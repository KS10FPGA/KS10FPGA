PROJECT := ks10

RTL       := rtl
ISE       := ise
XILDIR    := `cygpath -u '$(XILINX)'`
FUSE      := $(XILDIR)/ISE_DS/ISE/bin/nt/fuse.exe
WCFG      := ks10_useriot.wcfg

PRJFILE   := $(PROJECT).prj
TESTBENCH := $(PROJECT)_testbench
WORK      := work.testbench

#LOAD      := MAINDEC-10-DSKAA.SEQ
#LOAD      := MAINDEC-10-DSKAB.SEQ
#LOAD      := MAINDEC-10-DSKAC.SEQ
#LOAD      := MAINDEC-10-DSKAD.SEQ
#LOAD      := MAINDEC-10-DSKAE.SEQ
#LOAD      := MAINDEC-10-DSKAF.SEQ
#LOAD      := MAINDEC-10-DSKAG.SEQ
#LOAD      := MAINDEC-10-DSKAH.SEQ		# runs 3.4 ms
#LOAD      := MAINDEC-10-DSKAI.SEQ
#LOAD      := MAINDEC-10-DSKAJ.SEQ
#LOAD      := MAINDEC-10-DSKAK.SEQ
#LOAD      := MAINDEC-10-DSKAL.SEQ
#LOAD      := MAINDEC-10-DSKAM.SEQ
#LOAD      := MAINDEC-10-DSKBA.SEQ		# FAIL
#LOAD      := MAINDEC-10-DSKCA.SEQ
#LOAD      := MAINDEC-10-DSKCB.SEQ
#LOAD      := MAINDEC-10-DSKCC.SEQ
#LOAD      := MAINDEC-10-DSKCD.SEQ
#LOAD      := MAINDEC-10-DSKCE-RD00.SEQ
LOAD      := MAINDEC-10-DSKCF-RD00.SEQ	
#LOAD      := MAINDEC-10-DSKEA-RD00.SEQ

#LOAD     := MAINDEC-10-DSDZA.SEQ
#LOAD     := fixed.SEQ
#LOAD     := MAINDEC-10-DSKCG.fixed.txt
#LOAD     := MAINDEC-10-DSKCG.txt

#LOAD     := smmon.txt

SRC := \
    	$(RTL)/ks10/utils/utils.v \
	$(RTL)/ks10/cpu/useq/crom.v \
	$(RTL)/ks10/cpu/useq/drom.v \
	$(RTL)/ks10/cpu/useq/skip.v \
	$(RTL)/ks10/cpu/useq/stack.v \
	$(RTL)/ks10/cpu/useq/dispatch.v \
	$(RTL)/ks10/cpu/useq/useq.v \
	$(RTL)/ks10/cpu/alu.v \
	$(RTL)/ks10/cpu/apr.v \
	$(RTL)/ks10/cpu/bus.v \
	$(RTL)/ks10/cpu/byte_disp.v \
	$(RTL)/ks10/cpu/dbm.v \
	$(RTL)/ks10/cpu/dbus.v \
	$(RTL)/ks10/cpu/debug.v \
	$(RTL)/ks10/cpu/intf.v \
	$(RTL)/ks10/cpu/intr.v \
	$(RTL)/ks10/cpu/iolatch.v \
	$(RTL)/ks10/cpu/ni_disp.v \
	$(RTL)/ks10/cpu/pager.v \
	$(RTL)/ks10/cpu/pcflags.v \
	$(RTL)/ks10/cpu/pf_disp.v \
	$(RTL)/ks10/cpu/pxct.v \
	$(RTL)/ks10/cpu/ram1kx36.v \
	$(RTL)/ks10/cpu/ramfile.v \
	$(RTL)/ks10/cpu/regir.v \
	$(RTL)/ks10/cpu/scad.v \
	$(RTL)/ks10/cpu/timer.v \
	$(RTL)/ks10/cpu/timing.v \
	$(RTL)/ks10/cpu/vma.v \
	$(RTL)/ks10/cpu/cpu.v \
	$(RTL)/ks10/csl/csl.v \
	$(RTL)/ks10/mem/mem.v \
	$(RTL)/ks10/arb/arb.v \
	$(RTL)/ks10/uba/dz11/uart/uart_brg.v \
	$(RTL)/ks10/uba/dz11/uart/uart_rx.v \
	$(RTL)/ks10/uba/dz11/uart/uart_tx.v \
	$(RTL)/ks10/uba/dz11/uart/uart_bufrx.v \
	$(RTL)/ks10/uba/dz11/uart/uart_buftx.v \
	$(RTL)/ks10/uba/dz11/dzfifo.v \
	$(RTL)/ks10/uba/dz11/dz11.v \
	$(RTL)/ks10/uba/rh11/sd/sd.v \
	$(RTL)/ks10/uba/rh11/sd/sdspi.v \
	$(RTL)/ks10/uba/rh11/rpxx.v \
	$(RTL)/ks10/uba/rh11/sdaddr.v \
	$(RTL)/ks10/uba/rh11/rh11.v \
	$(RTL)/ks10/uba/uba.v \
	$(RTL)/ks10/ks10.v \
	$(RTL)/esm/esm_csl.v \
	$(RTL)/esm/esm_ks10.v \
	$(RTL)/esm/esm_testbench.v

#	$(RTL)/uba/rh11/sd/sd.v \


