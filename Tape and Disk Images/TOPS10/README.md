<!--
Copyright 2022 Rob Doyle
SPDX-License-Identifier: GPL-2.0
-->

# TOPS-10 RP06 System Disks

The TOPS-10 information and disk images are taken from: https://www.steubentech.com/~talon/pdp10/

The directory has a single file:

tops10-1.4.tar.bz2
  - TOPS-10 Compressed System Tape Archive

    Obtained from: https://www.steubentech.com/~talon/pdp10/tops10-1.4.tar.bz2

The tops10-1.4.tar.bz2 compressed tape archive contains several disk images
that are used extensively to test and validate the KS10 FPGA implementation
and are used by the Verilog simulation test bench and is also used to perform
on-target FPGA testing.

The two RP06 disk images that are used are by the KS10 FPGA project are:

  - dskb.rp06

  TOPS-10 System DSKB:

  - dskc.rp06

  TOPS-10 System DSKC:

The "dskb.rp06" and "dskc.rp06" disk images can be extracted from the
compressed tape archive as follows:

<pre>
$ <b>make dskb.rp06 dskc.rp06</b>
</pre>

If you want to extract everything on the tape archive file, do:

<pre>
$ <b>make</b>
</pre>
