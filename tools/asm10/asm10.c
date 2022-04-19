/* A simple PDP-10 Assembler.  Just enough so I could write some
 * simple programs for testing purposes.
 *
 * Written 2011 by David Bridgham
 * Modified 2017 by Rob Doyle
 *   Allowed # to be comment charcter to be compatible with CPP
 *
 */

#include <stdlib.h>
#include <stdio.h>
#include <stdarg.h>
#include <errno.h>
#include <string.h>
#include <strings.h>

#include "ctype-asm.h"
#include "asm10.h"
#include "sym.h"
#include "pseudo.h"

/* These globals could all go into a state structure but it's just as
 * easy this way */
int pass = 1;			/* assembler pass */
int seen_error = 0;
char *in_file_name;
FILE *ofile = 0;
unsigned int line_number = 0;
unsigned int char_column = 0;
halfword address = 0100;
halfword start_address = 0100;
halfword max_address = 0100;
halfword literal_address = 0;

void parse_error(token *t, const char *format, ...)
{
  va_list ap;

  seen_error = 1;
  va_start(ap, format);
  fprintf(stderr, "%s:%u:%u: ", in_file_name, line_number, t->position);
  vfprintf(stderr, format, ap);
  va_end(ap);
}

void operand_parse_error(token *t)
{
  parse_error(t, "Unexpected token '%s' in operand\n", t->token ? t->token : "");
}

void token_free(token *t)
{
  if (t->free && t->token)
    free(t->token);
}

/* returns the token, * updates *line to after the parsed out token */
token get_token(char **line)
{
  char *start, *end;
  token t = {0, 0, 0, 0, 0};

  /* skip leading whitespace */
  for (start = *line; !iseol(*start); start++, char_column++)
    if (!isblank(*start))
      break;
  /* who on earth thought it was a good idea for the character
     position in error messages to be a column and not just a simple
     count of characters? */
    else if (*start == '\t')
      char_column += 8 - char_column % 8;
  t.position = char_column;

  if (iseol(*start)) {
    t.token = "<newline>";
    t.type = eol;
    return t;
  }
  else if (*start == '#') { end = start+1; t.token = "#"; t.type = eol; }
  else if (*start == ';') { end = start+1; t.token = ";"; t.type = eol; }
  else if (*start == '+') { end = start+1; t.token = "+"; t.type = plus; }
  else if (*start == '-') { end = start+1; t.token = "-"; t.type = minus; }
  else if (*start == '@') { end = start+1; t.token = "@"; t.type = at; }
  else if (*start == '(') { end = start+1; t.token = "("; t.type = open; }
  else if (*start == ')') { end = start+1; t.token = ")"; t.type = close; }
  else if (*start == '[') { end = start+1; t.token = "["; t.type = literalopen; }
  else if (*start == ']') { end = start+1; t.token = "]"; t.type = literalclose; }
  else if (*start == ',') {
      if (*(start+1) == ',') {
          end = start+2; t.token = ",,"; t.type = cc;
      } else {
          end = start+1; t.token = ","; t.type = comma;
      }
  }

  /* number has to come before token since digits may be in tokens,
   * just not the first character */
  else if (isdigit(*start)) {
    for (end = start+1; isdigit(*end); end++)
      ;
    t.token = strndup(start, end-start);
    t.free = 1;
    t.type = num;
    if (*end == '.') {
      t.value = strtoll(t.token, 0, 10);
      end++;
    } else {
      t.value = strtoll(t.token, 0, 8);
    }
  } else if (istoken(*start)) {
    for (end = start+1; istoken(*end); end++)
      ;
    t.token = strndup(start, end-start);
    t.free = 1;
    if (*end == ':') {
      end++;
      t.type = label;
    } else if ((t.value = opcode_lookup(t.token)) != -1) {
      t.type = opcode;
    } else {
      t.type = name;
    }
  }
  else {
    parse_error(&t, "Illegal character \%o\n", *start);
    t.token = "<\?\?>";
    t.type = eol;
  }

  char_column += end - start;
  *line = end;
  return t;
}


/* Eventually this routine will understand all the different output
   formats I want to support.  Address is incremented here.  */
void write_word(word *word,
		int literal_mode,
		char *pstring,
		char *oline)
{
  if (pass == 2)
    fprintf(ofile, "%06o\t%06o %06o  %s %s",
	    (literal_mode ? literal_address : address)&HALF_MASK,
	    word->lh&HALF_MASK, word->rh&HALF_MASK,
	    pstring ? pstring : "", oline ? oline : "\n");
  if (literal_mode)
    literal_address++;
  else {
    if (++address > max_address)
      max_address = address;
  }
}

