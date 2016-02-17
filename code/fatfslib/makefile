ifneq (${MAKECMDGOALS}, clean)
ifneq (${MAKECMDGOALS}, rcsclean)
include ../makedefs
endif
endif

TARGET := \
	fatfslib

FILES := \
	dir.o \
	diskio.o \
	ff.o

HEADERS := \
	dir.h \
	diskio.h \
	ff.h \
	ffconf.h \
	integer.h

$(TARGET).a : $(FILES) 

$(FILES) : $(HEADERS)

dir.o : ../stdio.h

diskio.o : ../sd.h

clean:
	rm -f *.o
	rm -f *.a
	rm -f *.d

rcsclean: clean
	rcsclean *

rcsfetch: $(HEADERS) $(FILES:.o=.c) makefile

ifneq (${MAKECMDGOALS}, clean)
-include ${wildcard *.d} __dummy__
endif
