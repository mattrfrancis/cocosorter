module bitonic_sorter(clk, reset, data_in, ready, valid, done);

input clk;
input reset;
input [4*8-1:0] data_in;
input valid;
output ready;
output done;

reg [4*8-1:0] data;
reg ready_r;
reg done_r;

always @(posedge clk) begin

	if(valid && ready && !reset) begin
		data <= data_in;
		ready_r <= 0;
		done_r <= 1;
	end

end

assign ready = ready_r;
assign done = done_r;

initial begin
	ready_r <= 1;
	done_r <= 0;
end

initial begin 
	$dumpfile("dump.vcd");
	$dumpvars;
end

endmodule
