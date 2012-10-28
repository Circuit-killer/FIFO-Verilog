module fifo (DIN, WE, RE, RESET, CLK, DOUT, EF, PEF, FF, PFF);
	
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
	addsub5 WR_sub (1, WADD, RADD, WriteMinusRead, CO, Overflow);
	
	AND2 andWMR1 (WriteMinusRead[4], WriteMinusRead[4], E);
	AND2 andWMR2 (WriteMinusRead[3], WriteMinusRead[3], D);
	AND2 andWMR3 (WriteMinusRead[2], WriteMinusRead[2], C);
	AND2 andWMR4 (WriteMinusRead[1], WriteMinusRead[1], B);
	AND2 andWMR5 (WriteMinusRead[0], WriteMinusRead[0], A);

	INV  invWRM1 (E, E_INV);
	INV  invWRM2 (D, D_INV);
	INV  invWRM3 (C, C_INV);
	INV  invWRM4 (B, B_INV);
	INV  invWRM5 (A, A_INV);
	
	INV invRESET (RESET, RESET_INV);
	
	// 00000
	//wire ZeroDetect   = ~E & ~D & ~C & ~B & ~A;
	AND5 andZeroDetect (E_INV, D_INV, C_INV, B_INV, A_INV, ZeroDetect);
	// 00001
	//wire OneDetect    = ~E & ~D & ~C & ~B & A;
	AND5 andOneDetect (E_INV, D_INV, C_INV, B_INV, A, OneDetect);
	// 11111
	//wire NegOneDetect = E & D & C & B & A;
	AND5 andNegOneDetect (E, D, C, B, A, NegOneDetect);
	
	//wire FF = (ZeroDetect | NegOneDetect) & ~RESET;
	OR2  flagFF1 (ZeroDetect, NegOneDetect, orFF1);
	AND2 flagFF2 (orFF1, RESET_INV, FF);
	INV  flagFFInv (FF, FF_INV);
	
	//wire EF = ((ZeroDetect | OneDetect) & ~FF) | RESET;
	OR2  flagEF1 (ZeroDetect, OneDetect, orEF1);
	AND2 flagEF2 (orEF1, FF_INV, andEF2);
	OR2  flagEF3 (andEF2, RESET, EF);
	INV  flagEFInv (EF, EF_INV);
	
	//wire PEF = (!D&!B&!A) | (!D&!C);
	AND3  flagPEF1 (D_INV, B_INV, A_INV, andPEF1);
	AND2  flagPEF2 (D_INV, C_INV, andPEF2);
	OR2   flagPEF3 (andPEF1, andPEF2, PEF);
	INV   flagPEFInv (PEF, PEF_INV);
	
	//wire PFF = (D&C);
	AND2 flagPFF (D, C, PFF);
	INV  flagPFFInv (PFF, PFF_INV);

endmodule 



// 5 input and
module AND5 (A, B, C, D, E, Z);
output Z;
input A, B, C, D, E;

	AND4 and4To5_1 (A, B, C, D, andTo2);
	AND2 and4to5_2 (andTo2, E, Z);
 
endmodule
