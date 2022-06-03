////////////////////////////////////////////////////////////////////////////////
//
// KS-10 Processor Testbench
//
// Brief
//   KS-10 FPGA Test Bench Console Processor IO
//
// File
//   conio.sv
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

   initial
     begin
        //
        // AXI Write Bus Outputs
        //

        axiAWADDR  <= 32'bx;
        axiAWVALID <= 0;
        axiWDATA   <= 32'bx;
        axiWVALID  <= 0;
        axiWSTRB   <= 4'b1111;

        //
        // AXI Read Bus Outputs
        //

        axiARADDR  <= 32'bx;
        axiARVALID <= 0;
        axiRREADY  <= 0;
     end

   //
   // Task to write a 32-bit word to console register
   //

   task conWRITE32;
      input [0:31] addr;
      input [0:31] data;
      begin
         @(posedge cpuCLK);
         @(posedge cpuCLK);
         axiAWADDR  <= addr;
         axiAWVALID <= 1;
         axiAWPROT  <= 0;
         axiWDATA   <= data;
         axiWVALID  <= 1;
         axiWSTRB   <= 4'b1111;
         @(posedge axiBVALID);
         axiAWADDR  <= 32'bx;
         axiAWVALID <= 0;
         axiAWPROT  <= 3'bx;
         axiWDATA   <= 32'bx;
         axiWVALID  <= 0;
         axiWSTRB   <= 4'b1111;
         @(posedge cpuCLK);
         @(posedge cpuCLK);
      end
   endtask

   //
   // Task to read a 32-bit word from console register
   //
   // Note:
   //  A 32-bit read requires 2 16-bit word operations.
   //

   task conREAD32;
      input [0:31] addr;
      output reg [0:31] data;
      begin
         @(posedge cpuCLK);
         @(posedge cpuCLK);
         axiARADDR  <= addr;
         axiARPROT  <= 0;
         axiARVALID <= 1;
         @(posedge axiRVALID);
         data <= axiRDATA;
         axiRREADY <= 1;
         @(posedge cpuCLK);
         axiARADDR  <= 32'bx;
         axiARPROT  <= 3'bx;
         axiARVALID <= 0;
         axiRREADY <= 0;
         @(posedge cpuCLK);
         @(posedge cpuCLK);
      end
   endtask

   //
   // Task to write a 36-bit word to console register
   //
   // Note:
   //  A 36-bit write requires 2 32-bit word operations.
   //

   task conWRITE36;
      input [0:31] addr;
      input [0:35] data;
      begin
         conWRITE32(addr+0, data[ 4:35]);
         conWRITE32(addr+4, {28'b0, data[0:3]});
         #100;
      end
   endtask

   //
   // Task to read a 36-bit word from console register
   //
   // Note:
   //  A 36-bit read requires 3 16-bit word operations.
   //

   task conREAD36;
      input [0:31] addr;
      output reg [0:35] data;
      begin
         conREAD32(addr+0, data[ 4:35]);
         conREAD32(addr+4, data[ 0: 3]);
         #100;
      end
   endtask

   //
   // Task to write a 64-bit word to console register
   //
   // Note:
   //  A 64-bit write requires 2 32-bit word operations.
   //

   task conWRITE64;
      input [0:31] addr;
      input [0:63] data;
      begin
         conWRITE32(addr+0, data[32:63]);
         conWRITE32(addr+4, data[ 0:31]);
         #100;
      end
   endtask

   //
   // Task to read a 64-bit word from console register
   //
   // Note:
   //  A 64-bit read requires 4 16-bit word operations.
   //

   task conREAD64;
      input [0:31] addr;
      output reg [0:63] data;
      begin
         conREAD32(addr+0, data[32:63]);
         conREAD32(addr+4, data[ 0:31]);
         #100;
      end
   endtask

   //
   // Task to write to KS10 memory
   //
   // Details
   //  Write address.  Write data.
   //

   task conWRITEMEM;
      input [18:35] address;
      input [ 0:35] data;
      begin
         conWRITE36(addrREGADDR, {18'o010000, address});
         conWRITE36(addrREGDATA, data);
         conGO(address);
      end
   endtask

   //
   // Task to read from KS10 memory
   //

   task conREADMEM;
      input  [18:35] address;
      output [ 0:35] data;
      begin
         conWRITE36(addrREGADDR, {18'o040000, address});
         conGO(address);
         conREAD36(addrREGDATA, data);
      end
   endtask

   //
   // Task to read from KS10 memory (physical)
   //

   task conREADMEMP;
      input  [18:35] address;
      output [ 0:35] data;
      reg    [ 0:15] status;
      begin
         conWRITE36(addrREGADDR, {18'o041000, address});
         conGO(address);
         conREAD36(addrREGDATA, data);
      end
   endtask

   //
   // Task to write to KS10 IO
   //
   // Details
   //  Write address.  Write data.
   //

   task conWRITEIO;
      input [14:35] address;
      input [ 0:35] data;
      begin
         conWRITE36(addrREGADDR, {14'o00450, address}); // Write, Phys, IO
         conWRITE36(addrREGDATA, data);
         conGO(address);
      end
   endtask

   //
   // Task to read from KS10 IO
   //

   task conREADIO;
      input  [14:35] address;
      output [ 0:35] data;
      reg    [ 0:15] status;
      begin
         conWRITE36(addrREGADDR, {14'o02050, address}); // Read, Phys, IO
         conGO(address);
         conREAD36(addrREGDATA, data);
      end
   endtask

   //
   // Set the GO bit then poll the GO bit.
   // Whine about NXM/NXD response
   //

   task conGO;
      input [18:35] address;
      reg   [ 0:31] status;
      begin

         //
         // Set GO bit
         //

         @(posedge cpuCLK);
         @(posedge cpuCLK);
         conREAD32(addrREGSTATUS, status);
         status <= status + statGO;
         @(posedge cpuCLK);
         conWRITE32(addrREGSTATUS, status);
         @(posedge cpuCLK);
         conREAD32(addrREGSTATUS, status);
         while (status & statGO)
           begin
              @(posedge cpuCLK);
              conREAD32(addrREGSTATUS, status);
           end
         @(posedge cpuCLK);
         if (status & statNXMNXD)
           $display("[%11.3f] KS10: NXM/NXD at address %06o", $time/1.0e3,
                    address);
         conWRITE32(addrREGSTATUS, status & ~statNXMNXD);

      end
   endtask
