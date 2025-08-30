//DOCKER SUCKS

module health_map
(
	input logic 		vsync,
	input logic 		reset,
	input logic [5:0] X,
	input logic	[3:0] Y,

	input logic player_collision,
	
	output logic pixel
);

	logic [3:0] health_hundreds;
	logic [3:0] health_tens;
	//logic [3:0] health_ones;
    logic [3:0] check;
	
	logic [7:0] number_slice;
	logic [7:0] number_address;
	
	number_rom rom_instance(.address(number_address), .data(number_slice));
	
	assign pixel = number_slice[3'b111 - X[2:0]];
	
	always_ff @ (posedge reset or posedge player_collision) begin
		if(reset) begin
			health_hundreds = 4'h1;
			health_tens = 4'h0;
			check = 4'h0;
		end
		
		else if(player_collision) begin
			//whenever we hit an enemy, increment the health count
			if(health_hundreds == 4'h1)begin
				health_hundreds = 4'h0;
				health_tens = 4'h8;
				check = 4'h1;
			end

			//check for carry
         	//else if(health_hundreds == 4'h0 && check == 4'h0) begin
			//	health_hundreds = 4'h0;
            //	check = check + 4'h1;
            //	health_tens = 4'h8;
			//end
			
			else if(health_tens > 4'h0 && check)
            	health_tens = health_tens - 4'h2;

			else if(health_tens == 4'h0) begin
				health_tens = 4'h0;
				check = 4'h0;
			end
			
			//keep things the same by default
			//else begin
				health_hundreds = health_hundreds;
				health_tens = health_tens;
			//end	

		end
		
	end

	always_comb begin
	
		//choose which health to print
		if(X >= 6'd0 && X < 6'd8) begin
			number_address = {health_hundreds, 4'b0} + Y;
		end
		
		else if(X >= 6'd8 && X < 6'd16) begin
			number_address = {health_tens, 4'b0} + Y;
		end
		
		else begin
			number_address = 4'b0 + Y;
		end

	end
	
endmodule 