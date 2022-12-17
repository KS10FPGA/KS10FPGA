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

PROJECT         := de10_ks10

#
# FPGA partnumber
#

FAMILY          := "Cyclone V"
DEVICE          := 5CSEBA6U23I7

#
# What system?
#

UNAME           := $(shell uname -o)

#
# Project structure
#

MAINDEC         := ../maindec
TOOL_DIR        := ../tools
TAPE_DIR        := ../Tape\ and\ Disk\ Images
TMP_DIR         := tmp
TESTBENCH       := testbench
QUESTA_DIR      := de10_top/questa
IVERILOG_DIR    := de10_top/iverilog
MODELSIM_DIR    := de10_top/modelsim
QUARTUS_DIR     := de10_top/quartus

#
# $(QUARTUS_ROOTDIR) is an environment variable that is created when Quartus
# is installed for both the windows and linux environments.
#
# For the Cygwin build environment, $(QUARTUS_ROOTDIR) must be modified from a
# windows-like path to a unix-like path using cygwin 'cygpath'.
#
# For the Linux build environment, $(QUARTUS_ROOTDIR) is already correct.
#

ifeq ($(UNAME), Cygwin)
QUARTUS_ROOTDIR := $(shell cygpath -u $(QUARTUS_ROOTDIR))/bin64
endif

#
# Quartus executables
#

QSYS-GENERATE   := $(QUARTUS_ROOTDIR)/../sopc_builder/bin/qsys-generate
QUARTUS_MAP     := $(QUARTUS_ROOTDIR)/quartus_map
QUARTUS_FIT     := $(QUARTUS_ROOTDIR)/quartus_fit
QUARTUS_ASM     := $(QUARTUS_ROOTDIR)/quartus_asm
QUARTUS_STA     := $(QUARTUS_ROOTDIR)/quartus_sta
QUARTUS_PGM     := $(QUARTUS_ROOTDIR)/quartus_pgm
QUARTUS_CPF     := $(QUARTUS_ROOTDIR)/quartus_cpf
JTAGCONFIG      := $(QUARTUS_ROOTDIR)/jtagconfig

#
# ModelSim executables
#

MODELSIM        := $(QUARTUS_ROOTDIR)/../../modelsim_ase/win32aloem
MSIM_VLIB       := $(MODELSIM)/vlib
MSIM_VMAP       := $(MODELSIM)/vmap
MSIM_VLOG       := $(MODELSIM)/vlog
MSIM_VOPT       := $(MODELSIM)/vopt
MSIM_VSIM       := $(MODELSIM)/vsim

#
# QuestaSim executables
#

QUESTASIM       := $(QUARTUS_ROOTDIR)/../../questa_fse/win64/
QSIM_VLIB       := $(QUESTASIM)/vlib
QSIM_VMAP       := $(QUESTASIM)/vmap
QSIM_VLOG       := $(QUESTASIM)/vlog
QSIM_VOPT       := $(QUESTASIM)/vopt
QSIM_VSIM       := $(QUESTASIM)/vsim

#
# Tools
#

ASM10           := $(TOOL_DIR)/asm10/asm10
MERGE18         := $(TOOL_DIR)/merge/merge18.awk
MERGE36         := $(TOOL_DIR)/merge/merge36.awk
SAV2VERILOG     := $(TOOL_DIR)/sav2verilog/sav2verilog
T10BACKUP       := $(TOOL_DIR)/tapeutils/t10backup

#
# Tapes
#

DIAG_DIR        := $(TAPE_DIR)/KS10\ Diagnostics
MICROCODE_DIR   := $(TAPE_DIR)/KS10\ Microcode
REDPACK_DIR     := $(TAPE_DIR)/RED\ PACK\ 405A2
TOPS10_DIR      := $(TAPE_DIR)/TOPS10

