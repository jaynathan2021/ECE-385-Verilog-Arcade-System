//enemy_controller.sv
//
//Responsible for controlling the behaviour of the enemy array

module enemy_controller
(
	input logic 			v_sync,
	input logic				reset,
	input logic	 [3:0]		state,count,
	output logic [9:0] 	enemy_posX,	//X offset of the enemy array
	output logic [9:0]	enemy_posY		//Y offset of the enemy array
);

logic x_movement;
logic y_movement;
logic spaz;
logic [11:0] x_pos;	//use a subpixel offset to allow for smooth, sloow
									//movement
logic [11:0] y_pos;

//assign x_pos = 12'b0;
//assign y_pos = 12'b0;

always_ff @ (posedge v_sync or posedge reset) begin

	//by default, don't change position
	x_pos = x_pos;
	y_pos = y_pos;

	if(reset) begin
		x_movement <= 1'b1;
		x_pos <= 12'h0;
		spaz <= 1'h0;

		y_movement <= 1'b1;
		y_pos <= 12'h0;
	end

	//update enemy possition
	else if(count <= 4'h1 || count == 4'h2 || count <= 4'h3 ||count == 4'h6) begin			
		//if(y_pos[11:2] >= 10'h20) begin
		//	y_pos = y_pos + 5;
		//end
		//else begin
			//if we're moving to the right, then move to the right
			//otherwise move to the left
			if(x_movement == 1'b1)
				x_pos = x_pos + 12'h001;
			else
				x_pos = x_pos - 12'h001;
			
			//if we're at the right side, then start moving to the left
			if(x_pos[11:2] >= 10'd32) begin
				x_pos[11:2] = 10'd32;
				x_movement = 1'b0;
			end
			//if we're at the left side, then start moving to the right
			if(x_pos[11:2] == 10'd0) begin
				x_movement = 1'b1;
			end

			
			if(y_movement == 1'b1)
				y_pos = y_pos + 12'h001;
			else
				y_pos = y_pos - 12'h001;

			//if we're at the top, then start moving down
			if(y_pos[11:2] >= 10'd20) begin
				y_pos[11:2] = 10'd20;
				y_movement = 1'b0;
			end
			//if we're at the bottom, then start moving up
			if(y_pos[11:2] == 10'd0) begin
				y_movement = 1'b1;
			end
		//end
	end
	
	else if(count == 4'h4 || count == 4'h5 || count == 4'h8) begin
	//	if(y_pos[11:2] >= 10'h20) begin
	//		y_pos = y_pos + 5;
	//	end
	//	else begin
	//		y_pos = y_pos + 2;
	//	end
	//end

	//else begin
	//	if(y_pos[11:2] >= 10'h20) begin
	//		y_pos = y_pos + 5;
	//	end
	//	else begin
			if(x_movement == 1)
				x_pos = x_pos + 12'h003;
			else
				x_pos = x_pos - 12'h003;
			//y_pos = y_pos + 1;

			//if we're at the right side, then start moving to the left
			if(x_pos[11:2] >= 10'd32) begin
				x_pos[11:2] = 10'd32;
				//y_pos = y_pos + 1;
				x_movement = 0;
			end
			//if we're at the left side, then start moving to the right
			if(x_pos[11:2] == 10'd0) begin
				//y_pos = y_pos + 1;
				x_movement = 1;
			end
	//	end
	end
	else begin
		if(spaz <= 1'hd)
			spaz = spaz + 3'h100;
		else
			spaz = 0;
		if(x_movement == 1)
				if(spaz <= 1'h8) begin
					x_pos = x_pos + 2'h002;
				end
				else
					x_pos = x_pos - 2'h001;
			else begin
				if(spaz <= 1'h8)
					x_pos = x_pos - 12'h002;
				else
					x_pos = x_pos + 2'h001;
					
			end
			//y_pos = y_pos + 1;

			//if we're at the right side, then start moving to the left
			if(x_pos[11:2] >= 10'd32) begin
				x_pos[11:2] = 10'd32;
				//y_pos = y_pos + 1;
				x_movement = 0;
			end
			//if we're at the left side, then start moving to the right
			if(x_pos[11:2] == 10'd0) begin
				//y_pos = y_pos + 1;
				x_movement = 1;
			end
	end
end

assign enemy_posX = x_pos[11:2];
assign enemy_posY = y_pos[11:2];


//always_comb begin

	////for one second, use the first animation.
	////for every other second, use the second
	////animation
	//if(counter < 8'd60)
	//	animation_offset = 8'd8;
	//else
	//	animation_offset = 8'd0;
		
//end

endmodule 