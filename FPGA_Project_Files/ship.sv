module ship_rom
(
	input 	[7:0] addr,
	output 	[15:0] data
);

	parameter[0:7][15:0] ROM = {
	
		16'b0000000110000000,	//0        ██
		16'b0000001111000000,	//1       ████       
		16'b0000011001100000,	//2      ██  ██     
		16'b0000111111110000,	//3     ████████
		16'b0100110110110010,	//4  █  ██ ██ ██  █
		16'b0101110110111010,	//5  █ ███ ██ ███ █
		16'b0111010110101110,	//6  ███ █ ██ █ ███
		16'b0100010000100010	//7  █   █    █   █
	
	};
	
	assign data = ROM[addr];

endmodule 

// enemy sprite_rom.sv


module sprite_romA
(
	input 	[7:0] addr,
	output 	[7:0] data
);

	logic[7:0] addr_reg;

	parameter [0:8][7:0] ROM = {

		8'b11000011, //0 ██    ██
		8'b00100100, //1 █ █  █ █
		8'b00111100, //2   ████  
		8'b11111111, //3 ████████
		8'b00100100, //4   █  █  
		8'b00011000, //5    ██   
		8'b00000000, //6 
		8'b00000000, //7 
		
	};

	assign data = ROM[addr];
	
endmodule 

module sprite_romB
	(
		input 	[7:0] addr,
		output 	[7:0] data
	);
	
		logic[7:0] addr_reg;
	
		parameter [0:8][7:0] ROM = {
				
			8'b00000000, //8      
			8'b00111100, //9    ████  
			8'b01011010, //10  █ ██ █
			8'b11111111, //11 ████████
			8'b10100101, //12 █ █  █ █
			8'b00111100, //13   ████  
			8'b00011000, //14    ██  
			8'b00000000, //15 
			
		};
	
		assign data = ROM[addr];
		
	endmodule 

	module sprite_romC
		(
			input 	[7:0] addr,
			output 	[7:0] data
		);
		
			logic[7:0] addr_reg;
		
			parameter [0:8][7:0] ROM = {
						
				8'b00011000, //16    ██   
				8'b10111101, //17 █ ████ █ 
				8'b10100101, //18 █ █  █ █
				8'b11000011, //19 ██    ██
				8'b10100101, //20 █ █  █ █
				8'b10111101, //21 █ ████ █
				8'b00011000, //22    ██  
				8'b00000000, //23
				
			};
		
			assign data = ROM[addr];
			
		endmodule 