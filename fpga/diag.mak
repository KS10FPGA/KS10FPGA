#******************************************************************************
#
# KS-10 Processor
#
# Brief
#    Diagnostic tape build rules
#
# File
#    diag.mak
#
# Author
#    Rob Doyle - doyle (at) cox (dot) net
#
#******************************************************************************
#
# Copyright (C) 2022 Rob Doyle
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
# Unzip diagnostic tape
#

$(DIAG_TAPE) : $(DIAG_TAPE).gz
	zcat $(DIAG_TAPE).gz > $(DIAG_TAPE)

#
# Generic rule for building most diagnostics. There are some special
# rules below for diagnostics that require special handling.
#

ALL_DAT := \
	$(TMP_DIR)/dskaa.dat \
	$(TMP_DIR)/dskab.dat \
	$(TMP_DIR)/dskac.dat \
	$(TMP_DIR)/dskad.dat \
	$(TMP_DIR)/dskae.dat \
	$(TMP_DIR)/dskaf.dat \
	$(TMP_DIR)/dskag.dat \
	$(TMP_DIR)/dskah.dat \
	$(TMP_DIR)/dskai.dat \
	$(TMP_DIR)/dskaj.dat \
	$(TMP_DIR)/dskak.dat \
	$(TMP_DIR)/dskal.dat \
	$(TMP_DIR)/dskam.dat \
	$(TMP_DIR)/dskba.dat \
	$(TMP_DIR)/dskca.dat \
	$(TMP_DIR)/dskcb.dat \
	$(TMP_DIR)/dskcc.dat \
	$(TMP_DIR)/dskcd.dat \
	$(TMP_DIR)/dskce.dat \
	$(TMP_DIR)/dskcf.dat \
	$(TMP_DIR)/dskcg.dat \
	$(TMP_DIR)/dskda.dat \
	$(TMP_DIR)/dskea.dat \
	$(TMP_DIR)/dskeb.dat \
	$(TMP_DIR)/dskec.dat \
	$(TMP_DIR)/dskfa.dat \
	$(TMP_DIR)/dsdua.dat \
	$(TMP_DIR)/dskma.dat \
	$(TMP_DIR)/dslpa.dat \
	$(TMP_DIR)/dslta.dat \
	$(TMP_DIR)/dsmma.dat \
	$(TMP_DIR)/dsmmb.dat \
	$(TMP_DIR)/dsmmc.dat \
	$(TMP_DIR)/dsmmd.dat \
	$(TMP_DIR)/dsrma.dat \
	$(TMP_DIR)/dsrmb.dat \
	$(TMP_DIR)/dsrpa.dat \

#
# Note: in the rule below, '$(basename $(@F))' expands into 'dskaa', or 'dskab',
# or whatever the target diagnostic name is (without the directory name or '.dat'
# extension).
#

$(ALL_DAT) : $(T10BACKUP) $(DIAG_TAPE) $(SAV2VERILOG) $(TMP_DIR)/dsqda.dat $(TMP_DIR)/dsqdb.dat $(TMP_DIR)/dsqdc.dat $(TMP_DIR)/dsqda.patch.dat
	cd $(TMP_DIR); \
	../$(T10BACKUP) -i -x diagnostics..$(basename $(@F)).sav -f ../$(DIAG_TAPE); \
	../$(SAV2VERILOG) $(basename $(@F)).sav $(basename $(@F)).tmp.dat; \
	cat dsqda.dat dsqdb.dat dsqdc.dat $(basename $(@F)).tmp.dat dsqda.patch.dat | awk -f ../$(MERGE18) -vfilename=$(basename $(@F)).dat > $(basename $(@F)).dat; \
	rm -f $(basename $(@F)).sav $(basename $(@F)).tmp.dat

#
# DSDZA (DZ11 Diagnostics)
#
# The DZ11 needs patched because the diagnostic uses software timing loops
# to verify the baud rate. The KS10 FPGA is significantly faster than the
# DEC KS10 and the timing has to be modified accordingly.
#

