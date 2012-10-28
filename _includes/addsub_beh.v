// generate compare data using boolean operations

module addsub_beh5 (sub, a, b, z, co, oflow);
	// inputs
	input sub;
	input [4:0] a, b;
	// outputs
	output [4:0] z;
	output co;
	output oflow;
	
	wire [4:0] b2 = (sub) ? (~b) : b;
		
	add_beh ab1 (a[0], b2[0],    sub, c_out1, z[0]);
	add_beh ab2 (a[1], b2[1], c_out1, c_out2, z[1]);
	add_beh ab3 (a[2], b2[2], c_out2, c_out3, z[2]);
	add_beh ab4 (a[3], b2[3], c_out3, c_out4, z[3]);
	add_beh ab5 (a[4], b2[4], c_out4, c_out5, z[4]);
	
	assign co = c_out5;

	assign oflow = co ^ c_out4;
	
endmodule
