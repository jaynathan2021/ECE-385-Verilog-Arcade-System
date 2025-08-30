//enemy_status.sv
//
// keeps track of what enemies are still alive.
// records the data in a column-major array.




// class waves;
// 	rand bit [5:0] wave[9];
// 	rand bit [4:0] s;
//
// 	//int s;
// 	//task set(int n);
//     	//s = n;
//   	//endtask
// 	constraint wave_size {wave.sum() == s;}
// endclass


module enemy_status
(
	input		logic	reset,
	input		logic	clk,
	input		logic [6:0] enemy_hit,
	input		logic collision,
	input		logic [3:0] state,
	input		logic pulse, co,

	output	logic [9:0][5:0]	enemy_status,
	output	logic [3:0]			count
);

	logic [59:0] enemy_array;
	logic [59:0] sig;

	
	logic [9:0][5:0]	wave1;
	logic [9:0][5:0]	wave2;
	logic [9:0][5:0]	wave3;
	logic [9:0][5:0]	wave4;
	logic [9:0][5:0]	wave5;
	logic [9:0][5:0]	wave6;
	logic [9:0][5:0]	wave7;
	logic [9:0][5:0]	wave8;
	logic [9:0][5:0]	wave9;
	logic [9:0][5:0]	wave10;
			

	
	
	
	always_ff @ (posedge reset or posedge collision) //or posedge pulse or posedge state or posedge count) 
	begin
								
		if(reset) begin			
			enemy_status <= {
				6'b001000,
				6'b000000,
				6'b000000,
				6'b000010,
				6'b000000,
				6'b100000,
				6'b000001,
				6'b000000,
				6'b010000,
				6'b000000 
			};
			count <= 4'h1;
			// enemy_array <= {enemy_status[0], enemy_status[1], enemy_status[2], 
			// 			   enemy_status[3], enemy_status[4], enemy_status[5], 
			// 			   enemy_status[6], enemy_status[7], enemy_status[8], 
			// 			   enemy_status[9]};
		end
		
		else if(collision) begin
			//whenever there's a collision, kill the enemy
			enemy_status[enemy_hit[6:3]][enemy_hit[2:0]] <= 1'b0;
			// enemy_array <= {enemy_status[0], enemy_status[1], enemy_status[2], 
			// 	enemy_status[3], enemy_status[4], enemy_status[5], 
			// 	enemy_status[6], enemy_status[7], enemy_status[8], 
			// 	enemy_status[9]};
			sig <= sig + 1;
			if(sig == 4 && count ==  4'h1) begin
				wave2 <= {
					6'b001000,
					6'b000000,
					6'b100000,
					6'b100000,
					6'b000000,
					6'b010000,
					6'b000001,
					6'b000100,
					6'b000000,
					6'b000000 
				};
				enemy_status <= wave2;
				count <= 4'h2;
				sig <= 0;
			end
			else if(sig == 5 && count == 4'h2) begin
				wave3 <= {
					6'b000000,
					6'b000100,
					6'b000000,
					6'b010000,
					6'b000000,
					6'b000100,
					6'b000001,
					6'b000110,
					6'b000000,
					6'b000000 
				};
				enemy_status <= wave3;
				count <= 4'h3;
				sig <= 0;
			end
			else if(sig == 5 && count == 4'h3) begin
				wave4 <= {
					6'b000000,
					6'b000000,
					6'b000010,
					6'b000000,
					6'b001000,
					6'b000000,
					6'b000010,
					6'b000000,
					6'b001000,
					6'b000000 
				};
				enemy_status <= wave4;
				count <= 4'h4;
				sig <= 0;
			end
			else if(sig == 3 && count == 4'h4) begin
				wave5 <= {
					6'b000000,
					6'b001000,
					6'b000010,
					6'b000100,
					6'b000001,
					6'b010000,
					6'b000001,
					6'b001000,
					6'b000000,
					6'b000000 
				};
				enemy_status <= wave5;
				count <= 4'h5;
				sig <= 0;
			end
			else if(sig == 6 && count == 4'h5) begin
				wave6 <= {
					6'b100000,
					6'b000010,
					6'b010000,
					6'b000000,
					6'b000000,
					6'b101010,
					6'b000000,
					6'b000000,
					6'b000000,
					6'b010000 
				};
				enemy_status <= wave6;
				count <= 4'h6;
				sig <= 0;
			end
			else if(sig == 6 && count == 4'h6) begin
				wave7 <= {
					6'b001100,
					6'b000000,
					6'b110000,
					6'b000000,
					6'b000000,
					6'b000000,
					6'b101000,
					6'b000000,
					6'b000000,
					6'b010001 
				};
				enemy_status <= wave7;
				count <= 4'h7;
				sig <= 0;
			end
			else if(sig == 7 && count == 4'h7) begin
				wave8 <= {
					6'b000000,
					6'b010000,
					6'b000000,
					6'b100101,
					6'b000000,
					6'b010010,
					6'b000000,
					6'b000000,
					6'b000000,
					6'b000101
				};
				enemy_status <= wave8;
				count <= 4'h8;
				sig <= 0;
			end
			else if(sig == 7 && count == 4'h8) begin
				wave9 <= {
					6'b000000,
					6'b000000,
					6'b000000,
					6'b000000,
					6'b100001,
					6'b000000,
					6'b010001,
					6'b100001,
					6'b000000,
					6'b000101
				};
				enemy_status <= wave9;
				count <= 4'h9;
				sig <= 0;
			end
			else if(sig == 7 && count == 4'h9) begin
				wave10 <= {
					6'b101000,
					6'b100010,
					6'b010100,
					6'b000001,
					6'b000000,
					6'b100000,
					6'b000000,
					6'b001001,
					6'b100000,
					6'b000000 
				};
				enemy_status <= wave10;
				count <= 4'ha;
				sig <= 0;
			end
		end
		//else if(sig) begin
			// if(count == 4'h1) begin
			// 	enemy_status[0] <= 6'b101100;
			// 	enemy_status[1] <= 6'b001011;
			// 	enemy_status[2] <= 6'b110010;
			// 	enemy_status[3] <= 6'b000011;
			// 	enemy_status[4] <= 6'b001101;
			// 	enemy_status[5] <= 6'b101011;
			// 	enemy_status[6] <= 6'b101001;
			// 	enemy_status[7] <= 6'b010100;
			// 	enemy_status[8] <= 6'b101001;
			// 	enemy_status[9] <= 6'b010001;
			// 	enemy_array <= {enemy_status[0], enemy_status[1], enemy_status[2], 
			// 		enemy_status[3], enemy_status[4], enemy_status[5], 
			// 		enemy_status[6], enemy_status[7], enemy_status[8], 
			// 		enemy_status[9]};
			// 	count <= 4'h2;
			// end
		
		
			
		// else begin
		// 	case (state)
		// 		4'h1: begin
		// 			if(collision) begin
		// 				//whenever there's a collision, kill the enemy
		// 				enemy_status[enemy_hit[6:3]][enemy_hit[2:0]] <= 1'b0;
		// 			end
		// 			//count <= 4'h1;
		// 		end
		// 		4'h2: begin
		// 			if(collision) begin
		// 				//whenever there's a collision, kill the enemy
		// 				enemy_status[enemy_hit[6:3]][enemy_hit[2:0]] <= 1'b0;
		// 			end
					// enemy_status[0] <= 6'b101100;
					// enemy_status[1] <= 6'b001011;
					// enemy_status[2] <= 6'b110010;
					// enemy_status[3] <= 6'b000011;
					// enemy_status[4] <= 6'b001101;
					// enemy_status[5] <= 6'b101011;
					// enemy_status[6] <= 6'b101001;
					// enemy_status[7] <= 6'b010100;
					// enemy_status[8] <= 6'b101001;
					// enemy_status[9] <= 6'b010001;
		// 			//count <= 4'h2;
		// 		end
		// 	endcase
			// if(count <= 4'h0)
			// begin
		//	 	else if(pulse)begin
			// 		count <= 4'h1;
			// 	end
			// 	enemy_status[2] <= 6'b110010;
				// if(collision) begin
				// 	//wave1[enemy_hit[6:3]][enemy_hit[2:0]] <= 1'b0;
				// 	enemy_status[enemy_hit[6:3]][enemy_hit[2:0]] <= 1'b0;
			//	 end
			

		// else if(count == 4'h0) begin
		// 	enemy_status[2] <= 6'b110010;
		// 	count <= 4'h1;
		// end	
			// else if(enemy_array == 60'h0 && state == 2) begin
			// 	count <= 4'h1;
				// enemy_status <= {
				// 	6'b101100,
				// 	6'b001011,
				// 	6'b110010,
				// 	6'b000011,
				// 	6'b001101,
				// 	6'b101011,
				// 	6'b101001,
				// 	6'b010100,
				// 	6'b101001,
				// 	6'b010001 
				// };

			// 	wave3 <= {
			// 		6'b110100,
			// 		6'b110111,
			// 		6'b100100,
			// 		6'b101011,
			// 		6'b100101,
			// 		6'b101011,
			// 		6'b100101,
			// 		6'b101001,
			// 		6'b100011,
			// 		6'b010101 
			// 	};

			// 	wave4 <= {
			// 		6'b101100,
			// 		6'b011011,
			// 		6'b001001,
			// 		6'b000101,
			// 		6'b000101,
			// 		6'b010111,
			// 		6'b001101,
			// 		6'b000001,
			// 		6'b101011,
			// 		6'b000101 
			// 	};

			// 	wave5 <= {
			// 		6'b001010,
			// 		6'b001011,
			// 		6'b100110,
			// 		6'b010011,
			// 		6'b101001,
			// 		6'b100011,
			// 		6'b010011,
			// 		6'b100101,
			// 		6'b001010,
			// 		6'b100101 
			// 	};

			// 	wave6 <= {
			// 		6'b110100,
			// 		6'b000111,
			// 		6'b010100,
			// 		6'b000111,
			// 		6'b101101,
			// 		6'b100111,
			// 		6'b010011,
			// 		6'b101001,
			// 		6'b101001,
			// 		6'b001001 
			// 	};

			// 	wave7 <= {
					// 6'b101100,
					// 6'b110011,
					// 6'b000110,
					// 6'b111101,
					// 6'b100001,
					// 6'b110011,
					// 6'b010001,
					// 6'b100001,
					// 6'b110001,
					// 6'b000101 
			// 	};

			// 	wave8 <= {
					// 6'b101000,
					// 6'b100010,
					// 6'b010111,
					// 6'b010011,
					// 6'b101011,
					// 6'b100101,
					// 6'b111101,
					// 6'b100001,
					// 6'b100001,
					// 6'b010101 
			// 	};

			// 	wave9 <= {
			// 		6'b101100,
			// 		6'b111011,
			// 		6'b010010,
			// 		6'b110011,
			// 		6'b100101,
			// 		6'b111011,
			// 		6'b010011,
			// 		6'b001001,
			// 		6'b100101,
			// 		6'b000101
			// 	};

			// 	wave10 <= {
			// 		6'b101101,
			// 		6'b111011,
			// 		6'b001010,
			// 		6'b101011,
			// 		6'b110101,
			// 		6'b100111,
			// 		6'b010101,
			// 		6'b101001,
			// 		6'b100101,
			// 		6'b000101 
			// 	};
				// enemy_array <= {enemy_status[0], enemy_status[1], enemy_status[2], 
				// 		   enemy_status[3], enemy_status[4], enemy_status[5], 
				// 		   enemy_status[6], enemy_status[7], enemy_status[8], 
				// 		   enemy_status[9]};
			// end

			
			 //else if(co)
			//begin
				//if(pulse) begin
					// enemy_status[0] <= 6'b101100;
					// enemy_status[1] <= 6'b001011;
					// enemy_status[2] <= 6'b110010;
					// enemy_status[3] <= 6'b000011;
					// enemy_status[4] <= 6'b001101;
					// enemy_status[5] <= 6'b101011;
					// enemy_status[6] <= 6'b101001;
					// enemy_status[7] <= 6'b010100;
					// enemy_status[8] <= 6'b101001;
					// enemy_status[9] <= 6'b010001;
					// count <= 4'h2;
				// end 
				
				//if(collision) begin
					//enemy_status[enemy_hit[6:3]][enemy_hit[2:0]] <= 1'b0;
				//end
			// end
	//		
	//		else if(state <= 3)
	//		begin
	//			enemy_status = wave3;
	//			if(collision) begin
	//				enemy_status[enemy_hit[6:3]][enemy_hit[2:0]] <= 1'b0;
	//			end
	//		end
	//
	//		else if(state <= 4)
	//		begin
	//			enemy_status = wave4;
	//			if(collision) begin
	//				enemy_status[enemy_hit[6:3]][enemy_hit[2:0]] <= 1'b0;
	//			end
	//		end
	//
	//		else if(state <= 5)
	//		begin
	//			enemy_status = wave5;
	//			if(collision) begin
	//				enemy_status[enemy_hit[6:3]][enemy_hit[2:0]] <= 1'b0;
	//			end
	//		end
	//
	//		else if(state <= 6)
	//		begin
	//			enemy_status = wave6;
	//			if(collision) begin
	//				enemy_status[enemy_hit[6:3]][enemy_hit[2:0]] <= 1'b0;
	//			end
	//		end
	//
	//		else if(state <= 7)
	//		begin
	//			enemy_status = wave7;
	//			if(collision) begin
	//				enemy_status[enemy_hit[6:3]][enemy_hit[2:0]] <= 1'b0;
	//			end
	//		end
	//
	//	 	else if(state <= 8)
	//	 	begin
	//	 		enemy_status = wave8;
	//			if(collision) begin
	//				enemy_status[enemy_hit[6:3]][enemy_hit[2:0]] <= 1'b0;
	//	 		end
	//	 	end
	//
	//		else if(state <= 9)
	//	 	begin
	//	 		enemy_status = wave9;
	//	 		if(collision) begin
	//	 			enemy_status[enemy_hit[6:3]][enemy_hit[2:0]] <= 1'b0;
	//	 		end
	//	 	end
	//
	//	 	else if(state <= 10)
	//	 	begin
	//	 		enemy_status = wave10;
	//	 		if(collision) begin
	//	 			enemy_status[enemy_hit[6:3]][enemy_hit[2:0]] <= 1'b0;
	//	 		end
	//	 	end
	 
		//end
	end

endmodule 