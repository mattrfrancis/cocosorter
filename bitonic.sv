module bitonic_sorter
#(parameter NUM_COUNT = 2, DATA_WIDTH = 8)
(clk, reset, data_in, ready, valid, done, data_out);

input clk;
input reset;
input [NUM_COUNT*DATA_WIDTH-1:0] data_in;
input valid;
output ready;
output done;
output [NUM_COUNT*DATA_WIDTH-1:0] data_out;

reg [NUM_COUNT*DATA_WIDTH-1:0] data;

reg [3:0] state;
localparam WAIT = 4'b0000;
localparam SORTING = 4'b0001;
localparam DONE = 4'b0010;

always @(posedge clk) begin

	if(valid && state == WAIT && !reset) begin
		data <= data_in;
		state <= SORTING;
	end

	if(state == SORTING) begin
		data <= data_from_sorter;
		state <= DONE;
	end

	if(state == DONE) begin
		state <= WAIT;
	end
end

// Sorting

wire [NUM_COUNT*DATA_WIDTH-1:0] data_from_sorter;
bnode sorter(.clk(clk), .data_in(data), .data_out(data_from_sorter), .polarity(1'b0));

//logic [DATA_WIDTH-1:0] high;
//logic [DATA_WIDTH-1:0] low;
//logic comp;
//
//wire [DATA_WIDTH-1:0] data_a;
//wire [DATA_WIDTH-1:0] data_b;
//
//assign data_a = data[2*DATA_WIDTH-1-:8];
//assign data_b = data[1*DATA_WIDTH-1-:8];
//
//
//always_comb begin
//
//	comp = data_a > data_b;
//	high = comp ? data_a : data_b; 
//	low = comp ? data_b : data_a; 
//end

assign ready = state == WAIT;
assign done = state == DONE;
assign data_out = data;

initial begin
	state <= WAIT;
end

initial begin 
	$dumpfile("dump.vcd");
	$dumpvars;
end

endmodule
