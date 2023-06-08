`timescale 1ns / 1ps

module tb_InDecode;
    reg clk;
    reg reset;
    reg Ctl_RegWrite_in;
    reg [4:0] WriteReg;
    reg [31:0] WriteData;
    reg [31:0] instruction_in;
    reg [31:0] PC_in;
    
    InDecode uut (
        .clk(clk),
        .reset(reset),
        .Ctl_RegWrite_in(Ctl_RegWrite_in),
        .WriteReg(WriteReg),
        .PC_in(PC_in),
        .instruction_in(instruction_in),
        .WriteData(WriteData)
    );

    initial begin
        reset = 1;
        #24 reset = 0;
    end
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    
    
    initial begin
        WriteReg = 0;
        #25 WriteReg = 1;
        #10 WriteReg = 2;
        #10 WriteReg = 3;
        #10 WriteReg = 4;
        #10 WriteReg = 5;
        #10 WriteReg = 6;
        #10 WriteReg = 7;
        #10 WriteReg = 8;
        #10 WriteReg = 9;
        #10 WriteReg = 10;
        #10 WriteReg = 11;
        #10 WriteReg = 12;
        #10 WriteReg = 13;
        #10 WriteReg = 14;
        #10 WriteReg = 15;
    end
    
    initial begin
        WriteData = 0;
        #25 WriteData = 3;
        #10 WriteData = 4;
        #10 WriteData = 5;
        #10 WriteData = 6;
        #10 WriteData = 7;
        #10 WriteData = 8;
        #10 WriteData = 9;
        #10 WriteData = 10;
        #10 WriteData = 11;
        #10 WriteData = 12;
        #10 WriteData = 13;
        #10 WriteData = 14;
        #10 WriteData = 15;
        #10 WriteData = 16;
        #10 WriteData = 17;
    end
    
    initial begin
        instruction_in = 32'bx;
        #175 instruction_in = 32'b0000000_00010_00001_000_01010_0110011;
        #10 instruction_in = 32'b0100000_01010_01011_000_01100_0110011;
        #10 instruction_in = 32'b0000000_00100_00000_000_01010_0010011;
        #10 instruction_in = 32'b0000_0000_0110_00011_010_11111_0000011;
        #10 instruction_in = 32'b0000000_01100_00000_010_01001_0100011;
        #10 instruction_in = 32'b0_000000_00110_00101_001_0100_0_1100011;
    end
    
    initial begin
        PC_in = 32'bx;
        #175 PC_in = 0;
        #10 PC_in = 4;
        #10 PC_in = 8;
        #10 PC_in = 12;
        #10 PC_in = 16;
        #10 PC_in = 20;
    end
    
    initial begin
        Ctl_RegWrite_in = 0;
        #25 Ctl_RegWrite_in = 1;
        #150 Ctl_RegWrite_in = 0;
    end
endmodule
