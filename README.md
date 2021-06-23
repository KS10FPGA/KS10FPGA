# KS10FPGA
The Digital Equipment Corporation (DEC) KS10 was a low cost implementation of
the popular PDP-10 mainframe computer. I’ve always wanted my own PDP-10 and now
I’ve decided to build my own.   How hard could that be?

The goal of this project is to re-implement the DEC KS10 using modern components
and technology. This project retains microcode compatibility with the original
DEC KS10 in order to maximize the probability that this design will behave
exactly like the original DEC KS10 implementation.

The Console Processor and the entire KS10 Central Processing Unit (CPU) is
implemented in a single Intel Cyclone 5 System on a Chip (SoC) Field
Programmable Gate Array (FPGA).  In addtion to the FPGA, this SoC includes
a dual core ARM processor which provides the platform for the Console Processor
and provides capabilities for modern networking. The FPGA is firmware is written in
Verilog and currently consists of about 33,000 lines of code plus comments.

The KS10 FPGA peripherals are significantly different than the legacy DEC KS10
peripherals. Modern peripherals like Secure Digital High-Capacity (SDHC)
solid-state disk drives replace the Moving Head RP06 disk drives and TU45
9-track magtape drives. Even though the physical devices are different, the
original hardware interfaces have been retained. The disk drives use the same
bits-on-disk formatting as the SIMH simulator so that files and disk images may
be moved between SIMH and the target hardware without modification. Universal
Serial Bus (USB) and Ethernet devices are provided in addition to standard
legacy RS-232 devices.

I have selected the 
<a href="https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&No=1046">Terasic DE10-Nano Kit</a>
as the basic platform for the system.  To that I've added a custom Daughter Board
which provides SSRAM-based main memory, 8x USB RS-232 ports, SD Card, and
front panel interface. The DE10-Nano Kit is readily available on Amazon, Digikey
and Mouser.

<p>The following peripheral devices have been implemented:</p>
<ul>
  <li>1024 KW Memory</li>
  <li>RH11 Massbus Controller</li>
  <li>RP06 Disk Drives (x8)</li>
  <li>DZ11 Terminal Multiplexer</li>
  <li>LP20 Printer Interface</li>
  <li>LP26 Printer with Direct Access Vertical Format Unit</li>
  <li>DUP11 Synchronous Serial Interface</li>
  <li>KMC11 General Purpose Processor (in work)</li>
</ul>

Detailed design information can be found on the wiki pages at:
<a href="https://github.com/KS10FPGA/KS10FPGA/wiki">https://github.com/KS10FPGA/KS10FPGA/wiki</a>

<p>Rob Doyle</p>
<p>email: doyle at cox dot net</p>
