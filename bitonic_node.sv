module bitonic_node #(parameter DATA_WIDTH = 8, NODE_ORDER = 1, NODE_DWIDTH = 8)
(clk, reset, valid, data_in, done, data_out);

input clk;
input reset;
input valid;
input [NODE_DWIDTH-1:0] data_in;

output done;
output [NODE_DWIDTH-1:0] data_out;

reg state;
reg [NODE_DWIDTH-1:0] data_out_reg;
assign done = state == 1;
assign data_out = state == 1 ? data_out_reg : 0;

always @(posedge clk) begin

	if(reset) begin
		state <= 0;
	end if(valid) begin
		state <= 1;
		data_out_reg <= data_in + 1;
	end else begin
		state <= 0;
	end

end


initial begin
	state <= 0;
end



endmodule
