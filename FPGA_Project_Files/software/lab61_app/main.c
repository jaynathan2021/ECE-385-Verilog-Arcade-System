////
////// Main.c - makes LEDG0 on DE2-115 board blink if NIOS II is set up correctly
////// for ECE 385 - University of Illinois - Electrical and Computer Engineering
////// Author: Zuofu Cheng
////
////int main()
////{
////	volatile unsigned int *LED_PIO = (unsigned int*)0x70;
////	volatile unsigned int *SW_PIO  = (unsigned int*)0x50;
////	volatile unsigned int *ADDR_PIO = (unsigned int*)0x60;
////
////
////	int sum = 0;
////	int cont = 0;
////	*LED_PIO = 0; //clear LEDs
////
////	while ((1+1) != 3) //infinite loop
////	{
////		if(*ADDR_PIO == 0 && cont == 0) {
////			sum = sum + *SW_PIO;
////			cont = 1;
////		}
////		if(*ADDR_PIO == 1 && cont == 1) {
////			cont = 0;
////		}
////
////		*LED_PIO = sum;
////	}
////	return 1;
////}
//// Main.c - makes LEDG0 on DE2-115 board blink if NIOS II is set up correctly
//// for ECE 385 - University of Illinois - Electrical and Computer Engineering
//// Author: Zuofu Cheng
//
//int main()
//{
//	int i = 0;
//	volatile unsigned int *LED_PIO = (unsigned int*)0x70; //make a pointer to access the PIO block
//
//	*LED_PIO = 0; //clear all LEDs
//	while ( (1+1) != 3) //infinite loop
//	{
//		for (i = 0; i < 100000; i++); //software delay
//		*LED_PIO |= 0x1; //set LSB
//		for (i = 0; i < 100000; i++); //software delay
//		*LED_PIO &= ~0x1; //clear LSB
//	}
//	return 1; //never gets here
//}

// Main.c - makes LEDG0 on DE2-115 board blink if NIOS II is set up correctly
// for ECE 385 - University of Illinois - Electrical and Computer Engineering
// Author: Zuofu Cheng

int main()
{
	int i = 0;
	volatile unsigned int *LED_PIO = (unsigned int*)0x70; //make a pointer to access the PIO block

	int cond = 100000;

	*LED_PIO = 0xFFFFFFFF; //clear all LEDs
	while ((1+1) != 3) //infinite loop
	{
		if(cond == 0) {
			*LED_PIO = *LED_PIO - 1;
			cond = 100000;
		}
		cond--;
	}
	return 1; //never gets here
}
