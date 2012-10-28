module count5_beh (clk, enable, clr, count);
	input clk, enable, clr;
	output [4:0] count;	
	
	wire c4 = count[4];
	wire c3 = count[3];
	wire c2 = count[2];
	wire c1 = count[1];
	wire c0 = count[0];
	
	FFDPC ff_e (c4, clk, 0, clr, E);
	FFDPC ff_d (c3, clk, 0, clr, D);
	FFDPC ff_c (c2, clk, 0, clr, C);
	FFDPC ff_b (c1, clk, 0, clr, B);
	FFDPC ff_a (c0, clk, 0, clr, A);	
	
	
	// espresso minizmied logic	
	wire c4_into_mux = (!E&D&C&B&A) | (E&!A) | (E&!B) | (E&!D) | (E&!C);
	wire c3_into_mux = (!D&C&B&A) | (D&!A) | (D&!C) | (D&!B);
	wire c2_into_mux = (!C&B&A) | (C&!B) | (C&!A);
	wire c1_into_mux = (!B&A) | (B&!A);
	wire c0_into_mux = (!A);
	
	MUX21 mux_c4 (E, c4_into_mux, enable, c4_m);
	MUX21 mux_c3 (D, c3_into_mux, enable, c3_m);
	MUX21 mux_c2 (C, c2_into_mux, enable, c2_m);
	MUX21 mux_c1 (B, c1_into_mux, enable, c1_m);
	MUX21 mux_c0 (A, c0_into_mux, enable, c0_m);
		
	assign count[4] = c4_m;
	assign count[3] = c3_m;
	assign count[2] = c2_m;
	assign count[1] = c1_m;
	assign count[0] = c0_m;

	
endmodule
