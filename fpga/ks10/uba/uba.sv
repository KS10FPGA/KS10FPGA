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
// Copyright (C) 2012-2021 Rob Doyle
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
`include "ubapage.vh"
`include "../cpu/bus.vh"

module UBA (
      input  wire         rst,                          // Reset
      input  wire         clk,                          // Clock
      // KS10 Backplane Bus Interface
      input  wire         busREQI,                      // Backplane Bus Request In
      output reg          busREQO,                      // Backplane Bus Request Out
      input  wire         busACKI,                      // Backplane Bus Acknowledge In
      output wire         busACKO,                      // Backplane Bus Acknowledge Out
      input  wire [ 0:35] busADDRI,                     // Backplane Bus Address In
      output wire [ 0:35] busADDRO,                     // Backplane Bus Address Out
      input  wire [ 0:35] busDATAI,                     // Backplane Bus Data In
      output reg  [ 0:35] busDATAO,                     // Backplane Bus Data Out
      output wire [ 1: 7] busINTR,                      // Backplane Bus Interrupt Request
      // Device Interface
      output wire         devRESET,                     // IO Device Reset
      input  wire         devREQI[1:4],                 // IO Device Request In
      output reg          devREQO[1:4],                 // IO Device Request Out
      input  wire         devACKI[1:4],                 // IO Device Acknowledge In
      output reg          devACKO[1:4],                 // IO Device Acknowledge Out
      input  wire [ 7: 4] devINTR[1:4],                 // IO Device Interrupt Request
      input  wire [ 0:35] devADDRI[1:4],                // IO Device Address In
      output wire [ 0:35] devADDRO[1:4],                // IO Device Address Out
      input  wire [ 0:35] devDATAI[1:4],                // IO Device Data In
      output reg  [ 0:35] devDATAO[1:4]                // IO Device Data Out
   );

   //
   // IO Bridge Configuration
   //

   parameter  [14:17] ubaNUM   = 4'd0;                  // Bridge Device Number
   parameter  [18:35] ubaADDR  = `ubaADDR;              // Base address
   localparam [18:35] pageADDR = ubaADDR + `pageOFFSET; // Paging RAM Address
   localparam [18:35] statADDR = ubaADDR + `statOFFSET; // Status Register Address
   localparam [18:35] maintADDR= ubaADDR + `maintOFFSET;// Maintenance Register Address
   localparam [ 0:35] wruRESP  = `getWRU(ubaNUM);       // Lookup WRU Response

   //
   // KS10 Address Bus
   //
   // Details:
   //  busADDRI[ 0:13] is flags
   //  busADDRI[14:35] is address
   //

   wire         busREAD   = `busREAD(busADDRI);         // Read Cycle (IO or Memory)
   wire         busWRITE  = `busWRITE(busADDRI);        // Write Cycle (IO or Memory)
   wire         busPHYS   = `busPHYS(busADDRI);         // Physical reference
   wire         busIO     = `busIO(busADDRI);           // IO Cycle
   wire         busWRU    = `busWRU(busADDRI);          // Read interrupting controller number
   wire         busVECT   = `busVECT(busADDRI);         // Read interrupt vector
   wire         busIOBYTE = `busIOBYTE(busADDRI);       // IO Byte Cycle
   wire [15:17] busPI     = `busPI(busADDRI);           // IO Bridge PI Request
   wire [14:17] busDEV    = `busDEV(busADDRI);          // IO Bridge Device Number
   wire [18:35] busADDR   = `busIOADDR(busADDRI);       // IO Address

   //
   // Signals
   //

   wire         regUBAMR;                               // Maintenance Mode
   wire         setNXD;                                 // Set NXD
   wire         setTMO;                                 // Set TMO
   wire         pageFAIL;                               // Page failure

   //
   // Device Address Bus
   //

   reg  [ 0:35] mdevADDRI;
   reg  [ 0:35] mdevDATAI;
// wire         devREAD   = `busREAD(mdevADDRI);         // Read Cycle (IO or Memory)
// wire         devWRITE  = `busWRITE(mdevADDRI);        // Write Cycle (IO or Memory)
   wire         devIO     = `busIO(mdevADDRI);           // IO Cycle

   //
   // Device request on any device input
   //

   wire         devREQ = devREQI[1] | devREQI[2] | devREQI[3] | devREQI[4];

   //
   // Paging flags
   //

   wire [ 0: 3] pageFLAGS;                              // Page flags
   wire         flagsRPW = `flagsRPW(pageFLAGS);        // Page read/pause/write
   wire         flagsE16 = `flagsE16(pageFLAGS);        // Page E16
   wire         flagsFTM = `flagsFTM(pageFLAGS);        // Page fast transfer mode
   wire         flagsVLD = `flagsFTM(pageFLAGS);        // Page valid

   //
   // Address Decoding
   //

   wire wruREAD    = busREAD  & busIO & busPHYS &  busWRU & !busVECT;
   wire vectREAD   = busREAD  & busIO & busPHYS & !busWRU &  busVECT & (busDEV == ubaNUM);
   wire pageREAD   = busREAD  & busIO & busPHYS & !busWRU & !busVECT & (busDEV == ubaNUM) & (busADDR[18:29] == pageADDR[18:29]);
   wire pageWRITE  = busWRITE & busIO & busPHYS & !busWRU & !busVECT & (busDEV == ubaNUM) & (busADDR[18:29] == pageADDR[18:29]);
   wire statREAD   = busREAD  & busIO & busPHYS & !busWRU & !busVECT & (busDEV == ubaNUM) & (busADDR[18:35] == statADDR[18:35]);
   wire statWRITE  = busWRITE & busIO & busPHYS & !busWRU & !busVECT & (busDEV == ubaNUM) & (busADDR[18:35] == statADDR[18:35]);
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
   // Device acknowledge selector
   //

   always @*
     begin
        devACKO[1] = 0;
        devACKO[2] = 0;
        devACKO[3] = 0;
        devACKO[4] = 0;
        if (devREQI[1])
          devACKO[1] = busACKI;
        else if (devREQI[2])
          devACKO[2] = busACKI;
        else if (devREQI[3])
          devACKO[3] = busACKI;
        else if (devREQI[4])
          devACKO[4] = busACKI;
     end

   //
   // Device arbiter
   //
   //  The address and data bus is enabled to the KS10 backplane bus arbiter
   //  with the following prorities from highest to lowest:
   //
   //  1.  The device is reponding to a Interrupt Vector request.  In this case,
   //      the CPU asserts both busREQI and busVECT.  This is the highest priority.
   //
   //  2.  The device is the target of either an memory or IO request.  In this
   //      case the initiator asserts busREQI and target, if any, asserts
   //      devACKI[n].
   //
   //  3.  The device is initiating a memory or IO DMA request. In this case, the
   //      device (initiator) asserts devREQI[n].  Memory requests are routed
   //      to the KS10 backplane.  IO requests are routed to other UBA devices.
   //

   always @*
     begin
        mdevADDRI = 0;
        mdevDATAI = 0;

        //
        // INTR 7 vector arbitration (Highest Priority)
        //

        if (busREQI & busVECT & devINTR[1][7])
          begin
             mdevDATAI = devDATAI[1];
             mdevADDRI = devADDRI[1];
          end
        else if (busREQI & busVECT & devINTR[2][7])
          begin
             mdevDATAI = devDATAI[2];
             mdevADDRI = devADDRI[2];
          end
        else if (busREQI & busVECT & devINTR[3][7])
          begin
             mdevDATAI = devDATAI[3];
             mdevADDRI = devADDRI[3];
          end
        else if (busREQI & busVECT & devINTR[4][7])
          begin
             mdevDATAI = devDATAI[4];
             mdevADDRI = devADDRI[4];
          end

        //
        // INTR 6 vector arbitration
        //

        else if (busREQI & busVECT & devINTR[1][6])
          begin
             mdevDATAI = devDATAI[1];
             mdevADDRI = devADDRI[1];
          end
        else if (busREQI & busVECT & devINTR[2][6])
          begin
             mdevDATAI = devDATAI[2];
             mdevADDRI = devADDRI[2];
          end
        else if (busREQI & busVECT & devINTR[3][6])
          begin
             mdevDATAI = devDATAI[3];
             mdevADDRI = devADDRI[3];
          end
        else if (busREQI & busVECT & devINTR[4][6])
          begin
             mdevDATAI = devDATAI[4];
             mdevADDRI = devADDRI[4];
          end

        //
        // INTR 5 vector arbitration
        //

        else if (busREQI & busVECT & devINTR[1][5])
          begin
             mdevDATAI = devDATAI[1];
             mdevADDRI = devADDRI[1];
          end
        else if (busREQI & busVECT & devINTR[2][5])
          begin
             mdevDATAI = devDATAI[2];
             mdevADDRI = devADDRI[2];
          end
        else if (busREQI & busVECT & devINTR[3][5])
          begin
             mdevDATAI = devDATAI[3];
             mdevADDRI = devADDRI[3];
          end
        else if (busREQI & busVECT & devINTR[4][5])
          begin
             mdevDATAI = devDATAI[4];
             mdevADDRI = devADDRI[4];
          end

        //
        // INTR 4 vector arbitration (Lowest prioity)
        //

        else if (busREQI & busVECT & devINTR[1][4])
          begin
             mdevDATAI = devDATAI[1];
             mdevADDRI = devADDRI[1];
          end
        else if (busREQI & busVECT & devINTR[2][4])
          begin
             mdevDATAI = devDATAI[2];
             mdevADDRI = devADDRI[2];
          end
        else if (busREQI & busVECT & devINTR[3][4])
          begin
             mdevDATAI = devDATAI[3];
             mdevADDRI = devADDRI[3];
          end
        else if (busREQI & busVECT & devINTR[4][4])
          begin
             mdevDATAI = devDATAI[4];
             mdevADDRI = devADDRI[4];
          end

        //
        // Mem or IO request that is acknowledged by Device 1
        //

        else if (busREQI & devACKI[1])
          begin
             mdevADDRI = devADDRI[1];
             mdevDATAI = devDATAI[1];
          end

        //
        // Mem or IO request that is acknowledged by Device 2
        //

        else if (busREQI & devACKI[2])
          begin
             mdevADDRI = devADDRI[2];
             mdevDATAI = devDATAI[2];
          end

        //
        // Mem or IO request that is acknowledged by Device 3
        //

        else if (busREQI & devACKI[3])
          begin
             mdevADDRI = devADDRI[3];
             mdevDATAI = devDATAI[3];
          end

        //
        // Mem or IO request that is acknowledged by Device 4
        //

        else if (busREQI & devACKI[4])
          begin
             mdevADDRI = devADDRI[4];
             mdevDATAI = devDATAI[4];
          end

        //
        // Mem or IO request from Device 1
        //

        else if (devREQI[1])
          begin
             mdevADDRI = devADDRI[1];
             mdevDATAI = devDATAI[1];
          end

        //
        // Mem or IO request from Device 2
        //

        else if (devREQI[2])
          begin
             mdevADDRI = devADDRI[2];
             mdevDATAI = devDATAI[2];
          end

        //
        // Mem or IO request from Device 3
        //

        else if (devREQI[3])
          begin
             mdevADDRI = devADDRI[3];
             mdevDATAI = devDATAI[3];
          end

        //
        // Mem or IO request from Device 4
        //

        else if (devREQI[4])
          begin
             mdevADDRI = devADDRI[4];
             mdevDATAI = devDATAI[4];
          end
    end

   //
   // NXD Bus Monitor
   //
   //  The Bus Monitor acknowledges bus requests to the UBA and devices on the
   //  IO Bus. NXD is asserted on an 'un-acked' IO requests to the devices.
   //

   UBANXD NXD (
      .rst        (rst),
      .clk        (clk),
      .busREQI    (busREQI),
      .busACKO    (busACKO),
      .devREQ     (devREAD | devWRITE | vectREAD),
      .devACK     (devACKI[1] | devACKI[2] | devACKI[3] | devACKI[4]),
      .ubaACK     (ubaREAD | ubaWRITE | loopREAD | loopWRITE),
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

   wire [1:4] mdevINTR = devINTR[1] | devINTR[2] | devINTR[3] | devINTR[4];

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
      .devINTR    (mdevINTR)
   );

   //
   // Loopback testing
   //

   reg [0:35] loopDATA;
   reg [0:35] loopADDR;

   always @(posedge clk)
     begin
        if (rst)
          begin
             loopDATA <= 0;
             loopADDR <= 0;
          end
        else if (loopWRITE)
          begin
             loopDATA <= busDATAI;
             loopADDR <= busADDRI;
          end
     end

   wire ewlb = `busIO(loopADDR) &  `busIOBYTE(loopADDR) & !loopADDR[34] & !loopADDR[35];        // Even word, low  byte.
   wire ewhb = `busIO(loopADDR) &  `busIOBYTE(loopADDR) & !loopADDR[34] &  loopADDR[35];        // Even word, high byte.
   wire owlb = `busIO(loopADDR) &  `busIOBYTE(loopADDR) &  loopADDR[34] & !loopADDR[35];        // Odd  word, low byte.
   wire owhb = `busIO(loopADDR) &  `busIOBYTE(loopADDR) &  loopADDR[34] &  loopADDR[35];        // Odd  word, high byte.
   wire ew   = `busIO(loopADDR) & !`busIOBYTE(loopADDR) & !loopADDR[34] & !loopADDR[35];        // Even word
   wire ow   = `busIO(loopADDR) & !`busIOBYTE(loopADDR) &  loopADDR[34] & !loopADDR[35];        // Odd  word

   //
   // IO Bus Paging
   //
   //  Don't ever attempt to "page" an IO operation.
   //

   wire [0:35] pageDATAO;

   UBAPAGE PAGE (
      .rst        (rst),
      .clk        (clk),
      .devREQI    (devREQ),
      .busADDRI   (busADDRI),
      .busDATAI   (busDATAI),
      .busADDRO   (busADDRO),
      .pageWRITE  (pageWRITE),
      .pageDATAO  (pageDATAO),
      .pageADDRI  (mdevADDRI),
      .pageFLAGS  (pageFLAGS),
      .pageFAIL   (pageFAIL)
   );

   //
   // KS10 to Device Interface
   //

   assign devREQO[1] = busREQI;
   assign devREQO[2] = busREQI;
   assign devREQO[3] = busREQI;
   assign devREQO[4] = busREQI;

   assign devADDRO[1] = busADDRI;
   assign devADDRO[2] = busADDRI;
   assign devADDRO[3] = busADDRI;
   assign devADDRO[4] = busADDRI;

   assign devDATAO[1] = busDATAI;
   assign devDATAO[2] = busDATAI;
   assign devDATAO[3] = busDATAI;
   assign devDATAO[4] = busDATAI;

  assign devRESET  = statINI;

   //
   // Device to KS10 Interface
   //
   //  Don't do device-to-memory request if there is a page failure.
   //  IO requests always stay local to this UBA.
   //

   always @(posedge clk)
     begin
        if (rst)
          busREQO <= 0;
        else
          busREQO <= !pageFAIL & !devIO & devREQ;
     end

   //
   // KS10 Bus Data Multiplexer
   //

   always @*
     begin
        busDATAO = mdevDATAI;
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

`ifndef SYNTHESIS

   integer file;

   initial
     begin
        case (ubaNUM)
          1: file = $fopen("uba1status.txt", "w");
          2: file = $fopen("uba2status.txt", "w");
          3: file = $fopen("uba3status.txt", "w");
          4: file = $fopen("uba4status.txt", "w");
        endcase
        $fwrite(file, "[%11.3f] UBA%d: Initialized.\n", $time/1.0e3, ubaNUM);
        $fflush(file);
     end

   reg [0:35] addr;

   always @(posedge clk)
     begin
        if (rst)
          addr <= 0;
        else
          begin

             if (busREQI)
               addr <= busADDRI;

             if (busREQO)
               addr <= mdevADDRI;

             if (setNXD)
               $fwrite(file, "[%11.3f] UBA%d: Nonexistent device (NXD). Addr = %012o.\n",
                       $time/1.0e3, ubaNUM, addr);

             if (setTMO)
               $fwrite(file, "[%11.3f] UBA%d: Nonexistent memory (TMO). Addr = %012o.\n",
                       $time/1.0e3, ubaNUM, addr);

             if (pageFAIL)
               $fwrite(file, "[%11.3f] UBA%d: Page Failure (TMO). Addr = %012o.\n",
                       $time/1.0e3, ubaNUM, addr);

             if (busACKI)
               begin
                  if (`busREAD(busADDRO))
                    $fwrite(file, "[%11.3f] UBA%d: Read %012o from address %012o.\n",
                            $time/1.0e3, ubaNUM, busDATAI, busADDRO);
                  else
                    $fwrite(file, "[%11.3f] UBA%d: Wrote %012o to address %012o.\n",
                            $time/1.0e3, ubaNUM, busDATAO, busADDRO);
               end

          end
     end

`endif

endmodule
