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
// Copyright (C) 2012-2014 Rob Doyle
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
`include "ubasr.vh"
`include "../ks10.vh"
`include "../cpu/bus.vh"

module UBA(rst, clk,
           // KS10 Bus Interface
           busREQI, busREQO, busACKI, busACKO, busADDRI, busADDRO, busDATAI, busDATAO, busINTR,
           // Device Interface
           devREQO, devADDRO, devDATAO, devINTA, devRESET,
           // Device #1 Interface
           dev1REQI, dev1ACKI, dev1ADDRI, dev1DATAI, dev1INTR, dev1ACKO,
           // Device #2 Interface
           dev2REQI, dev2ACKI, dev2ADDRI, dev2DATAI, dev2INTR, dev2ACKO);

   input          rst;                          // Reset
   input          clk;                          // Clock
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

   wire        setNXD;
   wire        setTMO;
   wire        pageFAIL;
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

   assign devRESET = statINI;

   //
   // Maintenance Register
   //
   //  The maintenance register is write only.
   //

   wire regUBAMR;

   UBAMR MR (
      .rst        (rst),
      .clk        (clk),
      .busDATAI   (busDATAI),
      .maintWRITE (maintWRITE),
      .regUBAMR   (regUBAMR)
   );

   //
   // Maintenance Loopback
   //

   wire loopREQO;
   wire [0:35] loopADDRO;
   wire [0:35] loopDATAO;
   wire [0: 3] pageFLAGS;

   UBALOOP LOOP (
      .rst        (rst),
      .clk        (clk),
      .busADDRI   (busADDRI),
      .busADDRO   (busADDRO),
      .busDATAI   (busDATAI),
      .busACKI    (busACKI),
      .pageFLAGS  (pageFLAGS),
      .loopREAD   (loopREAD),
      .loopWRITE  (loopWRITE),
      .loopREQO   (loopREQO),
      .loopADDRO  (loopADDRO),
      .loopDATAO  (loopDATAO)
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
      .devACK     (dev1ACKI | dev2ACKI),
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
      .dev1INTR   (dev1INTR),
      .dev2INTR   (dev2INTR),
      .devINTA    (devINTA)
   );

   //
   // KS10 to Device Buffer
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
   // Device to KS10
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
          endcase
     end

   wire        devREQI  = dev1REQI | dev2REQI;
   wire [0:35] devADDRI = (arbState == arbDEV1) ? dev1ADDRI : dev2ADDRI;
   wire [0:35] devDATAI = (arbState == arbDEV1) ? dev1DATAI : dev2DATAI;

   //
   // Loopback Mux
   //


   assign      busREQO   = regUBAMR ? loopREQO  : devREQI;
   wire [0:35] pageADDRI = regUBAMR ? loopADDRO : devADDRI;

   //
   // IO Bus Paging
   //

   wire [0:35] pageDATAO;

   UBAPAGE PAGE (
      .rst          (rst),
      .clk          (clk),
      .busREQO      (busREQO),
      .busADDRI     (busADDRI),
      .busDATAI     (busDATAI),
      .busADDRO     (busADDRO),
      .pageWRITE    (pageWRITE),
      .pageDATAO    (pageDATAO),
      .pageADDRI    (pageADDRI),
      .pageFLAGS    (pageFLAGS),
      .pageFAIL     (pageFAIL)
   );

   //
   // KS10 Bus Data Multiplexer
   //

   reg [0:35] busDATAO;

   always @*
     begin
        busDATAO = 36'b0;
        if (pageREAD)
          busDATAO = pageDATAO;
        if (statREAD)
          busDATAO = regUBASR;
        if (devREAD | vectREAD)
          if (dev1ACKI)
            busDATAO = dev1DATAI;
          else if (dev2ACKI)
            busDATAO = dev2DATAI;
        if (wruREAD)
          busDATAO = wruRESP;
        if (busREQO & busACKI)
          if (regUBAMR)
            busDATAO = loopDATAO;
          else
            busDATAO = devDATAI;
     end

   //
   // FIXME
   //  These assignments are stubbed
   //

   assign dev1ACKO = 0;
   assign dev2ACKO = 0;

   //
   // Whine about NXD and TMO
   //

`ifndef SYNTHESIS

   reg [0:35] addr;

   always @(posedge clk or posedge rst)
     begin
        if (rst)
          addr <= 0;
        else
          begin
             if (busREQI)
               addr <= busADDRI;
             if (devREQI)
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
          end
     end

`endif

endmodule
