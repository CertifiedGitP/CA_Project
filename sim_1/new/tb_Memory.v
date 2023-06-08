`timescale 1ns / 1ps

module tb_Memory();
    // input
    reg clk, reset;
    reg Ctl_MemtoReg_in, Ctl_RegWrite_in, Ctl_MemRead_in, Ctl_MemWrite_in, Ctl_Branch_in;
    reg [ 4:0] Rd_in;
    reg [31:0] Write_Data, ALUresult_in, PCimm_in;
    reg Zero_in;
    
    // output
    wire Ctl_MemtoReg_out, Ctl_RegWrite_out;
    wire [ 4:0] Rd_out;
    wire PCSrc;
    wire [31:0] Read_Data, ALUresult_out, PCimm_out;
    
    Memory uut(
        .clk(clk),
        .reset(reset),
        .Ctl_MemtoReg_in(Ctl_MemtoReg_in),
        .Ctl_RegWrite_in(Ctl_RegWrite_in),
        .Ctl_MemRead_in(Ctl_MemRead_in),
        .Ctl_MemWrite_in(Ctl_MemWrite_in),
        .Ctl_Branch_in(Ctl_Branch_in),
        .Ctl_MemtoReg_out(Ctl_MemtoReg_out),
        .Ctl_RegWrite_out(Ctl_RegWrite_out),
        .Write_Data(Write_Data),
        .Read_Data(Read_Data),
        .Zero_in(Zero_in),
        .ALUresult_in(ALUresult_in),
        .ALUresult_out(ALUresult_out),
        .PCimm_in(PCimm_in),
        .PCimm_out(PCimm_out),
        .PCSrc(PCSrc),
        .Rd_in(Rd_in),
        .Rd_out(Rd_out)
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
        Ctl_MemtoReg_in = 0;
        Ctl_RegWrite_in = 0;
        Rd_in = 0;
    end
    
    initial begin
        Ctl_MemRead_in = 0;
        #25 Ctl_MemRead_in = 0;
        #10 Ctl_MemRead_in = 0;
        #10 Ctl_MemRead_in = 0;
        #10 Ctl_MemRead_in = 1;
        #10 Ctl_MemRead_in = 1;
        #10 Ctl_MemRead_in = 1;
        #10 Ctl_MemRead_in = 0;
        #10 Ctl_MemRead_in = 0;
        #10 Ctl_MemRead_in = 0;        
    end
    
    initial begin
        Ctl_MemWrite_in = 0;
        #25 Ctl_MemWrite_in = 1;
        #10 Ctl_MemWrite_in = 1;
        #10 Ctl_MemWrite_in = 1;
        #10 Ctl_MemWrite_in = 0;
        #10 Ctl_MemWrite_in = 0;
        #10 Ctl_MemWrite_in = 0;
        #10 Ctl_MemWrite_in = 0;
        #10 Ctl_MemWrite_in = 0;
        #10 Ctl_MemWrite_in = 0;
    end
    
    initial begin
        Ctl_Branch_in = 0;
        #25 Ctl_Branch_in = 0;
        #10 Ctl_Branch_in = 0;
        #10 Ctl_Branch_in = 0;
        #10 Ctl_Branch_in = 0;
        #10 Ctl_Branch_in = 0;
        #10 Ctl_Branch_in = 0;
        #10 Ctl_Branch_in = 1;
        #10 Ctl_Branch_in = 1;
        #10 Ctl_Branch_in = 1;
    end
    
    initial begin
        Zero_in = 0;
        #25 Zero_in = 0;
        #10 Zero_in = 0;
        #10 Zero_in = 0;
        #10 Zero_in = 0;
        #10 Zero_in = 0;
        #10 Zero_in = 0;
        #10 Zero_in = 0;
        #10 Zero_in = 0;
        #10 Zero_in = 1;
    end
    
    initial begin
        Write_Data = 0;
        #25 Write_Data = 4;
        #10 Write_Data = 5;
        #10 Write_Data = 6;
        #10 Write_Data = 0;
        #10 Write_Data = 0;
        #10 Write_Data = 0;
        #10 Write_Data = 0;
        #10 Write_Data = 0;
        #10 Write_Data = 0;
    end
    
    initial begin
        ALUresult_in = 0;
        #25 ALUresult_in = 17;
        #10 ALUresult_in = 12;
        #10 ALUresult_in = 7;
        #10 ALUresult_in = 17;
        #10 ALUresult_in = 12;
        #10 ALUresult_in = 7;
        #10 ALUresult_in = 0;
        #10 ALUresult_in = 0;
        #10 ALUresult_in = 0;
    end
    
    initial begin
        PCimm_in = 0;
        #25 PCimm_in = 0;
        #10 PCimm_in = 0;
        #10 PCimm_in = 0;
        #10 PCimm_in = 0;
        #10 PCimm_in = 0;
        #10 PCimm_in = 0;
        #10 PCimm_in = 32;
        #10 PCimm_in = 32;
        #10 PCimm_in = 44;
    end
endmodule
