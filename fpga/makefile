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
# Copyright (C) 2013-2017 Rob Doyle
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

MAINDEC      := ../maindec
TESTBENCH    := esm_top/testbench
ISE_DIR      := esm_top/ise
QUESTA_DIR   := esm_top/questa
IVERILOG_DIR := esm_top/iverilog

#
# Other tools
#

IVERILOG     := iverilog
VVP          := vvp
VLIB         := vlib
VMAP         := vmap
VLOG         := vlog
VOPT         := vopt
VSIM         := vsim
VIVADO       := /cygdrive/c/Xilinx/Vivado/2015.4/bin/vivado
OBJCOPY      := objcopy
CLOC         := cloc-1.62.exe

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

.SHELLFLAGS = -o pipefail -ec

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
#   -D SIM_LPR          Simulate LPR
#   -D SIM_SDHC         Simulate the SDHC Card
#   -D SIM_SDHC_OFFLINE Simulate the SDHC as offline
#   -D STOP_ON_COMPLETE Stop simulation when test is complete (See debug.v)
#   -D STOP_ON_STUCK_PC Stop simulating when PC gets stuck.
#   -D DEBUG_DSKAA      Diagnostic information (See debug.v)
#   -D DEBUG=DSKAA      Diagnostic information (See debug.v)
#

SIM_ARGS := \
	-D SIM_CTY \
	-D SIM_LPR \
	-D SIM_SMMON \
	-D SIM_SDHC \
	-D ENABLE_TIMER \
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
	ks10/dz11/dzcsr.v \
	ks10/dz11/dzmsr.v \
	ks10/dz11/dztcr.v \
	ks10/dz11/dztdr.v \
	ks10/dz11/dzintr.v \
	ks10/dz11/dzrbuf.v \
	ks10/dz11/dzscan.v \
	ks10/dz11/dzuart.v \
	ks10/dz11/dz11.v \
	ks10/lp20/lpbar.v \
	ks10/lp20/lpbctr.v \
	ks10/lp20/lpcbuf.v \
	ks10/lp20/lpcctr.v \
	ks10/lp20/lpcksm.v \
	ks10/lp20/lpcsra.v \
	ks10/lp20/lpcsrb.v \
	ks10/lp20/lpdma.v \
	ks10/lp20/lppctr.v \
	ks10/lp20/lpintr.v \
	ks10/lp20/lppdat.v \
	ks10/lp20/lpramd.v \
	ks10/lp20/lp20.v \
	ks10/lp26/lp26.v \
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
	ks10/utils/edgetrig.v \
	ks10/utils/uart/uart_brg.v \
	ks10/utils/uart/uart_rx.v \
	ks10/utils/uart/uart_tx.v

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
# Disk drives
#

UNIT0_DSK := $(TESTBENCH)/unit0.dsk
UNIT1_DSK := $(TESTBENCH)/unit1.dsk
UNIT2_DSK := $(TESTBENCH)/unit2.dsk
UNIT3_DSK := $(TESTBENCH)/unit3.dsk
UNIT4_DSK := $(TESTBENCH)/unit4.dsk
UNIT5_DSK := $(TESTBENCH)/unit5.dsk
UNIT6_DSK := $(TESTBENCH)/unit6.dsk
UNIT7_DSK := $(TESTBENCH)/unit7.dsk

DISKS := \
	$(UNIT0_DSK) \
	$(UNIT1_DSK) \
	$(UNIT2_DSK) \
	$(UNIT3_DSK) \
	$(UNIT4_DSK) \
	$(UNIT5_DSK) \
	$(UNIT6_DSK) \
	$(UNIT7_DSK) \

#
# Simulation testbench files
#

SIM_FILES := \
	$(TESTBENCH)/cy7c1460av33.v \
	$(TESTBENCH)/testbench.v \
	$(TESTBENCH)/sdsim.v

#
# If loading a diagnostic, add it.  Otherwise don't
# If were simulating SMMON, add the SMMON files.  Otherwise don't.
#

SEQ_FILES :=

ifdef DIAG

SEQ_FILES += \
	$(MAINDEC)/$(PREFIX)$(DIAG).SEQ

endif

ifneq (, $(findstring SIM_SMMON, $(SIM_ARGS)))

SEQ_FILES += \
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
	ks10/lp20/lp20.vh \
	ks10/lp20/lpbar.vh \
	ks10/lp20/lpbctr.vh \
	ks10/lp20/lpcbuf.vh \
	ks10/lp20/lpcctr.vh \
	ks10/lp20/lpcksm.vh \
	ks10/lp20/lpcsra.vh \
	ks10/lp20/lpcsrb.vh \
	ks10/lp20/lppctr.vh \
	ks10/lp20/lpramd.vh \
	ks10/lp26/lpdvfu.vh \
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
	ks10/utils/ascii.vh \
	ks10/utils/uart/uart.vh \
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
	$(ISE_DIR)/esm_ks10.xise \
	$(ISE_DIR)/esm_ks10.gise \
	$(ISE_DIR)/esm_ks10.wcfg

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
	'    <filter task="map"    file="Map"             num="284"  type="warning"></filter>' \
	'    <filter task="xst"    file="Xst"             num="647"  type="warning"></filter>' \
	'    <filter task="xst"    file="Xst"             num="1710" type="warning"></filter>' \
	'    <filter task="xst"    file="Xst"             num="1895" type="warning"></filter>' \
	'    <filter task="xst"    file="Xst"             num="2261" type="info"   ></filter>' \
	'    <filter task="xst"    file="Xst"             num="2677" type="warning"></filter>' \
	'    <filter task="xst"    file="Xst"             num="2708" type="warning"></filter>' \
	'    <filter task="place"  file="Place"           num="1109" type="warning"></filter>' \
	'    <filter task="place"  file="Place"           num="1137" type="warning"></filter>' \
	'    <filter task="place"  file="Place"           num="1197" type="warning"></filter>' \
	'    <filter task="place"  file="Place"           num="1206" type="warning"></filter>' \
	'    <filter task="bitgen" file="Bitgen"          num="341"  type="info"   ></filter>' \
	'    <filter task="bitgen" file="PhysDesignRules" num="2410" type="warning"></filter>' \
	'</filters>'

#
# Build the binary firmware image
#

build: $(ISE_DIR)/$(PROJECT).bin

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
# Ensure that there is something to execute.  If not, error out.
#

ifeq ($(SEQ_FILES), )

$(TESTBENCH)/ssram.dat : $(SEQ_FILES) $(TESTBENCH)/ssram.awk makefile
	$(error "Need to define DIAG (from command line - DIAG=DSKAA) or define SIM_SMMON or both")

else

$(TESTBENCH)/ssram.dat : $(SEQ_FILES) $(TESTBENCH)/ssram.awk makefile
	cat $(SEQ_FILES) | \
	awk -f $(TESTBENCH)/ssram.awk -vfilename="$(SEQ_FILES)" > $(TESTBENCH)/ssram.dat

endif

.PHONY : $(TESTBENCH)/ssram.dat

$(ISE_DIR)/$(PROJECT).filter: makefile
	@echo "Creating "$@ > /dev/stderr
	@echo "" > $@
	@for FIL in $(FILTER_ARGS); \
	do \
	    echo $$FIL >> $@; \
	done

$(ISE_DIR)/$(PROJECT).xst: makefile
	@echo "Creating "$@ > /dev/stderr
	@echo "" > $@
	@for CMD in $(XST_CMDS); \
	do \
	    echo $$CMD >> $@; \
	done

$(ISE_DIR)/$(PROJECT).prj: makefile
	@echo "Creating "$@ > /dev/stderr
	@echo "" > $@
	@for FILE in $(RTL_FILES); \
	do \
	    echo 'verilog work "../../'$$FILE'"' >> $@; \
	done

$(ISE_DIR)/$(PROJECT)_isim.prj: makefile
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

