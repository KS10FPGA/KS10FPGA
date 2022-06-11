# ASM10

This is a little bitty barely useful PDP10 assembler that was written by David
Bridgham and is used here with his permission.

On occasion it is useful to generate PDP10 code for debugging hardware.

I've made some minor changes from his original verision, namely:
<ul>
  <li>Changes to add a comment character that is consistent with the standard
      C preprocessor so that I can use macros</li>
  <li>Added KS10-specific opcodes. The original ASM10 was used for developing
      his KA10 FPGA and did not include KS10 opcodes</li>
  <li>Changes to make it compile cleanly with a modern compiler</li>
</ul>

# Usage

<pre>
asm10 input_file [-1] [-o output_file]

Usage:
    -1       	Run first pass only.
    -o file	Create output file instead of writing to stdout

<b>Note: -o file doesn't seem to work correctly - redirect the output instead.</b>

</pre>

# Building asm10

The <code>asm10</code> assembler can be built form sources as follows:

<pre>
$ <b>cd &lt;install_directory&gt/tools/asm10</b>
$ <b>make</b>
gcc -g -O3 -W -Wall -Wno-char-subscripts asm10.c ctype-asm.c opcodes.c pseudo.c sym.c -DKS10 -o asm10
$
</pre>

# Example Program

<pre>

;
; Boot the KS10 from Magtape
;
;  The first tape file is microcode. Skip over the microcode
;  The second tape file is MTBOOT. Read MTBOOT and jump to address o1000 to
;    start MTBOOT.
;

        LOC     377000

        ;
        ; SET BOOT ADDRESS
        ;

        START   MTBOOT

        ;
        ; AC0 = DATA
        ; AC1 = ADDR

MTBOOT:

        ;
        ; SETUP UBA PAGING
        ;

        HLLZ  1, 000036         ; GET UBA# FROM CONSOLE DATA AREA
        MOVEI 0, 140001         ; FTM, VALID, PAGE 1
        WRIO  0, 763001(1)      ; WRITE PAGE 1

        ;
        ; CLEAR UBA
        ;

        MOVE  1, 000036         ; GET RH11 BASE ADDR FROM CONSOLE DATA AREA
        ;MOVEI 0, 000100        ; UBACSR[INI]
        ;WRIO  0, 100(1)        ; WRITE TO UBACSR

        ;
        ; DEVICE CLEAR
        ;

        MOVEI 0, 000040         ; RHCS2[CLR]
        WRIO  0, 10(1)          ; WRITE TO MTCS2

        ;
        ; SET UNIT
        ;

        MOVE  0, 000037         ; GET UNIT FROM CONSOLE DATA AREA
        WRIO  0, 10(1)          ; WRITE TO MTCS2

        ;
        ; SEE IF WE ARE AT BOT.  IF NOT, REWIND THE TAPE
        ;

        RDIO  0, 12(1)          ; READ MTDS
        TRNE  0, 000002         ; CHECK BEGINNING-OF-TAPE (MTDS[BOT])
        JRST  NOWREW            ; SKIP REWIND IF BOT
        MOVEI 2, 7              ; REWIND COMMAND
        JSP   17, DOCMD         ; EXECUTE COMMAND

        ;
        ; SPACE FORWARD OVER MICROCODE
        ;

NOREW:  MOVEI 2, 31             ; SPACE FORWARD COMMAND
        JSP   17, DOCMD         ; EXECUTE COMMAND

        ;
        ; READ BOOT
        ;

        MOVEI 2, 71             ; READ FORWARD
        JSP   17, DOCMD         ; EXECUTE COMMAND

        ;
        ; EXECUTE BOOT
        ;

        JRST     1000           ; JUMP TO BOOTLOADER

        ;
        ; SUBROUTINE TO RUN A COMMAND
        ;
        ;  AC2 IS THE COMMAND
        ;  AC1 IS THE BASE ADDR
        ;  AC0 IS TEMP DATA

        ;
        ; CONFIGURE MTTC
        ;

