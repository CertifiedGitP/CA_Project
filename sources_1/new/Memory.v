`timescale 1ns / 1ps
module Memory(
    input       reset, clk,
    // control signals
    input       Ctl_MemtoReg_in, Ctl_RegWrite_in, Ctl_MemRead_in, Ctl_MemWrite_in, Ctl_Branch_in,
    output reg  Ctl_MemtoReg_out, Ctl_RegWrite_out,
    
    // bypass
    input       [ 4:0]  Rd_in,
    output reg  [ 4:0]  Rd_out,
    
    //
    input               jal_in, jalr_in,
    input               Zero_in,
    input       [31:0]  Write_Data, ALUresult_in, PCimm_in, PC_in,
    output              PCSrc,
    
    output reg         jal_out, jalr_out,
    output reg  [31:0] Read_Data, ALUresult_out,PC_out,
    output      [31:0] PCimm_out
    );
   
    wire branch;
    or u0(branch, jalr_in, jal_in, Zero_in);
    and u1(PCSrc, Ctl_Branch_in, branch);
    
    parameter mem_size = 1024;
    reg [31:0] mem [0:mem_size-1];
    integer i;
    // DataMemory
    initial begin
        $readmemh("fibonacci.ram.mem", mem);
        //mem[0] <= 32'h00000019;
    end 
    always @(posedge clk) begin
        if (Ctl_MemWrite_in)    mem[ALUresult_in/4] <= Write_Data;
        if (reset)  Read_Data <= 0;
        else        Read_Data <= mem[ALUresult_in/4];
    end
    
    // MEM/WB reg
    always @(posedge clk) begin
        Ctl_MemtoReg_out <= Ctl_MemtoReg_in;
        Ctl_RegWrite_out <= Ctl_RegWrite_in;
        jalr_out <= (reset) ? 1'b0 : jalr_in;
        jal_out <= (reset) ? 1'b0 : jal_in;
        PC_out <= (reset) ? 1'b0 : PC_in;

        Rd_out <= Rd_in;
        ALUresult_out <= ALUresult_in;
    end
    assign PCimm_out = (jalr_in) ? ALUresult_in : PCimm_in;
endmodule
