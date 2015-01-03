TARGET  := console

OPENOCD_CFG := ks10.cfg

OPENOCD_EXE := /usr/local/openocd-0.8.0/bin/openocd-0.8.0.exe

LDFLAGS := \
	--script=$(TARGET).ld \
	--entry reset \
        --gc-sections \
	-Map $(TARGET).map

FILES := \
	console.o \
	commands.o \
	epi.o \
	fpga.o \
	ks10.o \
	main.o\
	sd.o \
	startup.o \
	stdio.o \
	uart.o 

HEADERS := \
	commands.hpp \
	console.hpp \
	epi.hpp \
	fpga.hpp \
	ks10.hpp\
	sd.h \
	stdio.h \
	uart.h \
	fatfs/dir.h \
	fatfs/diskio.h \
	fatfs/ff.h \
	fatfs/ffconf.h \
	fatfs/integer.h \
	driverlib/cpu.h \
	driverlib/epi.h \
	driverlib/debug.h \
	driverlib/gpio.h \
	driverlib/interrupt.h \
	driverlib/pin_map.h \
	driverlib/rom.h \
	driverlib/ssi.h \
	driverlib/sysctl.h \
	driverlib/systick.h \
	driverlib/timer.h \
	driverlib/uart.h

DRIVERLIB := \
	driverlib/driverlib.a

LIBFATFS := \
	fatfs/libfatfs.a

include makedefs

$(TARGET).bin : $(TARGET).elf
	$(OBJCOPY) -O binary $< $@
	make -C driverlib
	make -C fatfs

$(TARGET).elf : $(TARGET).ld $(FILES) $(DRIVERLIB) $(LIBFATFS)
	$(LD) $(LDFLAGS) $(FILES) $(DRIVERLIB) $(LIBFATFS) $(LIBGCC) $(LIBC) -o $(TARGET).elf

$(TARGET).o : $(TARGET).cpp $(HEADERS)

$(DRIVERLIB) : 
	make -C driverlib

$(LIBFATFS) :
	make -C fatfs

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
	make -C fatfs clean

rcsclean: clean
	rcsclean *
	make -C driverlib rcsclean
	make -C fatfs rcsclean

rcsfetch: $(HEADERS) $(FILES:.o=.cpp) $(OPENOCD_CFG) $(TARGET).ld makefile makedefs
	make -C driverlib rcsfetch
	make -C fatfs rcsfetch

archive_all:
	tar -czvf ks10_code_all_`date '+%y%m%d'`.tgz *

archive_dist:
	make rcsfetch
	tar --exclude-vcs -czvf ks10_code_dist_`date '+%y%m%d'`.tgz *

ifneq (${MAKECMDGOALS}, clean)
-include ${wildcard *.d} __dummy__
endif
