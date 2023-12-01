module bitonic_block
#(parameter DATA_WIDTH = 8, BLOCK_DEPTH = 1)
(clk, reset, data_in, valid, done, data_out);

input clk;
input reset;
input [2**BLOCK_DEPTH*DATA_WIDTH-1:0] data_in;
input valid;

output done;
output [2**BLOCK_DEPTH*DATA_WIDTH-1:0] data_out;

localparam T_WIDTH = 2**BLOCK_DEPTH*DATA_WIDTH;
localparam STATE_NUMS = $clog2(BLOCK_DEPTH + 1);

reg [STATE_NUMS:0] state;
logic [STATE_NUMS:0] next_state;

reg [T_WIDTH-1:0] int_value;
logic [T_WIDTH-1:0] next_value;

always @(posedge clk) begin

	if(reset) begin
		state <= 0;
		int_value <=0;
	end else begin
		state <= next_state;
		int_value <= next_value;
	end

end

assign data_out = state == BLOCK_DEPTH ? int_value : T_WIDTH'('b0);

always_comb begin
	case(state)
		0: begin
			next_state = valid ? 1 : 0;
			next_value = data_in + 1;
		end

		BLOCK_DEPTH : begin
			next_state = 0;
		end

		default : begin
			next_state = state + 1;
			next_value = int_value + 1;
		end
	endcase
end

assign done = state == BLOCK_DEPTH;

initial begin
	state <= 0;
end

endmodule
