////////////////////////////////////////////////////////////////////
//!
//! KS-10 Processor
//!
//! \brief
//!      KS-10 Console
//!
//! \details
//!
//! \notes:
//!      Important memory areas:
//!       0000030 Halt Switch
//!       0000031 Keep Alive
//!       0000032 Console Input
//!       0000033 Console Output
//!       0000034 Klinik Input
//!       0000035 Klinik Output
//!       0000036 RH11 Address
//!       0000037 Unit Number
//!       0000040 Magtape Params
//!
//! \file
//!      con.v
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

module CON(clk, clken,
           busREQI,  busREQO,  busACKI,  busACKO,
           busADDRI, busADDRO, busDATAI, busDATAO);

   input         clk;      	// Clock
   input         clken;         // Clock enable
   input         busREQI;	// Bus Request In
   output        busREQO;	// Bus Request Out
   input         busACKI;	// Bus Acknowledge In
   output        busACKO;	// Bus Acknowledge Out
   input  [0:35] busADDRI;      // Bus Address In
   output [0:35] busADDRO;      // Bus Address Out
   input  [0:35] busDATAI;      // Bus Data In
   output [0:35] busDATAO; 	// Bus Data Out

   //
   // Memory Address and Flags
   //
   
   wire         busREAD     = busADDRI[ 3]; 
   wire         busWRITE    = busADDRI[ 5];
   wire         busPHYSICAL = busADDRI[ 8];
   wire         busIO       = busADDRI[10];
   wire [18:35] busADDR     = busADDRI[18:35];
   
   //
   // Execute/Start 'Vector'
   //
   // Details:
   //  When the 'execute switch' is asserted at power-up the
   //  KS10 microcode performs a 'read' at IO address o200000
   //  and then executes that instruction.  In the KS10, this
   //  IO address was handled by the Console.  This mechanism
   //  allowed the Console set the address that the KS10
   //  began execution.
   //
   //  This is normally a JRST instruction which causes the
   //  code to jump to the entry point of the code/bootloader.
   //
   
   assign busREQO  = 1'b0;
   assign busACKO  = busIO & busREAD & busPHYSICAL & (busADDR == 18'o200000);
// assign busDATAO = busACKO ? 36'o254000030624 : 36'bx;
   assign busDATAO = busACKO ? 36'o254000030600 : 36'bx;
   assign busADDRO = 36'bx;
   
   //
   // Print the Halt Status Block
   // synthesis translate_off
   //
   
   always @(posedge clk)
     begin
        if (busWRITE & ~busIO & busPHYSICAL)
          begin
             case (busADDR)
               18'o000000 :
                 begin
                  $display("");
                  case (busDATAI[24:35])
                    12'o0000 : $display("Microcode Startup.");
                    12'o0001 : $display("Halt Instruction.");
                    12'o0002 : $display("Console Halt.");
                    12'o0100 : $display("IO Page Failure.");
                    12'o0101 : $display("Illegal Interrupt Instruction.");
                    12'o0102 : $display("Pointer to Unibus Vector is zero.");
                    12'o1000 : $display("Illegal Microcode Dispatch.");
                    12'o1005 : $display("Microcode Startup Check Failed.");
                    default  : $display("Unknown Halt Cause.");
                  endcase
               end
               18'o000001 : $display("PC  is %06o", busDATAI);
               18'o376000 : $display("MAG is %06o", busDATAI);
               18'o376001 : $display("PC  is %06o", busDATAI);
               18'o376002 : $display("HR  is %06o", busDATAI);
               18'o376003 : $display("AR  is %06o", busDATAI);
               18'o376004 : $display("ARX is %06o", busDATAI);
               18'o376005 : $display("BR  is %06o", busDATAI);
               18'o376006 : $display("BRX is %06o", busDATAI);
               18'o376007 : $display("ONE is %06o", busDATAI);
               18'o376010 : $display("EBR is %06o", busDATAI);
               18'o376011 : $display("UBR is %06o", busDATAI);
               18'o376012 : $display("MSK is %06o", busDATAI);
               18'o376013 : $display("FLG is %06o", busDATAI);
               18'o376014 : $display("PI  is %06o", busDATAI);
               18'o376015 : $display("X1  is %06o", busDATAI);
               18'o376016 : $display("TO  is %06o", busDATAI);
               18'o376017 : $display("T1  is %06o", busDATAI);
               18'o376020 : $display("VMA is %06o", busDATAI);
               18'o376021 : $display("FE  is %06o", busDATAI);
             endcase
          end
     end
   
   // synthesis translate_on

endmodule