$(TMP_DIR)/dsdza.dat : $(T10BACKUP) $(DIAG_TAPE) $(SAV2VERILOG) $(TMP_DIR)/dsqda.dat $(TMP_DIR)/dsqdb.dat $(TMP_DIR)/dsqdc.dat $(TMP_DIR)/dsqda.patch.dat $(TMP_DIR)/dsdza.patch.dat
	cd $(TMP_DIR); \
	../$(T10BACKUP) -i -x diagnostics..dsdza.sav -f ../$(DIAG_TAPE); \
	../$(SAV2VERILOG) dsdza.sav dsdza.tmp.dat; \
	cat dsqda.dat dsqdb.dat dsqdc.dat dsdza.tmp.dat dsqda.patch.dat dsdza.patch.dat | awk -f ../$(MERGE18) -vfilename=dsdza.dat > dsdza.dat; \
	rm -f dsdza.sav dsdza.tmp.dat

#
# DSTUA (RH11/TM03/TU45 Tape Drive)
#
#  Special rule to build DSTUA
#  The listing file that I have and the executable on the diagnostic tape do not match.
#  Use the SAV file ($(MAINDEC)/latest-dstua.sav) that I got from Richard Cornwell.
#

$(TMP_DIR)/dstua.dat : $(T10BACKUP) $(DIAG_TAPE) $(SAV2VERILOG) $(TMP_DIR)/dsqda.dat $(TMP_DIR)/dsqdb.dat $(TMP_DIR)/dsqdc.dat $(TMP_DIR)/dsqda.patch.dat $(MAINDEC)/latest-dstua.sav
	cd $(TMP_DIR); \
	../$(SAV2VERILOG) ../$(MAINDEC)/latest-dstua.sav dstua.tmp.dat; \
	cat dsqda.dat dsqdb.dat dsqdc.dat dstua.tmp.dat dsqda.patch.dat | awk -f ../$(MERGE18) -vfilename=dstua.dat > dstua.dat; \
	rm -f dstua.tmp.dat

#
# DSTUB (Tape Drive)
#
#  Special rule to build DSTUB
#  The listing file that I have and the executable on the diagnostic tape do not match.
#  Use the SAV file ($(MAINDEC)/latest-dstub.sav) that I got from Richard Cornwell.
#

$(TMP_DIR)/dstub.dat : $(T10BACKUP) $(DIAG_TAPE) $(SAV2VERILOG) $(TMP_DIR)/dsqda.dat $(TMP_DIR)/dsqdb.dat $(TMP_DIR)/dsqdc.dat $(TMP_DIR)/dsqda.patch.dat $(MAINDEC)/latest-dstub.sav
	cd $(TMP_DIR); \
	../$(SAV2VERILOG) ../$(MAINDEC)/latest-dstub.sav dstub.tmp.dat; \
	cat dsqda.dat dsqdb.dat dsqdc.dat dstub.tmp.dat dsqda.patch.dat | awk -f ../$(MERGE18) -vfilename=dstub.dat > dstub.dat; \
	rm -f dstub.tmp.dat

#
# DSUBA (Unibus Adapter)
#
#  DSUBA can be patched to set the starting diagnostic number.
#  This was used during debugging the UBA and UBEs.
#

$(TMP_DIR)/dsuba.dat : $(T10BACKUP) $(DIAG_TAPE) $(SAV2VERILOG) $(TMP_DIR)/dsqda.dat $(TMP_DIR)/dsqdb.dat $(TMP_DIR)/dsqdc.dat $(TMP_DIR)/dsqda.patch.dat
	cd $(TMP_DIR); \
	../$(T10BACKUP) -i -x diagnostics..dsuba.sav -f ../$(DIAG_TAPE); \
	../$(SAV2VERILOG) dsuba.sav dsuba.tmp.dat; \
	cat dsqda.dat dsqdb.dat dsqdc.dat dsuba.tmp.dat dsqda.patch.dat dsuba.patch.dat | awk -f ../$(MERGE18) -vfilename=dsuba.dat > dsuba.dat; \
	rm -f dsuba.sav dsuba.tmp.dat

#
# DSQDA (SUBSM)
#

$(TMP_DIR)/dsqda.dat : $(T10BACKUP) $(DIAG_TAPE)
	mkdir -p $(TMP_DIR)
	cd $(TMP_DIR); \
	../$(T10BACKUP) -i -x diagnostics..subsm.sav -f ../$(DIAG_TAPE); \
	../$(SAV2VERILOG) subsm.sav dsqda.dat; \
	rm -f subsm.sav

#
# DSQDB (SMDDT)
#

