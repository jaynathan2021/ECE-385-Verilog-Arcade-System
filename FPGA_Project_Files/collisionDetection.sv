// collision_detection
//
// Responsible for detecting collisions between missiles
// hitting either the player or an enemy. Whenever one is
// hit, pcollision (player collision) or ecollision (enemy
// collision) is set high for one clock cycle of vsync. 

module collision_detection
(
	input logic reset,
	input logic vsync,
	
	input logic [9:0] pmissileX,	//player missile X
	input logic [9:0] pmissileY,	//player missile Y

	input logic [9:0] emissileX,	//enemy missile X
	input logic [9:0] emissileY,	//enemy missile Y
	
	input logic [9:0] playerX,		//left X coord of player
	
	output	logic [6:0] enemy_hit,	//index of enemy that has been hit
	
	input logic [9:0] enemy_posX,	//top left x coordinate of enemy array
	input	logic [9:0][5:0] 	enemy_status,	//array of living enemies
	
	output logic pcollision,		//flag signifying player has been hit
	output logic ecollision			//flag signifying enemy has been hit
);

	logic [9:0] pmissile_normalized;
	logic [9:0] player_xmax;

	logic [9:0] playerYminRange;
	logic [9:0] playerYmaxRange;

	logic [9:0] ySlice1;
	logic [9:0] ySlice2;
	logic [9:0] ySlice3;
	logic [9:0] ySlice4;
	logic [9:0] ySlice5;
	logic [9:0] ySlice6;

	always_comb 
	begin
	
		pmissile_normalized = pmissileX - enemy_posX;
		player_xmax = playerX + 10'd64;

		playerYminRange = 10'd452;
		playerYmaxRange = 10'd480;

		ySlice1 = 10'd63;
		ySlice2 = 10'd95;
		ySlice3 = 10'd127;
		ySlice4 = 10'd159;
		ySlice5 = 10'd191;
		ySlice6 = 10'd223;

		// ySlice7 = 10'd255;
		// ySlice8 = 10'd287;
		// ySlice9 = 10'd319;
		//ySlice10 = 10'd351;
		//ySlice11 = 10'd393;
		//ySlice12 = 10'd432;
	
	end

	always_ff @ (posedge vsync or posedge reset) 
	begin
		if(reset) 
		begin
			pcollision = 1'b0;
			ecollision = 1'b0;
		end
		
		else 
		begin
			//check for enemy collision with player missile
				
			// Y row start => middle of row
			// 32   => 	48
			// 64	=> 	80
			// 96	=> 	112
			// 128	=> 	144
			// 160	=> 	176
			// 192	=> 	208
			// 224
			
			//ensure the pcollision and ecollision flags
			//are only high for a single vsync cycle
			if(pcollision && ecollision)begin
				pcollision = 1'b0;
				ecollision = 1'b0;
			end
			else if(pcollision)
				pcollision = 1'b0;

			if(ecollision)begin
				ecollision = 1'b0;
			end

			

			//check if there's a collission between the player
			//missile and one of the enemies. Check at eeach
			//of the 6 levels
			if(pmissileY[9:5] == ySlice1[9:5] && pmissile_normalized[5] == 1'b0 && enemy_status[pmissile_normalized[9:6]][ySlice1[7:5] - 3'd1]) 
			begin 
				enemy_hit = { pmissile_normalized[9:6], ySlice1[7:5] - 3'd1 };
				ecollision = 1'b1;
			end
			
			
			else if(pmissileY[9:5]	== ySlice2[9:5] && pmissile_normalized[5] == 1'b0 && enemy_status[pmissile_normalized[9:6]][ySlice2[7:5] - 3'd1]) 
			begin	
				enemy_hit = { pmissile_normalized[9:6], ySlice2[7:5] - 3'd1 };
				ecollision = 1'b1;
			end
			
			
			else if(pmissileY[9:5]	== ySlice3[9:5] && pmissile_normalized[5] == 1'b0 && enemy_status[pmissile_normalized[9:6]][ySlice3[7:5] - 3'd1]) 
			begin			
				enemy_hit = { pmissile_normalized[9:6], ySlice3[7:5] - 3'd1 };
				ecollision = 1'b1;
			end
			
			
			else if(pmissileY[9:5]	== ySlice4[9:5] && pmissile_normalized[5] == 1'b0 && enemy_status[pmissile_normalized[9:6]][ySlice4[7:5] - 3'd1]) 
			begin
				enemy_hit = { pmissile_normalized[9:6], ySlice4[7:5] - 3'd1 };
				ecollision = 1'b1;
			end
			
			
			else if(pmissileY[9:5]	== ySlice5[9:5] && pmissile_normalized[5] == 1'b0 && enemy_status[pmissile_normalized[9:6]][ySlice5[7:5] - 3'd1]) 
			begin
				enemy_hit = { pmissile_normalized[9:6], ySlice5[7:5] - 3'd1 };
				ecollision = 1'b1;

			end
			
			
			else if(pmissileY[9:5] == ySlice6[9:5] && pmissile_normalized[5] == 1'b0 && enemy_status[pmissile_normalized[9:6]][ySlice6[7:5] - 3'd1]) 
			begin
				enemy_hit = { pmissile_normalized[9:6], ySlice6[7:5] - 3'd1 };
				ecollision = 1'b1;
			end
			


	
			//yslice7-10:
			// else if(pmissileY[9:5]	== ySlice7[9:5] && pmissile_normalized[5] == 1'b0 && enemy_status[pmissile_normalized[9:6]][ySlice7[7:5] - 3'd1]) 
			// begin			
			// 	enemy_hit = { pmissile_normalized[9:6], ySlice7[7:5] - 3'd1 };
			// 	ecollision = 1'b1;
			// end
			
			
			// else if(pmissileY[9:5]	== ySlice8[9:5] && pmissile_normalized[5] == 1'b0 && enemy_status[pmissile_normalized[9:6]][ySlice8[7:5] - 3'd1]) 
			// begin
			// 	enemy_hit = { pmissile_normalized[9:6], ySlice8[7:5] - 3'd1 };
			// 	ecollision = 1'b1;
			// end
			
			
			// else if(pmissileY[9:5]	== ySlice9[9:5] && pmissile_normalized[5] == 1'b0 && enemy_status[pmissile_normalized[9:6]][ySlice9[7:5] - 3'd1]) 
			// begin
			// 	enemy_hit = { pmissile_normalized[9:6], ySlice9[7:5] - 3'd1 };
			// 	ecollision = 1'b1;

			// end
			
			
			// else if(pmissileY[9:5] == ySlice10[9:5] && pmissile_normalized[5] == 1'b0 && enemy_status[pmissile_normalized[9:6]][ySlice10[7:5] - 3'd1]) 
			// begin
			// 	enemy_hit = { pmissile_normalized[9:6], ySlice10[7:5] - 3'd1 };
			// 	ecollision = 1'b1;
			// end



			// else if(pmissileY[9:5] == ySlice11[9:5] && pmissile_normalized[5] == 1'b0 && enemy_status[pmissile_normalized[9:6]][ySlice11[7:5] - 3'd1]) 
			// begin
			// 	enemy_hit = { pmissile_normalized[9:6], ySlice11[7:5] - 3'd1 };
			// 	ecollision = 1'b1;
			// end

			// else if(pmissileY[9:5] == ySlice12[9:5] && pmissile_normalized[5] == 1'b0 && enemy_status[pmissile_normalized[9:6]][ySlice12[7:5] - 3'd1]) 
			// begin
			// 	enemy_hit = { pmissile_normalized[9:6], ySlice12[7:5] - 3'd1 };
			// 	ecollision = 1'b1;
			// end

			//check for collision between enemy misile and player
			if(emissileY >= 10'd452 && emissileY < 10'd480 && emissileX >= playerX && emissileX <= player_xmax)begin
				if(emissileX >= playerX)
				begin
					if(emissileX <= player_xmax)
						pcollision = 1'b1;
				end
			end
			
		end
	
	end


endmodule 