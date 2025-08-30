//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  10-06-2017                               --
//                                                                       --
//    fall 2017 Distribution                                             --
//                                                                       --
//    for use with ECE 385 Lab 8                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------

//64

// first row = 32
// Second Row = 96
// Third Row = 160
// Third Row Limit = 224


// color_mapper: Decide which color to be output to VGA for each pixel.
module  color_mapper (
							  input	logic	[3:0]	state,count,
							  input logic			game_over_pixel,
							  input	logic			you_win_pixel,
							  input	logic			press_space_pixel,
							  
							  
							  input	logic			player_unkillable,

							  
                              input         [9:0] DrawX, DrawY,       	// Current pixel coordinates
							  
							 // input	logic	[7:0] animation_offset,	    // Selects which one of the two enemy frames to display
							 
							  input logic   [9:0] enemy_posX,			// offset of the left side of the enemy array
							  input logic   [9:0] enemy_posY,
							  input	logic	[9:0] player_pos,	    // left X coord of player's ship
							  input	logic		  player_flash,			// whether or not the player should flash when invincible
							  
							  
							  input logic 		missile_exists,	    	// whether or not enemy missile exists
							  input	logic [9:0] missileX,		        // enemy missile X position
							  input logic [9:0] missileY,				// enemy missile Y position
							  
							  
							  input	logic		pmissile_exists,		// whether or not player missile exists
							  input logic [9:0] pMissileX,				// player missile x position
							  input logic [9:0] pMissileY,				// player missile y position
							  
							  
							  input logic [2:0] player_lives,			    // number of player lives left
							  input	logic [9:0][5:0] enemy_status,	        // array of enemies still alive
							  
							  input logic current_health_pixel,
							  input	logic current_score_pixel,	            //used for drawing score array

							  input logic score_text_pixel,
							  
							  input	logic health_block_pixel,   	            //used to print the lives text
							  
                       output logic [3:0] VGA_R, VGA_G, VGA_B ,             // VGA RGB output
							  output logic current_sprite_pixel
                     );
    
     logic [3:0] Red, Green, Blue;
	 logic [7:0] sprite_sliceA, sprite_sliceB, sprite_sliceC, sprite_addrA, sprite_addrB, sprite_addrC;
