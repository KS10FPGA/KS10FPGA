#
# Copyright 2022 Rob Doyle
# SPDX-License-Identifier: GPL-2.0
#

sav2verilog : sav2verilog.c
	gcc -O2 -W -Wall -Dx36 sav2verilog.c -o sav2verilog

test : sav2verilog dskaa.sav
	./sav2verilog dskaa.sav dskaa.dat

clean :
	rm -f *~ .*~ *.dat *.exe
	rm -f sav2verilog.exe sav2verilog