DIAG_TAPE       := $(DIAG_DIR)/ks_diag_gs.tap
REDPACK_TAPE    := $(REDPACK_DIR)/red405a2.tap.bz2
REDPACK_DISK    := $(REDPACK_DIR)/red405a2.rp06.gz
TOPS10_TAPE     := $(TOPS10_DIR)/tops10-1.4.tar.bz2
MICROCODE_TAPE  := $(MICROCODE_DIR)/CRAM4K_Microcode.tap.gz

#
# Other tools
#

IVERILOG        := iverilog
VVP             := vvp
CLOC            := cloc-1.62.exe
OPENOCD         := /usr/local/openocd/bin/openocd

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

ifeq ($(UNAME), Cygwin)
  .SHELLFLAGS = -o pipefail -ec
endif

#
# Synthesis Macro Definitions
#
# These definitions affect both the synthesis and the simulator.
#
# Macro Definitions
#   SERIALNUM           * Set the CPU serial number (decimal).  The default SERIALNUM is 4097.
#   MAJOR_VER=\"XX\"    * Set firmware version major revision (XX must be two ASCII digits)
#   MINOR_VER=\"YY\"    * Set firmware version minor revision (YY must be two ASCII digits)
#   CLKFRQ=12500000     * See clock freqency of CPU Clock (must match clock input)
#   SSRAMx18           ** Use 18-bit wide external SSRAM
#   SSRAMx36           ** Use 36-bit wide external SSRAM
#   SSRAM_BLKRAM       ** Use 36-bit wide internal Block RAM.
#   RPXX_SIMSEEK          Simulate RPXX seek accurately but slowly
#   RPXX_SIMSEARCH        Simulate RPXX search accurately bus slowly
#   RPXX_SIMDMD           Simulate RPXX diagnostic mode
#   DUP11_FASTCLK         Run the synchronous serial clock at 100 KHz instead of 10 KHz
#   PAGE_FAIL_TEST        Stress test PAGE FAIL logic
#
# * MUST BE SET
# ** SELECT one SSRAM option

KS10_SYN := \
	SERIALNUM=2020 \
	MAJOR_VER=\"00\" \
	MINOR_VER=\"38\" \
        CLKFRQ=12500000 \
	SSRAMx18 \
	RPXX_SIMSEEK \
	RPXX_SIMDMD

#
# Simulator Macro Definitions
#
# These are definitions for the simulator only. They do not affect synthesis.
#
#   DIAG                        * From command line. Something like "make DIAG=DSKAA vsim"
#   DIAG_XXXXXX                   Parsed from $(DIAG)
#   ENABLE_TIMER                  Enable 1 ms timer. Slows simulation. (See testbench)
#   SIM_SMMON                     Boot to SMMON instead of diagnostic app (See testbench)
#   SIM_CTY                       Simulate the CTY (See testbench)
#   SIM_LPR                       Simulate LPR
#   SIM_SDHC                      Simulate the SDHC Card
#   SIM_SDHC_OFFLINE              Simulate the SDHC as offline
#   STOP_ON_COMPLETE              Stop simulation when test is complete (See debug.v)
#   STOP_ON_STUCK_PC              Stop simulating when PC gets stuck.
#   STARTADDR=18\'oxxxxxx         Set start address
#                                 STARTADDR=18\'o020000 (Boot to SMMON)
#                                 STARTADDR=18\'o030001 (Boot to Diagnostics)
#				  If not set, STARTADDR will default to 18\'o020000
#   valBRAR0=36\'oxxxxxx_xxxxxx   Set BRAR0 breakpoint register
#   valBRMR0=36\'oxxxxxx_xxxxxx   Set BRMR0 breakpoint register
#   valBRAR1=36\'oxxxxxx_xxxxxx   Set BRAR1 breakpoint register
#   valBRMR1=36\'oxxxxxx_xxxxxx   Set BRMR1 breakpoint register
#   valBRAR2=36\'oxxxxxx_xxxxxx   Set BRAR2 breakpoint register
#   valBRMR2=36\'oxxxxxx_xxxxxx   Set BRMR2 breakpoint register
#   valBRAR3=36\'oxxxxxx_xxxxxx   Set BRAR3 breakpoint register
#   valBRMR3=36\'oxxxxxx_xxxxxx   Set BRMR3 breakpoint register
#
# * MUST BE SET
#

