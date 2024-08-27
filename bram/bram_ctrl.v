`timescale 1ns/1ps

module bram_ctrl
#(
    parameter DWIDTH = 8,
    parameter AWIDTH = 8,
    parameter MEM_SIZE= 127
)
(
    input clk, reset_n, i_run,
    input [AWIDTH-1:0] i_num_cnt,
    output [AWIDTH-1:0] addr0,
    output [DWIDTH-1:0] d0,
    input [DWIDTH-1:0] mem_data,
    output ce0, we0,
    output o_idle, o_write, o_read, o_done
);


    localparam IDLE=2'b00;
    localparam WRITE=2'b01;
    localparam READ=2'b10;
    localparam DONE = 2'b11;


    reg [1:0] c_state;
    reg [1:0] n_state;

    always @(posedge clk or negedge reset_n) begin
	if (!reset_n) begin
	    c_state <= IDLE;
	end else begin
	    c_state <= n_state;
	end
    end

    assign o_idle = c_state == IDLE;
    assign o_write = c_state == WRITE;
    assign o_read = c_state == READ;
    assign o_done = c_state == DONE;

    reg [AWIDTH-1:0] r_num_cnt;
    reg [AWIDTH-1:0] r_cnt;
  
    wire is_write_done = o_write &&(r_cnt == r_num_cnt -1);
    wire is_read_done = o_read &&(r_cnt == r_num_cnt-1);


    always @(*) begin
	case(c_state)
	    IDLE: if(i_run)
		n_state = WRITE;
	    WRITE: if (is_write_done)
		n_state = READ;
	    else n_state = WRITE;
	    READ: if(is_read_done)
		n_state = DONE;
	    else n_state = READ;
	    DONE: n_state =IDLE;
	    default: n_state=IDLE;
	endcase
    end
    
   always @(posedge clk or negedge reset_n) begin
	if(!reset_n) begin
	    r_num_cnt <= 0;
	end else if (i_run) begin
	    r_num_cnt <= i_num_cnt;
	end else if (o_done) begin
	    r_num_cnt <=0;
	end
    end

   
    always @(posedge clk or negedge reset_n) begin
	if(!reset_n) begin
	    r_cnt <= 0;
	end else if (is_write_done || is_read_done) begin
	    r_cnt <=0;
	end else if (o_write || o_read) begin
	    r_cnt <= r_cnt +1;
	end
    end

    assign addr0 = r_cnt;
    assign ce0 = o_write || o_read;
    assign we0 = o_write;
    assign d0 = r_cnt;

spbram #(
    .DWIDTH(DWIDTH),
    .AWIDTH(AWIDTH),
    .MEM_SIZE(MEM_SIZE))
    u_spbram(
    .clk(clk),
	.addr0(addr0),
	.ce0(ce0),
	.we0(we0),
	.q0(mem_data),
	.d0(d0)
    );


endmodule