$(TMP_DIR)/dsqdb.dat : $(T10BACKUP) $(DIAG_TAPE) $(TMP_DIR)/dsqda.dat
	cd $(TMP_DIR); \
	../$(T10BACKUP) -i -x diagnostics..smddt.sav -f ../$(DIAG_TAPE); \
	../$(SAV2VERILOG) smddt.sav dsqdb.dat; \
	rm -f smddt.sav

#
# DSQDC (SMMON)
#

$(TMP_DIR)/dsqdc.dat : $(T10BACKUP) $(DIAG_TAPE) $(TMP_DIR)/dsqdb.dat
	cd $(TMP_DIR); \
	../$(T10BACKUP) -i -x diagnostics..smmon.sav -f ../$(DIAG_TAPE); \
	../$(SAV2VERILOG) smmon.sav dsqdc.dat; \
	rm -f smmon.sav

#
# Patch DSQDA to change the timeout on the console.
#

$(TMP_DIR)/dsqda.patch.dat : makefile
	echo -e "000000180\t\t// mem[007304] = 000000000600" >  $(TMP_DIR)/dsqda.patch.dat
	echo -e "000000040\t\t// mem[007366] = 000000000100" >> $(TMP_DIR)/dsqda.patch.dat

#
# Enable paging
#  Unity map table
#  WREBR 030000
#  JRST  030600
#

