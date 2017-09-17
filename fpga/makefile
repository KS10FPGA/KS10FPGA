#******************************************************************************
#
# KS-10 Processor
#
# Brief
#    FPGA Build Rules
#
# File
#    makefile
#
# Author
#    Rob Doyle - doyle (at) cox (dot) net
#
#******************************************************************************
#
# Copyright (C) 2013-2016 Rob Doyle
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
# Project name.   Also top-level entity name (upper case)
#

PROJECT  := esm_ks10
RTLTOP   := ESM_KS10
SIMTOP   := testbench

#
# FPGA partnumber
#

PART     := xc6slx45-2-fgg676

#
# What system?
#

UNAME    := $(shell uname -s)

#
# Xilinx tools.  Convert $(XILINX) to unix if host is Cygwin
#

ifneq (, $(findstring CYGWIN, $(UNAME)))
    XILDIR   := $(shell cygpath -u '$(XILINX)')
    XILEXE   := $(XILDIR)/ISE_DS/ISE/bin/nt64
    BITGEN   := $(XILEXE)/bitgen
    FUSE     := $(XILEXE)/fuse
    MAP      := $(XILEXE)/map
    NGD      := $(XILEXE)/ngdbuild
    PAR      := $(XILEXE)/par
    PROMGEN  := $(XILEXE)/promgen
    IMPACT   := $(XILEXE)/impact
    TRCE     := $(XILEXE)/trce
    XST      := $(XILEXE)/xst
    INTSTYLE := ise
    XILPATH  := $(XILDIR)/ISE_DS/ISE/bin/nt64:$(XILDIR)/ISE_DS/ISE/lib/nt64:$(XILDIR)/ISE_DS/common/bin/nt64:$(XILDIR)/ISE_DS/common/lib/nt64
    UNISIMS  := $(XILDIR)/ISE_DS/PlanAhead/verilog/src/unisims
else
    XILDIR   := $(XILINX)
    XILDIR   := /opt/Xilinx/14.7
    XILEXE   := $(XILDIR)/ISE_DS/ISE/bin/lin64
    BITGEN   := $(XILEXE)/bitgen
    FUSE     := $(XILEXE)/fuse
    MAP      := $(XILEXE)/map
    NGD      := $(XILEXE)/ngdbuild
    PAR      := $(XILEXE)/par
    PROMGEN  := $(XILEXE)/promgen
    IMPACT   := $(XILEXE)/impact
    TRCE     := $(XILEXE)/trce
    XST      := $(XILEXE)/xst
    INTSTYLE := ise
    XILPATH  := $(XILDIR)/ISE_DS/ISE/bin/lin64:$(XILDIR)/ISE_DS/ISE/lib/lin64:$(XILDIR)/ISE_DS/common/bin/lin64:$(XILDIR)/ISE_DS/common/lib/lin64
    UNISIMS  := $(XILDIR)/ISE_DS/PlanAhead/verilog/src/unisims
endif

#
# Project structure
#

ISE       := esm_top/ise
MAINDEC   := ../maindec
TESTBENCH := esm_top/testbench
QUESTA    := esm_top/questa

#
# Other tools
#

IVERILOG := iverilog
VVP      := vvp
CLOC     := cloc-1.62.exe
OBJCOPY  := objcopy

#
# Fix pipelining (the tee command)
#
# Quoting the bash manual -
# Each command in a pipeline is executed in its own subshell.  The exit status
# of a pipeline is the exit status of the last command in the pipeline, unless
# the pipefail option is enabled. If pipefail is enabled, the pipeline’s return
# status is the value of the last (rightmost) command to exit with a non-zero
# status, or zero if all commands exit successfully.
#

.SHELLFLAGS = -o pipefail -c

#
# Initialized Memory Contents (Simulation only)
#

#DIAG     := DSKAA		#    1.0 ms
#DIAG     := DSKAB		#    1.1 ms
#DIAG     := DSKAC		#    0.8 ms
#DIAG     := DSKAD		#    0.9 ms
#DIAG     := DSKAE		#    0.7 ms
#DIAG     := DSKAF		#    0.8 ms
#DIAG     := DSKAG		#    0.5 ms
#DIAG     := DSKAH		#   15.0 ms
#DIAG     := DSKAI		#    2.4 ms
#DIAG     := DSKAJ		#    2.8 ms
#DIAG     := DSKAK		#    4.2 ms
#DIAG     := DSKAL		#    4.7 ms
#DIAG     := DSKAM		#    2.3 ms
#DIAG     := DSKBA-RD00  	#    1.0 ms FAIL
#DIAG     := DSKCA		#    1.9 ms
#DIAG     := DSKCB		#    1.3 ms
#DIAG     := DSKCC		#    2.1 ms
#DIAG     := DSKCD		#    5.2 ms
#DIAG     := DSKCE-RD00		#    5.7 ms
#DIAG     := DSKCF-RD00		#   10.6 ms
#DIAG     := DSKCG		# 1350.0 ms FAIL
#DIAG     := DSKDA-RD00		#    5.3 ms FAIL
#DIAG     := DSKEA-RD00		# 1046.0 ms
#DIAG     := DSKEB-RD00		#  ???.? ms FAIL
#DIAG     := DSKEC-RD00		#  ???.? ms FAIL
#DIAG     := DSKFA   		#  ???.? ms FAIL
#DIAG     := DSMMA   		#  ???.? ms FAIL
#DIAG     := DSMMB   		#  ???.? ms FAIL
#DIAG     := DSMMC   		#  ???.? ms FAIL
#DIAG     := DSMMD   		#  ???.? ms FAIL
#DIAG     := DSUBA-RD00		#  138.0 ms
#DIAG     := DSDZA-RD00		# 2411.8 ms
#DIAG     := DSRPA-RD00		#  ???.? ms FAIL

DIAGBASE := $(shell echo "$(DIAG)" | sed -e 's/-.*//')     # strip the -RD00-XXXX suffix

#
# Simulator Macro Definitions
#
#   -D ENABLE_TIMER     Enable 1 ms timer.  Slows simulation.  (See testbench)
#   -D SIM_SMMON        Boot to SMMON instead of diagnostic app (See testbench)
#   -D SIM_CTY          Simulate the CTY (See testbench)
#   -D SIM_SDHC         Simulate the SDHC Card
#   -D SIM_SDHC_OFFLINE Simulate the SDHC as offline
#   -D STOP_ON_COMPLETE Stop simulation when test is complete (See debug.v)
#   -D STOP_ON_STUCK_PC Stop simulating when PC gets stuck.
#   -D DEBUG_DSKAA      Diagnostic information (See debug.v)
#   -D DEBUG=DSKAA      Diagnostic information (See debug.v)
#

SIM_ARGS := \
        -D SIM_CTY \
        -D SIM_SMMON \
        -D SIM_SDHC \
        -D ENABLE_TIMER \
        -D STOP_ON_COMPLETE \
        -D STOP_ON_STUCK_PC \
        -D DEBUG_$(DIAGBASE) \
        -D DEBUG=$(DIAGBASE) \
        -D DIAG=$(DIAG)

#
# Synthesis Macro Definitions
#
# Macro Definitions
#   -D RPXX_SIMSEEK	Simulate RPXX seek accurately but slowly
#   -D RPXX_SIMSEARCH	Simulate RPXX search accurately bus slowly
#   -D RPXX_SIMDMD	Simulate RPXX diagnostic mode
#   -D CHIPSCOPE_CPU    Instrument the CPU
#   -D CHIPSCOPE_UBA    Instrument the UBA
#   -D CHIPSCOPE_SD     Instrument the SD Controller
#   -D CHIPSCOPE_MEM    Instrument the Memory Controller
#   -D CHIPSCOPE_CSL    Instrument the Console Interface
#   -D PAGE_FAIL_TEST   Stress test PAGE FAIL logic
#

