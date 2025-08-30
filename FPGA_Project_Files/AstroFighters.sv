//-------------------------------------------------------------------------
//                                                                       --
//                                                                       --
//      For use with ECE 385 Lab 62                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module AstroFighters (

      ///////// Clocks /////////
      input     MAX10_CLK1_50, 

      ///////// KEY /////////
      input    [ 1: 0]   KEY,

      ///////// SW /////////
      input    [ 9: 0]   SW,

      ///////// LEDR /////////
      output   [ 9: 0]   LEDR,

      ///////// HEX /////////
      output   [ 7: 0]   HEX0,
      output   [ 7: 0]   HEX1,
      output   [ 7: 0]   HEX2,
      output   [ 7: 0]   HEX3,
      output   [ 7: 0]   HEX4,
      output   [ 7: 0]   HEX5,

      ///////// SDRAM /////////
      output             DRAM_CLK,
      output             DRAM_CKE,
      output   [12: 0]   DRAM_ADDR,
      output   [ 1: 0]   DRAM_BA,
      inout    [15: 0]   DRAM_DQ,
      output             DRAM_LDQM,
      output             DRAM_UDQM,
      output             DRAM_CS_N,
      output             DRAM_WE_N,
      output             DRAM_CAS_N,
      output             DRAM_RAS_N,

      ///////// VGA /////////
      output             VGA_HS,
      output             VGA_VS,
      output   [ 3: 0]   VGA_R,
      output   [ 3: 0]   VGA_G,
      output   [ 3: 0]   VGA_B,


      ///////// ARDUINO /////////
      inout    [15: 0]   ARDUINO_IO,
      inout              ARDUINO_RESET_N 

);




logic Reset_h, vssig, blank, sync, VGA_Clk;


//=======================================================
//  REG/WIRE declarations
//=======================================================
	logic SPI0_CS_N, SPI0_SCLK, SPI0_MISO, SPI0_MOSI, USB_GPX, USB_IRQ, USB_RST;
	logic [3:0] hex_num_4, hex_num_3, hex_num_1, hex_num_0; //4 bit input hex digits
	logic [1:0] signs;
	logic [1:0] hundreds;
	logic [9:0] drawxsig, drawysig;
	logic [3:0] Red, Blue, Green;
	logic [7:0] keycode;

