/* Startup for STM32F303 Cortex-M4 ARM MCU
Copyright 2012, Adrien Destugues <pulkomandy@gmail.com>
This file is distributed under the terms of the MIT licence.
 */

/* Some mandatory setup for all assembly files. We tell the compiler we use the
   unified syntax (you always want this one), the thumb instruction code (the
   only one available for Cortex-M), and we select the .text section as we will
   be writing code, not data
*/
		.syntax 	unified
		.thumb
		.text
		.section .boot,"x"

/* Export these symbols: _start is the interrupt vector, Reset_handler does the
   initialization before calling main(), and Default_Handler does nothing. It's
   used for the other interrupts besides reset. */
		.global		_start
		.global		Reset_Handler
		.global		Default_Handler

/*===========================================================================*/

/* Use Default_handler for all exceptions and interrupts, unless another
handler is provided elsewhere.
*/

		.macro		IRQ handler
		.word		\handler	/* Store the pointer to handler here */
		.weak		\handler	/* Make it a weak symbol so it can be redefined */
		.set		\handler, Default_Handler /* And set the default value */
		.endm

/*===========================================================================*/

RCC_AHBENR = 0x40021014

DMA1_BASE = 0x40020000
DMA_CCR1 = 0x40020008
DMA_CNDTR1 = 0x4002000c
DMA_CPAR1 = 0x40020010
DMA_CMAR1 = 0x40020014

/* Exception vector table--Common to all Cortex-M4 */

_start: 
/*0x00*/    .word		__stack_end__	/* The stack is set up by the CPU using this at reset */
/*0x04*/    .word		Reset_Handler		/* Then it will jump to this address */
/*0x08*/    IRQ		NMI_Handler				// Define all other handlers to the
/*0x0c*/    IRQ		HardFault_Handler		// default value, using the IRQ macro
/*0x10*/    IRQ		MemManage_Handler		// we defined above
/*0x14*/    IRQ		BusFault_Handler
/*0x18*/    IRQ		UsageFault_Handler
/*0x1c*/    .word		0
/*0x20*/    .word		0
/*0x24*/    .word		0
/*0x28*/    .word		0
/*0x2c*/    IRQ		SVC_Handler
/*0x30*/    .word		0
/*0x34*/    .word		0
/*0x38*/    IRQ		PendSV_Handler
/*0x3c*/    IRQ		SysTick_Handler
/*0x40*/    IRQ		WWDG_IRQHandler
/*0x44*/    IRQ		PVD_IRQHandler
/*0x48*/    IRQ		TAMP_STAMP_IRQHandler
/*0x4c*/    IRQ		RTC_WKUP_IRQHandler
/*0x50*/    IRQ		FLASH_IRQHandler
/*0x54*/    IRQ		RCC_IRQHandler
/*0x58*/    IRQ		EXTI0_IRQHandler
/*0x5c*/    IRQ		EXTI1_IRQHandler
/*0x60*/    IRQ		EXTI2_IRQHandler
/*0x64*/    IRQ		EXTI3_IRQHandler
/*0x68*/    IRQ		EXTI4_IRQHandler
/*0x6c*/    IRQ		DMA1_Stream0_IRQHandler
/*0x70*/    IRQ		DMA1_Stream1_IRQHandler
/*0x74*/    IRQ		DMA1_Stream2_IRQHandler
/*0x78*/    IRQ		DMA1_Stream3_IRQHandler
/*0x7c*/    IRQ		DMA1_Stream4_IRQHandler
/*0x80*/    IRQ		DMA1_Stream5_IRQHandler
/*0x84*/    IRQ		DMA1_Stream6_IRQHandler
/*0x88*/    IRQ		ADC_IRQHandler
/*0x8c*/    IRQ		CAN1_TX_IRQHandler
/*0x90*/    IRQ		CAN1_RX0_IRQHandler
/*0x94*/    IRQ		CAN1_RX1_IRQHandler
/*0x98*/    IRQ		CAN1_SCE_IRQHandler
/*0x9c*/    IRQ		EXTI9_5_IRQHandler
/*0xa0*/    IRQ		TIM1_BRK_TIM15_IRQHandler
/*0xa4*/    IRQ		TIM1_UP_TIM16_IRQHandler
/*0xa8*/    IRQ		TIM1_TRG_COM_TIM17_IRQHandler
/*0xac*/    IRQ		TIM1_CC_IRQHandler
/*0xb0*/    IRQ		TIM2_IRQHandler
/*0xb4*/    IRQ		TIM3_IRQHandler
/*0xb8*/    IRQ		TIM4_IRQHandler
/*0xbc*/    IRQ		I2C1_EV_IRQHandler
/*0xc0*/    IRQ		I2C1_ER_IRQHandler
/*0xc4*/    IRQ		I2C2_EV_IRQHandler
/*0xc8*/    IRQ		I2C2_ER_IRQHandler
/*0xcc*/    IRQ		SPI1_IRQHandler
/*0xd0*/    IRQ		SPI2_IRQHandler
/*0xd4*/    IRQ		USART1_IRQHandler
/*0xd8*/    IRQ		USART2_IRQHandler
/*0xdc*/    IRQ		USART3_IRQHandler
/*0xe0*/    IRQ		EXTI15_10_IRQHandler
/*0xe4*/    IRQ		RTC_Alarm_IRQHandler
/*0xe8*/    IRQ		OTG_FS_WKUP_IRQHandler
/*0xec*/    IRQ		TIM8_BRK_IRQHandler
/*0xf0*/    IRQ		TIM8_UP_IRQHandler
/*0xf4*/    IRQ		TIM8_TRG_COM_IRQHandler
/*0xf8*/    IRQ		TIM8_CC_IRQHandler
/*0xfc*/    IRQ		ADC3_IRQHandler
/*0x100*/   IRQ		FMC_IRQHandler
/*0x104*/   .word		0
/*0x108*/   .word		0
/*0x10c*/   IRQ		SPI3_IRQHandler
/*0x110*/   IRQ		UART4_IRQHandler
/*0x114*/   IRQ		UART5_IRQHandler
/*0x118*/   IRQ		TIM6_DAC_IRQHandler
/*0x11c*/   IRQ		TIM7_IRQHandler
/*0x120*/   IRQ		DMA2_Channel1_IRQHandler
/*0x124*/   IRQ		DMA2_Channel2_IRQHandler
/*0x128*/   IRQ		DMA2_Channel3_IRQHandler
/*0x12c*/   IRQ		DMA2_Channel4_IRQHandler
/*0x130*/   IRQ		DMA2_Channel5_IRQHandler
/*0x134*/   IRQ		ADC4_IRQHandler
/*0x138*/   .word		0
/*0x13c*/   .word		0
/*0x140*/   IRQ		COMP_1_2_3_IRQHandler
/*0x144*/   IRQ		COMP_4_5_6_IRQHandler
/*0x148*/   IRQ		COMP_7_IRQHandler
/*0x14c*/   .word		0
/*0x150*/   .word		0
/*0x154*/   .word		0
/*0x158*/   .word		0
/*0x15c*/   .word		0
/*0x160*/   IRQ		I2C3_EV_IRQHandler
/*0x164*/   IRQ		I2C3_ER_IRQHandler
/*0x168*/   IRQ		USB_HP_IRQHandler
/*0x16c*/   IRQ		USB_LP_IRQHandler
/*0x170*/   IRQ		USB_WKUP_RMP_IRQHandler
/*0x174*/   IRQ		TIM20_BRK_IRQHandler
/*0x178*/   IRQ		TIM20_UP_IRQHandler
/*0x17c*/   IRQ		TIM20_TRG_COM_IRQHandler
/*0x180*/   IRQ		TIM20_CC_IRQHandler
/*0x184*/   IRQ		FPU_IRQHandler
/*0x188*/   .word		0
/*0x18c*/   .word		0
/*0x190*/   IRQ		SPI4_IRQHandler

