module LFSR2 (CLK, RESET, lfsr_count);
	
	input CLK, RESET;
	output [7:0] lfsr_count;
	
	reg [7:0] lfsr_count;
	


  always @(posedge CLK or posedge RESET) begin
    if(RESET)
      //lfsr_count <= 16'h70f0;
	  lfsr_count <= 8'b01110000;
    else
      lfsr_count <= {lfsr_count[5:0],
      ~(lfsr_count[6] ^ lfsr_count[5] ^
      lfsr_count[4] ^ lfsr_count[1])};
  end

endmodule // End Of Module counter
