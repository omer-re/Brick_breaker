// (c) Technion IIT, Department of Electrical Engineering 2018 
// Written By Liat Schwartz August 2018 

// Implements the state machine of the bomb
// mini-project, with present and next states

module Counter
	(
	input logic clk, 
	input logic resetN,
	input logic count_clk,
	input logic ena_count,
	input int MAX_COUNT,

	output logic end_count
   );
		
int counter;
 
always @(posedge clk or negedge resetN)   begin   
   
	if (!resetN)  begin  // Asynchronic reset
		counter <= 1'b0;
		end_count <= 1'b0;
		end
   else begin
		if (!ena_count) begin
			counter <= 0;
			end
		else begin  
			
			if (counter == MAX_COUNT) begin
			counter <= 1'b0;
			end_count <= 1'b1;
			end
			
			else begin
			end_count <= 1'b0;
			if (ena_count && count_clk) 
				counter <= counter + 1'b1;
				end
			end
						
		end
	end
endmodule
