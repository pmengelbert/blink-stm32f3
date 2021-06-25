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
display_buffer_row_0: .byte 0x00
display_buffer_row_1: .byte 0x00
display_buffer_row_2: .byte 0x00

update_buffer_row_0: .byte 0x03
update_buffer_row_1: .byte 0x05
update_buffer_row_2: .byte 0x06

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

@ set up GPIO port a, all 16 bits as output
set_up_gpio:
	ldr r1, =GPIOA_MODER
	ldr r0, [r1]
	and r0,  $0x00000000
	ldr r2, =$0x55555555
	orr r0, r2
	str r0, [r1]

loop_endlessly:
	b loop_endlessly

@ vim:ft=armv5
