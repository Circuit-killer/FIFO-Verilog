// memory with sync write and async read. Nothing is registered on way in.
// write is on pos edge of clock
module mem16x8 (DIN,WADD,WE,RADD,CLK, DOUT);
input [7:0] DIN;
input [3:0] WADD, RADD ;
input WE, CLK;
output [7:0] DOUT;
reg [7:0] DOUT;
reg [7:0] mem [0:15];
// always @ (RADD or posedge CLK)
always @ (RADD or mem[RADD])
       	DOUT<=mem[RADD];
always @ (posedge CLK)
	if (WE) mem[WADD]<=DIN;

endmodule
