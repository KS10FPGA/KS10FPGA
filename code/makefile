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
	fpga.o \
	ks10.o \
	main.o\
	rh11.o \
	sd.o \
	startup.o \
	stdio.o \
	taskhalt.o \
	taskutil.o \
	uart.o 

HEADERS := \
	align.hpp \
	commands.hpp \
	console.hpp \
	dz11.hpp \
	epi.hpp \
	fatal.hpp \
	fpga.hpp \
	ks10.hpp\
	prompt.hpp \
	rh11.hpp \
	sd.h \
	stdio.h \
	taskhalt.hpp \
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
	make -C driverlib

$(FATFSLIB) : FORCE
	make -C fatfslib

$(LWIPLIB) : FORCE
	make -C lwiplib

$(TELNETLIB) : FORCE
	make -C telnetlib

$(USTDLIB) : FORCE
	make -C ustdlib

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
	make -C driverlib clean
	make -C fatfslib clean
	make -C lwiplib clean
	make -C telnetlib clean
	make -C ustdlib clean

rcsclean: clean
	rcsclean *
	make -C driverlib rcsclean
	make -C fatfslib rcsclean
	make -C lwiplib rcsclean
	make -C telnetlib rcsclean
	make -C ustdlib rcsclean

rcsfetch: $(HEADERS) $(FILES:.o=.cpp) $(OPENOCD_CFG) $(TARGET).ld makefile makedefs
	make -C driverlib rcsfetch
	make -C fatfslib rcsfetch
	make -C lwiplib rcsfetch
	make -C telnetlib rcsfetch
	make -C ustdlib rcsfetch

archive_all:
	tar -czvf ks10_code_all_`date '+%y%m%d'`.tgz *

archive_dist:
	make rcsfetch
	tar --exclude-vcs -czvf ks10_code_dist_`date '+%y%m%d'`.tgz *

ifneq (${MAKECMDGOALS}, clean)
-include ${wildcard *.d} __dummy__
endif
