`timescale 1ns/1ps

`define DWIDTH 8
`define AWIDTH 7
`define MEM_SIZE 128


module tb_bram_ctrl;

    reg clk, reset_n, i_run;
    reg [`AWIDTH-1:0] i_num_cnt;
    
    wire [`AWIDTH-1:0] addr0;
    wire [`DWIDTH-1:0] d0;
    wire [`DWIDTH-1:0] mem_data;
    wire ce0, we0;
    wire o_idle, o_write, o_read, o_done;


    always #5 clk = ~clk;


    integer i;
    
    initial begin
	reset_n = 1;
	clk =0;
	i_run =0;
	i_num_cnt = 0;

	#100
	reset_n = 0;
	#10
	reset_n = 1;
	#10
	@(posedge clk);

	wait(o_idle);

	i_num_cnt <= 8'd2;
	i_run <= 1;

	@(posedge clk);
	i_run <= 0;

	wait(o_done);

	#100
	$finish;
    end

    bram_ctrl
    #(
    .DWIDTH(`DWIDTH),
	.AWIDTH(`AWIDTH),
	.MEM_SIZE(`MEM_SIZE)
    )
    u_bram_ctrl(
	.clk(clk),
	.reset_n(reset_n),
	.i_run(i_run),
	.i_num_cnt(i_num_cnt),
	.d0(d0),
	.addr0(addr0),
	.mem_data(mem_data),
	.ce0(ce0),
	.we0(we0),
	.o_idle(o_idle),
	.o_write(o_write),
	.o_read(o_read),
	.o_done(o_done)
    );


endmodule
