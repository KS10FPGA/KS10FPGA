#******************************************************************************
#
# KS-10 Processor
#
# Brief
#    Testbench build rules
#
# File
#    makefile
#
# Author
#    Rob Doyle - doyle (at) cox (dot) net
#
#******************************************************************************
#
# Copyright (C) 2013-2021 Rob Doyle
#
# This file is part of the KS10 FPGA Project
#
# The KS10 FPGA project is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option) any
# later version.
#
# The KS10 FPGA project is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
# more details.
#
# You should have received a copy of the GNU General Public License along with
# this software.  If not, see <http://www.gnu.org/licenses/>.
#
#******************************************************************************

#
# Programs
#

T10BACKUP   := ../../tools/tapeutils/t10backup.exe
DIAGTAPE    := ../../Tape\ and\ Disk\ Images/KS10\ Diagnostics/ks_diag_gs.tap
REDPACK     := ../../Tape\ and\ Disk\ Images/RED\ PACK\ 405A2/red405a2.tap
SAV2VERILOG := ../../tools/sav2verilog/sav2verilog.exe
MERGE_AWK   := ./merge18.awk

#
# Read SD Card to file so it can be examined.
#  This assumes that a 8GB card is installed.
#

DEV   := sde
UNIT0 := dskb.rp06.gz
UNIT1 := dskc.rp06.gz
UNIT2 := red405a2.rp06.gz
UNIT3 := dskb.rp06.gz
UNIT4 := dskb.rp06.gz
UNIT5 := dskb.rp06.gz
UNIT6 := dskb.rp06.gz
UNIT7 := dskb.rp06.gz

all : dsdab.ssram.dat

dskaa.ssram.dat : $(T10BACKUP) $(DIAGTAPE) $(SAV2VERILOG) DSQDA.DAT DSQDB.DAT DSQDC.DAT DSQDA.PATCH PAGEN.PATCH
	$(T10BACKUP) -i -x diagnostics..dskaa.sav -f $(DIAGTAPE)
	mv dskaa.sav DSKAA.SAV
	$(SAV2VERILOG) DSKAA.SAV DSKAA.DAT
	cat DSQDA.DAT DSQDB.DAT DSQDC.DAT DSKAA.DAT DSQDA.PATCH PAGEN.PATCH | awk -f $(MERGE_AWK) -vfilename=DSKAA.DAT > dskaa.ssram.dat

dskba.ssram.dat : $(T10BACKUP) $(DIAGTAPE) $(SAV2VERILOG) DSQDA.DAT DSQDB.DAT DSQDC.DAT DSQDA.PATCH
	$(T10BACKUP) -i -x diagnostics..dskba.sav -f $(DIAGTAPE)
	mv dskba.sav DSKBA.SAV
	$(SAV2VERILOG) DSKBA.SAV DSKBA.DAT
	cat DSQDA.DAT DSQDB.DAT DSQDC.DAT DSKBA.DAT DSQDA.PATCH | awk -f $(MERGE_AWK) -vfilename=DSKBA.DAT > dskba.ssram.dat

dskcg.ssram.dat : $(T10BACKUP) $(DIAGTAPE) $(SAV2VERILOG) DSQDA.DAT DSQDB.DAT DSQDC.DAT DSQDA.PATCH
	$(T10BACKUP) -i -x diagnostics..dskcg.sav -f $(DIAGTAPE)
	mv dskcg.sav DSKCG.SAV
	$(SAV2VERILOG) DSKCG.SAV DSKCG.DAT
	cat DSQDA.DAT DSQDB.DAT DSQDC.DAT DSKCG.DAT DSQDA.PATCH | awk -f $(MERGE_AWK) -vfilename=DSKCG.DAT > dskcg.ssram.dat

dskda.ssram.dat : $(T10BACKUP) $(DIAGTAPE) $(SAV2VERILOG) DSQDA.DAT DSQDB.DAT DSQDC.DAT DSQDA.PATCH
	$(T10BACKUP) -i -x diagnostics..dskda.sav -f $(DIAGTAPE)
	mv dskda.sav DSKDA.SAV
	$(SAV2VERILOG) DSKDA.SAV DSKDA.DAT
	cat DSQDA.DAT DSQDB.DAT DSQDC.DAT DSKDA.DAT DSQDA.PATCH | awk -f $(MERGE_AWK) -vfilename=DSKDA.DAT > dskda.ssram.dat

