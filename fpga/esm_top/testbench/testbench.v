
module testbench;

   reg clk;
   reg rst;

   initial
     begin
        $display($time, " << Starting the Simulation >>");
        clk = 1'b0;     	// initial state of clock
        rst = 1'b1;     	// initial state of reset
        #100 rst = 1'b0;        // release reset at 100 nS
     end
   
   always
     #10 clk = ~clk;    	// invert every ten nS

   KS10 UUT(.clk(clk),
            .rst(rst),
            .clken(1'b1),
            .d(36'b0),
            .t());

endmodule