SYN_ARGS := \
	-D RPXX_SIMSEEK \
	-D RPXX_SIMDMD \
#	-D RPXX_SIMSEARCH \
#	-D PAGE_FAIL_TEST \

#
# Diagnostic Prefix
#

PREFIX := MAINDEC-10-

#
# Diagnostic Files
#

DIAG_FILES := \
        $(MAINDEC)/${PREFIX}DSKAA.SEQ \
        $(MAINDEC)/${PREFIX}DSKAB.SEQ \
        $(MAINDEC)/${PREFIX}DSKAC.SEQ \
        $(MAINDEC)/${PREFIX}DSKAD.SEQ \
        $(MAINDEC)/${PREFIX}DSKAE.SEQ \
        $(MAINDEC)/${PREFIX}DSKAF.SEQ \
        $(MAINDEC)/${PREFIX}DSKAG.SEQ \
        $(MAINDEC)/${PREFIX}DSKAH.SEQ \
        $(MAINDEC)/${PREFIX}DSKAI.SEQ \
        $(MAINDEC)/${PREFIX}DSKAJ.SEQ \
        $(MAINDEC)/${PREFIX}DSKAK.SEQ \
        $(MAINDEC)/${PREFIX}DSKAL.SEQ \
        $(MAINDEC)/${PREFIX}DSKAM.SEQ \
        $(MAINDEC)/${PREFIX}DSKBA.SEQ \
        $(MAINDEC)/${PREFIX}DSKCA.SEQ \
        $(MAINDEC)/${PREFIX}DSKCB.SEQ \
        $(MAINDEC)/${PREFIX}DSKCC.SEQ \
        $(MAINDEC)/${PREFIX}DSKCD.SEQ \
        $(MAINDEC)/${PREFIX}DSKCE-RD00.SEQ \
        $(MAINDEC)/${PREFIX}DSKCF-RD00.SEQ \
        $(MAINDEC)/${PREFIX}DSKCG.SEQ \
        $(MAINDEC)/${PREFIX}DSKDA-RD00.SEQ \
        $(MAINDEC)/${PREFIX}DSKEA-RD00.SEQ \
        $(MAINDEC)/${PREFIX}DSKEB.SEQ \
        $(MAINDEC)/${PREFIX}DSKEC.SEQ \
        $(MAINDEC)/${PREFIX}DSMMA.SEQ \
        $(MAINDEC)/${PREFIX}DSMMB.SEQ \
        $(MAINDEC)/${PREFIX}DSMMC.SEQ \
        $(MAINDEC)/${PREFIX}DSMMD.SEQ \
        $(MAINDEC)/${PREFIX}DSDZA-RD00.SEQ \
        $(MAINDEC)/${PREFIX}DSUBA-RD00.SEQ \
        $(MAINDEC)/${PREFIX}DSRPA-RD00.SEQ

#
# Verilog source files
#

RTL_FILES := \
	esm_top/esm_ks10.v \
	ks10/ks10.v \
	ks10/arb/arb.v \
	ks10/clk/clk.v \
	ks10/csl/csl.v \
	ks10/cpu/alu.v \
	ks10/cpu/apr.v \
	ks10/cpu/bus.v \
	ks10/cpu/disp_byte.v \
	ks10/cpu/disp_ni.v \
	ks10/cpu/disp_pf.v \
	ks10/cpu/dbm.v \
	ks10/cpu/dbus.v \
	ks10/cpu/intf.v \
	ks10/cpu/nxd.v \
	ks10/cpu/nxm.v \
	ks10/cpu/pager.v \
	ks10/cpu/pcflags.v \
	ks10/cpu/pi.v \
	ks10/cpu/pxct.v \
	ks10/cpu/ramfile.v \
	ks10/cpu/regir.v \
	ks10/cpu/scad.v \
	ks10/cpu/timer.v \
	ks10/cpu/timing.v \
	ks10/cpu/vma.v \
	ks10/cpu/cpu.v \
	ks10/cpu/useq/crom.v \
	ks10/cpu/useq/drom.v \
	ks10/cpu/useq/skip.v \
	ks10/cpu/useq/stack.v \
	ks10/cpu/useq/dispatch.v \
	ks10/cpu/useq/useq.v \
	ks10/debug/debug.v \
	ks10/dz11/uart/uart_brg.v \
	ks10/dz11/uart/uart_rx.v \
	ks10/dz11/uart/uart_tx.v \
	ks10/dz11/dzcsr.v \
	ks10/dz11/dzmsr.v \
	ks10/dz11/dztcr.v \
	ks10/dz11/dztdr.v \
	ks10/dz11/dzintr.v \
	ks10/dz11/dzrbuf.v \
	ks10/dz11/dzscan.v \
	ks10/dz11/dzuart.v \
	ks10/dz11/dz11.v \
	ks10/mem/mem.v \
	ks10/mem/memstat.v \
	ks10/rh11/rh11.v \
	ks10/rh11/rhintr.v \
	ks10/rh11/rhnem.v \
	ks10/rh11/rhba.v \
	ks10/rh11/rhdb.v \
	ks10/rh11/rhwc.v \
	ks10/rh11/rhcs1.v \
	ks10/rh11/rhcs2.v \
	ks10/rh11/rpxx/rpaddr.v \
	ks10/rh11/rpxx/rpcs1.v \
	ks10/rh11/rpxx/rpctrl.v \
	ks10/rh11/rpxx/rpda.v \
	ks10/rh11/rpxx/rpdc.v \
	ks10/rh11/rpxx/rpds.v \
	ks10/rh11/rpxx/rper1.v \
	ks10/rh11/rpxx/rper2.v \
	ks10/rh11/rpxx/rper3.v \
	ks10/rh11/rpxx/rphcrc.v \
	ks10/rh11/rpxx/rpla.v \
	ks10/rh11/rpxx/rpmr.v \
	ks10/rh11/rpxx/rpof.v \
	ks10/rh11/rpxx/rpxx.v \
	ks10/rh11/sd/sd.v \
	ks10/rh11/sd/sdspi.v \
	ks10/uba/uba.v \
	ks10/uba/ubamr.v \
	ks10/uba/ubasr.v \
	ks10/uba/ubanxd.v \
	ks10/uba/ubapage.v \
	ks10/uba/ubatmo.v \
	ks10/uba/ubaintr.v \
	ks10/utils/fifo.v \
	ks10/utils/sync.v \
	ks10/utils/clkfwd.v \
	ks10/utils/edgetrig.v

#
# Coregen Files
#  Added as required
#

CGN_FILES =

ifneq (, $(findstring CHIPSCOPE_CPU, $(SYN_ARGS)))
RTL_FILES += \
	ks10/xilinx/chipscope_cpu_ila/chipscope_cpu_ila.v \
	ks10/xilinx/chipscope_cpu_icon/chipscope_cpu_icon.v \
	ks10/xilinx/chipscope_cpu_vio/chipscope_cpu_vio.v
CGN_FILES += \
	ks10/xilinx/chipscope_cpu_ila/chipscope_cpu_ila.ngc \
	ks10/xilinx/chipscope_cpu_icon/chipscope_cpu_icon.ngc \
	ks10/xilinx/chipscope_cpu_vio/chipscope_cpu_vio.ngc
endif

ifneq (, $(findstring CHIPSCOPE_CSL, $(SYN_ARGS)))
RTL_FILES += \
	ks10/xilinx/chipscope_csl_ila/chipscope_csl_ila.v \
	ks10/xilinx/chipscope_csl_icon/chipscope_csl_icon.v
CGN_FILES += \
	ks10/xilinx/chipscope_csl_ila/chipscope_csl_ila.ngc \
	ks10/xilinx/chipscope_csl_icon/chipscope_csl_icon.ngc
endif

