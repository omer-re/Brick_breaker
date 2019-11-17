// (c) Technion IIT, Department of Electrical Engineering 2018 
// Written By Liat Schwartz August 2018 

// Implements the state machine of the bomb
// mini-project, with present and next states

module BackCounter
	(
	input logic clk, 
	input logic resetN,
	input logic count_clk,
	input logic start_count,

	output logic enable
   );
 
logic counting;
int counter;
always @(posedge clk or negedge resetN)   begin   
   
	if (!resetN)  begin  // Asynchronic reset
		counter <= 1'b0;
		enable <= 1'b0;
		counting <= 1'b0;
		counter <= 5;
		end
   else begin
		if (start_count) begin
			counter <= 6;
			counting <= 1'b1;
			end
		if (counting) begin
			enable <= 1'b1;
			if (count_clk) begin
				counter <= counter - 1;
			end
			if (counter == 0)
				counting <= 1'b0;
				
			end
		else
		enable <= 1'b0;	
	end
end

endmodule
