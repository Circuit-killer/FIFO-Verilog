module count5 (clk, enable, clr, count);
	input clk, enable, clr;
	output [4:0] count;
	
	// flipflops
	FFDPC ff_e (count[4], clk, 0, clr, E);
	FFDPC ff_d (count[3], clk, 0, clr, D);
	FFDPC ff_c (count[2], clk, 0, clr, C);
	FFDPC ff_b (count[1], clk, 0, clr, B);
	FFDPC ff_a (count[0], clk, 0, clr, A);
	
	// inversions
	INV inv_e (E, E_INV);
	INV inv_d (D, D_INV);
	INV inv_c (C, C_INV);
	INV inv_b (B, B_INV);
	INV inv_a (A, A_INV);
	
	// count[4] = (!E&D&C&B&A) | (E&!A) | (E&!B) | (E&!D) | (E&!C);
	AND4 count4_logic_term1_and (E_INV, D, C, B, count4_term1_and);
	AND2 count4_logic_term1 (count4_term1_and, A, count4_term1);
	AND2 count4_logic_term2 (E, A_INV, count4_term2);
	AND2 count4_logic_term3 (E, B_INV, count4_term3);
	AND2 count4_logic_term4 (E, D_INV, count4_term4);
	AND2 count4_logic_term5 (E, C_INV, count4_term5);
	OR4 count4_or_1 (count4_term1, count4_term2, count4_term3, count4_term4, count4_or_1);
	OR2 count4_or (count4_or_1, count4_term5, c4_into_mux);
	
	// count[3] = (!D&C&B&A) | (D&!A) | (D&!C) | (D&!B);
	AND4 count3_logic_term1 (D_INV, C, B, A, count3_term1);
	AND2 count3_logic_term2 (D, A_INV, count3_term2);
	AND2 count3_logic_term3 (D, C_INV, count3_term3);
	AND2 count3_logic_term4 (D, B_INV, count3_term4);
	OR4 count3_or (count3_term1, count3_term2, count3_term3, count3_term4, c3_into_mux);
	
	// count[2] = (!C&B&A) | (C&!B) | (C&!A);
	AND3 count2_logic_term1 (C_INV, B, A, count2_term1);
	AND2 count2_logic_term2 (C, B_INV, count2_term2);
	AND2 count2_logic_term3 (C, A_INV, count2_term3);
	OR3 count2_or (count2_term1, count2_term2, count2_term3, c2_into_mux);
	
	// count[1] = (!B&A) | (B&!A);
	AND2 count1_logic_term1 (B_INV, A, count1_term1);
	AND2 count1_logic_term2 (B, A_INV, count1_term2);
	OR2 count1_or (count1_term1, count1_term2, c1_into_mux);
	
	// count[0] = (!A) & enable;
	AND2 count0_and (A_INV, enable, c0_into_mux);
	
	// everything into mux
	MUX21 mux_c4 (E, c4_into_mux, enable, count[4]);
	MUX21 mux_c3 (D, c3_into_mux, enable, count[3]);
	MUX21 mux_c2 (C, c2_into_mux, enable, count[2]);
	MUX21 mux_c1 (B, c1_into_mux, enable, count[1]);
	MUX21 mux_c0 (A, c0_into_mux, enable, count[0]);
	
endmodule
