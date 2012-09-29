BEGIN {
    FS="[, ;	]";
}

/D [0-7][0-7][0-7][0-7], / {
     #print $2 " " $4 " " $5 " " $6 
     i = strtonum("0" $2)
     MAP2[i]  = $2;
     MAP[4,i] = $4;
     MAP[5,i] = $5;
     MAP[6,i] = $6;
}

 END {
     for (i = 0; i < 512; i++) {
 	if (strtonum("0" MAP2[i]) == i) {
	    printf "            9'o%03o: drom <= 36'o%s_%s_%s;\n", 
		i,
		MAP[ 4,i],
		MAP[ 5,i],
		MAP[ 6,i]
 	} else {
	    printf "            9'o%03o: drom <= 36'o%s_%s_%s;\n", 
		i,
		"0000",
		"0000",
		"0000"
 	}
     }
}