ifneq (, $(findstring CHIPSCOPE_MEM, $(SYN_ARGS)))
RTL_FILES += \
	ks10/xilinx/chipscope_mem_ila/chipscope_mem_ila.v \
	ks10/xilinx/chipscope_mem_icon/chipscope_mem_icon.v
CGN_FILES += \
	ks10/xilinx/chipscope_mem_ila/chipscope_mem_ila.ngc \
	ks10/xilinx/chipscope_mem_icon/chipscope_mem_icon.ngc
endif

ifneq (, $(findstring CHIPSCOPE_SD, $(SYN_ARGS)))
RTL_FILES += \
	ks10/xilinx/chipscope_sd_ila/chipscope_sd_ila.v \
	ks10/xilinx/chipscope_sd_icon/chipscope_sd_icon.v
CGN_FILES += \
	ks10/xilinx/chipscope_sd_ila/chipscope_sd_ila.ngc \
	ks10/xilinx/chipscope_sd_icon/chipscope_sd_icon.ngc
endif

ifneq (, $(findstring CHIPSCOPE_UBA, $(SYN_ARGS)))
RTL_FILES += \
	ks10/xilinx/chipscope_uba_ila/chipscope_uba_ila.v \
	ks10/xilinx/chipscope_uba_icon/chipscope_uba_icon.v
CGN_FILES += \
	ks10/xilinx/chipscope_uba_ila/chipscope_uba_ila.ngc \
	ks10/xilinx/chipscope_uba_icon/chipscope_uba_icon.ngc
endif

#
# Simulation testbench files
#

SIM_DISK := \
	$(TESTBENCH)/sdsim.dsk

SIM_FILES := \
	$(TESTBENCH)/cy7c1460av33.v \
	$(TESTBENCH)/testbench.v \
	$(TESTBENCH)/sdsim.v

SSRAM_DAT := \
	$(TESTBENCH)/$(DIAG).dat

#
# If were simulating SMMON, add the SMMON files.  Otherwise don't.
#

MON_FILES :=

ifneq (, $(findstring SIM_SMMON, $(SIM_ARGS)))

MON_FILES += \
	$(MAINDEC)/MAINDEC-10-DSQDA-RD00.SEQ \
	$(MAINDEC)/MAINDEC-10-DSQDB-RD00.SEQ \
	$(MAINDEC)/MAINDEC-10-DSQDC-RD00.SEQ

endif

#
# Verilog include files
#

INC_FILES := \
	ks10/cpu/alu.vh \
	ks10/cpu/apr.vh \
	ks10/cpu/bus.vh \
	ks10/cpu/pager.vh \
	ks10/cpu/pcflags.vh \
	ks10/cpu/pxct.vh \
	ks10/cpu/regir.vh \
	ks10/cpu/vma.vh \
	ks10/cpu/useq/crom.vh  \
	ks10/cpu/useq/drom.vh  \
	ks10/debug/debug.vh \
	ks10/debug/debug_dskah.vh \
	ks10/debug/debug_dskba.vh \
	ks10/debug/debug_dskcg.vh \
	ks10/debug/debug_dskea.vh \
	ks10/debug/debug_dskeb.vh \
	ks10/debug/debug_dskec.vh \
	ks10/debug/debug_dsuba.vh \
	ks10/debug/debug_dsdza.vh \
	ks10/debug/debug_smmon.vh \
	ks10/debug/debug_default.vh \
	ks10/dz11/dz11.vh \
	ks10/dz11/dzcsr.vh \
	ks10/dz11/dzlpr.vh \
	ks10/dz11/dzrbuf.vh \
	ks10/dz11/dztcr.vh \
	ks10/dz11/dztdr.vh \
	ks10/dz11/dzuart.vh \
	ks10/mem/memstat.vh \
	ks10/rh11/rhba.vh \
	ks10/rh11/rhdb.vh \
	ks10/rh11/rhwc.vh \
	ks10/rh11/rhcs1.vh \
	ks10/rh11/rhcs2.vh \
	ks10/rh11/rpxx/rpas.vh \
	ks10/rh11/rpxx/rpcs1.vh \
	ks10/rh11/rpxx/rpda.vh \
	ks10/rh11/rpxx/rpcc.vh \
	ks10/rh11/rpxx/rpdc.vh \
	ks10/rh11/rpxx/rpds.vh \
	ks10/rh11/rpxx/rper1.vh \
	ks10/rh11/rpxx/rper2.vh \
	ks10/rh11/rpxx/rper3.vh \
	ks10/rh11/rpxx/rphcrc.vh \
	ks10/rh11/rpxx/rpof.vh \
	ks10/rh11/rpxx/rpla.vh \
	ks10/rh11/rpxx/rpmr.vh \
	ks10/rh11/rpxx/rpxx.vh \
	ks10/rh11/sd/sdspi.vh \
	ks10/rh11/sd/sd.vh \
	ks10/rh11/rh11.vh \
	ks10/uba/uba.vh \
	ks10/uba/ubamr.vh \
	ks10/uba/ubasr.vh \
	ks10/uba/ubabus.vh \
	ks10/uba/ubapage.vh \
	ks10/ks10.vh

#
# Microcode and memory initialization
#

CROM_DAT := \
	ks10/cpu/useq/crom.dat

DROM_DAT := \
	ks10/cpu/useq/drom.dat

DAT_FILES := \
	$(CROM_DAT) \
	$(DROM_DAT)

#
# Documentation files
#

DOC_FILES := \
	status.txt \
	fixme.txt

#
# Build files
#

BLD_FILES := \
	$(ISE)/esm_ks10.xise \
	$(ISE)/esm_ks10.gise \
	$(ISE)/esm_ks10.wcfg

#
# UCF File
#

UCF_FILE := \
	esm_top/$(PROJECT).ucf

#
# Filter file arguments
#

FILTER_ARGS := \
	'<filters xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="filter.xsd">' \
	'    <filter task="map"   file="Map"   num="284"  type="warning"></filter>' \
	'    <filter task="xst"   file="Xst"   num="647"  type="warning"></filter>' \
	'    <filter task="xst"   file="Xst"   num="1710" type="warning"></filter>' \
	'    <filter task="xst"   file="Xst"   num="1895" type="warning"></filter>' \
	'    <filter task="xst"   file="Xst"   num="2261" type="info"   ></filter>' \
	'    <filter task="xst"   file="Xst"   num="2677" type="warning"></filter>' \
	'    <filter task="place" file="Place" num="1109" type="warning"></filter>' \
	'    <filter task="place" file="Place" num="1137" type="warning"></filter>' \
	'    <filter task="place" file="Place" num="1197" type="warning"></filter>' \
	'    <filter task="place" file="Place" num="1206" type="warning"></filter>' \
	'</filters>'

#
# Build the binary firmware image
#

build: $(ISE)/$(PROJECT).bin

#
# Create the "Control ROM" microcode for microsequencer
#

ks10/cpu/useq/crom.dat: ks10/cpu/useq/ks10.mcr ks10/cpu/useq/crom.awk
	awk -f ks10/cpu/useq/crom.awk ks10/cpu/useq/ks10.mcr > ks10/cpu/useq/crom.dat

#
# Create the "Dispatch ROM" microcode for microsequencer
#

ks10/cpu/useq/drom.dat: ks10/cpu/useq/ks10.mcr ks10/cpu/useq/drom.awk
	awk -f ks10/cpu/useq/drom.awk ks10/cpu/useq/ks10.mcr > ks10/cpu/useq/drom.dat

#
# Initialize the SSRAM with MAINDEC (simulation only)
# Note special rule for force $(DIAG).dat to rebuild
#

$(TESTBENCH)/$(DIAG).dat : FORCE
FORCE:

