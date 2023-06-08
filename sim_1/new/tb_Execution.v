module tb_Execution();
	// input
	reg clk;
	reg Ctl_ALUSrc_in;
	reg Ctl_ALUOpcode1_in;
	reg Ctl_ALUOpcode0_in;
	reg Ctl_Branch_in;
	reg Ctl_MemRead_in;
	reg Ctl_MemWrite_in;
	reg Ctl_MemtoReg_in;
	reg Ctl_RegWrite_in;
	reg [4:0] Rd_in;
	reg [31:0] ReadData1_in;
	reg [31:0] ReadData2_in;
	reg [31:0] Immediate_in;
	reg [31:0] PC_in;
	reg [6:0] funct7_in;
	reg [2:0] funct3_in;

	// output
	wire Branch_out;
	wire MemRead_out;
	wire MemWrite_out;
	wire MemtoReg_out;
	wire RegWrite_out;
	wire [4:0] Rd_out;
	wire Zero_out;
	wire [31:0] ReadData2_out;
	wire [31:0] ALUresult_out;
	wire [31:0] PCimm_out;


	Execution uut(
		.clk(clk),
		.Ctl_ALUSrc_in(Ctl_ALUSrc_in),
		.Ctl_MemtoReg_in(Ctl_MemtoReg_in),
		.Ctl_RegWrite_in(Ctl_RegWrite_in),
		.Ctl_MemRead_in(Ctl_MemRead_in),
		.Ctl_MemWrite_in(Ctl_MemWrite_in),
		.Ctl_Branch_in(Ctl_Branch_in),
		.Ctl_ALUOpcode1_in(Ctl_ALUOpcode1_in),
		.Ctl_ALUOpcode0_in(Ctl_ALUOpcode0_in),
		.Ctl_MemtoReg_out(Ctl_MemtoReg_out),
		.Ctl_RegWrite_out(Ctl_RegWrite_out),
		.Ctl_MemRead_out(Ctl_MemRead_out),
		.Ctl_MemWrite_out(Ctl_MemWrite_out),
		.Ctl_Branch_out(Ctl_Branch_out),
		.Rd_in(Rd_in),
		.Rd_out(Rd_out),
		.Immediate_in(Immediate_in),
		.ReadData1_in(ReadData1_in),
		.ReadData2_in(ReadData2_in),
		.PC_in(PC_in),
		.funct7_in(funct7_in),
		.funct3_in(funct3_in),
		.Zero_out(Zero_out),
		.ALUresult_out(ALUresult_out),
		.PCimm_out(PCimm_out),
		.ReadData2_out(ReadData2_out)
	);

	initial begin
		clk = 0;
		forever #5 clk = ~clk;
	end

	initial begin
		Ctl_MemtoReg_in = 0;
		Ctl_RegWrite_in = 0;
		Ctl_MemRead_in = 0;
		Ctl_MemWrite_in = 0;
		Ctl_Branch_in = 0;
		Rd_in = 0;
	end
	
	initial begin
		Ctl_ALUSrc_in = 0;
		#25 Ctl_ALUSrc_in = 1;
	end

	initial begin
		Ctl_ALUOpcode1_in = 0;
		#5 Ctl_ALUOpcode1_in = 1;
		#10 Ctl_ALUOpcode1_in = 1;
		#10 Ctl_ALUOpcode1_in = 1;
		#10 Ctl_ALUOpcode1_in = 0;
		#10 Ctl_ALUOpcode1_in = 0;
		#10 Ctl_ALUOpcode1_in = 0;
	end
	
	initial begin
		Ctl_ALUOpcode0_in = 0;
		#5 Ctl_ALUOpcode0_in = 0;
		#10 Ctl_ALUOpcode0_in = 0;
		#10 Ctl_ALUOpcode0_in = 1;
		#10 Ctl_ALUOpcode0_in = 0;
		#10 Ctl_ALUOpcode0_in = 0;
		#10 Ctl_ALUOpcode0_in = 1;
	end
	
	initial begin
		Immediate_in = 32'bx;
		#5 Immediate_in = 32'bx;
		#10 Immediate_in = 32'bx;
		#10 Immediate_in = 4;
		#10 Immediate_in = 6;
		#10 Immediate_in = 9;
		#10 Immediate_in = 8;
	end
	
	initial begin
		ReadData1_in = 0;
		#5 ReadData1_in = 3;
		#10 ReadData1_in = 13;
		#10 ReadData1_in = 0;
		#10 ReadData1_in = 5;
		#10 ReadData1_in = 0;
		#10 ReadData1_in = 7;
	end
	
	initial begin
		ReadData2_in = 0;
		#5 ReadData2_in = 4;
		#10 ReadData2_in = 12;
		#10 ReadData2_in = 0;
		#10 ReadData2_in = 0;
		#10 ReadData2_in = 0;
		#10 ReadData2_in = 6;
	end
	
	initial begin
		funct7_in = 0;
		#5 funct7_in = 7'b0000000;
		#10 funct7_in = 7'b0100000;
		#10 funct7_in = 7'bx;
		#10 funct7_in = 7'bx;
		#10 funct7_in = 7'bx;
		#10 funct7_in = 7'bx;
	end
	
	initial begin
		funct3_in = 0;
		#5 funct3_in = 3'b000;
		#10 funct3_in = 3'b000;
		#10 funct3_in = 3'b000;
		#10 funct3_in = 3'b010;
		#10 funct3_in = 3'b010;
		#10 funct3_in = 3'b001;
	end
	
	initial begin
		PC_in = 0;
		#5 PC_in = 0;
		#10 PC_in = 4;
		#10 PC_in = 8;
		#10 PC_in = 12;
		#10 PC_in = 16;
		#10 PC_in = 20;
	end

endmodule