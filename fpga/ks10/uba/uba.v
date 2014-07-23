////////////////////////////////////////////////////////////////////////////////
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
//

//
// IO Bridge Status Register:
//
//            0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17
//          +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
//    (LH)  |                                                                       |
//          +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
//
//           18  19  20  21  22  23  24 25 26 27 28 29 30 31 32 33 34 35
//          +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
//    (RH)  |TMO|BMD|BPE|NXD|   |   |HI |LO |PWR|   |DXF|INI|    PIH    |    PIL    |
//          +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
//
//   Register Definitions
//
//      TMO : Non-existent Memory - Set by TMO.  Cleared by writing a 1.
//      BMD : Bad Memory Data     - Always read as 0.  Writes are ignored.
//      BPE : Bus Parity Error    - Always read as 0.  Writes are ignored.
//      NXD : Non-existant Device - Set by NXD.  Cleared by writing a 1.
//      HI  : Hi level intr pend  - IRQ on BR7 or BR6.  Writes are ignored.
//      LO  : Lo level intr pend  - IRQ on BR5 or BR4.  Writes are ignored.
//      PWR : Power Fail          - Always read as 0.  Writes are ignored.
//      DXF : Diable Transfer     - Read/Write.  Does nothing.
//      INI : Initialize          - Always read as 0.  Writing 1 resets all IO Bridge Devices.
//      PIH : Hi level PIA        - R/W
//      PIL : Lo level PIA        - R/W
//
// IO Bridge Maintenance Register:
//
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
//      CR  : Change Register     - Always read as 0.  Writes
//                                  are ignored.
//
// File
//   uba.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2012-2014 Rob Doyle
//
// This source file may be used and distributed without restriction provided
// that this copyright statement is not removed from the file and that any
// derivative work contains the original copyright notice and the associated
// disclaimer.
//
// This source file is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as published by the
// Free Software Foundation; version 2.1 of the License.
//
// This source is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License
// for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with this source; if not, download it from
// http://www.gnu.org/licenses/lgpl.txt
//
////////////////////////////////////////////////////////////////////////////////

