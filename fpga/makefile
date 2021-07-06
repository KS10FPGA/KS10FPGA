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


PROJECT  := de10_ks10
RTLTOP   := de10_ks10
SIMTOP   := testbench

#
# FPGA partnumber
#

FAMILY   := "Cyclone V"
DEVICE   := 5CSEBA6U23I7

#
# What system?
#

#UNAME    := $(shell uname -s)

#
# Project structure
#

MAINDEC      := ../maindec
TESTBENCH    := testbench
QUESTA_DIR   := de10_top/questa
IVERILOG_DIR := de10_top/iverilog
MODELSIM_DIR := de10_top/modelsim
QUARTUS_DIR  := de10_top/quartus

#
# Altera
#

ALTERA       := /cygdrive/c/intelFPGA_lite/18.1/modelsim_ase/win32aloem/
VLIB         := $(ALTERA)/vlib
VMAP         := $(ALTERA)/vmap
VLOG         := $(ALTERA)/vlog
VOPT         := $(ALTERA)/vopt
VSIM         := $(ALTERA)/vsim

#
# Other tools
#

IVERILOG     := iverilog
VVP          := vvp
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
#   ENABLE_TIMER     Enable 1 ms timer.  Slows simulation.  (See testbench)
#   SIM_SMMON        Boot to SMMON instead of diagnostic app (See testbench)
#   SIM_CTY          Simulate the CTY (See testbench)
#   SIM_LPR          Simulate LPR
#   SIM_SDHC         Simulate the SDHC Card
#   SIM_SDHC_OFFLINE Simulate the SDHC as offline
#   STOP_ON_COMPLETE Stop simulation when test is complete (See debug.v)
#   STOP_ON_STUCK_PC Stop simulating when PC gets stuck.
#   DEBUG_DSKAA      Diagnostic information (See debug.v)
#   DEBUG=DSKAA      Diagnostic information (See debug.v)

#        SIM_SMMON \

SIM_ARGS := \
	SIM_CTY \
	SIM_LPR \
	SIM_SDHC \
	ENABLE_TIMER \
	STOP_ON_STUCK_PC \
	DEBUG_$(DIAGBASE) \
	DEBUG=$(DIAGBASE) \
	DIAG=$(DIAG)

#
# Synthesis Macro Definitions
#
# Macro Definitions
#   MAJOR_VER=\"XX\"   *  Set firmware version major revision (XX must be two ASCII digits)
#   MINOR_VER=\"YY\"   *  Set firmware version minor revision (YY must be two ASCII digits)
#   CLKFRQ=12500000    *  See clock freqency of CPU Clock (must match clock input)
#   SSRAMx18           ** Use 18-bit wide external SSRAM
#   SSRAMx36           ** Use 36-bit wide external SSRAM
#   SSRAM_BLKRAM       ** Use 36-bit wide internal Block RAM.
#   RPXX_SIMSEEK          Simulate RPXX seek accurately but slowly
#   RPXX_SIMSEARCH        Simulate RPXX search accurately bus slowly
#   RPXX_SIMDMD           Simulate RPXX diagnostic mode
#   UBA4                  Include UBA4
#   RH11                  Include a RH11 Disk Controller Interface
#   DZ11                  Include a DZ11 Terminal Multiplexer Interface
#   KMC11                 Include a KMC11 Microprocessor
#   LP20                  Include a LP20/LP26 Printer Interface
#   DUP11                 Include a DUP11 Synchronous Interface
#   DUP11_FASTCLK         Run the synchronous serial clock at 100 KHz instead of 10 KHz
#   PAGE_FAIL_TEST        Stress test PAGE FAIL logic
#
# * MUST BE SET
# ** SELECT one SSRAM option
#

SYN_ARGS := \
	MAJOR_VER=\"00\" \
	MINOR_VER=\"30\" \
        CLKFRQ=12500000 \
	SSRAMx18 \
	RPXX_SIMSEEK \
	RPXX_SIMDMD \
	UBA4 \
	RH11 \
	DZ11 \
	DUP11 \
	KMC11 \
	LP20

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
	ks10/ks10.sv \
	ks10/arb/arb.sv \
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
	ks10/cpu/pager.sv \
	ks10/cpu/pcflags.v \
	ks10/cpu/pi.v \
	ks10/cpu/pxct.v \
	ks10/cpu/ramfile.v \
	ks10/cpu/regir.v \
	ks10/cpu/scad.v \
	ks10/cpu/timer.v \
	ks10/cpu/timing.v \
	ks10/cpu/vma.v \
	ks10/cpu/cpu.sv \
	ks10/cpu/useq/crom.v \
	ks10/cpu/useq/drom.v \
	ks10/cpu/useq/skip.v \
	ks10/cpu/useq/stack.v \
	ks10/cpu/useq/dispatch.v \
	ks10/cpu/useq/useq.v \
	ks10/debug/debug.v \
	ks10/dup11/dup11.v \
	ks10/dup11/dupclk.v \
	ks10/dup11/dupintr.v \
	ks10/dup11/dupparcsr.v \
	ks10/dup11/duprx.v \
	ks10/dup11/duprxcsr.v \
	ks10/dup11/duptx.v \
	ks10/dup11/duptxcsr.v \
	ks10/dup11/duptxdbuf.v \
	ks10/dz11/dzcsr.sv \
	ks10/dz11/dzmsr.sv \
	ks10/dz11/dztcr.sv \
	ks10/dz11/dztdr.sv \
	ks10/dz11/dzintr.sv \
	ks10/dz11/dzrbuf.sv \
	ks10/dz11/dzuart.sv \
	ks10/dz11/dz11.sv \
	ks10/kmc11/kmcalu.sv \
	ks10/kmc11/kmcbrg.sv \
	ks10/kmc11/kmcclk.sv \
	ks10/kmc11/kmcdmux.sv \
	ks10/kmc11/kmcintr.sv \
	ks10/kmc11/kmcmaint.sv \
	ks10/kmc11/kmcmem.sv \
	ks10/kmc11/kmcmisc.sv \
	ks10/kmc11/kmcmpram.sv \
	ks10/kmc11/kmcnprc.sv \
	ks10/kmc11/kmcseq.sv \
	ks10/kmc11/kmcsp.sv \
	ks10/kmc11/kmc11.sv \
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
	ks10/uba/uba.sv \
	ks10/uba/ubamr.sv \
	ks10/uba/ubasr.sv \
	ks10/uba/ubanxd.sv \
	ks10/uba/ubapage.sv \
	ks10/uba/ubatmo.sv \
	ks10/uba/ubaintr.sv \
	ks10/utils/crc16.v \
	ks10/utils/fifo.v \
	ks10/utils/sync.v \
	ks10/utils/edgetrig.v \
	ks10/utils/usrt/usrt_rx.v \
	ks10/utils/usrt/usrt_tx.v \
	ks10/utils/uart/uart_brg.v \
	ks10/utils/uart/uart_rx.v \
	ks10/utils/uart/uart_tx.v \

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
	$(TESTBENCH)/testbench.v \
	$(TESTBENCH)/dumpregs.v \
	$(TESTBENCH)/sdsim.v

ifneq (, $(findstring SSRAMx18, $(SYN_ARGS)))
SIM_FILES += \
	$(TESTBENCH)/cy7c1463kv33.v
endif

ifneq (, $(findstring SSRAMx36, $(SYN_ARGS)))
SIM_FILES += \
	$(TESTBENCH)/cy7c1460av33.v
endif

#
# If loading a diagnostic, add it.  Otherwise don't
# If were simulating SMMON, add the SMMON files.  Otherwise don't.
#

SEQ_FILES :=

ifdef DIAG

SEQ_FILES += \
	$(MAINDEC)/MAINDEC-10-DSQDA-RD00.SEQ \
	$(MAINDEC)/MAINDEC-10-DSQDB-RD00.SEQ \
	$(MAINDEC)/MAINDEC-10-DSQDC-RD00.SEQ \
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
	ks10/dup11/dup11.vh \
	ks10/dup11/duprxcsr.vh \
	ks10/dup11/duprxdbuf.vh \
	ks10/dup11/dupparcsr.vh \
	ks10/dup11/duptxcsr.vh \
	ks10/dup11/duptxdbuf.vh \
	ks10/dz11/dz11.vh \
	ks10/dz11/dzcsr.vh \
	ks10/dz11/dzlpr.vh \
	ks10/dz11/dzrbuf.vh \
	ks10/dz11/dztcr.vh \
	ks10/dz11/dztdr.vh \
	ks10/kmc11/kmc11.vh \
	ks10/kmc11/kmccram.vh \
	ks10/kmc11/kmcmaint.vh \
	ks10/kmc11/kmcmisc.vh \
	ks10/kmc11/kmcnprc.vh \
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
	ks10/utils/crc16.vh \
	ks10/utils/uart/uart.vh

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
# Build the binary firmware image
#

build: quartus

#
# Create the "Control ROM" microcode for microsequencer
#  Change my serial number from 4097 (default) to 2020.

$(CROM_DAT): ks10/cpu/useq/ks10.mcr ks10/cpu/useq/crom.awk
	awk -f ks10/cpu/useq/crom.awk ks10/cpu/useq/ks10.mcr > $(CROM_DAT)

#
# Create the "Dispatch ROM" microcode for microsequencer
#

$(DROM_DAT): ks10/cpu/useq/ks10.mcr ks10/cpu/useq/drom.awk
	awk -f ks10/cpu/useq/drom.awk ks10/cpu/useq/ks10.mcr > $(DROM_DAT)

#
# Initialize the SSRAM with MAINDEC (simulation only)
# Ensure that there is something to execute.  If not, error out.
#

ifeq ($(SEQ_FILES), )

$(TESTBENCH)/ssram.dat : $(SEQ_FILES) $(TESTBENCH)/ssram36.awk $(TESTBENCH)/ssram18.awk makefile
	$(error "Need to define DIAG (from command line - DIAG=DSKAA) or define SIM_SMMON or both")

else

ifneq (, $(findstring SSRAMx18, $(SYN_ARGS)))

$(TESTBENCH)/ssram.dat : $(SEQ_FILES) $(TESTBENCH)/ssram18.awk makefile
	cat $(SEQ_FILES) | \
	awk -f $(TESTBENCH)/ssram18.awk -vfilename="$(SEQ_FILES)" > $(TESTBENCH)/ssram.dat
else

$(TESTBENCH)/ssram.dat : $(SEQ_FILES) $(TESTBENCH)/ssram36.awk makefile
	cat $(SEQ_FILES) | \
	awk -f $(TESTBENCH)/ssram36.awk -vfilename="$(SEQ_FILES)" > $(TESTBENCH)/ssram.dat
endif

endif

#
# Questasim
#

WAVE_BUSES := \
	"add wave -noupdate -divider {BUSSES}" \
	"add wave -noupdate -radix binary   -radixshowbase 0 -label {clkT}                 {/testbench/uKS10/uCPU/clkT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {DP}                   {/testbench/uKS10/uCPU/dp}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {DBUS}                 {/testbench/uKS10/uCPU/dbus}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {DBM}                  {/testbench/uKS10/uCPU/dbm}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {RAMFILE}              {/testbench/uKS10/uCPU/ramfile}" \