dskea.ssram.dat : $(T10BACKUP) $(DIAGTAPE) $(SAV2VERILOG) DSQDA.DAT DSQDB.DAT DSQDC.DAT DSQDA.PATCH
	$(T10BACKUP) -i -x diagnostics..dskea.sav -f $(DIAGTAPE)
	mv dskea.sav DSKEA.SAV
	$(SAV2VERILOG) DSKEA.SAV DSKEA.DAT
	cat DSQDA.DAT DSQDB.DAT DSQDC.DAT DSKEA.DAT DSQDA.PATCH | awk -f $(MERGE_AWK) -vfilename=DSKEA.DAT > dskea.ssram.dat

dskeb.ssram.dat : $(T10BACKUP) $(DIAGTAPE) $(SAV2VERILOG) DSQDA.DAT DSQDB.DAT DSQDC.DAT DSQDA.PATCH
	$(T10BACKUP) -i -x diagnostics..dskeb.sav -f $(DIAGTAPE)
	mv dskeb.sav DSKEB.SAV
	$(SAV2VERILOG) DSKEB.SAV DSKEB.DAT
	cat DSQDA.DAT DSQDB.DAT DSQDC.DAT DSKEB.DAT DSQDA.PATCH | awk -f $(MERGE_AWK) -vfilename=DSKEB.DAT > dskeb.ssram.dat

dskec.ssram.dat : $(T10BACKUP) $(DIAGTAPE) $(SAV2VERILOG) DSQDA.DAT DSQDB.DAT DSQDC.DAT DSQDA.PATCH
	$(T10BACKUP) -i -x diagnostics..dskec.sav -f $(DIAGTAPE)
	mv dskec.sav DSKEC.SAV
	$(SAV2VERILOG) DSKEC.SAV DSKEC.DAT
	cat DSQDA.DAT DSQDB.DAT DSQDC.DAT DSKEC.DAT DSQDA.PATCH | awk -f $(MERGE_AWK) -vfilename=DSKEC.DAT > dskec.ssram.dat

#
# DUP11
#

dsdua.ssram.dat : $(T10BACKUP) $(DIAGTAPE) $(SAV2VERILOG) DSQDA.DAT DSQDB.DAT DSQDC.DAT DSQDA.PATCH
	$(T10BACKUP) -i -x diagnostics..dsdua.sav -f $(DIAGTAPE)
	mv dsdua.sav DSDUA.SAV
	$(SAV2VERILOG) DSDUA.SAV DSDUA.DAT
	cat DSQDA.DAT DSQDB.DAT DSQDC.DAT DSDUA.DAT DSQDA.PATCH | awk -f $(MERGE_AWK) -vfilename=DSDUA.DAT > dsdua.ssram.dat

#
# DZ11
#

dsdza.ssram.dat : $(T10BACKUP) $(DIAGTAPE) $(SAV2VERILOG) DSQDA.DAT DSQDB.DAT DSQDC.DAT DSQDA.PATCH.PATCH
	$(T10BACKUP) -i -x diagnostics..dsdza.sav -f $(DIAGTAPE)
	mv dsdza.sav DSDZA.SAV
	$(SAV2VERILOG) DSDZA.SAV DSDZA.DAT
	cat DSQDA.DAT DSQDB.DAT DSQDC.DAT DSDZA.DAT DSQDA.PATCH | awk -f $(MERGE_AWK) -vfilename=DSDZA.DAT > dsdza.ssram.dat

#
# KMC11
#

dskma.ssram.dat : $(T10BACKUP) $(DIAGTAPE) $(SAV2VERILOG) DSQDA.DAT DSQDB.DAT DSQDC.DAT DSQDA.PATCH
	$(T10BACKUP) -i -x diagnostics..dskma.sav -f $(DIAGTAPE)
	mv dskma.sav DSKMA.SAV
	$(SAV2VERILOG) DSKMA.SAV DSKMA.DAT
	cat DSQDA.DAT DSQDB.DAT DSQDC.DAT DSKMA.DAT DSQDA.PATCH | awk -f $(MERGE_AWK) -vfilename=DSKMA.DAT > dskma.ssram.dat