DOCMD:  MOVE  0, 000040         ; GET MTPARAM FROM CONSOLE DATA AREA
        ANDI  0, 003767         ; KEEP DEN, FMT, AND SS
        WRIO  0, 32(1)          ; WRITE TO MTTC

        ;
        ; ISSUE AN DRIVE CLEAR COMMAND TO MTCS1
        ;

        MOVEI 0, 000011         ; DRV CLEAR
        WRIO  0, 0(1)           ; WRITE TO MTCS1

        ;
        ; SET WORD COUNT
        ;

        MOVEI 0, 176000         ; 128 WORDS
        WRIO  0, 2(1)           ; WRITE TO MTWC

        ;
        ; SET BASE ADDRESS
        ;

        MOVEI 0, 004000         ; 04000
        WRIO  0, 4(1)           ; WRITE TO MTBA

        ;
        ; SET FRAME COUNT
        ;

        MOVEI 0, 0              ; 0
        WRIO  0, 6(1)           ; WRITE TO MTFC

        ;
        ; EXECUTE COMMAND
        ;

        WRIO  2, 0(1)           ; WRITE TO MTCS1

        ;
        ; CHECK MTDS STATUS
        ;

TSTDRY: RDIO  0, 12(1)          ; READ MTDS
        TRNN  0, 200            ; TEST DATA READY (MTDS[DRY])
        JRST  TSTDRY            ; CHECK AGAIN
        TRNE  0, 40000          ; TEST ERR
        HALT  .                 ; HALT HERE

        ;
        ; CLEAR MTDS[ATA]
        ;  (WORKS FOR UNIT 0 ONLY)

        MOVEI 0, 1              ; INIT AC
        WRIO  0, 16(1)          ; WRITE TO MTAS

        ;
        ; IF REWIND COMMAND, WAIT FOR COMMAND TO COMPLETE
        ;

        ANDI  2, 000076         ; MASK FUNCTION
        CAIE  2, 000006         ; SKIP IF REWIND COMMAND
        JRST  NOTREW            ; NOT REWIND
TSTATA: RDIO  0, 12(1)          ; READ MTDS
        TRNN  0, 100000         ; TEST ATTENTION (MTDS[ATA])
        JRST  TSTATA

        ;
        ; CLEAR MTDS[ATA]
        ;  (WORKS FOR UNIT 0 ONLY)

        MOVEI 0, 1              ; INIT AC
        WRIO  0, 16(1)          ; WRITE TO MTAS

        ;
        ; CHECK MTER STATUS2
        ;

NOTREW: RDIO  0, 14(1)          ; READ MTER
        CAIN  0, 1000           ; TEST FRAME CHECK ERROR (MTER[FCE])
        HALT  .                 ; HALT HERE
        JRST  0(17)             ; RETURN

        ;
        ; Data Pattern (not used)
        ;

DATA:   000000,,000000
        000000,,000001
        000000,,000002
        000000,,000003
        000000,,000004
        000000,,000005
        000000,,000006
        000000,,000007
        000000,,000010
        000000,,000011
        000000,,000012
        000000,,000013
        000000,,000014
        000000,,000015
        000000,,000016
        000000,,000017

        000000,,000020
        000000,,000021
        000000,,000022
        000000,,000023
        000000,,000024
        000000,,000025
        000000,,000026
        000000,,000027
        000000,,000030
        000000,,000031
        000000,,000032
        000000,,000033
        000000,,000034
        000000,,000035
        000000,,000036
        000000,,000037

        000000,,000040
        000000,,000041
        000000,,000042
        000000,,000043
        000000,,000044
        000000,,000045
        000000,,000046
        000000,,000047
        000000,,000050
        000000,,000051
        000000,,000052
        000000,,000053
        000000,,000054
        000000,,000055
        000000,,000056
        000000,,000057

        000000,,000060
        000000,,000061
        000000,,000062
        000000,,000063
        000000,,000064
        000000,,000065
        000000,,000066
        000000,,000067
        000000,,000070
        000000,,000071
        000000,,000072
        000000,,000073
        000000,,000074
        000000,,000075
        000000,,000076
        000000,,000077

        000000,,000100
        000000,,000101
        000000,,000102
        000000,,000103
        000000,,000104
        000000,,000105
        000000,,000106
        000000,,000107
        000000,,000110
        000000,,000111
        000000,,000112
        000000,,000113
        000000,,000114
        000000,,000115
        000000,,000116
        000000,,000117

        000000,,000120
        000000,,000121
        000000,,000122
        000000,,000123
        000000,,000124
        000000,,000125
        000000,,000126
        000000,,000127
        000000,,000130
        000000,,000131
        000000,,000132
        000000,,000133
        000000,,000134
        000000,,000135
        000000,,000136
        000000,,000137

        000000,,000140
        000000,,000141
        000000,,000142
        000000,,000143
        000000,,000144
        000000,,000145
        000000,,000146
        000000,,000147
        000000,,000150
        000000,,000151
        000000,,000152
        000000,,000153
        000000,,000154
        000000,,000155
        000000,,000156
        000000,,000157

        000000,,000160
        000000,,000161
        000000,,000162
        000000,,000163
        000000,,000164
        000000,,000165
        000000,,000166
        000000,,000167
        000000,,000170
        000000,,000171
        000000,,000172
        000000,,000173
        000000,,000174
        000000,,000175
        000000,,000176
        000000,,000177

        000000,,000200
        000000,,000201
        000000,,000202
        000000,,000203
        000000,,000204
        000000,,000205
        000000,,000206
        000000,,000207
        000000,,000210
        000000,,000211
        000000,,000212
        000000,,000213
        000000,,000214
        000000,,000215
        000000,,000216
        000000,,000217

