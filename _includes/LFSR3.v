module LFSR3 (CLK, RESET, lfsr_count);
	
	input CLK, RESET;
	output [7:0] lfsr_count;
	
	reg [7:0] lfsr_count;
	
	wire    linear_feedback;

//-------------Code Starts Here-------
assign linear_feedback = !(lfsr_count[7] ^ lfsr_count[3]);

always @(posedge CLK)
if (RESET) begin // active high reset
  lfsr_count <= 8'b0 ;
end else begin
  lfsr_count <= {lfsr_count[6],lfsr_count[5],
          lfsr_count[4],lfsr_count[3],
          lfsr_count[2],lfsr_count[1],
          lfsr_count[0], linear_feedback};
end 

endmodule // End Of Module counter
