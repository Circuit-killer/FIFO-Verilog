// cell level model of add
// s = a XOR b XOR c_in
// c_out = (ab) + (c_in(a XOR b))
// p ^ q = !(p & q) & (p | q)

module add (a, b, c_in, c_out, z);
	input a, b, c_in;
	output c_out, z;
	
	//==== Output for z ===================
	// a XOR b = a_xor_b
	AND2  s1 (a, b, z_temp1);
	INV   s2 (z_temp1, z_temp1_inv);
	OR2   s3 (a, b, z_temp2);
	AND2  s4 (z_temp1_inv, z_temp2, a_xor_b);
	// a_xor_b XOR c_in
	AND2  s5 (a_xor_b, c_in, z_temp3);
	INV   s6 (z_temp3, z_temp3_inv);
	OR2   s7 (a_xor_b, c_in, z_temp4);
	AND2  s8 (z_temp3_inv, z_temp4, z);
	
	//==== Output for c_out ===================
	// a XOR b = cout_a_xor_b
	AND2  c1 (a, b, cout_temp1);
	INV   c2 (cout_temp1, cout_temp1_inv);
	OR2   c3 (a, b, cout_temp2);
	AND2  c4 (cout_temp1_inv, cout_temp2, cout_a_xor_b);
	// c_in & cout_a_xor_b
	AND2  c5 (c_in, cout_a_xor_b, cout_temp3);
	// a & b
	AND2  c6 (a, b, cout_temp4);	
	OR2   c7 (cout_temp3, cout_temp4, c_out);

endmodule
