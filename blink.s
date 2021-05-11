.syntax unified
.thumb

RCC_AHBENR =    0x40021014
RCC_AHB2ENR =   0x40021018

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


GPIOA_MODER =   0x48000000
GPIOA_OTYPER =  0x48000004
GPIOA_OSPEEDR = 0x48000008
GPIOA_OPUPDR =  0x4800000c
GPIOA_ODR = 	0x48000014

.global main
.global TIM2_IRQHandler
.global here
.text
main:
	@ turn on the TIM16 timer
	ldr r1, =RCC_AHB2ENR
	ldr r0, [r1]
	orr r0, $0x00020000
	str r0, [r1]

	@ configure the timer
	ldr r1, =TIM16_CR1
	ldr r0, [r1]
	orr r0, $0x00000000 @ set up one-pulse mode
	str r0, [r1]

	@ configure capture
	ldr r1, =TIM16_CCRM1
	ldr r0, [r1]
	orr r0, 0x00000030
	str r0, [r1]

	@ more configure capture
	ldr r1, =TIM16_CCER
	mov r0, $0x00
	str r0, [r1]

	ldr r1, =TIM16_DIER
	ldr r0, [r1]
	orr r0, $0x00000002
	str r0, [r1]

	ldr r1, =TIM16_PSC
	mov r0, $7999
	str r0, [r1]

	ldr r1, =TIM16_ARR
	mov r0, $0xffff
	str r0, [r1]

	ldr r1, =TIM16_CCR1
	mov r0, $0x1000
	str r0, [r1]

here:
	ldr r1, =TIM16_CR1
	ldr r0, [r1]
	orr r0, $0x01
	str r0, [r1]

	ldr r0, =TIM16_SR
	ldr r4, [r1]

	@ turn on the GPIO pins
	ldr r1, =RCC_AHBENR
	ldr r0, [r1]
	orr r0, $0x00020000
	str r0, [r1]


	ldr r1, =GPIOA_MODER
	ldr r0, [r1]
	orr r0, $0x00000005
	and r0, $0xfffffff5
	str r0, [r1]

	ldr r1, =GPIOA_OTYPER
	ldr r0, [r1]
	and r0, $0xfffffffc
	str r0, [r1]

	ldr r1, =GPIOA_OSPEEDR
	ldr r0, [r1]
	and r0, $0xfffffff0
	str r0, [r1]

	ldr r1, =GPIOA_OPUPDR
	ldr r0, [r1]
	and r0, $0xfffffff0
	str r0, [r1]

	ldr r1, =GPIOA_ODR
	ldr r0, [r1]
	mov r0, $0x00000001
	str r0, [r1]

	ldr r1, =TIM16_CNT
	ldr r0, [r1]
	mov r3, $1000
	mov r0, $0
	str r0, [r1]
.L3loop:
	ldr r1, =TIM16_CNT
	ldr r4, [r1]
	cmp r3, r4
	bge .L3loop

	mov r0, $0
	str r0, [r1]

	ldr r1, =GPIOA_ODR
	ldr r0, [r1]
	eor r0, $0x00000001
	str r0, [r1]
loop:
	b .L3loop

TIM2_IRQHandler:
	b TIM2_IRQHandler

@ vim:ft=armv5
