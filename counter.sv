module counter_module(clk, reset, count);

input clk;
input reset;
output [3:0] count;
reg [3:0] counter;

always @(posedge clk) begin
	
	if(reset)
		counter <= 0;
	else
		counter <= counter + 1;

end


assign count = counter;

initial begin
	$dumpfile("dutwave.vcd");
	$dumpvars;
end

endmodule
