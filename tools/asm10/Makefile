GCC    = gcc
CFLAGS = -g -O3 -W -Wall -Wno-char-subscripts

CFILES = asm10.c ctype-asm.c opcodes.c pseudo.c sym.c
HFILES = asm10.h ctype-asm.h opcodes.h pseudo.h sym.h

asm10 :
	$(GCC) $(CFLAGS) $(CFILES) -DKS10 -o asm10

test : asm10
	./asm10 test.asm > test.lst
	./asm10 mtboot.asm > mtboot.lst
	./asm10 dup11.asm > dup11.lst

clean :
	rm -f *~ .*~
	rm -f $(FILES)
	rm -f asm10.exe asm10 *.out *.lst
