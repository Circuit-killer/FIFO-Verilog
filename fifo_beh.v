module fifo_beh (DIN, WE, RE, RESET, CLK, DOUT, EF, PEF, FF, PFF);
	
	input [7:0] DIN;
	input WE, RE, RESET, CLK;
	output [7:0] DOUT;
	output EF, PEF, PFF, FF;
	
	wire [3:0] WADD, RADD; // write address, read address
	wire [4:0] WriteMinusRead;
	
	// memory
	mem16x8 memoryFIFO (DIN, WADD[3:0], WE & ~FF, RADD[3:0], CLK, DOUT);
	
	// when in reset mode, set counter to 0
	counter4bit WADD_COUNTER (CLK, WE & ~FF, RESET, WADD[3:0]);
	counter4bit RADD_COUNTER (CLK, RE & ~EF, RESET, RADD[3:0]);
	
	// Subtract WADD from RADD
	addsub_beh5 WR_sub (1, WADD, RADD, WriteMinusRead, CO, Overflow);
	
	wire E = WriteMinusRead[4];
	wire D = WriteMinusRead[3];
	wire C = WriteMinusRead[2];
	wire B = WriteMinusRead[1];
	wire A = WriteMinusRead[0];
	
	// 00000
	wire ZeroDetect   = ~E & ~D & ~C & ~B & ~A;
	// 00001
	wire OneDetect    = ~E & ~D & ~C & ~B & A;
	// 11111
	wire NegOneDetect = E & D & C & B & A;
	
	wire FF = (ZeroDetect | NegOneDetect) & ~RESET;
	wire EF = ((ZeroDetect | OneDetect) & ~FF) | RESET;
	// wire PEF =  (!C&!B) | (!D); // 8 words or less. works correctly
	wire PEF = (!D&!B&!A) | (!D&!C);
	wire PFF = (D&C);

endmodule