#
# LP20
#

dslpa.ssram.dat : $(T10BACKUP) $(DIAGTAPE) $(SAV2VERILOG) DSQDA.DAT DSQDB.DAT DSQDC.DAT DSQDA.PATCH
	$(T10BACKUP) -i -x diagnostics..dslpa.sav -f $(DIAGTAPE)
	mv dslpa.sav DSLPA.SAV
	$(SAV2VERILOG) DSLPA.SAV DSLPA.DAT
	cat DSQDA.DAT DSQDB.DAT DSQDC.DAT DSLPA.DAT DSQDA.PATCH | awk -f $(MERGE_AWK) -vfilename=DSLPA.DAT > dslpa.ssram.dat

#
# Memory
#

dsmma.ssram.dat : $(T10BACKUP) $(DIAGTAPE) $(SAV2VERILOG) DSQDA.DAT DSQDB.DAT DSQDC.DAT DSQDA.PATCH
	$(T10BACKUP) -i -x diagnostics..dsmma.sav -f $(DIAGTAPE)
	mv dsmma.sav DSMMA.SAV
	$(SAV2VERILOG) DSMMA.SAV DSMMA.DAT
	cat DSQDA.DAT DSQDB.DAT DSQDC.DAT DSMMA.DAT DSQDA.PATCH | awk -f $(MERGE_AWK) -vfilename=DSMMA.DAT > dsmma.ssram.dat

#
# Memory
#

dsmmb.ssram.dat : $(T10BACKUP) $(DIAGTAPE) $(SAV2VERILOG) DSQDA.DAT DSQDB.DAT DSQDC.DAT DSQDA.PATCH
	$(T10BACKUP) -i -x diagnostics..dsmmb.sav -f $(DIAGTAPE)
	mv dsmmb.sav DSMMB.SAV
	$(SAV2VERILOG) DSMMB.SAV tempfile
	cat DSQDA.DAT DSQDB.DAT DSQDC.DAT tempfile DSQDA.PATCH | awk -f $(MERGE_AWK) -vfilename=DSMMB.DAT > dsmmb.ssram.dat

#
# Fast AC
#

dsmmc.ssram.dat : $(T10BACKUP) $(DIAGTAPE) $(SAV2VERILOG) DSQDA.DAT DSQDB.DAT DSQDC.DAT DSQDA.PATCH
	$(T10BACKUP) -i -x diagnostics..dsmmc.sav -f $(DIAGTAPE)
	mv dsmmc.sav DSMMC.SAV
	$(SAV2VERILOG) DSMMC.SAV tempfile
	cat DSQDA.DAT DSQDB.DAT DSQDC.DAT tempfile DSQDA.PATCH | awk -f $(MERGE_AWK) -vfilename=DSMMC.DAT > dsmmc.ssram.dat

#
#
#

dsmmd.ssram.dat : $(T10BACKUP) $(DIAGTAPE) $(SAV2VERILOG) DSQDA.DAT DSQDB.DAT DSQDC.DAT DSQDA.PATCH
	$(T10BACKUP) -i -x diagnostics..dsmmd.sav -f $(DIAGTAPE)
	mv dsmmd.sav DSMMD.SAV
	$(SAV2VERILOG) DSMMD.SAV DSMMD.DAT
	cat DSQDA.DAT DSQDB.DAT DSQDC.DAT DSMMD.DAT DSQDA.PATCH | awk -f $(MERGE_AWK) -vfilename=DSMMD.DAT > dsmmd.ssram.dat

#
# RH11/RM03/RP06
#

dsrmb.ssram.dat : $(T10BACKUP) $(DIAGTAPE) $(SAV2VERILOG) DSQDA.DAT DSQDB.DAT DSQDC.DAT DSQDA.PATCH
	$(T10BACKUP) -i -x diagnostics..dsrmb.sav -f $(DIAGTAPE)
	mv dsrmb.sav DSRMB.SAV
	$(SAV2VERILOG) DSRMB.SAV DSRMB.DAT
	cat DSQDA.DAT DSQDB.DAT DSQDC.DAT DSRMB.DAT DSQDA.PATCH | awk -f $(MERGE_AWK) -vfilename=DSRMB.DAT > dsrmb.ssram.dat

