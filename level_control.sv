// (c) Technion IIT, Department of Electrical Engineering 2018 
// Written By Liat Schwartz August 2018 

// Implements the state machine of the bomb
// mini-project, with present and next states

module level_control
	(
	input logic clk, 
	input logic resetN,
	input logic restartGame,
	input logic lose,  
	input logic win, 
	
	output logic [1:0] choose_brick_matrix,
	output int ball_speed,
	output logic small_bat

   );
	
enum logic [1:0] {level_0, level_1, level_2, level_3} prlevel, nxtlevel;

always @(posedge clk or negedge resetN)   begin   
 
	if (!resetN)  begin  // Asynchronic reset
		prlevel <= level_0;
		end
   else begin
		if (lose) 
			prlevel <= prlevel;
		else 
			prlevel <= nxtlevel;
		end

	end // always
	
always_comb // Update next state and outputs
	begin
		
		//defaults
		choose_brick_matrix = prlevel;
		nxtlevel = prlevel;
		ball_speed = -300;
		small_bat = 1'b0;
		
		case (prlevel)
			
			level_0: begin
				if (win) 
					nxtlevel = level_1;
				end
				
			level_1: begin
			ball_speed = -400;
				if (win) 
					nxtlevel = level_2;
				end
			
			level_2: begin
				ball_speed = -200;
				small_bat = 1'b1;
				if (win) 
					nxtlevel = level_3;
				end
			
			level_3: begin
				small_bat = 1'b1;
				end				
				
		endcase
		
	end // always comb
	
endmodule