STARTDIAG := 18\'o030001
STARTBOOT := 18\'o020000

KS10_SIM := \
	DIAG=\"$(DIAG)\" \
	DIAG_$(DIAG) \
	SIM_LPR \
	SIM_SDHC \
	ENABLE_TIMER \
	STOP_ON_STUCK_PC \
	STARTADDR=$(STARTDIAG)

#
# Devices that will be synthesized or simulated in the design
#
# The simulated and synthesized devices can be different because we can exceed
# the maximum number of lines of code that the VSIM simulator will support. We
# generally synthesize everything and simulate just what we're interested in
# simulating.
#
#   UBA1                        Include UBA1
#   UBA3                        Include UBA3
#   UBA4                        Include UBA4
#   RH11A                       Include a RH11 with a Disk Controller attached to UBA1
#   RH11B                       Include a RH11 with a Tape Controller attached to UBA3
#   DZ11                        Include a DZ11 Terminal Multiplexer Interface attached to UBA3
#   KMC11                       Include a KMC11 Microprocessor attached to UBA3
#   DUP11                       Include a DUP11 Synchronous Interface attached to UBA3
#   LP20                        Include a LP20/LP26 Printer Interface attached to UBA3
#   UBE1                        Include UBE1 Unibus Exerciser attached to UBA4
#   UBE2                        Include UBE2 Unibus Exerciser attached to UBA4
#   UBE3                        Include UBE3 Unibus Exerciser attached to UBA4
#   UBE4                        Include UBE4 Unibus Exerciser attached to UBA4
#   UBE5                        Include UBE5 Unibus Exerciser attached to UBA4
#

#
# Synthesized devices
#

KS10_SYNDEVS := \
	UBA1 \
	RH11A \
	UBA3 \
	RH11B \
	LP20 \
	DZ11 \
	DUP11 \
	KMC11 \
	UBA4 \
	UBE1 \
	UBE2 \
	UBE3 \
	UBE4

#
# Simulated devices
#

KS10_SIMDEVS := \
	UBA1 \
	RH11A \
	UBA3 \
	RH11B \
#	LP20 \
	DZ11 \
	DUP11 \
	KMC11 \
	UBA4 \
	UBE1 \
	UBE2 \
	UBE3 \
	UBE4

#
# Verilog source files
#