#
# RH11/RP06
#

dsrpa.ssram.dat : $(T10BACKUP) $(DIAGTAPE) $(SAV2VERILOG) DSQDA.DAT DSQDB.DAT DSQDC.DAT DSQDA.PATCH DSRPA.PATCH
	$(T10BACKUP) -i -x diagnostics..dsrpa.sav -f $(DIAGTAPE)
	mv dsrpa.sav DSRPA.SAV
	$(SAV2VERILOG) DSRPA.SAV DSRPA.DAT
	cat DSQDA.DAT DSQDB.DAT DSQDC.DAT DSRPA.DAT DSQDA.PATCH DSRPA.PATCH | awk -f $(MERGE_AWK) -vfilename=DSRPA.DAT > dsrpa.ssram.dat

#
# UBA
#

dsuba.ssram.dat : $(T10BACKUP) $(DIAGTAPE) $(SAV2VERILOG) DSQDA.DAT DSQDB.DAT DSQDC.DAT DSQDA.PATCH DSUBA.PATCH
	$(T10BACKUP) -i -x diagnostics..dsuba.sav -f $(DIAGTAPE)
	mv dsuba.sav DSUBA.SAV
	$(SAV2VERILOG) DSUBA.SAV DSDUA.DAT
	cat DSQDA.DAT DSQDB.DAT DSQDC.DAT DSDUA.DAT DSQDA.PATCH DSUBA.PATCH | awk -f $(MERGE_AWK) -vfilename=DSUBA.DAT > dsuba.ssram.dat


#
# Diagnostic Programs and Subroutines
#

DSQDA.DAT : $(T10BACKUP) $(DIAGTAPE)
	$(T10BACKUP) -i -x diagnostics..subsm.sav -f $(DIAGTAPE)
	mv subsm.sav DSQDA.SAV
	$(SAV2VERILOG) DSQDA.SAV DSQDA.DAT

DSQDB.DAT : $(T10BACKUP) $(DIAGTAPE)
	$(T10BACKUP) -i -x diagnostics..smddt.sav -f $(DIAGTAPE)
	mv smddt.sav DSQDB.SAV
	$(SAV2VERILOG) DSQDB.SAV DSQDB.DAT

DSQDC.DAT : $(T10BACKUP) $(DIAGTAPE)
	$(T10BACKUP) -i -x diagnostics..smmon.sav -f $(DIAGTAPE)
	mv smmon.sav DSQDC.SAV
	$(SAV2VERILOG) DSQDC.SAV DSQDC.DAT

#
# Enable paging
#  Unity map table
#  WREBR 030000
#  JRST  030600
#