$(ISE_DIR)/$(PROJECT)_isim.cmd: makefile
	@echo "Creating "$@ > /dev/stderr
	@echo "" > $@
	@for CMD in $(ISIM_CMDS); \
	do \
	    echo $$CMD >> $@; \
	done

$(ISE_DIR)/$(PROJECT)_impact.cmd: makefile
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
	-d SSRAM_DAT=\"\"../../$(TESTBENCH)/ssram.dat\"\" \
	-d CROM_DAT=\"\"../../$(CROM_DAT)\"\" \
	-d DROM_DAT=\"\"../../$(DROM_DAT)\"\" \
	-d UNIT0_DSK=\"\"../../$(UNIT0_DSK)\"\" \
	-d UNIT1_DSK=\"\"../../$(UNIT1_DSK)\"\" \
	-d UNIT2_DSK=\"\"../../$(UNIT2_DSK)\"\" \
	-d UNIT3_DSK=\"\"../../$(UNIT3_DSK)\"\" \
	-d UNIT4_DSK=\"\"../../$(UNIT4_DSK)\"\" \
	-d UNIT5_DSK=\"\"../../$(UNIT5_DSK)\"\" \
	-d UNIT6_DSK=\"\"../../$(UNIT6_DSK)\"\" \
	-d UNIT7_DSK=\"\"../../$(UNIT7_DSK)\"\" \
	-i ../../ks10/utils/uart \
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

$(ISE_DIR)/$(PROJECT)_isim.exe: $(ISE_DIR)/$(PROJECT)_isim.prj $(RTL_FILES) $(SIM_FILES) $(INC_FILES) $(DAT_FILES) $(SIM_DISK) makefile
	@cd $(ISE_DIR); \
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

isim: $(ISE_DIR)/$(PROJECT)_isim.exe $(ISE_DIR)/$(PROJECT)_isim.cmd $(ISE_DIR)/$(PROJECT).wcfg $(TESTBENCH)/ssram.dat $(DISKS) makefile
	@cd $(ISE_DIR); \
	export PATH=$(XILPATH):$$PATH; \
	./$(PROJECT)_isim.exe $(ISIM_ARGS) &

isim_bat : $(ISE_DIR)/$(PROJECT)_isim.exe $(ISE_DIR)/$(PROJECT)_isim.cmd $(ISE_DIR)/$(PROJECT).wcfg $(TESTBENCH)/ssram.dat makefile
	@cd $(ISE_DIR); \
	export PATH=$(XILPATH):$$PATH; \
	./$(PROJECT)_isim.exe -gui &

#
# Questasim
#

WAVE_BUSES := \
	"add wave -noupdate -divider {BUSSES}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {clk}                  {/testbench/uKS10/uKS10/uCPU/clk}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {DP}                   {/testbench/uKS10/uKS10/uCPU/dp}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {DBUS}                 {/testbench/uKS10/uKS10/uCPU/dbus}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {DBM}                  {/testbench/uKS10/uKS10/uCPU/dbm}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {RAMFILE}              {/testbench/uKS10/uKS10/uCPU/ramfile}" \

WAVE_CPU := \
	"add wave -noupdate -divider {CPU}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {clk}                  {/testbench/uKS10/uKS10/uCPU/clk}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {CROM J}               {/testbench/uKS10/uKS10/uCPU/uUSEQ/uCROM/addr}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {CROM ADDR}            {/testbench/uKS10/uKS10/uCPU/uUSEQ/addr}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {CROM CURR ADDR}       {/testbench/uKS10/uKS10/uCPU/uUSEQ/uSTACK/currADDR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {PC}                   {/testbench/uKS10/uKS10/uDEBUG/PC}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {IR}                   {/testbench/uKS10/uKS10/uDEBUG/IR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { 0: MAG}              {/testbench/uKS10/uKS10/uCPU/uALU/aluRAM[0][2:37]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { 1: PC}               {/testbench/uKS10/uKS10/uCPU/uALU/aluRAM[1][2:37]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { 2: HR}               {/testbench/uKS10/uKS10/uCPU/uALU/aluRAM[2][2:37]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { 3: AR}               {/testbench/uKS10/uKS10/uCPU/uALU/aluRAM[3][2:37]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { 4: ARX}              {/testbench/uKS10/uKS10/uCPU/uALU/aluRAM[4][2:37]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { 5: BR}               {/testbench/uKS10/uKS10/uCPU/uALU/aluRAM[5][2:37]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { 6: BRX}              {/testbench/uKS10/uKS10/uCPU/uALU/aluRAM[6][2:37]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { 7: ONE}              {/testbench/uKS10/uKS10/uCPU/uALU/aluRAM[7][2:37]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { 8: EBR}              {/testbench/uKS10/uKS10/uCPU/uALU/aluRAM[8][2:37]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { 9: UBR}              {/testbench/uKS10/uKS10/uCPU/uALU/aluRAM[9][2:37]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {10: MASK}             {/testbench/uKS10/uKS10/uCPU/uALU/aluRAM[10][2:37]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {11: FLG}              {/testbench/uKS10/uKS10/uCPU/uALU/aluRAM[11][2:37]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {12: PI}               {/testbench/uKS10/uKS10/uCPU/uALU/aluRAM[12][2:37]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {13: XWD1}             {/testbench/uKS10/uKS10/uCPU/uALU/aluRAM[13][2:37]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {14: T0}               {/testbench/uKS10/uKS10/uCPU/uALU/aluRAM[14][2:37]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {15: T1}               {/testbench/uKS10/uKS10/uCPU/uALU/aluRAM[15][2:37]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {AC0}                  {/testbench/uKS10/uKS10/uCPU/uRAMFILE/ram[0]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {AC1}                  {/testbench/uKS10/uKS10/uCPU/uRAMFILE/ram[1]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {AC2}                  {/testbench/uKS10/uKS10/uCPU/uRAMFILE/ram[2]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {AC3}                  {/testbench/uKS10/uKS10/uCPU/uRAMFILE/ram[3]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {AC4}                  {/testbench/uKS10/uKS10/uCPU/uRAMFILE/ram[4]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {AC5}                  {/testbench/uKS10/uKS10/uCPU/uRAMFILE/ram[5]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {AC6}                  {/testbench/uKS10/uKS10/uCPU/uRAMFILE/ram[6]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {AC7}                  {/testbench/uKS10/uKS10/uCPU/uRAMFILE/ram[7]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {AC8}                  {/testbench/uKS10/uKS10/uCPU/uRAMFILE/ram[8]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {AC9}                  {/testbench/uKS10/uKS10/uCPU/uRAMFILE/ram[9]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {AC10}                 {/testbench/uKS10/uKS10/uCPU/uRAMFILE/ram[10]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {AC11}                 {/testbench/uKS10/uKS10/uCPU/uRAMFILE/ram[11]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {AC12}                 {/testbench/uKS10/uKS10/uCPU/uRAMFILE/ram[12]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {AC13}                 {/testbench/uKS10/uKS10/uCPU/uRAMFILE/ram[13]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {AC14}                 {/testbench/uKS10/uKS10/uCPU/uRAMFILE/ram[14]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {AC15}                 {/testbench/uKS10/uKS10/uCPU/uRAMFILE/ram[15]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pageFAIL}             {/testbench/uKS10/uKS10/uCPU/pageFAIL}"

