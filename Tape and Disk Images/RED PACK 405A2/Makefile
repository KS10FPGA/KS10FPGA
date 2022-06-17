#
# Copyright 2022 Rob Doyle
# SPDX-License-Identifier: GPL-2.0
#

all : red405a2.tap red405a2.rp06

red405a2.tap : red405a2.tap.bz2
	bzcat $< > $@

red405a2.rp06 : red405a2.rp06.gz
	zcat $< > $@

red405a2.tap.bz2 :
	wget http://pdp-10.trailing-edge.com/tapes/red405a2.tap.bz2 red405a2.tap.bz2

clean :
	rm -f red405a2.rp06 red405a2.tap *~ .*~
