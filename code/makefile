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
	dz11.o \
	epi.o \
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
	dz11.hpp \
	epi.hpp \
	fatal.hpp \
	ks10.hpp\
	new.hpp \
	prompt.hpp \
	rh11.hpp \
	sd.h \
	stdio.h \
	taskutil.hpp \
	uart.h \
	uba.hpp

DRIVERLIB := \
	driverlib/driverlib.a

FATFSLIB := \
	fatfslib/fatfslib.a

LWIPLIB := \
	lwiplib/lwiplib.a

TELNETLIB := \
	telnetlib/telnetlib.a

USTDLIB := \
	ustdlib/ustdlib.a

$(TARGET).bin : $(TARGET).elf
	$(OBJCOPY) -O binary $< $@

$(TARGET).elf : $(TARGET).ld $(DRIVERLIB) $(USTDLIB) $(FATFSLIB) $(LWIPLIB) $(TELNETLIB) $(FILES)
	$(LD) $(LDFLAGS) $(FILES) --start-group $(DRIVERLIB) $(FATFSLIB) $(LWIPLIB) $(TELNETLIB) $(USTDLIB) --end-group $(LIBGCC) $(LIBC) -o $(TARGET).elf

$(TARGET).o : $(TARGET).cpp $(HEADERS)

$(DRIVERLIB) : FORCE
	${MAKE} -C driverlib

$(FATFSLIB) : FORCE
	${MAKE} -C fatfslib

$(LWIPLIB) : FORCE
	${MAKE} -C lwiplib

$(TELNETLIB) : FORCE
	${MAKE} -C telnetlib

$(USTDLIB) : FORCE
	${MAKE} -C ustdlib

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
	${MAKE} -C driverlib clean
	${MAKE} -C fatfslib clean
	${MAKE} -C lwiplib clean
	${MAKE} -C telnetlib clean
	${MAKE} -C ustdlib clean

rcsclean: clean
	rcsclean *
	${MAKE} -C driverlib rcsclean
	${MAKE} -C fatfslib rcsclean
	${MAKE} -C lwiplib rcsclean
	${MAKE} -C telnetlib rcsclean
	${MAKE} -C ustdlib rcsclean

rcsfetch: $(HEADERS) $(FILES:.o=.cpp) $(OPENOCD_CFG) $(TARGET).ld makefile makedefs
	${MAKE} -C driverlib rcsfetch
	${MAKE} -C fatfslib rcsfetch
	${MAKE} -C lwiplib rcsfetch
	${MAKE} -C telnetlib rcsfetch
	${MAKE} -C ustdlib rcsfetch

archive_all:
	tar -czvf ks10_code_all_`date '+%y%m%d'`.tgz *

archive_dist:
	${MAKE} rcsfetch
	tar --exclude-vcs -czvf ks10_code_dist_`date '+%y%m%d'`.tgz *

doxygen : Doxyfile
	doxygen.exe

check :
	@echo "Tabs in:"
	@-find . -type f | grep -v RCS | grep -e '\.cpp$$' -e '\.hpp$$' | xargs grep -P '\t'
	@echo "Trailing white space in:"
	@-find . -type f | grep -v RCS | grep -e '\.cpp$$' -e '\.hpp$$' | xargs grep -P '[ ]+$$'
	@echo "FIXMEs in:"
	@-find . -type f | grep -v RCS | grep -e '\.cpp$$' -e '\.hpp$$' | xargs grep -i 'fixme'


ifneq (${MAKECMDGOALS}, clean)
-include ${wildcard *.d} __dummy__
endif
