
include ../makedefs

TARGET := \
	driverlib

FILES := \
	epi.o \
	ethernet.o \
	gpio.o \
	interrupt.o \
	ssi.o \
	sysctl.o \
	systick.o \
	uart.o 

HEADERS := \
	cpu.h \
	debug.h \
	epi.h \
	ethernet.h \
	gpio.h \
	interrupt.h \
	pin_map.h \
	rom.h \
	ssi.h \
	sysctl.h \
	systick.h \
	uart.h

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
