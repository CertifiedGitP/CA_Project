`timescale 1ns / 1ps

module tb_RISCVpipeline();
    reg clk, rst, key;
    wire [31:0] current_pc, instruction;

    RISCVpipeline uut(
        .clk(clk),
        .rst(rst),
        .key(key),
        .current_pc(current_pc),
        .instruction(instruction)
    );
    
    initial begin
        rst = 0;
        key = 0;
        #54 rst = 1;
    end
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
endmodule