RTL_FILES := \
	ks10/ks10bus.sv \
	ks10/unibus.sv \
	ks10/massbus.sv \
        ks10/mtcslbus.sv \
        ks10/rpcslbus.sv \
	ks10/brcslbus.sv \
        ks10/trcslbus.sv \
	ks10/ks10.sv \
	ks10/arb/arb.sv \
	ks10/breakpoint/breakpoint.sv \
	ks10/csl/csl.sv \
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
	ks10/dup11/dup11.sv \
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
	ks10/lp20/lp20.sv \
	ks10/lp26/lp26.v \
	ks10/mem/mem.sv \
	ks10/mem/memstat.sv \
	ks10/rh11/rh11.sv \
	ks10/rh11/rhintr.v \
	ks10/rh11/rhnem.v \
	ks10/rh11/rhba.v \
	ks10/rh11/rhdb.v \
	ks10/rh11/rhwc.v \
	ks10/rh11/rhcs1.v \
	ks10/rh11/rhcs2.v \
	ks10/rpxx/rpaddr.v \
	ks10/rpxx/rpctrl.v \
	ks10/rpxx/rpda.v \
	ks10/rpxx/rpdc.v \
	ks10/rpxx/rpds.v \
	ks10/rpxx/rper1.v \
	ks10/rpxx/rper2.v \
	ks10/rpxx/rper3.v \
	ks10/rpxx/rphcrc.v \
	ks10/rpxx/rpla.v \
	ks10/rpxx/rpmr.v \
	ks10/rpxx/rpof.v \
	ks10/rpxx/rpxx.v \
	ks10/rpxx/rp.sv \
	ks10/rpxx/sd/sd.v \
	ks10/rpxx/sd/sdspi.v \
	ks10/mt/mt.sv \
        ks10/mt/mtfc.sv \
        ks10/mt/mtds.sv \
        ks10/mt/mter.sv \
        ks10/mt/mtmr.sv \
        ks10/mt/mttc.sv \
        ks10/mt/mtctrl.sv \
	ks10/trace/trace.sv \
	ks10/uba/uba.sv \
	ks10/uba/ubamr.sv \
	ks10/uba/ubasr.sv \
	ks10/uba/ubapage.sv \
	ks10/uba/ubaintr.sv \
	ks10/ube/ube.sv \
	ks10/ube/ubedb.sv \
	ks10/ube/ubecc.sv \
	ks10/ube/ubeba.sv \
	ks10/ube/ubecsr1.sv \
	ks10/ube/ubecsr2.sv \
	ks10/utils/crc16.v \
	ks10/utils/fifo.v \
	ks10/utils/lifo.sv \
	ks10/utils/edgetrig.v \
	ks10/utils/usrt/usrt_rx.v \
	ks10/utils/usrt/usrt_tx.v \
	ks10/utils/uart/uart_brg.v \
	ks10/utils/uart/uart_rx.v \
	ks10/utils/uart/uart_tx.v

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
	ks10/csl/dupccr.vh \
	ks10/csl/dzccr.vh \
	ks10/csl/lpccr.vh \
	ks10/csl/mtccr.vh \
	ks10/csl/rpccr.vh \
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
	ks10/mt/mt.vh \
	ks10/mt/mtcs1.vh \
	ks10/mt/mtfc.vh \
	ks10/mt/mtds.vh \
	ks10/mt/mter.vh \
	ks10/mt/mtas.vh \
	ks10/mt/mttc.vh \
	ks10/rh11/rhba.vh \
	ks10/rh11/rhdb.vh \
	ks10/rh11/rhds.vh \
	ks10/rh11/rhwc.vh \
	ks10/rh11/rhcs1.vh \
	ks10/rh11/rhcs2.vh \
	ks10/rh11/rh11.vh \
	ks10/rpxx/rpas.vh \
	ks10/rpxx/rpcs1.vh \
	ks10/rpxx/rpda.vh \
	ks10/rpxx/rpcc.vh \
	ks10/rpxx/rpdc.vh \
	ks10/rpxx/rpds.vh \
	ks10/rpxx/rper1.vh \
	ks10/rpxx/rper2.vh \
	ks10/rpxx/rper3.vh \
	ks10/rpxx/rphcrc.vh \
	ks10/rpxx/rpof.vh \
	ks10/rpxx/rpla.vh \
	ks10/rpxx/rpmr.vh \
	ks10/rpxx/rpxx.vh \
	ks10/rpxx/sd/sdspi.vh \
	ks10/rpxx/sd/sd.vh \
	ks10/uba/uba.vh \
	ks10/uba/ubamr.vh \
	ks10/uba/ubasr.vh \
	ks10/uba/ubabus.vh \
	ks10/uba/ubapage.vh \
	ks10/ube/ube.vh \
	ks10/ube/ubedb.vh \
	ks10/ube/ubecc.vh \
	ks10/ube/ubeba.vh \
	ks10/ube/ubecsr1.vh \
	ks10/ube/ubecsr2.vh \
	ks10/utils/ascii.vh \
	ks10/utils/crc16.vh \
	ks10/utils/uart/uart.vh

#
# Disk drives
#

UNIT0_DSK := \
	$(TESTBENCH)/unit0.dsk