//=======================================================
//  Structural coding
//=======================================================
	assign ARDUINO_IO[10] = SPI0_CS_N;
	assign ARDUINO_IO[13] = SPI0_SCLK;
	assign ARDUINO_IO[11] = SPI0_MOSI;
	assign ARDUINO_IO[12] = 1'bZ;
	assign SPI0_MISO = ARDUINO_IO[12];
	
	assign ARDUINO_IO[9] = 1'bZ; 
	assign USB_IRQ = ARDUINO_IO[9];
		
	//Assignments specific to Circuits At Home UHS_20
	assign ARDUINO_RESET_N = USB_RST;
	assign ARDUINO_IO[7] = USB_RST;//USB reset 
	assign ARDUINO_IO[8] = 1'bZ; //this is GPX (set to input)
	assign USB_GPX = 1'b0;//GPX is not needed for standard USB host - set to 0 to prevent interrupt
	
	//Assign uSD CS to '1' to prevent uSD card from interfering with USB Host (if uSD card is plugged in)
	assign ARDUINO_IO[6] = 1'b1;
	
	//HEX drivers to convert numbers to HEX output
	HexDriver hex_driver4 (hex_num_4, HEX4[6:0]);
	assign HEX4[7] = 1'b1;
	
	HexDriver hex_driver3 (hex_num_3, HEX3[6:0]);
	assign HEX3[7] = 1'b1;
	
	HexDriver hex_driver1 (hex_num_1, HEX1[6:0]);
	assign HEX1[7] = 1'b1;
	
	HexDriver hex_driver0 (hex_num_0, HEX0[6:0]);
	assign HEX0[7] = 1'b1;
	
	//fill in the hundreds digit as well as the negative sign
	assign HEX5 = {1'b1, ~signs[1], 3'b111, ~hundreds[1], ~hundreds[1], 1'b1};
	assign HEX2 = {1'b1, ~signs[0], 3'b111, ~hundreds[0], ~hundreds[0], 1'b1};
	
	
	//Assign one button to reset
	assign {Reset_h}=~ (KEY[0]);

	//Our A/D converter is only 12 bit
	assign VGA_R = Red;
	assign VGA_B = Blue;
	assign VGA_G = Green;
	
	//logic [7:0] animation_offset;
	logic [9:0] enemy_posX;
	logic [9:0] enemy_posY;
	logic [9:0] player_pos;
	logic [2:0] player_lives;
	logic player_flash;

	logic emissile_exists;

	logic [9:0] enemyMissileX;
	logic [9:0] enemyMissileY;

	logic [9:0][5:0]	enemy_status;

	logic pmissile_create;
	logic pmissile_exists;

	logic [9:0] playerMissileX;
	logic [9:0] playerMissileY;

	logic [6:0] enemy_hit;

	logic enemy_collision;
	logic player_collision;

	logic current_health_pixel;
	logic health_text_pixel;

	logic current_score_pixel;
	logic score_text_pixel;

	logic [9:0] score_text_x_offset;

	assign score_text_x_offset = drawxsig - 10'd496;

	logic press_space_pixel;
	logic you_win_pixel;
	logic game_over_pixel;

	logic [3:0] state, count;
	logic pulse, co;

	logic player_unkillable;

	
	
	lab62_soc u0 (
		.clk_clk                           (MAX10_CLK1_50),  //clk.clk
		.reset_reset_n                     (1'b1),           //reset.reset_n
		.altpll_0_locked_conduit_export    (),               //altpll_0_locked_conduit.export
		.altpll_0_phasedone_conduit_export (),               //altpll_0_phasedone_conduit.export
		.altpll_0_areset_conduit_export    (),               //altpll_0_areset_conduit.export
		.key_external_connection_export    (KEY),            //key_external_connection.export

		//SDRAM
		.sdram_clk_clk(DRAM_CLK),                            //clk_sdram.clk
		.sdram_wire_addr(DRAM_ADDR),                         //sdram_wire.addr
		.sdram_wire_ba(DRAM_BA),                             //.ba
		.sdram_wire_cas_n(DRAM_CAS_N),                       //.cas_n
		.sdram_wire_cke(DRAM_CKE),                           //.cke
		.sdram_wire_cs_n(DRAM_CS_N),                         //.cs_n
		.sdram_wire_dq(DRAM_DQ),                             //.dq
		.sdram_wire_dqm({DRAM_UDQM,DRAM_LDQM}),              //.dqm
		.sdram_wire_ras_n(DRAM_RAS_N),                       //.ras_n
		.sdram_wire_we_n(DRAM_WE_N),                         //.we_n

		//USB SPI	
		.spi0_SS_n(SPI0_CS_N),
		.spi0_MOSI(SPI0_MOSI),
		.spi0_MISO(SPI0_MISO),
		.spi0_SCLK(SPI0_SCLK),
		
		//USB GPIO
		.usb_rst_export(USB_RST),
		.usb_irq_export(USB_IRQ),
		.usb_gpx_export(USB_GPX),
		
		//LEDs and HEX
		.hex_digits_export({hex_num_4, hex_num_3, hex_num_1, hex_num_0}),
		.leds_export({hundreds, signs, LEDR}),
		.keycode_export(keycode)
	 );


//instantiate a vga_controller, ball, and color_mapper here with the ports.
vga_controller vga_controller_instance(
										.Clk(MAX10_CLK1_50),       
										.Reset(Reset_h),     
										.hs(VGA_HS),        
										.vs(VGA_VS),        
										.pixel_clk(VGA_Clk), 
										.blank(blank),     
										.sync(sync),      
										.DrawX(drawxsig),     
										.DrawY(drawysig)
);
				
enemy_controller enemy_instance(
										.reset(Reset_h),
										.v_sync(VGA_VS),
										.state(state),
										.count(count),
										//.animation_offset(animation_offset),
										.enemy_posX(enemy_posX),
										.enemy_posY(enemy_posY)
);	


							  
enemy_status enemy_array(
										.reset(Reset_h),
										.clk(VGA_VS),
										.enemy_hit(enemy_hit),
										.collision(enemy_collision),
										.pulse(pulse),
										.co(co),
										.enemy_status(enemy_status),
										.count(count)
);
	
	
	
player player_instance(
										.reset(Reset_h),
										.vsync(VGA_VS),
										.keycode(keycode),
										.pcollision(player_collision),

										
										.player_flash(player_flash),
										.pmissile_create(pmissile_create),
										.x_pos(player_pos),
										.health(player_lives),
										.player_unkillable(player_unkillable)
);	
enemy_missile emissile(
										.reset(Reset_h),
										.vsync(VGA_VS),
										.playerX(player_pos),
										.enemy_posX(enemy_posX),
										.enemy_status(enemy_status),
										.state(state),
										
										.exists(emissile_exists),
										.missileX(enemyMissileX),
										.missileY(enemyMissileY)
);

player_missile pmissile(
										.reset(Reset_h),
										.playerx(player_pos),
										.vsync(VGA_VS),
										.create(pmissile_create),
										.has_collided(enemy_collision),
										
										.exists(pmissile_exists),
										.playerMissileX(playerMissileX),
										.playerMissileY(playerMissileY)
);
	
	
	
collision_detection cd(
										.reset(Reset_h),
										.vsync(VGA_VS),
										
										.pmissileX(playerMissileX),
										.pmissileY(playerMissileY),

										.emissileX(enemyMissileX),
										.emissileY(enemyMissileY),
										
										.playerX(player_pos),
										
										.enemy_hit(enemy_hit),
										
										.enemy_posX(enemy_posX),
										.enemy_status(enemy_status),
										
										.pcollision(player_collision),
										.ecollision(enemy_collision)

);	
	
score_map scorekeeper (
										.vsync(VGA_VS),
										.reset(Reset_h),
										.X(drawxsig[6:1] - 6'h028),
										.Y(drawysig[4:1]),
										
										.enemy_collision(enemy_collision),
										
										.pixel(current_score_pixel)
);
score_text_map score_text(
										.X(score_text_x_offset[6:1]),
										.Y(drawysig[4:1]),
										
										.pixel(score_text_pixel)
);




health_map health_bar (
										.vsync(VGA_VS),
										.reset(Reset_h),
										.X(drawxsig[6:1] + 6'h07),
										.Y(drawysig[4:1]),
										
										.player_collision(player_collision),
										
										.pixel(current_health_pixel)
);	
lives_text_map lives_text(
										.X(drawxsig[6:1]),
										.Y(drawysig[4:1]),
										
										.pixel(health_text_pixel)
);
	
	
game_over_text_map gotm(
										.X(drawxsig[6:1] - 6'h10),
										.Y(drawysig[5:1] - 5'h08),
										
										.pixel(game_over_pixel)
);	


press_fire_text_map (
										.X(drawxsig[6:1] - 6'h0C),
										.Y(drawysig[5:1] - 5'h08),
										
										.pixel(press_space_pixel)
);


you_win_text_map (
										.X(drawxsig[6:1] - 6'h14),
										.Y(drawysig[5:1] - 5'h08),
										
										.pixel(you_win_pixel)
);


	
state_machine sm(				
										.vsync(VGA_VS),
										.enemy_array({enemy_status[0], enemy_status[1], enemy_status[2], 
													  enemy_status[3], enemy_status[4], enemy_status[5], 
													  enemy_status[6], enemy_status[7], enemy_status[8], 
													  enemy_status[9]}),
										.player_lives(player_lives),
										.key_pressed(keycode), 			
										.reset(Reset_h),
										.count(count),
										.state(state),
										.pulse(pulse),
										.co(co)
);


color_mapper color_instance(
										.state(state),
										.count(count),
										.you_win_pixel(you_win_pixel),
										.press_space_pixel(press_space_pixel),
										.game_over_pixel(game_over_pixel),

										.player_unkillable(player_collision),

										//.animation_offset(animation_offset),
										.enemy_posX(enemy_posX),
										.enemy_posY(enemy_posY),
										.player_pos(player_pos),
										.player_flash(player_flash),

										.missile_exists(emissile_exists),
										.missileX(enemyMissileX),
										.missileY(enemyMissileY),

										.pmissile_exists(pmissile_exists),
										.pMissileX(playerMissileX),
										.pMissileY(playerMissileY),

										.enemy_status(enemy_status),
										.player_lives(player_lives),

										.current_health_pixel(current_health_pixel),
										.current_score_pixel(current_score_pixel),

										.health_block_pixel(health_text_pixel),

										.score_text_pixel(score_text_pixel),

										.DrawX(drawxsig),     
										.DrawY(drawysig),
										.VGA_R(Red),
										.VGA_G(Green),
										.VGA_B(Blue),
					
										.current_sprite_pixel
);

logic current_sprite_pixel;
	 
//ball(
//				.Reset(Reset_h),
//				.frame_clk(VGA_VS),
//				.keycode(keycode),
//            .BallX(ballxsig), 
//				.BallY(ballysig), 
//				.BallS(ballsizesig)
//			  );
//
//			  
//color_mapper(
//							.BallX(ballxsig), 
//							.BallY(ballysig), 
//							.DrawX(drawxsig), 
//							.DrawY(drawysig), 
//							.Ball_size(ballsizesig),
//                   .Red(Red), 
//							.Green(Green), 
//							.Blue(Blue) 
//						 );


endmodule
