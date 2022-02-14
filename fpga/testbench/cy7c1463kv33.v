//************************************************************************
//************************************************************************
//** This model is the property of Cypress Semiconductor Corp and is    **
//** protected by the US copyright laws, any unauthorized copying and   **
//** distribution is prohibited. Cypress reserves the right to change   **
//** any of the functional specifications without any prior notice.     **
//** Cypress is not liable for any damages which may result from the    **
//** use of this functional model.                                      **
//**                                                                    **
//** File Name  :   CY7C1463KV33.v                                      **
//**                                                                    **
//** Revision   :   1.0 -Aug 26,2014                                    **
//**                                                                    **
//** The timings are to be selected by the user depending upon the      **
//** frequency of operation from the datasheet.                         **
//**                                                                    **
//** Model      :   CY7C1463KV33 - 2M x 18 NoBL Flow Through SRAM       **
//** Queries    :   MPD Applications                                    **
//**                e-mail: mpd_apps@cypress.com                        **
//************************************************************************
//************************************************************************

//
// Modifications by Rob Doyle.  Mistake are mine.
// Minor fixes so it can be complied with SystemVerilog
// - renamed 'do' (keyword) to 'dor' because 'do' is a keyword in SV.
//

`timescale 1ns/10ps

//
// NOTE :  Any setup/hold errors will force input signal to x state
//         or if results indeterminant (write addr) core is reset x

`define no_words (2*1024*1024 - 1)          // 2M x 18 RAM

module CY7C1463( d, clk, a, bws, we_b, adv_lb, ce1b, ce2, ce3b, oeb, cenb, mode);

   inout [17:0] d;
   input wire   clk,            // clock input (R)
                we_b,           // byte write enable(L)
                adv_lb,         // burst(H)/load(L) address
                ce1b,           // chip enable(L)
                ce2,            // chip enable(H)
                ce3b,           // chip enable(L)
                oeb,            // async output enable(L)(read)
                cenb,           // clock enable(L)
                mode;           // interleave(H)/linear(L) burst
   input [ 1:0] bws;            // byte write select(L)
   input [20:0] a;              // address bus

//      ***     NOTE DEVICE OPERATES #0.01 AFTER CLOCK          ***
//      *** THEREFORE DELAYS HAVE TO TAKE THIS INTO ACCOUNT     ***

//**********************************************************************
//  Timings for 133 MHz Operation
//**********************************************************************

`define MHZ133

`ifdef MHZ133

  `define toehz #3
  `define toelz #0
  `define tchz  #3.8
  `define tclz  #2.5
  `define tcdv  #6.5
  `define tdoh  #2.5
  `define tas   1.5
  `define tah   0.5

`endif

//***********************************************************************
//  Timings for 100MHz
//**********************************************************************

`ifdef MHZ100

  `define toehz #4.0
  `define toelz #0
  `define tchz  #4.5
  `define tclz  #2.5
  `define tcdv  #8.5
  `define tdoh  #2.5
  `define tas   1.5
  `define tah   0.5