UNIT1_DSK := \
	$(TESTBENCH)/unit1.dsk

UNIT2_DSK := \
	$(TESTBENCH)/unit2.dsk

UNIT3_DSK := \
	$(TESTBENCH)/unit3.dsk

UNIT4_DSK := \
	$(TESTBENCH)/unit4.dsk

UNIT5_DSK := \
	$(TESTBENCH)/unit5.dsk

UNIT6_DSK := \
	$(TESTBENCH)/unit6.dsk

UNIT7_DSK := \
	$(TESTBENCH)/unit7.dsk

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
# Default Build Rule
#

build : quartus

#
# Get microcode from tape
#

MICROCODE_FILE := $(MICROCODE_DIR)/cram4k.mcr

$(MICROCODE_FILE) : $(MICROCODE_TAPE)
	make -C $(MICROCODE_DIR) cram4k.mcr

#
# DROM Microcode Initialization
#

DROM_DAT := \
	ks10/cpu/useq/drom.dat

#
# Create the "Dispatch ROM" microcode for microsequencer
#

$(DROM_DAT) : ks10/cpu/useq/drom.awk $(MICROCODE_FILE) makefile
	awk -f ks10/cpu/useq/drom.awk $(MICROCODE_FILE) > $(DROM_DAT)

#
# CROM Microcode Initialization
#

CROM_DAT := \
	ks10/cpu/useq/crom.dat

#
# Create the "Control ROM" microcode for microsequencer
#  Read the CPU Serial Number (SERIALNUM) from the KS10_SYN variable.
#  If SERIALNUM is not set, use a default.
#  crom.awk will read the microcode from the microcode listing file, and edit
#  the microcode in order to insert CPU Serial Number into the microcode.
#

ifneq (, $(findstring SERIALNUM=, $(KS10_SYN)))
   SERIALNUM := $(shell echo $(KS10_SYN) | sed -E s/.*SERIALNUM=\([0-9]*\).*/\\1/)
else
   SERIALNUM := 4097
endif

$(CROM_DAT) : ks10/cpu/useq/crom.awk $(MICROCODE_FILE) makefile
	awk -v SERIALNUM=$(SERIALNUM) -f ks10/cpu/useq/crom.awk $(MICROCODE_FILE) > $(CROM_DAT)

#
# Simulation testbench files
#

SIM_FILES := \
	$(TESTBENCH)/testbench.sv \
	$(TESTBENCH)/dumpregs.sv \
	$(TESTBENCH)/mtsim.sv \
	$(TESTBENCH)/sdsim.sv \

#
# Simulate the right kind of memory
#

ifneq (, $(findstring SSRAMx18, $(KS10_SYN)))
    SIM_FILES += $(TESTBENCH)/cy7c1463kv33.sv
else
    ifneq (, $(findstring SSRAMx36, $(KS10_SYN)))
        SIM_FILES += $(TESTBENCH)/cy7c1460av33.sv
    endif
endif

#
# Convert the $(DIAG) name to lower case.
#

DIAG_LWR = $(shell echo $(DIAG) | tr A-Z a-z)

#
# $(DIAG_FILE) is the name of a file that will be used to initialize SSRAM file
# with the contents of the diagnostic progam. This is much faster than
# simulating the whole KS10 while it reads the diagnostic program from disk.
#
# The $(DIAG_FILE) is in a format that can be parsed by the verilog system task
# $readmemh(). The SSRAM simulator uses that system task to initialize the
# contents of the SSRAM.
#
# The filename looks something like "tmp/dstua.dat"
#

ifdef DIAG
    DIAG_FILE := $(TMP_DIR)/$(DIAG_LWR).dat
endif

#
# Initialize the SSRAM or BLKRAM with Diagnostic (simulation only)
# Create the initialization file (ssram.dat) with the proper tool.
#
# The KS10 FPGA supports both 36-bit wide memory (BLKRAM and 36-bit
# SSRAM) as well as 18-bit burst-read SSRAM. The SSRAM initialization
# is different betwwen 18-bit and 36-bit memory.
#

