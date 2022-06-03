////////////////////////////////////////////////////////////////////
//
// KS10 Processor
//
// Brief
//   Utilities for Printing Device Register contents on Reads and
//   Writes.
//
// File
//   dumpregs.sv
//
//
// Author
//   Rob Doyle - doyle (at) cox (dot) net
//
////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2012-2022 Rob Doyle
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
`timescale 1ns/1ps

//
// Utility to Print the Device Register contents on reads
//

module PRINT_DEV_REG_ON_RD #(
      parameter [ 7:0] TYPE = "W",
      parameter [31:0] DEVNAME_SZ = 0,
      parameter [31:0] REGNAME_SZ = 0
   ) (
      input wire clk,
      input wire devRD,
      input wire devHIBYTE,
      input wire devLOBYTE,
      input wire [15:0] regVAL,
      input wire [DEVNAME_SZ*8-1:0] devNAME,
      input wire [REGNAME_SZ*8-1:0] regNAME,
      input wire [31:0] file
   );

   reg lastDEVRD;
   always @(posedge clk)
     begin
        lastDEVRD <= devRD;
        if (lastDEVRD & !devRD)
          begin
             case (TYPE)
               "W":
                 $fwrite(file, "[%11.3f] %s: Read  %06o from %s (%s%s).\n",
                         $time/1.0e3,
                         devNAME,
                         regVAL,
                         regNAME,
                         devHIBYTE ? "H" : " ",
                         devLOBYTE ? "L" : " ");
               "H":
                 $fwrite(file, "[%11.3f] %s: Read  %03o    from %s (H ).\n",
                         $time/1.0e3,
                         devNAME,
                         regVAL[7:0],
                         regNAME);
               "L":
                 $fwrite(file, "[%11.3f] %s: Read  %03o    from %s ( L).\n",
                         $time/1.0e3,
                         devNAME,
                         regVAL[7:0],
                         regNAME);
             endcase
             $fflush(file);
          end
     end

endmodule

//
// Utility to Print the Device Register contents on writes
//

module PRINT_DEV_REG_ON_WR #(
      parameter [ 7:0] TYPE = "W",
      parameter [31:0] DEVNAME_SZ = 0,
      parameter [31:0] REGNAME_SZ = 0
   ) (
      input wire clk,
      input wire devWR,
      input wire devHIBYTE,
      input wire devLOBYTE,
      input wire [15:0] devDATA,
      input wire [15:0] regVAL,
      input wire [DEVNAME_SZ*8-1:0] devNAME,
      input wire [REGNAME_SZ*8-1:0] regNAME,
      input wire [31:0] file
   );

   reg lastDEVWR;
   always @(posedge clk)
     begin
        lastDEVWR <= devWR;
        if (!lastDEVWR & devWR)
          begin
             case (TYPE)
               "W":
                 $fwrite(file, "[%11.3f] %s: Wrote %06o to   %s (%s%s).  ",
                         $time/1.0e3,
                         devNAME,
                         devDATA,
                         regNAME,
                         devHIBYTE ? "H" : " ",
                         devLOBYTE ? "L" : " ");
               "H":
                 $fwrite(file, "[%11.3f] %s: Wrote %03o    to   %s (H ).  ",
                         $time/1.0e3,
                         devNAME,
                         devDATA[15:8],
                         regNAME);
               "L":
                 $fwrite(file, "[%11.3f] %s: Wrote %03o    to   %s ( L).  ",
                         $time/1.0e3,
                         devNAME,
                         devDATA[7:0],
                         regNAME);
             endcase
             $fflush(file);
          end
        if (lastDEVWR & !devWR)
          begin
             case (TYPE)
               "W":
                 $fwrite(file, "%s is %06o.\n", regNAME, regVAL);
               "H":
                 $fwrite(file, "%s is %06o.\n", regNAME, regVAL[7:0]);
               "L":
                 $fwrite(file, "%s is %06o.\n", regNAME, regVAL[7:0]);
             endcase
             $fflush(file);
          end
     end

endmodule
