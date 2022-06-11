#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "asm10.h"
#include "sym.h"

static struct symbol *symbol_table;


void sym_init()
{
  symbol_table = 0;
}

/* Creates a new symbol and adds it to the symbol table. Returns an error message or NULL. */
char *sym_new(char *name,
	      halfword value)
{
  struct symbol *sym;

  if (sym_lookup(name) == (halfword)-1) {
    if ((sym = malloc(sizeof(struct symbol))) == 0) {
      fprintf(stderr, "Out of memory allocating symbol '%s'\n", name);
      exit(1);
    }

    sym->name = strdup(name);
    sym->value = value;
    sym->link = symbol_table;
    symbol_table = sym;

    return 0;
  }
  else
    return "Duplicate symbol";
}

/* Looks up a symbol in the symbol table */
halfword sym_lookup(char *name)
{
  struct symbol *sym;

  /* special case 'dot' */
  if (strcmp(name, ".") == 0)
    return address;

  for (sym = symbol_table; sym; sym = sym->link) {
    if (strcmp(name, sym->name) == 0)
      return sym->value;
  }
  return (halfword)-1;
}
