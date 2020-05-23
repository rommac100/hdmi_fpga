`timescale 1ps / 1ps

// Test Bench for HDMI Generation
module tmds_testbench(
	
    );
reg clk = 0;
reg  [7:0] 		i_byte;
reg 		 	r_disp_en;
reg  [1:0]		r_ctl;
wire [9:0]	   	output_byte;
wire [3:0]	   	ones_count;
wire [6:0] 		disparity;	
tmds_encode encoder(
	.i_clk(clk),
	.i_byte(i_byte),
	.i_disp_en(r_disp_en),
	.i_ctl(r_ctl),
	.o_tmds_byte(output_byte),
	.r_ones_count(ones_count),
	.r_disparity(disparity));

initial
begin
	#5
	i_byte = 8'd1;
	r_ctl = 2'b00;
	r_disp_en = 1'b1;
	#10
	i_byte = 8'd2;

end


always 
	#5 clk= !clk; 
endmodule
