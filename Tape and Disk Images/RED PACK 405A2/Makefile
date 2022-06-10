
all : red405a2.tap red405a2.rp06

red405a2.tap : red405a2.tap.gz
	gunzip -c red405a2.tap.gz > red405a2.tap 

red405a2.rp06 : red405a2.rp06.gz
	gunzip -c red405a2.rp06.gz > red405a2.rp06

clean :
	rm -f red405a2.rp06 red405a2.tap *~ .*~
