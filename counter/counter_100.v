`timescale 1ns/1ps

module counter_100(
    input clk, reset_n, i_run,
    input [3:0] i_num,
    output [3:0] o_cnt
);

localparam IDLE = 2'b00;
localparam RUN= 2'b01;
localparam DONE=2'b10;

reg [1:0] c_state;
reg [1:0] n_state;

wire is_done ;

reg [3:0] r_cnt;

wire o_idle;
wire o_run;
wire o_done;


    always @(posedge clk or negedge reset_n) begin
	if (!reset_n) begin
	    c_state <= IDLE;
	end else begin
	    c_state <= n_state;
	end
    end


    always @(*) begin
	case (c_state)
	    IDLE: if(i_run) 
		n_state = RUN;
	    RUN : if(is_done)
		n_state = DONE;
		 else 
		n_state = RUN;

	    DONE: n_state = IDLE;
	    default: n_state = IDLE;
	endcase
    end

    assign is_done = (r_cnt == i_num -1);

    assign o_idle = c_state == IDLE;
    assign o_run = c_state == RUN;
    assign o_done = c_state == DONE;

    always @(posedge clk or negedge reset_n) begin
	if(!reset_n) begin
	    r_cnt <=0;
	end else if (is_done) begin
	    r_cnt <= 0;
	end else if (o_run) begin
	    r_cnt <= r_cnt+1;
	end
    end

    assign o_cnt = r_cnt;
endmodule