$(TESTBENCH)/$(DIAG).dat : $(MON_FILES) $(MAINDEC)/$(PREFIX)$(DIAG).SEQ $(TESTBENCH)/ssram.awk makefile
	cat $(MON_FILES) $(MAINDEC)/$(PREFIX)$(DIAG).SEQ | \
	awk -f $(TESTBENCH)/ssram.awk -vfilename=$(DIAG).SEQ > $(TESTBENCH)/$(DIAG).dat

$(ISE)/$(PROJECT).filter: makefile
	@echo "Creating "$@ > /dev/stderr
	@echo "" > $@
	@for FIL in $(FILTER_ARGS); \
	do \
	    echo $$FIL >> $@; \
	done

$(ISE)/$(PROJECT).xst: makefile
	@echo "Creating "$@ > /dev/stderr
	@echo "" > $@
	@for CMD in $(XST_CMDS); \
	do \
	    echo $$CMD >> $@; \
	done

$(ISE)/$(PROJECT).prj: makefile
	@echo "Creating "$@ > /dev/stderr
	@echo "" > $@
	@for FILE in $(RTL_FILES); \
	do \
	    echo 'verilog work "../../'$$FILE'"' >> $@; \
	done

$(ISE)/$(PROJECT)_isim.prj: makefile
	@echo "Creating "$@ > /dev/stderr
	@echo "" > $@
	@for FILE in $(RTL_FILES); \
	do \
	    echo 'verilog work "../../'$$FILE'"' >> $@; \
	done
	@for FILE in $(SIM_FILES); \
	do \
	    echo 'verilog work "../../'$$FILE'"' >> $@; \
	done
	@echo 'verilog work "$(XILINX)/ISE_DS/ISE/verilog/src/glbl.v"' >> $@;

$(ISE)/$(PROJECT)_isim.cmd: makefile
	@echo "Creating "$@ > /dev/stderr
	@echo "" > $@
	@for CMD in $(ISIM_CMDS); \
	do \
	    echo $$CMD >> $@; \
	done

$(ISE)/$(PROJECT)_impact.cmd: makefile
	@echo "Creating "$@ > /dev/stderr
	@echo "" > $@
	@for CMD in $(IMPACT_CMDS); \
	do \
	    echo $$CMD >> $@; \
	done

#
# FUSE
#  The Xilinx simulator has a different switch for defining macros.
#

FUSE_ARGS := \
	$(subst -D,-d,$(SIM_ARGS) $(SYN_ARGS)) \
	-d XILINX \
	-d SSRAM_DAT=\"\"../../$(TESTBENCH)/$(DIAG).dat\"\" \
	-d CROM_DAT=\"\"../../$(CROM_DAT)\"\" \
	-d DROM_DAT=\"\"../../$(DROM_DAT)\"\" \
	-d SDSIM_DSK=\"\"../../$(SIM_DISK)\"\" \
	-intstyle $(INTSTYLE) \
	-incremental \
	-o   $(PROJECT)_isim.exe \
	-prj $(PROJECT)_isim.prj \
	-lib unisims_ver \
	-lib unimacro_ver \
	-lib secureip \
	-lib xilinxcorelib_ver \
	work.$(SIMTOP) \
	work.glbl

$(ISE)/$(PROJECT)_isim.exe: $(ISE)/$(PROJECT)_isim.prj $(RTL_FILES) $(SIM_FILES) $(INC_FILES) $(DAT_FILES) $(SIM_DISK) makefile
	@cd $(ISE); \
	$(FUSE) $(FUSE_ARGS)

#
# ISIM Commands
#

ISIM_CMDS := \
	'onerror {resume}' \
	'isim set maxtraceablesize 1180000'

ISIM_ARGS := \
	-intstyle $(INTSTYLE) \
	-gui \
	-tclbatch $(PROJECT)_isim.cmd \
	-view $(PROJECT).wcfg \
	-wdb c:/temp/$(PROJECT).wdb

isim: $(ISE)/$(PROJECT)_isim.exe $(ISE)/$(PROJECT)_isim.cmd $(ISE)/$(PROJECT).wcfg $(TESTBENCH)/$(DIAG).dat makefile
	@cd $(ISE); \
	export PATH=$(XILPATH):$$PATH; \
	./$(PROJECT)_isim.exe $(ISIM_ARGS) &

isim_bat : $(ISE)/$(PROJECT)_isim.exe $(ISE)/$(PROJECT)_isim.cmd $(ISE)/$(PROJECT).wcfg $(TESTBENCH)/$(DIAG).dat makefile
	@cd $(ISE); \
	export PATH=$(XILPATH):$$PATH; \
	./$(PROJECT)_isim.exe -gui &

#
# Questasim
#

