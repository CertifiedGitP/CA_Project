`timescale 1ns / 1ps
module ALU_control(
    input [1:0] ALUop,
    input [6:0] funct7,
    input [2:0] funct3,
    output reg [3:0] ALU_ctl
    );
    
    // ALU_ctl : OPERATION
    // 4'b0000 : and  ==> ReadData1 & ReadData2
    // 4'b0001 : or   ==> ReadData1 | ReadData2
    // 4'b0010 : add  ==> ReadData1 + ReadData2 (Immediate_in)
    // 4'b0110 : sub  ==> ReadData1 - ReadData2
    // 4'b0111 : blt  (branch if less than)
    // 4'b1000 : bge  (branch if greater equal)
    // 4'b1100 : nor  ==> ~(ReadData1 | ReadData2)
    // 4'b1001 : shift left
    // 4'b1010 : shift right
    
    always @(*) begin
        casex ({ALUop, funct3, funct7})
          12'b00_xxx_xxxxxxx    : ALU_ctl = 4'b0010; // lb, lh, lw, sb, sh, sw => ADDITION
          12'b01_00x_xxxxxxx    : ALU_ctl = 4'b0110; // beq, bne               => SUBTRACT
          12'b01_100_xxxxxxx    : ALU_ctl = 4'b0111; // blt                    => BLT (Branch if Less Than)
          12'b01_101_xxxxxxx    : ALU_ctl = 4'b1000; // bge                    => BGE (Branch if Greater Equal)
          12'b10_000_0000000    : ALU_ctl = 4'b0010; // add                    => ADDITION
          12'b10_000_0100000    : ALU_ctl = 4'b0110; // sub                    => SUBTRACT
          12'b10_111_0000000    : ALU_ctl = 4'b0000; // and                    => AND
          12'b10_110_0000000    : ALU_ctl = 4'b0001; // or                     => OR
          12'b10_001_0000000    : ALU_ctl = 4'b1001; // sll                    => SHIFT_LEFT
          12'b10_101_0000000    : ALU_ctl = 4'b1010; // srl                    => SHIFT_RIGHT
          12'b11_000_xxxxxxx    : ALU_ctl = 4'b0010; // addi, jalr             => ADDITION
          12'b11_111_xxxxxxx    : ALU_ctl = 4'b0000; // andi                   => AND
          12'b11_001_0000000    : ALU_ctl = 4'b1001; // slli                   => SHIFT_LEFT
          12'b11_101_0000000    : ALU_ctl = 4'b1010; // srli                   => SHIFT_RIGHT
          default               : ALU_ctl = 4'bx;
        endcase
    end
endmodule
