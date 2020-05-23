`timescale 1ns / 1ps
module video_gen(
	i_clk,
	o_CounterX,
	o_CounterY
    );

input i_clk;
output [9:0] o_CounterX;
output [9:0] o_CounterY;

reg [9:0] o_CounterX;
reg [9:0] o_CounterY;

always @(posedge i_clk)
begin
	if (o_CounterX==799)
		o_CounterX <= o_CounterX+1;
	else
		o_CounterX <= 0;
end

always @(posedge i_clk)
begin
	if (o_CounterX==799)
	begin
		if (o_CounterY==524)
			o_CounterY<= 0;
		else
			o_CounterY<= o_CounterY+1;
	end
end

endmodule
