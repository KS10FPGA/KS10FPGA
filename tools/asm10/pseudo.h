
/* pseudo-op structure */
typedef struct pop {
  char *op;
  void (*func)(struct pop*, int, char*, inst*);
  halfword value;
} pop;

pop *pop_lookup(char *);