include diag.mak
include wave.mak

ifneq (, $(findstring SSRAMx18, $(KS10_SYN)))
    $(TESTBENCH)/ssram.dat : $(DIAG_FILE)
	cp $(DIAG_FILE) $(TESTBENCH)/ssram.dat
else
    $(TESTBENCH)/ssram.dat : $(DIAG_FILE)
	cp $(DIAG_FILE) $(TESTBENCH)/ssram.dat
endif

#
# The testbench needs the diagnostic tape
#

$(TESTBENCH)/ks_diag_gs.tap : $(DIAG_TAPE).gz
	zcat $ > $@

#
# The testbench needs the RED TAPE
#

$(TESTBENCH)/red405a2.tap : $(REDPACK_TAPE)
	bzcat $< > $@

#
# The testbench needs RED PACK
#

$(TESTBENCH)/red405a2.rp06 : $(REDPACK_DISK)
	zcat $(REDPACK_DISK) > $@

#
# The testbench needs TOPS-10 DSKB
#

$(TESTBENCH)/dskb.rp06 : $(TOPS10_TAPE)
	tar -jxvf $(TOPS10_TAPE) dskb.dsk -O > $@

#
# The testbench needs TOPS-10 DSKC
#

$(TESTBENCH)/dskc.rp06 : $(TOPS10_TAPE)
	tar -jxvf $(TOPS10_TAPE) dskb.dsk -O > $@

#
# VSIM/QUESTA Simulation
#

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
	$(addprefix +define+, $(KS10_SYN)) \
	$(addprefix +define+, $(KS10_SIM)) \
	$(addprefix +define+, $(KS10_SIMDEVS)) \

#
# Create $(QUESTA_DIR) if it doesn't exist
#

$(QUESTA_DIR) :
	mkdir -p $(QUESTA_DIR) :

#
# This is specially hacked because wave.do needs to be rebuilt when you change
# the DIAG string.  Just rebuilt it always.
#

.PHONY : $(QUESTA_DIR)/wave.do
$(QUESTA_DIR)/wave.do : $(QUESTA_DIR)
	@echo "Creating "$@ > /dev/stderr
	@echo "" > $@
	@for CMD in $(WAVE_LIST); \
	do \
	    echo $$CMD >> $@; \
	done

vsim :  $(SIM_FILES) $(RTL_FILES) $(INC_FILES) $(CROM_DAT) $(DROM_DAT) $(SIM_DISK) $(TESTBENCH)/ssram.dat  $(TESTBENCH)/red405a2.tap $(DISKS) makefile $(QUESTA_DIR)/wave.do chkram diag.mak
	test -d $(QUESTA_DIR)/work || $(MSIM_VLIB) $(QUESTA_DIR)/work
	$(MSIM_VMAP) work $(QUESTA_DIR)/work
	$(MSIM_VLOG) $(SIM_FILES) $(RTL_FILES) $(VLOG_ARGS)
	$(MSIM_VSIM) -i testbench -do $(QUESTA_DIR)/wave.do

questa : $(SIM_FILES) $(RTL_FILES) $(INC_FILES) $(CROM_DAT) $(DROM_DAT) $(SIM_DISK) $(TESTBENCH)/ssram.dat  $(TESTBENCH)/red405a2.tap $(DISKS) makefile $(QUESTA_DIR)/wave.do chkram diag.mak
	test -d $(QUESTA_DIR)/work || $(QSIM_VLIB) $(QUESTA_DIR)/work
	$(QSIM_VMAP) work $(QUESTA_DIR)/work
	$(QSIM_VLOG) $(SIM_FILES) $(RTL_FILES) $(VLOG_ARGS)
	$(QSIM_VOPT) testbench +acc=npr3+CPU+BRKPT+TRACE -o testbench_opt -debugdb
	$(QSIM_VSIM) -i -debugdb testbench_opt -do $(QUESTA_DIR)/wave.do