</pre>

# Example output file

<pre>
./asm10 mtboot.asm -o mtboot.lst
        ;
        ; Boot the KS10 from Magtape
        ;
        ;  The first tape file is microcode. Skip over the microcode.
        ;  The second tape file is MTBOOT. Read MTBOOT and jump to address o1000 to
        ;    start MTBOOT.
        ;
        ;
        ; SET BOOT ADDRESS
        ;
        ;
        ; AC0 = DATA
        ; AC1 = ADDR
        ;
        ; SETUP UBA PAGING
        ;
377000  510040 000036  510 01 0 00 000036               HLLZ  1, 000036         ; GET UBA# FROM CONSOLE DATA AREA
377001  201000 140001  201 00 0 00 140001               MOVEI 0, 140001         ; FTM, VALID, PAGE 1
377002  713001 763001  713 00 0 01 763001               WRIO  0, 763001(1)      ; WRITE PAGE 1
        ;
        ; CLEAR UBA
        ;
377003  200040 000036  200 01 0 00 000036               MOVE  1, 000036         ; GET RH11 BASE ADDR FROM CONSOLE DATA AREA
        ;MOVEI 0, 000100        ; UBACSR[INI]
        ;WRIO  0, 100(1)        ; WRITE TO UBACSR
        ;
        ; DEVICE CLEAR
        ;
377004  201000 000040  201 00 0 00 000040               MOVEI 0, 000040         ; RHCS2[CLR]
377005  713001 000010  713 00 0 01 000010               WRIO  0, 10(1)          ; WRITE TO MTCS2
        ;
        ; SET UNIT
        ;
377006  200000 000037  200 00 0 00 000037               MOVE  0, 000037         ; GET UNIT FROM CONSOLE DATA AREA
377007  713001 000010  713 00 0 01 000010               WRIO  0, 10(1)          ; WRITE TO MTCS2
        ;
        ; SEE IF WE ARE AT BOT.  IF NOT, REWIND THE TAPE
        ;
377010  712001 000012  712 00 0 01 000012               RDIO  0, 12(1)          ; READ MTDS
377011  602000 000002  602 00 0 00 000002               TRNE  0, 000002         ; CHECK BEGINNING-OF-TAPE (MTDS[BOT])
377012  254000 777777  254 00 0 00 777777               JRST  NOWREW            ; SKIP REWIND IF BOT
377013  201100 000007  201 02 0 00 000007               MOVEI 2, 7              ; REWIND COMMAND
377014  265740 377022  265 17 0 00 377022               JSP   17, DOCMD         ; EXECUTE COMMAND
        ;
        ; SPACE FORWARD OVER MICROCODE
        ;
377015  201100 000031  201 02 0 00 000031       NOREW:  MOVEI 2, 31             ; SPACE FORWARD COMMAND
377016  265740 377022  265 17 0 00 377022               JSP   17, DOCMD         ; EXECUTE COMMAND
        ;
        ; READ BOOT
        ;
377017  201100 000071  201 02 0 00 000071               MOVEI 2, 71             ; READ FORWARD
377020  265740 377022  265 17 0 00 377022               JSP   17, DOCMD         ; EXECUTE COMMAND
        ;
        ; EXECUTE BOOT
        ;
377021  254000 001000  254 00 0 00 001000               JRST     1000           ; JUMP TO BOOTLOADER
        ;
        ; SUBROUTINE TO RUN A COMMAND
        ;
        ;  AC2 IS THE COMMAND
        ;  AC1 IS THE BASE ADDR
        ;  AC0 IS TEMP DATA
        ;
        ; CONFIGURE MTTC
        ;