WAVE_CPU := \
	"add wave -noupdate -divider {CPU}" \
	"add wave -noupdate -radix binary   -radixshowbase 0 -label {cpuCLK}               {/testbench/uKS10/uCPU/clkT[1]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {stack}                {/testbench/uKS10/uCPU/uUSEQ/uSTACK/stack}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {stack wp}             {/testbench/uKS10/uCPU/uUSEQ/uSTACK/sp}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {stack sp}             {/testbench/uKS10/uCPU/uUSEQ/uSTACK/wp}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {stack addrOUT}        {/testbench/uKS10/uCPU/uUSEQ/uSTACK/addrOUT}" \
	"add wave -noupdate -radix binary   -radixshowbase 0 -label {clkT}                 {/testbench/uKS10/uCPU/clkT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {CROM J}               {/testbench/uKS10/uCPU/uUSEQ/uCROM/addr}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {CROM ADDR}            {/testbench/uKS10/uCPU/uUSEQ/addr}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {CROM CURR ADDR}       {/testbench/uKS10/uCPU/uUSEQ/uSTACK/currADDR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pageFAIL}             {/testbench/uKS10/uCPU/pageFAIL}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {PC}                   {/testbench/uKS10/uDEBUG/PC}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {IR}                   {/testbench/uKS10/uDEBUG/IR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { 0: MAG}              {/testbench/uKS10/uCPU/uALU/aluRAM[0][2:37]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { 1: PC}               {/testbench/uKS10/uCPU/uALU/aluRAM[1][2:37]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { 2: HR}               {/testbench/uKS10/uCPU/uALU/aluRAM[2][2:37]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { 3: AR}               {/testbench/uKS10/uCPU/uALU/aluRAM[3][2:37]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { 4: ARX}              {/testbench/uKS10/uCPU/uALU/aluRAM[4][2:37]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { 5: BR}               {/testbench/uKS10/uCPU/uALU/aluRAM[5][2:37]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { 6: BRX}              {/testbench/uKS10/uCPU/uALU/aluRAM[6][2:37]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { 7: ONE}              {/testbench/uKS10/uCPU/uALU/aluRAM[7][2:37]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { 8: EBR}              {/testbench/uKS10/uCPU/uALU/aluRAM[8][2:37]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { 9: UBR}              {/testbench/uKS10/uCPU/uALU/aluRAM[9][2:37]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {10: MASK}             {/testbench/uKS10/uCPU/uALU/aluRAM[10][2:37]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {11: FLG}              {/testbench/uKS10/uCPU/uALU/aluRAM[11][2:37]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {12: PI}               {/testbench/uKS10/uCPU/uALU/aluRAM[12][2:37]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {13: XWD1}             {/testbench/uKS10/uCPU/uALU/aluRAM[13][2:37]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {14: T0}               {/testbench/uKS10/uCPU/uALU/aluRAM[14][2:37]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {15: T1}               {/testbench/uKS10/uCPU/uALU/aluRAM[15][2:37]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {AC0}                  {/testbench/uKS10/uCPU/uRAMFILE/ram[0]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {AC1}                  {/testbench/uKS10/uCPU/uRAMFILE/ram[1]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {AC2}                  {/testbench/uKS10/uCPU/uRAMFILE/ram[2]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {AC3}                  {/testbench/uKS10/uCPU/uRAMFILE/ram[3]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {AC4}                  {/testbench/uKS10/uCPU/uRAMFILE/ram[4]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {AC5}                  {/testbench/uKS10/uCPU/uRAMFILE/ram[5]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {AC6}                  {/testbench/uKS10/uCPU/uRAMFILE/ram[6]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {AC7}                  {/testbench/uKS10/uCPU/uRAMFILE/ram[7]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {AC8}                  {/testbench/uKS10/uCPU/uRAMFILE/ram[8]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {AC9}                  {/testbench/uKS10/uCPU/uRAMFILE/ram[9]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {AC10}                 {/testbench/uKS10/uCPU/uRAMFILE/ram[10]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {AC11}                 {/testbench/uKS10/uCPU/uRAMFILE/ram[11]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {AC12}                 {/testbench/uKS10/uCPU/uRAMFILE/ram[12]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {AC13}                 {/testbench/uKS10/uCPU/uRAMFILE/ram[13]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {AC14}                 {/testbench/uKS10/uCPU/uRAMFILE/ram[14]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {AC15}                 {/testbench/uKS10/uCPU/uRAMFILE/ram[15]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {vmaREG}               {/testbench/uKS10/uCPU/vmaREG}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {regIR}                {/testbench/uKS10/uCPU/regIR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pageFAIL}             {/testbench/uKS10/uCPU/pageFAIL}"

WAVE_CPU_INTF := \
	"add wave -noupdate -divider {CPU Interface}" \
	"add wave -noupdate -radix binary   -radixshowbase 0 -label {clkT}                 {/testbench/uKS10/uCPU/clkT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {clken}                {/testbench/uKS10/uCPU/uINTF/clken}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cpuREQO}              {/testbench/uKS10/uCPU/cpuREQO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cpuACKI}              {/testbench/uKS10/uCPU/cpuACKI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cpuADDRO[0:35]}       {/testbench/uKS10/uCPU/cpuADDRO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { 3: READ}             {/testbench/uKS10/uCPU/cpuADDRO[3]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { 4: WRTEST}           {/testbench/uKS10/uCPU/cpuADDRO[4]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label { 5: WRITE}            {/testbench/uKS10/uCPU/cpuADDRO[5]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {10: IO}               {/testbench/uKS10/uCPU/cpuADDRO[10]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {11: WRU}              {/testbench/uKS10/uCPU/cpuADDRO[11]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {12: VECT}             {/testbench/uKS10/uCPU/cpuADDRO[12]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cpuADDRO[14:35]}      {/testbench/uKS10/uCPU/cpuADDRO[14:35]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cpuDATAI}             {/testbench/uKS10/uCPU/cpuDATAI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cpuDATAO}             {/testbench/uKS10/uCPU/cpuDATAO}" \

WAVE_CPU_NXD := \
	"add wave -noupdate -divider {CPU NXD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {clk}                  {/testbench/uKS10/uCPU/uNXD/clk}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cpuREQO}              {/testbench/uKS10/uCPU/uNXD/cpuREQO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cpuACKI}              {/testbench/uKS10/uCPU/uNXD/cpuACKI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busIO}                {/testbench/uKS10/uCPU/uNXD/busIO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busWRU}               {/testbench/uKS10/uCPU/uNXD/busWRU}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busVECT}              {/testbench/uKS10/uCPU/uNXD/busVECT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ioCLEAR}              {/testbench/uKS10/uCPU/uNXD/ioCLEAR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {addr3666}             {/testbench/uKS10/uCPU/uNXD/addr3666}" \
	"add wave -noupdate -divider {CPU NXD State Machine}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {wru}                  {/testbench/uKS10/uCPU/uNXD/wru}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {vect}                 {/testbench/uKS10/uCPU/uNXD/vect}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busy}                 {/testbench/uKS10/uCPU/uNXD/busy}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {state}                {/testbench/uKS10/uCPU/uNXD/state}" \
	"add wave -noupdate -divider {CPU NXD Outputs}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ioWAIT}               {/testbench/uKS10/uCPU/uNXD/ioWAIT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ioBUSY}               {/testbench/uKS10/uCPU/uNXD/ioBUSY}" \

WAVE_CSL := \
	"add wave -noupdate -divider {CSL}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {rst}                  {/testbench/uKS10/uCSL/rst}" \
	"add wave -noupdate -radix binary   -radixshowbase 0 -label {clk}                  {/testbench/uKS10/uCSL/clk}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {axiAWADDR}            {/testbench/uKS10/uCSL/axiAWADDR}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {axiAWVALID}           {/testbench/uKS10/uCSL/axiAWVALID}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {axiAWREADY}           {/testbench/uKS10/uCSL/axiAWREADY}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {axiWDATA}             {/testbench/uKS10/uCSL/axiWDATA}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {axiWSTRB}             {/testbench/uKS10/uCSL/axiWSTRB}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {axiWVALID}            {/testbench/uKS10/uCSL/axiWVALID}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {axiWREADY}            {/testbench/uKS10/uCSL/axiWREADY}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {axiARADDR}            {/testbench/uKS10/uCSL/axiARADDR}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {axiARVALID}           {/testbench/uKS10/uCSL/axiARVALID}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {axiARREADY}           {/testbench/uKS10/uCSL/axiARREADY}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {axiRDATA}             {/testbench/uKS10/uCSL/axiRDATA}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {axiRRESP}             {/testbench/uKS10/uCSL/axiRRESP}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {axiRVALID}            {/testbench/uKS10/uCSL/axiRVALID}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {axiRREADY}            {/testbench/uKS10/uCSL/axiRREADY}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {axiBRESP}             {/testbench/uKS10/uCSL/axiBRESP}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {axiBVALID}            {/testbench/uKS10/uCSL/axiBVALID}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {axiBREADY}            {/testbench/uKS10/uCSL/axiBREADY}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {axiWVALID}            {/testbench/uKS10/uCSL/axiWVALID}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busREQI}              {/testbench/uKS10/uCSL/busREQI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busREQO}              {/testbench/uKS10/uCSL/busREQO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busACKI}              {/testbench/uKS10/uCSL/busACKI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busACKO}              {/testbench/uKS10/uCSL/busACKO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busADDRI}             {/testbench/uKS10/uCSL/busADDRI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busADDRO}             {/testbench/uKS10/uCSL/busADDRO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busDATAI}             {/testbench/uKS10/uCSL/busDATAI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busDATAO}             {/testbench/uKS10/uCSL/busDATAO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {regCONIR}             {/testbench/uKS10/uCSL/regCONIR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {regCONDR}             {/testbench/uKS10/uCSL/regCONDR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {regCONAR}             {/testbench/uKS10/uCSL/regCONAR}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {regDZCCR}             {/testbench/uKS10/uCSL/regDZCCR}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {regLPCCR}             {/testbench/uKS10/uCSL/regLPCCR}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {regRPCCR}             {/testbench/uKS10/uCSL/regRPCCR}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {regDUPCCR}            {/testbench/uKS10/uCSL/regDUPCCR}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {regCONCSR}            {/testbench/uKS10/uCSL/regCONCSR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {regCONAR}             {/testbench/uKS10/uCSL/regCONAR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {regCONDR}             {/testbench/uKS10/uCSL/regCONDR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {rdPULSE}              {/testbench/uKS10/uCSL/rdPULSE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {wrPULSE}              {/testbench/uKS10/uCSL/wrPULSE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cslGO}                {/testbench/uKS10/uCSL/cslGO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpSETONLN}            {/testbench/uKS10/uCSL/lpSETONLN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpSETOFFLN}           {/testbench/uKS10/uCSL/lpSETOFFLN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cslRUN}               {/testbench/uKS10/uCSL/cslRUN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cslHALT}              {/testbench/uKS10/uCSL/cslHALT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cslCONT}              {/testbench/uKS10/uCSL/cslCONT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cslEXEC}              {/testbench/uKS10/uCSL/cslEXEC}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cslINTR}              {/testbench/uKS10/uCSL/cslINTR}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {state}                {/testbench/uKS10/uCSL/state}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {timer}                {/testbench/uKS10/uCSL/timer}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busIO}                {/testbench/uKS10/uCSL/busIO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {regREV}               {/testbench/uKS10/uCSL/regREV}"

WAVE_DBM := \
	"add wave -noupdate -divider {DBM}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {clk}                  {/testbench/uKS10/uCPU/clk}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mux}                  {/testbench/uKS10/uCPU/uDBM/mux}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dbm}                  {/testbench/uKS10/uCPU/uDBM/dbm}"

