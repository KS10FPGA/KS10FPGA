include ../makedefs

TARGET := \
	libfatfs

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

$(TARGET).a: $(FILES) $(HEADERS)

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
