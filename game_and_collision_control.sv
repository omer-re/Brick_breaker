// (c) Technion IIT, Department of Electrical Engineering 2018 
// Written By Liat Schwartz August 2018 

// Implements the state machine of the bomb
// mini-project, with present and next states

module game_and_collision_control
	(
	input logic clk, 
	input logic resetN,
	input logic startGame,
	input logic restartGame,
	input logic ballDrawReq,
	input logic batDrawReq,
	input logic brickDrawReq,
	input logic ballHitGround,
	input logic noBricksLeft,
	input logic [10:0] pixelX,
	input logic [10:0] pixelY,
	input logic continueGame,
	input logic cheat, // used to skip to end of level for demonstration purposes


	output logic changeCourse, 
	output logic hit, // up 1 clock to signify hitting brick
	output logic lose,  
	output logic win, 
	output logic ena_move,
	output logic [10:0] hit_pixelX,
	output logic [10:0] hit_pixelY,
	output logic ena_count,
	output logic new_game,
	output int 	 counter, 
	output logic ready_screen,
	output logic opening_screen,
	output logic win_screen,
	output logic background_only

   );

	enum logic [3:0] {startScreen, idle, game, hitBrick, hitBat, WAIT, hitGround, WIN, WINmessage} prState, nxtState;
		
always @(posedge clk or negedge resetN)   begin   
   
	if (!resetN)  begin  // Asynchronic reset
		prState <= startScreen;
		hit_pixelX <= 0;
		hit_pixelY <= 0;
		end
   else begin 
		if (restartGame)	begin 
			prState <= idle;
			hit_pixelX <= 0;
			hit_pixelY <= 0;
			end
		else begin
			prState <= nxtState;
			hit_pixelX <= pixelX;
			hit_pixelY <= pixelY;
			end
		end

	end // always
	
always_comb // Update next state and outputs
	begin
	
		nxtState = prState;
		changeCourse = 1'b0;
		hit = 1'b0;
		lose = 1'b0;
		ena_move = 1'b1;
		win = 1'b0;
		ena_count = 1'b0;
		new_game = 1'b0;
		counter = 0; //determines external counter's maximum count
		ready_screen = 1'b0;
		opening_screen = 1'b0;
		win_screen = 1'b0;
		background_only = 1'b0;
			
		case (prState)
			
			startScreen: begin 
			//displays opening screen for 3 seconds
				background_only = 1'b1;
				opening_screen = 1'b1;
				ena_move = 1'b0;
				ena_count = 1'b1;
				counter = 150;
				if (continueGame)
					nxtState = idle;
				end
				
			idle: begin 
			//waits user input to start level and displays start screen
				new_game = 1'b1;
				ready_screen = 1'b1;
				ena_move = 1'b0;
				if (startGame)
					nxtState = game;
				end
				
			game: begin 
			// manages game stages and recognizes collisions as two objects making their drawing requests simultaneously
				if (ballDrawReq && batDrawReq) begin
						nxtState = hitBat;
						end
						
				else if (ballDrawReq && brickDrawReq) begin
						nxtState = hitBrick;
						end
						
				else if (ballHitGround) begin
						nxtState = hitGround; 
						end
						
				else if (noBricksLeft || cheat) begin 
						nxtState = WIN; 
						end
					end
					
			hitBat: begin
				changeCourse = 1'b1;
				nxtState = WAIT;
				end 
						
			hitBrick: begin
				changeCourse = 1'b1;
				hit = 1'b1;
				nxtState = WAIT;
				end 
					
			WAIT: begin 
			//waits 5 frames to avoid recognizing one hit as multiple ones
				ena_count = 1'b1;
				counter = 5; 
				if (continueGame)
					nxtState = game;
				end
			
			hitGround: begin 
			//game is over if ball hits ground
				background_only = 1'b1;
				ena_move = 1'b0;
				lose = 1'b1;
				if (restartGame)
					nxtState = idle;
				end //
			
			WIN: begin
			//stopping game after player succesfully hit all bricks
				ena_move = 1'b0;
				win = 1'b1;
				nxtState = WINmessage; 
			end
			
			WINmessage: begin 
			//displays winning screen for 1.3 seconds
				background_only = 1'b1;
				ena_move = 1'b0;
				ena_count = 1'b1;
				win_screen = 1'b1;
				counter = 40;
				if (continueGame)
					nxtState = idle;
				else
					nxtState = WINmessage; 
			end
		endcase
		
	end // always comb
	
endmodule
