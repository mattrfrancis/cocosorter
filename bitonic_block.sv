module bitonic_block
#(parameter DATA_WIDTH = 8, BLOCK_DEPTH = 1)
(clk, reset, data_in, valid, done, data_out);

input clk;
input reset;
input [2**BLOCK_DEPTH*DATA_WIDTH-1:0] data_in;
input valid;

output done;
output [2**BLOCK_DEPTH*DATA_WIDTH-1:0] data_out;

// Here we look to create nodes instead of adding each cycle
// We will consider a block done when each node is done
// There are as many nodes as there is BLOCK_DEPTH
// The size of each node input will be the maximum, divided by two, until there are only two inputs

localparam T_WIDTH = 2**BLOCK_DEPTH*DATA_WIDTH;
localparam STATE_NUMS = $clog2(BLOCK_DEPTH + 1);

// redo here

wire [T_WIDTH-1:0] bstage_outs [BLOCK_DEPTH:0];
wire [BLOCK_DEPTH:0] bstage_ready;
assign bstage_outs[0] = data_in;
assign bstage_ready[0] = valid;
assign done = bstage_ready[BLOCK_DEPTH] == 1;
assign data_out = done ? bstage_outs[BLOCK_DEPTH] : 0;

genvar i_bstage;
genvar i_node;

generate for(i_bstage = 0; i_bstage < BLOCK_DEPTH; i_bstage = i_bstage + 1) begin : bstage_gen

	localparam n_nodes = 2**i_bstage;
	wire [n_nodes-1:0] nodes_ready;
	assign bstage_ready[i_bstage + 1] = &nodes_ready;

	for(i_node = 0; i_node < n_nodes; i_node = i_node + 1) begin : node_gen

		localparam NODE_DWIDTH = DATA_WIDTH * 2**(BLOCK_DEPTH - i_bstage);
		wire [NODE_DWIDTH-1:0] node_data_in;
		assign node_data_in = bstage_outs[i_bstage][NODE_DWIDTH*(i_node+1)-1-:NODE_DWIDTH];
		wire [NODE_DWIDTH-1:0] node_data_out;
		
		bitonic_node #(.DATA_WIDTH(DATA_WIDTH), .NODE_ORDER(n_nodes - i_node), .NODE_DWIDTH(NODE_DWIDTH)) node_constr (.clk(clk), .reset(reset), .valid(bstage_ready[i_bstage]), .data_in(node_data_in), .done(nodes_ready[i_node]), .data_out(node_data_out));

		assign bstage_outs[i_bstage+1][NODE_DWIDTH*(i_node+1)-1-:NODE_DWIDTH] = node_data_out;

	end

end endgenerate

endmodule
