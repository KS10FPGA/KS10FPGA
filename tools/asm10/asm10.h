
typedef unsigned long halfword;	/* needs at least 18 bits */
typedef long long fullword;

typedef struct {
  halfword lh, rh;
} word;

#define HALF_MASK 0777777

typedef struct {
  halfword op : 9;
  halfword ac : 4;
  halfword i  : 1;
  halfword x  : 4;
  halfword y  : 18;
} inst;

typedef enum {
  eol, name, label, num, comma, cc, opcode,
  open, close, at, literalopen, literalclose, plus, minus
} ttype;

typedef struct {
  ttype type;
  char *token;
  fullword value;
  unsigned char free;
  unsigned int position;
} token;

extern halfword start_address;
extern halfword address;
