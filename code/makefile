G++     := arm-none-eabi-g++.exe
GCC     := arm-none-eabi-gcc-4.7.2.exe
LD      := arm-none-eabi-ld.exe
OBJCOPY := arm-none-eabi-objcopy

TARGET := hello

CFLAGS := \
	-W -Wall \
	-mcpu=cortex-m3 \
	-mthumb \
	-Os \
	-MD \
	-std=gnu++11 \
	-fno-rtti \
	-fcheck-new \
        -pedantic \
	-ffunction-sections \
	-fdata-sections \
	-fno-exceptions \
        -Wno-ctor-dtor-privacy \
	-Wno-non-virtual-dtor 

LDFLAGS := \
	--script=$(TARGET).ld \
	--entry vectReset \
        --gc-sections \
	-Map $(TARGET).map

##.c.o :
#	$(GCC) $(CFLAGS) -c $<

#.cpp.o :
#	$(GPP) $(CFLAGS) -c $<

hello.bin : hello.axf
	$(OBJCOPY) -O binary hello.axf hello.bin

hello.axf : hello.o startup.o
	$(LD) $(LDFLAGS) hello.o startup.o -o hello.axf

hello.o : hello.cpp drivers/epi.hpp drivers/gpio.hpp drivers/sysctl.hpp drivers/uart.hpp drivers/memmap.hpp
	$(GCC) $(CFLAGS) -c hello.cpp -o hello.o

startup.o : startup.cpp
	$(GCC) $(CFLAGS) -c startup.cpp -o startup.o

#ks10boot.cpp : ks10boot.sav ks10boot.awk makefile
#	od -Ad -t u1 < ks10boot.sav | gawk -f ks10boot.awk > ks10boot.cpp

#boot.elf : startup.o console.o ks10boot.o boot.o
#	$(LD) $(LDFLAGS) startup.o console.o ks10boot.o boot.o driverlib/gcc-cm3/libdriver-cm3.a -o $(TARGET).elf

#archive_all:
#	tar -czvf ks10_code_all_`date '+%y%m%d'`.tgz *
