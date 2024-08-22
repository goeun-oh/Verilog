`timescale 1ns/1ps


module tb_counter_100;

reg clk, reset_n, i_run;
reg [3:0] i_num;
wire [3:0] o_cnt;

always #5 clk = ~clk;


initial begin
    clk <= 0;
    reset_n <=1;
    i_run <=0;
    #10
    reset_n <= 0;
    i_run <=1;
    i_num <=4'd3;
    @(posedge clk);
    #10
    reset_n <= 1;
    i_run <=0;

    #100
    $finish;


end


counter_100 u_counter_100(
    .clk(clk), 
    .reset_n(reset_n),
    .i_run(i_run),
    .i_num(i_num),
    .o_cnt(o_cnt)
);
endmodule