$(TMP_DIR)/paging.patch.dat : makefile
	echo -e "000000180\t\t// mem[000600] = 540000540001" >  $(TMP_DIR)/pagen.patch.dat
	echo -e "000000181\t\t// mem[000601] = 540002540003" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "000000182\t\t// mem[000602] = 540004540005" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "000000183\t\t// mem[000603] = 540006540007" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "000000184\t\t// mem[000604] = 540010540011" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "000000185\t\t// mem[000605] = 540012540013" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "000000186\t\t// mem[000606] = 540014540015" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "000000187\t\t// mem[000607] = 540016540017" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "000000188\t\t// mem[000610] = 540020540021" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "000000189\t\t// mem[000611] = 540022540023" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "00000018a\t\t// mem[000612] = 540024540025" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "00000018b\t\t// mem[000613] = 540026540027" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "00000018c\t\t// mem[000614] = 540030540031" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "00000018d\t\t// mem[000615] = 540032540033" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "00000018e\t\t// mem[000616] = 540034540035" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "00000018f\t\t// mem[000617] = 540036540037" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "000000190\t\t// mem[000620] = 540040540041" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "000000191\t\t// mem[000621] = 540042540043" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "000000192\t\t// mem[000622] = 540044540045" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "000000193\t\t// mem[000623] = 540046540047" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "000000194\t\t// mem[000624] = 540050540051" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "000000195\t\t// mem[000625] = 540052540053" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "000000196\t\t// mem[000626] = 540054540055" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "000000197\t\t// mem[000627] = 540056540057" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "000000198\t\t// mem[000630] = 540060540061" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "000000199\t\t// mem[000631] = 540062540063" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "00000019a\t\t// mem[000632] = 540064540065" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "00000019b\t\t// mem[000633] = 540066540067" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "00000019c\t\t// mem[000634] = 540070540071" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "00000019d\t\t// mem[000635] = 540072540073" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "00000019e\t\t// mem[000636] = 540074540075" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "00000019f\t\t// mem[000637] = 540076540077" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001a0\t\t// mem[000640] = 540100540101" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001a1\t\t// mem[000641] = 540102540103" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001a2\t\t// mem[000642] = 540104540105" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001a3\t\t// mem[000643] = 540106540107" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001a4\t\t// mem[000644] = 540110540111" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001a5\t\t// mem[000645] = 540112540113" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001a6\t\t// mem[000646] = 540114540115" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001a7\t\t// mem[000647] = 540116540117" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001a8\t\t// mem[000650] = 540120540121" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001a9\t\t// mem[000651] = 540122540123" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001aa\t\t// mem[000652] = 540124540125" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001ab\t\t// mem[000653] = 540126540127" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001ac\t\t// mem[000654] = 540130540131" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001ad\t\t// mem[000655] = 540132540133" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001ae\t\t// mem[000656] = 540134540135" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001af\t\t// mem[000657] = 540136540137" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001b0\t\t// mem[000660] = 540140540141" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001b1\t\t// mem[000661] = 540142540143" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001b2\t\t// mem[000662] = 540144540145" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001b3\t\t// mem[000663] = 540146540147" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001b4\t\t// mem[000664] = 540150540151" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001b5\t\t// mem[000665] = 540152540153" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001b6\t\t// mem[000666] = 540154540155" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001b7\t\t// mem[000667] = 540156540157" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001b8\t\t// mem[000670] = 540160540161" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001b9\t\t// mem[000671] = 540162540163" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001ba\t\t// mem[000672] = 540164540165" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001bb\t\t// mem[000673] = 540166540167" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001bc\t\t// mem[000674] = 540170540171" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001bd\t\t// mem[000675] = 540172540173" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001be\t\t// mem[000676] = 540174540175" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001bf\t\t// mem[000677] = 540176540177" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001c0\t\t// mem[000700] = 540200540201" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001c1\t\t// mem[000701] = 540202540203" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001c2\t\t// mem[000702] = 540204540205" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001c3\t\t// mem[000703] = 540206540207" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001c4\t\t// mem[000704] = 540210540211" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001c5\t\t// mem[000705] = 540212540213" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001c6\t\t// mem[000706] = 540214540215" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001c7\t\t// mem[000707] = 540216540217" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001c8\t\t// mem[000710] = 540220540221" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001c9\t\t// mem[000711] = 540222540223" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001ca\t\t// mem[000712] = 540224540225" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001cb\t\t// mem[000713] = 540226540227" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001cc\t\t// mem[000714] = 540230540231" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001cd\t\t// mem[000715] = 540232540233" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001ce\t\t// mem[000716] = 540234540235" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001cf\t\t// mem[000717] = 540236540237" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001d0\t\t// mem[000720] = 540240540241" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001d1\t\t// mem[000721] = 540242540243" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001d2\t\t// mem[000722] = 540244540245" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001d3\t\t// mem[000723] = 540246540247" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001d4\t\t// mem[000724] = 540250540251" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001d5\t\t// mem[000725] = 540252540253" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001d6\t\t// mem[000726] = 540254540255" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001d7\t\t// mem[000727] = 540256540257" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001d8\t\t// mem[000730] = 540260540261" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001d9\t\t// mem[000731] = 540262540263" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001da\t\t// mem[000732] = 540264540265" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001db\t\t// mem[000733] = 540266540267" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001dc\t\t// mem[000734] = 540270540271" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001dd\t\t// mem[000735] = 540272540273" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001de\t\t// mem[000736] = 540274540275" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001df\t\t// mem[000737] = 540276540277" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001e0\t\t// mem[000740] = 540300540301" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001e1\t\t// mem[000741] = 540302540303" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001e2\t\t// mem[000742] = 540304540305" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001e3\t\t// mem[000743] = 540306540307" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001e4\t\t// mem[000744] = 540310540311" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001e5\t\t// mem[000745] = 540312540313" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001e6\t\t// mem[000746] = 540314540315" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001e7\t\t// mem[000747] = 540316540317" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001e8\t\t// mem[000750] = 540320540321" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001e9\t\t// mem[000751] = 540322540323" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001ea\t\t// mem[000752] = 540324540325" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001eb\t\t// mem[000753] = 540326540327" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001ec\t\t// mem[000754] = 540330540331" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001ed\t\t// mem[000755] = 540332540333" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001ee\t\t// mem[000756] = 540334540335" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "0000001ef\t\t// mem[000757] = 540336540337" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "000003001\t\t// mem[030001] = 701200020000" >> $(TMP_DIR)/pagen.patch.dat
	echo -e "000003002\t\t// mem[030002] = 254000030600" >> $(TMP_DIR)/pagen.patch.dat

#
# Patch the timout on the UART test
#
# The DZ11 needs patched because the diagnostic uses software timing loops
# to verify the baud rate. The KS10 FPGA is significantly faster than the
# DEC KS10 and the timing has to be modified accordingly.
#