#	$(QSIM_VOPT) testbench +acc=npr3+CPU+UBA+DEBUG+RH11+RPXX -o testbench_opt -debugdb
#	$(QSIM_VOPT) testbench +acc=npr3+CPU+UBA+DEBUG+KMC11 -o testbench_opt -debugdb
#	$(QSIM_VOPT) testbench +acc=npr3+CPU+UBA+DEBUG+DUP11+USRT_TX+USRT_RX+CRC16 -o testbench_opt -debugdb
#	$(QSIM_VOPT) testbench +acc=npr3+CPU+UBA+DEBUG+LP20+LP26 -o testbench_opt -debugdb

#
# iverilog
#

iverilog : $(SIM_FILES) $(RTL_FILES) $(INC_FILES) $(CROM_DAT) $(DROM_DAT) $(SIM_DISK) $(TESTBENCH)/ssram.dat $(DISKS) makefile chkram
	$(IVERILOG) -W all -g2012 -s testbench -o $(IVERILOG_DIR)/sim.vvp \
	$(addprefix -D , $(KS10_SIM)) \
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

PRJ_ARGS := \
	'set_global_assignment -name FAMILY $(FAMILY)' \
	'set_global_assignment -name DEVICE $(DEVICE)' \
	'set_global_assignment -name TOP_LEVEL_ENTITY $(PROJECT)' \
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

pgm : $(QUARTUS_DIR)/output_files/$(PROJECT).sof
	$(QUARTUS_PGM) $(PGM_ARGS)

pgm1 :
	$(QUARTUS_PGM) $(PGM_ARGS)

$(PROJECT).rbf : $(QUARTUS_DIR)/output_files/$(PROJECT).sof
	$(QUARTUS_CPF) -c -o bitstream_compression=on $(QUARTUS_DIR)/output_files/$(PROJECT).sof $(PROJECT).rbf

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
	$(QUARTUS_STA) $(STA_ARGS) $(QUARTUS_DIR)/$(PROJECT)

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
	$(QUARTUS_ASM) $(ASM_ARGS) $(QUARTUS_DIR)/$(PROJECT)

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

.DELETE_ON_ERROR :
$(QUARTUS_DIR)/output_files/$(PROJECT).fit.rpt : $(QUARTUS_DIR)/output_files/$(PROJECT).map.rpt
	$(QUARTUS_FIT) $(FIT_ARGS) $(QUARTUS_DIR)/$(PROJECT)

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
	$(addprefix --verilog_macro=, $(KS10_SYN)) \
	$(addprefix --verilog_macro=, $(KS10_SYNDEVS)) \

MAP_FILES := \
	$(QUARTUS_DIR)/$(PROJECT).v \
	$(QUARTUS_DIR)/$(PROJECT).qsf \
	$(QUARTUS_DIR)/$(PROJECT).srf \
	$(QUARTUS_DIR)/files.qsf \
	$(QUARTUS_DIR)/constraints.qsf \
	$(QUARTUS_DIR)/soc_system/synthesis/soc_system.v \
	$(QUARTUS_DIR)/soc_system/synthesis/soc_system.qip

.DELETE_ON_ERROR:
$(QUARTUS_DIR)/output_files/$(PROJECT).map.rpt : $(MAP_FILES) $(RTL_FILES) $(CROM_DAT) $(DROM_DAT) chkram
	$(QUARTUS_MAP) $(MAP_ARGS) $(QUARTUS_DIR)/$(PROJECT)

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
	$(QSYS-GENERATE) $(QSYS_ARGS) $(QUARTUS_DIR)/soc_system.qsys

#
# Disk Drives for mtsim.sv
#

$(UNIT0_DSK) : $(TESTBENCH)/dskb.rp06
	cp $< $@

$(UNIT1_DSK) : $(TESTBENCH)/dskc.rp06
	cp $< $@

