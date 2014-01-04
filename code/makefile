TARGET  := console

OPENOCD_CFG := ks10.cfg

LDFLAGS := \
	--script=$(TARGET).ld \
	--entry reset \
        --gc-sections \
	-Map $(TARGET).map

FILES := \
	console.o\
	commands.o \
	epi.o \
	fpga.o \
	ks10.o \
	sd.o \
	startup.o \
	stdio.o \
	sysclk.o \
	uart.o \

HEADERS := \
	commands.hpp \
	epi.h \
	fpga.h \
	ks10.hpp\
	sd.h \
	stdio.h \
	sysclk.hpp \
	timer.hpp \
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
	driverlib/uart.h \

DRIVERLIB := \
	driverlib/driverlib.a

LIBFATFS := \
	fatfs/libfatfs.a

include makedefs

$(TARGET).bin : $(TARGET).elf
	$(OBJCOPY) -O binary $< $@

$(TARGET).elf :$(TARGET).ld $(FILES) $(DRIVERLIB) $(LIBFATFS)
	make -C driverlib
	make -C fatfs
	$(LD) $(LDFLAGS) $(FILES) $(DRIVERLIB) $(LIBFATFS) $(LIBGCC) $(LIBC) -o $(TARGET).elf

$(TARGET).o : $(TARGET).cpp $(HEADERS)

$(DRIVERLIB) : 
	make -C driverlib

$(LIBFATFS) :
	make -C fatfs

#
# Program the flash in the target
#

load : $(TARGET).bin $(OPENOCD_CFG)
	-openocd -f $(OPENOCD_CFG) -c "program_device ()"

#
# Reset the target from the JTAG port
#

reset : $(OPENOCD_CFG)
	-openocd -f $(OPENOCD_CFG) -c "reset" -c "shutdown"

clean :
	rm -f *.elf
	rm -f *.map
	rm -f *.bin
	rm -f *.o
	rm -f *.d
	rm -rf ../doc/Doxygen/*
	make -C driverlib clean
	make -C fatfs clean

rcsclean : clean
	rcsclean *
	make -C driverlib rcsclean
	make -C fatfs rcsclean

archive_all :
	tar -czvf ks10_code_all_`date '+%y%m%d'`.tgz *

ifneq (${MAKECMDGOALS}, clean)
-include ${wildcard *.d} __dummy__
endif
