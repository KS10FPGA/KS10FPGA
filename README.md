# KS10FPGA
The Digital Equipment Corporation (DEC) KS10 was a low cost implementation of
the popular PDP-10 mainframe computer. I’ve always wanted my own PDP-10 and now
I’ve decided to build my own.   How hard could that be?

The goal of this project is to re-implement the DEC KS10 using modern components
and technology. This project retains microcode compatibility with the original
DEC KS10 in order to maximize the probability that this design will behave
exactly like the original DEC KS10 implementation.

The entire KS10 Central Processing Unit (CPU) is implemented in a single Field
Programmable Gate Array (FPGA) instead using of boards of discrete logic. The
FPGA is firmware is written in Verilog and currently consists of about 33,000
lines of code plus comments. Similarly, the Console Processor is implemented in
a single-chip ARM Cortex M3 microcontroller whereas the DEC KS10 used an Intel
8080 microprocessor and a board full of logic. All of the software is hosted on
top of the SafeRTOS real time operating system (RTOS) which is embedded in the
microcontroller ROM by the manufacturer. The console software is written in a
mixture of C and C++ and is about 20,000 lines of code plus comments (excluding
the lwIP TCP/IP stack and SafeRTOS).

The KS10 FPGA peripherals are significantly different than the legacy DEC KS10
peripherals. Modern peripherals like Secure Digital High-Capacity (SDHC)
solid-state disk drives replace the Moving Head RP06 disk drives and TU45
9-track magtape drives. Even though the physical devices are different, the
original hardware interfaces have been retained. The disk drives use the same
bits-on-disk formatting as the SIMH simulator so that files and disk images may
be moved between SIMH and the target hardware without modification. Universal
Serial Bus (USB) and Ethernet devices are provided in addition to standard
legacy RS-232 devices.

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

More details can be found on the wiki pages at
<a href="https://github.com/KS10FPGA/KS10FPGA/wiki">https://github.com/KS10FPGA/KS10FPGA/wiki</a>
