#
#
#

BEGIN {
    FS="[	]";
    printf "        //\n";
    printf "        //\n";
    printf "        // DSKAA.DAT\n";
    printf "        // Entry point is 030600\n";
    printf "        //\n";
    printf "        //\n";
    printf "        \n";
}

#
# Sixbit 
#
#  These looks like:
#
#" xxx	aaaaaa	dd dd dd dd dd dd "
#

/^  ....\t[0-7][0-7][0-7][0-7][0-7][0-7]\t[0-7][0-7] [0-7][0-7] [0-7][0-7] [0-7][0-7] [0-7][0-7] [0-7][0-7].*/ {
    data1 = substr($3,  1, 2);
    data2 = substr($3,  4, 2);
    data3 = substr($3,  7, 2);
    data4 = substr($3, 10, 2);
    data5 = substr($3, 13, 2);
    data6 = substr($3, 16, 2);
    #print $2, (data1 data2 data3 data4 data5 data6)
    i = strtonum("0" $2)
    map[i] = (data1 data2 data3 data4 data5 data6)
}

#
# ASCII
#
#  These looks like:
#
#" xxx	aaaaaa	ddd ddd ddd ddd ddd "

/^  ....\t[0-7][0-7][0-7][0-7][0-7][0-7]\t[0-7][0-7][0-7] [0-7][0-7][0-7] [0-7][0-7][0-7] [0-7][0-7][0-7] [0-7][0-7][0-7].*/ {
    data1 = and(strtonum("0" substr($3,  1, 3)), 0177)
    data2 = and(strtonum("0" substr($3,  5, 3)), 0177)
    data3 = and(strtonum("0" substr($3,  9, 3)), 0177)
    data4 = and(strtonum("0" substr($3, 13, 3)), 0177)
    data5 = and(strtonum("0" substr($3, 17, 3)), 0177)
    dig1  = and(rshift(data1, 1), 077);
    dig2  = and(lshift(data1, 2), 037) + and(lshift(data1, 6), 040);
    dig3  = and(rshift(data3, 3), 017) + and(lshift(data2, 5), 060);
    dig4  = and(rshift(data4, 4), 007) + and(lshift(data3, 4), 070);
    dig5  = and(rshift(data5, 5), 003) + and(lshift(data4, 3), 074);

    data = sprintf(" %02o,%02o ...", dig1, dig2);

    #print ($2 data)
    #print $2, (data1 " " data2 " "   data3 " "  data4 " "  data5)
}

#
# 030651 123 124 122 125 103 
#   1   2   3   1   2   4   1   2   2   1   2   5   1    0   3
#  001 010 011 001 010 100 001 010 010 001 010 101 001 000 011
#  xx          xx          xx          xx          xx
#
#  1 010 011 1 010 100 1 010 010 1 010 101 1 000 011
#  101 001 110 101 001 010 010 101 010 110 000 11x


#
# OPCODES
#
#  These looks like:
#
#" xxx	aaaaaa	ddd dd d dd dddddd "
#

/^  ....\t[0-7][0-7][0-7][0-7][0-7][0-7]\t[0-7][0-7][0-7] [0-7][0-7] [0-7] [0-7][0-7] [0-7][0-7][0-7][0-7][0-7][0-7].*/ {
    data1 = substr($3,  1, 3)
    data2 = substr($3,  5, 2)
    data3 = substr($3,  8, 1)
    data4 = substr($3, 10, 2)
    data5 = substr($3, 13, 6)
    val2  = strtonum("0" data2)
    val3  = strtonum("0" data3)
    val4  = strtonum("0" data4)
    val   = val2 * 32 + val3 * 16 + val4;
    data  = sprintf("%s%03o%s", data1, val, data5);
    #print $2, data
    i = strtonum("0" $2)
    map[i] = data
}

#
# Definitions
# 
#  These looks like:
#
#" xxx	aaaaaa	dddddd	dddddd "
#

/^  ....\t[0-7][0-7][0-7][0-7][0-7][0-7]\t[0-7][0-7][0-7][0-7][0-7][0-7]\t[0-7][0-7][0-7][0-7][0-7][0-7].*/ {
    #print $2, ($3 $4)
    i = strtonum("0" $2)
    map[i] = ($3 $4)
}

#
#
#

END {
   for (i = 0; i < 040000; i++) { 
       if (i == 0) {
	   printf "         RAM[%05d] = 36'o%s;	// %06o (jump to entry point)\n", i, "254000030600", i
       } else {
	   if (map[i] != "") {
               printf "         RAM[%05d] = 36'o%s;	// %06o\n", i, map[i], i
           } else {
	       printf "         RAM[%05d] = 36'o%s;	// %06o (unused)\n", i, "000000000000", i
	   }
       }
   }
}