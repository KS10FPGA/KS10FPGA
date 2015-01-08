include ../makedefs

TARGET := \
	telnetlib

FILES := \
	telnet.o \
	lwip_task.o

HEADERS := \
	telnet.h \
	lwip_task.h \

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