DOFILE := \
        "onerror {resume}" \
        "quietly WaveActivateNextPane {} 0 " \
        "add wave -noupdate -radix octal -radixshowbase 0 clk" \
        "add wave -noupdate -radix octal -radixshowbase 0 reset" \
        "add wave -noupdate -color \"lightblue\" -divider {Memory Interface}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label {busADDRI}             {/testbench/uKS10/uKS10/uMEM/busADDRI}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label {busDATAI}             {/testbench/uKS10/uKS10/uMEM/busDATAI}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label {busDATAO}             {/testbench/uKS10/uKS10/uMEM/busDATAO}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label {memREAD}              {/testbench/uKS10/uKS10/uMEM/memREAD}"  \
        "add wave -noupdate -radix octal -radixshowbase 0 -label {memWRITE}             {/testbench/uKS10/uKS10/uMEM/memWRITE}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label {memWRTEST}            {/testbench/uKS10/uKS10/uMEM/memWRTEST}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label {ssramDATA}            {/testbench/uKS10/uKS10/uMEM/ssramDATA}" \
        "add wave -noupdate -divider {CPU Interface}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label {clk}                  {/testbench/clk}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label {reset}                {/testbench/reset}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label {clken}                {/testbench/uKS10/uKS10/uCPU/uINTF/clken}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label {cpuREQO}              {/testbench/uKS10/uKS10/uCPU/cpuREQO}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label {cpuACKI}              {/testbench/uKS10/uKS10/uCPU/cpuACKI}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label {cpuADDRO[0:35]}       {/testbench/uKS10/uKS10/uCPU/cpuADDRO}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label { 3: READ}             {/testbench/uKS10/uKS10/uCPU/cpuADDRO[3]}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label { 4: WRTEST}           {/testbench/uKS10/uKS10/uCPU/cpuADDRO[4]}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label { 5: WRITE}            {/testbench/uKS10/uKS10/uCPU/cpuADDRO[5]}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label {10: IO}               {/testbench/uKS10/uKS10/uCPU/cpuADDRO[10]}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label {11: WRU}              {/testbench/uKS10/uKS10/uCPU/cpuADDRO[11]}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label {12: VECT}             {/testbench/uKS10/uKS10/uCPU/cpuADDRO[12]}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label {cpuADDRO[14:35]}      {/testbench/uKS10/uKS10/uCPU/cpuADDRO[14:35]}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label {cpuDATAI}             {/testbench/uKS10/uKS10/uCPU/cpuDATAI}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label {cpuDATAO}             {/testbench/uKS10/uKS10/uCPU/cpuDATAO}" \
        "add wave -noupdate -divider {** CPU **}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label {CROM J}               {/testbench/uKS10/uKS10/uCPU/uUSEQ/uCROM/addr}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label {CROM ADDR}            {/testbench/uKS10/uKS10/uCPU/uUSEQ/addr}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label {CROM CURR ADDR}       {/testbench/uKS10/uKS10/uCPU/uUSEQ/uSTACK/currADDR}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label {PC}                   {/testbench/uKS10/uKS10/uDEBUG/cpuPC}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label {IR}                   {/testbench/uKS10/uKS10/uDEBUG/cpuHR}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label { 0: MAG}              {/testbench/uKS10/uKS10/uCPU/uALU/aluRAM[0]}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label { 1: PC}               {/testbench/uKS10/uKS10/uCPU/uALU/aluRAM[1]}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label { 2: HR}               {/testbench/uKS10/uKS10/uCPU/uALU/aluRAM[2]}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label { 3: AR}               {/testbench/uKS10/uKS10/uCPU/uALU/aluRAM[3]}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label { 4: ARX}              {/testbench/uKS10/uKS10/uCPU/uALU/aluRAM[4]}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label { 5: BR}               {/testbench/uKS10/uKS10/uCPU/uALU/aluRAM[5]}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label { 6: BRX}              {/testbench/uKS10/uKS10/uCPU/uALU/aluRAM[6]}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label { 7: ONE}              {/testbench/uKS10/uKS10/uCPU/uALU/aluRAM[7]}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label { 8: EBR}              {/testbench/uKS10/uKS10/uCPU/uALU/aluRAM[8]}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label { 9: UBR}              {/testbench/uKS10/uKS10/uCPU/uALU/aluRAM[9]}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label {10: MASK}             {/testbench/uKS10/uKS10/uCPU/uALU/aluRAM[10]}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label {11: FLG}              {/testbench/uKS10/uKS10/uCPU/uALU/aluRAM[11]}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label {12: PI}               {/testbench/uKS10/uKS10/uCPU/uALU/aluRAM[12]}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label {13: XWD1}             {/testbench/uKS10/uKS10/uCPU/uALU/aluRAM[13]}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label {14: T0}               {/testbench/uKS10/uKS10/uCPU/uALU/aluRAM[14]}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label {15: T1}               {/testbench/uKS10/uKS10/uCPU/uALU/aluRAM[15]}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label {AC0}                  {/testbench/uKS10/uKS10/uCPU/uRAMFILE/ram[0]}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label {AC1}                  {/testbench/uKS10/uKS10/uCPU/uRAMFILE/ram[1]}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label {AC2}                  {/testbench/uKS10/uKS10/uCPU/uRAMFILE/ram[2]}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label {AC3}                  {/testbench/uKS10/uKS10/uCPU/uRAMFILE/ram[3]}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label {AC4}                  {/testbench/uKS10/uKS10/uCPU/uRAMFILE/ram[4]}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label {AC5}                  {/testbench/uKS10/uKS10/uCPU/uRAMFILE/ram[5]}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label {AC6}                  {/testbench/uKS10/uKS10/uCPU/uRAMFILE/ram[6]}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label {AC7}                  {/testbench/uKS10/uKS10/uCPU/uRAMFILE/ram[7]}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label {AC8}                  {/testbench/uKS10/uKS10/uCPU/uRAMFILE/ram[8]}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label {AC9}                  {/testbench/uKS10/uKS10/uCPU/uRAMFILE/ram[9]}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label {AC10}                 {/testbench/uKS10/uKS10/uCPU/uRAMFILE/ram[10]}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label {AC11}                 {/testbench/uKS10/uKS10/uCPU/uRAMFILE/ram[11]}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label {AC12}                 {/testbench/uKS10/uKS10/uCPU/uRAMFILE/ram[12]}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label {AC13}                 {/testbench/uKS10/uKS10/uCPU/uRAMFILE/ram[13]}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label {AC14}                 {/testbench/uKS10/uKS10/uCPU/uRAMFILE/ram[14]}" \
        "add wave -noupdate -radix octal -radixshowbase 0 -label {AC15}                 {/testbench/uKS10/uKS10/uCPU/uRAMFILE/ram[15]}" \
        "run 100 us"

$(QUESTA)/wave.do: makefile
	@echo "Creating "$@ > /dev/stderr
	@echo "" > $@
	@for CMD in $(DOFILE); \
	do \
	    echo $$CMD >> $@; \
	done

#
#	vlib $(QUESTA)/work
#	vmap
#./$(QUESTA)/work work
#	+define+XILINX\
#

questa: $(SIM_FILES) $(RTL_FILES) $(INC_FILES) $(DAT_FILES) $(SIM_DISK) $(SSRAM_DAT) makefile $(QUESTA)/wave.do
	vlib work
	vlog $(SIM_FILES) $(RTL_FILES) \
	+define+SSRAM_DAT=\"$(TESTBENCH)/$(DIAG).dat\" \
	+define+CROM_DAT=\"$(CROM_DAT)\" \
	+define+DROM_DAT=\"$(DROM_DAT)\" \
	+define+SDSIM_DSK=\"$(SIM_DISK)\" \
	$(subst -D ,+define+,$(SIM_ARGS) $(SYN_ARGS))
	echo testbench -novopt -do $(QUESTA)/wave.do
	cmd /c "vsim testbench -novopt -do $(QUESTA)/wave.do"

#
# Vivado
#

VIVADO_EXE = /cygdrive/c/Xilinx/Vivado/2015.4/bin/vivado

vivado: $(SSRAM_DAT)
	$(VIVADO_EXE) -help

#
# xst
#
# xst options:
#
#   -filter                    : Filter File
#   -intstyle                  : Integration Style
#   -sd                        : Core Search Directory
#   -write_timing_constraints  : Write timing constraints
#

XST_OPTS := \
	-filter $(PROJECT).filter \
	-intstyle $(INTSTYLE)

XST_DEFS := \
	XILINX \
	SYNTHESIS \
	$(subst \','\'', $(subst -D ,,$(SYN_ARGS)))

XST_CMDS := \
	'set -xsthdpdir "xst"' \
	'run' \
	'-ifn $(PROJECT).prj' \
	'-use_new_parser yes' \
	'-ofn $(PROJECT).ngc' \
	'-ofmt ngc' \
	'-p $(PART)' \
	'-top $(RTLTOP)' \
	'-opt_mode Speed' \
	'-opt_level 2' \
	'-power NO' \
	'-iuc NO' \
	'-keep_hierarchy Soft' \
	'-netlist_hierarchy As_Optimized' \
	'-rtlview Yes' \
	'-glob_opt AllClockNets' \
	'-read_cores YES' \
	'-write_timing_constraints NO' \
	'-cross_clock_analysis NO' \
	'-hierarchy_separator /' \
	'-bus_delimiter <>' \
	'-case Maintain' \
	'-slice_utilization_ratio 100' \
	'-bram_utilization_ratio 100' \
	'-dsp_utilization_ratio 100' \
	'-lc Auto' \
	'-reduce_control_sets Auto' \
	'-define {$(XST_DEFS)}' \
	'-fsm_extract YES -fsm_encoding Auto' \
	'-safe_implementation No' \
	'-fsm_style LUT' \
	'-ram_extract Yes' \
	'-ram_style Auto' \
	'-rom_extract Yes' \
	'-shreg_extract YES' \
	'-rom_style Auto' \
	'-auto_bram_packing NO' \
	'-resource_sharing NO' \
	'-async_to_sync YES' \
	'-shreg_min_size 2' \
	'-use_dsp48 Auto' \
	'-iobuf YES' \
	'-max_fanout 100000' \
	'-bufg 16' \
	'-register_duplication YES' \
	'-register_balancing Forward' \
	'-move_first_stage YES' \
	'-move_last_stage YES' \
	'-optimize_primitives NO' \
	'-use_clock_enable Auto' \
	'-use_sync_set Auto' \
	'-use_sync_reset Auto' \
	'-iob True' \
	'-equivalent_register_removal YES' \
	'-slice_utilization_ratio_maxmargin 5'

ifneq (, $(findstring CHIPSCOPE_SD, $(SYN_ARGS)))
XST_CMDS += \
	'-sd {"../../ks10/xilinx/chipscope_sd_ila" "../../ks10/xilinx/chipscope_sd_icon"}'
endif

ifneq (, $(findstring CHIPSCOPE_CPU, $(SYN_ARGS)))
XST_CMDS += \
	'-sd {"../../ks10//xilinx/chipscope_cpu_ila" "../../ks10//xilinx/chipscope_cpu_icon" "../../ks10//xilinx/chipscope_cpu_vio"}'