`endif

   reg         notifier;        // error support reg's
   reg         noti1_0;
   reg         noti1_1;
   reg         noti1_2;
   reg         noti1_3;
   reg         noti1_4;
   reg         noti1_5;
   reg         noti1_6;
   reg         noti2;

   wire        chipen;          // combined chip enable (high for an active chip)

   reg         chipen_d;        // _d = delayed
   reg         chipen_o;        // _o = operational = delayed sig or _d sig

   wire        writestate;      // holds 1 if any of writebus is low
   reg         writestate_o;

   wire        loadcyc;         // holds 1 for load cycles (setup and hold checks)
   wire        writecyc;        // holds 1 for write cycles (setup and hold checks)
   wire [ 1:0] bws;             // holds the bws values

   wire [ 1:0] writebusb;       // holds the "internal" bws bus based on we_b
   reg  [ 1:0] writebusb_d;
   reg  [ 1:0] writebusb_o;

   wire [ 2:0] operation;       // holds chipen, adv_ld and writestate
   reg  [ 2:0] operation_d;
   reg  [ 2:0] operation_o;

   wire [20:0] a;               // address input bus
   reg  [20:0] a_d;
   reg  [20:0] a_o;

   reg  [17:0] dor;             // data  output reg
   reg  [17:0] di;              // data   input bus
   reg  [17:0] dd;              // data delayed bus

   wire        tristate;        // tristate output (on a bytewise basis) when asserted
   reg         cetri;           // register set by chip disable which sets the tristate
   reg         oetri;           // register set by oe which sets the tristate
   reg         enable;          // register to make the ram enabled when equal to 1
   reg  [20:0] addreg;          // register to hold the input address
   reg  [17:0] pipereg;         // register for the output data
   reg  [17:0] mem [0:`no_words]; // RAM array
   reg  [17:0] writeword;       // temporary holding register for the write data

   reg         burstinit;       // register to hold a[0] for burst type
   reg  [20:0] i;               // temporary register used to write to all mem locs.
   reg         writetri;        // tristate
   reg         lw, bw;          // pipelined write functions
   reg         we_bl;


   wire [17:0]  d =  !tristate ?  dor[17:0] : 18'bz ;    //  data bus

   assign chipen        = (adv_lb == 1 ) ? chipen_d : ~ce1b & ce2 & ~ce3b ;

   assign writestate    = ~& writebusb;

   assign operation     = {chipen, adv_lb, writestate};

   assign writebusb[1:0]= (we_b  == 0 & adv_lb == 0) ? bws[1:0]:
                          (we_b  == 1 & adv_lb == 0) ? 2'b11 :
                          (we_bl == 0 & adv_lb == 1) ? bws[1:0]:
                          (we_bl == 1 & adv_lb == 1) ? 2'b11 :
                                                       2'bxx ;

   assign loadcyc       = chipen & !cenb;

   assign writecyc      = writestate_o & enable & ~cenb & chipen; // check

   assign tristate      = cetri | writetri | oetri;

   pullup(mode);

//
// Initialization
//  Initialize the output to be tri-state, ram to be disabled
//

