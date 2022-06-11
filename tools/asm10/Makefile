CFLAGS = -g -O3 -W -Wall -Wno-char-subscripts

CFILES = asm10.c ctype-asm.c opcodes.c pseudo.c sym.c
HFILES = asm10.h ctype-asm.h opcodes.h pseudo.h sym.h

asm10 :
	$(CC) $(CFLAGS) $(CFILES) -DKS10 -o asm10

test : asm10
	./asm10 test.asm
	./asm10 mtboot.asm -o mtboot.lst

clean :
	rm -f *~ .*~
	rm -f $(FILES)
	rm -f asm10.exe asm10 *.out *.lst
