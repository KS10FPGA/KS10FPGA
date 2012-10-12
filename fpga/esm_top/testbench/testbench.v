
module testbench;

   reg clk;
   reg rst;

   initial
     begin
        $display($time, " << Starting the Simulation >>");
        clk = 1'b0;     	// initial state of clock
        rst = 1'b1;     	// initial state of reset
        #91 rst = 1'b0;        // release reset at 90 nS
     end
   
   always
     #10 clk = ~clk;    	// invert every ten nS

   KS10 UUT(.clk(clk),
            .rst(rst),
            .clken(1'b1),
            .run(1'b1),
            .msec_en(1'b1),
            .execute(1'b1),
            .d(36'b0),
            .t(),
            .crom());

endmodule
