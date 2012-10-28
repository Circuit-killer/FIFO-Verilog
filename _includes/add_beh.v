// generate compare data using boolean operations
// s = a XOR b XOR c_in
// c_out = (ab) + (c_in(a XOR b))

module add_beh (a, b, c_in, c_out, s);
	input a, b, c_in;
	output c_out, s;

	wire s = a ^ b ^ c_in;
	wire c_out = (a & b) | (c_in & (a ^ b)); 
	
endmodule
