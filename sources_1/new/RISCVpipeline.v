`timescale 1ns / 1ps
module RISCVpipeline(
    output [31:0] current_pc,
    output [31:0] instruction,
    
    input clk, rst, key,
    output [ 7:0] digit, fnd,
    output [15:0] LED
    );
    
    wire c;
    wire [ 2:0] LED_clk;
    wire [31:0] pc, ins;
    wire [ 7:0] ind_ctl, exe_ctl, mem_ctl, wb_ctl;
    
    wire [31:0] ind_pc, exe_pc, mem_pc;
    wire [31:0] ind_data1, ind_data2, ind_imm, exe_data2, exe_addr, exe_result, mem_addr, mem_result, mem_data, wb_data;
    wire [ 4:0] ind_rd, ind_rs1, ind_rs2, exe_rd, mem_rd, wb_rd;
    wire [ 6:0] ind_funct7;
    wire [ 2:0] ind_funct3;
    wire ind_jal, ind_jalr, exe_jal, exe_jalr, exe_zero, mem_PCSrc, mem_jal, mem_jalr;
    wire stall;        // flush signal = mem_PCSrc
    wire [ 1:0] forA_out, forB_out;
    
    wire	[31:0] clk_address, clk_count;
	wire 	[31:0] data = (key)? mem_data : clk_count;
	wire 	[31:0] RAM_address = (key) ? (clk_address<<2) : exe_result;  // mem[2]¿¡ f(n) ÀúÀå
	assign LED =  (key) ? 16'b1000_0000_0000_0000 : 16'b0;
    
    assign current_pc = pc;
    assign instruction = ins;
    
    wire reset;
    assign reset = ~rst;

//////////////////////////////////////////////////////////////////////////////////////
    Counter A0_Counter(
        .key1(key),
	    .mem_data(mem_data),
	    .clk_address(clk_address),
	    .ind_rs1(ind_rs1),
	    .ind_data1(ind_data1),
	    .clk(clk),						.clk_out(c),
	    .rst(reset),						
	    .pc_in(pc),
	                                    .LED_clk(LED_clk),  
                                        .clk_count_out(clk_count));

    LED_channel LED0(
        .data(data),				    .digit(digit),
	    .LED_clk(LED_clk),				.fnd(fnd));
//////////////////////////////////////////////////////////////////////////////////////
    InFetch A1_InFetch(
        .clk(c),  .reset(reset),
        .PCSrc(mem_PCSrc),
        .PCWrite(stall),
        .PCimm_in(mem_addr),
                                        .PC_out(pc),
                                        .instruction_out(ins)
    );
        
    Hazard_detection_unit A2_Hazard_detection_unit(
        .exe_Ctl_MemRead_in(ind_ctl[4]),
        .Rd_in(ind_rd),
        .instruction_in(ins[24:15]),
                                        .stall_out(stall)
    );

    InDecode A3_InDecode(
        .clk(c),  .reset(reset),
        .stall(stall),
        .flush(mem_PCSrc),  
        .PC_in(pc),                     .PC_out(ind_pc),
        .instruction_in(ins),           .funct7_out(ind_funct7),
                                        .funct3_out(ind_funct3),
                                        .Rd_out(ind_rd),
                                        .Rs1_out(ind_rs1),
                                        .Rs2_out(ind_rs2),
                                        .ReadData1_out(ind_data1),
                                        .ReadData2_out(ind_data2),
                                        .jal_out(ind_jal),
                                        .jalr_out(ind_jalr),
                                        .Immediate_out(ind_imm),
                              
                                        .Ctl_ALUSrc_out(ind_ctl[7]),
                                        .Ctl_MemtoReg_out(ind_ctl[6]),
                                        .Ctl_RegWrite_out(ind_ctl[5]),
                                        .Ctl_MemRead_out(ind_ctl[4]),
                                        .Ctl_MemWrite_out(ind_ctl[3]),
                                        .Ctl_Branch_out(ind_ctl[2]),
                                        .Ctl_ALUOpcode1_out(ind_ctl[1]),
                                        .Ctl_ALUOpcode0_out(ind_ctl[0]),
        .Ctl_RegWrite_in(wb_ctl[5]),
        .WriteReg(wb_rd),
        .WriteData(wb_data)
    );
    
    Execution A4_Execution(
        .clk(c), .reset(reset),
        .flush(mem_PCSrc),
        .Ctl_ALUSrc_in(ind_ctl[7]),
        .Ctl_MemtoReg_in(ind_ctl[6]),    .Ctl_MemtoReg_out(exe_ctl[6]),
        .Ctl_RegWrite_in(ind_ctl[5]),    .Ctl_RegWrite_out(exe_ctl[5]),
        .Ctl_MemRead_in(ind_ctl[4]),     .Ctl_MemRead_out(exe_ctl[4]),
        .Ctl_MemWrite_in(ind_ctl[3]),    .Ctl_MemWrite_out(exe_ctl[3]),
        .Ctl_Branch_in(ind_ctl[2]),      .Ctl_Branch_out(exe_ctl[2]),
        .Ctl_ALUOpcode1_in(ind_ctl[1]),
        .Ctl_ALUOpcode0_in(ind_ctl[0]),

        .jal_in(ind_jal),               .jal_out(exe_jal),
        .jalr_in(ind_jalr),             .jalr_out(exe_jalr),
        .ForwardA_in(forA_out),
        .ForwardB_in(forB_out),
        .mem_data(exe_result),
        .wb_data(wb_data),
        
        .PC_in(ind_pc),                 .PC_out(exe_pc),
                                        .PCimm_out(exe_addr),
        .funct7_in(ind_funct7),
        .funct3_in(ind_funct3),
        .ReadData1_in(ind_data1),
        .ReadData2_in(ind_data2),       .ReadData2_out(exe_data2),
                                        .Zero_out(exe_zero),
                                        .ALUresult_out(exe_result),
        .Immediate_in(ind_imm),
        .Rd_in(ind_rd),                 .Rd_out(exe_rd)
    );
    
    Forwarding_unit A5_Forwarding_unit(
        .mem_Ctl_RegWrite_in(exe_ctl[5]),
        .wb_Ctl_RegWrite_in(mem_ctl[5]),
        .Rs1_in(ind_rs1),
        .Rs2_in(ind_rs2),
        .mem_Rd_in(exe_rd),     //remarkable
        .wb_Rd_in(mem_rd),      //remarkable
                                        .ForwardA_out(forA_out),
                                        .ForwardB_out(forB_out)
    );
    
    Memory A6_Memory(
        .clk(c),  .reset(reset),
        .PCimm_in(exe_addr),            .PCimm_out(mem_addr),
        .Ctl_MemtoReg_in(exe_ctl[6]),   .Ctl_MemtoReg_out(mem_ctl[6]),
        .Ctl_RegWrite_in(exe_ctl[5]),   .Ctl_RegWrite_out(mem_ctl[5]),
        .Ctl_MemRead_in(exe_ctl[4]),
        .Ctl_MemWrite_in(exe_ctl[3]),
        .Ctl_Branch_in(exe_ctl[2]),
        .Zero_in(exe_zero),             .PCSrc(mem_PCSrc),        
        
        .jal_in(exe_jal),               .jal_out(mem_jal),
        .jalr_in(exe_jalr),             .jalr_out(mem_jalr),
        .PC_in(exe_pc),                 .PC_out(mem_pc),
        .Write_Data(exe_data2),         .Read_Data(mem_data),
        .ALUresult_in(RAM_address),      .ALUresult_out(mem_result),
        .Rd_in(exe_rd),                 .Rd_out(mem_rd)
    );
    
    WB A7_WB(
        .Ctl_MemtoReg_in(mem_ctl[6]),
        .Ctl_RegWrite_in(mem_ctl[5]),   .Ctl_RegWrite_out(wb_ctl[5]),
        .jal_in(mem_jal),
        .jalr_in(mem_jalr),
        .ReadDatafromMem_in(mem_data),  .WriteDatatoReg_out(wb_data),
        .ALUresult_in(mem_result),
        .PC_in(mem_pc),
        .Rd_in(mem_rd),                 .Rd_out(wb_rd)
    );
    
endmodule
