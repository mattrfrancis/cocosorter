module bnode(clk, data_in, data_out);

input clk;
input [8*2-1:0] data_in;
output [8*2-1:0] data_out;

logic comp;
wire [7:0] data_a;
wire [7:0] data_b;

assign data_a = data_in[15-:8];
assign data_b = data_in[7-:8];

assign comp = data_a < data_b;
assign data_out = sorted_data;

logic [15:0] sorted_data;

always_comb begin

	sorted_data = comp ? {data_a, data_b} : {data_b, data_a};

end


endmodule
