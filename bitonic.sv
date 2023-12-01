module bitonic_top
#(parameter NUM_INPUT = 16, DATA_WIDTH = 8)
(clk, reset, data_in, valid, done, data_out);

input clk;
input reset;
input [NUM_INPUT * DATA_WIDTH - 1:0] data_in;
input valid;

output done;
output [NUM_INPUT * DATA_WIDTH - 1:0] data_out;

// We construct as per https://github.com/mcjtag/bitonic_sorter/blob/master/img/bitonic.gif

// There will be x stages, with y blocks, each containing z nodes

localparam STAGES = $clog2(NUM_INPUT);
localparam ALL_WIDTH = NUM_INPUT * DATA_WIDTH;

wire [ALL_WIDTH - 1:0] stage_data [STAGES:0];
wire [STAGES:0] stage_ready;

assign stage_data[0] = data_in;
assign stage_ready[0] = valid;
assign done = stage_ready[STAGES] == 1;
assign data_out = stage_data[STAGES];

genvar i_stage;
genvar i_block;

generate for(i_stage = 0; i_stage < STAGES; i_stage = i_stage + 1) begin : stages_gen

	// Each stage x should have inputs/(2^(stage+1))
	localparam BLOCK_COUNT = NUM_INPUT/(2**(i_stage+1));
	localparam BLOCK_DWIDTH = DATA_WIDTH*2**(i_stage+1);
	localparam BLOCK_DEPTH = i_stage + 1;
	wire [BLOCK_COUNT - 1:0] blks_done;
	assign stage_ready[i_stage+1] = &blks_done;

	for(i_block = 0; i_block < BLOCK_COUNT; i_block = i_block + 1) begin

		wire [BLOCK_DWIDTH-1:0] block_in;
		wire [BLOCK_DWIDTH-1:0] block_out;

		assign block_in = stage_data[i_stage][BLOCK_DWIDTH*(i_block+1)-1-:BLOCK_DWIDTH];
		assign stage_data[i_stage+1][BLOCK_DWIDTH*(i_block+1)-1-:BLOCK_DWIDTH] = block_out;

		bitonic_block #(.DATA_WIDTH(DATA_WIDTH), .BLOCK_DEPTH(BLOCK_DEPTH), .POLARITY(i_block%2)) blk_const (.clk(clk), .reset(reset), .data_in(block_in), .data_out(block_out), .done(blks_done[i_block]), .valid(stage_ready[i_stage]));
		
	end


initial begin
	$dumpfile("dump.vcd");
	$dumpvars;
end

end endgenerate
endmodule