WAVE_CPU_INTF := \
	"add wave -noupdate -divider {CPU Interface}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {clk}                  {/testbench/uKS10/uKS10/uCPU/clk}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {clken}                {/testbench/uKS10/uKS10/uCPU/uINTF/clken}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cpuREQO}              {/testbench/uKS10/uKS10/uCPU/cpuREQO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cpuACKI}              {/testbench/uKS10/uKS10/uCPU/cpuACKI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cpuADDRO[0:35]}       {/testbench/uKS10/uKS10/uCPU/cpuADDRO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { 3: READ}             {/testbench/uKS10/uKS10/uCPU/cpuADDRO[3]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { 4: WRTEST}           {/testbench/uKS10/uKS10/uCPU/cpuADDRO[4]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { 5: WRITE}            {/testbench/uKS10/uKS10/uCPU/cpuADDRO[5]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {10: IO}               {/testbench/uKS10/uKS10/uCPU/cpuADDRO[10]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {11: WRU}              {/testbench/uKS10/uKS10/uCPU/cpuADDRO[11]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {12: VECT}             {/testbench/uKS10/uKS10/uCPU/cpuADDRO[12]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cpuADDRO[14:35]}      {/testbench/uKS10/uKS10/uCPU/cpuADDRO[14:35]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cpuDATAI}             {/testbench/uKS10/uKS10/uCPU/cpuDATAI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cpuDATAO}             {/testbench/uKS10/uKS10/uCPU/cpuDATAO}" \

WAVE_CSL := \
	"add wave -noupdate -divider {CSL}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {conDATA}               {/testbench/uKS10/uKS10/uCSL/conDATA}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {conADDR}               {/testbench/uKS10/uKS10/uCSL/conADDR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {conBHE_N}              {/testbench/uKS10/uKS10/uCSL/conBHE_N}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {conBLE_N}              {/testbench/uKS10/uKS10/uCSL/conBLE_N}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {conRD_N}               {/testbench/uKS10/uKS10/uCSL/conRD_N}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {conWR_N}               {/testbench/uKS10/uKS10/uCSL/conWR_N}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busREQI}               {/testbench/uKS10/uKS10/uCSL/busREQI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busREQO}               {/testbench/uKS10/uKS10/uCSL/busREQO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busACKI}               {/testbench/uKS10/uKS10/uCSL/busACKI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busACKO}               {/testbench/uKS10/uKS10/uCSL/busACKO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busADDRI}              {/testbench/uKS10/uKS10/uCSL/busADDRI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busADDRO}              {/testbench/uKS10/uKS10/uCSL/busADDRO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busDATAI}              {/testbench/uKS10/uKS10/uCSL/busDATAI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busDATAO}              {/testbench/uKS10/uKS10/uCSL/busDATAO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {regCIR}                {/testbench/uKS10/uKS10/uCSL/regCIR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {regDATA}               {/testbench/uKS10/uKS10/uCSL/regDATA}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {regADDR}               {/testbench/uKS10/uKS10/uCSL/regADDR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dzCCR}                 {/testbench/uKS10/uKS10/uCSL/dzCCR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpCCR}                 {/testbench/uKS10/uKS10/uCSL/lpCCR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {rpCCR}                 {/testbench/uKS10/uKS10/uCSL/rpCCR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cslGO}                 {/testbench/uKS10/uKS10/uCSL/cslGO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busIO}                 {/testbench/uKS10/uKS10/uCSL/busIO}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {state}                 {/testbench/uKS10/uKS10/uCSL/state}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {timer}                 {/testbench/uKS10/uKS10/uCSL/timer}" \

WAVE_DBM := \
	"add wave -noupdate -divider {DBM}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {clk}                  {/testbench/uKS10/uKS10/uCPU/clk}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {memCLK}               {/testbench/uKS10/uKS10/uCPU/uDBM/memCLK}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {clkPHS}               {/testbench/uKS10/uKS10/uCPU/uDBM/clkPHS}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {enable}               {/testbench/uKS10/uKS10/uCPU/uDBM/enable}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mux}                  {/testbench/uKS10/uKS10/uCPU/uDBM/mux}" \

WAVE_INTF := \
	"add wave -noupdate -divider {INTF}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cpuRUN}               {/testbench/uKS10/uKS10/uCPU/uINTF/cpuRUN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cpuCONT}              {/testbench/uKS10/uKS10/uCPU/uINTF/cpuCONT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cpuEXEC}              {/testbench/uKS10/uKS10/uCPU/uINTF/cpuEXEC}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cpuHALT}              {/testbench/uKS10/uKS10/uCPU/uINTF/cpuHALT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cslSET}               {/testbench/uKS10/uKS10/uCPU/uINTF/cslSET}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cslRUN}               {/testbench/uKS10/uKS10/uCPU/uINTF/cslRUN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cslEXEC}              {/testbench/uKS10/uKS10/uCPU/uINTF/cslEXEC}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cslCONT}              {/testbench/uKS10/uKS10/uCPU/uINTF/cslCONT}" \

WAVE_MEM := \
	"add wave -noupdate -color \"lightblue\" -divider {Memory Interface}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busREQI}              {/testbench/uKS10/uKS10/uMEM/busREQI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busACKO}              {/testbench/uKS10/uKS10/uMEM/busACKO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busADDRI}             {/testbench/uKS10/uKS10/uMEM/busADDRI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busDATAI}             {/testbench/uKS10/uKS10/uMEM/busDATAI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busDATAO}             {/testbench/uKS10/uKS10/uMEM/busDATAO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {memREAD}              {/testbench/uKS10/uKS10/uMEM/memREAD}"  \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {memWRITE}             {/testbench/uKS10/uKS10/uMEM/memWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {memWRTEST}            {/testbench/uKS10/uKS10/uMEM/memWRTEST}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ssramDATA}            {/testbench/uKS10/uKS10/uMEM/ssramDATA}"

WAVE_ARB := \
	"add wave -noupdate -divider {ARBITER}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubaREQI}              {/testbench/uKS10/uKS10/uARB/ubaREQI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubaREQO}              {/testbench/uKS10/uKS10/uARB/ubaREQO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubaACKI}              {/testbench/uKS10/uKS10/uARB/ubaACKI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {uba1ADDRI}            {/testbench/uKS10/uKS10/uARB/uba1ADDRI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {uba1ADDRO}            {/testbench/uKS10/uKS10/uARB/uba1ADDRO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {uba1DATAI}            {/testbench/uKS10/uKS10/uARB/uba1DATAI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {uba1DATAO}            {/testbench/uKS10/uKS10/uARB/uba1DATAO}"

WAVE_KS10 :=\
	"add wave -noupdate -divider {KS10 Device Interconnect}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQI}              {/testbench/uKS10/uKS10/devREQI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQO}              {/testbench/uKS10/uKS10/devREQO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devACKI}              {/testbench/uKS10/uKS10/devACKI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devACKO}              {/testbench/uKS10/uKS10/devACKO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devADDRI}             {/testbench/uKS10/uKS10/devADDRI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devADDRO}             {/testbench/uKS10/uKS10/devADDRO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAI}             {/testbench/uKS10/uKS10/devDATAI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAO}             {/testbench/uKS10/uKS10/devDATAO}"

WAVE_UBA1 := \
	"add wave -noupdate -divider {UBA 1}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busREQI}              {/testbench/uKS10/uKS10/UBA1/busREQI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busREQO}              {/testbench/uKS10/uKS10/UBA1/busREQO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busACKI}              {/testbench/uKS10/uKS10/UBA1/busACKI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busACKO}              {/testbench/uKS10/uKS10/UBA1/busACKO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busADDRI}             {/testbench/uKS10/uKS10/UBA1/busADDRI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busADDRO}             {/testbench/uKS10/uKS10/UBA1/busADDRO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busDATAI}             {/testbench/uKS10/uKS10/UBA1/busDATAI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busDATAO}             {/testbench/uKS10/uKS10/UBA1/busDATAO}" \
	"add wave -noupdate -divider {Debug}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQI[1]}           {/testbench/uKS10/uKS10/UBA1/devREQI[1]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQI[2]}           {/testbench/uKS10/uKS10/UBA1/devREQI[2]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQI[3]}           {/testbench/uKS10/uKS10/UBA1/devREQI[3]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQI[4]}           {/testbench/uKS10/uKS10/UBA1/devREQI[4]}" \
	"add wave -noupdate -divider {UBA 1, Demuxed}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devADDRI}             {/testbench/uKS10/uKS10/UBA1/busADDRI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAI}             {/testbench/uKS10/uKS10/UBA1/busDATAI}" \
	"add wave -noupdate -divider {UBA 1, DEV 1}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQI}              {/testbench/uKS10/uKS10/UBA1/devREQI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQO}              {/testbench/uKS10/uKS10/UBA1/devREQO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devACKI}              {/testbench/uKS10/uKS10/UBA1/devACKI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devACKO}              {/testbench/uKS10/uKS10/UBA1/devACKO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dev1ADDRI}            {/testbench/uKS10/uKS10/UBA1/dev1ADDRI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dev1ADDRO}            {/testbench/uKS10/uKS10/UBA1/dev1ADDRO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dev1DATAI}            {/testbench/uKS10/uKS10/UBA1/dev1DATAI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dev1DATAO}            {/testbench/uKS10/uKS10/UBA1/dev1DATAO}"

