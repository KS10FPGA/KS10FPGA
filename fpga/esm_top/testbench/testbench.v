
module testbench;

   reg clk;                     // Clock
   reg reset;                   // Reset
   wire runLED;                 // Run LED

   //
   // Console Interfaces
   //

   wire [7:0] cslAD; 		// Multiplexed Address/Data Bus
   reg  [7:0] cslADOUT;         // Address/Data Bus Out
   wire [7:0] cslADIN;		// Data Bus In
   reg        cslALE;           // Address Latch Enable
   reg        cslRD_N;          // Read Strobe
   reg        cslWR_N;          // Write Strobe
   wire       cslINTR_N;        // Console Interrupt

   //
   // DZ11 Serial Interface
   //

   wire [0:3] RXD;              // Received RS-232 Data
   wire [0:3] TXD;              // Transmitted RS-232 Data

   //
   // SSRAM
   //

   wire        ssramCLK;        // SSRAM Clock
   wire [0:22] ssramADDR;       // SSRAM Address Bus
   wire [0:35] ssramDATA;       // SSRAM Data Bus
   wire        ssramADV;        // SSRAM Advance
   wire        ssramWR;         // SSRAM Write

   //
   // Initialization
   //

   initial
     begin
        $display("KS10 Simulation Starting");

        // Initial state
        
        clk     = 0;
        reset   = 1;
        cslALE  = 0;
        cslWR_N = 1;
        cslRD_N = 1;

        //
        // Release reset at 95 nS
        //
        
        #95 reset = 1'b0;

        //
        // Write to regSTAT[12:19]
        //
        
        #5  cslADOUT = 8'h25;
        #5  cslALE   = 1;
        #5  cslADOUT = 8'h16;
        #5  cslALE   = 0;
        #5  cslWR_N  = 0;
        #50 cslWR_N  = 1;
        #5  cslRD_N  = 0;
        #50 cslRD_N  = 1;
        
        //
        // Write to regSTAT[20:27]
        //

        #5  cslADOUT = 8'h26;
        #5  cslALE   = 1;
        #5  cslADOUT = 8'h06;
        #5  cslALE   = 0;
        #5  cslWR_N  = 0;
        #50 cslWR_N  = 1;
        #5  cslRD_N  = 0;
        #50 cslRD_N  = 1;
        
        //
        // Write to regSTAT[28:35]
        //

        #5  cslADOUT = 8'h27;
        #5  cslALE   = 1;
        #5  cslADOUT = 8'h01;
        #5  cslALE   = 0;
        #5  cslWR_N  = 0;
        #50 cslWR_N  = 1;
        #5  cslRD_N  = 0;
        #50 cslRD_N  = 1;
        
     end

   //
   // Clock generator
   //
   // Details
   //  Clock is inverted every ten nS
   //

   always
     #10 clk = ~clk;

   assign cslAD = (~cslRD_N) ? 8'bz : cslADOUT;

   //
   // UUT
   //

   KS10 UUT
     (.clk              (clk),
      .reset            (reset),
      .RXD              (RXD),
      .TXD              (TXD),
      .cslALE           (cslALE),
      .cslAD            (cslAD),
      .cslRD_N          (cslRD_N),
      .cslWR_N          (cslWR_N),
      .cslINTR_N        (cslINTR_N),
      .ssramCLK         (ssramCLK),
      .ssramADDR        (ssramADDR),
      .ssramDATA        (ssramDATA),
      .ssramWR          (ssramWR),
      .ssramADV         (ssramADV),
      .runLED           (runLED)
      );

   //
   // Display of Processor Status
   //

   reg lastRUN;
   always @(posedge clk or posedge reset)
     begin
        if (reset)
          lastRUN = 1'b0;
        else
          begin
             if (runLED & ~lastRUN)
               $display("KS10 CPU Unhalted at t = %f us", $time / 1.0e3);
             else if (~runLED & lastRUN)
               $display("KS10 CPU Halted at t = %f us.", $time / 1.0e3);
             lastRUN = runLED;
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
