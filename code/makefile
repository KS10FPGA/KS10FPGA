#******************************************************************************
#
# KS10 Console Microcontroller
#
# Brief
#    Console MCU Build rules
#
# File
#    makefile
#
# Author
#    Rob Doyle - doyle (at) cox (dot) net
#
#******************************************************************************
#
# Copyright (C) 2013-2016 Rob Doyle
#
# This file is part of the KS10 FPGA Project
#
# The KS10 FPGA project is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option) any
# later version.
#
# The KS10 FPGA project is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
# more details.
#
# You should have received a copy of the GNU General Public License along with
# this software.  If not, see <http://www.gnu.org/licenses/>.
#
#******************************************************************************

include makedefs

TARGET  := console

OPENOCD_CFG := ks10.cfg

OPENOCD_EXE := /usr/local/openocd-0.8.0/bin/openocd-0.8.0.exe

LDFLAGS := \
	--script=$(TARGET).ld \
	--entry reset \
        --gc-sections \
	-rpath asdf \
	-Map $(TARGET).map

FILES := \
	console.o \
	commands.o \
	dasm.o \
	dz11.o \
	epi.o \
	fpga.o \
	ks10.o \
	main.o\
	new.o \
	rh11.o \
	sd.o \
	startup.o \
	stdio.o \
	taskutil.o \
	uart.o 

HEADERS := \
	align.hpp \
	commands.hpp \
	console.hpp \
	dasm.hpp \
	dz11.hpp \
	debug.hpp \
	epi.hpp \
	fatal.hpp \
	fpga.hpp \
	ks10.hpp\
	new.hpp \
	prompt.hpp \
	rh11.hpp \
	sd.h \
	stdio.h \
	taskutil.hpp \
	vt100.hpp \
	uart.h \
	uba.hpp

DRIVERLIB := \
	driverlib/driverlib.a

FATFSLIB := \
	fatfslib/fatfslib.a

LWIPLIB := \
	lwiplib/lwiplib.a

CMDLINELIB := \
	cmdlinelib/cmdlinelib.a

TELNETLIB := \
	telnetlib/telnetlib.a

$(TARGET).bin : $(TARGET).elf
	$(OBJCOPY) -O binary $< $@

$(TARGET).elf : $(TARGET).ld $(DRIVERLIB) $(FATFSLIB) $(LWIPLIB) $(TELNETLIB) $(CMDLINELIB) $(FILES)
	$(LD) $(LDFLAGS) $(FILES) --start-group $(DRIVERLIB) $(FATFSLIB) $(LWIPLIB) $(TELNETLIB) $(CMDLINELIB) --end-group $(LIBGCC) $(LIBC) -o $(TARGET).elf

$(TARGET).o : $(TARGET).cpp $(HEADERS)

$(CMDLINELIB) : FORCE
	${MAKE} -C cmdlinelib

$(DRIVERLIB) : FORCE
	${MAKE} -C driverlib

$(FATFSLIB) : FORCE
	${MAKE} -C fatfslib

$(LWIPLIB) : FORCE
	${MAKE} -C lwiplib

$(TELNETLIB) : FORCE
	${MAKE} -C telnetlib

FORCE:

#
# Program the flash in the target
#

load: $(TARGET).bin $(OPENOCD_CFG)
	-$(OPENOCD_EXE) -f $(OPENOCD_CFG) -c "program_device ()"

#
# Reset the target from the JTAG port
#

reset: $(OPENOCD_CFG)
	-$(OPENOCD_EXE) -f $(OPENOCD_CFG) -c "reset" -c "shutdown"

clean:
	rm -f *.elf
	rm -f *.map
	rm -f *.bin
	rm -f *.o
	rm -f *.d
	rm -rf ../doc/Doxygen/*
	${MAKE} -C cmdlinelib clean
	${MAKE} -C driverlib clean
	${MAKE} -C fatfslib clean
	${MAKE} -C lwiplib clean
	${MAKE} -C telnetlib clean

rcsclean: clean
	rcsclean *
	${MAKE} -C cmdlinelib rcsclean
	${MAKE} -C driverlib rcsclean
	${MAKE} -C fatfslib rcsclean
	${MAKE} -C lwiplib rcsclean
	${MAKE} -C telnetlib rcsclean

rcsfetch: $(HEADERS) $(FILES:.o=.cpp) $(OPENOCD_CFG) $(TARGET).ld makefile makedefs
	${MAKE} -C cmdlinelib rcsfetch
	${MAKE} -C driverlib rcsfetch
	${MAKE} -C fatfslib rcsfetch
	${MAKE} -C lwiplib rcsfetch
	${MAKE} -C telnetlib rcsfetch

archive_all:
	tar -czvf ks10_code_all_`date '+%y%m%d'`.tgz *

archive_dist:
	${MAKE} rcsfetch
	tar --exclude-vcs -czvf ks10_code_dist_`date '+%y%m%d'`.tgz *

doxygen : Doxyfile
	doxygen.exe

EXCLUDE := \
	-e RCS \
	-e fatfslib \
	-e lwiplib \
	-e driverlib

FILTYPES := \

check :
	@echo "Tabs in:"
	@-find . -type f | grep -v $(EXCLUDE) | grep -e '\.cpp$$' -e '\.hpp$$' -e '\.c$$' -e '\.h$$' -e '\.s$$' | xargs grep -P '\t'
	@echo "Trailing white space in:"
	@-find . -type f | grep -v $(EXCLUDE) | grep -e '\.cpp$$' -e '\.hpp$$' -e '\.c$$' -e '\.h$$' -e '\.s$$' | xargs grep -P '[ ]+$$'
	@echo "FIXMEs in:"
	@-find . -type f | grep -v $(EXCLUDE) | grep -e '\.cpp$$' -e '\.hpp$$' -e '\.c$$' -e '\.h$$' -e '\.s$$' | xargs grep -i 'fixme'


ifneq (${MAKECMDGOALS}, clean)
-include ${wildcard *.d} __dummy__
endif