WAVE_UBA3 := \
	"add wave -noupdate -divider {UBA 3}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busREQI}              {/testbench/uKS10/uKS10/UBA3/busREQI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busREQO}              {/testbench/uKS10/uKS10/UBA3/busREQO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busACKI}              {/testbench/uKS10/uKS10/UBA3/busACKI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busACKO}              {/testbench/uKS10/uKS10/UBA3/busACKO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busADDRI}             {/testbench/uKS10/uKS10/UBA3/busADDRI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busADDRO}             {/testbench/uKS10/uKS10/UBA3/busADDRO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busDATAI}             {/testbench/uKS10/uKS10/UBA3/busDATAI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busDATAO}             {/testbench/uKS10/uKS10/UBA3/busDATAO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busINTR}              {/testbench/uKS10/uKS10/UBA3/busINTR}" \
	"add wave -noupdate -divider {UBA 3, Demuxed}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devADDRI}             {/testbench/uKS10/uKS10/UBA3/busADDRI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAI}             {/testbench/uKS10/uKS10/UBA3/busDATAI}" \
	"add wave -noupdate -divider {UBA 3, Error Stuff}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {setNXD}               {/testbench/uKS10/uKS10/UBA3/setNXD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {setTMO}               {/testbench/uKS10/uKS10/UBA3/setTMO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pageFAIL}             {/testbench/uKS10/uKS10/UBA3/pageFAIL}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pageFLAGS}            {/testbench/uKS10/uKS10/UBA3/pageFLAGS}" \
	"add wave -noupdate -divider {UBA 3, DEV 1}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQI}              {/testbench/uKS10/uKS10/UBA3/devREQI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQO}              {/testbench/uKS10/uKS10/UBA3/devREQO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devACKI}              {/testbench/uKS10/uKS10/UBA3/devACKI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devACKO}              {/testbench/uKS10/uKS10/UBA3/devACKO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dev1INTR}             {/testbench/uKS10/uKS10/UBA3/dev1INTR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dev1INTA}             {/testbench/uKS10/uKS10/UBA3/dev1INTA}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dev1ADDRI}            {/testbench/uKS10/uKS10/UBA3/dev1ADDRI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dev1ADDRO}            {/testbench/uKS10/uKS10/UBA3/dev1ADDRO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dev1DATAI}            {/testbench/uKS10/uKS10/UBA3/dev1DATAI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dev1DATAO}            {/testbench/uKS10/uKS10/UBA3/dev1DATAO}" \
	"add wave -noupdate -divider {UBA 3, DEV 2}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQI}              {/testbench/uKS10/uKS10/UBA3/devREQI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQO}              {/testbench/uKS10/uKS10/UBA3/devREQO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devACKI}              {/testbench/uKS10/uKS10/UBA3/devACKI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devACKO}              {/testbench/uKS10/uKS10/UBA3/devACKO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dev2INTR}             {/testbench/uKS10/uKS10/UBA3/dev2INTR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dev2INTA}             {/testbench/uKS10/uKS10/UBA3/dev2INTA}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dev2ADDRI}            {/testbench/uKS10/uKS10/UBA3/dev2ADDRI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dev2ADDRO}            {/testbench/uKS10/uKS10/UBA3/dev2ADDRO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dev2DATAI}            {/testbench/uKS10/uKS10/UBA3/dev2DATAI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dev2DATAO}            {/testbench/uKS10/uKS10/UBA3/dev2DATAO}"

WAVE_RH11 := \
	"add wave -noupdate -divider {RH11}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQI}              {/testbench/uKS10/uKS10/uRH11/devREQI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQO}              {/testbench/uKS10/uKS10/uRH11/devREQO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devACKI}              {/testbench/uKS10/uKS10/uRH11/devACKI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devACKO}              {/testbench/uKS10/uKS10/uRH11/devACKO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAI}             {/testbench/uKS10/uKS10/uRH11/devDATAI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAO}             {/testbench/uKS10/uKS10/uRH11/devDATAO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devADDRI}             {/testbench/uKS10/uKS10/uRH11/devADDRI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devADDRO}             {/testbench/uKS10/uKS10/uRH11/devADDRO}"

WAVE_SD := \
	"add wave -noupdate -divider {SD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ch}                   {/testbench/SD/ch}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {spiTX}                {/testbench/SD/spiTX}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQO}              {/testbench/uKS10/uKS10/uRH11/uSD/devREQO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAO}             {/testbench/uKS10/uKS10/uRH11/uSD/devDATAO}" \