PAGEN.PATCH : makefile
	echo -e "000000180\t\t// mem[000600] = 540000540001" >  PAGEN.PATCH
	echo -e "000000181\t\t// mem[000601] = 540002540003" >> PAGEN.PATCH
	echo -e "000000182\t\t// mem[000602] = 540004540005" >> PAGEN.PATCH
	echo -e "000000183\t\t// mem[000603] = 540006540007" >> PAGEN.PATCH
	echo -e "000000184\t\t// mem[000604] = 540010540011" >> PAGEN.PATCH
	echo -e "000000185\t\t// mem[000605] = 540012540013" >> PAGEN.PATCH
	echo -e "000000186\t\t// mem[000606] = 540014540015" >> PAGEN.PATCH
	echo -e "000000187\t\t// mem[000607] = 540016540017" >> PAGEN.PATCH
	echo -e "000000188\t\t// mem[000610] = 540020540021" >> PAGEN.PATCH
	echo -e "000000189\t\t// mem[000611] = 540022540023" >> PAGEN.PATCH
	echo -e "00000018a\t\t// mem[000612] = 540024540025" >> PAGEN.PATCH
	echo -e "00000018b\t\t// mem[000613] = 540026540027" >> PAGEN.PATCH
	echo -e "00000018c\t\t// mem[000614] = 540030540031" >> PAGEN.PATCH
	echo -e "00000018d\t\t// mem[000615] = 540032540033" >> PAGEN.PATCH
	echo -e "00000018e\t\t// mem[000616] = 540034540035" >> PAGEN.PATCH
	echo -e "00000018f\t\t// mem[000617] = 540036540037" >> PAGEN.PATCH
	echo -e "000000190\t\t// mem[000620] = 540040540041" >> PAGEN.PATCH
	echo -e "000000191\t\t// mem[000621] = 540042540043" >> PAGEN.PATCH
	echo -e "000000192\t\t// mem[000622] = 540044540045" >> PAGEN.PATCH
	echo -e "000000193\t\t// mem[000623] = 540046540047" >> PAGEN.PATCH
	echo -e "000000194\t\t// mem[000624] = 540050540051" >> PAGEN.PATCH
	echo -e "000000195\t\t// mem[000625] = 540052540053" >> PAGEN.PATCH
	echo -e "000000196\t\t// mem[000626] = 540054540055" >> PAGEN.PATCH
	echo -e "000000197\t\t// mem[000627] = 540056540057" >> PAGEN.PATCH
	echo -e "000000198\t\t// mem[000630] = 540060540061" >> PAGEN.PATCH
	echo -e "000000199\t\t// mem[000631] = 540062540063" >> PAGEN.PATCH
	echo -e "00000019a\t\t// mem[000632] = 540064540065" >> PAGEN.PATCH
	echo -e "00000019b\t\t// mem[000633] = 540066540067" >> PAGEN.PATCH
	echo -e "00000019c\t\t// mem[000634] = 540070540071" >> PAGEN.PATCH
	echo -e "00000019d\t\t// mem[000635] = 540072540073" >> PAGEN.PATCH
	echo -e "00000019e\t\t// mem[000636] = 540074540075" >> PAGEN.PATCH
	echo -e "00000019f\t\t// mem[000637] = 540076540077" >> PAGEN.PATCH
	echo -e "0000001a0\t\t// mem[000640] = 540100540101" >> PAGEN.PATCH
	echo -e "0000001a1\t\t// mem[000641] = 540102540103" >> PAGEN.PATCH
	echo -e "0000001a2\t\t// mem[000642] = 540104540105" >> PAGEN.PATCH
	echo -e "0000001a3\t\t// mem[000643] = 540106540107" >> PAGEN.PATCH
	echo -e "0000001a4\t\t// mem[000644] = 540110540111" >> PAGEN.PATCH
	echo -e "0000001a5\t\t// mem[000645] = 540112540113" >> PAGEN.PATCH
	echo -e "0000001a6\t\t// mem[000646] = 540114540115" >> PAGEN.PATCH
	echo -e "0000001a7\t\t// mem[000647] = 540116540117" >> PAGEN.PATCH
	echo -e "0000001a8\t\t// mem[000650] = 540120540121" >> PAGEN.PATCH
	echo -e "0000001a9\t\t// mem[000651] = 540122540123" >> PAGEN.PATCH
	echo -e "0000001aa\t\t// mem[000652] = 540124540125" >> PAGEN.PATCH
	echo -e "0000001ab\t\t// mem[000653] = 540126540127" >> PAGEN.PATCH
	echo -e "0000001ac\t\t// mem[000654] = 540130540131" >> PAGEN.PATCH
	echo -e "0000001ad\t\t// mem[000655] = 540132540133" >> PAGEN.PATCH
	echo -e "0000001ae\t\t// mem[000656] = 540134540135" >> PAGEN.PATCH
	echo -e "0000001af\t\t// mem[000657] = 540136540137" >> PAGEN.PATCH
	echo -e "0000001b0\t\t// mem[000660] = 540140540141" >> PAGEN.PATCH
	echo -e "0000001b1\t\t// mem[000661] = 540142540143" >> PAGEN.PATCH
	echo -e "0000001b2\t\t// mem[000662] = 540144540145" >> PAGEN.PATCH
	echo -e "0000001b3\t\t// mem[000663] = 540146540147" >> PAGEN.PATCH
	echo -e "0000001b4\t\t// mem[000664] = 540150540151" >> PAGEN.PATCH
	echo -e "0000001b5\t\t// mem[000665] = 540152540153" >> PAGEN.PATCH
	echo -e "0000001b6\t\t// mem[000666] = 540154540155" >> PAGEN.PATCH
	echo -e "0000001b7\t\t// mem[000667] = 540156540157" >> PAGEN.PATCH
	echo -e "0000001b8\t\t// mem[000670] = 540160540161" >> PAGEN.PATCH
	echo -e "0000001b9\t\t// mem[000671] = 540162540163" >> PAGEN.PATCH
	echo -e "0000001ba\t\t// mem[000672] = 540164540165" >> PAGEN.PATCH
	echo -e "0000001bb\t\t// mem[000673] = 540166540167" >> PAGEN.PATCH
	echo -e "0000001bc\t\t// mem[000674] = 540170540171" >> PAGEN.PATCH
	echo -e "0000001bd\t\t// mem[000675] = 540172540173" >> PAGEN.PATCH
	echo -e "0000001be\t\t// mem[000676] = 540174540175" >> PAGEN.PATCH
	echo -e "0000001bf\t\t// mem[000677] = 540176540177" >> PAGEN.PATCH
	echo -e "0000001c0\t\t// mem[000700] = 540200540201" >> PAGEN.PATCH
	echo -e "0000001c1\t\t// mem[000701] = 540202540203" >> PAGEN.PATCH
	echo -e "0000001c2\t\t// mem[000702] = 540204540205" >> PAGEN.PATCH
	echo -e "0000001c3\t\t// mem[000703] = 540206540207" >> PAGEN.PATCH
	echo -e "0000001c4\t\t// mem[000704] = 540210540211" >> PAGEN.PATCH
	echo -e "0000001c5\t\t// mem[000705] = 540212540213" >> PAGEN.PATCH
	echo -e "0000001c6\t\t// mem[000706] = 540214540215" >> PAGEN.PATCH
	echo -e "0000001c7\t\t// mem[000707] = 540216540217" >> PAGEN.PATCH
	echo -e "0000001c8\t\t// mem[000710] = 540220540221" >> PAGEN.PATCH
	echo -e "0000001c9\t\t// mem[000711] = 540222540223" >> PAGEN.PATCH
	echo -e "0000001ca\t\t// mem[000712] = 540224540225" >> PAGEN.PATCH
	echo -e "0000001cb\t\t// mem[000713] = 540226540227" >> PAGEN.PATCH
	echo -e "0000001cc\t\t// mem[000714] = 540230540231" >> PAGEN.PATCH
	echo -e "0000001cd\t\t// mem[000715] = 540232540233" >> PAGEN.PATCH
	echo -e "0000001ce\t\t// mem[000716] = 540234540235" >> PAGEN.PATCH
	echo -e "0000001cf\t\t// mem[000717] = 540236540237" >> PAGEN.PATCH
	echo -e "0000001d0\t\t// mem[000720] = 540240540241" >> PAGEN.PATCH
	echo -e "0000001d1\t\t// mem[000721] = 540242540243" >> PAGEN.PATCH
	echo -e "0000001d2\t\t// mem[000722] = 540244540245" >> PAGEN.PATCH
	echo -e "0000001d3\t\t// mem[000723] = 540246540247" >> PAGEN.PATCH
	echo -e "0000001d4\t\t// mem[000724] = 540250540251" >> PAGEN.PATCH
	echo -e "0000001d5\t\t// mem[000725] = 540252540253" >> PAGEN.PATCH
	echo -e "0000001d6\t\t// mem[000726] = 540254540255" >> PAGEN.PATCH
	echo -e "0000001d7\t\t// mem[000727] = 540256540257" >> PAGEN.PATCH
	echo -e "0000001d8\t\t// mem[000730] = 540260540261" >> PAGEN.PATCH
	echo -e "0000001d9\t\t// mem[000731] = 540262540263" >> PAGEN.PATCH
	echo -e "0000001da\t\t// mem[000732] = 540264540265" >> PAGEN.PATCH
	echo -e "0000001db\t\t// mem[000733] = 540266540267" >> PAGEN.PATCH
	echo -e "0000001dc\t\t// mem[000734] = 540270540271" >> PAGEN.PATCH
	echo -e "0000001dd\t\t// mem[000735] = 540272540273" >> PAGEN.PATCH
	echo -e "0000001de\t\t// mem[000736] = 540274540275" >> PAGEN.PATCH
	echo -e "0000001df\t\t// mem[000737] = 540276540277" >> PAGEN.PATCH
	echo -e "0000001e0\t\t// mem[000740] = 540300540301" >> PAGEN.PATCH
	echo -e "0000001e1\t\t// mem[000741] = 540302540303" >> PAGEN.PATCH
	echo -e "0000001e2\t\t// mem[000742] = 540304540305" >> PAGEN.PATCH
	echo -e "0000001e3\t\t// mem[000743] = 540306540307" >> PAGEN.PATCH
	echo -e "0000001e4\t\t// mem[000744] = 540310540311" >> PAGEN.PATCH
	echo -e "0000001e5\t\t// mem[000745] = 540312540313" >> PAGEN.PATCH
	echo -e "0000001e6\t\t// mem[000746] = 540314540315" >> PAGEN.PATCH
	echo -e "0000001e7\t\t// mem[000747] = 540316540317" >> PAGEN.PATCH
	echo -e "0000001e8\t\t// mem[000750] = 540320540321" >> PAGEN.PATCH
	echo -e "0000001e9\t\t// mem[000751] = 540322540323" >> PAGEN.PATCH
	echo -e "0000001ea\t\t// mem[000752] = 540324540325" >> PAGEN.PATCH
	echo -e "0000001eb\t\t// mem[000753] = 540326540327" >> PAGEN.PATCH
	echo -e "0000001ec\t\t// mem[000754] = 540330540331" >> PAGEN.PATCH
	echo -e "0000001ed\t\t// mem[000755] = 540332540333" >> PAGEN.PATCH
	echo -e "0000001ee\t\t// mem[000756] = 540334540335" >> PAGEN.PATCH
	echo -e "0000001ef\t\t// mem[000757] = 540336540337" >> PAGEN.PATCH
	echo -e "000003001\t\t// mem[030001] = 701200020000" >> PAGEN.PATCH
	echo -e "000003002\t\t// mem[030002] = 254000030600" >> PAGEN.PATCH

