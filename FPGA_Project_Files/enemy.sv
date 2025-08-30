//enemy_controller.sv
//
//Responsible for controlling the behaviour of the enemy array

module enemy_controller
(
	input logic 			v_sync,
	input logic				reset,
	output logic [7:0] 	animation_offset,	//Selects which enemy animation to use
	output logic [9:0]	enemy_offset		//X offset of the enemy array
);


logic [7:0] counter;
logic count_up_offset;
logic [11:0] subpixel_offset;	//use a subpixel offset to allow for smooth, sloow
										//movement

always_ff @ (posedge v_sync or posedge reset) begin

	//by default, don't change position
	subpixel_offset = subpixel_offset;

	if(reset) begin
		count_up_offset <= 1'b1;
		subpixel_offset <= 12'd0;
		counter <= 8'd0;
	end

	//update enemy possition
	else begin
		//set a counter to know what enemy animation
		//frame we should use.
		counter = counter + 8'd1;
		if(counter >= 8'd120)
			counter = 8'd0;
			
		//if we're moving to the right, then move to the right
		if(count_up_offset)
			subpixel_offset = subpixel_offset + 12'h001;
		//otherwise move to the left
		else
			subpixel_offset = subpixel_offset - 12'h001;
			
		//if we're at the right side, then start moving to the left
		if(subpixel_offset[11:2] >= 10'd32) begin
			subpixel_offset[11:2] = 10'd32;
			count_up_offset = 1'b0;
		end
		//if we're at the left side, then start moving to the right
		if(subpixel_offset[11:2] == 10'd0) begin
			count_up_offset = 1'b1;
		end
	end
		
end

assign enemy_offset = subpixel_offset[11:2];


always_comb begin

	//for one second, use the first animation.
	//for every other second, use the second
	//animation
	if(counter < 8'd60)
		animation_offset = 8'd8;
	else
		animation_offset = 8'd0;
		
end

endmodule 


//enemy_missile.sv
//
//responsible for controlling when an enemy
//creates a new missile and controls it's
//movement. The enemy that is closest to the
//left side of the player's ship is the one
//that shoots a missile every 2 seconds

module enemy_missile
(
	input		logic				reset,
	input		logic	[9:0]		playerX,				//player left X coordinate
	input		logic [9:0][5:0] 	enemy_status,	//enemies that are still alive
	input		logic				vsync,				//vsync signal
	input		logic [9:0]		enemy_offset,		//offset of the enemy array
	input		logic [3:0]		state,
	
	
	output	logic				exists,				//whether or not the enemy missile exists
	output 	logic	[9:0]		missileX,			//enemy missile X position
	output	logic	[9:0]		missileY				//enemy missile Y position
);

	logic [7:0] missile_timer;		//counts two seconds between every missile shot
	logic [5:0] enemy_column;
	logic [3:0] column_index;
	
	always_ff @ (posedge vsync or posedge reset) begin

		if(reset) begin
			missile_timer = 8'd0;
			exists = 1'b0;
		end
		
		else if(state != 4'd1) begin
			missile_timer = 8'd0;
			exists = 1'b0;
		end
		
		else begin
		
			missileX = missileX;
		
			//wait for when we can send the next missile
			if(missile_timer < 8'd120 && !exists) begin
				missile_timer = missile_timer + 8'd1;
			end
			
			//if it's time, create the missile (if we can)
			else if(!exists && missile_timer >= 8'd120) begin
			
				//have a missile shoot out from the middle
				//of the enemy
				missileX = {column_index, 6'b0} + enemy_offset + 10'd16;
				missile_timer = 8'd0;
			
				//choose the Y position to create it from, depending
				//on what the lowest enemy that is still alive
				//in the nearest column of enemies.
				if(enemy_column[5]) begin
					exists = 1'b1;
					missileY = 10'd224;
				end
				
				else if(enemy_column[4]) begin
					exists = 1'b1;
					missileY = 10'd192;
				end
				
				else if(enemy_column[3]) begin
					exists = 1'b1;
					missileY = 10'd160;
				end
				
				else if(enemy_column[2]) begin
					exists = 1'b1;
					missileY = 10'd128;
				end
				
				else if(enemy_column[1]) begin
					exists = 1'b1;
					missileY = 10'd96;
				end
				
				else if(enemy_column[0]) begin
					exists = 1'b1;
					missileY = 10'd64;
				end
				
			end
			
			//check for collision
			else if (missileY >= 480) begin
				
				exists = 1'b0;
				
			end
			
			//otherwise update y position
			else if(exists) begin
				
				missileY = missileY + 10'd3;
				
			end
							
		end
		
	end
	
	always_comb begin
	
		column_index = playerX[9:6];
		enemy_column = enemy_status[column_index];

	end

endmodule 


//enemy_status.sv
//
// keeps track of what enemies are still alive.
// records the data in a column-major array.

module enemy_status
(
	input		logic	reset,
	input		logic [6:0] enemy_hit,
	input		logic collision,

	output	logic [9:0][5:0]	enemy_status
);

	always_ff @ (posedge reset or posedge collision) begin
		
		if(reset) begin
			enemy_status <= {
			6'b111111,
			6'b111111,
			6'b111111,
			6'b111111,
			6'b111111,
			6'b111111,
			6'b111111,
			6'b111111,
			6'b111111,
			6'b111111 
			};
		end
		
		//whenever there's a collision, kill the enemy
		else if(collision) begin
			enemy_status[enemy_hit[6:3]][enemy_hit[2:0]] <= 1'b0;
		end
		
	end

endmodule 