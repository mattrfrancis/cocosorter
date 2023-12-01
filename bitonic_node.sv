module bitonic_node #(parameter DATA_WIDTH = 8, NODE_ORDER = 1, NODE_DWIDTH = 8, POLARITY = 1)
(clk, reset, valid, data_in, done, data_out);

input clk;
input reset;
input valid;
input [NODE_DWIDTH-1:0] data_in;

output done;
output [NODE_DWIDTH-1:0] data_out;

// Node order for the big one (8 input) is 3.
// 2**NODE_ORDER = individual inputs
// 2**(NODE_ORDER-1) = number of comparitors

// start here

localparam NUM_COMP = 2**(NODE_ORDER-1);

genvar i_comp;

wire [NUM_COMP-1:0] nodes_done;
assign done = &nodes_done;

generate for(i_comp = 0; i_comp < NUM_COMP; i_comp = i_comp + 1) begin : comp_gen

	wire [DATA_WIDTH-1:0] A;
	wire [DATA_WIDTH-1:0] B;
	wire [DATA_WIDTH-1:0] H;
	wire [DATA_WIDTH-1:0] L;

	assign A = data_in[DATA_WIDTH*(i_comp + 1)-1-:DATA_WIDTH];
	assign B = data_in[DATA_WIDTH*(i_comp + 1 + NUM_COMP)-1-:DATA_WIDTH];
	assign data_out[DATA_WIDTH*(i_comp + 1)-1-:DATA_WIDTH] = H;
	assign data_out[DATA_WIDTH*(i_comp + 1 + NUM_COMP)-1-:DATA_WIDTH] = L;

	bitonic_comp #(.DATA_WIDTH(DATA_WIDTH), .POLARITY(POLARITY)) comp_constr (.clk(clk), .reset(reset), .valid(valid), .A(A), .B(B), .H(H), .L(L), .done(nodes_done[i_comp]));

end endgenerate

endmodule
