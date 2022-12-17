<!--
Copyright 2022 Rob Doyle
SPDX-License-Identifier: GPL-2.0
-->

# RED PACK Disk and Tape Images

The Reliability Exerciser and Diagnostic Pack (RED PACK) is a very useful
diagnostic tool that DEC provided to its Field Service Engineers to help
maintain and repair the KS10.

The diagnostics contained in the RED PACK are used extensively to test
and validate the KS10 FPGA implementation. The diagnostics are used by
the Verilog simulation test bench and are also used to perform on-target
FPGA testing.

This directory has two files:

red405a2.tap.gz
  - SIMH RED PACK tape file

    Obtained from: http://pdp-10.trailing-edge.com/tapes/red405a2.tap.bz2

red405a2.rp06.gz
  - SIMH RED PACK RP06 disk image

    This was created using the procedure in described in:
    https://github.com/KS10FPGA/KS10FPGA/wiki/Creating-the-REDPACK