#
# The PATCH to DSQDA changes the timeout on the console.
#

DSQDA.PATCH : makefile
	echo -e "000000180\t\t// mem[007304] = 000000000600" >  DSQDA.PATCH
	echo -e "000000040\t\t// mem[007366] = 000000000100" >> DSQDA.PATCH

#
# Set the initial test number to something other than 1 at addr 077263
#  Start on Test 0
#

DSRPA.PATCH : makefile
	echo -e "568000000\t\t// mem[060773] = 255000000000" >  DSRPA.PATCH
	echo -e "000000000\t\t// mem[077263] = 000000000000" >> DSRPA.PATCH

#
# Patch the timout on the UART test
#

# Start with test 31
#	echo -e "@38fe"                                      >   DSDZA.PATCH
#	echo -e "000003669\t\t// mem[034376] = 000000033151" >>  DSDZA.PATCH

DSDZA.PATCH : makefile
	echo -e ""                                                           >  DSDZA.PATCH
	echo -e "@3ba8"                                                      >> DSDZA.PATCH
	echo -e "000006000\t\t// mem[035650] = 000000006000 ( 0:   50 baud)" >> DSDZA.PATCH
	echo -e "000006000\t\t// mem[035651] = 000000006000 ( 1:   75 baud)" >> DSDZA.PATCH
	echo -e "000006000\t\t// mem[035652] = 000000006000 ( 2:  110 baud)" >> DSDZA.PATCH
	echo -e "000006000\t\t// mem[035653] = 000000006000 ( 3:  134 baud)" >> DSDZA.PATCH
	echo -e "000006000\t\t// mem[035654] = 000000006000 ( 4:  150 baud)" >> DSDZA.PATCH
	echo -e "000006000\t\t// mem[035655] = 000000006000 ( 5:  300 baud)" >> DSDZA.PATCH
	echo -e "000006000\t\t// mem[035656] = 000000006000 ( 6:  600 baud)" >> DSDZA.PATCH
	echo -e "000006000\t\t// mem[035657] = 000000006000 ( 7: 1200 baud)" >> DSDZA.PATCH
	echo -e "000006000\t\t// mem[035660] = 000000006000 ( 8: 1800 baud)" >> DSDZA.PATCH
	echo -e "000006000\t\t// mem[035661] = 000000006000 ( 9: 2000 baud)" >> DSDZA.PATCH
	echo -e "000006000\t\t// mem[035662] = 000000006000 (10: 2400 baud)" >> DSDZA.PATCH
	echo -e "000006000\t\t// mem[035663] = 000000006000 (11: 3600 baud)" >> DSDZA.PATCH
	echo -e "000006000\t\t// mem[035664] = 000000006000 (12: 4800 baud)" >> DSDZA.PATCH
	echo -e "000006000\t\t// mem[035665] = 000000006000 (13: 7200 baud)" >> DSDZA.PATCH
	echo -e "0000000c0\t\t// mem[035666] = 0000000000c0 (14: 9600 baud)" >> DSDZA.PATCH
	echo -e "000006000\t\t// mem[035667] = 000000006000 (15:19200 baud)" >> DSDZA.PATCH