void write_finish()
{
  if (pass == 2)
    fprintf(ofile, "\n777777\t000000 %06o\n", start_address);
}


/* parse a single instruction, ie after any label
   a line's grammar, I don't think this is context-free
    line = ["label"] instr
    instr = expr [ ",,"  expr ]
            | "opname" [ operand ]
    operand = [ expr "," ] Y
    Y = ["@"] [ expr ] ["(" expr ")"]
        | "[" instr "]"
    expr = number { ( "+" | "-" ) number }
    number = [ "+" | "-" ]  "octal" | "decimal" | "name"
*/
#define push(s) stack[sp++] = s
#define pop()   state = stack[--sp]; if (sp < 0) { fprintf(stderr, "parse stack underflow\n"); goto done; }
#define next_token() token_free(&t); t = get_token(line);
void parse_inst(char **line,
		char *oline,
		token t,
		int literal_mode)
{
  enum state { instr, instr1, psop,
	       xx, xxyy, worddone,
	       operand, operand1,
	       y, y1, yindex,
	       expr, expr1, exprplus, exprminus,
	       number, numberminus, done } state;
  enum state stack[10];
  int sp = 0;
  word word = {0,0};
  fullword e, e2;		/* "return" value from expr */
  inst inst = { 0, 0, 0, 0, 0};
  char *parsed = 0;
  char *tline;
  pop *pop;

  push(done);
  state = instr;
  while (1) {
    switch (state) {
    case instr:
      if (t.type == eol) goto done;
      else if (t.type == opcode) {
	inst.op = t.value;
	push(instr1); state = operand;
	break;
      } else if ((t.type == name) && ((pop = pop_lookup(t.token)) != 0)) {
	push(psop); state = operand;
	break;
      } else  { push(xx); state = expr; continue; }
      break;
    case instr1:
      word.lh = (inst.op << 9) | (inst.ac << 5) | (inst.i << 4) | inst.x;
      word.rh = inst.y & HALF_MASK;
      asprintf(&parsed, "%03o %02o %1o %02o %06o      ", inst.op, inst.ac, inst.i, inst.x, inst.y);
      write_word(&word, literal_mode, parsed, oline);
      if (parsed) free(parsed);
      state = done;
      continue;
    case psop:
      pop->func(pop, literal_mode, oline, &inst);
      state = done;
      continue;

    case xx:
      if (t.type == cc) {	/* then we're reading xx,,yy */
	word.lh = e;
	push(xxyy); state = expr;
      } else if ((t.type == eol) || (literal_mode && (t.type == literalclose))) { /* then we've read xx */
	word.rh = e;
	word.lh = e >> 18;
	asprintf(&parsed, "%15lld.       ", e);
	write_word(&word, literal_mode, parsed, oline);
	if (parsed) free(parsed);
	state = done;
	continue;
      } else {			/* if there's more, assume the number or symbol is an opcode and get operand */
	inst.op = e;
	push(instr1); state = operand;
	continue;
      }
      break;
    case xxyy:
      word.rh = e;
      state = worddone;
      continue;
    case worddone:
      asprintf(&parsed, "%6o,,%-6o          ", word.lh&HALF_MASK, word.rh&HALF_MASK);
      write_word(&word, literal_mode, parsed, oline);
      if (parsed) free(parsed);
      state = done;
      continue;

    case operand:
      switch (t.type) {
      case literalclose:
      case eol:  	pop(); continue;
      case plus:
      case minus:
      case name:
      case num:
	push(operand1); state = expr;
	continue;
      default:
	state = y;
	continue;
      }
      break;
    case operand1:
      if (t.type == comma) {
	inst.ac = e;
	state = y;
      } else {
	state = y1;		/* here's where we're not context-free, jump into the middle of y processing */
	continue;
      }
      break;

    case y:
      switch (t.type) {
      case at:		inst.i = 1; break;
      case open:	push(yindex); state = expr; break;
      case literalopen:
	inst.y = literal_address;
	pop();
	tline = *line;
	next_token();
	parse_inst(line, tline, t, literal_mode+1);
	t = get_token(line);	/* don't free_token(&t) here because parse_line did it */
	continue;
      case name:
      case num:
      case plus:
      case minus:	push(y1); state = expr; continue;
      default:		parse_error(&t, "Unexpected token '%s'\n", t.token); goto done;
      }
      break;
    case y1:
      inst.y = e;
      if (t.type == open) {
	push(yindex); state = expr;
	break;
      } else {
	pop();
	continue;
      }
      break;
    case yindex:
      inst.x = e;
      pop();
      if (t.type != close)
	parse_error(&t, "Expected close paren, not '%s'\n", t.token);
      break;

    case expr:
      push(expr1); state = number; continue;
    case expr1:
      if (t.type == plus) { e2 = e; push(exprplus); state = number; }
      else if (t.type == minus) { e2 = e; push(exprminus); state = number; }
      else { pop(); continue; }
      break;
    case exprplus: e = e2 + e; pop(); continue;
    case exprminus: e = e2 - e; pop(); continue;

    case number:
      switch (t.type) {
      case plus:     break;
      case minus:    push(numberminus); break;
      case num:      e = t.value; pop(); break;
      case name:
	if ((pass == 2) &&
	    ((e = sym_lookup(t.token)) == -1))
	  parse_error(&t, "Unknown symbol '%s'\n", t.token);
	pop();
	break;
      default:       parse_error(&t, "Expected a number or symbol, not '%s'\n", t.token); goto done;
      }
      break;
    case numberminus:
      e = -e; pop();
      continue;

    case done:
      if (literal_mode) {
	if (t.type != literalclose)
	  parse_error(&t, "Expected ']' for end of literal, found '%s'\n", t.token);
      } else if (t.type != eol) {
#if 0
	parse_error(&t, "Unexpected token '%s', thought was all done\n", t.token);
#else
        state = instr;
        continue;
#endif
      }
      goto done;
    }
    next_token();
  }

 done:
  return;
}