initial
  begin
     // signals
     writetri   = 0;
     cetri      = 1;
     enable     = 0;
     lw         = 0;
     bw         = 0;
     // error signals
     notifier   = 0;
     noti1_0    = 0;
     noti1_1    = 0;
     noti1_2    = 0;
     noti1_3    = 0;
     noti1_4    = 0;
     noti1_5    = 0;
     noti1_6    = 0;
     noti2      = 0;
     $readmemh(`SSRAM_DAT, mem);

  end

   //
   // Asynchronous OE
   //

   always @(oeb)
     begin
        if (oeb == 1)
          oetri <= `toehz 1;
        else
          oetri <= `toelz 0;
     end

   //
   // Setup / Hold violations
   //

   always @(noti2)
     begin
        if ($time != 0)
          $display("[%11.3f] CY7C1463: Data bus corruption", $time/1.0e3);
        force d =36'bx;
        #1;
        release d;
     end

   always @(noti1_0)
     begin
        if ($time != 0)
          $display("[%11.3f] CY7C1463: Byte write corruption", $time/1.0e3);
          force bws = 2'bx;
        #1;
        release bws;
     end

   always @(noti1_1)
     begin
        if ($time != 0)
          $display("[%11.3f] CY7C1463: Byte enable corruption", $time/1.0e3);
        force we_b = 1'bx;
        #1;
        release we_b;
     end

   always @(noti1_2)
     begin
        if ($time != 0)
          $display("[%11.3f] CY7C1463: CE1B corruption", $time/1.0e3);
        force ce1b =1'bx;
        #1;
        release ce1b;
     end

   always @(noti1_3)
     begin
        if ($time != 0)
          $display("[%11.3f] CY7C1463: CE2 corruption", $time/1.0e3);
        force ce2 =1'bx;
        #1;
        release ce2;
     end

   always @(noti1_4)
     begin
        if ($time != 0)
          $display("[%11.3f] CY7C1463: CE3B corruption", $time/1.0e3);
        force ce3b =1'bx;
        #1;
        release ce3b;
     end

   always @(noti1_5)
     begin
        if ($time != 0)
          $display("[%11.3f] CY7C1463: CENB corruption", $time/1.0e3);
        force cenb =1'bx;
        #1;
        release cenb;
     end

   always @(noti1_6)
     begin
        if ($time != 0)
          $display("[%11.3f] CY7C1463: ADV_LB corruption", $time/1.0e3);
        force adv_lb = 1'bx;
        #1;
        release adv_lb;
     end

   //
   // Synchronous functions from clk edge
   //

   always @(posedge clk)
     if (!cenb)
       begin
          #0.01;

          // latch conditions on adv_lb

          if (adv_lb)
            we_bl      <= we_bl;
          else
            we_bl      <= we_b;

          chipen_d     <= chipen;
          chipen_o     <= chipen;

          writestate_o <= writestate;

          writebusb_o  <= writebusb;
          writebusb_d  <= writebusb_o;

          operation_o  <= operation;
          a_o          <= a;
          a_d          <= a_o;
          di            = d;

          // execute previously pipelined fns

          if (lw) begin
             loadwrite;
             lw =0;
          end

          if (bw) begin
             burstwrite;
             bw =0;
          end

          // decode input/piplined state

          casex (operation)
            3'b0??  : turnoff;
            3'b101  : setlw;
            3'b111  : setbw;
            3'b100  : loadread;
            3'b110  : burstread;
            default : unknown; // output unknown values and display an error message
          endcase

          dor <= `tcdv  pipereg;

       end

   //
   // Tasks
   //

   task read;
      begin
         if (enable)
           cetri <= `tclz 0;
         writetri <= `tchz 0;
         dor <= `tdoh 18'hx;
         pipereg = mem[addreg];
      end
   endtask

   task write;
      begin
         if (enable) cetri <= `tclz 0;
         writeword = mem[addreg];  // set up a word to hold the data for the current location
         /* overwrite the current word for the bytes being written to */
         if (!writebusb_o[1]) writeword[17:9]  = di[17:9];
         if (!writebusb_o[0]) writeword[8:0]   = di[8:0];
         writeword = writeword & writeword; //convert z to x states
         mem[addreg] = writeword;  // store the new word into the memory location
         //writetri <= `tchz 1;    // tristate the outputs
      end
   endtask

   task setlw;
      begin
         lw =1;
         writetri <= `tchz 1;    // tristate the outputs
      end
   endtask

   task setbw;
      begin
         bw =1;
         writetri <= `tchz 1;    // tristate the outputs
      end
   endtask

   task loadread;
      begin
         burstinit = a[0];
         addreg = a;
         enable = 1;
         read;
      end
   endtask

   task loadwrite;
      begin
         burstinit = a_o[0];
         addreg = a_o;
         enable = 1;
         write;
      end
   endtask

   task burstread;
      begin
         burst;
         read;
      end
   endtask

   task burstwrite;
      begin
         burst;
         write;
      end
   endtask

   task unknown;
      begin
         dor = 18'bx;
         // $display ("Unknown function:  Operation = %b\n", operation);
      end
   endtask

   task turnoff;
      begin
         enable = 0;
         cetri <= `tchz 1;
         pipereg = 18'h0;
      end
   endtask

   task burst;
      begin
         if (burstinit == 0 || mode == 0)
           begin
              case (addreg[1:0])
                2'b00:   addreg[1:0] = 2'b01;
                2'b01:   addreg[1:0] = 2'b10;
                2'b10:   addreg[1:0] = 2'b11;
                2'b11:   addreg[1:0] = 2'b00;
                default: addreg[1:0] = 2'bxx;
              endcase
           end
         else
           begin
              case (addreg[1:0])
                2'b00:   addreg[1:0] = 2'b11;
                2'b01:   addreg[1:0] = 2'b00;
                2'b10:   addreg[1:0] = 2'b01;
                2'b11:   addreg[1:0] = 2'b10;
                default: addreg[1:0] = 2'bxx;
              endcase
           end
      end
   endtask

   //
   // IO checks
   //

   specify

      // specify the setup and hold checks
      // notifier will wipe memory as result is indeterminent

      $setuphold(posedge clk &&& loadcyc, a, `tas, `tah, notifier);

      // noti1 should make ip = 'bx;

      $setuphold(posedge clk, bws,  `tas, `tah, noti1_0);
      $setuphold(posedge clk, we_b, `tas, `tah, noti1_1);
      $setuphold(posedge clk, ce1b, `tas, `tah, noti1_2);
      $setuphold(posedge clk, ce2,  `tas, `tah, noti1_3);
      $setuphold(posedge clk, ce3b, `tas, `tah, noti1_4);

      // noti2 should make d = 18'hxxxxx;

      $setuphold(posedge clk &&& writecyc, d, `tas, `tah, noti2);

      // add extra tests here.

      $setuphold(posedge clk, cenb,   `tas, `tah, noti1_5);
      $setuphold(posedge clk, adv_lb, `tas, `tah, noti1_6);

   endspecify

endmodule
