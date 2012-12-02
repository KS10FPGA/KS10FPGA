////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!      KS-10 Unibus Adapter
//!
//! \details
//!      Important addresses:
//!
//!      763000-763077 : UBA paging RAM
//!      763100        : UBA Status Register
//!      763101        : UBA Maintenace Register
//!
//! \todo
//!
//! \file
//!      uba.v
//!
//! \author
//!      Rob Doyle - doyle (at) cox (dot) net
//!
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
//
// Comments are formatted for doxygen
//

`default_nettype none
  
module UBA(clk, rst, clken, 
           ubaDEV, ubaVECT, ubaWRU, ubaINTR, ubaINTA, ubaRESET,
           busREQI, busREQO, busACKI, busACKO,
           busADDRI, busADDRO, busDATAI, busDATAO, busINTR,
           ubaADDRI, pageVALID, forceRPW, fastMODE, enable16
           );
   
   input          clk;          // Clock
   input          rst;          // Reset
   input          clken;        // Clock enable
   input  [ 0: 3] ubaDEV;       // Unibus Device Number
   input  [18:35] ubaVECT;      // Unibus Interrupt Vector
   input  [18:35] ubaWRU;	// Unibus WRU Response
   input  [ 7: 4] ubaINTR;      // Interrupt Request
   output [ 7: 4] ubaINTA;      // Interrupt Acknowledge
   output         ubaRESET;     // Reset Command Output
   input          busREQI;      // Unibus Request In
   output         busREQO;      // Unibus Request Out
   input          busACKI;      // Unibus Acknowledge In
   output         busACKO;      // Unibus Acknowledge Out
   input  [ 0:35] busADDRI;     // Bus Address In
   output [ 0:35] busADDRO;     // Bus Address Out
   input  [ 0:35] busDATAI;     // Unibus Data In
   output [ 0:35] busDATAO;     // Unibus Data Out
   output [ 1: 7] busINTR;      // Unibus Interrupt Request
   input  [17: 0] ubaADDRI;     // Unpaged Unibus Address (little endian)
   output         pageVALID;    // Page Valid
   output         forceRPW;     // Force RPW
   output         fastMODE;     // fastMODE
   output         enable16;     // enable16
   
   //
   // Addresses
   //
   
   parameter [18:29] pageADDR  = 12'o7630;      // Paging RAM Address
   parameter [18:35] statADDR  = 18'o763100;    // Status Register Address
   parameter [18:35] maintADDR = 18'o763101;    // Maintenance Register Address

   //
   // Memory flags
   //
   // Details:
   //  busADDRI[ 0:13] is flags
   //  busADDRI[14:35] is address
   //
   
   wire         busREAD   = busADDRI[ 3];       // 1 = Read Cycle (IO or Memory)
   wire         busWRITE  = busADDRI[ 5];       // 1 = Write Cycle (IO or Memory)
   wire         busIO     = busADDRI[10];       // 1 = IO Cycle, 0 = Memory Cycle1
   wire         busWRU    = busADDRI[11];       // 1 = Read interrupt controller number
   wire         busVECT   = busADDRI[12];       // 1 = Read interrupt vector
   wire         busIOBYTE = busADDRI[13];       // 1 = Unibus Byte IO Operation
   wire         busPI     = busADDRI[15:17];	// Unibus PI Request
   wire [14:17] busDEV    = busADDRI[14:17];    // Unibus Device Number
   wire [18:35] busADDR   = busADDRI[18:35];    // Address

   //
   // Address Decoding
   //

   wire pageREAD   = busIO   & busREAD  & (busDEV == ubaDEV) & (busADDR == pageADDR);
   wire pageWRITE  = busIO   & busWRITE & (busDEV == ubaDEV) & (busADDR == pageADDR);
   wire statWRITE  = busIO   & busWRITE & (busDEV == ubaDEV) & (busADDR == statADDR);
   wire statREAD   = busIO   & busREAD  & (busDEV == ubaDEV) & (busADDR == statADDR);
   wire vectREAD   = busIO   & busREAD  & (busDEV == ubaDEV) & busVECT;
   wire wruREAD    = busWRU  & busREAD;
   
   //
   // Unibus Reset
   //

   wire ubaRESET;
   
   //
   // Inputs from Unibus Devices
   //

   wire setNXM = 1'b0;
   wire setNXD = 1'b0;

   //
   //
   // Trace
   //  UBA3/E8
   //
   
   wire statINTHI = intREQ[7] | intREQ[6];
   wire statINTLO = intREQ[5] | intREQ[4];
   
   //
   // Unibus Interrupt Request
   //

   wire vectREQ = 1'b0;
	
   reg [7:4] intREQ;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          intREQ <= 4'b0;
        else if (vectREQ)
          intREQ <= ubaINTR;
     end

   //
   // Low Priority Interrupt
   //
   // Trace
   //  UBA3/E180
   //
   
   reg [1:7] ubaINTRH;
   always @(statINTHI or statPIH)
     begin
        if (statINTHI)
          case (statPIH)
            0: ubaINTRH <= 7'b0000000;
            1: ubaINTRH <= 7'b1000000;
            2: ubaINTRH <= 7'b0100000;
            3: ubaINTRH <= 7'b0010000;
            4: ubaINTRH <= 7'b0001000;
            5: ubaINTRH <= 7'b0000100;
            6: ubaINTRH <= 7'b0000010;
            7: ubaINTRH <= 7'b0000001;
          endcase
        else
          ubaINTRH <= 7'b0000000;
     end

   //
   // High Priority Interrupt
   //
   // Trace
   //  UBA3/E182
   //
   
   reg [7:4] ubaINTRL;
   always @(statINTLO or statPIL)
     begin
        ubaINTRH <= 7'b0;
        if (statINTLO)
          case (statPIL)
            0: ubaINTRH <= 7'b0000000;
            1: ubaINTRL <= 7'b1000000;
            2: ubaINTRL <= 7'b0100000;
            3: ubaINTRL <= 7'b0010000;
            4: ubaINTRL <= 7'b0001000;
            5: ubaINTRL <= 7'b0000100;
            6: ubaINTRL <= 7'b0000010;
            7: ubaINTRL <= 7'b0000001;
          endcase
        else
          ubaINTRL <= 7'b0000000;
     end

   //
   // Unibus Interrupt Request
   //
   // Trace
   //  UBA3/E179
   //  UBA3/E181
   //
   
   assign busINTR = ubaINTRL | ubaINTRH;

   //
   // Unibus Interrupt Acknowledge
   //
   // Trace
   //  UBA7/E27
   //  UBA7/E39
   //  UBA7/E53
   //  UBA7/E113
   //  UBA7/E184
   //  UBA7/E185
   //

   reg [7:4] ubaINTA;
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          ubaINTA = 4'b0;
        else
          begin
             if (wruREAD & statINTHI & (busPI == statPIH))
               begin
                  if (intREQ[7])
                    ubaINTA = 4'b1000;
                  else if (intREQ[6])
                    ubaINTA = 4'b0100;
                  else
                    ubaINTA = 4'b0000;
               end
             else if (wruREAD & statINTLO & (busPI == statPIL))
               begin
                  if (intREQ[5])
                    ubaINTA = 4'b0010;
                  else if (intREQ[4])
                    ubaINTA = 4'b0001;
                  else
                    ubaINTA = 4'b0000;
               end
             else
               ubaINTA = 4'b0000;
          end
     end
   
   //
   // Unibus Status Register (IO Address 763100)
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
   //     (RH)  |TM|BM|PE|ND|     |HI|LO|PF|  |DX|IN|  PIH   |  PIL   |
   //           +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
   //
   //     Register Definitions
   //
   //           NM  : Time Out            - Set by NXM.  Cleared by
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
   //                                       1 resets all Unibus Devices.
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

   wire [0:35] regSTAT = {18'b0, statNM, 2'b0, statND, 2'b0,
                          statINTHI, statINTLO,
                          2'b0, statDX, 1'b0, statPIH, statPIL};

   assign ubaRESET = statWRITE & busADDRI[29];
   
   //
   // Unibus Maintenance Register (IO Address 763101)
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
   // Unibus Pager
   //
   // Details
   //  Unibus Paging RAM is 763000 - 763077
   //

   wire [ 0:35] pagDATAO;       // Paging RAM to KS10 Data
   wire [16:35] pagADDRO;	// Pager output
   
   UBAPAG uUBAPAG
      (.clk(clk),
       .rst(rst),
       .pagWRITE(pageWRITE),
       .busADDRI(busADDRI),
       .busDATAI(busDATAI),
       .pagDATAO(pagDATAO),
       .ubaADDRI(ubaADDRI),
       .pagADDRO(pagADDRO),
       .pagVALID(pageVALID),
       .forceRPW(forceRPW),
       .enable16(enable16),
       .fastMode(fastMODE)
       );

   //
   // BUS MUX
   //

   reg busACKO;
   reg [0:35] busDATAO;
   always @(pageREAD or pagDATAO or statREAD or regSTAT or vectREAD or ubaVECT or wruREAD)
     begin
        busACKO  = 1'b0;             
        busDATAO = 36'bx;
        if (pageREAD)
          begin
             busACKO  = 1'b1;             
             busDATAO = pagDATAO;
          end
        if (statREAD)
          begin
             busACKO  = 1'b1;             
             busDATAO = regSTAT;
          end
        if (vectREAD)
          begin
             busACKO  = 1'b1;
             busDATAO = {18'b0, ubaVECT};
          end
        if (wruREAD)
          begin
             busACKO  = 1'b1;            
             busDATAO = {18'b0, ubaWRU};
          end
     end
   
endmodule