WAVE_LP20 :=\
	"add wave -noupdate -divider {LP20}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpONLINE}             {/testbench/uKS10/uKS10/uLP20/lpONLINE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQI}              {/testbench/uKS10/uKS10/uLP20/devREQI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQO}              {/testbench/uKS10/uKS10/uLP20/devREQO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devACKI}              {/testbench/uKS10/uKS10/uLP20/devACKI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devACKO}              {/testbench/uKS10/uKS10/uLP20/devACKO}" \
	"add wave -noupdate -radix binary   -radixshowbase 0 -label {devINTR}              {/testbench/uKS10/uKS10/uLP20/devINTR}" \
	"add wave -noupdate -radix binary   -radixshowbase 0 -label {devINTA}              {/testbench/uKS10/uKS10/uLP20/devINTA}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAI}             {/testbench/uKS10/uKS10/uLP20/devDATAI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAO}             {/testbench/uKS10/uKS10/uLP20/devDATAO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devADDRI}             {/testbench/uKS10/uKS10/uLP20/devADDRI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devADDRO}             {/testbench/uKS10/uKS10/uLP20/devADDRO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREAD}              {/testbench/uKS10/uKS10/uLP20/devREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devWRITE}             {/testbench/uKS10/uKS10/uLP20/devWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devIO}                {/testbench/uKS10/uKS10/uLP20/devIO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devIOBYTE}            {/testbench/uKS10/uKS10/uLP20/devIOBYTE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devWRU}               {/testbench/uKS10/uKS10/uLP20/devWRU}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpTOF}                {/testbench/uKS10/uKS10/uLP20/lpTOF}" \
	"add wave -noupdate -divider {LP20 REGS}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {CSRA REG}             {/testbench/uKS10/uKS10/uLP20/regCSRA}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {CSRB REG}             {/testbench/uKS10/uKS10/uLP20/regCSRB}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {BAR  REG}             {/testbench/uKS10/uKS10/uLP20/regBAR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {BCTR REG}             {/testbench/uKS10/uKS10/uLP20/regBCTR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {PCTR REG}             {/testbench/uKS10/uKS10/uLP20/regPCTR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {RAMD REG}             {/testbench/uKS10/uKS10/uLP20/regRAMD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {CCTR REG}             {/testbench/uKS10/uKS10/uLP20/regCCTR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {CBUF REG}             {/testbench/uKS10/uKS10/uLP20/regCBUF}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {CKSM REG}             {/testbench/uKS10/uKS10/uLP20/regCKSM}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {PDAT REG}             {/testbench/uKS10/uKS10/uLP20/regPDAT}" \
	"add wave -noupdate -divider {LP20 DMA}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpCMDGO}              {/testbench/uKS10/uKS10/uLP20/DMA/lpCMDGO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpCMDSTOP}            {/testbench/uKS10/uKS10/uLP20/DMA/lpCMDSTOP}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpREADY}              {/testbench/uKS10/uKS10/uLP20/DMA/lpREADY}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {DMA state}            {/testbench/uKS10/uKS10/uLP20/DMA/state}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {DMA timer}            {/testbench/uKS10/uKS10/uLP20/DMA/timer}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpDONE}               {/testbench/uKS10/uKS10/uLP20/DMA/lpDONE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpTESTMSYN}           {/testbench/uKS10/uKS10/uLP20/DMA/lpTESTMSYN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpTESTMPE}            {/testbench/uKS10/uKS10/uLP20/DMA/lpTESTMPE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpINCR}               {/testbench/uKS10/uKS10/uLP20/DMA/lpINCR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpSETMSYN}            {/testbench/uKS10/uKS10/uLP20/DMA/lpSETMSYN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpSETMPE}             {/testbench/uKS10/uKS10/uLP20/DMA/lpSETMPE}" \
	"add wave -noupdate -divider {LP20 Interrupts}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devINTR}              {/testbench/uKS10/uKS10/uLP20/INTR/devINTR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devINTA}              {/testbench/uKS10/uKS10/uLP20/INTR/devINTA}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpINTR}               {/testbench/uKS10/uKS10/uLP20/INTR/lpINTR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpIE}                 {/testbench/uKS10/uKS10/uLP20/INTR/lpIE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpIRQ}                {/testbench/uKS10/uKS10/uLP20/INTR/lpIRQ}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpSETIRQ}             {/testbench/uKS10/uKS10/uLP20/CSRA/lpSETIRQ}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpSETERR}             {/testbench/uKS10/uKS10/uLP20/CSRA/lpSETERR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpSETPCZ}             {/testbench/uKS10/uKS10/uLP20/CSRA/lpSETPCZ}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpSETUNDC}            {/testbench/uKS10/uKS10/uLP20/CSRA/lpSETUNDC}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpSETDONE}            {/testbench/uKS10/uKS10/uLP20/CSRA/lpDONE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpVFURDY}             {/testbench/uKS10/uKS10/uLP20/CSRA/lpVFURDY}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpONLINE}             {/testbench/uKS10/uKS10/uLP20/CSRA/lpONLINE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lastONLINE}           {/testbench/uKS10/uKS10/uLP20/CSRA/lastONLINE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpINIT}               {/testbench/uKS10/uKS10/uLP20/INTR/lpINIT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devWRI}               {/testbench/uKS10/uKS10/uLP20/INTR/devWRU}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {vectREAD}             {/testbench/uKS10/uKS10/uLP20/INTR/vectREAD}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {state}                {/testbench/uKS10/uKS10/uLP20/INTR/state}" \
	"add wave -noupdate -divider {LP20 RAMD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQO}              {/testbench/uKS10/uKS10/uLP20/RAMD/devREQO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devACKI}              {/testbench/uKS10/uKS10/uLP20/RAMD/devACKI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpDATAI}              {/testbench/uKS10/uKS10/uLP20/RAMD/lpDATAI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ramWRITE}             {/testbench/uKS10/uKS10/uLP20/RAMD/ramWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {wordDATAI}            {/testbench/uKS10/uKS10/uLP20/RAMD/wordDATAI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {byteDATAI}            {/testbench/uKS10/uKS10/uLP20/RAMD/byteDATAI}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {ramADDR}              {/testbench/uKS10/uKS10/uLP20/RAMD/ramADDR}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {lpADDR}               {/testbench/uKS10/uKS10/uLP20/RAMD/lpADDR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpCMDGO}              {/testbench/uKS10/uKS10/uLP20/RAMD/lpCMDGO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpINCADDR}            {/testbench/uKS10/uKS10/uLP20/RAMD/lpINCADDR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpMODEPRINT}          {/testbench/uKS10/uKS10/uLP20/RAMD/lpMODEPRINT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpMODETEST}           {/testbench/uKS10/uKS10/uLP20/RAMD/lpMODETEST}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpMODELDVFU}          {/testbench/uKS10/uKS10/uLP20/RAMD/lpMODELDVFU}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpMODELDRAM}          {/testbench/uKS10/uKS10/uLP20/RAMD/lpMODELDRAM}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ram[0]}               {/testbench/uKS10/uKS10/uLP20/RAMD/ram[0]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ram[1]}               {/testbench/uKS10/uKS10/uLP20/RAMD/ram[1]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {regRAMD}              {/testbench/uKS10/uKS10/uLP20/RAMD/regRAMD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpRPEEN}              {/testbench/uKS10/uKS10/uLP20/RAMD/lpRPEEN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpDHLDEN}             {/testbench/uKS10/uKS10/uLP20/RAMD/lpDHLDEN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpSETDHLD}            {/testbench/uKS10/uKS10/uLP20/RAMD/lpSETDHLD}" \
	"add wave -noupdate -divider {LP20 PDAT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQO}              {/testbench/uKS10/uKS10/uLP20/PDAT/devREQO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devACKI}              {/testbench/uKS10/uKS10/uLP20/PDAT/devACKI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpDMAWR}              {/testbench/uKS10/uKS10/uLP20/PDAT/lpDMAWR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {CBUF REG}             {/testbench/uKS10/uKS10/uLP20/PDAT/lpCBUF}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {CBUF REG}             {/testbench/uKS10/uKS10/uLP20/PDAT/lpCBUF}" \
	"add wave -noupdate -radix ascii    -radixshowbase 0 -label {CBUF REG}             {/testbench/uKS10/uKS10/uLP20/PDAT/lpCBUF}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {RAMD REG}             {/testbench/uKS10/uKS10/uLP20/PDAT/lpRAMD}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {CCTR REG}             {/testbench/uKS10/uKS10/uLP20/PDAT/lpCCTR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpOP}                 {/testbench/uKS10/uKS10/uLP20/PDAT/lpOP}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpTESTDTE}            {/testbench/uKS10/uKS10/uLP20/PDAT/lpTESTDTE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpTESTLPE}            {/testbench/uKS10/uKS10/uLP20/PDAT/lpTESTLPE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpSETDTE}             {/testbench/uKS10/uKS10/uLP20/PDAT/lpSETDTE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpDPAR}               {/testbench/uKS10/uKS10/uLP20/PDAT/lpDPAR}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {state}                {/testbench/uKS10/uKS10/uLP20/PDAT/state}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpCLRCCTR}            {/testbench/uKS10/uKS10/uLP20/PDAT/lpCLRCCTR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpINCCCTR}            {/testbench/uKS10/uKS10/uLP20/PDAT/lpINCCCTR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpSETUNDC}            {/testbench/uKS10/uKS10/uLP20/PDAT/lpSETUNDC}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpSETDTE}             {/testbench/uKS10/uKS10/uLP20/PDAT/lpSETDTE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpDEMAND}             {/testbench/uKS10/uKS10/uLP20/PDAT/lpDEMAND}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpVAL}                {/testbench/uKS10/uKS10/uLP20/PDAT/lpVAL}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpLPE}                {/testbench/uKS10/uKS10/uLP20/PDAT/lpLPE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpPI}                 {/testbench/uKS10/uKS10/uLP20/PDAT/lpPI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpSTROBE}             {/testbench/uKS10/uKS10/uLP20/PDAT/lpSTROBE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpDATA}               {/testbench/uKS10/uKS10/uLP20/PDAT/lpDATA}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpPDAT}               {/testbench/uKS10/uKS10/uLP20/PDAT/lpPDAT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpPARERR}             {/testbench/uKS10/uKS10/uLP20/PDAT/lpPARERR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpREADY}              {/testbench/uKS10/uKS10/uLP20/DMA/lpREADY}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {strobe}               {/testbench/uKS10/uKS10/uLP20/PDAT/strobe}" \
	"add wave -noupdate -divider {LP26}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {clk}                  {/testbench/uKS10/uKS10/uLP26/clk}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {rst}                  {/testbench/uKS10/uKS10/uLP26/rst}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpINIT}               {/testbench/uKS10/uKS10/uLP26/lpINIT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpOVFU}               {/testbench/uKS10/uKS10/uLP26/lpOVFU}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpSETONLN}            {/testbench/uKS10/uKS10/uLP26/lpSETONLN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpSETOFFLN}           {/testbench/uKS10/uKS10/uLP26/lpSETOFFLN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpONLINE}             {/testbench/uKS10/uKS10/uLP26/lpONLINE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpSTROBE}             {/testbench/uKS10/uKS10/uLP26/lpSTROBE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpPI}                 {/testbench/uKS10/uKS10/uLP26/lpPI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpDATA}               {/testbench/uKS10/uKS10/uLP26/lpDATA}" \
	"add wave -noupdate -radix ascii    -radixshowbase 0 -label {lpDATA}               {/testbench/uKS10/uKS10/uLP26/lpDATA}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpDPAR}               {/testbench/uKS10/uKS10/uLP26/lpDPAR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpPARERR}             {/testbench/uKS10/uKS10/uLP26/lpPARERR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpVFURDY}             {/testbench/uKS10/uKS10/uLP26/lpVFURDY}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpDEMAND}             {/testbench/uKS10/uKS10/uLP26/lpDEMAND}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {lpLCTR}               {/testbench/uKS10/uKS10/uLP26/lpLCTR}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {lpVFULEN}             {/testbench/uKS10/uKS10/uLP26/lpVFULEN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpTXEMPTY}            {/testbench/uKS10/uKS10/uLP26/lpTXEMPTY}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpTXSTB}              {/testbench/uKS10/uKS10/uLP26/lpTXSTB}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpTXDAT}              {/testbench/uKS10/uKS10/uLP26/lpTXDAT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpXON}                {/testbench/uKS10/uKS10/uLP26/lpXON}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {state}                {/testbench/uKS10/uKS10/uLP26/state}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {lpDVFULEN}            {/testbench/uKS10/uKS10/uLP26/lpDVFULEN}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {lpOVFULEN}            {/testbench/uKS10/uKS10/uLP26/lpOVFULEN}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {lpVFULEN}             {/testbench/uKS10/uKS10/uLP26/lpVFULEN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpTEMP}               {/testbench/uKS10/uKS10/uLP26/lpTEMP}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {lpCOUNT}              {/testbench/uKS10/uKS10/uLP26/lpCOUNT}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {lpLFCNT}              {/testbench/uKS10/uKS10/uLP26/lpLFCNT}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {lpLCTR}               {/testbench/uKS10/uKS10/uLP26/lpLCTR}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {lpCCTR}               {/testbench/uKS10/uKS10/uLP26/lpCCTR}" \
	"add wave -noupdate -radix ascii    -radixshowbase 0 -label {lpLINBUF}             {/testbench/uKS10/uKS10/uLP26/lpLINBUF}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpTOF}                {/testbench/uKS10/uKS10/uLP26/lpTOF}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpVFUDAT[0]}          {/testbench/uKS10/uKS10/uLP26/lpVFUDAT[0]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpVFUDAT[1]}          {/testbench/uKS10/uKS10/uLP26/lpVFUDAT[1]}" \
	"add wave -noupdate -divider {LP20 UART}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {clken}                {/testbench/uKS10/uKS10/uLP26/TX/clken}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {load}                 {/testbench/uKS10/uKS10/uLP26/TX/load}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {data}                 {/testbench/uKS10/uKS10/uLP26/TX/data}" \
	"add wave -noupdate -radix ascii    -radixshowbase 0 -label {data}                 {/testbench/uKS10/uKS10/uLP26/TX/data}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {state}                {/testbench/uKS10/uKS10/uLP26/TX/state}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {empty}                {/testbench/uKS10/uKS10/uLP26/TX/empty}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {intr}                 {/testbench/uKS10/uKS10/uLP26/TX/intr}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpRXD}                {/testbench/uKS10/uKS10/uLP26/lpRXD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpTXD}                {/testbench/uKS10/uKS10/uLP26/lpTXD}" \
	"add wave -noupdate -divider {LP20 REG READ/WRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAI}             {/testbench/uKS10/uKS10/uLP20/devDATAI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAO}             {/testbench/uKS10/uKS10/uLP20/devDATAO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {csraREAD}             {/testbench/uKS10/uKS10/uLP20/csraREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {csraWRITE}            {/testbench/uKS10/uKS10/uLP20/csraWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {csrbREAD}             {/testbench/uKS10/uKS10/uLP20/csrbREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {csrbWRITE}            {/testbench/uKS10/uKS10/uLP20/csrbWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {barREAD}              {/testbench/uKS10/uKS10/uLP20/barREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {barWRITE}             {/testbench/uKS10/uKS10/uLP20/barWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {bctrREAD}             {/testbench/uKS10/uKS10/uLP20/bctrREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {bctrWRITE}            {/testbench/uKS10/uKS10/uLP20/bctrWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pctrREAD}             {/testbench/uKS10/uKS10/uLP20/pctrREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pctrWRITE}            {/testbench/uKS10/uKS10/uLP20/pctrWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ramdREAD}             {/testbench/uKS10/uKS10/uLP20/ramdREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ramdWRITE}            {/testbench/uKS10/uKS10/uLP20/ramdWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cctrREAD}             {/testbench/uKS10/uKS10/uLP20/cctrREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cctrWRITE}            {/testbench/uKS10/uKS10/uLP20/cctrWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cbufREAD}             {/testbench/uKS10/uKS10/uLP20/cbufREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cbufWRITE}            {/testbench/uKS10/uKS10/uLP20/cbufWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cksmREAD}             {/testbench/uKS10/uKS10/uLP20/cksmREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cksmWRITE}            {/testbench/uKS10/uKS10/uLP20/cksmWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pdatREAD}             {/testbench/uKS10/uKS10/uLP20/pdatREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pdatWRITE}            {/testbench/uKS10/uKS10/uLP20/pdatWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {vectREAD}             {/testbench/uKS10/uKS10/uLP20/vectREAD}"