endif

ifneq (, $(findstring CHIPSCOPE_MEM, $(SYN_ARGS)))
XST_CMDS += \
	'-sd {"../../ks10//xilinx/chipscope_mem_ila" "../../ks10//xilinx/chipscope_mem_icon"}'
endif

ifneq (, $(findstring CHIPSCOPE_CSL, $(SYN_ARGS)))
XST_CMDS += \
	'-sd {"../../ks10//xilinx/chipscope_csl_ila" "../../ks10//xilinx/chipscope_csl_icon"}'
endif

ifneq (, $(findstring CHIPSCOPE_UBA, $(SYN_ARGS)))
XST_CMDS += \
	'-sd {"../../ks10//xilinx/chipscope_uba_ila" "../../ks10//xilinx/chipscope_uba_icon"}'
endif

$(ISE)/$(PROJECT).ngc $(ISE)/$(PROJECT).ngr: $(ISE)/$(PROJECT).xst $(ISE)/$(PROJECT).prj $(ISE)/$(PROJECT).filter $(RTL_FILES) $(INC_FILES) $(DAT_FILES) makefile
	@cd $(ISE); \
	echo "################################################################################" | tee    $(PROJECT).log; \
	echo Running XST | tee -a $(PROJECT).log; \
	echo $(XST) $(XST_OPTS) -ifn $(PROJECT).xst -ofn $(PROJECT).syr | tee -a $(PROJECT).log; \
	echo "################################################################################" | tee -a $(PROJECT).log; \
	$(XST) $(XST_OPTS) -ifn $(PROJECT).xst -ofn $(PROJECT).syr | tee -a $(PROJECT).log

#
# ngdbuild
#
# "NGDBuild reads in a netlist file in EDIF or NGC format and creates a Xilinx Native
# Generic Database (NGD) file that contains a logical description of the design in terms of
# logic elements, such as AND gates, OR gates, LUTs, flip-flops, and RAMs"
#
# usage:
#   ngdbuild [options] design_name [ngd_file[.ngd]]
#
# Ngdbuild options:
#
#   -dd                   : Destination Directory
#   -sd                   : Core Search Directory
#   -filter               : Filter File
#   -intstyle             : Integration Style {ise|xflow|silent}
#   -nt                   : Netlist Translation Type {timestamp|on|off}
#   -p                    : Part number
#   -uc                   : User Constraints File
#

NGD_OPTS := \
	-dd _ngo \
	-filter $(PROJECT).filter \
	-intstyle $(INTSTYLE) \
	-nt timestamp \
	-p $(PART) \
	-uc ../../$(UCF_FILE)

ifneq (, $(findstring CHIPSCOPE_SD, $(SYN_ARGS)))
NGD_OPTS += \
	-sd ../../ks10/xilinx/chipscope_sd_ila \
	-sd ../../ks10/xilinx/chipscope_sd_icon
endif

ifneq (, $(findstring CHIPSCOPE_CPU, $(SYN_ARGS)))
NGD_OPTS += \
	-sd ../../ks10/xilinx/chipscope_cpu_ila \
	-sd ../../ks10/xilinx/chipscope_cpu_icon \
	-sd ../../ks10/xilinx/chipscope_cpu_vio
endif

ifneq (, $(findstring CHIPSCOPE_MEM, $(SYN_ARGS)))
NGD_OPTS += \
	-sd ../../ks10/xilinx/chipscope_mem_ila \
	-sd ../../ks10/xilinx/chipscope_mem_icon
endif

ifneq (, $(findstring CHIPSCOPE_CSL, $(SYN_ARGS)))
NGD_OPTS += \
	-sd ../../ks10/ilinx/chipscope_csl_ila \
	-sd ../../ks10/xilinx/chipscope_csl_icon
endif

ifneq (, $(findstring CHIPSCOPE_UBA, $(SYN_ARGS)))
NGD_OPTS += \
	-sd ../../ks10/xilinx/chipscope_uba_ila \
	-sd ../../ks10/xilinx/chipscope_uba_icon
endif

$(ISE)/$(PROJECT).ngd $(ISE)/$(PROJECT).bld: $(ISE)/$(PROJECT).ngc $(UCF_FILE) $(CGN_FILES) $(ISE)/$(PROJECT).filter makefile
	@cd $(ISE); \
	echo "################################################################################" | tee -a $(PROJECT).log; \
	echo Running NGDBUILD | tee -a $(PROJECT).log; \
	echo $(NGD) $(NGD_OPTS) $(PROJECT).ngc $(PROJECT).ngd | tee -a $(PROJECT).log; \
	echo "################################################################################" | tee -a $(PROJECT).log; \
	$(NGD) $(NGD_OPTS) $(PROJECT).ngc $(PROJECT).ngd | tee -a $(PROJECT).log

#
# MAP
#
# The MAP program maps a logical design to a Xilinx FPGA. The
# input to MAP is an NGD file, which is generated using the
# NGDBuild program.
#
# usage:
#    map [options] infile[.ngd] [pcf_file.pcf]
#
# Map Options:
#
#   -filter               : Filter File
#   -global_opt           : Global optimizations {off|speed|area|power}
#   -intstyle             : Integration Style
#   -ir                   : Do Not Use RLOCs to Generate RPMs {all|off|place}
#   -lc                   : LUT Combining {off|auto|area}
#   -logic_opt            : Logic Optimization {on|off}
#   -mt                   : Multi-threading {off|2}
#   -o                    : Output File Name
#   -ol                   : Overall Effort Level {std|high}
#   -p                    : Part number
#   -power                : Power Optimization
#   -pr                   : Pack Registers in I/O {off | i | o | b}
#   -r                    : Register Ordering
#   -register_duplication : Duplicate Registers
#   -t                    : Placer Cost Table
#   -w                    : Overwrite files
#   -xe                   : Extra Effort Level
#   -xt                   : Extra Placer Cost Table
#

MAP_OPTS:= \
	-filter $(PROJECT).filter \
	-global_opt off \
	-intstyle $(INTSTYLE) \
	-ir off \
	-lc off \
	-logic_opt off \
	-mt 2 \
	-ol high \
	-p $(PART) \
	-power off \
	-pr b \
	-r 4 \
	-register_duplication off \
	-t 1 \
	-w \
	-xe n \
	-xt 0

$(ISE)/$(PROJECT)_map.ncd $(ISE)/$(PROJECT).pcf: $(ISE)/$(PROJECT).ngd $(ISE)/$(PROJECT).filter makefile
	@cd $(ISE); \
	echo "################################################################################" | tee -a $(PROJECT).log; \
	echo Running MAP | tee -a $(PROJECT).log; \
	echo $(MAP) $(MAP_OPTS) -o $(PROJECT)_map.ncd $(PROJECT).ngd $(PROJECT).pcf | tee -a $(PROJECT).log; \
	echo "################################################################################" | tee -a $(PROJECT).log; \
	$(MAP) $(MAP_OPTS) -o $(PROJECT)_map.ncd $(PROJECT).ngd $(PROJECT).pcf | tee -a $(PROJECT).log

#
# Place and Route
#
# PAR accepts a mapped NCD file as input, places and routes the design,
# and outputs an NCD file to be used by the bitstream generator (BitGen).
#
# usage:
#   par [options] infile[.ncd] outfile [pcf_file[.pcf]]
#
# par options:
#
#   -filter               : Filter File
#   -intstyle             : Integration Style
#   -mt                   : Multi-threading {off|2|3|4}
#   -ol                   : Overall Effort Level {std|high}
#   -w                    : Overwrite files
#   -xe                   : Extra Effort Level {n|c}
#