`default_nettype none
`include "uba.vh"
`include "../ks10.vh"

module UBA(clk, rst,
           // KS10 Bus Interface
           busREQI, busREQO, busACKI, busACKO, busADDRI, busADDRO, busDATAI, busDATAO, busINTR,
           // Device Interface
           devREQO, devADDRO, devDATAO, devINTA, devRESET,
           // Device #1 Interface
           dev1REQI, dev1ACKI, dev1ADDRI, dev1DATAI, dev1INTR, dev1ACKO,
           // Device #2 Interface
           dev2REQI, dev2ACKI, dev2ADDRI, dev2DATAI, dev2INTR, dev2ACKO);

   input          clk;                          // Clock
   input          rst;                          // Reset
   // KS10 Backplane Bus Interface
   input          busREQI;                      // Backplane Bus Request In
   output         busREQO;                      // Backplane Bus Request Out
   input          busACKI;                      // Backplane Bus Acknowledge In
   output         busACKO;                      // Backplane Bus Acknowledge Out
   input  [ 0:35] busADDRI;                     // Backplane Bus Address In
   output [ 0:35] busADDRO;                     // Backplane Bus Address Out
   input  [ 0:35] busDATAI;                     // Backplane Bus Data In
   output [ 0:35] busDATAO;                     // Backplane Bus Data Out
   output [ 1: 7] busINTR;                      // Backplane Bus Interrupt Request
   // Device Interface
   output         devREQO;                      // IO Device Request Out
   output [ 0:35] devADDRO;                     // IO Device Address Out
   output [ 0:35] devDATAO;                     // IO Device Data Out
   output [ 7: 4] devINTA;                      // IO Device Interrupt Acknowledge
   output         devRESET;                     // IO Device Reset
   // Device #1 Interface
   input          dev1REQI;                     // IO Device #1 Request In
   input          dev1ACKI;                     // IO Device #1 Acknowledge In
   input  [ 0:35] dev1ADDRI;                    // IO Device #1 Address In
   input  [ 0:35] dev1DATAI;                    // IO Device #1 Data In
   input  [ 7: 4] dev1INTR;                     // IO Device #1 Interrupt Request
   output         dev1ACKO;                     // IO Device #1 Acknowledge Out
   // Device #2 Interface
   input          dev2REQI;                     // IO Device #2 Request In
   input          dev2ACKI;                     // IO Device #2 Acknowledge In
   input  [ 0:35] dev2ADDRI;                    // IO Device #2 Address In
   input  [ 0:35] dev2DATAI;                    // IO Device #2 Data In
   input  [ 7: 4] dev2INTR;                     // IO Device #2 Interrupt Request
   output         dev2ACKO;                     // IO Device #2 Acknowledge Out

   //
   // IO Bridge Configuration
   //

   parameter  [14:17] ubaNUM    = `devUBA1;                // Bridge Device Number
   parameter  [18:35] ubaADDR   = 18'o763000;              // Base address
   localparam [18:35] pageADDR  = ubaADDR + `pageOFFSET;   // Paging RAM Address
   localparam [18:35] statADDR  = ubaADDR + `statOFFSET;   // Status Register Address
   localparam [18:35] maintADDR = ubaADDR + `maintOFFSET;  // Maintenance Register Address
   localparam [ 0:35] wruRESP   = `getWRU(ubaNUM);         // Lookup WRU Response

   //
   // Address Bus
   //
   // Details:
   //  busADDRI[ 0:13] is flags
   //  busADDRI[14:35] is address
   //

   wire         busREAD   = busADDRI[ 3];       // 1 = Read Cycle (IO or Memory)
   wire         busWRITE  = busADDRI[ 5];       // 1 = Write Cycle (IO or Memory)
   wire         busPHYS   = busADDRI[ 8];       // 1 = Physical reference
   wire         busIO     = busADDRI[10];       // 1 = IO Cycle, 0 = Memory Cycle
   wire         busWRU    = busADDRI[11];       // 1 = Read interrupting controller number
   wire         busVECT   = busADDRI[12];       // 1 = Read interrupt vector
   wire         busIOBYTE = busADDRI[13];       // 1 = IO Bridge Byte IO Operation
   wire [15:17] busPI     = busADDRI[15:17];    // IO Bridge PI Request
   wire [14:17] busDEV    = busADDRI[14:17];    // IO Bridge Device Number
   wire [18:35] busADDR   = busADDRI[18:35];    // IO Address

   //
   // Address Decoding
   //

   wire wruREAD    = busIO & busWRU   &  busPHYS;
   wire vectREAD   = busIO & busVECT  & (busDEV == ubaNUM);
   wire pageREAD   = busIO & busREAD  & (busDEV == ubaNUM) & (busADDR[18:29] == pageADDR[18:29]);
   wire pageWRITE  = busIO & busWRITE & (busDEV == ubaNUM) & (busADDR[18:29] == pageADDR[18:29]);
   wire statWRITE  = busIO & busWRITE & (busDEV == ubaNUM) & (busADDR[18:35] == statADDR[18:35]);
   wire statREAD   = busIO & busREAD  & (busDEV == ubaNUM) & (busADDR[18:35] == statADDR[18:35]);
   wire maintWRITE = busIO & busWRITE & (busDEV == ubaNUM) & (busADDR[18:35] == maintADDR[18:35]);
   wire maintREAD  = busIO & busREAD  & (busDEV == ubaNUM) & (busADDR[18:35] == maintADDR[18:35]);
   wire devREAD    = busIO & busREAD  & (busDEV == ubaNUM) & (busADDR[18:20] == ubaADDR[18:20]) & (busADDR[21:26] != ubaADDR[21:26]);
   wire devWRITE   = busIO & busWRITE & (busDEV == ubaNUM) & (busADDR[18:20] == ubaADDR[18:20]) & (busADDR[21:26] != ubaADDR[21:26]);

   //
   // IO Bridge Interrupt Request
   //

   wire [7:4] intREQ = dev1INTR  | dev2INTR;
   wire       statINTHI = intREQ[7] | intREQ[6];
   wire       statINTLO = intREQ[5] | intREQ[4];

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
   // Low Priority Interrupt
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
          devINTA = `ubaINTNUL;
        else
          begin
             if (wruREAD & (busPI == statPIH))
               begin
                  if (intREQ[7])
                    devINTA = `ubaINTR7;
                  else if (intREQ[6])
                    devINTA = `ubaINTR6;
                  else
                    devINTA = `ubaINTNUL;
               end
             else if (wruREAD & (busPI == statPIL))
               begin
                  if (intREQ[5])
                    devINTA = `ubaINTR5;
                  else if (intREQ[4])
                    devINTA = `ubaINTR4;
                  else
                    devINTA = `ubaINTNUL;
               end
             else
               devINTA = `ubaINTNUL;
          end
     end

   //
   // Control/Status Register
   //

   reg       statTMO;
   reg       statNXD;
   reg       statDXF;
   reg [0:2] statPIH;
   reg [0:2] statPIL;
   wire      setNXD;
   wire      setTMO;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             statTMO  <= 0;
             statNXD  <= 0;
             statDXF  <= 0;
             statPIH  <= 0;
             statPIL  <= 0;
          end
        else
          begin
             if (statWRITE)
               begin
                  if (busDATAI[`statINI])
                    begin
                       statTMO <= 0;
                       statNXD <= 0;
                       statDXF <= 0;
                       statPIH <= 0;
                       statPIL <= 0;
                    end
                  else
                    begin
                       statTMO <= statTMO & !busDATAI[`statTMO];
                       statNXD <= statNXD & !busDATAI[`statNXD];
                       statDXF <= busDATAI[`statDXF];
                       statPIH <= busDATAI[`statPIH];
                       statPIL <= busDATAI[`statPIL];
                    end
               end
             else
               begin
`ifdef FIXME
                  if (setTMO | setNXD)
                    statTMO <= 1;
                  if (setNXD)
                    statNXD <= 1;
`endif
               end
          end
     end

   wire [0:35] regSTAT = {18'b0, statTMO, 2'b0, statNXD, 2'b0, statINTHI,
                          statINTLO, 2'b0, statDXF, 1'b0, statPIH, statPIL};

   //
   // Device reset
   //

   reg devRESET;
   reg [0:5] count;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             count    <= 0;
             devRESET <= 0;
          end
        else if (statWRITE & busDATAI[`statINI])
          begin
             count    <= 0;
             devRESET <= 1;
          end
        else
          begin
             if (count == 31)
               devRESET <= 0;
             else
               count <= count + 1'b1;
          end
     end;

   //
   // KS10 to device
   //

   reg devREQO;
   reg [0:35] devDATAO;
   reg [0:35] devADDRO;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          begin
             devREQO  <= 0;
             devDATAO <= 0;
             devADDRO <= 0;
          end
        else
          begin
             devREQO  <= busREQI;
             devDATAO <= busDATAI;
             devADDRO <= busADDRI;
          end
     end

   //
   // IO Bus Arbiter
   //

   localparam [0:1] arbIDLE = 0,
                    arbDEV1 = 1,
                    arbDEV2 = 2;

   reg [0:1] arbState;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          arbState <= arbIDLE;
        else
          case (arbState)
            arbIDLE:
              if (dev1REQI)
                arbState <= arbDEV1;
              else if (dev2REQI)
                arbState <= arbDEV2;
            arbDEV1:
              if (!dev1REQI)
                if (dev2REQI)
                  arbState <= arbDEV2;
                else
                  arbState <= arbIDLE;
            arbDEV2:
              if (!dev2REQI)
                if (dev1REQI)
                  arbState <= arbDEV1;
                else
                  arbState <= arbIDLE;
          endcase;
     end;

   wire        devREQI   = dev1REQI | dev2REQI;
   wire        devACKI   = (arbState == arbDEV1 ? dev1ACKI :
                            (arbState == arbDEV2 ? dev2ACKI :
                             36'b0));
   wire [0:35] devADDRI  = (arbState == arbDEV1 ? dev1ADDRI :
                            (arbState == arbDEV2 ? dev2ADDRI :
                             36'b0));

   assign busREQO = devREQI;

   //
   // NXD is asserted on an 'un-acked' IO request to the devices.
   //

   reg        [0:3] nxdCount;
   localparam [0:3] nxdTimeout = 15;
   
   always @(posedge clk or posedge rst)
     begin
        if (rst)
          nxdCount <= 0;
        else
          begin
             if (devREQO & busIO & (busREAD | busWRITE))
               nxdCount <= nxdTimeout;
             else if (nxdCount != 0)
               begin
                  if (devACKI)
                    nxdCount <= 0;
                  else
                    nxdCount <= nxdCount - 1'b1;
               end
          end
     end

   assign setNXD = (nxdCount == 1);

   //
   // TMO is asserted on an 'un-acked' KS10 bus request
   //

   reg        [0:3] tmoCount;
   localparam [0:3] tmoTimeout = 15;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          tmoCount <= 0;
        else
          begin
             if (busREQO)
	       tmoCount <= tmoTimeout;
	     else if (tmoCount != 0)
	       begin
                  if (busACKI)
                    tmoCount <= 0;
                  else
                    tmoCount <= tmoCount - 1'b1;
	       end
	  end
     end
   
   assign setTMO = (tmoCount == 1);

   //
   // IO Bus Paging
   //

   wire        pageNXM;
   wire [0:35] pageDATAO;

   UBAPAG uUBAPAG (
      .clk          (clk),
      .rst          (rst),
      // KS10 Bus Interface
      .busADDRI     (busADDRI),
      .busDATAI     (busDATAI),
      .busADDRO     (busADDRO),
      .pageWRITE    (pageWRITE),
      .pageDATAO    (pageDATAO),
      // Device Interface
      .devREQI      (devREQI),
      .devADDRI     (devADDRI),
      // Status
      .pageNXM      (pageNXM)
   );

   //
   // Bus Data Out
   //

   reg busACKO;
   reg [0:35] busDATAO;

   always @(pageREAD   or pageWRITE or pageDATAO  or
            statREAD   or statWRITE or regSTAT    or
            maintWRITE or maintREAD or
            wruREAD    or ubaNUM    or statINTHI  or statINTLO or busPI    or statPIH   or statPIL   or
            devREAD    or devWRITE  or vectREAD   or dev1ACKI  or dev2ACKI or dev1DATAI or dev2DATAI or arbState)
     begin
        busACKO  = 0;
        busDATAO = 36'b0;
        if (pageREAD)
          begin
             busACKO  = 1;
             busDATAO = pageDATAO;
          end
        if (statREAD)
          begin
             busACKO  = 1;
             busDATAO = regSTAT;
          end
        if ((wruREAD & (busPI == statPIH)) |
	    (wruREAD & (busPI == statPIL)))
          begin
             busACKO  = 1;
             busDATAO = wruRESP;
          end
        if (devREAD | devWRITE | vectREAD)
          begin
             if (dev1ACKI)
               begin
                  busACKO  = 1;
                  busDATAO = dev1DATAI;
               end
             else if (dev2ACKI)
               begin
                  busACKO  = 1;
                  busDATAO = dev2DATAI;
               end
          end
        if (statWRITE | maintWRITE | maintREAD | pageWRITE)
          begin
             busACKO  = 1;
             busDATAO = 36'b0;
          end
     end

endmodule
