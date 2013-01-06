////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   KS10 IO Bus Bridge
//
// Details
//   This device 'bridges' the KS10 FPGA backplane bus to the IO
//   IO Bus.  On a real KS10, the IO bus was UNIBUS.  The IO
//   Bus in the KS10 FPGA is not UNIBUS.
//
// Notes
//      Important addresses:
//
//      763000-763077 : IO Bridge Paging RAM
//      763100        : IO Bridge Status Register
//      763101        : IO Bridge Maintenace Register
//
// File
//      uba.v
//
// Author
//      Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2012 Rob Doyle
//
// This source file may be used and distributed without
// restriction provided that this copyright statement is not
// removed from the file and that any derivative work contains
// the original copyright notice and the associated disclaimer.
//
// This source file is free software; you can redistribute it
// and/or modify it under the terms of the GNU Lesser General
// Public License as published by the Free Software Foundation;
// version 2.1 of the License.
//
// This source is distributed in the hope that it will be
// useful, but WITHOUT ANY WARRANTY; without even the implied
// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
// PURPOSE. See the GNU Lesser General Public License for more
// details.
//
// You should have received a copy of the GNU Lesser General
// Public License along with this source; if not, download it
// from http://www.gnu.org/licenses/lgpl.txt
//
////////////////////////////////////////////////////////////////////

