`timescale 1ps / 1ps
module tmds_encode(
	i_clk,
	i_byte,
	i_disp_en,
	i_ctl,
	o_tmds_byte,
	r_ones_count,
	r_disparity
    );


input 			i_clk;
input [7:0] 		i_byte;
input [1:0] 		i_ctl;
input 			i_disp_en;

output reg [9:0] 	o_tmds_byte;
output 			r_ones_count;

output [6:0] 		r_disparity;

integer 		i;

reg [3:0] 		r_ones_count;
reg [3:0] 		r_ones_count_parsed;
reg [3:0] 		r_count_diff; // count diff between num of 1s and num of zeros
reg [9:0] 		r_temp_byte;
reg signed [6:0]	r_disparity;

function [3:0] count_ones;
input [7:0] input_byte;
reg [3:0] ones_count; 
integer i;
begin
	ones_count = 4'd0;
	for (i=0; i< 8; i= i+1)
	begin
		if (input_byte[i] == 1)
			ones_count = ones_count +4'd1;
	end
	count_ones = ones_count;
end
endfunction

function [7:0] xor_byte;
input [7:0] i_byte;
reg [7:0] tmp_byte;
integer i;
begin
	tmp_byte = 8'd0;
	tmp_byte[0] = i_byte[0];
	for (i=1; i<8; i=i+1)
		tmp_byte[i] = tmp_byte[i-8'd1] ^ i_byte[i];
	xor_byte = tmp_byte;
end
endfunction

function [7:0] xnor_byte;
input [7:0] i_byte;
reg [7:0] tmp_byte;
integer i;
begin
	tmp_byte = 8'd0;
	tmp_byte[0] = i_byte[0];
	for (i=1; i<8; i=i+1)
		tmp_byte[i] = ~(tmp_byte[i-8'd1] ^ i_byte[i]);
	xnor_byte = tmp_byte;
end
endfunction

task t_dispar_zero; // evaluates when the disparity equals zero or equals 4
begin
	if (r_temp_byte[8] == 1'b0)
	begin
		o_tmds_byte[9:8] = 2'b10;
		o_tmds_byte[7:0] = ~r_temp_byte[7:0];
		r_disparity = r_disparity - r_count_diff;
	end
	else
	begin
		o_tmds_byte[9:8] = 2'b01;
		o_tmds_byte[7:0] = r_temp_byte[7:0];
		r_disparity = r_disparity + r_count_diff;
	end
end
endtask

task t_dispar_not_zero; //evaluates when the disparity does not equal zero and not equal to 4
begin
	if ((r_disparity >0 && r_ones_count_parsed >4) && (r_disparity <0 && r_ones_count_parsed < 4))
	begin
		if (r_temp_byte[8] == 1'b0)
		begin
			o_tmds_byte[9:8] = 2'b10;
			o_tmds_byte[7:0] = ~r_temp_byte[7:0];
			r_disparity = r_disparity - r_count_diff;
		end
		else
		begin
			o_tmds_byte[9:8] = 2'b01;
			o_tmds_byte[7:0] = ~r_temp_byte[7:0];
			r_disparity = r_disparity + r_count_diff+2;
		end
	end
	else
	begin
		if (r_temp_byte[8] == 1'b0)
		begin
			o_tmds_byte[9:8] = 2'b00;
			o_tmds_byte[7:0] = r_temp_byte[7:0];
			r_disparity = r_disparity - r_count_diff-2;
		end
		else
		begin
			o_tmds_byte[9:8] = 2'b01;
			o_tmds_byte[7:0] = r_temp_byte[7:0];
			r_disparity = r_disparity + r_count_diff;
		end
	end
end
endtask

initial
begin
	r_disparity = 7'd0; //prevents a High impedience value from existing.
end

always @(posedge i_clk)
begin
	r_temp_byte = 10'd0;
	r_ones_count = count_ones(i_byte); //store count of ones in input byte

	if ((r_ones_count > 3'd4) || (r_ones_count == 3'd4 && i_byte[0] == 0))
	begin
		r_temp_byte[7:0] = xnor_byte(i_byte);
		r_temp_byte[8] = 1'd0;
	end
  	else
	begin
		r_temp_byte[7:0] = xor_byte(i_byte);	
		r_temp_byte[8] = 1'd1;
	end

	r_ones_count_parsed = count_ones(r_temp_byte[7:0]); //stores the number of ones after Xor or XNORed
	r_count_diff = (r_ones_count_parsed-(4'd8-r_ones_count_parsed)); //stores the difference between the count of ones and count of 0s
	
	if (i_disp_en)
	begin
		if (r_disparity == 0 || r_ones_count_parsed == 4)
			t_dispar_zero();
		else
			t_dispar_not_zero();	
	end
	else
	begin //send ctrl 10bit packet when enable display is false
		case (i_ctl)
			2'b00:
				o_tmds_byte = 10'b0010101011;
			2'b01:
				o_tmds_byte = 10'b0010101010;
			2'b10:
				o_tmds_byte = 10'b1101010100;
			2'b11:
				o_tmds_byte = 10'b1101010101;
		endcase
		r_disparity = 7'd0; 
	end

	

	

end

endmodule