//	 logic current_sprite_pixel;
	 
	 logic [15:0] player_slice;
	 logic [7:0]  player_addr;
	 logic current_player_pixel;
	 
	 logic [9:0] enemy_x_actual;
	 logic [9:0] enemy_y_actual;
	 logic [9:0] player_x_actual;
	 
	 assign enemy_x_actual = DrawX - enemy_posX;
	 assign enemy_y_actual = DrawY + enemy_posY - 10'h25;
	 assign player_x_actual = DrawX - player_pos;
	 
	 sprite_romA ROM_enemyA(.addr(sprite_addrA), .data(sprite_sliceA));
	 sprite_romB ROM_enemyB(.addr(sprite_addrB), .data(sprite_sliceB));
	 sprite_romC ROM_enemyC(.addr(sprite_addrC), .data(sprite_sliceC));
	 ship_rom ROM_player(.addr(player_addr), .data(player_slice));
    
    // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;
    
    // Assign color based on is_ball signal
	 always_comb  begin
	 
		//if(count == 4'h1 || count == 4'h2 || count == 4'h3 ||count == 4'h6)
			sprite_addrA = { 5'b0, DrawY[4:2]};
			
		//else if(count == 4'h4 || count == 4'h5 || count == 4'h8)
			sprite_addrB = { 5'b0, DrawY[4:2]} + 8'h08;
			
		//else if(count == 4'h7 || count == 4'h9 || count == 4'ha)
			sprite_addrC = { 5'b0, DrawY[4:2]} + 8'h10;
			
		player_addr = {5'b0, DrawY[4:2]};
	 
	 
    
			
		//some default pixel values
		current_player_pixel = 1'b0;
	 	current_sprite_pixel = 1'b0;
	 
		//draw "press space"
		if(state == 4'h0) begin
			if(press_space_pixel && DrawX >= 10'h118 && DrawX < 10'h168 && DrawY >= 10'hd0 && DrawY < 10'h110) 
			begin
				Red = 4'hf;
				Blue = 4'hf;
				Green = 4'hf;
			end
			
			else 
			begin
				Red = 4'h0;
				Blue = 4'h0;
				Green = 4'h0;
			end
		end
		
		//draw "you win"
		else if(state == 4'hb) begin
			if(you_win_pixel && DrawX >= 10'h128 && DrawX < 10'h158 &&DrawY >= 10'hd0 && DrawY < 10'h110) 
			begin
				Red = 4'h0;
				Blue = 4'h0;
				Green = 4'hf;
			end
			
			else 
			begin
				Red = 4'h0;
				Blue = 4'hf;
				Green = 4'h0;
			end
		end
		
		//draw "game over"
		else if(state == 4'hc) begin
			if(game_over_pixel && DrawX >= 10'h120 && DrawX < 10'h160 && DrawY >= 10'hd0 && DrawY < 10'h110) 
			begin
				Red = 4'hf;
				Blue = 4'h0;
				Green = 4'h0;
			end
			
			else begin
				Red = 4'h0;
				Blue = 4'h7;
				Green = 4'h3;
			end
		
		end
	 
		//print the game logic
		
			
			//use for debugging - flashes block on screen
			//whenever event is true
			//else if(DrawX >= 10'd400 &&
			//DrawX < 10'd432 &&
			//DrawY >= 10'd0 &&
			//DrawY < 10'd32 &&
			//player_unkillable) begin
			//	Red = 4'hff;
			//	Green = 4'hff;
			//	Blue = 4'hff;
			//end
		 
			//Draw the enemies
			
			else if(count == 1 || count == 2 || count == 3 ||count == 6) begin
								//draw the health

				if(DrawY >= 10'h0 && DrawY < 10'h20 && DrawX >= 10'h70 && DrawX < 10'hA0) 
				begin
					if(current_health_pixel) 
					begin
						Red = 4'h0;
						Blue = 4'h0;
						Green = 4'h0;
					end
					
					else 
					begin
						Red = 4'hf;
						Blue = 4'h0;
						Green = 4'hf;
					end
				end
			 
				//draw the "health" text
				else if(DrawX >= 10'h0 && DrawX < 10'h70 && DrawY >= 10'b0 && DrawY < 10'h20)
				begin
					if(health_block_pixel) begin
						Red = 4'h0;
						Blue = 4'h0;
						Green = 4'h0;			
					end
					
					else begin
						Red = 4'hf;
						Blue = 4'h0;
						Green = 4'hf;
					end
				
				end
			 
				//draw the word "score"
				
				else if(DrawX >= 10'h1f0 && DrawX < 10'h250 && DrawY >= 10'd0 && DrawY < 10'h20) 
				begin
					if(score_text_pixel) 
					begin
						Red = 4'h0;
						Blue = 4'h0;
						Green = 4'h0;
					end
					
					else 
					begin
						Red = 4'hf;
						Blue = 4'h0;
						Green = 4'hf;
					end
				
				end
			 
				//draw the score
				else if(DrawX >= 10'h250 && DrawX < 10'h280 && DrawY >= 10'h0 && DrawY < 10'h20) 
				begin
					if(current_score_pixel) 
					begin
						Red = 4'h0;
						Blue = 4'h0;
						Green = 4'h0;
					end
					
					else 
					begin
						Red = 4'hf;
						Blue = 4'h0;
						Green = 4'hf;
					end
				end
				
				else if(DrawX >= 10'ha0 && DrawX < 10'h1f0 && DrawY >= 10'h0 && DrawY < 10'h20) 
				begin
					Red = 4'hf;
					Blue = 4'h0;
					Green = 4'hf;
				end
				
				else if (enemy_x_actual[5] == 1'b0 && 10'hE0 > DrawY && 10'h20 <= DrawY &&
						DrawX >= enemy_posX && enemy_status[enemy_x_actual[9:6]][DrawY[7:5] - 3'd1]) 
				begin				
						//sprite_addr = { 5'b0, DrawY[4:2]};
						current_sprite_pixel = sprite_sliceA[enemy_x_actual[4:2]];
						
						if(current_sprite_pixel == 1'b1) 
						begin
							Red = 4'hf;
							Blue = 4'hf;
							Green = 4'h0;
						end
						
						else 
						begin
							Red = 4'h0;
							Blue = 4'h0;
							Green = 4'h0;
						end	
				end
				
				//draw the enemy missile
				else if(missile_exists && DrawX[9:2] == missileX[9:2] && DrawY[9:2] == missileY[9:2]) 
				begin
					Red = 4'h0;
					Blue = 4'hf;
					Green = 4'hf;
				end
				
				//draw the player missile
				else if(pmissile_exists && DrawX[9:2] == pMissileX[9:2] && DrawY[9:2] == pMissileY[9:2]) 
				begin
					Red = 4'hf;
					Blue = 4'hf;
					Green = 4'hf;
				end
				
				//Draw the ship
				else if(DrawY >= 10'd448 &&
				DrawX >= player_pos &&
				DrawX < player_pos + 10'd64 &&
				!player_flash) begin
					//player_addr = {5'b0, DrawY[4:2]};
					current_player_pixel = player_slice[player_x_actual[5:2]];
					
					if(current_player_pixel == 1'b1) begin
						Red = 4'h0;
						Blue = 4'hf;
						Green = 4'hf;
					end
					
					else begin
						Red = 4'h0;
						Blue = 4'h0;
						Green = 4'h0;
					end
				
				end
				
				else begin
					Red = 4'h0;
					Blue = 4'hf;
					Green = 4'h0;
				end
			end
			
			else if(count == 4'h4 || count == 4'h5 || count == 4'h8) begin	
								//draw the health

				if(DrawY >= 10'h0 && DrawY < 10'h20 && DrawX >= 10'h70 && DrawX < 10'hA0) 
				begin
					if(current_health_pixel) 
					begin
						Red = 4'h0;
						Blue = 4'h0;
						Green = 4'h0;
					end
					
					else 
					begin
						Red = 4'hf;
						Blue = 4'h0;
						Green = 4'hf;
					end
				end
			 
				//draw the "health" text
				else if(DrawX >= 10'h0 && DrawX < 10'h70 && DrawY >= 10'b0 && DrawY < 10'h20)
				begin
					if(health_block_pixel) begin
						Red = 4'h0;
						Blue = 4'h0;
						Green = 4'h0;			
					end
					
					else begin
						Red = 4'hf;
						Blue = 4'h0;
						Green = 4'hf;
					end
				
				end
			 
				//draw the word "score"
				
				else if(DrawX >= 10'h1f0 && DrawX < 10'h250 && DrawY >= 10'd0 && DrawY < 10'h20) 
				begin
					if(score_text_pixel) 
					begin
						Red = 4'h0;
						Blue = 4'h0;
						Green = 4'h0;
					end
					
					else 
					begin
						Red = 4'hf;
						Blue = 4'h0;
						Green = 4'hf;
					end
				
				end
			 
				//draw the score
				else if(DrawX >= 10'h250 && DrawX < 10'h280 && DrawY >= 10'h0 && DrawY < 10'h20) 
				begin
					if(current_score_pixel) 
					begin
						Red = 4'h0;
						Blue = 4'h0;
						Green = 4'h0;
					end
					
					else 
					begin
						Red = 4'hf;
						Blue = 4'h0;
						Green = 4'hf;
					end
				end
				
				else if(DrawX >= 10'ha0 && DrawX < 10'h1f0 && DrawY >= 10'h0 && DrawY < 10'h20) 
				begin
					Red = 4'hf;
					Blue = 4'h0;
					Green = 4'hf;
				end

				else if (enemy_x_actual[5] == 1'b0 && 10'hE0 > DrawY && 10'h20 <= DrawY &&
					DrawX >= enemy_posX && enemy_status[enemy_x_actual[9:6]][DrawY[7:5] - 3'd1]) 
				begin	
					//sprite_addr = { 5'b0, DrawY[4:2]} + 8'h10;			
					current_sprite_pixel = sprite_sliceB[enemy_x_actual[4:2]];
						
						if(current_sprite_pixel == 1'b1) 
						begin
							Red = 4'hc;
							Blue = 4'he;
							Green = 4'hc;
						end
						
						else 
						begin
							Red = 4'h0;
							Blue = 4'h0;
							Green = 4'h0;
						end	
				end
				
				//draw the enemy missile
				else if(missile_exists && DrawX[9:2] == missileX[9:2] && DrawY[9:2] == missileY[9:2]) 
				begin
					Red = 4'hf;
					Blue = 4'h0;
					Green = 4'h0;
				end
				
				//draw the player missile
				else if(pmissile_exists && DrawX[9:2] == pMissileX[9:2] && DrawY[9:2] == pMissileY[9:2]) 
				begin
					Red = 4'hf;
					Blue = 4'hf;
					Green = 4'hf;
				end
				
				//Draw the ship
				else if(DrawY >= 10'd448 &&
				DrawX >= player_pos &&
				DrawX < player_pos + 10'd64 &&
				!player_flash) begin
					//player_addr = {5'b0, DrawY[4:2]};
					current_player_pixel = player_slice[player_x_actual[5:2]];
					
					if(current_player_pixel == 1'b1) begin
						Red = 4'h0;
						Blue = 4'hf;
						Green = 4'hf;
					end
					
					else begin
						Red = 4'h0;
						Blue = 4'h0;
						Green = 4'h0;
					end
				
				end
				
				else begin
					Red = 4'h0;
					Blue = 4'h0;
					Green = 4'h0;
				end
			end
			
			else if(count == 4'h7 || count == 4'h9 || count == 4'h10) begin	
								//draw the health

				if(DrawY >= 10'h0 && DrawY < 10'h20 && DrawX >= 10'h70 && DrawX < 10'hA0) 
				begin
					if(current_health_pixel) 
					begin
						Red = 4'h0;
						Blue = 4'h0;
						Green = 4'h0;
					end
					
					else 
					begin
						Red = 4'hf;
						Blue = 4'h0;
						Green = 4'hf;
					end
				end
			 
				//draw the "health" text
				else if(DrawX >= 10'h0 && DrawX < 10'h70 && DrawY >= 10'b0 && DrawY < 10'h20)
				begin
					if(health_block_pixel) begin
						Red = 4'h0;
						Blue = 4'h0;
						Green = 4'h0;			
					end
					
					else begin
						Red = 4'hf;
						Blue = 4'h0;
						Green = 4'hf;
					end
				
				end
			 
				//draw the word "score"
				
				else if(DrawX >= 10'h1f0 && DrawX < 10'h250 && DrawY >= 10'd0 && DrawY < 10'h20) 
				begin
					if(score_text_pixel) 
					begin
						Red = 4'h0;
						Blue = 4'h0;
						Green = 4'h0;
					end
					
					else 
					begin
						Red = 4'hf;
						Blue = 4'h0;
						Green = 4'hf;
					end
				
				end
			 
				//draw the score
				else if(DrawX >= 10'h250 && DrawX < 10'h280 && DrawY >= 10'h0 && DrawY < 10'h20) 
				begin
					if(current_score_pixel) 
					begin
						Red = 4'h0;
						Blue = 4'h0;
						Green = 4'h0;
					end
					
					else 
					begin
						Red = 4'hf;
						Blue = 4'h0;
						Green = 4'hf;
					end
				end
				
				else if(DrawX >= 10'ha0 && DrawX < 10'h1f0 && DrawY >= 10'h0 && DrawY < 10'h20) 
				begin
					Red = 4'hf;
					Blue = 4'h0;
					Green = 4'hf;
				end

				else if (enemy_x_actual[5] == 1'b0 && 10'hE0 > DrawY && 10'h20 <= DrawY &&
					DrawX >= enemy_posX && enemy_status[enemy_x_actual[9:6]][DrawY[7:5] - 3'd1]) 
				begin	
					//sprite_addr = { 5'b0, DrawY[4:2]} + 8'h10;			
					current_sprite_pixel = sprite_sliceC[enemy_x_actual[4:2]];
					
					if(current_sprite_pixel == 1'b1) 
					begin
						Red = 4'hf;
						Blue = 4'h0;
						Green = 4'hf;
					end
					
					else 
					begin
						Red = 4'h0;
						Blue = 4'h0;
						Green = 4'h0;
					end	
				end
				
				//draw the enemy missile
				else if(missile_exists && DrawX[9:2] == missileX[9:2] && DrawY[9:2] == missileY[9:2]) 
				begin
					Red = 4'hf;
					Blue = 4'hf;
					Green = 4'hf;
				end
				
				//draw the player missile
				else if(pmissile_exists && DrawX[9:2] == pMissileX[9:2] && DrawY[9:2] == pMissileY[9:2]) 
				begin
					Red = 4'hf;
					Blue = 4'hf;
					Green = 4'hf;
				end
				
				//Draw the ship
				else if(DrawY >= 10'd448 &&
				DrawX >= player_pos &&
				DrawX < player_pos + 10'd64 &&
				!player_flash) begin
					//player_addr = {5'b0, DrawY[4:2]};
					current_player_pixel = player_slice[player_x_actual[5:2]];
					
					if(current_player_pixel == 1'b1) begin
						Red = 4'h0;
						Blue = 4'hf;
						Green = 4'hf;
					end
					
					else begin
						Red = 4'h0;
						Blue = 4'h0;
						Green = 4'h0;
					end
				
				end
				
				else begin
					Red = 4'h0;
					Blue = 4'hf;
					Green = 4'h0;
				end
			end
			
		
		else begin
        //    // Background with nice color gradient
        //    //Red = 4'h3f; 
        //    //Green = 4'h00;
        //    //Blue = 4'h7f - {1'b0, DrawX[9:3]};
				Red = 4'h0;
				Blue = 4'hf;
				Green = 4'h0;
	  end
 end 
    
endmodule