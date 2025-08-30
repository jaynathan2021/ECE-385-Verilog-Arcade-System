module state_machine
(
		input logic 			vsync,
		input logic [59:0] 	enemy_array,
		input logic [2:0]		player_lives,
		input logic [7:0] 	key_pressed,
		input logic 			reset,
		input logic [3:0]		count,
		
		output logic [3:0]	state,
		output logic		pulse,co
);


	always_ff @ (posedge vsync or posedge reset) begin
	
		if(reset) begin
			//state 0 = "press space" state
			state <= 4'h0;
			pulse <= 0;
			co <= 0;
		end
		
		else begin
		
			if(state == 4'h0 && key_pressed == 8'd40) begin
				//state 1 = Level 1
				state <= 4'h1;
				// if (state[1] == 1'b1) begin
				// 	// Transition from state 1 to state 2 (rising edge)
				// 	// Put your code here
				// 	pulse <= 1;
				// 	co <= 0;
				// end
				// if(pulse == 0 && c == 0) begin
				// 	pulse <= 1;
				// 	c <= 1;
				// end
				// else
				// 	pulse <= 0;
			end
			
			else if(count == 4'h1 && enemy_array == 60'h0) begin //&& count == 4'h1
				//state 2 = Level 2
				state <= 4'h2;
				// if (state[0] == 1'b1) begin
				// 	// Transition from state 1 to state 2 (rising edge)
				// 	// Put your code here
				// 	pulse <= 0;
				// 	co <= 1;
				//end
				// if(pulse == 0 && c == 0) begin
				// 	pulse <= 1;
				// 	co <= 1;
				// end
				// else
				// 	pulse <= 0;
			end
//
			else if(count == 4'h2 && enemy_array == 60'd0)
				//state 3 = Level 3
				state <= 4'h3;

			else if(count == 4'h3 && enemy_array == 60'd0)
				//state 4 = Level 4
				state <= 4'h4;
			
			else if(count == 4'h4 && enemy_array == 60'd0)
				//state 5 = Level 5
				state <= 4'h5;
			
			else if(count == 4'h5 && enemy_array == 60'd0)
				//state 6 = Level 6
				state <= 4'h6;
			
			else if(count == 4'h6 && enemy_array == 60'd0)
				//state 7 = Level 7
				state <= 4'h7;
			
			else if(count == 4'h7 && enemy_array == 60'd0)
				//state 8 = Level 8
				state <= 4'h8;
			
			else if(count == 4'h8 && enemy_array == 60'd0)
				//state 9 = Level 9
				state <= 4'h9;
			
			else if(count == 4'h9 && enemy_array == 60'd0)
				//state 10 = Level 10
				state <= 4'ha;
			
			else if(count == 4'ha && enemy_array == 60'd0)
				//state 11 = you win state
				state <= 4'hb;
				
			else if(state >= 4'h1 && player_lives == 3'd0)
				//state 12 = game over state
				state <= 4'hc;
				
			else
				//otherwise don't change anything
				state <= state;
		
		end
	end

endmodule 