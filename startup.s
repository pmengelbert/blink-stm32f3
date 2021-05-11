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

_start: 	.word		__stack_end__	/* The stack is set up by the CPU using this at reset */
		.word		Reset_Handler		/* Then it will jump to this address */

		IRQ		NMI_Handler				// Define all other handlers to the
		IRQ		HardFault_Handler		// default value, using the IRQ macro
		IRQ		MemManage_Handler		// we defined above
		IRQ		BusFault_Handler
		IRQ		UsageFault_Handler
		.word		0
		.word		0
		.word		0
		.word		0
		IRQ		SVC_Handler
		IRQ		DebugMon_Handler
		.word		0
		IRQ		PendSV_Handler
		IRQ		SysTick_Handler

/* Hardware interrupts specific to the STM32F405
   TODO review this and see if the STM32F303 is close enough ! 
 
 NOTE: you can comment all of this if you don't use interrupts, to save a bit of
 flash space. Or if you are crazy you can even interleave code and vectors.*/

		IRQ		WWDG_IRQHandler
		IRQ		PVD_IRQHandler
		IRQ		TAMP_STAMP_IRQHandler
		IRQ		RTC_WKUP_IRQHandler
		IRQ		FLASH_IRQHandler
		IRQ		RCC_IRQHandler
		IRQ		EXTI0_IRQHandler
		IRQ		EXTI1_IRQHandler
		IRQ		EXTI2_IRQHandler
		IRQ		EXTI3_IRQHandler
		IRQ		EXTI4_IRQHandler
		IRQ		DMA1_Stream0_IRQHandler
		IRQ		DMA1_Stream1_IRQHandler
		IRQ		DMA1_Stream2_IRQHandler
		IRQ		DMA1_Stream3_IRQHandler
		IRQ		DMA1_Stream4_IRQHandler
		IRQ		DMA1_Stream5_IRQHandler
		IRQ		DMA1_Stream6_IRQHandler
		IRQ		ADC_IRQHandler
		IRQ		CAN1_TX_IRQHandler
		IRQ		CAN1_RX0_IRQHandler
		IRQ		CAN1_RX1_IRQHandler
		IRQ		CAN1_SCE_IRQHandler
		IRQ		EXTI9_5_IRQHandler
		IRQ		TIM1_BRK_TIM9_IRQHandler
		IRQ		TIM1_UP_TIM10_IRQHandler
		IRQ		TIM1_TRG_COM_TIM11_IRQHandler
		IRQ		TIM1_CC_IRQHandler
		IRQ		TIM2_IRQHandler
		IRQ		TIM3_IRQHandler
		IRQ		TIM4_IRQHandler
		IRQ		I2C1_EV_IRQHandler
		IRQ		I2C1_ER_IRQHandler
		IRQ		I2C2_EV_IRQHandler
		IRQ		I2C2_ER_IRQHandler
		IRQ		SPI1_IRQHandler
		IRQ		SPI2_IRQHandler
		IRQ		USART1_IRQHandler
		IRQ		USART2_IRQHandler
		IRQ		USART3_IRQHandler
		IRQ		EXTI15_10_IRQHandler
		IRQ		RTC_Alarm_IRQHandler
		IRQ		OTG_FS_WKUP_IRQHandler
		IRQ		TIM8_BRK_TIM12_IRQHandler
		IRQ		TIM8_UP_TIM13_IRQHandler
		IRQ		TIM8_TRG_COM_TIM14_IRQHandler
		IRQ		TIM8_CC_IRQHandler
		IRQ		DMA1_Stream7_IRQHandler
		IRQ		FSMC_IRQHandler
		IRQ		SDIO_IRQHandler
		IRQ		TIM5_IRQHandler
		IRQ		SPI3_IRQHandler
		IRQ		UART4_IRQHandler
		IRQ		UART5_IRQHandler
		IRQ		TIM6_DAC_IRQHandler
		IRQ		TIM7_IRQHandler
		IRQ		DMA2_Stream0_IRQHandler
		IRQ		DMA2_Stream1_IRQHandler
		IRQ		DMA2_Stream2_IRQHandler
		IRQ		DMA2_Stream3_IRQHandler
		IRQ		DMA2_Stream4_IRQHandler
		IRQ		ETH_IRQHandler
		IRQ		ETH_WKUP_IRQHandler
		IRQ		CAN2_TX_IRQHandler
		IRQ		CAN2_RX0_IRQHandler
		IRQ		CAN2_RX1_IRQHandler
		IRQ		CAN2_SCE_IRQHandler
		IRQ		OTG_FS_IRQHandler
		IRQ		DMA2_Stream5_IRQHandler
		IRQ		DMA2_Stream6_IRQHandler
		IRQ		DMA2_Stream7_IRQHandler
		IRQ		USART6_IRQHandler
		IRQ		I2C3_EV_IRQHandler
		IRQ		I2C3_ER_IRQHandler
		IRQ		OTG_HS_EP1_OU_IRQHandler
		IRQ		OTG_HS_EP1_IN_IRQHandler
		IRQ		OTG_HS_WKUP_IRQHandler
		IRQ		OTG_HS_IRQHandler
		IRQ		DCMI_IRQHandler
		IRQ		CRYP_IRQHandler
		IRQ		HASH_RNG_IRQHandler
		IRQ		FPU_IRQHandler

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
