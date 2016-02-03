################################################################################
##
## KS-10 Processor
##
## Brief
##   Dispatch ROM Parser
##
## Details
##
##   This awk script parses the KS10 Microcode Listing File and extracts the
##   the contents of the Control ROM.
##
## File
##   crom.awk
##
## Author
##   Rob Doyle - doyle (at) cox (dot) net
##
################################################################################
##
## Copyright (C) 2012-2016 Rob Doyle
##
## This source file may be used and distributed without restriction provided
## that this copyright statement is not removed from the file and that any
## derivative work contains the original copyright notice and the associated
## disclaimer.
##
## This source file is free software; you can redistribute it and#or modify it
## under the terms of the GNU Lesser General Public License as published by the
## Free Software Foundation; version 2.1 of the License.
##
## This source is distributed in the hope that it will be useful, but WITHOUT
## ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
## FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License
## for more details.
##
## You should have received a copy of the GNU Lesser General Public License
## along with this source; if not, download it from
## http://www.gnu.org/licenses/lgpl.txt
##
################################################################################

BEGIN {
    FS="[, ;	]";
    printf "//\n";
    printf "//\n";
    printf "// CROM.DAT\n";
    printf "// This code is extracted from the KS10 microcode listing by an\n";
    printf "// AWK script.   DO NOT EDIT THIS FILE!\n";
    printf "//\n";
    printf "//\n";
    printf "\n";
}

/^U [0-7][0-7][0-7][0-7], / {
    #print $4 " " $5 " " $6 " " $7 " " $8 " " $9 " " $10 " " $11 " " $12 "// " $2
    i         = strtonum("0"  $2);
    MAP2[i]   = strtonum("0"  $2);
    MAP[ 4,i] = strtonum("0"  $4);
    MAP[ 5,i] = strtonum("0"  $5);
    MAP[ 6,i] = strtonum("0"  $6);
    MAP[ 7,i] = strtonum("0"  $7);
    MAP[ 8,i] = strtonum("0"  $8);
    MAP[ 9,i] = strtonum("0"  $9);
    MAP[10,i] = strtonum("0" $10);
    MAP[11,i] = strtonum("0" $11);
    MAP[12,i] = strtonum("0" $12);
}

END {
    for (i = 0; i < 4096; i++) {
	if (MAP2[i] == i) {
	    printf "%03x%03x%03x%03x%03x%03x%03x%03x%03x	// CROM[%4o] = 108'o%04o_%04o_%04o_%04o_%04o_%04o_%04o_%04o_%04o;\n",
		MAP[ 4,i], MAP[ 5,i], MAP[ 6,i], MAP[ 7,i], MAP[ 8,i], MAP[ 9,i], MAP[10,i], MAP[11,i], MAP[12,i], i,
		MAP[ 4,i], MAP[ 5,i], MAP[ 6,i], MAP[ 7,i], MAP[ 8,i], MAP[ 9,i], MAP[10,i], MAP[11,i],	MAP[12,i]
	} else {
	    printf "%03x%03x%03x%03x%03x%03x%03x%03x%03x	// CROM[%4o] = 108'o%04o_%04o_%04o_%04o_%04o_%04o_%04o_%04o_%04o;	// Unused\n",
		0, 0, 0, 0, 0, 0, 0, 0, 0, i,
		0, 0, 0, 0, 0, 0, 0, 0, 0
	}
    }
}