/* Parse a single line of the input file. */
void parse_line(char *line)
{
  token t;
  char *err;
  char *oline;

  oline = line;
  t = get_token(&line);

#define BOB_WAS_HERE
#ifdef BOB_WAS_HERE  
  if ((pass == 2) && (t.type == eol) && t.token[0] == ';') {
      printf("\t;%s", line);
  } else
#endif

  if (t.type == label) {
    if ((pass == 1) && ((err = sym_new(t.token, address)) != 0))
      parse_error(&t, "%s '%s'\n", err, t.token);
    token_free(&t);
    t = get_token(&line);
  }
  parse_inst(&line, oline, t, 0);
}


/* It's a simple, two-pass assembler.  The first pass parses the
 * input, generating a symbol table.  The second pass parses the input
 * again, using the symbol table and generating output. */
void asm10_pass(char *ifile_name,
		FILE *ifile)
{
  size_t n = 100;		/* arbitrary line length */
  char *line;

  line = malloc(n);		/* getline will realloc this if needed */
  if (line == NULL) {
    fprintf(stderr, "Out of memory in pass one for %s\n", ifile_name);
    return;
  }

  /* this initialization needs to be re-done before the second pass */
  line_number = 0;
  address = 0100;
  in_file_name = ifile_name;

  while (getline(&line, &n, ifile) != -1) {
    line_number++;
    char_column = 0;
    parse_line(line);
  }

  free(line);
}

static const char * usage =
"Usage: %s [options] file1.asm [file2.asm ...]\n\
  Options:\n\
    -1            only run first pass\n\
    -o filename   output to filename\n";

int main(int argc, char ** argv) {
    char *input_file_name;
    FILE *ifile;
    int pass1_only = 0;

    sym_init();
    ofile = stdout;
    ifile = stdin;

    if (argc <= 1) {
        fprintf(stderr, usage, argv[0]);
        exit(1);
    }

    while (--argc) {
        argv++;

        if (strcmp(*argv, "-o") == 0) {
            if (argc == 1) {
                fprintf(stderr, "-o argument without a filename\n");
                exit (1);
            } else {
                if (ofile)
                    fclose(ofile);
                if ((ofile = fopen(argv[1], "w")) == NULL) {
                    fprintf(stderr, "Unable to open output file: %s\n", argv[1]);
                    perror(0);
                    exit(1);
                }
                argc--; argv++;
            }
        } else if (strcmp(*argv, "-1") == 0) {
            pass1_only = 1;

        } else {
            input_file_name = argv[0];

            ifile = fopen(input_file_name, "r");
            if (ifile == NULL) {
                fprintf(stderr, "Unable to open input file: %s\n", input_file_name);
                perror(0);
            } else {
                sym_init();

                pass = 1;
                asm10_pass(input_file_name, ifile);

                start_address = max_address-1;
                literal_address = max_address;

                if (!seen_error && !pass1_only) {
                    rewind(ifile);
                    pass = 2;
                    asm10_pass(input_file_name, ifile);
                }

                fclose(ifile);
            }
        }
    }

    write_finish();

    if ((ofile) && (ofile != stdout))
        fclose(ofile);

    return seen_error;
}