#
#
#

DSUBA.PATCH : makefile
	echo -e ""                                                          >  DSUBA.PATCH
	echo -e "@4e00"                                                     >> DSUBA.PATCH
	echo -e "000000000\t\t// mem[047000] = 000000000000 (memlow)"       >> DSUBA.PATCH
	echo -e "@38E5"                                                     >> DSUBA.PATCH
	echo -e "0000032d4\t\t// mem[034345] = 000000031324 (DSUBA test10)" >> DSUBA.PATCH

check :
	cat /proc/partitions
	@echo
	@echo Device is currently /dev/$(DEV)

#
# Carefully update the SD Card
#

rp06_disk : makefile $(UNIT0) $(UNIT1) $(UNIT2)
	@echo ""
	@echo "The disk" /dev/$(DEV) "is partitioned as follows:"
	@cat /proc/partitions | grep $(DEV)
	@echo ""
	@echo "This script will destroy all of the data on" /dev/$(DEV)
	@echo "This script will destroy all of the data on" /dev/$(DEV)
	@echo "This script will destroy all of the data on" /dev/$(DEV)
	@echo ""
	@echo "You've been warned.  If you don't know what you're doing.   Stop now!"
	@echo ""
	@read -r -p "Are you sure you want to do that? [YES/NO] " prompt; \
	if [[ $$prompt == "YES" || $$prompt == "yes" ]]; then \
		echo "This will take a while.  Please be patient."; \
		zcat $(UNIT0) | dd of=/dev/$(DEV) bs=512 iflag=count_bytes oflag=seek_bytes count=309700K seek=0G; \
		zcat $(UNIT1) | dd of=/dev/$(DEV) bs=512 iflag=count_bytes oflag=seek_bytes count=309700K seek=1G; \
		zcat $(UNIT2) | dd of=/dev/$(DEV) bs=512 iflag=count_bytes oflag=seek_bytes count=309700K seek=2G; \
        else \
		echo "You must answer YES to write to SD Card!"; \
        fi

