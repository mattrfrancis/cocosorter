module bitonic_sorter
#(parameter NUM_COUNT = 4, DATA_WIDTH = 8)
(clk, reset, data_in, ready, valid, done, data_out);

input clk;
input reset;
input [NUM_COUNT*DATA_WIDTH-1:0] data_in;
input valid;
output ready;
output done;
output [NUM_COUNT*DATA_WIDTH-1:0] data_out;

reg [NUM_COUNT/2*DATA_WIDTH-1:0] data_in_top;
reg [NUM_COUNT/2*DATA_WIDTH-1:0] data_in_bottom;
reg [NUM_COUNT*DATA_WIDTH-1:0] data;

reg [3:0] state;
localparam WAIT = 4'b0000;
localparam SORT_1 = 4'b0001;
localparam SORT_2 = 4'b0010;
localparam SORT_3 = 4'b0011;
localparam DONE = 4'b0100;

always @(posedge clk) begin

	if(valid && state == WAIT && !reset) begin
		data <= data_in;
		state <= SORT_1;
	end

	if(state == SORT_1) begin
		data <= {data_from_top[2*DATA_WIDTH-1-:8], data_from_bottom[DATA_WIDTH-1-:8], data_from_top[DATA_WIDTH-1-:8], data_from_bottom[2*DATA_WIDTH-1-:8]};
		state <= SORT_2;
	end

	if(state == SORT_2) begin
		data <= {data_from_top[2*DATA_WIDTH-1-:8], data_from_bottom[2*DATA_WIDTH-1-:8], data_from_bottom[DATA_WIDTH-1-:8], data_from_top[DATA_WIDTH-1-:8]};
		//data <= {data_from_top, data_from_bottom};
		state <= SORT_3;
	end
	if(state == SORT_3) begin
		data <= {data_from_top, data_from_bottom};
		state <= DONE;
	end

	if(state == DONE) begin
		state <= WAIT;
	end
end

// Sorting

wire [NUM_COUNT/2*DATA_WIDTH-1:0] data_from_top;
wire [NUM_COUNT/2*DATA_WIDTH-1:0] data_from_bottom;

bnode top_sorter(.clk(clk), .data_out(data_from_top), .data_in(data[NUM_COUNT*DATA_WIDTH-1-:NUM_COUNT/2*DATA_WIDTH]));
bnode bottom_sorter(.clk(clk), .data_out(data_from_bottom), .data_in(data[NUM_COUNT/2*DATA_WIDTH-1-:NUM_COUNT/2*DATA_WIDTH]));


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
