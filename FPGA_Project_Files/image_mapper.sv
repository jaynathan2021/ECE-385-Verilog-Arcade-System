module image_mapper (
  input clk,
  input [9:0] DrawX,
  input [9:0] DrawY,
  output logic [7:0] Red,
  output logic [7:0] Green,
  output logic [7:0] Blue
);

  logic [18:0] read_address;
  logic [7:0] mem [307200];
  logic [7:0] outpt;
  logic [7:0] mem2 [307200];
  logic [31:0] bruhfrfrnocap;
  logic go;

initial begin
  $readmemh("C:/Users/jayna/Downloads/bruh1.hex", mem);
  $readmemh("C:/Users/jayna/Downloads/bruh2.hex", mem2);
  go=0;
end
always_ff @ (posedge clk)
	begin
		bruhfrfrnocap=bruhfrfrnocap+1;
		if (bruhfrfrnocap==300000)
			begin
			go=1;
			end
		if (bruhfrfrnocap%600000==0)
			begin
			go=0;
			end
	end
	always_comb begin
	if (go==0)
		begin
		read_address = DrawY * 640 + DrawX;
		Red = mem[read_address];
		Green = mem[read_address];
		Blue = mem[read_address];
		end
	else
		begin
		read_address = DrawY * 640 + DrawX;
		Red = mem2[read_address];
		Green = mem2[read_address];
		Blue = mem2[read_address];
		end
		
	end 
  
endmodule