crc16_tb: crc16_tb.v ../../ks10/utils/crc16.v
	iverilog -W all -g2012 -s crc16_tb -o crc16_tb.vvp $?
	vvp crc16_tb.vvp

#
# The SD Card Simulator uses a seperate file for each of the devices
#   $fseek() can't seek a 8GB file so we split it up.
#   These are the disk images
#

unit0.dsk : makefile $(UNIT0)
	zcat $(UNIT0) > unit0.dsk

unit1.dsk : makefile $(UNIT1)
	zcat $(UNIT1) > unit1.dsk

unit2.dsk : makefile $(UNIT2)
	zcat $(UNIT2) > unit2.dsk

unit3.dsk : makefile $(UNIT3)
	zcat $(UNIT3) > unit3.dsk

unit4.dsk : makefile $(UNIT4)
	zcat $(UNIT4) > unit4.dsk

unit5.dsk : makefile $(UNIT5)
	zcat $(UNIT5) > unit5.dsk

unit6.dsk : makefile $(UNIT6)
	zcat $(UNIT6) > unit6.dsk

unit7.dsk : makefile $(UNIT7)
	zcat $(UNIT7) > unit7.dsk

sim_disk : unit0.dsk unit1.dsk unit2.dsk unit3.dsk unit4.dsk unit5.dsk unit6.dsk unit7.dsk

clean :	makefile
	rcsclean *
	rm -rf unit0.dsk unit1.dsk unit2.dsk unit3.dsk unit4.dsk unit5.dsk unit6.dsk unit7.dsk
