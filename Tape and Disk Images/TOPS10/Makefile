#
# Copyright 2022 Rob Doyle
# SPDX-License-Identifier: GPL-2.0
#

#
# Extract everything from the tape archive
#

all : tops10-1.4.tar.bz2
	tar -jxvf tops10-1.4.tar.bz2

#
# DSKB
#  I've renamed the disk image from dskb.dsk to dskb.rp06 - so the the disk type is known.
#  The KS10 FPGA (like the DEC KS10) doesn't autosize disks like SIMH. Size matters.
#

dskb.rp06 : tops10-1.4.tar.bz2
	tar -jxvf tops10-1.4.tar.bz2 dskb.dsk -O > dskb.rp06

#
# DSKC
#  I've renamed the disk image from dskc.dsk to dskc.rp06 - so the the disk type is known.
#  The KS10 FPGA (like the DEC KS10) doesn't autosize disks like SIMH. Size matters.
#

dskc.rp06 : tops10-1.4.tar.bz2
	tar -jxvf tops10-1.4.tar.bz2 dskc.dsk -O > dskc.rp06

#
# TAR File
#  Download from the internet
#  I don't trust that this will be persistent.
#

tops10-1.4.tar.bz2 :
	wget https://www.steubentech.com/~talon/pdp10/tops10-1.4.tar.bz2 tops10-1.4.tar.bz2

#
# Clean everything up
#

clean :
	rm -f *~ .*~
	rm -f BB-D480C-SB_1981.tap advent.tap
	rm -f dskb.dsk dskc.dsk
	rm -f dskb.rp06 dskc.rp06
	rm -f *.txt *.out test.*

