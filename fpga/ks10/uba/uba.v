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
`include "../cpu/bus.vh"

module UBA (
      input  wire         rst,                          // Reset
      input  wire         clk,                          // Clock
      // KS10 Backplane Bus Interface
      input  wire         busREQI,                      // Backplane Bus Request In
      output wire         busREQO,                      // Backplane Bus Request Out
      input  wire         busACKI,                      // Backplane Bus Acknowledge In
      output wire         busACKO,                      // Backplane Bus Acknowledge Out
      input  wire [ 0:35] busADDRI,                     // Backplane Bus Address In
      output wire [ 0:35] busADDRO,                     // Backplane Bus Address Out
      input  wire [ 0:35] busDATAI,                     // Backplane Bus Data In
      output reg  [ 0:35] busDATAO,                     // Backplane Bus Data Out
      output wire [ 1: 7] busINTR,                      // Backplane Bus Interrupt Request
      // Device Interface
      output wire         devRESET,                     // IO Device Reset
      input  wire [ 1: 4] devREQI,                      // IO Device Request In
      output wire [ 1: 4] devREQO,                      // IO Device Request Out
      input  wire [ 1: 4] devACKI,                      // IO Device Acknowledge In
      output reg  [ 1: 4] devACKO,                      // IO Device Acknowledge Out
      input  wire [ 7: 4] dev1INTR,                     // IO Device 1 Interrupt Request
      input  wire [ 0:35] dev1ADDRI,                    // IO Device 1 Address In
      output wire [ 0:35] dev1ADDRO,                    // IO Device 1 Address Out
      input  wire [ 0:35] dev1DATAI,                    // IO Device 1 Data In
      output wire [ 0:35] dev1DATAO,                    // IO Device 1 Data Out
      input  wire [ 7: 4] dev2INTR,                     // IO Device 2 Interrupt Request
      input  wire [ 0:35] dev2ADDRI,                    // IO Device 2 Address In
      output wire [ 0:35] dev2ADDRO,                    // IO Device 2 Address Out
      input  wire [ 0:35] dev2DATAI,                    // IO Device 2 Data In
      output wire [ 0:35] dev2DATAO,                    // IO Device 2 Data Out
      input  wire [ 7: 4] dev3INTR,                     // IO Device 3 Interrupt Request
      input  wire [ 0:35] dev3ADDRI,                    // IO Device 3 Address In
      output wire [ 0:35] dev3ADDRO,                    // IO Device 3 Address Out
      input  wire [ 0:35] dev3DATAI,                    // IO Device 3 Data In
      output wire [ 0:35] dev3DATAO,                    // IO Device 3 Data Out
      input  wire [ 7: 4] dev4INTR,                     // IO Device 4 Interrupt Request
      input  wire [ 0:35] dev4ADDRI,                    // IO Device 4 Address In
      output wire [ 0:35] dev4ADDRO,                    // IO Device 4 Address Out
      input  wire [ 0:35] dev4DATAI,                    // IO Device 4 Data In
      output wire [ 0:35] dev4DATAO                     // IO Device 4 Data Out
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
   // Address Bus
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
   wire [15:17] busPI     = `busPI(busADDRI);           // IO Bridge PI Request
   wire [14:17] busDEV    = `busDEV(busADDRI);          // IO Bridge Device Number
   wire [18:35] busADDR   = `busIOADDR(busADDRI);       // IO Address

   //
   // Signals
   //

   wire regUBAMR;                                       // Maintenance Mode
   wire setNXD;                                         // Set NXD
   wire setTMO;                                         // Set TMO
   wire pageFAIL;                                       // Page fail
   wire loopACKO;                                       // Loopback acknowledge

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
        devACKO  = 0;
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
   //  when:
   //
   //  1.  The device is initiating a DMA request.  In this case the device
   //      (initiator) asserts devREQI[n].  In multiple requests are present,
   //      this arbiter selects the lowest device.
   //  2.  The device is the target of either an memory or IO request.  In this
   //      case the initiator asserts busREQI and target, if any, asserts
   //      devACKI[n].
   //  3.  The device is reponding to a Interrupt Vector request.  In this case,
   //      the CPU asserts both busREQI and busVECT.  Responding to an interrupt
   //      vector request has priority over all other types of bus transactions.
   //

   reg [0:35] devADDRI;
   reg [0:35] devDATAI;

   always @*
     begin
        devADDRI = 0;
        devDATAI = 0;

        //
        // Interrupt arbitration
        //

        if (busREQI & busVECT)
          begin

             //
             // INTR 7 (Highest Priority)
             //

             if (dev1INTR[7])
               devDATAI = dev1DATAI;
             else if (dev2INTR[7])
               devDATAI = dev2DATAI;
             else if (dev3INTR[7])
               devDATAI = dev3DATAI;
             else if (dev4INTR[7])
               devDATAI = dev3DATAI;

             //
             // INTR 6
             //

             else if (dev1INTR[6])
               devDATAI = dev1DATAI;
             else if (dev2INTR[6])
               devDATAI = dev2DATAI;
             else if (dev3INTR[6])
               devDATAI = dev3DATAI;
             else if (dev4INTR[6])
               devDATAI = dev4DATAI;

             //
             // INTR 5
             //

             else if (dev1INTR[5])
               devDATAI = dev1DATAI;
             else if (dev2INTR[5])
               devDATAI = dev2DATAI;
             else if (dev3INTR[5])
               devDATAI = dev3DATAI;
             else if (dev4INTR[5])
               devDATAI = dev4DATAI;

             //
             // INTR 4 (Lowest prioity)
             //

             else if (dev1INTR[4])
               devDATAI = dev1DATAI;
             else if (dev2INTR[4])
               devDATAI = dev2DATAI;
             else if (dev3INTR[4])
               devDATAI = dev3DATAI;
             else if (dev4INTR[4])
               devDATAI = dev4DATAI;
          end
        else

          //
          // Device arbitration
          //

          begin

             //
             // Device 1
             //

             if ((busREQI & devACKI[1]) | devREQI[1])
               begin
                  devADDRI = dev1ADDRI;
                  devDATAI = dev1DATAI;
               end

             //
             // Device 2
             //

             else if ((busREQI & devACKI[2]) | devREQI[2])
               begin
                  devADDRI = dev2ADDRI;
                  devDATAI = dev2DATAI;
               end

             //
             // Device 3
             //

             else if ((busREQI & devACKI[3]) | devREQI[3])
               begin
                  devADDRI = dev3ADDRI;
                  devDATAI = dev3DATAI;
               end

             //
             //
             //

             else if ((busREQI & devACKI[4]) | devREQI[4])
               begin
                  devADDRI = dev4ADDRI;
                  devDATAI = dev4DATAI;
               end
          end
     end

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
      .devACK     (devACKI[1] | devACKI[2] | devACKI[3] | devACKI[4]),
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

   wire [1:4] devINTR = dev1INTR | dev2INTR | dev3INTR | dev4INTR;

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
      .devINTR    (devINTR)
   );

   //
   // IO Bus Paging
   //

   wire [0:35] pageDATAO;

   UBAPAGE PAGE (
      .rst        (rst),
      .clk        (clk),
      .devREQI    (devREQI[1] | devREQI[2] | devREQI[3] | devREQI[4]),
      .busADDRI   (busADDRI),
      .busDATAI   (busDATAI),
      .busADDRO   (busADDRO),
      .pageWRITE  (pageWRITE),
      .pageDATAO  (pageDATAO),
      .pageADDRI  (regUBAMR ? 0 : devADDRI),
      .pageFAIL   (pageFAIL)
   );

   //
   // KS10 to Device Interface
   //

   assign devREQO[1] = busREQI;
   assign devREQO[2] = busREQI;
   assign devREQO[3] = busREQI;
   assign devREQO[4] = busREQI;

   assign dev1ADDRO = busADDRI;
   assign dev2ADDRO = busADDRI;
   assign dev3ADDRO = busADDRI;
   assign dev4ADDRO = busADDRI;

   assign dev1DATAO = busDATAI;
   assign dev2DATAO = busDATAI;
   assign dev3DATAO = busDATAI;
   assign dev4DATAO = busDATAI;

   assign devRESET = statINI;

   //
   // Device to KS10 Interface
   //

   assign busREQO = !pageFAIL & (devREQI[1] | devREQI[2] | devREQI[3] | devREQI[4]);

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
               addr <= devADDRI;

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
