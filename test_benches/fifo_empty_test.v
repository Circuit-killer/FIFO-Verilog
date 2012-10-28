module test;

	reg clk = 0; // clock is positive edge
	reg WE = 1;
	reg RE = 1;
	wire [7:0] DATA_IN;
	wire [7:0] DOUT_BEH;
	wire [7:0] DOUT;
	reg RESET = 1;

	always begin
		# 50 clk = ~clk;
	end
	
	
	always @ (clk) begin	
		// Write occurs first
		//# 400 WE = ~WE;
		//# 100 RE = ~RE;
		
		// Read occurs first
		//# 400 RE = ~RE;
		//# 100 WE = ~WE;
		
		//#800 WE = ~WE;
		//#400 RE = ~RE;
	end
		
	initial begin
		#50 RESET = 1;
		#100 RESET = 0;
		
		// Full test
		//#550 RE = 0;
		
		// Empty test
		#550 WE = 0;
		
		// Reset test
		//# 2500 RESET = 1;
		//# 200 RESET = 0;
		
		#5000 $finish;
	end
	
	initial begin

		// generate vcd file
		$dumpfile("./fifo.vcd");
		$dumpvars;
		
		// print info to screen
		$display("\n\n********************************************************************************");
		$display("Legend:");
		$display("        E  = Empty flag (EE) is 1");
		$display("        F  = Full flag (FF) is 1");
		$display("        PE = Partially empty flag (PEF) is 1");
		$display("        PF = Partially full flag (PFF) is 1");
		$display("        RESET = RESET is 1");
		$display("\n********************************************************************************");
		
		$display("\n                                      |     BEHAVIORAL     |         GATE");
		$display("              %3s %7s %2s %2s %5s | %4s %2s %3s %2s %3s | %4s %2s %3s %2s %3s",
										"CLK",
										"DATA_IN",
										"WE",
										"RE",
										"RESET",
										// Behavorial
										"DOUT",
										"EF",
										"PEF",
										"FF",
										"PFF",
										// Gate
										"DOUT",
										"EF",
										"PEF",
										"FF",
										"PFF" );
										//"WD", "RD");
		$display("              -----------------------------------------------------------------");
	
	end
	
	
	// display signals at 50 time units into period to eliminate delay info
	//always @ (clk) begin // display only at posedge
	always begin
		#50 $strobe("At time %5t %3d %7d %2d %2d %5s | %4d %2s %3s %2s %3s | %4d %2s %3s %2s %3s",
										$time,
										clk,
										DATA_IN,
										WE,
										RE,
										RESET ? "RESET" : "",
										// Behavioral
										DOUT_BEH,
										EF_BEH ? "E" : "",
										PEF_BEH ? "PE" : "",
										FF_BEH ? "F" : "",
										PFF_BEH ? "FF" : "",
										// Gate
										DOUT,
										EF ? "E" : "",
										PEF ? "PE" : "",
										FF ? "F" : "",
										PFF ? "PF" : "");
										//FIFO_BEH1.WADD[3:0], FIFO_BEH1.RADD[3:0]);
	end
	
	// compare behavioral and gate 50 time units after clk changes
	always @ (clk) begin
		// only checlk after output signals have settled
		#50	if (DOUT_BEH !== DOUT) $display("ERROR: time=%4t, DOUT_BEH=%d  DOUT=%d", $time, DOUT_BEH, DOUT);
		if (EF_BEH !== EF) $display("ERROR: time=%4t, EF_BEH=%d  EF=%d", $time, EF_BEH, EF);
		if (PEF_BEH !== PEF) $display("ERROR: time=%4t, PEF_BEH=%d  PEF_BEH=%d", $time, PEF_BEH, PEF);
		if (FF_BEH !== FF) $display("ERROR: time=%4t, FF_BEH=%d  FF_BEH=%d", $time, FF_BEH, FF);
		if (PFF_BEH !== PFF) $display("ERROR: time=%4t, PFF_BEH=%d  PFF=%d", $time, PFF_BEH, PFF);
	end
	
	
	// Generate random data
	//LFSR1 LFSR_1 (DATA_IN, RESET, clk, 1);
	//LFSR2 LFSR_2 (clk, RESET, DATA_IN);
	LFSR3 LFSR_3 (clk, RESET, DATA_IN);
	
	fifo_beh FIFO_BEH1 (DATA_IN, WE, RE, RESET, clk, DOUT_BEH, EF_BEH, PEF_BEH, FF_BEH, PFF_BEH);
	fifo     FIFO1     (DATA_IN, WE, RE, RESET, clk, DOUT, EF, PEF, FF, PFF);
	
	
endmodule // test