$(TMP_DIR)/dsdza.patch.dat : makefile
	echo -e ""                                                           >  $(TMP_DIR)/dsdza.patch.dat
	echo -e "@3ba8"                                                      >> $(TMP_DIR)/dsdza.patch.dat
	echo -e "000006000\t\t// mem[035650] = 000000006000 ( 0:   50 baud)" >> $(TMP_DIR)/dsdza.patch.dat
	echo -e "000006000\t\t// mem[035651] = 000000006000 ( 1:   75 baud)" >> $(TMP_DIR)/dsdza.patch.dat
	echo -e "000006000\t\t// mem[035652] = 000000006000 ( 2:  110 baud)" >> $(TMP_DIR)/dsdza.patch.dat
	echo -e "000006000\t\t// mem[035653] = 000000006000 ( 3:  134 baud)" >> $(TMP_DIR)/dsdza.patch.dat
	echo -e "000006000\t\t// mem[035654] = 000000006000 ( 4:  150 baud)" >> $(TMP_DIR)/dsdza.patch.dat
	echo -e "000006000\t\t// mem[035655] = 000000006000 ( 5:  300 baud)" >> $(TMP_DIR)/dsdza.patch.dat
	echo -e "000006000\t\t// mem[035656] = 000000006000 ( 6:  600 baud)" >> $(TMP_DIR)/dsdza.patch.dat
	echo -e "000006000\t\t// mem[035657] = 000000006000 ( 7: 1200 baud)" >> $(TMP_DIR)/dsdza.patch.dat
	echo -e "000006000\t\t// mem[035660] = 000000006000 ( 8: 1800 baud)" >> $(TMP_DIR)/dsdza.patch.dat
	echo -e "000006000\t\t// mem[035661] = 000000006000 ( 9: 2000 baud)" >> $(TMP_DIR)/dsdza.patch.dat
	echo -e "000006000\t\t// mem[035662] = 000000006000 (10: 2400 baud)" >> $(TMP_DIR)/dsdza.patch.dat
	echo -e "000006000\t\t// mem[035663] = 000000006000 (11: 3600 baud)" >> $(TMP_DIR)/dsdza.patch.dat
	echo -e "000006000\t\t// mem[035664] = 000000006000 (12: 4800 baud)" >> $(TMP_DIR)/dsdza.patch.dat
	echo -e "000006000\t\t// mem[035665] = 000000006000 (13: 7200 baud)" >> $(TMP_DIR)/dsdza.patch.dat
	echo -e "0000000c0\t\t// mem[035666] = 0000000000c0 (14: 9600 baud)" >> $(TMP_DIR)/dsdza.patch.dat
	echo -e "000006000\t\t// mem[035667] = 000000006000 (15:19200 baud)" >> $(TMP_DIR)/dsdza.patch.dat

#
# Start with different tests
#
#	echo -e "000003669\t\t// mem[034376] = 000000033151"                 >>  $(TMP_DIR)/dsdza.patch.dat

#
# Patches for DSUBA
#

$(TMP_DIR)/dsuba.patch.dat : makefile
	echo -e ""                                                          >  $(TMP_DIR)/dsuba.patch.dat
#
# Start with different tests
#
#	echo -e "000000000\t\t// mem[047000] = 000000000000 (memlow)"       >> $(TMP_DIR)/dsuba.patch.dat
#	echo -e "000000000\t\t// mem[034345] = 000000031372 (DSUBA TEST11)" >> $(TMP_DIR)/dsuba.patch.dat
#	echo -e "000000000\t\t// mem[034345] = 000000031721 (DSUBA TEST15)" >> $(TMP_DIR)/dsuba.patch.dat
#	echo -e "000000000\t\t// mem[034345] = 000000032056 (DSUBA TEST17)" >> $(TMP_DIR)/dsuba.patch.dat
#	echo -e "000000000\t\t// mem[034345] = 000000032772 (DSUBA TEST33)" >> $(TMP_DIR)/dsuba.patch.dat
#	echo -e "000000000\t\t// mem[034345] = 000000033154 (DSUBA TEST37)" >> $(TMP_DIR)/dsuba.patch.dat
#	echo -e "000000000\t\t// mem[034345] = 000000033375 (DSUBA TEST44)" >> $(TMP_DIR)/dsuba.patch.dat
#	echo -e "000000000\t\t// mem[034345] = 000000033474 (DSUBA TEST46)" >> $(TMP_DIR)/dsuba.patch.dat
#	echo -e "000000000\t\t// mem[034345] = 000000033526 (DSUBA TEST47)" >> $(TMP_DIR)/dsuba.patch.dat
#
