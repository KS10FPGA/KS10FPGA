GCC     := arm-none-eabi-gcc.exe
AR      := arm-none-eabi-ar.exe
PART    := LM3S9B92

TARGET  := libfatfs

CFLAGS := \
	-DPART_${PART} \
	-W -Wall \
	-mcpu=cortex-m3 \
	-mthumb \
	-Os \
	-g \
	-std=c99 \
        -pedantic \
	-ffunction-sections \
	-fdata-sections \
	-DTARGET_IS_TEMPEST_RB1 \
	-I ..

FILES := \
	dir.o \
	diskio.o \
	ff.o

HEADERS := \
	dir.h \
	diskio.h \
	ff.h \
	ffconf.h \
	integer.h

$(TARGET).a : $(FILES)
	$(AR) -cr $(TARGET).a $(FILES) 

.c.o :
	$(GCC) $(CFLAGS) -c $< -o $@

.cpp.o : 
	$(GCC) $(CFLAGS) -c $< -o $@

clean:
	rcsclean *
	rm -f *.o
	rm -f *.a