WAVE_FIRST := \
	"onerror {resume}" \
	"quietly WaveActivateNextPane {} 0 " \
	"view wave" \
	"add wave -noupdate -radix octal    -radixshowbase 0 clk" \
	"add wave -noupdate -radix octal    -radixshowbase 0 reset" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {clkPHS}               {/testbench/uKS10/uKS10/uCLK/clkPHS}" \

WAVE_LAST := \
       "run -a"

VLOG_ARGS := \
	-work $(QUESTA_DIR)/work \
	-lint \
	+incdir+ks10 \
	+incdir+ks10/uba \
	+incdir+ks10/cpu \
	+incdir+ks10/cpu/useq \
	+incdir+ks10/debug \
	+incdir+ks10/dz11 \
	+incdir+ks10/dz11/uart \
	+incdir+ks10/lp20 \
	+incdir+ks10/mem \
	+incdir+ks10/rh11 \
	+incdir+ks10/rh11/rpxx \
	+incdir+ks10/rh11/sd \
	+incdir+ks10/utils \
	+incdir+ks10/utils/uart \
	+define+SSRAM_DAT=\"$(TESTBENCH)/ssram.dat\" \
	+define+CROM_DAT=\"$(CROM_DAT)\" \
	+define+DROM_DAT=\"$(DROM_DAT)\" \
	+define+UNIT0_DSK=\"$(UNIT0_DSK)\" \
	+define+UNIT1_DSK=\"$(UNIT1_DSK)\" \
	+define+UNIT2_DSK=\"$(UNIT2_DSK)\" \
	+define+UNIT3_DSK=\"$(UNIT3_DSK)\" \
	+define+UNIT4_DSK=\"$(UNIT4_DSK)\" \
	+define+UNIT5_DSK=\"$(UNIT5_DSK)\" \
	+define+UNIT6_DSK=\"$(UNIT6_DSK)\" \
	+define+UNIT7_DSK=\"$(UNIT7_DSK)\" \
	$(subst -D ,+define+,$(SIM_ARGS) $(SYN_ARGS))