WAVE_DZ11 := \
	"add wave -noupdate -divider {DZ11}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQO}              {/testbench/uKS10/uDZ11/devREQO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devACKI}              {/testbench/uKS10/uDZ11/devACKI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devACKO}              {/testbench/uKS10/uDZ11/devACKO}" \
	"add wave -noupdate -radix binary   -radixshowbase 0 -label {devINTR}              {/testbench/uKS10/uDZ11/devINTR}" \
	"add wave -noupdate -radix binary   -radixshowbase 0 -label {devINTA}              {/testbench/uKS10/uDZ11/devINTA}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAI}             {/testbench/uKS10/uDZ11/devDATAI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAO}             {/testbench/uKS10/uDZ11/devDATAO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devADDRI}             {/testbench/uKS10/uDZ11/devADDRI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devADDRO}             {/testbench/uKS10/uDZ11/devADDRO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREAD}              {/testbench/uKS10/uDZ11/devREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devWRITE}             {/testbench/uKS10/uDZ11/devWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devIO}                {/testbench/uKS10/uDZ11/devIO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devWRU}               {/testbench/uKS10/uDZ11/devWRU}" \
	"add wave -noupdate -divider {DZ11 REGS}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {clk}                  {/testbench/uKS10/uDZ11/clk}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label regCSR                 {/testbench/uKS10/uDZ11/regCSR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label regMSR                 {/testbench/uKS10/uDZ11/regMSR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label regRBUF                {/testbench/uKS10/uDZ11/regRBUF}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label regTCR                 {/testbench/uKS10/uDZ11/regTCR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label regTDR                 {/testbench/uKS10/uDZ11/regTDR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label csrTRDY                {/testbench/uKS10/uDZ11/regCSR[15]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label csrTIE                 {/testbench/uKS10/uDZ11/regCSR[14]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label csrSA                  {/testbench/uKS10/uDZ11/regCSR[13]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label csrSAE                 {/testbench/uKS10/uDZ11/regCSR[12]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label csrRDONE               {/testbench/uKS10/uDZ11/regCSR[7]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label csrRIE                 {/testbench/uKS10/uDZ11/regCSR[6]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[0]/lprREG}       {/testbench/uKS10/uDZ11/UART[0]/UART/lprREG}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[1]/lprREG}       {/testbench/uKS10/uDZ11/UART[1]/UART/lprREG}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[2]/lprREG}       {/testbench/uKS10/uDZ11/UART[2]/UART/lprREG}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[3]/lprREG}       {/testbench/uKS10/uDZ11/UART[3]/UART/lprREG}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[4]/lprREG}       {/testbench/uKS10/uDZ11/UART[4]/UART/lprREG}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[5]/lprREG}       {/testbench/uKS10/uDZ11/UART[5]/UART/lprREG}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[6]/lprREG}       {/testbench/uKS10/uDZ11/UART[6]/UART/lprREG}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[7]/lprREG}       {/testbench/uKS10/uDZ11/UART[7]/UART/lprREG}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[0]/txREG}        {/testbench/uKS10/uDZ11/UART[0]/UART/ttyTX/txREG}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[1]/txREG}        {/testbench/uKS10/uDZ11/UART[1]/UART/ttyTX/txREG}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[2]/txREG}        {/testbench/uKS10/uDZ11/UART[2]/UART/ttyTX/txREG}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[3]/txREG}        {/testbench/uKS10/uDZ11/UART[3]/UART/ttyTX/txREG}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[4]/txREG}        {/testbench/uKS10/uDZ11/UART[4]/UART/ttyTX/txREG}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[5]/txREG}        {/testbench/uKS10/uDZ11/UART[5]/UART/ttyTX/txREG}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[6]/txREG}        {/testbench/uKS10/uDZ11/UART[6]/UART/ttyTX/txREG}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[7]/txREG}        {/testbench/uKS10/uDZ11/UART[7]/UART/ttyTX/txREG}" \
	"add wave -noupdate -divider UART" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[0]/clken}        {/testbench/uKS10/uDZ11/UART[0]/UART/clken}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[1]/clken}        {/testbench/uKS10/uDZ11/UART[1]/UART/clken}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[2]/clken}        {/testbench/uKS10/uDZ11/UART[2]/UART/clken}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[3]/clken}        {/testbench/uKS10/uDZ11/UART[3]/UART/clken}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[4]/clken}        {/testbench/uKS10/uDZ11/UART[4]/UART/clken}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[5]/clken}        {/testbench/uKS10/uDZ11/UART[5]/UART/clken}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[6]/clken}        {/testbench/uKS10/uDZ11/UART[6]/UART/clken}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[7]/clken}        {/testbench/uKS10/uDZ11/UART[7]/UART/clken}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[0]/rxd}          {/testbench/uKS10/uDZ11/UART[0]/UART/rxd}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[1]/rxd}          {/testbench/uKS10/uDZ11/UART[1]/UART/rxd}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[2]/rxd}          {/testbench/uKS10/uDZ11/UART[2]/UART/rxd}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[3]/rxd}          {/testbench/uKS10/uDZ11/UART[3]/UART/rxd}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[4]/rxd}          {/testbench/uKS10/uDZ11/UART[4]/UART/rxd}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[5]/rxd}          {/testbench/uKS10/uDZ11/UART[5]/UART/rxd}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[6]/rxd}          {/testbench/uKS10/uDZ11/UART[6]/UART/rxd}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[7]/rxd}          {/testbench/uKS10/uDZ11/UART[7]/UART/rxd}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[0]/txd}          {/testbench/uKS10/uDZ11/UART[0]/UART/txd}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[1]/txd}          {/testbench/uKS10/uDZ11/UART[1]/UART/txd}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[2]/txd}          {/testbench/uKS10/uDZ11/UART[2]/UART/txd}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[3]/txd}          {/testbench/uKS10/uDZ11/UART[3]/UART/txd}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[4]/txd}          {/testbench/uKS10/uDZ11/UART[4]/UART/txd}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[5]/txd}          {/testbench/uKS10/uDZ11/UART[5]/UART/txd}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[6]/txd}          {/testbench/uKS10/uDZ11/UART[6]/UART/txd}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[7]/txd}          {/testbench/uKS10/uDZ11/UART[7]/UART/txd}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[0]/ttyTX/state}  {/testbench/uKS10/uDZ11/UART[0]/UART/ttyTX/state}" \
        "add wave -noupdate -radix octal    -radixshowbase 0 -label {UART[0]/ttyRX/state}  {/testbench/uKS10/uDZ11/UART[0]/UART/ttyRX/state}" \
	"add wave -noupdate -divider {DZ11 Receiver}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {RBUF/uartRXFRME}      {/testbench/uKS10/uDZ11/RBUF/uartRXFRME}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {RBUF/uartRXPARE}      {/testbench/uKS10/uDZ11/RBUF/uartRXPARE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {RBUF/uartRXFULL}      {/testbench/uKS10/uDZ11/RBUF/uartRXFULL}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {RBUF/uartRXCLR}       {/testbench/uKS10/uDZ11/RBUF/uartRXCLR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {RBUF/uartRXDATA}      {/testbench/uKS10/uDZ11/RBUF/uartRXDATA}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {RBUF/rxSCAN}          {/testbench/uKS10/uDZ11/RBUF/rxSCAN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {RBUF/rd}              {/testbench/uKS10/uDZ11/RBUF/rd}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {RBUF/wr}              {/testbench/uKS10/uDZ11/RBUF/wr}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {RBUF/writeDATA}       {/testbench/uKS10/uDZ11/RBUF/writeDATA}" \
	"add wave -noupdate -divider {DZ11 FIFO}" \
	"add wave -noupdate -radix decimal  -radixshowbase 0 -label {RBUF/FIFO_SIZE}       {/testbench/uKS10/uDZ11/RBUF/FIFO_SIZE}" \
	"add wave -noupdate -radix decimal  -radixshowbase 0 -label {RBUF/depth}           {/testbench/uKS10/uDZ11/RBUF/depth}" \
	"add wave -noupdate -radix decimal  -radixshowbase 0 -label {RBUF/rd_ptr}          {/testbench/uKS10/uDZ11/RBUF/rd_ptr}" \
	"add wave -noupdate -radix decimal  -radixshowbase 0 -label {RBUF/wr_ptr}          {/testbench/uKS10/uDZ11/RBUF/wr_ptr}" \
	"add wave -noupdate -divider {DZ11 Interrupts}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label clk                    {/testbench/uKS10/uDZ11/INTR/clk}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label iack                   {/testbench/uKS10/uDZ11/INTR/iack}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label vectREAD               {/testbench/uKS10/uDZ11/INTR/vectREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label rbufREAD               {/testbench/uKS10/uDZ11/INTR/rbufREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label tdrWRITE               {/testbench/uKS10/uDZ11/INTR/tdrWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label cdrRIE                 {/testbench/uKS10/uDZ11/INTR/csrRIE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label csrRRDY                {/testbench/uKS10/uDZ11/INTR/csrRRDY}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label csrTIE                 {/testbench/uKS10/uDZ11/INTR/csrTIE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label csrTRDY                {/testbench/uKS10/uDZ11/INTR/csrTRDY}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label rxstate                {/testbench/uKS10/uDZ11/INTR/rxstate}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label txstate                {/testbench/uKS10/uDZ11/INTR/txstate}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label arbstate               {/testbench/uKS10/uDZ11/INTR/arbstate}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label rxclr                  {/testbench/uKS10/uDZ11/INTR/rxclr}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label txclr                  {/testbench/uKS10/uDZ11/INTR/txclr}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label rxINTR                 {/testbench/uKS10/uDZ11/INTR/rxINTR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label txINTR                 {/testbench/uKS10/uDZ11/INTR/txINTR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label rxVECTOR               {/testbench/uKS10/uDZ11/INTR/rxVECTOR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label rxVECTER               {/testbench/uKS10/uDZ11/INTR/rxVECTER}" \
	"add wave -noupdate -divider {DZ11 REG READ/WRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAI}             {/testbench/uKS10/uDZ11/devDATAI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAO}             {/testbench/uKS10/uDZ11/devDATAO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label csrREAD                {/testbench/uKS10/uDZ11/csrREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label csrWRITE               {/testbench/uKS10/uDZ11/csrWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label rbufREAD               {/testbench/uKS10/uDZ11/rbufREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label lprWRITE               {/testbench/uKS10/uDZ11/lprWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label tcrREAD                {/testbench/uKS10/uDZ11/tcrREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label tcrWRITE               {/testbench/uKS10/uDZ11/tcrWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label msrREAD                {/testbench/uKS10/uDZ11/msrREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label tdrWRITE               {/testbench/uKS10/uDZ11/tdrWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label vectREAD               {/testbench/uKS10/uDZ11/vectREAD}"

WAVE_INTF := \
	"add wave -noupdate -divider {INTF}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cpuRUN}               {/testbench/uKS10/uCPU/uINTF/cpuRUN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cpuCONT}              {/testbench/uKS10/uCPU/uINTF/cpuCONT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cpuEXEC}              {/testbench/uKS10/uCPU/uINTF/cpuEXEC}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cpuHALT}              {/testbench/uKS10/uCPU/uINTF/cpuHALT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cslSET}               {/testbench/uKS10/uCPU/uINTF/cslSET}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cslRUN}               {/testbench/uKS10/uCPU/uINTF/cslRUN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cslEXEC}              {/testbench/uKS10/uCPU/uINTF/cslEXEC}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cslCONT}              {/testbench/uKS10/uCPU/uINTF/cslCONT}" \

WAVE_MEM := \
	"add wave -noupdate -color \"lightblue\" -divider {Memory Interface}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {memCLK}               {/testbench/uKS10/uMEM/memCLK}" \
	"add wave -noupdate -radix binary   -radixshowbase 0 -label {clkT}                 {/testbench/uKS10/uMEM/clkT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busREQI}              {/testbench/uKS10/uMEM/busREQI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busACKO}              {/testbench/uKS10/uMEM/busACKO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busADDRI}             {/testbench/uKS10/uMEM/busADDRI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busDATAI}             {/testbench/uKS10/uMEM/busDATAI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busDATAO}             {/testbench/uKS10/uMEM/busDATAO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {writeEN}              {/testbench/uKS10/uMEM/writeEN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {memREAD}              {/testbench/uKS10/uMEM/memREAD}"  \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {memWRITE}             {/testbench/uKS10/uMEM/memWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {memWRTEST}            {/testbench/uKS10/uMEM/memWRTEST}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {SSRAM_CLK}            {/testbench/uKS10/uMEM/SSRAM_CLK}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {SSRAM_WE_N}           {/testbench/uKS10/uMEM/SSRAM_WE_N}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {SSRAM_ADV}            {/testbench/uKS10/uMEM/SSRAM_ADV}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {SSRAM_D}              {/testbench/uKS10/uMEM/SSRAM_D}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {SSRAM_A}              {/testbench/uKS10/uMEM/SSRAM_A[17:0]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {address}              {/testbench/uKS10/uMEM/SSRAM_A[17:1]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ssramDI}              {/testbench/uKS10/uMEM/ssramDI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ssramDO}              {/testbench/uKS10/uMEM/ssramDO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {SSRAM addreg}         {/testbench/SSRAM/addreg}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {SSRAM do}             {/testbench/SSRAM/do}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {tristate}             {/testbench/SSRAM/tristate}"

#	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mem[0]}               {/testbench/SSRAM/mem[0]}" \
#	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mem[1]}               {/testbench/SSRAM/mem[1]}" \
#	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mem[2]}               {/testbench/SSRAM/mem[2]}" \
#	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mem[3]}               {/testbench/SSRAM/mem[3]}" \
#	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mem[4]}               {/testbench/SSRAM/mem[4]}" \
#	"add wave -noupdate -radix octal    -radixshowbase 0 -label {mem[5]}               {/testbench/SSRAM/mem[5]}"

WAVE_ARB := \
	"add wave -noupdate -divider {ARBITER}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubaREQI}              {/testbench/uKS10/uARB/ubaREQI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubaREQO}              {/testbench/uKS10/uARB/ubaREQO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubaACKI}              {/testbench/uKS10/uARB/ubaACKI}" \
	"add wave -noupdate -divider {ARB Connections to UBA1}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubaREQI[1]}           {/testbench/uKS10/uARB/ubaREQI[1]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubaREQO[1]}           {/testbench/uKS10/uARB/ubaREQO[1]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubaACKI[1]}           {/testbench/uKS10/uARB/ubaACKI[1]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubaACKO[1]}           {/testbench/uKS10/uARB/ubaACKO[1]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubaADDRI[1]}          {/testbench/uKS10/uARB/ubaADDRI[1]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubaADDRO[1]}          {/testbench/uKS10/uARB/ubaADDRO[1]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubaDATAI[1]}          {/testbench/uKS10/uARB/ubaDATAI[1]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubaDATAO[1]}          {/testbench/uKS10/uARB/ubaDATAO[1]}" \
	"add wave -noupdate -divider {ARB Connections to UBA3}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubaREQI[3]}           {/testbench/uKS10/uARB/ubaREQI[3]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubaREQO[3]}           {/testbench/uKS10/uARB/ubaREQO[3]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubaACKI[3]}           {/testbench/uKS10/uARB/ubaACKI[3]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubaACKO[3]}           {/testbench/uKS10/uARB/ubaACKO[3]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubaADDRI[3]}          {/testbench/uKS10/uARB/ubaADDRI[3]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubaADDRO[3]}          {/testbench/uKS10/uARB/ubaADDRO[3]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubaDATAI[3]}          {/testbench/uKS10/uARB/ubaDATAI[3]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubaDATAO[3]}          {/testbench/uKS10/uARB/ubaDATAO[3]}"

WAVE_KS10 :=\
	"add wave -noupdate -divider {KS10 Device Interconnect}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQI}              {/testbench/uKS10/devREQI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQO}              {/testbench/uKS10/devREQO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devACKI}              {/testbench/uKS10/devACKI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devACKO}              {/testbench/uKS10/devACKO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devADDRI}             {/testbench/uKS10/devADDRI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devADDRO}             {/testbench/uKS10/devADDRO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAI}             {/testbench/uKS10/devDATAI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAO}             {/testbench/uKS10/devDATAO}"

WAVE_UBA1 := \
	"add wave -noupdate -divider {UBA1}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busREQI}              {/testbench/uKS10/UBA1/busREQI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busREQO}              {/testbench/uKS10/UBA1/busREQO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busACKI}              {/testbench/uKS10/UBA1/busACKI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busACKO}              {/testbench/uKS10/UBA1/busACKO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busADDRI}             {/testbench/uKS10/UBA1/busADDRI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busADDRO}             {/testbench/uKS10/UBA1/busADDRO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busDATAI}             {/testbench/uKS10/UBA1/busDATAI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busDATAO}             {/testbench/uKS10/UBA1/busDATAO}" \
	"add wave -noupdate -divider {UBA1, Register Control}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {wruREAD}              {/testbench/uKS10/UBA1/wruREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {vectREAD}             {/testbench/uKS10/UBA1/vectREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pageREAD}             {/testbench/uKS10/UBA1/pageREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pageWRITE}            {/testbench/uKS10/UBA1/pageWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {statREAD}             {/testbench/uKS10/UBA1/statREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {statWRITE}            {/testbench/uKS10/UBA1/statWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {maintWRITE}           {/testbench/uKS10/UBA1/maintWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubaREAD}              {/testbench/uKS10/UBA1/ubaREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubaWRITE}             {/testbench/uKS10/UBA1/ubaWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREAD}              {/testbench/uKS10/UBA1/devREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devWRITE}             {/testbench/uKS10/UBA1/devWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {loopREAD}             {/testbench/uKS10/UBA1/loopREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {loopWRITE}            {/testbench/uKS10/UBA1/loopWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {regUBASR}             {/testbench/uKS10/UBA1/regUBASR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {regUBAMR}             {/testbench/uKS10/UBA1/regUBAMR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {loopADDR}             {/testbench/uKS10/UBA1/loopADDR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {loopDATA}             {/testbench/uKS10/UBA1/loopDATA}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pageRAM}              {/testbench/uKS10/UBA1/PAGE/pageRAM}" \
	"add wave -noupdate -divider {UBA1, Interrupts}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {busINTR}              {/testbench/uKS10/UBA1/busINTR}" \
	"add wave -noupdate -divider {UBA1, Error Stuff}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {setNXD}               {/testbench/uKS10/UBA1/setNXD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {setTMO}               {/testbench/uKS10/UBA1/setTMO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pageFAIL}             {/testbench/uKS10/UBA1/pageFAIL}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pageFLAGS}            {/testbench/uKS10/UBA1/PAGE/pageFLAGS}" \
	"add wave -noupdate -divider {UBA1, DEV 1}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devINTR[1]}           {/testbench/uKS10/UBA1/devINTR[1]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQI[1]}           {/testbench/uKS10/UBA1/devREQI[1]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQO[1]}           {/testbench/uKS10/UBA1/devREQO[1]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devACKI[1]}           {/testbench/uKS10/UBA1/devACKI[1]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devACKO[1]}           {/testbench/uKS10/UBA1/devACKO[1]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devADDRI[1]}          {/testbench/uKS10/UBA1/devADDRI[1]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devADDRO[1]}          {/testbench/uKS10/UBA1/devADDRO[1]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAI[1]}          {/testbench/uKS10/UBA1/devDATAI[1]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAO[1]}          {/testbench/uKS10/UBA1/devDATAO[1]}" \
	"add wave -noupdate -divider {UBA1, DEV 2}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devINTR[2]}           {/testbench/uKS10/UBA1/devINTR[2]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQI[2]}           {/testbench/uKS10/UBA1/devREQI[2]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQO[2]}           {/testbench/uKS10/UBA1/devREQO[2]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devACKI[2]}           {/testbench/uKS10/UBA1/devACKI[2]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devACKO[2]}           {/testbench/uKS10/UBA1/devACKO[2]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devINTR[2]}           {/testbench/uKS10/UBA1/devINTR[2]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devADDRI[2]}          {/testbench/uKS10/UBA1/devADDRI[2]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devADDRO[2]}          {/testbench/uKS10/UBA1/devADDRO[2]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAI[2]}          {/testbench/uKS10/UBA1/devDATAI[2]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAO[2]}          {/testbench/uKS10/UBA1/devDATAO[2]}" \
	"add wave -noupdate -divider {UBA1, DEV 3}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devINTR[3]}           {/testbench/uKS10/UBA1/devINTR[3]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQI[3]}           {/testbench/uKS10/UBA1/devREQI[3]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQO[3]}           {/testbench/uKS10/UBA1/devREQO[3]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devACKI[3]}           {/testbench/uKS10/UBA1/devACKI[3]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devACKO[3]}           {/testbench/uKS10/UBA1/devACKO[3]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devINTR[3]}           {/testbench/uKS10/UBA1/devINTR[3]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devADDRI[3]}          {/testbench/uKS10/UBA1/devADDRI[3]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devADDRO[3]}          {/testbench/uKS10/UBA1/devADDRO[3]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAI[3]}          {/testbench/uKS10/UBA1/devDATAI[3]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAO[3]}          {/testbench/uKS10/UBA1/devDATAO[3]}" \
	"add wave -noupdate -divider {UBA1, DEV 4}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devINTR[4]}           {/testbench/uKS10/UBA1/devINTR[4]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQI[4]}           {/testbench/uKS10/UBA1/devREQI[4]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQO[4]}           {/testbench/uKS10/UBA1/devREQO[4]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devACKI[4]}           {/testbench/uKS10/UBA1/devACKI[4]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devACKO[4]}           {/testbench/uKS10/UBA1/devACKO[4]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devINTR[4]}           {/testbench/uKS10/UBA1/devINTR[4]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devADDRI[4]}          {/testbench/uKS10/UBA1/devADDRI[4]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devADDRO[4]}          {/testbench/uKS10/UBA1/devADDRO[4]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAI[4]}          {/testbench/uKS10/UBA1/devDATAI[4]}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAO[4]}          {/testbench/uKS10/UBA1/devDATAO[4]}"

WAVE_UBA2 := $(subst UBA1,UBA2,$(WAVE_UBA1))
WAVE_UBA3 := $(subst UBA1,UBA3,$(WAVE_UBA1))
WAVE_UBA4 := $(subst UBA1,UBA4,$(WAVE_UBA1))

WAVE_UBE1 := \
	"add wave -noupdate -divider {UBE1}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQI}              {/testbench/uKS10/uUBE1/devREQI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQO}              {/testbench/uKS10/uUBE1/devREQO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devACKI}              {/testbench/uKS10/uUBE1/devACKI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devACKO}              {/testbench/uKS10/uUBE1/devACKO}" \
	"add wave -noupdate -radix binary   -radixshowbase 0 -label {devINTR}              {/testbench/uKS10/uUBE1/devINTR}" \
	"add wave -noupdate -radix binary   -radixshowbase 0 -label {devINTA}              {/testbench/uKS10/uUBE1/devINTA}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAI}             {/testbench/uKS10/uUBE1/devDATAI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAO}             {/testbench/uKS10/uUBE1/devDATAO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devADDRI}             {/testbench/uKS10/uUBE1/devADDRI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devADDRO}             {/testbench/uKS10/uUBE1/devADDRO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREAD}              {/testbench/uKS10/uUBE1/devREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devWRITE}             {/testbench/uKS10/uUBE1/devWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devIO}                {/testbench/uKS10/uUBE1/devIO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devPHYS}                {/testbench/uKS10/uUBE1/devPHYS}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devIOBYTE}            {/testbench/uKS10/uUBE1/devIOBYTE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devWRU}               {/testbench/uKS10/uUBE1/devWRU}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devVECT}              {/testbench/uKS10/uUBE1/devVECT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDEV}               {/testbench/uKS10/uUBE1/devDEV}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devADDR}              {/testbench/uKS10/uUBE1/devADDR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devHIBYTE}            {/testbench/uKS10/uUBE1/devHIBYTE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devLOBYTE}            {/testbench/uKS10/uUBE1/devLOBYTE}" \
	"add wave -noupdate -divider {UBE1 PARAMS}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubeDEV}               {/testbench/uKS10/uUBE1/ubeDEV}" \
\	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubeVECT}              {/testbench/uKS10/uUBE1/ubeVECT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ubeADDR}              {/testbench/uKS10/uUBE1/ubeADDR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dbADDR}               {/testbench/uKS10/uUBE1/dbADDR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ccADDR}               {/testbench/uKS10/uUBE1/ccADDR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {csr1ADDR}             {/testbench/uKS10/uUBE1/csr1ADDR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {csr2ADDR}             {/testbench/uKS10/uUBE1/csr2ADDR}" \
	"add wave -noupdate -divider {UBE1 SELECT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {vectREAD}             {/testbench/uKS10/uUBE1/vectREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dbREAD}               {/testbench/uKS10/uUBE1/dbREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dbWRITE}              {/testbench/uKS10/uUBE1/dbWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ccREAD}               {/testbench/uKS10/uUBE1/ccREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ccWRITE}              {/testbench/uKS10/uUBE1/ccWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {baREAD}               {/testbench/uKS10/uUBE1/baREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {baWRITE}              {/testbench/uKS10/uUBE1/baWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {csr1READ}             {/testbench/uKS10/uUBE1/csr1READ}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {csr1WRITE}            {/testbench/uKS10/uUBE1/csr1WRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {csr2READ}             {/testbench/uKS10/uUBE1/csr2READ}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {csr2WRITE}            {/testbench/uKS10/uUBE1/csr2WRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {clrREAD}              {/testbench/uKS10/uUBE1/clrREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {clrWRITE}             {/testbench/uKS10/uUBE1/clrWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {simgoREAD}            {/testbench/uKS10/uUBE1/simgoREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {simgoWRITE}           {/testbench/uKS10/uUBE1/simgoWRITE}" \
	"add wave -noupdate -divider {UBE1 REGS}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {regDB}                {/testbench/uKS10/uUBE1/regDB}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {regCC}                {/testbench/uKS10/uUBE1/regCC}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {regBA}                {/testbench/uKS10/uUBE1/regBA}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {regCSR1}              {/testbench/uKS10/uUBE1/regCSR1}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {regCSR2}              {/testbench/uKS10/uUBE1/regCSR2}" \

WAVE_UBE2 := $(subst UBE1,UBE2,$(WAVE_UBE1))
WAVE_UBE3 := $(subst UBE1,UBE3,$(WAVE_UBE1))
WAVE_UBE4 := $(subst UBE1,UBE4,$(WAVE_UBE1))

WAVE_DUP11 :=\
	"add wave -noupdate -divider {DUP11}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQI}              {/testbench/uKS10/uDUP11/devREQI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQO}              {/testbench/uKS10/uDUP11/devREQO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devACKI}              {/testbench/uKS10/uDUP11/devACKI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devACKO}              {/testbench/uKS10/uDUP11/devACKO}" \
	"add wave -noupdate -radix binary   -radixshowbase 0 -label {devINTR}              {/testbench/uKS10/uDUP11/devINTR}" \
	"add wave -noupdate -radix binary   -radixshowbase 0 -label {devINTA}              {/testbench/uKS10/uDUP11/devINTA}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAI}             {/testbench/uKS10/uDUP11/devDATAI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAO}             {/testbench/uKS10/uDUP11/devDATAO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devADDRI}             {/testbench/uKS10/uDUP11/devADDRI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devADDRO}             {/testbench/uKS10/uDUP11/devADDRO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREAD}              {/testbench/uKS10/uDUP11/devREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devWRITE}             {/testbench/uKS10/uDUP11/devWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devIO}                {/testbench/uKS10/uDUP11/devIO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devIOBYTE}            {/testbench/uKS10/uDUP11/devIOBYTE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devWRU}               {/testbench/uKS10/uDUP11/devWRU}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devHIBYTE}            {/testbench/uKS10/uDUP11/devHIBYTE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devLOBYTE}            {/testbench/uKS10/uDUP11/devLOBYTE}" \
	"add wave -noupdate -divider {DUP11 REGS}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {RXCSR  REG}           {/testbench/uKS10/uDUP11/regRXCSR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {RXDBUF REG}           {/testbench/uKS10/uDUP11/regRXDBUF}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {TXCSR  REG}           {/testbench/uKS10/uDUP11/regTXCSR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {TXDBUF REG}           {/testbench/uKS10/uDUP11/regTXDBUF}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {PARCSR REG}           {/testbench/uKS10/uDUP11/regPARCSR}" \
	"add wave -noupdate -divider {DUP11 MODEM}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupW3}                {/testbench/uKS10/uDUP11/RXCSR/dupW3}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupW5}                {/testbench/uKS10/uDUP11/RXCSR/dupW5}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupW6}                {/testbench/uKS10/uDUP11/RXCSR/dupW6}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupDSCA}              {/testbench/uKS10/uDUP11/RXCSR/dupDSCA}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupSECTX}             {/testbench/uKS10/uDUP11/RXCSR/dupSECTX}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupSECRX}             {/testbench/uKS10/uDUP11/RXCSR/dupSECRX}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupRI}                {/testbench/uKS10/uDUP11/dupRI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupCTS}               {/testbench/uKS10/uDUP11/dupCTS}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupDCD}               {/testbench/uKS10/uDUP11/dupDCD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupDSR}               {/testbench/uKS10/uDUP11/dupDSR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupRTS}               {/testbench/uKS10/uDUP11/dupRTS}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupDTR}               {/testbench/uKS10/uDUP11/dupDTR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupDSCB}              {/testbench/uKS10/uDUP11/RXCSR/dupDSCB}" \
	"add wave -noupdate -divider {DUP11 CLKS}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupMSEL}              {/testbench/uKS10/uDUP11/uDUPCLK/dupMSEL}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {clk10KHz}             {/testbench/uKS10/uDUP11/uDUPCLK/clk10KHz}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {clk5KHz}              {/testbench/uKS10/uDUP11/uDUPCLK/clk5KHz}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupMCO}               {/testbench/uKS10/uDUP11/uDUPCLK/dupMCO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupMNTT}              {/testbench/uKS10/uDUP11/uDUPCLK/dupMNTT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupRXCEN}             {/testbench/uKS10/uDUP11/uDUPCLK/dupRXCEN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupTXCEN}             {/testbench/uKS10/uDUP11/uDUPCLK/dupTXCEN}" \
	"add wave -noupdate -divider {DUP11 TX}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupDECMD}             {/testbench/uKS10/uDUP11/uDUPTX/dupDECMD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupCRCI}              {/testbench/uKS10/uDUP11/uDUPTX/dupCRCI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupMSEL}              {/testbench/uKS10/uDUP11/uDUPTX/dupMSEL}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupSEND}              {/testbench/uKS10/uDUP11/uDUPTX/dupSEND}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupTXABRT}            {/testbench/uKS10/uDUP11/uDUPTX/dupTXABRT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupTXEOM}             {/testbench/uKS10/uDUP11/uDUPTX/dupTXEOM}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupTXSOM}             {/testbench/uKS10/uDUP11/uDUPTX/dupTXSOM}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupTXCEN}             {/testbench/uKS10/uDUP11/uDUPTX/dupTXCEN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupTXDONE}            {/testbench/uKS10/uDUP11/uDUPTX/dupTXDONE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupTXACT}             {/testbench/uKS10/uDUP11/uDUPTX/dupTXACT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupTXDLE}             {/testbench/uKS10/uDUP11/uDUPTX/dupTXDLE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupTXD}               {/testbench/uKS10/uDUP11/uDUPTX/dupTXD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {txdbufWRITE}          {/testbench/uKS10/uDUP11/txdbufWRITE}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {state}                {/testbench/uKS10/uDUP11/uDUPTX/state}" \
	"add wave -noupdate -divider {DUP11 USRT TX}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {clr}                  {/testbench/uKS10/uDUP11/uDUPTX/uUSRT_TX/clr}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {clken}                {/testbench/uKS10/uDUP11/uDUPTX/uUSRT_TX/clken}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {abort}                {/testbench/uKS10/uDUP11/uDUPTX/uUSRT_TX/abort}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {flag}                 {/testbench/uKS10/uDUP11/uDUPTX/uUSRT_TX/flag}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {data}                 {/testbench/uKS10/uDUP11/uDUPTX/uUSRT_TX/data}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {zbi}                  {/testbench/uKS10/uDUP11/uDUPTX/uUSRT_TX/zbi}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {load}                 {/testbench/uKS10/uDUP11/uDUPTX/uUSRT_TX/load}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {last}                 {/testbench/uKS10/uDUP11/uDUPTX/uUSRT_TX/last}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {empty}                {/testbench/uKS10/uDUP11/uDUPTX/uUSRT_TX/empty}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {txd}                  {/testbench/uKS10/uDUP11/uDUPTX/uUSRT_TX/txd}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {txdat}                {/testbench/uKS10/uDUP11/uDUPTX/uUSRT_TX/txdat}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {txlen}                {/testbench/uKS10/uDUP11/uDUPTX/uUSRT_TX/txlen}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {txzbi}                {/testbench/uKS10/uDUP11/uDUPTX/uUSRT_TX/txzbi}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {count}                {/testbench/uKS10/uDUP11/uDUPTX/uUSRT_TX/count}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {state}                {/testbench/uKS10/uDUP11/uDUPTX/uUSRT_TX/state}" \
	"add wave -noupdate -divider {DUP11 TXCRC}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {din}                  {/testbench/uKS10/uDUP11/uDUPTX/uCRC16/din}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {poly}                 {/testbench/uKS10/uDUP11/uDUPTX/uCRC16/poly}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {init}                 {/testbench/uKS10/uDUP11/uDUPTX/uCRC16/init}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {crc}                  {/testbench/uKS10/uDUP11/uDUPTX/uCRC16/crc}" \
	"add wave -noupdate -divider {DUP11 RX}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupMCO}               {/testbench/uKS10/uDUP11/uDUPCLK/dupMCO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupMDI}               {/testbench/uKS10/uDUP11/uDUPRX/dupMDI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupRXIN}              {/testbench/uKS10/uDUP11/uDUPRX/dupRXIN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupINIT}              {/testbench/uKS10/uDUP11/uDUPRX/dupINIT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupCRCI}              {/testbench/uKS10/uDUP11/uDUPRX/dupCRCI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupMSEL}              {/testbench/uKS10/uDUP11/uDUPRX/dupMSEL}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupRXEN}              {/testbench/uKS10/uDUP11/uDUPRX/dupRXEN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupRXACT}             {/testbench/uKS10/uDUP11/uDUPRX/dupRXACT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupRXSOM}             {/testbench/uKS10/uDUP11/uDUPRX/dupRXSOM}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupRXEOM}             {/testbench/uKS10/uDUP11/uDUPRX/dupRXEOM}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupRXCRCE}            {/testbench/uKS10/uDUP11/uDUPRX/dupRXCRCE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupRXABRT}            {/testbench/uKS10/uDUP11/uDUPRX/dupRXABRT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupRXDONE}            {/testbench/uKS10/uDUP11/uDUPRX/dupRXDONE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupCRCINIT}           {/testbench/uKS10/uDUP11/uDUPRX/dupCRCINIT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupDECMD}             {/testbench/uKS10/uDUP11/uDUPRX/dupDECMD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupSSM}               {/testbench/uKS10/uDUP11/uDUPRX/dupSSM}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupRXCEN}             {/testbench/uKS10/uDUP11/uDUPRX/dupRXCEN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupRXD}               {/testbench/uKS10/uDUP11/uDUPRX/dupRXD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupRXDAT}             {/testbench/uKS10/uDUP11/uDUPRX/dupRXDAT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupRXCRCE}            {/testbench/uKS10/uDUP11/uDUPRX/dupRXCRCE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupRXABRT}            {/testbench/uKS10/uDUP11/uDUPRX/dupRXABRT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupCRCERR}            {/testbench/uKS10/uDUP11/uDUPRX/dupCRCERR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {dupCRCLO}             {/testbench/uKS10/uDUP11/uDUPRX/dupCRCLO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {state}                {/testbench/uKS10/uDUP11/uDUPRX/state}" \
	"add wave -noupdate -divider {DUP11 USRT RX}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {clr}                  {/testbench/uKS10/uDUP11/uDUPRX/uUSRT_RX/clr}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {clken}                {/testbench/uKS10/uDUP11/uDUPRX/uUSRT_RX/clken}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {rxd}                  {/testbench/uKS10/uDUP11/uDUPRX/uUSRT_RX/rxd}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {decmode}              {/testbench/uKS10/uDUP11/uDUPRX/uUSRT_RX/decmode}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {synchr}               {/testbench/uKS10/uDUP11/uDUPRX/uUSRT_RX/synchr}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {stat}                 {/testbench/uKS10/uDUP11/uDUPRX/uUSRT_RX/stat}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {bitcnt}               {/testbench/uKS10/uDUP11/uDUPRX/uUSRT_RX/bitcnt}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {ones}                 {/testbench/uKS10/uDUP11/uDUPRX/uUSRT_RX/ones}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {zbd}                  {/testbench/uKS10/uDUP11/uDUPRX/uUSRT_RX/zbd}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {sync}                 {/testbench/uKS10/uDUP11/uDUPRX/uUSRT_RX/sync}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {flag}                 {/testbench/uKS10/uDUP11/uDUPRX/uUSRT_RX/flag}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {abort}                {/testbench/uKS10/uDUP11/uDUPRX/uUSRT_RX/abort}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {valid}                {/testbench/uKS10/uDUP11/uDUPRX/uUSRT_RX/valid}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {data}                 {/testbench/uKS10/uDUP11/uDUPRX/uUSRT_RX/data}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {full}                 {/testbench/uKS10/uDUP11/uDUPRX/uUSRT_RX/full}" \
	"add wave -noupdate -divider {DUP11 RX CRC16}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {din}                  {/testbench/uKS10/uDUP11/uDUPRX/uCRC16/din}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {poly}                 {/testbench/uKS10/uDUP11/uDUPRX/uCRC16/poly}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {init}                 {/testbench/uKS10/uDUP11/uDUPRX/uCRC16/init}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {crc}                  {/testbench/uKS10/uDUP11/uDUPRX/uCRC16/crc}" \
	"add wave -noupdate -divider {DUP11 RX INTR}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {dupRXDONE}            {/testbench/uKS10/uDUP11/uDUPRX/dupRXDONE}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {dupRXIE}              {/testbench/uKS10/uDUP11/RXCSR/regRXCSR[6]}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {dupIREQ}              {/testbench/uKS10/uDUP11/uRXINTR/dupIREQ}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {dupIACK}              {/testbench/uKS10/uDUP11/uRXINTR/dupIACK}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {dupSECINH}            {/testbench/uKS10/uDUP11/uRXINTR/dupSECINH}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {dupPRIACT}            {/testbench/uKS10/uDUP11/uRXINTR/dupPRIACT}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {dupIRQO}              {/testbench/uKS10/uDUP11/uRXINTR/dupIRQO}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {state}                {/testbench/uKS10/uDUP11/uRXINTR/state}" \
	"add wave -noupdate -divider {DUP11 TX INTR}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {dupTXDONE}            {/testbench/uKS10/uDUP11/uDUPTX/dupTXDONE}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {dupTXIE}              {/testbench/uKS10/uDUP11/TXCSR/regTXCSR[6]}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {dupIREQ}              {/testbench/uKS10/uDUP11/uTXINTR/dupIREQ}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {dupIACK}              {/testbench/uKS10/uDUP11/uTXINTR/dupIACK}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {dupSECINH}            {/testbench/uKS10/uDUP11/uTXINTR/dupSECINH}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {dupPRIACT}            {/testbench/uKS10/uDUP11/uTXINTR/dupPRIACT}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {dupIRQO}              {/testbench/uKS10/uDUP11/uTXINTR/dupIRQO}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {state}                {/testbench/uKS10/uDUP11/uTXINTR/state}" \
	"add wave -noupdate -divider {DUP11 REG READ/WRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAI}             {/testbench/uKS10/uDUP11/devDATAI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAO}             {/testbench/uKS10/uDUP11/devDATAO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {rxcsrREAD}            {/testbench/uKS10/uDUP11/rxcsrREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {rxcsrWRITE}           {/testbench/uKS10/uDUP11/rxcsrWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {rxdbufREAD}           {/testbench/uKS10/uDUP11/rxdbufREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {parcsrWRITE}          {/testbench/uKS10/uDUP11/parcsrWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {txcsrREAD}            {/testbench/uKS10/uDUP11/txcsrREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {txcsrWRITE}           {/testbench/uKS10/uDUP11/txcsrWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {txdbufREAD}           {/testbench/uKS10/uDUP11/txdbufREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {txdbufWRITE}          {/testbench/uKS10/uDUP11/txdbufWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {vectREAD}             {/testbench/uKS10/uDUP11/vectREAD}" \
	"add wave -noupdate -divider {DUP11 BARF}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0                               {/testbench/uKS10/uDUP11/uDUPTX/*}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0                               {/testbench/uKS10/uDUP11/uDUPTX/uUSRT_TX/*}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0                               {/testbench/uKS10/uDUP11/uDUPRX/*}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0                               {/testbench/uKS10/uDUP11/uDUPRX/uUSRT_RX/*}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0                               {/testbench/uKS10/uDUP11/uRXINTR/*}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0                               {/testbench/uKS10/uDUP11/uTXINTR/*}"

WAVE_KMC11 := \
	"add wave -noupdate -divider {KMC11}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcPCCLKEN}           {/testbench/uKS10/uKMC11/kmcPCCLKEN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcCRAMCLKEN}         {/testbench/uKS10/uKMC11/kmcCRAMCLKEN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcCRAMIN}            {/testbench/uKS10/uKMC11/kmcCRAMIN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcCRAMOUT}           {/testbench/uKS10/uKMC11/kmcCRAMOUT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQO}              {/testbench/uKS10/uKMC11/devREQO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devACKI}              {/testbench/uKS10/uKMC11/devACKI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devADDRO}             {/testbench/uKS10/uKMC11/devADDRO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAI}             {/testbench/uKS10/uKMC11/devDATAI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQI}              {/testbench/uKS10/uKMC11/devREQI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devACKO}              {/testbench/uKS10/uKMC11/devACKO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devADDRI}             {/testbench/uKS10/uKMC11/devADDRI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAO}             {/testbench/uKS10/uKMC11/devDATAO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcMISC}              {/testbench/uKS10/uKMC11/kmcMISC}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcNPRC}              {/testbench/uKS10/uKMC11/kmcNPRC}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcCRAMOUT}           {/testbench/uKS10/uKMC11/kmcCRAMOUT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcCRAMOUT}           {/testbench/uKS10/uKMC11/kmcCRAMOUT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcALU}               {/testbench/uKS10/uKMC11/kmcALU}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcALUC}              {/testbench/uKS10/uKMC11/kmcALUC}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcALUZ}              {/testbench/uKS10/uKMC11/kmcALUZ}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcMEM}               {/testbench/uKS10/uKMC11/kmcMEM}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcMAR}               {/testbench/uKS10/uKMC11/kmcMAR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcPC}                {/testbench/uKS10/uKMC11/kmcPC}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcCRAM}              {/testbench/uKS10/uKMC11/kmcCRAM}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcDMUX}              {/testbench/uKS10/uKMC11/kmcDMUX}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcBRG}               {/testbench/uKS10/uKMC11/kmcBRG}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcCSR0}              {/testbench/uKS10/uKMC11/kmcCSR0}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcCSR2}              {/testbench/uKS10/uKMC11/kmcCSR2}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcCSR4}              {/testbench/uKS10/uKMC11/kmcCSR4}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcCSR6}              {/testbench/uKS10/uKMC11/kmcCSR6}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcNPRID}             {/testbench/uKS10/uKMC11/kmcNPRID}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcNPROD}             {/testbench/uKS10/uKMC11/kmcNPROD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcNPRIA}             {/testbench/uKS10/uKMC11/kmcNPRIA}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcNPROA}             {/testbench/uKS10/uKMC11/kmcNPROA}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcMNTADDR}           {/testbench/uKS10/uKMC11/kmcMNTADDR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcMNTINST}           {/testbench/uKS10/uKMC11/kmcMNTINST}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {sel0READ}             {/testbench/uKS10/uKMC11/sel0READ}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {sel0WRITE}            {/testbench/uKS10/uKMC11/sel0WRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {sel2READ}             {/testbench/uKS10/uKMC11/sel2READ}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {sel2WRITE}            {/testbench/uKS10/uKMC11/sel2WRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {sel4READ}             {/testbench/uKS10/uKMC11/sel4READ}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {sel4WRITE}            {/testbench/uKS10/uKMC11/sel4WRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {sel6READ}             {/testbench/uKS10/uKMC11/sel6READ}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {sel6WRITE}            {/testbench/uKS10/uKMC11/sel6WRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {vectREAD}             {/testbench/uKS10/uKMC11/vectREAD}" \
	"add wave -noupdate -divider {KMC11 Interrupt}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcSETIRQ}            {/testbench/uKS10/uKMC11/kmcSETIRQ}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcIRQO}              {/testbench/uKS10/uKMC11/kmcIRQO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcVECTXXX4}          {/testbench/uKS10/uKMC11/kmcVECTXXX4}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {vectREAD}             {/testbench/uKS10/uKMC11/vectREAD}" \
	"add wave -noupdate -divider {KMC11 NPRC}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQO}              {/testbench/uKS10/uKMC11/uNPRC/devREQO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devACKI}              {/testbench/uKS10/uKMC11/uNPRC/devACKI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcLDNPRC}            {/testbench/uKS10/uKMC11/uNPRC/kmcLDNPRC}" \
	"add wave -noupdate -radix decimal  -radixshowbase 0 -label {kmcNXMCNT}            {/testbench/uKS10/uKMC11/uNPRC/kmcNXMCNT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcSETNXM}            {/testbench/uKS10/uKMC11/uNPRC/kmcSETNXM}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcNPRCLKEN}          {/testbench/uKS10/uKMC11/uNPRC/kmcNPRCLKEN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {state}                {/testbench/uKS10/uKMC11/uNPRC/state}" \
#	"add wave -noupdate -divider {KMC11 Memories}" \
#	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcCRAM_MEM}          {/testbench/uKS10/uKMC11/uSEQ/kmcCRAM_MEM}" \
#	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcRAM}               {/testbench/uKS10/uKMC11/uMEM/ram}" \
#	"add wave -noupdate -radix octal    -radixshowbase 0 -label {kmcSP}                {/testbench/uKS10/uKMC11/uALU/kmcSP}" \
#	"add wave -noupdate -divider {KMC11 ALL}" \
#	"add wave -noupdate -radix octal    -radixshowbase 0                               {/testbench/uKS10/uKMC11/*}" \
#	"add wave -noupdate -radix octal    -radixshowbase 0                               {/testbench/uKS10/uKMC11/uSEQ/*}" \
#	"add wave -noupdate -radix octal    -radixshowbase 0                               {/testbench/uKS10/uKMC11/uALU/*}" \
#	"add wave -noupdate -radix octal    -radixshowbase 0                               {/testbench/uKS10/uKMC11/uBRG/*}" \

WAVE_RH11 := \
	"add wave -noupdate -divider {RH11}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQI}              {/testbench/uKS10/uRH11/devREQI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQO}              {/testbench/uKS10/uRH11/devREQO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devACKI}              {/testbench/uKS10/uRH11/devACKI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devACKO}              {/testbench/uKS10/uRH11/devACKO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAI}             {/testbench/uKS10/uRH11/devDATAI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAO}             {/testbench/uKS10/uRH11/devDATAO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devADDRI}             {/testbench/uKS10/uRH11/devADDRI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devADDRO}             {/testbench/uKS10/uRH11/devADDRO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {RHCS1 REG}            {/testbench/uKS10/uRH11/rhCS1}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {RHWC  REG}            {/testbench/uKS10/uRH11/rhWC}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {RHBA  REG}            {/testbench/uKS10/uRH11/rhBA}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {RHCS2 REG}            {/testbench/uKS10/uRH11/rhCS2}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {RHDB  REG}            {/testbench/uKS10/uRH11/rhDB}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {RPDA  REG}            {/testbench/uKS10/uRH11/rpDA}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {RPDS  REG}            {/testbench/uKS10/uRH11/rpDS}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {RPER1 REG}            {/testbench/uKS10/uRH11/rpER1}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {RPAS  REG}            {/testbench/uKS10/uRH11/rpAS}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {RPLA  REG}            {/testbench/uKS10/uRH11/rpLA}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {RPMR  REG}            {/testbench/uKS10/uRH11/rpMR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {RPDT  REG}            {/testbench/uKS10/uRH11/rpDT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {RPSN  REG}            {/testbench/uKS10/uRH11/rpSN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {RPOF  REG}            {/testbench/uKS10/uRH11/rpOF}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {RPDC  REG}            {/testbench/uKS10/uRH11/rpDC}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {RPCC  REG}            {/testbench/uKS10/uRH11/rpCC}"

WAVE_SD := \
	"add wave -noupdate -divider {SD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ch}                   {/testbench/SD/ch}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {spiTX}                {/testbench/SD/spiTX}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQO}              {/testbench/uKS10/uRH11/uSD/devREQO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAO}             {/testbench/uKS10/uRH11/uSD/devDATAO}" \

WAVE_LP20 :=\
	"add wave -noupdate -divider {LP20}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpONLINE}             {/testbench/uKS10/uLP20/lpONLINE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQI}              {/testbench/uKS10/uLP20/devREQI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQO}              {/testbench/uKS10/uLP20/devREQO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devACKI}              {/testbench/uKS10/uLP20/devACKI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devACKO}              {/testbench/uKS10/uLP20/devACKO}" \
	"add wave -noupdate -radix binary   -radixshowbase 0 -label {devINTR}              {/testbench/uKS10/uLP20/devINTR}" \
	"add wave -noupdate -radix binary   -radixshowbase 0 -label {devINTA}              {/testbench/uKS10/uLP20/devINTA}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAI}             {/testbench/uKS10/uLP20/devDATAI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAO}             {/testbench/uKS10/uLP20/devDATAO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devADDRI}             {/testbench/uKS10/uLP20/devADDRI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devADDRO}             {/testbench/uKS10/uLP20/devADDRO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREAD}              {/testbench/uKS10/uLP20/devREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devWRITE}             {/testbench/uKS10/uLP20/devWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devIO}                {/testbench/uKS10/uLP20/devIO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devIOBYTE}            {/testbench/uKS10/uLP20/devIOBYTE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devWRU}               {/testbench/uKS10/uLP20/devWRU}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpTOF}                {/testbench/uKS10/uLP20/lpTOF}" \
	"add wave -noupdate -divider {LP20 REGS}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {CSRA REG}             {/testbench/uKS10/uLP20/regCSRA}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {CSRB REG}             {/testbench/uKS10/uLP20/regCSRB}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {BAR  REG}             {/testbench/uKS10/uLP20/regBAR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {BCTR REG}             {/testbench/uKS10/uLP20/regBCTR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {PCTR REG}             {/testbench/uKS10/uLP20/regPCTR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {RAMD REG}             {/testbench/uKS10/uLP20/regRAMD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {CCTR REG}             {/testbench/uKS10/uLP20/regCCTR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {CBUF REG}             {/testbench/uKS10/uLP20/regCBUF}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {CKSM REG}             {/testbench/uKS10/uLP20/regCKSM}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {PDAT REG}             {/testbench/uKS10/uLP20/regPDAT}" \
	"add wave -noupdate -divider {LP20 DMA}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpCMDGO}              {/testbench/uKS10/uLP20/DMA/lpCMDGO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpCMDSTOP}            {/testbench/uKS10/uLP20/DMA/lpCMDSTOP}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpREADY}              {/testbench/uKS10/uLP20/DMA/lpREADY}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {DMA state}            {/testbench/uKS10/uLP20/DMA/state}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {DMA timer}            {/testbench/uKS10/uLP20/DMA/timer}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpDONE}               {/testbench/uKS10/uLP20/DMA/lpDONE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpTESTMSYN}           {/testbench/uKS10/uLP20/DMA/lpTESTMSYN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpTESTMPE}            {/testbench/uKS10/uLP20/DMA/lpTESTMPE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpINCR}               {/testbench/uKS10/uLP20/DMA/lpINCR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpSETMSYN}            {/testbench/uKS10/uLP20/DMA/lpSETMSYN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpSETMPE}             {/testbench/uKS10/uLP20/DMA/lpSETMPE}" \
	"add wave -noupdate -divider {LP20 Interrupts}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devINTR}              {/testbench/uKS10/uLP20/INTR/devINTR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devINTA}              {/testbench/uKS10/uLP20/INTR/devINTA}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpINTR}               {/testbench/uKS10/uLP20/INTR/lpINTR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpIE}                 {/testbench/uKS10/uLP20/INTR/lpIE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpIRQ}                {/testbench/uKS10/uLP20/INTR/lpIRQ}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpSETIRQ}             {/testbench/uKS10/uLP20/CSRA/lpSETIRQ}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpSETERR}             {/testbench/uKS10/uLP20/CSRA/lpSETERR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpSETPCZ}             {/testbench/uKS10/uLP20/CSRA/lpSETPCZ}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpSETUNDC}            {/testbench/uKS10/uLP20/CSRA/lpSETUNDC}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpSETDONE}            {/testbench/uKS10/uLP20/CSRA/lpDONE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpVFURDY}             {/testbench/uKS10/uLP20/CSRA/lpVFURDY}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpONLINE}             {/testbench/uKS10/uLP20/CSRA/lpONLINE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lastONLINE}           {/testbench/uKS10/uLP20/CSRA/lastONLINE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpINIT}               {/testbench/uKS10/uLP20/INTR/lpINIT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devWRI}               {/testbench/uKS10/uLP20/INTR/devWRU}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {vectREAD}             {/testbench/uKS10/uLP20/INTR/vectREAD}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {state}                {/testbench/uKS10/uLP20/INTR/state}" \
	"add wave -noupdate -divider {LP20 RAMD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQO}              {/testbench/uKS10/uLP20/RAMD/devREQO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devACKI}              {/testbench/uKS10/uLP20/RAMD/devACKI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpDATAI}              {/testbench/uKS10/uLP20/RAMD/lpDATAI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ramWRITE}             {/testbench/uKS10/uLP20/RAMD/ramWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {wordDATAI}            {/testbench/uKS10/uLP20/RAMD/wordDATAI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {byteDATAI}            {/testbench/uKS10/uLP20/RAMD/byteDATAI}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {ramADDR}              {/testbench/uKS10/uLP20/RAMD/ramADDR}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {lpADDR}               {/testbench/uKS10/uLP20/RAMD/lpADDR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpCMDGO}              {/testbench/uKS10/uLP20/RAMD/lpCMDGO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpINCADDR}            {/testbench/uKS10/uLP20/RAMD/lpINCADDR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpMODEPRINT}          {/testbench/uKS10/uLP20/RAMD/lpMODEPRINT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpMODETEST}           {/testbench/uKS10/uLP20/RAMD/lpMODETEST}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpMODELDVFU}          {/testbench/uKS10/uLP20/RAMD/lpMODELDVFU}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpMODELDRAM}          {/testbench/uKS10/uLP20/RAMD/lpMODELDRAM}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ramDATA}              {/testbench/uKS10/uLP20/RAMD/ramDATA}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ramCTRL}              {/testbench/uKS10/uLP20/RAMD/ramCTRL}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {regRAMD}              {/testbench/uKS10/uLP20/RAMD/regRAMD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpRPEEN}              {/testbench/uKS10/uLP20/RAMD/lpRPEEN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpDHLDEN}             {/testbench/uKS10/uLP20/RAMD/lpDHLDEN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpSETDHLD}            {/testbench/uKS10/uLP20/RAMD/lpSETDHLD}" \
	"add wave -noupdate -divider {LP20 PDAT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devREQO}              {/testbench/uKS10/uLP20/PDAT/devREQO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devACKI}              {/testbench/uKS10/uLP20/PDAT/devACKI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpDMAWR}              {/testbench/uKS10/uLP20/PDAT/lpDMAWR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {CBUF REG}             {/testbench/uKS10/uLP20/PDAT/lpCBUF}" \
	"add wave -noupdate -radix hex      -radixshowbase 0 -label {CBUF REG}             {/testbench/uKS10/uLP20/PDAT/lpCBUF}" \
	"add wave -noupdate -radix ascii    -radixshowbase 0 -label {CBUF REG}             {/testbench/uKS10/uLP20/PDAT/lpCBUF}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {RAMD REG}             {/testbench/uKS10/uLP20/PDAT/lpRAMD}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {CCTR REG}             {/testbench/uKS10/uLP20/PDAT/lpCCTR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpOP}                 {/testbench/uKS10/uLP20/PDAT/lpOP}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpTESTDTE}            {/testbench/uKS10/uLP20/PDAT/lpTESTDTE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpTESTLPE}            {/testbench/uKS10/uLP20/PDAT/lpTESTLPE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpSETDTE}             {/testbench/uKS10/uLP20/PDAT/lpSETDTE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpDPAR}               {/testbench/uKS10/uLP20/PDAT/lpDPAR}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {state}                {/testbench/uKS10/uLP20/PDAT/state}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpCLRCCTR}            {/testbench/uKS10/uLP20/PDAT/lpCLRCCTR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpINCCCTR}            {/testbench/uKS10/uLP20/PDAT/lpINCCCTR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpSETUNDC}            {/testbench/uKS10/uLP20/PDAT/lpSETUNDC}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpSETDTE}             {/testbench/uKS10/uLP20/PDAT/lpSETDTE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpDEMAND}             {/testbench/uKS10/uLP20/PDAT/lpDEMAND}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpVAL}                {/testbench/uKS10/uLP20/PDAT/lpVAL}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpLPE}                {/testbench/uKS10/uLP20/PDAT/lpLPE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpPI}                 {/testbench/uKS10/uLP20/PDAT/lpPI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpSTROBE}             {/testbench/uKS10/uLP20/PDAT/lpSTROBE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpDATA}               {/testbench/uKS10/uLP20/PDAT/lpDATA}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpPDAT}               {/testbench/uKS10/uLP20/PDAT/lpPDAT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpPARERR}             {/testbench/uKS10/uLP20/PDAT/lpPARERR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpREADY}              {/testbench/uKS10/uLP20/DMA/lpREADY}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {strobe}               {/testbench/uKS10/uLP20/PDAT/strobe}" \
	"add wave -noupdate -divider {LP26}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {clk}                  {/testbench/uKS10/uLP26/clk}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {rst}                  {/testbench/uKS10/uLP26/rst}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpINIT}               {/testbench/uKS10/uLP26/lpINIT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpOVFU}               {/testbench/uKS10/uLP26/lpOVFU}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpSETONLN}            {/testbench/uKS10/uLP26/lpSETONLN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpSETOFFLN}           {/testbench/uKS10/uLP26/lpSETOFFLN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpONLINE}             {/testbench/uKS10/uLP26/lpONLINE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpSTROBE}             {/testbench/uKS10/uLP26/lpSTROBE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpPI}                 {/testbench/uKS10/uLP26/lpPI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpDATA}               {/testbench/uKS10/uLP26/lpDATA}" \
	"add wave -noupdate -radix ascii    -radixshowbase 0 -label {lpDATA}               {/testbench/uKS10/uLP26/lpDATA}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpDPAR}               {/testbench/uKS10/uLP26/lpDPAR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpPARERR}             {/testbench/uKS10/uLP26/lpPARERR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpVFURDY}             {/testbench/uKS10/uLP26/lpVFURDY}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpDEMAND}             {/testbench/uKS10/uLP26/lpDEMAND}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {lpLCTR}               {/testbench/uKS10/uLP26/lpLCTR}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {lpVFULEN}             {/testbench/uKS10/uLP26/lpVFULEN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpTXEMPTY}            {/testbench/uKS10/uLP26/lpTXEMPTY}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpTXSTB}              {/testbench/uKS10/uLP26/lpTXSTB}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpTXDAT}              {/testbench/uKS10/uLP26/lpTXDAT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpXON}                {/testbench/uKS10/uLP26/lpXON}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {state}                {/testbench/uKS10/uLP26/state}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {lpDVFULEN}            {/testbench/uKS10/uLP26/lpDVFULEN}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {lpOVFULEN}            {/testbench/uKS10/uLP26/lpOVFULEN}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {lpVFULEN}             {/testbench/uKS10/uLP26/lpVFULEN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpTEMP}               {/testbench/uKS10/uLP26/lpTEMP}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {lpCOUNT}              {/testbench/uKS10/uLP26/lpCOUNT}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {lpLFCNT}              {/testbench/uKS10/uLP26/lpLFCNT}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {lpLCTR}               {/testbench/uKS10/uLP26/lpLCTR}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {lpCCTR}               {/testbench/uKS10/uLP26/lpCCTR}" \
	"add wave -noupdate -radix ascii    -radixshowbase 0 -label {lpLINBUF}             {/testbench/uKS10/uLP26/lpLINBUF}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpTOF}                {/testbench/uKS10/uLP26/lpTOF}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpDVFUDAT}            {/testbench/uKS10/uLP26/lpDVFUDAT}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpOVFUDAT}            {/testbench/uKS10/uLP26/lpOVFUDAT}" \
	"add wave -noupdate -divider {LP20 UART}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {clken}                {/testbench/uKS10/uLP26/TX/clken}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {load}                 {/testbench/uKS10/uLP26/TX/load}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {data}                 {/testbench/uKS10/uLP26/TX/data}" \
	"add wave -noupdate -radix ascii    -radixshowbase 0 -label {data}                 {/testbench/uKS10/uLP26/TX/data}" \
	"add wave -noupdate -radix unsigned -radixshowbase 0 -label {state}                {/testbench/uKS10/uLP26/TX/state}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {empty}                {/testbench/uKS10/uLP26/TX/empty}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {intr}                 {/testbench/uKS10/uLP26/TX/intr}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpRXD}                {/testbench/uKS10/uLP26/lpRXD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {lpTXD}                {/testbench/uKS10/uLP26/lpTXD}" \
	"add wave -noupdate -divider {LP20 REG READ/WRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAI}             {/testbench/uKS10/uLP20/devDATAI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {devDATAO}             {/testbench/uKS10/uLP20/devDATAO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {csraREAD}             {/testbench/uKS10/uLP20/csraREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {csraWRITE}            {/testbench/uKS10/uLP20/csraWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {csrbREAD}             {/testbench/uKS10/uLP20/csrbREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {csrbWRITE}            {/testbench/uKS10/uLP20/csrbWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {barREAD}              {/testbench/uKS10/uLP20/barREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {barWRITE}             {/testbench/uKS10/uLP20/barWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {bctrREAD}             {/testbench/uKS10/uLP20/bctrREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {bctrWRITE}            {/testbench/uKS10/uLP20/bctrWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pctrREAD}             {/testbench/uKS10/uLP20/pctrREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pctrWRITE}            {/testbench/uKS10/uLP20/pctrWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ramdREAD}             {/testbench/uKS10/uLP20/ramdREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {ramdWRITE}            {/testbench/uKS10/uLP20/ramdWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cctrREAD}             {/testbench/uKS10/uLP20/cctrREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cctrWRITE}            {/testbench/uKS10/uLP20/cctrWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cbufREAD}             {/testbench/uKS10/uLP20/cbufREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cbufWRITE}            {/testbench/uKS10/uLP20/cbufWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cksmREAD}             {/testbench/uKS10/uLP20/cksmREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cksmWRITE}            {/testbench/uKS10/uLP20/cksmWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pdatREAD}             {/testbench/uKS10/uLP20/pdatREAD}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pdatWRITE}            {/testbench/uKS10/uLP20/pdatWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {vectREAD}             {/testbench/uKS10/uLP20/vectREAD}"

WAVE_PAGER :=\
	"add wave -noupdate -divider {PAGER}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {clk}                  {/testbench/uKS10/uCPU/uPAGER/clk}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {clken}                {/testbench/uKS10/uCPU/uPAGER/clken}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {cpuADDRO}             {/testbench/uKS10/uCPU/cpuADDRO}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {vmaEN}                {/testbench/uKS10/uCPU/uPAGER/vmaEN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {crom}                 {/testbench/uKS10/uCPU/uPAGER/crom}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {drom}                 {/testbench/uKS10/uCPU/uPAGER/drom}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {specPAGEWRITE}        {/testbench/uKS10/uCPU/uPAGER/specPAGEWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {specPAGESWEEP}        {/testbench/uKS10/uCPU/uPAGER/specPAGESWEEP}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pageWRITE}            {/testbench/uKS10/uCPU/uPAGER/pageWRITE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pageSWEEP}            {/testbench/uKS10/uCPU/uPAGER/pageSWEEP}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {writeEN}              {/testbench/uKS10/uCPU/writeEN}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pageFAIL}             {/testbench/uKS10/uCPU/pageFAIL}" \
	"add wave -noupdate -divider {}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pageVALID}            {/testbench/uKS10/uCPU/uPAGER/pageVALID}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pageWRITEABLE}        {/testbench/uKS10/uCPU/uPAGER/pageWRITEABLE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pageCACHEABLE}        {/testbench/uKS10/uCPU/uPAGER/pageCACHEABLE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pageADDRI}            {/testbench/uKS10/uCPU/uPAGER/pageADDRI}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {writeSel}             {/testbench/uKS10/uCPU/uPAGER/writeSel}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {writeAddr}            {/testbench/uKS10/uCPU/uPAGER/writeAddr}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {vma}                  {/testbench/uKS10/uCPU/uPAGER/vma}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pageTABLE}            {/testbench/uKS10/uCPU/uPAGER/pageTABLE}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pageFLAGS}            {/testbench/uKS10/uCPU/uPAGER/pageFLAGS}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {pageADDR}             {/testbench/uKS10/uCPU/uPAGER/pageADDR}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {physAddr}             {/testbench/uKS10/uCPU/uPAGER/physAddr}"

WAVE_FIRST := \
	"onerror {resume}" \
	"quietly WaveActivateNextPane {} 0 " \
	"view wave" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {memRST}               {/testbench/memRST}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {memCLK}               {/testbench/memCLK}" \
	"add wave -noupdate -radix octal    -radixshowbase 0 -label {haltLED}              {/testbench/haltLED}"

WAVE_LAST := \
       "run 10 us"

VLOG_ARGS := \
	-work $(QUESTA_DIR)/work \
	-lint \
	+incdir+ks10 \
	+incdir+ks10/uba \
	+incdir+ks10/cpu \
	+incdir+ks10/cpu/useq \
	+incdir+ks10/debug \
	+incdir+ks10/dup11 \
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
	$(addprefix +define+, $(SIM_ARGS)) \
	$(addprefix +define+, $(SYN_ARGS))

WAVE_LIST := \
	$(WAVE_FIRST) \
	$(WAVE_CPU_INTF) \
	$(WAVE_CPU) \
	$(WAVE_UBA1) \
	$(WAVE_LAST)

#	$(WAVE_LP20) \
#	$(WAVE_CSL) \
#	$(WAVE_DZ11) \
#	$(WAVE_MEM) \
#	$(WAVE_INTF) \
#	$(WAVE_ARB) \
#	$(WAVE_KS10) \
#	$(WAVE_UBA3) \
#	$(WAVE_DUP11) \
#	$(WAVE_DZ11) \
#	$(WAVE_KMC11) \
#	$(WAVE_RH11) \
#	$(WAVE_SD) \

$(QUESTA_DIR)/wave.do: makefile
	@echo "Creating "$@ > /dev/stderr
	@echo "" > $@
	@for CMD in $(WAVE_LIST); \
	do \
	    echo $$CMD >> $@; \
	done

vsim:   $(SIM_FILES) $(RTL_FILES) $(INC_FILES) $(DAT_FILES) $(SIM_DISK) $(TESTBENCH)/ssram.dat $(DISKS) makefile $(QUESTA_DIR)/wave.do
	test -d $(QUESTA_DIR)/work || $(VLIB) $(QUESTA_DIR)/work
	$(VMAP) work $(QUESTA_DIR)/work
	$(VLOG) $(SIM_FILES) $(RTL_FILES) $(VLOG_ARGS)
	$(VSIM) -i testbench -do $(QUESTA_DIR)/wave.do

questa: $(SIM_FILES) $(RTL_FILES) $(INC_FILES) $(DAT_FILES) $(SIM_DISK) $(TESTBENCH)/ssram.dat $(DISKS) makefile $(QUESTA_DIR)/wave.do
	$(VLIB) $(QUESTA_DIR)/work
	$(VMAP) work $(QUESTA_DIR)/work
	$(VLOG) $(SIM_FILES) $(RTL_FILES) $(VLOG_ARGS)
	$(VOPT) testbench +acc=npr3+CPU+UBA+DEBUG+DZ11+UART_TX+UART_RX -o testbench_opt -debugdb
	$(VSIM) -i -debugdb testbench_opt &

#	$(VOPT) testbench +acc=npr3+CPU+UBA+DEBUG+RH11+RPXX -o testbench_opt -debugdb
#	$(VOPT) testbench +acc=npr3+CPU+UBA+DEBUG+KMC11 -o testbench_opt -debugdb
#	$(VOPT) testbench +acc=npr3+CPU+UBA+DEBUG+DUP11+USRT_TX+USRT_RX+CRC16 -o testbench_opt -debugdb
#	$(VOPT) testbench +acc=npr3+CPU+UBA+DEBUG+LP20+LP26 -o testbench_opt -debugdb


#
# iverilog
#

iverilog : $(SIM_FILES) $(RTL_FILES) $(INC_FILES) $(DAT_FILES) $(SIM_DISK) $(TESTBENCH)/ssram.dat $(DISKS) makefile
	$(IVERILOG) -W all -g2012 -s testbench -o $(IVERILOG_DIR)/sim.vvp \
	$(addprefix -D , $(SIM_ARGS)) \
	$(addprefix -D , $(SYN_ARGS)) \
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
	-I ks10/csl \
	-I ks10/debug \
	-I ks10/dup11 \
	-I ks10/dz11 \
	-I ks10/kmc11 \
	-I ks10/lp20 \
	-I ks10/lp26 \
	-I ks10/mem \
	-I ks10/rh11 \
	-I ks10/rh11/rpxx \
	-I ks10/rh11/sd \
	-I ks10/uba \
	-I ks10/utils \
	-I ks10/utils/uart \
	-I ks10/utils/usrt \
	-I testbench \
	$(SIM_FILES) $(RTL_FILES)
	$(VVP) -n $(IVERILOG_DIR)/sim.vvp | tee $(IVERILOG_DIR)/sim.log

#
# Make a list of the RTL Files
#

$(QUARTUS_DIR)/files.qsf : makefile
	@echo "Creating "$@ > /dev/stderr
	@echo "#" > $@
	@echo "# This file is created by the Makefile." >> $@
	@echo "# Do not edit." >> $@
	@echo "#" >> $@
	@echo 'set_global_assignment -name VERILOG_FILE ./$(PROJECT).v' >> $@;
	@for FILE in $(RTL_FILES); \
	do \
	    echo 'set_global_assignment -name VERILOG_FILE ../../'$$FILE >> $@; \
	done

#
# Create project file
#

PRJ_ARGS:= \
	'set_global_assignment -name FAMILY $(FAMILY)' \
	'set_global_assignment -name DEVICE $(DEVICE)' \
	'set_global_assignment -name TOP_LEVEL_ENTITY $(RTLTOP)' \
	'set_global_assignment -name LAST_QUARTUS_VERSION "18.1.0 Lite Edition"' \
	'set_global_assignment -name PROJECT_CREATION_TIME_DATE "17:14:54 MARCH 04,2015"' \
	'set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files' \
	'set_global_assignment -name NUM_PARALLEL_PROCESSORS 16' \
	'set_global_assignment -name PARTITION_NETLIST_TYPE SOURCE -section_id Top' \
	'set_global_assignment -name PARTITION_FITTER_PRESERVATION_LEVEL PLACEMENT_AND_ROUTING -section_id Top' \
	'set_global_assignment -name PARTITION_COLOR 16764057 -section_id Top' \
	'set_global_assignment -name MIN_CORE_JUNCTION_TEMP "-40"' \
	'set_global_assignment -name MAX_CORE_JUNCTION_TEMP 100' \
	'set_global_assignment -name POWER_PRESET_COOLING_SOLUTION "23 MM HEAT SINK WITH 200 LFPM AIRFLOW"' \
	'set_global_assignment -name POWER_BOARD_THERMAL_MODEL "NONE (CONSERVATIVE)"' \
	'set_global_assignment -name OPTIMIZE_MULTI_CORNER_TIMING ON' \
	'set_global_assignment -name ECO_REGENERATE_REPORT ON' \
	'set_global_assignment -name VERILOG_SHOW_LMF_MAPPING_MESSAGES OFF' \
	'set_global_assignment -name SDC_FILE $(PROJECT).sdc' \
	'set_global_assignment -name QIP_FILE soc_system/synthesis/soc_system.qip' \
	'set_global_assignment -name SOURCE_FILE db/$(PROJECT).cmp.rdb' \
	'set_global_assignment -name VERILOG_INPUT_VERSION SYSTEMVERILOG_2005' \
	'set_instance_assignment -name PARTITION_HIERARCHY root_partition -to | -section_id Top ' \
	'source ./files.qsf' \
	'source ./constraints.qsf'

$(QUARTUS_DIR)/$(PROJECT).qsf : makefile
	@echo "Creating "$@ > /dev/stderr
	@echo "#" > $@
	@echo "# This file is created by the Makefile." >> $@
	@echo "# Do not edit." >> $@
	@echo "#" >> $@
	@for ARG in $(PRJ_ARGS); \
	do \
	    echo $$ARG >> $@; \
	done

#
# Quartus build
#

quartus : $(QUARTUS_DIR)/output_files/$(PROJECT).sta.rpt

#
# Quartus FPGA program
#

PGM_ARGS := \
	--mode=jtag \
	--operation=p\;$(QUARTUS_DIR)/output_files/$(PROJECT).sof"@2" \
	--quiet

pgm: $(QUARTUS_DIR)/output_files/$(PROJECT).sof
	quartus_pgm $(PGM_ARGS)
	jtagconfig

pgm1:
	quartus_pgm $(PGM_ARGS)
	jtagconfig

#
# Quartus Static Timing Analyzer
#
# usage: quartus_sta [options] <project name>
#
# quartus_sta options:
#
#   --rev = <value>			: specify revision
#   --read_settings_files = <on|off>	: Read setting from qsf file
#   --write_settings_files = <on|off>	: Write setting to qsf file
#

STA_ARGS := \
	--rev=$(PROJECT)

$(QUARTUS_DIR)/output_files/$(PROJECT).sta.rpt : $(QUARTUS_DIR)/output_files/$(PROJECT).asm.rpt
	quartus_sta $(STA_ARGS) $(QUARTUS_DIR)/$(PROJECT)

#
# Quartus Assembler.  This generates a programming image in SRAM Object File (.sof) format
#
# usage: quartus_asm [options] <project name>
#
# quartus_asm options:
#
#   --rev = <value>			: specify revision
#   --read_settings_files = <on|off>	: Read setting from qsf file
#   --write_settings_files = <on|off>	: Write setting to qsf file
#

ASM_ARGS := \
	--read_settings_files=off \
	--write_settings_files=off \
	--rev=$(PROJECT)

$(QUARTUS_DIR)/output_files/$(PROJECT).asm.rpt  $(QUARTUS_DIR)/output_files/$(PROJECT).sof : $(QUARTUS_DIR)/output_files/$(PROJECT).fit.rpt
	quartus_asm $(ASM_ARGS) $(QUARTUS_DIR)/$(PROJECT)

#
# Quartus Fitter.  This performs place-and-routes the design.
#
# usage: quartus_fit [options] <project name>
#
# quartus_fit options:
#
#   --rev = <value>			: specify revision
#   --read_settings_files = <on|off>	: Read setting from qsf file
#   --write_settings_files = <on|off>	: Write setting to qsf file
#

FIT_ARGS := \
	--read_settings_files=off \
	--write_settings_files=off \
	--rev=$(PROJECT)

.DELETE_ON_ERROR:
$(QUARTUS_DIR)/output_files/$(PROJECT).fit.rpt : $(QUARTUS_DIR)/output_files/$(PROJECT).map.rpt
	quartus_fit $(FIT_ARGS) $(QUARTUS_DIR)/$(PROJECT)

#
# Quartus Mapper.  This analyzes and synthesizes the design.
#
# usage: quartus_map [options] <project name>
#
# quartus_map options:
#
#   --rev = <value>			: specify revision
#   --read_settings_files = <on|off>	: Read setting from qsf file
#   --write_settings_files = <on|off>	: Write setting to qsf file
#   --source = <file>			: Read source file
#

MAP_ARGS := \
	--read_settings_files=on \
	--write_settings_files=off \
	--rev=$(PROJECT) \
	--verilog_macro=QUARTUS \
	--verilog_macro=SYNTHESIS \
	$(addprefix --verilog_macro=, $(SYN_ARGS)) \

MAP_FILES := \
	$(QUARTUS_DIR)/$(PROJECT).v \
	$(QUARTUS_DIR)/$(PROJECT).qsf \
	$(QUARTUS_DIR)/$(PROJECT).srf \
	$(QUARTUS_DIR)/files.qsf \
	$(QUARTUS_DIR)/constraints.qsf \
	$(QUARTUS_DIR)/soc_system/synthesis/soc_system.v \
	$(QUARTUS_DIR)/soc_system/synthesis/soc_system.qip

.DELETE_ON_ERROR:
$(QUARTUS_DIR)/output_files/$(PROJECT).map.rpt : $(MAP_FILES) $(RTL_FILES) $(DAT_FILES)
	quartus_map $(MAP_ARGS) $(QUARTUS_DIR)/$(PROJECT)

#
# QSYS (aka Plaform Designer) Command Line Arguments
#
# usage: qsys-generate [options] <qsys file>
#
# qsys-generate options:
#
#   --family = <value>			: Specify familiy name
#   --part = <part>			: Specify part number
#   --synthesis = <VERILOG|VHDL>  	: Specify HDL language
#   --output-directory = <dir>    	: Specify output directory.
#

QSYS_ARGS := \
	--family=$(FAMILY) \
	--part=$(DEVICE) \
	--output-directory=$(QUARTUS_DIR)/soc_system \
	--synthesis=VERILOG

QSYS_FILES := \
	$(QUARTUS_DIR)/soc_system.qsys \
	$(QUARTUS_DIR)/soc_system.tcl \
	$(QUARTUS_DIR)/soc_system_hw.tcl \
	$(QUARTUS_DIR)/$(PROJECT).qpf \
	$(QUARTUS_DIR)/$(PROJECT).sdc \
	$(QUARTUS_DIR)/$(PROJECT).tcl \
	$(QUARTUS_DIR)/$(PROJECT).v \
	$(QUARTUS_DIR)/ks10_hw.tcl

$(QUARTUS_DIR)/soc_system/synthesis/soc_system.v $(QUARTUS_DIR)/soc_system/synthesis/soc_system.qip : $(QSYS_FILES)
	qsys-generate $(QSYS_ARGS) $(QUARTUS_DIR)/soc_system.qsys

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

clean: clean_rtl clean_questa clean_iverilog
	rm -f cty_out.txt \
	      lprout.txt \
	      rhstatus.txt \
	      lpstatus.txt \
              kmcstatus.txt \

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
# Cleanup after modelsim
#

clean_vsim: clean_questa

clean_questa:
	rm -rf $(QUESTA_DIR)/work
	rm -f  $(QUESTA_DIR)/esm_ks10.cr.mti \
	       $(QUESTA_DIR)/esm_ks10.mpf \
	       $(QUESTA_DIR)/wave.do \
	       transcript \
               testchench \
               vsim.wlf \
               cty_out.txt \
               lpr_out.txt \
               dupstatus.txt \
               dzstatus.txt \
               kmcstatus.txt \
               lpstatus.txt \
               rhstatus.txt \
               cty_out.txt \


#
# Cleanup after iverilog
#

clean_iverilog:
	rm -f $(IVERILOG_DIR)/sim.vvp \
	      $(IVERILOG_DIR)/sim.log

#
# Cleanup after quartus
#

clean_quartus:
	rm -rf $(QUARTUS_DIR)/.qsys_edit
	rm -rf $(QUARTUS_DIR)/db
	rm -rf $(QUARTUS_DIR)/incremental_db
	rm -rf $(QUARTUS_DIR)/output_files
	rm -rf $(QUARTUS_DIR)/soc_system
	rm -rf $(QUARTUS_DIR)/stamp
	rm -rf $(QUARTUS_DIR)/hps_isw_handoff
	rm -f  $(QUARTUS_DIR)/soc_system.sopcinfo \
               $(QUARTUS_DIR)/hps_isw_handoff \
               $(QUARTUS_DIR)/hps_sdram_p0_summary.csv \
               $(QUARTUS_DIR)/c5_pin_model_dump.txt \
               $(QUARTUS_DIR)/$(PROJECT).qws \
               $(QUARTUS_DIR)/$(PROJECT).*.rpt \
               $(QUARTUS_DIR)/$(PROJECT).map.summary \
               $(QUARTUS_DIR)/files.qsf \
               $(QUARTUS_DIR)/$(PROJECT).qsf \
               ks10/cpu/useq/crom.dat \
               ks10/cpu/useq/drom.dat \

#
# rcsclean everything
#

rcsclean: rcsclean_rtl rcsclean_ise

#
# rcsclean Quartus
#

rcsclean_quartus: clean_quartus
	rcsclean $(QUARTUS_DIR)/*

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
	-rcsclean ks10/dup11/*
	-rcsclean ks10/dz11/*
	-rcsclean ks10/lp20/*
	-rcsclean ks10/lp26/*
	-rcsclean ks10/mem/*
	-rcsclean ks10/rh11/*
	-rcsclean ks10/rh11/sd/*
	-rcsclean ks10/rh11/rpxx/*
	-rcsclean ks10/uba/*
	-rcsclean ks10/utils/*
	-rcsclean ks10/utils/uart/*
	-rcsclean ks10/utils/usrt/*
	-rcsclean ks10/xilinx/*
	-find . -type f | grep -v RCS | grep -v archive | grep \\.v$$

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
	@-find ks10 testbench -type f | grep -v RCS | grep -e '\.v$$' -e '\.vh$$' -e '\.sv$$' -e '\.svh$$' | xargs grep -P '\t'
	@echo "Trailing white space in:"
	@-find ks10 testbench -type f | grep -v RCS | grep -e '\.v$$' -e '\.vh$$' -e '\.sv$$' -e '\.svh$$' | xargs grep -P '[ ]+$$'
	@echo "FIXMEs in:"
	@-find ks10 testbench -type f | grep -v RCS | grep -e '\.v$$' -e '\.vh$$' -e '\.sv$$' -e '\.svh$$' | xargs grep -i 'fixme'