PAR_OPTS := \
	-filter $(PROJECT).filter \
	-intstyle $(INTSTYLE) \
	-mt 4 \
	-ol high \
	-w \
	-xe n

$(ISE)/$(PROJECT).ncd: $(ISE)/$(PROJECT)_map.ncd $(ISE)/$(PROJECT).pcf $(ISE)/$(PROJECT).filter makefile
	@cd $(ISE); \
	echo "################################################################################" | tee -a $(PROJECT).log; \
	echo Running PAR | tee -a $(PROJECT).log; \
	echo $(PAR) $(PAR_OPTS) $(PROJECT)_map.ncd $(PROJECT).ncd $(PROJECT).pcf | tee -a $(PROJECT).log; \
	echo "################################################################################" | tee -a $(PROJECT).log; \
	$(PAR) $(PAR_OPTS) $(PROJECT)_map.ncd $(PROJECT).ncd $(PROJECT).pcf | tee -a $(PROJECT).log

#
# bitgen
#
# Generate BIT file from NCD file.
#
# usage:
#   bitgen [options] infile[.ncd] [outfile] [pcf_file.pcf]
#
# bitgen options:
#
#   -g                    : Set configuration
#   -intstyle             : Integration style
#   -w                    : Overwrite existing output file
#

BITGEN_OPTS := \
	-w \
	-intstyle $(INTSTYLE) \
	-g DebugBitstream:No \
	-g Binary:no \
	-g CRC:Enable \
	-g Reset_on_err:No \
	-g ConfigRate:2 \
	-g ProgPin:PullUp \
	-g TckPin:PullUp \
	-g TdiPin:PullUp \
	-g TdoPin:PullUp \
	-g TmsPin:PullUp \
	-g UnusedPin:PullDown \
	-g UserID:0xFFFFFFFF \
	-g ExtMasterCclk_en:No \
	-g SPI_buswidth:1 \
	-g TIMER_CFG:0xFFFF \
	-g multipin_wakeup:No \
	-g StartUpClk:Cclk \
	-g DONE_cycle:4 \
	-g GTS_cycle:5 \
	-g GWE_cycle:6 \
	-g LCK_cycle:NoWait \
	-g Security:None \
	-g DonePipe:No \
	-g DriveDone:No \
	-g en_sw_gsr:No \
	-g drive_awake:No \
	-g sw_clk:Startupclk \
	-g sw_gwe_cycle:5 \
	-g sw_gts_cycle:4

$(ISE)/$(PROJECT).bit: $(ISE)/$(PROJECT).ncd makefile
	@cd $(ISE); \
	echo "################################################################################" | tee -a $(PROJECT).log; \
	echo Running BITGEN | tee -a $(PROJECT).log; \
	echo $(BITGEN) $(BITGEN_OPTS) $(PROJECT).ncd $(PROJECT).bit | tee -a $(PROJECT).log; \
	echo "################################################################################" | tee -a $(PROJECT).log; \
	$(BITGEN) $(BITGEN_OPTS) $(PROJECT).ncd $(PROJECT).bit | tee -a $(PROJECT).log

#
# promgen
#
# Create the Intel Hex file for loading into the serial flash.
#
# usage:
#   promgen [options]
#
# promgen options:
#
#   -c                    : Checksum
#   -o                    : Output File Name
#   -p                    : PROM format
#   -s                    : PROM size
#   -spi                  : Disable bit swapping
#   -u                    : Load upward {addr filename}
#   -w                    : Overwrite existing output file
#

PROMGEN_OPTS := \
	-c ff \
	-o $(PROJECT).mcs \
	-p mcs \
	-s 4096 \
	-spi \
	-u 0000 $(PROJECT).bit \
	-w

$(ISE)/$(PROJECT).mcs: $(ISE)/$(PROJECT).bit makefile
	@cd $(ISE); \
	echo "################################################################################" | tee -a $(PROJECT).log; \
	echo Running PROMGEN | tee -a $(PROJECT).log; \
	echo $(PROMGEN) $(PROMGEN_OPTS) | tee -a $(PROJECT).log; \
	echo "################################################################################" | tee -a $(PROJECT).log; \
	$(PROMGEN) $(PROMGEN_OPTS) | tee -a $(PROJECT).log

#
# Convert Hex File to Binary File
#

OBJCOPY_OPTS := \
	-I ihex \
	-O binary

$(ISE)/$(PROJECT).bin : $(ISE)/$(PROJECT).mcs makefile
	@cd $(ISE); \
	echo "################################################################################" | tee -a $(PROJECT).log; \
	echo Running OBJCOPY | tee -a $(PROJECT).log; \
	echo $(OBJCOPY) $(OBJCOPY_OPTS) $(ISE)/$(PROJECT).mcs $(ISE)/$(PROJECT).bin | tee -a $(PROJECT).log; \
	echo "################################################################################" | tee -a $(PROJECT).log; \
	$(OBJCOPY) $(OBJCOPY_OPTS) $(ISE)/$(PROJECT).mcs $(ISE)/$(PROJECT).bin

#
# Run 'impact' to program the KS10 flash
#
# Gosh the documentation for impact is really poor.
#
# usage:
#   impact [options]
#
# Note:
#   This is keyed to my Digilent JTAG HS2 programmer. If you want to
#   auto probe for a JTAG device:
#
#   Replace
#	'setCable -target "digilent_plugin DEVICE=JtagHs2 FREQUENCY="' \
#
#   With
#	'setcable -p auto' \
#
#   Also.  Some boards have different serial flash memories that store
#   the firmware.  If you get the error message "The idcode read from
#   the device does not match the idcode in the bsdl File"
#
#   Replace
#
#	'attachflash -position 1 -spi S25FL032P' \
#   With
#	'attachflash -position 1 -spi S25FL064P' \
#

IMPACT_CMDS := \
	'setmode -bscan' \
	'setCable -target "digilent_plugin DEVICE=JtagHs2 FREQUENCY="' \
	'identify -inferir' \
	'identifyMPM' \
	'attachflash -position 1 -spi S25FL064P' \
	'assignfiletoattachedflash -position 1 -file $(PROJECT).mcs' \
	'program -p 1 -dataWidth 1 -spionly -e -v -loadfpga' \
	'quit'

load: $(ISE)/$(PROJECT).mcs $(ISE)/$(PROJECT)_impact.cmd
	cd $(ISE); \
	$(IMPACT) -batch $(PROJECT)_impact.cmd

reload: $(ISE)/$(PROJECT)_impact.cmd
	cd $(ISE); \
	$(IMPACT) -batch $(PROJECT)_impact.cmd

#
# TRCE
#

trce :
	$(TRCE) -v -tsi asdf.tsi $(ISE)/$(PROJECT).ncd


#
# iverilog
#

testsuite/$(DIAG).vvp : $(SIM_FILES) $(RTL_FILES) $(INC_FILES) $(DAT_FILES) $(SIM_DISK) $(SSRAM_DAT) makefile
	$(IVERILOG) -W all -s testbench -o $@ $(SIM_FILES) $(RTL_FILES) \
	$(SIM_ARGS) \
	$(SYN_ARGS) \
	-D SSRAM_DAT=\"$(SSRAM_DAT)\" \
	-D CROM_DAT=\"$(CROM_DAT)\" \
	-D DROM_DAT=\"$(DROM_DAT)\" \
	-D SDSIM_DSK=\"$(SIM_DISK)\" \
	-I ks10 \
	-I ks10/cpu \
	-I ks10/cpu/useq \
	-I ks10/debug \
	-I ks10/dz11 \
	-I ks10/dz11/uart \
	-I ks10/mem \
	-I ks10/rh11 \
	-I ks10/rh11/rpxx \
	-I ks10/rh11/sd \
	-I ks10/uba

testsuite/$(DIAG).txt : testsuite/$(DIAG).vvp
	$(VVP) -n $< > testsuite/$(DIAG).txt

