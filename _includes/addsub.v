// cell level model of add/subtractor

module addsub5 (sub, a, b, z, co, oflow);
	// inputs
	input sub;
	input [4:0] a, b;
	// outputs
	output [4:0] z;
	output co;
	output oflow;
	
	wire [4:0] b2;
	
	// complement
	XOR b2_1 (sub, b[0], b2[0]);
	XOR b2_2 (sub, b[1], b2[1]);
	XOR b2_3 (sub, b[2], b2[2]);
	XOR b2_4 (sub, b[3], b2[3]);
	XOR b2_5 (sub, b[4], b2[4]);
	
	
	// Add	
	add ag1 (a[0], b2[0], sub,    c_out1, z[0]);
	add ag2 (a[1], b2[1], c_out1, c_out2, z[1]);
	add ag3 (a[2], b2[2], c_out2, c_out3, z[2]);
	add ag4 (a[3], b2[3], c_out3, c_out4, z[3]);
	add ag5 (a[4], b2[4], c_out4, co,     z[4]);
	
	// Detecting overflow
	XOR o_detect (co, c_out4, oflow);

endmodule
