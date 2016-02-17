Microcode V130 was the last revision of DEC microcode for the KS10.  Because
the DEC KS10 only provided 2K words of microcode memory, DEC shipped 3 variants
of this microcode because a unified version was too large to fit the KS10's
limited amount microcode memory.   These were:

1. KS10.MCR  - KI10 Paging and KL10 Paging.  No UBABLT.  Used for diagnostics.
2. T10KI.MCR - KI10 Paging and UBABLT.  No KL10 Paging.  Used for TOPS10.
3. T10KL.MCR - KL10 Paging and UBABLT.  No KI10 Paging.  Used for TOPS20.

As a design simplification, the KS10 FPGA places all microcode in FPGA-based
ROM.  In order to accomplish that, the KS10 FPGA increased the microcode memory
from 2K words to 4K words and the three microcode variants were re-merged back
into a single version of microcode.

Microcode V130R1 was created for the KS10 FPGA for the reasons described above
and requires 4K microcode memory.  It includes the following changes:

1.  Conditional compiles modified to include KI10 Paging, KL10 Paging, and
    UBABLT on machines with 4K of microcode memory.
2.  The PAGE-FAIL address moved from 3777 to 7777 on machines with 4K of
    microcode memory.  The PAGE-FAIL must be the address with all bits set.
3.  The minor microcode version (UCR) was changed from 0 to 1.

Other than these minor changes, there were no changes to the microcode
functionality.

Rob Doyle

doyle (at) cox (dot) net

15 April 2015
