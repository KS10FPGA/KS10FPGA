ifneq (${MAKECMDGOALS}, clean)
ifneq (${MAKECMDGOALS}, rcsclean)
include ../makedefs
endif
endif

TARGET := \
	lwiplib

FILES := \
	lwiplib.o 

HEADERS := \
	lwiplib.h \
	lwipopts.h

$(TARGET).a : $(FILES) 

$(FILES) : $(HEADERS)

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