`default_nettype none
`include "uba.vh"
`include "../ks10.vh"
  
module UBA(clk, rst, clken, ctlNUM,
           // KS10 Bus Interface
           busREQI,  busREQO,  busACKI,  busACKO,
           busADDRI, busADDRO, busDATAI, busDATAO,
           busINTR,
           // Device Interface
           devREQO, devADDRO, devDATAO, devINTA, devRESET,
           // Device #1 Interface
           dev1REQI, dev1ACKI, dev1ADDRI, dev1DATAI, dev1INTR, dev1VECT, dev1ACKO,
           // Device #2 Interface
           dev2REQI, dev2ACKI, dev2ADDRI, dev2DATAI, dev2INTR, dev2VECT, dev2ACKO);
   
   input          clk;          		// Clock
   input          rst;          		// Reset
   input          clken;        		// Clock enable
   input  [ 0: 3] ctlNUM;       		// Bridge Device Number
   // KS10 Backplane Bus Interface
   input          busREQI;      		// Backplane Bus Request In
   output         busREQO;      		// Backplane Bus Request Out
   input          busACKI;      		// Backplane Bus Acknowledge In
   output         busACKO;      		// Backplane Bus Acknowledge Out
   input  [ 0:35] busADDRI;     		// Backplane Bus Address In
   output [ 0:35] busADDRO;     		// Backplane Bus Address Out
   input  [ 0:35] busDATAI;     		// Backplane Bus Data In
   output [ 0:35] busDATAO;     		// Backplane Bus Data Out
   output [ 1: 7] busINTR;      		// Backplane Bus Interrupt Request
   // Device Interface
   output         devREQO;      		// IO Device Request Out
   output [ 0:35] devADDRO;     		// IO Device Address Out
   output [ 0:35] devDATAO;     		// IO Device Data Out
   output [ 7: 4] devINTA;      		// IO Device Interrupt Acknowledge
   output         devRESET;     		// IO Device Reset
   // Device #1 Interface
   input          dev1REQI;      		// IO Device #1 Request In
   input          dev1ACKI;      		// IO Device #1 Acknowledge In
   input  [ 0:35] dev1ADDRI;     		// IO Device #1 Address In
   input  [ 0:35] dev1DATAI;     		// IO Device #1 Data In
   input  [ 7: 4] dev1INTR;     		// IO Device #1 Interrupt Request
   input  [18:35] dev1VECT;     		// IO Device #1 Interrupt Vector
   output         dev1ACKO;      		// IO Device #1 Acknowledge Out
   // Device #2 Interface
   input          dev2REQI;      		// IO Device #2 Request In
   input          dev2ACKI;      		// IO Device #2 Acknowledge In
   input  [ 0:35] dev2ADDRI;     		// IO Device #2 Address In
   input  [ 0:35] dev2DATAI;     		// IO Device #2 Data In
   input  [ 7: 4] dev2INTR;     		// IO Device #2 Interrupt Request
   input  [18:35] dev2VECT;     		// IO Device #2 Interrupt Vector
   output         dev2ACKO;      		// IO Device #2 Acknowledge Out

   //
   // IO Bridge Configuration
   //
   
   parameter [14:17] ctlNUM0 = `ctlNUM0;	// IO Bridge Device 0
   parameter [14:17] ctlNUM1 = `ctlNUM1;	// IO Bridge Device 1
   parameter [14:17] ctlNUM2 = `ctlNUM2;	// IO Bridge Device 2
   parameter [14:17] ctlNUM3 = `ctlNUM3;	// IO Bridge Device 3
   parameter [18:35] wruNUM0 = `wruNUM0;  	// IO Bridge Device 0 WRU Response (bit 18)
   parameter [18:35] wruNUM1 = `wruNUM1;  	// IO Bridge Device 1 WRU Response (bit 19)
   parameter [18:35] wruNUM2 = `wruNUM2;  	// IO Bridge Device 2 WRU Response (bit 20)
   parameter [18:35] wruNUM3 = `wruNUM3;  	// IO Bridge Device 3 WRU Response (bit 21)
   
   //
   // IO Addresses
   //
   
   parameter [18:35] pageADDR  = 18'o763000;    // Paging RAM Address
   parameter [18:35] statADDR  = 18'o763100;    // Status Register Address
   parameter [18:35] maintADDR = 18'o763101;    // Maintenance Register Address
   parameter [18:26] ctrlADDR  =  9'o763;	// Bridge Registers

   //
   // Address Bus
   //
   // Details:
   //  busADDRI[ 0:13] is flags
   //  busADDRI[14:35] is address
   //
   
   wire         busREAD   = busADDRI[ 3];       // 1 = Read Cycle (IO or Memory)
   wire         busWRITE  = busADDRI[ 5];       // 1 = Write Cycle (IO or Memory)
   wire         busIO     = busADDRI[10];       // 1 = IO Cycle, 0 = Memory Cycle
   wire         busWRU    = busADDRI[11];       // 1 = Read interrupting controller number
   wire         busVECT   = busADDRI[12];       // 1 = Read interrupt vector
   wire         busIOBYTE = busADDRI[13];       // 1 = IO Bridge Byte IO Operation
   wire [15:17] busPI     = busADDRI[15:17];	// IO Bridge PI Request
   wire [14:17] busCTL    = busADDRI[14:17];    // IO Bridge Device Number
   wire [18:35] busADDR   = busADDRI[18:35];    // IO Address

   //
   // Address Decoding
   //

   wire wruREAD    = busWRU & busREAD;
   wire vectREAD   = busIO  & busREAD  & (busCTL == ctlNUM) & busVECT;
   wire pageREAD   = busIO  & busREAD  & (busCTL == ctlNUM) & (busADDR[18:29] == pageADDR[18:29]);
   wire pageWRITE  = busIO  & busWRITE & (busCTL == ctlNUM) & (busADDR[18:29] == pageADDR[18:29]);
   wire statWRITE  = busIO  & busWRITE & (busCTL == ctlNUM) & (busADDR[18:35] == statADDR[18:35]);
   wire statREAD   = busIO  & busREAD  & (busCTL == ctlNUM) & (busADDR[18:35] == statADDR[18:35]);
   wire devREAD    = busIO  & busREAD  & (busCTL == ctlNUM) & (busADDR[18:20] == ctrlADDR[18:20]) & (busADDR[21:26] != ctrlADDR[21:26]);
   
   //
   // IO Bridge Interrupt Request
   //

   wire vectREQ = 1'b1;		// FIXME
	
   reg [7:4] intREQ;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          intREQ <= 4'b0;
        else if (vectREQ)
          intREQ <= dev1INTR | dev2INTR;
     end

   wire statINTHI = intREQ[7] | intREQ[6];
   wire statINTLO = intREQ[5] | intREQ[4];
   
   //
   // High Priority Interrupt
   //
   // Trace
   //  UBA3/E180
   //
   
   reg [1:7] devINTRH;
   always @(statINTHI or statPIH)
     begin
        if (statINTHI)
          case (statPIH)
            0: devINTRH <= 7'b0000000;
            1: devINTRH <= 7'b1000000;
            2: devINTRH <= 7'b0100000;
            3: devINTRH <= 7'b0010000;
            4: devINTRH <= 7'b0001000;
            5: devINTRH <= 7'b0000100;
            6: devINTRH <= 7'b0000010;
            7: devINTRH <= 7'b0000001;
          endcase
        else
          devINTRH <= 7'b0000000;
     end

   //
   // High Priority Interrupt
   //
   // Trace
   //  UBA3/E182
   //
   
   reg [1:7] devINTRL;
   always @(statINTLO or statPIL)
     begin
        if (statINTLO)
          case (statPIL)
            0: devINTRL <= 7'b0000000;
            1: devINTRL <= 7'b1000000;
            2: devINTRL <= 7'b0100000;
            3: devINTRL <= 7'b0010000;
            4: devINTRL <= 7'b0001000;
            5: devINTRL <= 7'b0000100;
            6: devINTRL <= 7'b0000010;
            7: devINTRL <= 7'b0000001;
          endcase
        else
          devINTRL <= 7'b0000000;
     end

   //
   // IO Bridge Interrupt Request
   //
   // Trace
   //  UBA3/E179
   //  UBA3/E181
   //
   
   assign busINTR = devINTRL | devINTRH;

   //
   // IO Bridge Interrupt Acknowledge
   //
   // Trace
   //  UBA7/E27
   //  UBA7/E39
   //  UBA7/E53
   //  UBA7/E113
   //  UBA7/E184
   //  UBA7/E185
   //

   reg [7:4] devINTA;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          devINTA = 4'b0;
        else
          begin
             if (wruREAD & statINTHI & (busPI == statPIH))
               begin
                  if (intREQ[7])
                    devINTA = 4'b1000;
                  else if (intREQ[6])
                    devINTA = 4'b0100;
                  else
                    devINTA = 4'b0000;
               end
             else if (wruREAD & statINTLO & (busPI == statPIL))
               begin
                  if (intREQ[5])
                    devINTA = 4'b0010;
                  else if (intREQ[4])
                    devINTA = 4'b0001;
                  else
                    devINTA = 4'b0000;
               end
             else
               devINTA = 4'b0000;
          end
     end
      
   //
   // NXM and NXD Decoding
   //
   // Details
   //  NXD is asserted on an 'un-acked' IO request to the devices.
   //  NXM is asserted on an 'un-acked' memory request to the devices.
   //

   wire devACKI = dev1ACKI | dev2ACKI;
   wire setNXD  = ((devREQO & busREAD  &  busIO & ~devACKI) |
                   (devREQO & busWRITE &  busIO & ~devACKI));
   wire setNXM  = ((devREQO & busREAD  & ~busIO & ~devACKI) |
                   (devREQO & busWRITE & ~busIO & ~devACKI));
   
   //
   // IO Bridge Status Register (IO Address 763100)
   //
   // Details:
   //    
   //             0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17
   //           +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
   //     (LH)  |                                                     |
   //           +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
   //
   //            18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
   //           +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
   //     (RH)  |NM|BM|PE|ND|     |HI|LO|PF|  |DX|IN|  PIH   |  PIL   |
   //           +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
   //
   //     Register Definitions
   //
   //           NM  : Non-existent Memory - Set by NXM.  Cleared by
   //                                       writing a 1.
   //           BM  : Bad Memory Data     - Always read as 0.  Writes
   //                                       are ignored.
   //           PE  : Bus Parity Error    - Always read as 0.  Writes
   //                                       are ignored.
   //           ND  : Non-existant Device - Set by NXD.  Cleared by
   //                                       writing a 1.
   //           HI  : Hi level intr pend  - IRQ on BR7 or BR6.  Writes
   //                                       are ignored.
   //           LO  : Lo level intr pend  - IRQ on BR5 or BR4.  Writes
   //                                       are ignored.
   //           PF  : Power Fail          - Always read as 0.  Writes
   //                                       are ignored.
   //           DX  : Diable Transfer     - Read/Write.  Does nothing.
   //           IN  : Initialize          - Always read as 0.  Writing
   //                                       1 resets all IO Bridge Devices.
   //           PIH : Hi level PIA        - R/W
   //           PIL : Lo level PIA        - R/W
   //
   
   reg 	     statNM;
   reg 	     statND;
   reg 	     statDX;
   reg [0:2] statPIH;
   reg [0:2] statPIL;
   
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             statNM  <= 1'b0;
             statND  <= 1'b0;
             statDX  <= 1'b0;
             statPIH <= 3'b0;
             statPIL <= 3'b0;
          end
        else if (clken)
          begin
             if (statWRITE)
               begin
                  statNM  <= statNM & ~busDATAI[18];
                  statND  <= statND & ~busDATAI[21];
                  statDX  <= busDATAI[28];
                  statPIH <= busDATAI[30:32];
                  statPIL <= busDATAI[33:35];
               end
             else
               begin
                  statNM <= statNM | setNXM;
                  statND <= statNM | setNXD;
               end
          end
     end

   wire [18:35] regSTAT = {statNM, 2'b0, statND, 2'b0, statINTHI, statINTLO,
                           2'b0, statDX, 1'b0, statPIH, statPIL};

   //
   // IO Bridge Reset Output
   //
   
   assign devRESET = statWRITE & busADDRI[29];

   //
   // IO Bridge Maintenance Register (IO Address 763101)
   //
   // Details
   //  SIMH reads this register as zero always and ignores writes.
   //
   //             0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17
   //           +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
   //     (LH)  |                                                     |
   //           +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
   //
   //            18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
   //           +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
   //     (RH)  |                                                  |CR|
   //           +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
   //
   //
   //           CR  : Change Register     - Always read as 0.  Writes
   //                                       are ignored.
   //


   //
   //
   // IO Bridge Pager.   IO Bridge Paging RAM is 763000 - 763077
   //
   // Details
   //  The page table translates IO Bridge addresses to phyical
   //  addresses.  There are 64 virtual pages which map to 2048
   //  physical pages.
   //
   //  The IO Bridge Paging RAM is 64x15 bits.
   //
   // Note
   //  The implementation is different than the KS10 implementation.
   //  I have chosen to use a Dual Port RAM which allows the KS10 bus
   //  interface to be implemented on one port (Read/Write) and the
   //  IO Bridge Paging to be implemented on the second port (Read-only).
   //
   //  This saves a whole ton of multiplexers and uses some free DPRAM.
   //
   //  The IO Bridge addressing was little endian.  This has all been
   //  converted to big-endian to keep things consistent.
   //
   //            18 19                24 25                33 34 35
   //           +--+--------------------+--------------------+--+--+
   //           | 0| Virtual Page Number|      Word Number   |W | B|
   //           +--+--------------------+--------------------+--+--+
   //                       |6                      |9
   //                       |                       |
   //                      \ /                      |
   //               +-------+-------+               |
   //               |      Page     |               |
   //               |  Translation  |               |
   //               +-------+-------+               |
   //                       |                       |
   //                       |                       |
   //                      \ /11                   \ /9
   //          +------------------------+------------------------+
   //          |  Physical Page Number  |        Word Number     |
   //          +------------------------+------------------------+
   //           16                    26 27                    35
   //     
   //  Paging RAM Write
   //
   //           0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17
   //          +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
   //    (LH)  |                                                     |
   //          +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
   //
   //           18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
   //          +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
   //    (RH)  |FR|ES|FM|VA| 0| 0| 0|             PPN                |
   //          +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
   //
   //  Paging RAM Read
   //
   //           0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17
   //          +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
   //    (LH)  |           | 0|FR|ES|FM|VA|                    | PPN |
   //          +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
   //
   //           18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
   //          +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
   //    (RH)  |        PPN (cont)        |                          |
   //          +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
   //
   //  Paging RAM Internal Format:
   //
   //            0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 
   //          +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
   //          |FR|ES|FM|PV|            PPN                 |
   //          +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
   //
   //  Paging RAM Definitions
   //
   //          FR  : Force Read-Pause-Write (AKA Read Reverse in the
   //                documents).
   //          ES  : Enable 16-bit IO Bridge Transfers.  Disable 18-bit
   //                IO Bridge transfers.
   //          FM  : Fast Transfer Mode.  In this mode, both odd and
   //                even words of IO Bridge data are transferred during
   //                a single KS10 memory operation (i.e., all 36 bits).
   //          PV  : Page valid.  This bit is set to one when the page
   //                data is loaded.
   //          PPN : Physical Page Number.
   //
   
   wire [0: 5] addr = busADDRI[30:35];
   reg  [0:14] pageRAM[0:63];

   always @(negedge clk)
     begin
        if (pageWRITE)
          pageRAM[addr] <= {busDATAI[18:21], busDATAI[25:35]};
     end

   //
   // KS10 readback of Paging RAM
   //

   wire [0:35] pageDATAO = {5'b0, pageRAM[addr][0:3], 7'b0, pageRAM[addr][4:14], 9'b0};

   //
   // IO Bridge Paging
   //

   wire [ 0:35] devADDRI  = ((dev1REQI) ? dev1ADDRI :
                             (dev2REQI) ? dev2ADDRI :
                             36'b0);
   
   wire [ 0: 5] virtPAGE  = devADDRI[19:24];      	// Virtual Page Number
   wire         forceRPW  = pageRAM[virtPAGE][0];
   wire         enable16  = pageRAM[virtPAGE][1];
   wire         fastMode  = pageRAM[virtPAGE][2];
   wire         pageVALID = pageRAM[virtPAGE][3];
   wire [16:26] physPAGE  = pageRAM[virtPAGE][4:14];

   //
   // Bus Initiator Paging
   //
   
   assign busADDRO = {devADDRI[0:13], 2'b0, physPAGE[16:26], devADDRI[27:35]};
   assign busREQO  = dev1REQI | dev2REQI;        

   //
   // Bus Target Paging
   //

   assign devADDRO = busADDRI;
   assign dev1ACKO = 0;		// FIXME
   assign dev2ACKO = 0;		// FIXME
   
   //
   // Bus Data Out
   //

   reg busACKO;
   reg [0:35] busDATAO;
   always @(pageREAD or pageDATAO or
            statREAD or regSTAT   or
            vectREAD or dev1VECT  or
            wruREAD  or wruNUM1   or wruNUM3  or ctlNUM    or statINTHI or statINTLO or busPI or statPIH or statPIL or
            devREAD  or dev1ACKI  or dev2ACKI or dev1DATAI or dev2DATAI)
     begin
        busACKO  = 1'b0;             
        busDATAO = 36'bx;
        if (pageREAD)
          begin
             busACKO  = 1'b1;             
             busDATAO = pageDATAO;
          end
        if (statREAD)
          begin
             busACKO  = 1'b1;             
             busDATAO = {18'b0, regSTAT};
          end
        if (vectREAD)
          begin
             busACKO  = 1'b1;
             busDATAO = {18'b0, dev1VECT};
          end
        if ((wruREAD & statINTHI & (busPI == statPIH)) |
            (wruREAD & statINTLO & (busPI == statPIL)))
          begin
             busACKO  = 1'b1;
             case (ctlNUM)
               ctlNUM0:
                 busDATAO = {18'b0, wruNUM0};
               ctlNUM1:
                 busDATAO = {18'b0, wruNUM1};
               ctlNUM2:
                 busDATAO = {18'b0, wruNUM2};
               ctlNUM3:
                 busDATAO = {18'b0, wruNUM3};
               default:
                 busDATAO = 36'b0;
             endcase
          end
        if (devREAD)
          begin
             busACKO = dev1ACKI | dev2ACKI;
             if (dev1ACKI)
               busDATAO = dev1DATAI;
             else if (dev2ACKI)
               busDATAO = dev2DATAI;
             else
              busDATAO = 36'b0;
           end
     end

   //
   // Device Data Out
   //

   assign devDATAO = busDATAI;
   
endmodule 