$(UNIT2_DSK) : $(TESTBENCH)/red405a2.rp06
	cp $< $@

$(UNIT3_DSK) : $(TESTBENCH)/dskb.rp06
	cp $< $@

$(UNIT4_DSK) : $(TESTBENCH)/dskb.rp06
	cp $< $@

$(UNIT5_DSK) : $(TESTBENCH)/dskb.rp06
	cp $< $@

$(UNIT6_DSK) : $(TESTBENCH)/dskb.rp06
	cp $< $@

$(UNIT7_DSK) : $(TESTBENCH)/dskb.rp06
	cp $< $@

#
# Verify some kind of RAM is configured.
#

chkram :
    ifeq (, $(findstring SSRAMx18, $(KS10_SYN)))
        ifeq (, $(findstring SSRAMx36, $(KS10_SYN)))
            ifeq (, $(findstring SSRAM_BLKRAM, $(KS10_SYN)))
		$(error KS10: The Memory Subsystem MUST be defined. Set KS10_SYN+=SSRAMx18, KS10_SYN+=SSRAMx36, or KS10_SYN+=SSRAM_BLKRAM)
            endif
        endif
    endif

#
# Clean everything
#

clean : clean_rtl clean_questa clean_iverilog

#
# Clean RTL
#

clean_rtl :
	rm -f ks10/cpu/useq/crom.dat
	rm -f ks10/cpu/useq/drom.dat
	rm -f $(TESTBENCH)/*.dat
	rm -f $(TESTBENCH)/unit?.dsk
	rm -f $(TESTBENCH)/red405a2.tap
	rm -f $(TESTBENCH)/red405a2.rp06
	find . -type f -name "*~" | xargs rm -fv

#
# Cleanup after modelsim
#

clean_vsim : clean_questa

clean_questa :
	rm -rf tmp
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

clean_iverilog :
	rm -f $(IVERILOG_DIR)/sim.vvp \
	      $(IVERILOG_DIR)/sim.log

#
# Cleanup after quartus
#

clean_quartus :
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

rcsclean : rcsclean_rtl rcsclean_ise

#
# rcsclean Quartus
#

rcsclean_quartus : clean_quartus
	rcsclean $(QUARTUS_DIR)/*

#
# rcsclean RTL
#

rcsclean_rtl : clean_rtl
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

archive_all :
	tar --exclude=testsuite_*/* -czvf ks10_fpga_all_`date '+%y%m%d'`.tgz *

archive_dist : $(SRC)
	make rcsfetch
	tar  --exclude-vcs -czvf ks10_fpga_dist_`date '+%y%m%d'`.tgz *

#
# Count Lines of Code
#

cloc :
	$(CLOC) --by-file --force-lang=Verilog-SystemVerilog,vh,sv,svh \
                --exclude-ext=html,xml,json,c,tcl,pad \
                --exclude-dir=soc_system,hps_isw_handoff \
                ks10 de10_top

#
# Check files for tabs, whitespace, and FIXMEs.
#

check :
	@echo "Tabs in:"
	@-find ks10 testbench -type f | grep -v RCS | grep -e '\.v$$' -e '\.vh$$' -e '\.sv$$' -e '\.svh$$' | xargs grep -P '\t'
	@echo "Trailing white space in:"
	@-find ks10 testbench -type f | grep -v RCS | grep -e '\.v$$' -e '\.vh$$' -e '\.sv$$' -e '\.svh$$' | xargs grep -P '[ ]+$$'
	@echo "FIXMEs in:"
	@-find ks10 testbench -type f | grep -v RCS | grep -e '\.v$$' -e '\.vh$$' -e '\.sv$$' -e '\.svh$$' | xargs grep -i 'fixme'

#
# OpenOCD
#

openocd :
	$(OPENOCD) -d -f altera-usb-blaster2.cfg -f chain.cfg -c init -c shutdown

# -f altera_fpgasoc.cfg
# -f altera_my.cfg