#
# Clean everything
#

clean: clean_rtl clean_ise

#
# Clean RTL
#

clean_rtl:
	rm -f ks10/cpu/useq/crom.dat
	rm -f ks10/cpu/useq/drom.dat
	rm -f $(TESTBENCH)/*.dat
	find . -type f -name "*~" | xargs rm -fv

#
# Clean ISE
#

clean_ise:
	rm -rf $(ISE)/xst \
               $(ISE)/_ngo \
               $(ISE)/_xmsgs \
               $(ISE)/isim \
               $(ISE)/iseconfig \
               $(ISE)/xlnx_auto_0_xdb
	rm -f  $(ISE)/$(PROJECT).bgn \
	       $(ISE)/$(PROJECT).bit \
	       $(ISE)/$(PROJECT).bld \
	       $(ISE)/$(PROJECT).cfi \
               $(ISE)/$(PROJECT).cmd_log \
               $(ISE)/$(PROJECT).drc \
               $(ISE)/$(PROJECT).filter \
               $(ISE)/$(PROJECT).log \
               $(ISE)/$(PROJECT).lso \
               $(ISE)/$(PROJECT).mcs \
               $(ISE)/$(PROJECT).ncd \
               $(ISE)/$(PROJECT).ngc \
               $(ISE)/$(PROJECT).ngc_xst.xrpt \
               $(ISE)/$(PROJECT).ngd \
               $(ISE)/$(PROJECT).ngr \
               $(ISE)/$(PROJECT).pad \
               $(ISE)/$(PROJECT).par \
               $(ISE)/$(PROJECT).pcf\
               $(ISE)/$(PROJECT).prj\
               $(ISE)/$(PROJECT).prm\
               $(ISE)/$(PROJECT).ptwx \
               $(ISE)/$(PROJECT).srp \
               $(ISE)/$(PROJECT).syr \
               $(ISE)/$(PROJECT).stx \
               $(ISE)/$(PROJECT).twr \
               $(ISE)/$(PROJECT).twx \
               $(ISE)/$(PROJECT).unroutes \
               $(ISE)/$(PROJECT).ut \
               $(ISE)/$(PROJECT).wdb \
               $(ISE)/$(PROJECT).xpi \
               $(ISE)/$(PROJECT).xst \
               $(ISE)/$(PROJECT)_bitgen.xwbt \
               $(ISE)/$(PROJECT)_envsettings.html \
               $(ISE)/$(PROJECT)_guide.ncd \
               $(ISE)/$(PROJECT)_impact.cmd \
               $(ISE)/$(PROJECT)_isim.cmd \
               $(ISE)/$(PROJECT)_isim.exe \
               $(ISE)/$(PROJECT)_isim.prj \
               $(ISE)/$(PROJECT)_map.map \
               $(ISE)/$(PROJECT)_map.mrp \
               $(ISE)/$(PROJECT)_map.ncd \
               $(ISE)/$(PROJECT)_map.ngm \
               $(ISE)/$(PROJECT)_map.xrpt \
               $(ISE)/$(PROJECT)_ngdbuild.xrpt \
               $(ISE)/$(PROJECT)_pad.csv \
               $(ISE)/$(PROJECT)_pad.txt \
               $(ISE)/$(PROJECT)_par.xrpt \
               $(ISE)/$(PROJECT)_summary.html \
               $(ISE)/$(PROJECT)_summary.xml \
               $(ISE)/$(PROJECT)_usage.xml \
               $(ISE)/$(PROJECT)_xst.xrpt \
               $(ISE)/fuse.log \
               $(ISE)/fuse.xmsgs \
               $(ISE)/fuseRelaunch.cmd \
               $(ISE)/_impactbatch.log \
               $(ISE)/isim.cmd \
               $(ISE)/isim.log \
               $(ISE)/par_usage_statistics.html \
               $(ISE)/usage_statistics_webtalk.html \
               $(ISE)/webtalk.log \
               $(ISE)/webtalk_pn.xml \
               $(ISE)/xilinx_device_details.xml \
               $(ISE)/xilinxsim.ini

#
# rcsclean everything
#

rcsclean: rcsclean_rtl rcsclean_ise

#
# rcsclean ISE
#

rcsclean_ise: clean_ise
	rcsclean $(ISE)/*

#
# rcsclean RTL
#

rcsclean_rtl: clean_rtl
	-rcsclean *
	-rcsclean ks10/*
	-rcsclean ks10/arb/*
	-rcsclean ks10/clk/*
	-rcsclean ks10/cpu/*
	-rcsclean ks10/cpu/useq/*
	-rcsclean ks10/csl/*
	-rcsclean ks10/debug/*
	-rcsclean ks10/dz11/*
	-rcsclean ks10/dz11/uart/*
	-rcsclean ks10/mem/*
	-rcsclean ks10/rh11/*
	-rcsclean ks10/rh11/sd/*
	-rcsclean ks10/rh11/rpxx/*
	-rcsclean ks10/uba/*
	-rcsclean ks10/utils/*
	-rcsclean ks10/xilinx/*
	-rcsclean ks10/xilinx/chipscope_cpu_ila/*
	-rcsclean ks10/xilinx/chipscope_cpu_iocon/*
	-rcsclean ks10/xilinx/chipscope_cpu_vio
	-rcsclean ks10/xilinx/chipscope_csl_ila
	-rcsclean ks10/xilinx/chipscope_csl_icon
	-rcsclean ks10/xilinx/chipscope_mem_ila
	-rcsclean ks10/xilinx/chipscope_mem_icon
	-rcsclean ks10/xilinx/chipscope_sd_ila
	-rcsclean ks10/xilinx/chipscope_sd_icon
	-rcsclean ks10/xilinx/chipscope_uba_ila
	-rcsclean ks10/xilinx/chipscope_uba_icon
	-rcsclean esm_top/*
	-rcsclean esm_top/testbench/*
	-find . -type f | grep -v RCS | grep -v archive | grep \\.v$$

#
# Fetch design from RCS
#

rcsfetch: $(INC_FILES) $(RTL_FILES) $(SIM_FILES) $(BLD_FILES) $(DAT_FILES) $(DOC_FILES) $(DIAG_FILES) $(UCF_FILE)

#
# Archive files
#

archive_all:
	tar --exclude=testsuite_*/* -czvf ks10_fpga_all_`date '+%y%m%d'`.tgz *

archive_dist: $(SRC)
	make rcsfetch
	tar  --exclude-vcs -czvf ks10_fpga_dist_`date '+%y%m%d'`.tgz *

#./t10backup.exe   -x smmon.sav -f ks_diag_gs.tap
#	-prj testbench_beh.prj \
#	-lib unisims_ver \
#	-lib unimacro_ver \
#	-lib xilinxcorelib_ver \
#	-lib secureip \
#	echo 'verilog work "C:/Xilinx/13.1/ISE_DS/ISE//verilog/src/glbl.v"' >> $@

#
# Count Lines of Code
#

cloc :
	$(CLOC) --by-file --force-lang=Verilog-SystemVerilog,vh --exclude-dir=ise,libero,xilinx ks10 esm_top
	$(CLOC) --by-file --exclude-dir=driverlib,SafeRTOS,lwiplib ../code

#
#
#

check :
	@echo "Tabs in:"
	@-find ks10 esm_top -type f | grep -v RCS | grep -e '\.v$$' -e '\.vh$$' | xargs grep -P '\t'
	@echo "Trailing white space in:"
	@-find ks10 esm_top -type f | grep -v RCS | grep -e '\.v$$' -e '\.vh$$' | xargs grep -P '[ ]+$$'
	@echo "FIXMEs in:"
	@-find ks10 esm_top -type f | grep -v RCS | grep -e '\.v$$' -e '\.vh$$' | xargs grep -i 'fixme'

