
module testbench;

   reg clk;
   reg reset;

   //
   // SSRAM
   //

   wire [0:22] ssramADDR;
   wire [0:35] ssramDATA;
   wire        ssramWR;
   
   //
   // Switches
   //
   
   reg  swCONT;
   wire swEXEC = 1'b1;
   wire swRUN  = 1'b1;

   //
   // LED Outputs
   //
   
   wire cpuHALT;
   wire cpuRUN;

   //
   // Initialization
   //
   
   initial
     begin
        $display("KS10 Simulation Starting");
        clk   = 1'b0;             // initial state of clock
        reset = 1'b1;             // initial state of reset
        #95 reset = 1'b0;         // release reset at 95 nS
     end

   //
   // Clock generator
   //
   
   always
     #10 clk = ~clk;            // clock is inverted every ten nS

   //
   // UUT
   //
   
   KS10 UUT
     (.clk      (clk),
      .reset    (reset),
      .ssramADDR(ssramADDR),
      .ssramDATA(ssramDATA),
      .ssramWR  (ssramWR),
      .pwrFAIL  (1'b0),
      .swCONT   (swCONT),
      .swEXEC   (swEXEC),
      .swRUN    (swRUN),
      .conRXD   (1'b1),
      .conTXD   (conTXD),
      .cpuHALT  (cpuHALT),
      .cpuRUN   (cpuRUN2)
      );

   //
   // Display of Processor Status
   //
   
   reg lastHALT;
   always @(posedge clk or posedge reset)
     begin
        if (reset)
          lastHALT = 1'b0;
        else
          begin
             if (cpuHALT & ~lastHALT)
               $display("KS10 CPU Halted at t = %f us", $time / 1.0e3);
             else if (~cpuHALT & lastHALT)
               $display("KS10 CPU Unhalted at t = %f us.", $time / 1.0e3);
             lastHALT = cpuHALT;
          end
     end

   //
   //
   //
   
   always @(posedge cpuHALT or posedge reset )
     begin
        if (reset)
          swCONT <= 1'b0;
        else if ($time > 12000 && $time < 14000)
          begin
             #500 swCONT <= 1'b1;
             #600 swCONT <= 1'b0;
          end
     end

   //
   // PDP10 Memory Initialization
   //
   // Note:
   //  We initialize the PDP10 memory with the diagnostic
   //  code.  This saves having to figure out how to load
   //  the code into memory by some other means.
   //
   //  Object code is extracted from the listing file by a
   //  'simple' AWK script and is included below.
   //

   reg [0:35] SSRAM [0:32767];
   initial
     begin
       `include "ssram.dat"
     end

   //
   // Synchronous RAM
   //
   // Details
   //  This is PDP10 memory.
   //
   // Note:
   //  Only 32K is implemented.  This is sufficient to run the
   //  MAINDEC diagnostics.  Adding more memory makes the
   //  simulation run very slow.
   //
   // FIXME
   //  This is temporary
   //
   
   reg  [0:14] rd_addr;
   wire [0:14] wr_addr = ssramADDR[8:22];

   always @(negedge clk or posedge reset)
     begin
        if (reset)
          ;
        else if (ssramWR)
          SSRAM[wr_addr] <= ssramDATA;
        rd_addr <= wr_addr;
     end
   
   assign ssramDATA = (ssramWR) ? 36'bz : SSRAM[rd_addr];
       
endmodule