377022  200000 000040  200 00 0 00 000040       DOCMD:  MOVE  0, 000040         ; GET MTPARAM FROM CONSOLE DATA AREA
377023  405000 003767  405 00 0 00 003767               ANDI  0, 003767         ; KEEP DEN, FMT, AND SS
377024  713001 000032  713 00 0 01 000032               WRIO  0, 32(1)          ; WRITE TO MTTC
        ;
        ; ISSUE AN DRIVE CLEAR COMMAND TO MTCS1
        ;
377025  201000 000011  201 00 0 00 000011               MOVEI 0, 000011         ; DRV CLEAR
377026  713001 000000  713 00 0 01 000000               WRIO  0, 0(1)           ; WRITE TO MTCS1
        ;
        ; SET WORD COUNT
        ;
377027  201000 176000  201 00 0 00 176000               MOVEI 0, 176000         ; 128 WORDS
377030  713001 000002  713 00 0 01 000002               WRIO  0, 2(1)           ; WRITE TO MTWC
        ;
        ; SET BASE ADDRESS
        ;
377031  201000 004000  201 00 0 00 004000               MOVEI 0, 004000         ; 04000
377032  713001 000004  713 00 0 01 000004               WRIO  0, 4(1)           ; WRITE TO MTBA
        ;
        ; SET FRAME COUNT
        ;
377033  201000 000000  201 00 0 00 000000               MOVEI 0, 0              ; 0
377034  713001 000006  713 00 0 01 000006               WRIO  0, 6(1)           ; WRITE TO MTFC
        ;
        ; EXECUTE COMMAND
        ;
377035  713101 000000  713 02 0 01 000000               WRIO  2, 0(1)           ; WRITE TO MTCS1
        ;
        ; CHECK MTDS STATUS
        ;
377036  712001 000012  712 00 0 01 000012       TSTDRY: RDIO  0, 12(1)          ; READ MTDS
377037  606000 000200  606 00 0 00 000200               TRNN  0, 200            ; TEST DATA READY (MTDS[DRY])
377040  254000 377036  254 00 0 00 377036               JRST  TSTDRY            ; CHECK AGAIN
377041  602000 040000  602 00 0 00 040000               TRNE  0, 40000          ; TEST ERR
377042  254200 377042  254 00 0 00 377042               HALT  .                 ; HALT HERE
        ;
        ; CLEAR MTDS[ATA]
        ;  (WORKS FOR UNIT 0 ONLY)
377043  201000 000001  201 00 0 00 000001               MOVEI 0, 1              ; INIT AC
377044  713001 000016  713 00 0 01 000016               WRIO  0, 16(1)          ; WRITE TO MTAS
        ;
        ; IF REWIND COMMAND, WAIT FOR COMMAND TO COMPLETE
        ;
377045  405100 000076  405 02 0 00 000076               ANDI  2, 000076         ; MASK FUNCTION
377046  302100 000006  302 02 0 00 000006               CAIE  2, 000006         ; SKIP IF REWIND COMMAND
377047  254000 377055  254 00 0 00 377055               JRST  NOTREW            ; NOT REWIND
377050  712001 000012  712 00 0 01 000012       TSTATA: RDIO  0, 12(1)          ; READ MTDS
377051  606000 100000  606 00 0 00 100000               TRNN  0, 100000         ; TEST ATTENTION (MTDS[ATA])
377052  254000 377050  254 00 0 00 377050               JRST  TSTATA
        ;
        ; CLEAR MTDS[ATA]
        ;  (WORKS FOR UNIT 0 ONLY)
377053  201000 000001  201 00 0 00 000001               MOVEI 0, 1              ; INIT AC
377054  713001 000016  713 00 0 01 000016               WRIO  0, 16(1)          ; WRITE TO MTAS
        ;
        ; CHECK MTER STATUS2
        ;
377055  712001 000014  712 00 0 01 000014       NOTREW: RDIO  0, 14(1)          ; READ MTER
377056  306000 001000  306 00 0 00 001000               CAIN  0, 1000           ; TEST FRAME CHECK ERROR (MTER[FCE])
377057  254200 377057  254 00 0 00 377057               HALT  .                 ; HALT HERE
377060  254017 000000  254 00 0 17 000000               JRST  0(17)             ; RETURN
</pre>

# Grammar

<pre>
line = ["label"] instr

instr = expr [ ",,"  expr ]
        | op [ operand ]

op = "name" | number

operand = [ expr "," ] ["@"] [ expr ] ["(" expr ")"]

expr = number { ( "+" | "-" ) number }

number = [ "+" | "-" ]  "octal" | "decimal" | "name"

</pre>
