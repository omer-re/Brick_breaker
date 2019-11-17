// (c) Technion IIT, Department of Electrical Engineering 2018 
// Written By Liat Schwartz August 2018 

// Implements the state machine of the bomb
// mini-project, with present and next states

module score_keeper
	(
	input logic clk, 
	input logic resetN,
	input logic restartGame,
	input logic hit,

	output logic [3:0] scoreOne, scoreTen, scoreHundred
	
   );
	

always_ff @(posedge clk or negedge resetN)   begin   
   
	if (!resetN)  begin  // Asynchronic reset
		scoreOne <= 4'b0;
		scoreTen <= 4'b0;
		scoreHundred <= 4'b0;
		end
   else begin
		if (restartGame) begin //synchronic reset
			scoreOne <= 4'b0;
			scoreTen <= 4'b0;
			scoreHundred <= 4'b0;
			end
		else if (hit) begin
			if (scoreOne == 9) begin
				if (scoreTen == 9) begin
						scoreTen <= 0;
						scoreHundred <= scoreHundred + 1'b1;
						end
				else begin
					scoreTen <= scoreTen + 1'b1;
					end
				scoreOne <= 0;
				end
			else begin
				scoreOne <= scoreOne + 1'b1;
				end 
			end
		end
	end // always
endmodule
