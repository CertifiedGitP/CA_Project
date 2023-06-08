`timescale 1ns / 1ps
module Control_unit(
    input [6:0] opcode,
    input reset,
    output reg [7:0] Ctl_out
    );
    
    always @(*) begin
        if (reset)
            Ctl_out = 8'b0;
        else
            case(opcode)
                7'b01100_11 : Ctl_out = 8'b001000_10;   //R-type  add, sub, sll, and , or
                7'b00100_11 : Ctl_out = 8'b101000_11;   //I-type  xxxi
                7'b00000_11 : Ctl_out = 8'b111100_00;   //I-type  load
                7'b01000_11 : Ctl_out = 8'b100010_00;   //S-type  store
                7'b11000_11 : Ctl_out = 8'b000001_01;   //SB-type branch
                7'b11011_11 : Ctl_out = 8'b001001_00;   //UJ-type jal
                7'b11001_11 : Ctl_out = 8'b101001_11;   //I-type  jalr
                default     : Ctl_out = 8'b0;
            endcase
    end
endmodule
