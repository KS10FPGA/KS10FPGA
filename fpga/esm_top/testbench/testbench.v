
module testbench;

   reg clk;
   reg reset;

   //
   // Switches
   //
   
   reg  swCONT;
   wire swEXEC = 1'b0;
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
     (.clk	(clk),
      .reset	(reset),
      .pwrFAIL	(1'b0),
      .swCONT	(swCONT),
      .swEXEC	(swEXEC),
      .swRUN	(swRUN),
      .conRXD	(1'b1),
      .conTXD	(conTXD),
      .cpuHALT	(cpuHALT),
      .cpuRUN	(cpuRUN2)
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
       
endmodule