WAVE_LIST := \
	$(WAVE_FIRST) \
	$(WAVE_MEM) \
	$(WAVE_CPU_INTF) \
	$(WAVE_CPU) \
	$(WAVE_ARB) \
	$(WAVE_KS10) \
	$(WAVE_UBA3) \
	$(WAVE_LP20) \
	$(WAVE_LAST)

$(QUESTA_DIR)/wave.do: makefile
	@echo "Creating "$@ > /dev/stderr
	@echo "" > $@
	@for CMD in $(WAVE_LIST); \
	do \
	    echo $$CMD >> $@; \
	done

vsim:   $(SIM_FILES) $(RTL_FILES) $(INC_FILES) $(DAT_FILES) $(SIM_DISK) $(TESTBENCH)/ssram.dat $(DISKS) makefile $(QUESTA_DIR)/wave.do
	test -d $(QUESTA_DIR)/work || $(VLIB) $(QUESTA_DIR)/workx
	$(VMAP) work $(QUESTA_DIR)/work
	$(VLOG) $(SIM_FILES) $(RTL_FILES) $(VLOG_ARGS)
	$(VSIM) -i testbench -do $(QUESTA_DIR)/wave.do

questa: $(SIM_FILES) $(RTL_FILES) $(INC_FILES) $(DAT_FILES) $(SIM_DISK) $(TESTBENCH)/ssram.dat $(DISKS) makefile $(QUESTA_DIR)/wave.do
	$(VLIB) $(QUESTA_DIR)/work
	$(VMAP) work $(QUESTA_DIR)/work
	$(VLOG) $(SIM_FILES) $(RTL_FILES) $(VLOG_ARGS)
	$(VOPT) testbench +acc=npr3+LP20+LP26+CPU -o testbench_opt -debugdb
	$(VSIM) -i -debugdb testbench_opt -do $(QUESTA_DIR)/wave.do  &

#
# Vivado
#

vivado: $(TESTBENCH)/ssram.dat
	$(VIVADO) -help

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

#
# Some versions of XST don't set the return status correctly.  We have to
# grep the listing file to see if the build succeeded
#

$(ISE_DIR)/$(PROJECT).ngc $(ISE_DIR)/$(PROJECT).ngr: $(ISE_DIR)/$(PROJECT).xst $(ISE_DIR)/$(PROJECT).prj $(ISE_DIR)/$(PROJECT).filter $(RTL_FILES) $(INC_FILES) $(DAT_FILES) makefile
	@cd $(ISE_DIR); \
	echo "################################################################################" | tee    $(PROJECT).log; \
	echo Running XST | tee -a $(PROJECT).log; \
	echo $(XST) $(XST_OPTS) -ifn $(PROJECT).xst -ofn $(PROJECT).syr | tee -a $(PROJECT).log; \
	echo "################################################################################" | tee -a $(PROJECT).log; \
	rm -f $(PROJECT).ngc; \
	$(XST) $(XST_OPTS) -ifn $(PROJECT).xst -ofn $(PROJECT).syr | tee -a $(PROJECT).log;

#	grep -e "Number of errors[ ]*:[ ]*0" < $(PROJECT).syr

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

$(ISE_DIR)/$(PROJECT).ngd: $(ISE_DIR)/$(PROJECT).ngc $(UCF_FILE) $(CGN_FILES) $(ISE_DIR)/$(PROJECT).filter makefile
	@cd $(ISE_DIR); \
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

$(ISE_DIR)/$(PROJECT)_map.ncd $(ISE_DIR)/$(PROJECT).pcf: $(ISE_DIR)/$(PROJECT).ngd $(ISE_DIR)/$(PROJECT).filter makefile
	@cd $(ISE_DIR); \
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

$(ISE_DIR)/$(PROJECT).ncd: $(ISE_DIR)/$(PROJECT)_map.ncd $(ISE_DIR)/$(PROJECT).pcf $(ISE_DIR)/$(PROJECT).filter makefile
	@cd $(ISE_DIR); \
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

$(ISE_DIR)/$(PROJECT).bit: $(ISE_DIR)/$(PROJECT).ncd makefile
	@cd $(ISE_DIR); \
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

$(ISE_DIR)/$(PROJECT).mcs: $(ISE_DIR)/$(PROJECT).bit makefile
	@cd $(ISE_DIR); \
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

$(ISE_DIR)/$(PROJECT).bin : $(ISE_DIR)/$(PROJECT).mcs makefile
	@cd $(ISE_DIR); \
	echo "################################################################################" | tee -a $(PROJECT).log; \
	echo Running OBJCOPY | tee -a $(PROJECT).log; \
	echo $(OBJCOPY) $(OBJCOPY_OPTS) $(ISE_DIR)/$(PROJECT).mcs $(ISE_DIR)/$(PROJECT).bin | tee -a $(PROJECT).log; \
	echo "################################################################################" | tee -a $(PROJECT).log; \
	$(OBJCOPY) $(OBJCOPY_OPTS) $(ISE_DIR)/$(PROJECT).mcs $(ISE_DIR)/$(PROJECT).bin

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
	'attachflash -position 1 -spi S25FL032P' \
	'assignfiletoattachedflash -position 1 -file $(PROJECT).mcs' \
	'program -p 1 -dataWidth 1 -spionly -e -v -loadfpga' \
	'quit'

load: $(ISE_DIR)/$(PROJECT).mcs $(ISE_DIR)/$(PROJECT)_impact.cmd
	cd $(ISE_DIR); \
	$(IMPACT) -batch $(PROJECT)_impact.cmd

reload: $(ISE_DIR)/$(PROJECT)_impact.cmd
	cd $(ISE_DIR); \
	$(IMPACT) -batch $(PROJECT)_impact.cmd

#
# TRCE
#

trce :
	$(TRCE) -v -tsi asdf.tsi $(ISE_DIR)/$(PROJECT).ncd

#
# iverilog
#

iverilog : $(SIM_FILES) $(RTL_FILES) $(INC_FILES) $(DAT_FILES) $(SIM_DISK) $(TESTBENCH)/ssram.dat $(DISKS) makefile
	$(IVERILOG) -W all -s testbench -o $(IVERILOG_DIR)/sim.vvp $(SIM_FILES) $(RTL_FILES) \
	$(SIM_ARGS) \
	$(SYN_ARGS) \
	-D SSRAM_DAT=\"$(TESTBENCH)/ssram.dat\" \
	-D CROM_DAT=\"$(CROM_DAT)\" \
	-D DROM_DAT=\"$(DROM_DAT)\" \
	-D UNIT0_DSK=\"$(UNIT0_DSK)\" \
	-D UNIT1_DSK=\"$(UNIT1_DSK)\" \
	-D UNIT2_DSK=\"$(UNIT2_DSK)\" \
	-D UNIT3_DSK=\"$(UNIT3_DSK)\" \
	-D UNIT4_DSK=\"$(UNIT4_DSK)\" \
	-D UNIT5_DSK=\"$(UNIT5_DSK)\" \
	-D UNIT6_DSK=\"$(UNIT6_DSK)\" \
	-D UNIT7_DSK=\"$(UNIT7_DSK)\" \
	-I ks10 \
	-I ks10/utils \
	-I ks10/cpu \
	-I ks10/cpu/useq \
	-I ks10/debug \
	-I ks10/dz11 \
	-I ks10/dz11/uart \
	-I ks10/lp20 \
	-I ks10/lp26 \
	-I ks10/mem \
	-I ks10/rh11 \
	-I ks10/rh11/rpxx \
	-I ks10/rh11/sd \
	-I ks10/uba \
	-I ks10/utils/uart
	$(VVP) -n $(IVERILOG_DIR)/sim.vvp | tee $(IVERILOG_DIR)/sim.log

