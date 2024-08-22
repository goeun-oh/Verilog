`timescale 1ns/1ps


module spbram
#(
	parameter DWIDTH = 16,
	parameter AWIDTH = 12,
	parameter MEM_SIZE=3840
)



(
	input clk,

	input [AWIDTH-1:0] addr0,
	input ce0, //memory available
	input we0, // write = 1, read =0
	output reg [DWIDTH-1:0] q0,//when read, data output
	input [DWIDTH-1:0] d0 //when write, data input
);
(* ram_style = "block" *) reg [DWIDTH-1:0] ram [0:MEM_SIZE-1];

always @(posedge clk) begin
	if(ce0) begin
		if(we0) // write
			ram[addr0] <=d0;
		else //read
			q0 <= ram[addr0];
	end
end


endmodule

