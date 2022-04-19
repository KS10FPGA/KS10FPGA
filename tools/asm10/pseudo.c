
#include <stdlib.h>
#include "asm10.h"
#include "pseudo.h"


void set_addr(pop *p,
	      int l,
	      char *oline,
	      inst *inst)
{
  address = inst->y;
}

void set_start(pop *p,
	       int l,
	      char *oline,
	      inst *inst)
{
  start_address = inst->y;
}

void psop(pop *p,
	  int literal_mode,
	  char *oline,
	  inst *inst)
{
  word word;
  char *parsed = 0;

  word.lh = p->value | (inst->ac << 5) | (inst->i << 1) | inst->x;
  word.rh = inst->y & HALF_MASK;
  asprintf(&parsed, "%03o %02o %1o %02o %06o      ", p->value>>9, inst->ac, inst->i, inst->x, inst->y);
  write_word(&word, literal_mode, parsed, oline);
  if (parsed) free(parsed);
}

pop pseudo_ops[] = {
  { "LOC", &set_addr, 0 },
  { "START", &set_start, 0 },
  { "halt", &psop, 0254200 }
};


pop *pop_lookup(char *op)
{
  pop *p;

  for (p = &pseudo_ops[0]; p < &pseudo_ops[sizeof(pseudo_ops)/sizeof(pop)]; p++)
    if (strcasecmp(op, p->op) == 0)
      return p;
  return 0;
}
