// player.sv
//
// Controls player's space ship, 
// and allows for user control

module player
(
	input logic reset,
	input logic vsync,
	input logic [7:0] keycode,			//code from the keyboard
	input logic pcollision,				//check if we're hit by an enemy missile
	
	output logic pmissile_create,		//command to create new player missile
	output logic player_flash,			//choose to flash whenever ship has post-hit invincibility
	output logic [9:0] x_pos,			//left X position of player's ship
	output logic [2:0] health,			//number of health left
	output logic player_unkillable
);

	// w = 8'd26
	// a = 8'd4
	// s = 8'd22
	// d = 8'd7
	// space = 8'd44
	
	logic [11:0] subpixel_position;
	logic invincible;
	logic [9:0] invincible_counter;
	
	assign player_flash = invincible_counter[2];
	
	always_ff @ (posedge vsync or posedge reset) begin
	
		subpixel_position = subpixel_position;
	
		if(reset) begin
			subpixel_position[11:2] = 10'd288;
			pmissile_create = 1'b0;
			health = 3'h5;
			invincible = 1'b0;
			invincible_counter = 9'b0;
			player_unkillable = 1'b0;
		end
		
		else begin
		
			//if we're hit by a missile, we're not invincible, and we
			//still have health left, remove a life, and make us
			//temporarily invincible.
			if(pcollision && health > 3'b0 && !invincible) begin
				health = health - 3'b1;
				invincible = 1'b1;
				invincible_counter = 9'b0;
				player_unkillable = 1'b1;
			end
			//if we're invincible, decrement the invincibility counter
			else if(invincible && invincible_counter <= 9'hF0) begin
				invincible_counter = invincible_counter + 9'b1;
				player_unkillable = 1'b1;
			end
			//if the invincibility counter runs out, reset everything
			else begin
				invincible_counter = 9'b0;
				invincible = 1'b0;
				player_unkillable = 1'b0;
			end
							
			//move left whenever a is pressed				
			if(keycode == 8'd4)
				subpixel_position = subpixel_position - 12'd6;
			//move right whenever d is pressed 
			else if(keycode == 8'd7)
				subpixel_position = subpixel_position + 12'd6;
			//if space is pressed, shoot a missile
			else if(keycode == 8'd44)
				pmissile_create = 1'b1;
			//otherwise do nothing
			else
				pmissile_create = 1'b0;
			
			//check the left bound
			if(subpixel_position[11:2] == 10'd0)
				subpixel_position = 12'd0;
			
			//check for overflow
			else if(subpixel_position[11:2] >= 10'd999)
				subpixel_position = 12'd0;
			
			//check the right bound
			else if(subpixel_position[11:2] > 10'd576)
				subpixel_position[11:2] = 10'd576;
			
		end
	
	end
	
	assign x_pos = subpixel_position[11:2];
	
endmodule 


//player_missile.sv
//
//controls the missile fired by the player.
//can only have one on the screen at any
//given time.

module player_missile
(
	input		logic			reset,
	input		logic	[9:0]	playerx,			//X coord of left side of player's ship
	input		logic			vsync,			//vsync clock signal
	input		logic			create,			//set high whenever a creation request is made
	input		logic			has_collided,	//set high whenever a collision occurs
	
	output	logic exists,						//set high whenever missile exists
	output	logic [9:0]	playerMissileX,	//X coord
	output	logic [9:0] playerMissileY		//Y coord
);

	logic creation_flag;

	always_ff @ (posedge vsync or posedge reset) begin
	
		playerMissileX = playerMissileX;
		playerMissileY = playerMissileY;
	
		if(reset) begin
			exists = 1'b0;
			playerMissileX = 10'd0;
			playerMissileY = 10'd0;
		end
	
		else begin
			
			//if create is high, set the creation flag to 1
			//to signal we want to make a new missile
			if(create) begin
				creation_flag = 1'b1;
			end
			
			//make sure that the flag is only set whenever we have 
			//create held high, so not to queue input.
			else begin
				creation_flag = 1'b0;
			end
			
			//if we have collided, then erase the missile
			if(has_collided) begin
				exists = 1'b0;
			end
			
			//create a new missile if create flag is high 
			//and a missile doesn't already exist
			else if(creation_flag && !exists) begin
				exists = 1'b1;
				playerMissileX = playerx + 10'd30;
				playerMissileY = 10'd448;
			end
			
			//if we go out of bounds, delete the missile
			else if(exists && playerMissileY == 10'd0) begin
				exists = 1'b0;
			end
			
			//otherwise update the missile's position
			else if(exists) begin
				playerMissileY = playerMissileY - 10'd4;
			end
		
		end
	
	end
	
	always_comb begin
	
	
	
	end

endmodule
