struct symbol {
  struct symbol *link;		/* a simple linked list, for the moment */
  char *name;
  halfword value;
};



void sym_init();
char *sym_new(char *name, halfword value);
halfword sym_lookup(char *name);
