////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor
//
// Brief
//   KS10 IO Bus Bridge
//
// Details
//   This device 'bridges' the KS10 FPGA backplane bus to the IO Bus.  On a
//   real KS10, the IO bus was UNIBUS.  The IO Bus in the KS10 FPGA is not
//   UNIBUS.
//
// Notes
//   Important addresses:
//
//   763000-763077 : IO Bridge Paging RAM
//   763100        : IO Bridge Status Register
//   763101        : IO Bridge Maintenace Register
//
// File
//   uba.v
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2016 Rob Doyle
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
`timescale 1ns/1ps

`include "uba.vh"
`include "ubasr.vh"
`include "../ks10.vh"
`include "../cpu/bus.vh"

module UBA (
      input  wire         rst,                  // Reset
      input  wire         clk,                  // Clock
      // KS10 Backplane Bus Interface
      input  wire         busREQI,              // Backplane Bus Request In
      output wire         busREQO,              // Backplane Bus Request Out
      input  wire         busACKI,              // Backplane Bus Acknowledge In
      output wire         busACKO,              // Backplane Bus Acknowledge Out
      input  wire [ 0:35] busADDRI,             // Backplane Bus Address In
      output wire [ 0:35] busADDRO,             // Backplane Bus Address Out
      input  wire [ 0:35] busDATAI,             // Backplane Bus Data In
      output reg  [ 0:35] busDATAO,             // Backplane Bus Data Out
      output wire [ 1: 7] busINTR,              // Backplane Bus Interrupt Request
      // Device Interface
      output wire         devREQO,              // IO Device Request Out
      input  wire         devACKI,              // IO Device Acknowledge In
      input  wire         devREQI,              // IO Device Request In
      output wire         devACKO,              // IO Device Acknowledge Out
      output wire [ 0:35] devADDRO,             // IO Device Address Out
      input  wire [ 0:35] devADDRI,             // IO Device Address In
      output wire [ 0:35] devDATAO,             // IO Device Data Out
      input  wire [ 0:35] devDATAI,             // IO Device Data In
      input  wire [ 7: 4] devINTR,              // IO Device Interrupt Request
      output wire [ 7: 4] devINTA,              // IO Device Interrupt Acknowledge
      output wire         devRESET              // IO Device Reset
   );

   //
   // IO Bridge Configuration
   //

   parameter  [14:17] ubaNUM    = 4'd0;                    // Bridge Device Number
   parameter  [18:35] ubaADDR   = `ubaADDR;                // Base address
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

   wire         busREAD   = `busREAD(busADDRI);  // Read Cycle (IO or Memory)
   wire         busWRITE  = `busWRITE(busADDRI); // Write Cycle (IO or Memory)
   wire         busPHYS   = `busPHYS(busADDRI);  // Physical reference
   wire         busIO     = `busIO(busADDRI);    // IO Cycle
   wire         busWRU    = `busWRU(busADDRI);   // Read interrupting controller number
   wire         busVECT   = `busVECT(busADDRI);  // Read interrupt vector
   wire         busIOBYTE = `busIOBYTE(busADDRI);// IO Bridge Byte IO Operation
   wire [15:17] busPI     = `busPI(busADDRI);    // IO Bridge PI Request
   wire [14:17] busDEV    = `busDEV(busADDRI);   // IO Bridge Device Number
   wire [18:35] busADDR   = `busIOADDR(busADDRI);// IO Address

   //
   // Signals
   //

   wire regUBAMR;                               // Maintenance Mode
   wire setNXD;                                 // Set NXD
   wire setTMO;                                 // Set TMO
   wire pageFAIL;                               // Page fail
   wire loopACKO;                               // Loopback acknowledge

   //
   // Address Decoding
   //

   wire wruREAD    = busREAD  & busIO & busPHYS &  busWRU & !busVECT;
   wire vectREAD   = busREAD  & busIO & busPHYS & !busWRU &  busVECT & (busDEV == ubaNUM);
   wire pageREAD   = busREAD  & busIO & busPHYS & !busWRU & !busVECT & (busDEV == ubaNUM) & (busADDR[18:29] == pageADDR[18:29]);
   wire pageWRITE  = busWRITE & busIO & busPHYS & !busWRU & !busVECT & (busDEV == ubaNUM) & (busADDR[18:29] == pageADDR[18:29]);
   wire statREAD   = busREAD  & busIO & busPHYS & !busWRU & !busVECT & (busDEV == ubaNUM) & (busADDR[18:35] == statADDR[18:35]);
   wire statWRITE  = busWRITE & busIO & busPHYS & !busWRU & !busVECT & (busDEV == ubaNUM) & (busADDR[18:35] == statADDR[18:35]);
   wire maintREAD  = busREAD  & busIO & busPHYS & !busWRU & !busVECT & (busDEV == ubaNUM) & (busADDR[18:35] == maintADDR[18:35]);
   wire maintWRITE = busWRITE & busIO & busPHYS & !busWRU & !busVECT & (busDEV == ubaNUM) & (busADDR[18:35] == maintADDR[18:35]);
   wire ubaREAD    = busREAD  & busIO & busPHYS & !busWRU & !busVECT & (busDEV == ubaNUM) & (busADDR[18:28] == ubaADDR[18:28]);
   wire ubaWRITE   = busWRITE & busIO & busPHYS & !busWRU & !busVECT & (busDEV == ubaNUM) & (busADDR[18:28] == ubaADDR[18:28]);
   wire devREAD    = busREAD  & busIO & busPHYS & !busWRU & !busVECT & (busDEV == ubaNUM) & (busADDR[18:28] != ubaADDR[18:28]) & !regUBAMR;
   wire devWRITE   = busWRITE & busIO & busPHYS & !busWRU & !busVECT & (busDEV == ubaNUM) & (busADDR[18:28] != ubaADDR[18:28]) & !regUBAMR;
   wire loopREAD   = busREAD  & busIO & busPHYS & !busWRU & !busVECT & (busDEV == ubaNUM) & (busADDR[18:28] != ubaADDR[18:28]) &  regUBAMR;
   wire loopWRITE  = busWRITE & busIO & busPHYS & !busWRU & !busVECT & (busDEV == ubaNUM) & (busADDR[18:28] != ubaADDR[18:28]) &  regUBAMR;

   //
   // Status Register
   //
   //  The status register is read/write.
   //

   wire        statINTHI;
   wire        statINTLO;
   wire [0:35] regUBASR;
   wire        statINI = `statINI(regUBASR);
   wire [0: 2] statPIH = `statPIH(regUBASR);
   wire [0: 2] statPIL = `statPIL(regUBASR);

   UBASR SR (
      .rst        (rst),
      .clk        (clk),
      .busDATAI   (busDATAI),
      .statWRITE  (statWRITE),
      .statINTHI  (statINTHI),
      .statINTLO  (statINTLO),
      .setNXD     (setNXD),
      .setTMO     (setTMO | pageFAIL),
      .regUBASR   (regUBASR)
   );

   //
   // Maintenance Register
   //
   //  The maintenance register is write only.
   //

   UBAMR MR (
      .rst        (rst),
      .clk        (clk),
      .busDATAI   (busDATAI),
      .maintWRITE (maintWRITE),
      .regUBAMR   (regUBAMR)
   );

   //
   // NXD Bus Monitor
   //
   //  The Bus Monitor acknowledges bus requests to the UBA and devices on the
   //  IO Bus.  NXD is asserted on an 'un-acked' IO requests to the devices.
   //

   UBANXD NXD (
      .rst        (rst),
      .clk        (clk),
      .busREQI    (busREQI),
      .busACKO    (busACKO),
      .ubaREQ     (ubaREAD  | ubaWRITE | loopREAD | loopWRITE),
      .ubaACK     (ubaREAD  | ubaWRITE | loopREAD | loopWRITE),
      .devREQ     (devREAD  | devWRITE | vectREAD),
      .devACK     (devACKI),
      .wruREQ     (wruREAD),
      .wruACK     (wruREAD & ((busPI == statPIH) | (busPI == statPIL))),
      .setNXD     (setNXD)
   );

   //
   // TMO Bus Monitor
   //
   //  TMO is asserted on an 'un-acked' KS10 bus requests.
   //

   UBATMO TMO (
      .rst        (rst),
      .clk        (clk),
      .busREQO    (busREQO),
      .busACKI    (busACKI),
      .setTMO     (setTMO)
   );

   //
   // Interrupts
   //

   UBAINTR INTR (
      .rst        (rst),
      .clk        (clk),
      .busPI      (busPI),
      .busINTR    (busINTR),
      .wruREAD    (wruREAD),
      .statPIH    (statPIH),
      .statPIL    (statPIL),
      .statINTHI  (statINTHI),
      .statINTLO  (statINTLO),
      .devINTR    (devINTR),
      .devINTA    (devINTA)
   );

   //
   // IO Bus Paging
   //

   wire [0: 3] pageFLAGS;
   wire [0:35] pageDATAO;

   UBAPAGE PAGE (
      .rst        (rst),
      .clk        (clk),
      .regUBAMR   (regUBAMR),
      .busREQO    (busREQO),
      .busADDRI   (busADDRI),
      .busDATAI   (busDATAI),
      .busADDRO   (busADDRO),
      .pageWRITE  (pageWRITE),
      .pageDATAO  (pageDATAO),
      .pageADDRI  (devADDRI),
      .pageFLAGS  (pageFLAGS),
      .pageFAIL   (pageFAIL)
   );

   //
   // KS10 to Device Interface
   //

   assign devREQO  = busREQI;
   assign devACKO  = busACKI;
   assign devDATAO = busDATAI;
   assign devADDRO = busADDRI;
   assign devRESET = statINI;

   //
   // Device to KS10 Interface
   //

   assign busREQO  = devREQI;

   //
   // KS10 Bus Data Multiplexer
   //

   always @*
     begin
        busDATAO = devDATAI;
        if (pageREAD)
          busDATAO = pageDATAO;
        if (statREAD)
          busDATAO = regUBASR;
        if (wruREAD)
          busDATAO = wruRESP;
     end

   //
   // Whine about NXD and TMO
   //

`ifdef SYNTHESIS
`ifdef CHIPSCOPE_UBA

   //
   // ChipScope Pro Integrated Controller (ICON)
   //

   wire [35:0] control0;

   chipscope_uba_icon uICON (
      .CONTROL0   (control0)
   );

   //
   // ChipScope Pro Integrated Logic Analyzer (ILA)
   //

   wire [151:0] TRIG0 = {
       devADDRI,               // dataport[116:151]
       devDATAI,               // dataport[ 80:115]
       busADDRO,                // dataport[ 44: 79]
       busDATAO,                // dataport[  8: 43]
       pageFAIL,                // dataport[      7]
       setTMO,                  // dataport[      6]
       setNXD,                  // dataport[      5]
       busACKO,                 // dataport[      4]
       busACKI,                 // dataport[      3]
       busREQO,                 // dataport[      2]
       busREQI,                 // dataport[      1]
       rst                      // dataport[      0]
   };

   chipscope_uba_ila uILA (
      .CLK        (clk),
      .CONTROL    (control0),
      .TRIG0      (TRIG0)
   );

`endif
`else

   reg [0:35] addr;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          addr <= 0;
        else
          begin
             if (busREQI)
               addr <= busADDRI;
             if (busREQO)
               addr <= devADDRI;
             if (setNXD)
               $display("[%11.3f] UBA%d: Nonexistent device (NXD).  Addr = %012o.",
                        $time/1.0e3, ubaNUM, addr);
             if (setTMO)
               $display("[%11.3f] UBA%d: Nonexistent memory (TMO).  Addr = %012o.",
                        $time/1.0e3, ubaNUM, addr);
             if (pageFAIL)
               $display("[%11.3f] UBA%d: Page Failure (TMO).  Addr = %012o.",
                        $time/1.0e3, ubaNUM, addr);

             if (busACKI)
               begin
                  if (`busREAD(busADDRO))
                    $display("[%11.3f] UBA: Read %012o from address %012o.", $time/1.0e3, busDATAI, busADDRO);
                  else
                    $display("[%11.3f] UBA: Wrote %012o to address %012o.", $time/1.0e3, busDATAO, busADDRO);
               end

          end
     end

`endif

endmodule