INC := \
	$(RTL)/ks10/cpu/useq/crom.vh  \
	$(RTL)/ks10/cpu/useq/drom.vh  \
	$(RTL)/ks10/cpu/alu.vh \
	$(RTL)/ks10/cpu/apr.vh \
	$(RTL)/ks10/cpu/pager.vh \
	$(RTL)/ks10/cpu/pcflags.vh \
	$(RTL)/ks10/cpu/pxct.vh \
	$(RTL)/ks10/cpu/regir.vh \
	$(RTL)/ks10/cpu/vma.vh \
	$(RTL)/ks10/uba/dz11/uart/uart_brg.vh \
	$(RTL)/ks10/uba/dz11/dz11.vh \
	$(RTL)/ks10/uba/rh11/sd/sdspi.vh \
	$(RTL)/ks10/uba/rh11/sd/sd.vh \
	$(RTL)/ks10/uba/rh11/rpxx.vh \
	$(RTL)/ks10/uba/rh11/rh11.vh \
	$(RTL)/ks10/uba/uba.vh \
	$(RTL)/ks10/ks10.vh

DAT := \
	$(RTL)/ks10/cpu/useq/crom.dat \
	$(RTL)/ks10/cpu/useq/drom.dat \
	$(RTL)/testbench/ssram.dat

DOC := \
	$(RTL)/status.txt

UCF := \
	$(RTL)/esm/esm_ks10.ucf

BLD := \
	$(ISE)/ks10.xise \
	$(ISE)/ks10.gise \
	$(ISE)/ks10.wcfg

asdf :  $(INC) $(SRC) $(BLD) $(DAT) $(UCF) $(DOC)
	echo $(INC) $(SRC) $(BLD) $(DAT) $(UCF) $(DOC)

$(RTL)/ks10/cpu/useq/crom.dat  : $(RTL)/ks10/cpu/useq/ks10.mcr $(RTL)/ks10/cpu/useq/crom.awk makefile
	awk -f $(RTL)/ks10/cpu/useq/crom.awk $(RTL)/ks10/cpu/useq/ks10.mcr > $(RTL)/ks10/cpu/useq/crom.dat

$(RTL)/ks10/cpu/useq/drom.dat  : $(RTL)/ks10/cpu/useq/ks10.mcr $(RTL)/ks10/cpu/useq/drom.awk makefile
	awk -f $(RTL)/ks10/cpu/useq/drom.awk $(RTL)/ks10/cpu/useq/ks10.mcr > $(RTL)/ks10/cpu/useq/drom.dat

$(RTL)/testbench/ssram.dat : $(RTL)/testbench/$(LOAD) $(RTL)/testbench/ssram.awk makefile
	awk -f $(RTL)/testbench/ssram.awk -vfilename=$(LOAD) $(RTL)/testbench/$(LOAD) > $(RTL)/testbench/ssram.dat

clean: 
	rcsclean $(RTL)/*
	rcsclean $(RTL)/testbench/*
	rcsclean $(RTL)/esm/*
	rcsclean $(RTL)/ks10/*
	rcsclean $(RTL)/ks10/arb/*
	rcsclean $(RTL)/ks10/csl/*
	rcsclean $(RTL)/ks10/cpu/*
	rcsclean $(RTL)/ks10/mem/*
	rcsclean $(RTL)/ks10/utils/*
	rcsclean $(RTL)/ks10/uba/dz11/uart/*
	rcsclean $(RTL)/ks10/uba/dz11/*
	rcsclean $(RTL)/ks10/uba/rh11/sd/*
	rcsclean $(RTL)/ks10/uba/rh11/*
	rcsclean $(RTL)/ks10/uba/*
	rcsclean $(RTL)/ks10/cpu/useq/*
	rm -f    $(RTL)/ks10/cpu/useq/*.dat
	rm -f    $(RTL)/testbench/*.dat
	find . -type f -name "*~" | xargs rm -fv

archive_src: $(SRC)
	tar -czvf ks10_src_`date '+%y%m%d'`.tgz $(SRC)

archive_all:
	tar -czvf ks10_all_`date '+%y%m%d'`.tgz *

$(ISE)/$(PRJFILE) : makefile
	echo "Creating "$(ISE)/$(PRJFILE) > /dev/stderr
	echo "" > $@;
	for FILE in $(SRC); \
	do \
	    echo 'verilog work "../'$$FILE'"' >> $@; \
	done

$(ISE)/$(TESTBENCH) : $(ISE)/$(PRJFILE) makefile
	cd ise; \
	$(FUSE) \
	-intstyle ise \
	-incremental \
	-prj $(PRJFILE) \
	-o $(TESTBENCH) \
	work.testbench

test : $(ISE)/$(TESTBENCH).exe
	$(ISE)/$(TESTBENCH).exe \
	-gui \
	-intstyle ise \
	-tclbatch $(TESTBENCH).cmd \
	-wdb $(TESTBENCH).wdb


#./t10backup.exe   -x smmon.sav -f ks_diag_gs.tap

#	-prj testbench_beh.prj \
#	-lib unisims_ver \
#	-lib unimacro_ver \
#	-lib xilinxcorelib_ver \
#	-lib secureip \
#	echo 'verilog work "C:/Xilinx/13.1/ISE_DS/ISE//verilog/src/glbl.v"' >> $@
