
all : red405a2.tap red405a2.rp06

red405a2.tap : red405a2.tap.bz2
	bunzip2 -c $< > $@

red405a2.rp06 : red405a2.rp06.gz
	gunzip -c $< > $@

red405a2.tap.bz2 :
	wget http://pdp-10.trailing-edge.com/tapes/red405a2.tap.bz2 red405a2.tap.bz2

clean :
	rm -f red405a2.rp06 red405a2.tap *~ .*~
