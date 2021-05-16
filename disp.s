.syntax unified
.thumb

RCC_AHBENR =    0x40021014
RCC_AHB2ENR =   0x40021018

GPIOA_MODER =   0x48000000
GPIOA_OTYPER =  0x48000004
GPIOA_OSPEEDR = 0x48000008
GPIOA_OPUPDR =  0x4800000c
GPIOA_ODR = 	0x48000014
GPIOA_AFRL = 	0x48000020

TIM16 =			0x40014400
TIM16_CR1 =		TIM16 + 0x00
TIM16_CR2 =		TIM16 + 0x04
TIM16_DIER =	TIM16 + 0x0c
TIM16_SR =		TIM16 + 0x10
TIM16_CCRM1 =	TIM16 + 0x18
TIM16_CCER =	TIM16 + 0x20
TIM16_CNT =		TIM16 + 0x24
TIM16_PSC =		TIM16 + 0x28
TIM16_ARR =		TIM16 + 0x2c
TIM16_CCR1 =	TIM16 + 0x34
TIM16_BDTR =	TIM16 + 0x44

NVIC_ISER0 =	0xe000e100
NVIC_ICER0 =	0xe000e180

DMA1_BASE = 0x40020000
DMA_CCR1 = 0x40020008
DMA_CNDTR1 = 0x4002000c @ numdata
DMA_CPAR1 = 0x40020010
DMA_CMAR1 = 0x40020014

.global main
.global TIM1_UP_TIM16_IRQHandler

.data
disp_row_0: .byte 0x03
disp_row_1: .byte 0x05
disp_row_2: .byte 0x06

.text

main:
	mov r7, $0

@ turn on the clock for GPIO and DMA

enable_interrupt:
	@ enable interrupt 25
	ldr r1, =NVIC_ISER0
	ldr r0, [r1]
	orr r0, $(1 << 25)
	str r0, [r1]

turn_on_clocks:
	@ set up gpio clock and dma clock
	ldr r1, =RCC_AHBENR
	ldr r0, [r1]
	ldr r2, =$0xfffdfffe
	and r0, r2
	ldr r2, =$0x00020001
	orr r0, r2
	str r0, [r1]

	@ turn on the TIM16 timer clock
	ldr r1, =RCC_AHB2ENR
	ldr r0, [r1]
	orr r0, $0x00020000
	str r0, [r1]

@ set up GPIO port a, lowest 5 bits as output
set_up_gpio:
	ldr r1, =GPIOA_MODER
	ldr r0, [r1]
	ldr r2, =$0xfffffc00
	and r0, r2
	ldr r2, =$0x00000155
	orr r0, r2
	str r0, [r1]

configure_capture:
	ldr r1, =TIM16_DIER
	ldr r0, [r1]
	orr r0, $0x00000001
	str r0, [r1]

	ldr r1, =TIM16_PSC
	mov r0, $7999 @ set prescaler such that the 8MHz clock will be scaled down to 1KHz
	str r0, [r1]

	ldr r1, =TIM16_ARR
	mov r0, $6 @ reset the counter after one 30th of a second
	str r0, [r1]

	@enable the timer
	ldr r1, =TIM16_CR1
	ldr r0, [r1]
	orr r0, $0x01
	str r0, [r1]

	ldr r8, =$0x00100000
game_loop:
	ldr r5, =__ram_start__
	ldrb r4, [r5]
	add r4, $1
	strb r4, [r5]

	ldrb r4, [r5, $1]
	add r4, $1
	strb r4, [r5, $1]

	ldrb r4, [r5, $2]
	add r4, $1
	strb r4, [r5, $2]

	mov r6, r8
	bl delay
	b game_loop

delay:
	subs r6, $1
	bne delay
	bx lr

interrupt_handler:
TIM1_UP_TIM16_IRQHandler:
	ldr r1, =GPIOA_ODR
	ldr r2, =__ram_start__
	ldrb r0, [r2, r7]
	mov r3, r7
	lsl r3, $3
	orr r0, r3
	strb r0, [r1]
	add r7, $1
	cmp r7, $3
	it eq
	moveq r7, $0
	ldr r1, =TIM16_SR
	ldr r0, [r1]
	and r0, $0xfffffffe @ clear the interrupt flag
	str r0, [r1]
	bx lr

@ set up continuous dma between .data section and GPIO port A
set_up_dma:
	@ disable the channel to enable writes
	ldr r1, =DMA_CCR1
	mov r0, $0
	str r0, [r1]

	ldr r1, =DMA_CPAR1
	ldr r0, =GPIOA_ODR
	str r0, [r1]

	ldr r1, =DMA_CMAR1
	ldr r0, =__ram_start__
	str r0, [r1]

	ldr r1, =DMA_CNDTR1
	@ ldr r0, =__data_size__
	mov r0, $1
	str r0, [r1]

	ldr r1, =DMA_CCR1
	/* - memory-to-memory enabled
	   - priority: high
	   - 8 bit memory
	   - 8 bit peripheral
	   - increment memory
	   - do not increment peripheral
	   - not circular
	   - no interrupts
	   - not enabled (yet)
   */
	ldr r0, =$0x00007091
	str r0, [r1]

@ loop endlessly

@ vim:ft=armv5