#
# Disks
#

$(UNIT0_DSK) : $(TESTBENCH)/dskb.rp06.gz
	zcat $< > $@

$(UNIT1_DSK) : $(TESTBENCH)/dskc.rp06.gz
	zcat $< > $@

$(UNIT2_DSK) : $(TESTBENCH)/red405a2.rp06.gz
	zcat $< > $@

$(UNIT3_DSK) : $(TESTBENCH)/dskb.rp06.gz
	zcat $< > $@

$(UNIT4_DSK) : $(TESTBENCH)/dskb.rp06.gz
	zcat $< > $@

$(UNIT5_DSK) : $(TESTBENCH)/dskb.rp06.gz
	zcat $< > $@

$(UNIT6_DSK) : $(TESTBENCH)/dskb.rp06.gz
	zcat $< > $@

$(UNIT7_DSK) : $(TESTBENCH)/dskb.rp06.gz
	zcat $< > $@

#
# Clean everything
#

clean: clean_rtl clean_ise clean_questa clean_iverilog
	rm -f cty_out.txt \
	      rhstatus.txt \
	      lpstatus.txt

#
# Clean RTL
#

clean_rtl:
	rm -f ks10/cpu/useq/crom.dat
	rm -f ks10/cpu/useq/drom.dat
	rm -f $(TESTBENCH)/*.dat
	rm -f $(TESTBENCH)/unit?.dsk
	find . -type f -name "*~" | xargs rm -fv

#
# Clean ISE
#

clean_ise:
	rm -rf $(ISE_DIR)/xst \
	       $(ISE_DIR)/_ngo \
	       $(ISE_DIR)/_xmsgs \
	       $(ISE_DIR)/isim \
	       $(ISE_DIR)/iseconfig \
	       $(ISE_DIR)/xlnx_auto_0_xdb
	rm -f  $(ISE_DIR)/$(PROJECT).bgn \
	       $(ISE_DIR)/$(PROJECT).bit \
	       $(ISE_DIR)/$(PROJECT).bld \
	       $(ISE_DIR)/$(PROJECT).cfi \
	       $(ISE_DIR)/$(PROJECT).cmd_log \
	       $(ISE_DIR)/$(PROJECT).drc \
	       $(ISE_DIR)/$(PROJECT).filter \
	       $(ISE_DIR)/$(PROJECT).log \
	       $(ISE_DIR)/$(PROJECT).lso \
	       $(ISE_DIR)/$(PROJECT).mcs \
	       $(ISE_DIR)/$(PROJECT).ncd \
	       $(ISE_DIR)/$(PROJECT).ngc \
	       $(ISE_DIR)/$(PROJECT).ngc_xst.xrpt \
	       $(ISE_DIR)/$(PROJECT).ngd \
	       $(ISE_DIR)/$(PROJECT).ngr \
	       $(ISE_DIR)/$(PROJECT).pad \
	       $(ISE_DIR)/$(PROJECT).par \
	       $(ISE_DIR)/$(PROJECT).pcf\
	       $(ISE_DIR)/$(PROJECT).prj\
	       $(ISE_DIR)/$(PROJECT).prm\
	       $(ISE_DIR)/$(PROJECT).ptwx \
	       $(ISE_DIR)/$(PROJECT).srp \
	       $(ISE_DIR)/$(PROJECT).syr \
	       $(ISE_DIR)/$(PROJECT).stx \
	       $(ISE_DIR)/$(PROJECT).twr \
	       $(ISE_DIR)/$(PROJECT).twx \
	       $(ISE_DIR)/$(PROJECT).unroutes \
	       $(ISE_DIR)/$(PROJECT).ut \
	       $(ISE_DIR)/$(PROJECT).wdb \
	       $(ISE_DIR)/$(PROJECT).xpi \
	       $(ISE_DIR)/$(PROJECT).xst \
	       $(ISE_DIR)/$(PROJECT)_bitgen.xwbt \
	       $(ISE_DIR)/$(PROJECT)_envsettings.html \
	       $(ISE_DIR)/$(PROJECT)_guide.ncd \
	       $(ISE_DIR)/$(PROJECT)_impact.cmd \
	       $(ISE_DIR)/$(PROJECT)_isim.cmd \
	       $(ISE_DIR)/$(PROJECT)_isim.exe \
	       $(ISE_DIR)/$(PROJECT)_isim.prj \
	       $(ISE_DIR)/$(PROJECT)_map.map \
	       $(ISE_DIR)/$(PROJECT)_map.mrp \
	       $(ISE_DIR)/$(PROJECT)_map.ncd \
	       $(ISE_DIR)/$(PROJECT)_map.ngm \
	       $(ISE_DIR)/$(PROJECT)_map.xrpt \
	       $(ISE_DIR)/$(PROJECT)_ngdbuild.xrpt \
	       $(ISE_DIR)/$(PROJECT)_pad.csv \
	       $(ISE_DIR)/$(PROJECT)_pad.txt \
	       $(ISE_DIR)/$(PROJECT)_par.xrpt \
	       $(ISE_DIR)/$(PROJECT)_summary.html \
	       $(ISE_DIR)/$(PROJECT)_summary.xml \
	       $(ISE_DIR)/$(PROJECT)_usage.xml \
	       $(ISE_DIR)/$(PROJECT)_xst.xrpt \
	       $(ISE_DIR)/fuse.log \
	       $(ISE_DIR)/fuse.xmsgs \
	       $(ISE_DIR)/fuseRelaunch.cmd \
	       $(ISE_DIR)/_impactbatch.log \
	       $(ISE_DIR)/isim.cmd \
	       $(ISE_DIR)/isim.log \
	       $(ISE_DIR)/par_usage_statistics.html \
	       $(ISE_DIR)/usage_statistics_webtalk.html \
	       $(ISE_DIR)/webtalk.log \
	       $(ISE_DIR)/webtalk_pn.xml \
	       $(ISE_DIR)/xilinx_device_details.xml \
	       $(ISE_DIR)/xilinxsim.ini

#
# Cleanup after modelsim
#

clean_questa:
	rm -rf $(QUESTA_DIR)/work
	rm -f  $(QUESTA_DIR)/esm_ks10.cr.mti \
	       $(QUESTA_DIR)/esm_ks10.mpf \
	       $(QUESTA_DIR)/wave.do \
	       transcript \
	       vsim.wlf

#
# Cleanup after iverilog
#

clean_iverilog:
	rm -f $(IVERILOG_DIR)/sim.vvp \
	      $(IVERILOG_DIR)/sim.log

#
# rcsclean everything
#

rcsclean: rcsclean_rtl rcsclean_ise

#
# rcsclean ISE
#

rcsclean_ise: clean_ise
	rcsclean $(ISE_DIR)/*

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
	-rcsclean ks10/lp20/*
	-rcsclean ks10/lp26/*
	-rcsclean ks10/mem/*
	-rcsclean ks10/rh11/*
	-rcsclean ks10/rh11/sd/*
	-rcsclean ks10/rh11/rpxx/*
	-rcsclean ks10/uba/*
	-rcsclean ks10/utils/*
	-rcsclean ks10/utils/UART/*
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

