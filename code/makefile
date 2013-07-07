G++     := arm-none-eabi-g++.exe
GCC     := arm-none-eabi-g++.exe
LD      := arm-none-eabi-ld.exe
XXD     := xxd
OBJCOPY := arm-none-eabi-objcopy
PART    := LM3S9B92

TARGET  := console

BOOTFILE := diagnostics..dskda.sav
OPENOCD_CFG := ek-lm3s9b9x.cfg


CFLAGS := \
	-DPART_${PART} \
	-W -Wall \
	-mcpu=cortex-m3 \
	-mthumb \
	-Os \
	-g \
	-MD \
	-std=gnu++11 \
	-fno-rtti \
	-fcheck-new \
        -pedantic \
	-ffunction-sections \
	-fdata-sections \
	-fno-exceptions \
        -Wno-ctor-dtor-privacy \
	-Wno-non-virtual-dtor \
	-DTARGET_IS_TEMPEST_RB1 \
	-I..

LDFLAGS := \
	--script=$(TARGET).ld \
	--entry vectReset \
        --gc-sections \
	-Map $(TARGET).map

FILES := \
	console.o\
	commands.o \
	fpga.o \
	ks10.o \
	sd.o \
	startup.o \
	stdio.o \
	uart.o \

HEADERS := \
	commands.hpp \
	fpga.h \
	ks10.hpp\
	sd.h \
	stdio.h \
	uart.h \
	fatfs/dir.h \
	fatfs/diskio.h \
	fatfs/ff.h \
	fatfs/ffconf.h \
	fatfs/integer.h \

DRIVERLIB := \
	driverlib/driverlib.a

LIBFATFS := \
	fatfs/libfatfs.a

LIBS := \
	/usr/local/lib/gcc/arm-none-eabi/4.6.2/thumb/libgcc.a \
	/usr/local/arm-none-eabi/lib/thumb/libc.a \

$(TARGET).bin : $(TARGET).elf
	$(OBJCOPY) -O binary $< $@

$(TARGET).elf :$(TARGET).ld $(FILES) $(DRIVERLIB) $(LIBFATFS)
	make -C driverlib
	make -C fatfs
	$(LD) $(LDFLAGS) $(FILES) $(DRIVERLIB) $(LIBFATFS) $(LIBS) -o $(TARGET).elf

$(TARGET).o : $(TARGET).cpp $(HEADERS)
	$(GCC) $(CFLAGS) -c $< -o $@

.cpp.o : 
	$(GCC) $(CFLAGS) -c $< -o $@

.c.o : 
	$(GCC) $(CFLAGS) -std=c99 -c $< -o $@




$(DRIVERLIB) : 
	make -C driverlib

$(LIBFATFS) :
	make -C fatfs

load :  $(TARGET).bin $(OPENOCD_CFG)
	-openocd -f $(OPENOCD_CFG) -c "program_device ()"

reset : 
	-openocd -f $(OPENOCD_CFG) -c "reset" -c "shutdown"

clean:
	rcsclean *
	rm -f *.elf
	rm -f *.map
	rm -f *.bin
	rm -f *.o
	rm -f *.d
	rm -rf ../doc/Doxygen/*
	make -C driverlib clean
	make -C fatfs clean

archive_all:
	tar -czvf ks10_code_all_`date '+%y%m%d'`.tgz *

ifneq (${MAKECMDGOALS}, clean)
-include ${wildcard *.d} __dummy__
endif
