CFLAGS = -g

FILES = asm10.o opcodes.o ctype-asm.o sym.o opcodes.o pseudo.o

asm10: $(FILES)

asm10.o: asm10.h

ctype-asm.o: ctype-asm.h

sym.o: sym.h

opcodes.o: opcodes.h

pseudo.o: pseudo.h

#install: asm10
#	cp asm10 ~/bin/

test: asm10
	./asm10 test.asm

clean:
	rm -f $(FILES)
	rm -f asm10.exe