/*===========================================================================*/

		.section .text
/* Default exception handler--does nothing but return */

		.thumb_func
Default_Handler: 
		b		.

/*===========================================================================*/

/* Reset vector: Set up environment to call C main() */

		.thumb_func
Reset_Handler:

/* Copy initialized data from flash to RAM */

copy_data:	
	ldr r0, =RCC_AHBENR
	ldr r1, [r0]
	orr r1, $0x00000001
	str r1, [r0]

	@ set up DMA
	ldr r0, =DMA_CPAR1
	ldr r1, =__load_data_beg__
	str r1, [r0]

	ldr r0, =DMA_CMAR1
	ldr r1, =__ram_start__
	str r1, [r0]

	ldr r0, =DMA_CNDTR1
	ldr r1, [r0]
	ldr r3, =$0xffff0000
	and r1, r3
	ldr r2, =__data_size__
	ldr r3, =$0x0000ffff
	and r2, r3
	orr r1, r2
	str r1, [r0]

	ldr r0, =DMA_CCR1
	ldr r1, [r0]
	ldr r3, =$0xffff8000
	and r1, r3
	ldr r2, =$(0x70c1 & 0x00007fff)
	orr r1, r2
	str r1, [r0]

/* Zero uninitialized data (bss) */

zero_bss: 	
		ldr 		r1, BSS_BEG
		ldr 		r3, BSS_END
		subs 		r3, r3, r1		/* Length of uninitialized data */
		beq			call_main		/*Skip if none */

		mov 		r2, #0

zero_bss_loop: 	
		strb		r2, [r1], #1		/* Store zero */
		subs		r3, r3, #1		/* Decrement counter */
		bgt			zero_bss_loop		/* Repeat until done */

/* Call main() */

call_main:	
		mov		r0, #0			/* argc=0 */
		mov		r1, #0			/* argv=NULL */

		bl		main 

/* If main returns, we jump into the bootloader. The bootloader expect things
to be configured similar to what they are on reset, so we first have to restore
RCC clocks and map in the boot ROM. */

		LDR     R0, =0x40023844 /* RCC_APB2ENR */
		LDR     R1, =0x00004000 /* ENABLE SYSCFG CLOCK */
		STR     R1, [R0, #0]
		LDR     R0, =0x40013800 /* SYSCFG_MEMRMP */
		LDR     R1, =0x00000001 /* MAP ROM AT ZERO */
		STR     R1, [R0, #0]
		LDR     R0, =0x1FFFD800 /* ROM BASE */
		LDR     SP,[R0, #0]     /* SP @ +0 */
		LDR     R0,[R0, #4]     /* PC @ +4 */
		BX      R0

/*=============================================================================*/

/* These are filled in by the linker */

		.align		4
TEXT_END:	.word		__text_end__
DATA_BEG:	.word		__data_beg__
DATA_END:	.word		__data_end__
BSS_BEG:	.word		__bss_beg__ 
BSS_END:	.word		__bss_end__

/*==========================================================================*/
@ vim:ft=armv5
