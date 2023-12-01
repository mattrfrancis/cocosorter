module bitonic_comp #(parameter DATA_WIDTH = 8, POLARITY = 0)
(clk, reset, valid, A, B, H, L, done);


input clk;
input reset;
input valid;
input [DATA_WIDTH-1:0] A;
input [DATA_WIDTH-1:0] B;
output [DATA_WIDTH-1:0] H;
output [DATA_WIDTH-1:0] L;
output done;

reg [DATA_WIDTH-1:0] H_r;
reg [DATA_WIDTH-1:0] L_r;
reg done_r;
wire comp;

assign comp = A < B;
assign H = H_r;
assign L = L_r;
assign done = done_r;

always @(posedge clk) begin

	if(reset) begin
		H_r <= 0;
		L_r <= 0;
		done_r <= 0;
	end else if(valid) begin
	
		if(POLARITY) begin
			
			H_r <= comp ? B : A;
			L_r <= comp ? A : B;

		end else begin

			H_r <= comp ? A : B;
			L_r <= comp ? B : A;
			
		end

		done_r <= 1;

	end else begin
		H_r <= 0;
		L_r <= 0;
		done_r <= 0;
	end

end

endmodule
