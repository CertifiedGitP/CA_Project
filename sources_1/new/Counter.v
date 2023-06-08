`timescale 1ns / 1ps

module Counter(
	input              clk, rst,
	input  [31:0]      pc_in, 
	input              key1,
	input  [31:0]      mem_data,
    input  [ 4:0]      ind_rs1,
	input  [31:0]      ind_data1,
	output reg [31:0] clk_address,
	output     [ 2:0]  LED_clk,
	output             clk_out,
	output reg [31:0] clk_count_out
    );
	reg [31:0]count = 0;
	reg [31:0]led_count = 0;
	reg count_flag;
	assign clk_out = count[0]; //count[24];
	assign clk_check = count[0];
    assign LED_clk = led_count[14:12];
   
    
	always @(posedge clk) begin
		led_count <= led_count + 32'b1;
		count <= count + 32'b1;
	end
	
	always @(posedge clk_out) begin
		if(rst) begin
			clk_count_out <=  32'b0;
			count_flag <= 1'b0;
		end
		else begin
		    if((ind_rs1 == 5'd31)&&(ind_data1 == 32'd400))
                count_flag <= 1'b1;
            if(!count_flag)
                clk_count_out <= clk_count_out + 32'b1;
		end
			
	end
	
	always@(posedge clk_check) begin
		if(key1) clk_address <= 32'd2;
	end
endmodule
