ifneq (${MAKECMDGOALS}, clean)
ifneq (${MAKECMDGOALS}, rcsclean)
include ../makedefs
endif
endif

TARGET := \
	telnetlib

FILES := \
	telnet.o \
	telnet_task.o

HEADERS := \
	telnet.hpp \
	telnet_task.hpp \

$(TARGET).a : $(FILES) 

$(FILES) : $(HEADERS)

clean:
	rm -f *.o
	rm -f *.a
	rm -f *.d

rcsclean: clean
	rcsclean *

rcsfetch: $(HEADERS) $(FILES:.o=.cpp) makefile

ifneq (${MAKECMDGOALS}, clean)
-include ${wildcard *.d} __dummy__
endif
