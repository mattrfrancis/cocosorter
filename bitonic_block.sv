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

always @(posedge clk) begin

	if(reset)
		state <= 0;
	else 
		state <= next_state;

end

assign data_out = state == BLOCK_DEPTH ? T_WIDTH'('b1) : T_WIDTH'('b0);

always_comb begin
	case(state)
		0: next_state = valid ? 1 : 0;
		BLOCK_DEPTH : next_state = 0;
		default: next_state = state + 1;
	endcase
end

assign done = state == BLOCK_DEPTH;

initial begin
	state <= 0;
end

endmodule
