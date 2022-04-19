/* My own version of ctype */

#  define _ISbit(bit)	(1 << (bit))

enum
{
  _ISblank = _ISbit(0),		/* whitespace */
  _IStoken = _ISbit(1),		/* characters that make up names */
  _ISdigit = _ISbit(2),		/* digits */
  _ISoctal = _ISbit(3),		/* digits in octal numbers */
  _ISeol = _ISbit(4),		/* end of line indicator */
};

extern char ctype[256];

#define isblank(c) (ctype[c] & _ISblank)
#define istoken(c) (ctype[c] & _IStoken)
#define isdigit(c) (ctype[c] & _ISdigit)
#define isoctal(c) (ctype[c] & _ISoctal)
#define iseol(c) (ctype[c] & _ISeol)
