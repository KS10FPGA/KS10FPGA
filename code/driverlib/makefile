include ../makedefs

TARGET := \
	driverlib

FILES := \
	epi.o \
	gpio.o \
	interrupt.o \
	ssi.o \
	sysctl.o \
	systick.o \
	uart.o 

HEADERS := \
	debug.h \
	epi.h \
	gpio.h \
	interrupt.h \
	pin_map.h \
	rom.h \
	ssi.h \
	sysctl.h \
	systick.h \
	uart.h

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
