`timescale 1ns / 1ps
module InFetch(
    input               clk, reset,
    input               PCSrc,
    input               PCWrite,
    input       [31:0]  PCimm_in,
    output      [31:0]  instruction_out,
    output reg  [31:0]  PC_out
    );
    wire        [31:0] pc;
    wire        [31:0] PC4 = (PCSrc) ? PCimm_in : pc + 4;
    
    PC B1_PC(
    .clk(clk),
    .reset(reset),
    .PCWrite(PCWrite),
    .PC_in(PC4),
    .PC_out(pc)
    );
    
    iMEM B2_iMEM(
    .clk(clk),
    .reset(reset),
    .IF_ID_Write(PCWrite),
    .PCSrc(PCSrc),
    .PC_in(pc),
    .instruction_out(instruction_out)
    );
    
    // IF/ID reg
    always @(posedge clk) begin
        if (reset||PCSrc)   PC_out <= 0;
        else if (PCWrite)   PC_out <= PC_out;
        else                PC_out <= pc;
    end
    
endmodule

module PC(
    input               clk, reset,
    input               PCWrite,
    input       [31:0]  PC_in,
    output reg  [31:0]  PC_out
    );
    always @(posedge clk) begin
        if (reset)          PC_out <= 0;
        else if (PCWrite)   PC_out <= PC_out;
        else                PC_out <= PC_in;
    end
endmodule


module iMEM(
    input               clk, reset,
    input               IF_ID_Write, PCSrc,
    input      [31:0]   PC_in,
    output reg [31:0]   instruction_out
    );
    parameter ROM_size = 128;
    reg [31:0] ROM [0:ROM_size-1];
    integer i;
    initial begin
        for (i=0; i!=ROM_size; i=i+1) begin
            ROM[i] = 32'b0;
        end
        $readmemh ("fibonacci.rom.mem", ROM);
    end
    
    // instruction Fetch (BRAM)
    always @(posedge clk) begin
        if  (!IF_ID_Write) begin
            if(reset||PCSrc)    instruction_out <= 32'b0;
            else                instruction_out <= ROM[PC_in[31:2]];
        end
    end
endmodule