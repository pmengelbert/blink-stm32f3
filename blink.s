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
TIM16_BDTR =	TIM16 + 0x44


GPIOA_MODER =   0x48000000
GPIOA_OTYPER =  0x48000004
GPIOA_OSPEEDR = 0x48000008
GPIOA_OPUPDR =  0x4800000c
GPIOA_ODR = 	0x48000014
GPIOA_AFRL = 	0x48000020

.global main
.global here
.text
main:
	@ turn on the TIM16 timer clock
	ldr r1, =RCC_AHB2ENR
	ldr r0, [r1]
	orr r0, $0x00020000
	str r0, [r1]

	@ turn on the GPIO clock
	ldr r1, =RCC_AHBENR
	ldr r0, [r1]
	and r0, $0xfffdffff
	orr r0, $0x00020000
	str r0, [r1]

	@ configure capture
	ldr r1, =TIM16_CCRM1
	ldr r0, [r1]
	ldr r2, =$0xfffeff8f
	and r0, r2
	orr r0, $0x00000030 @ set
	str r0, [r1]

	@ more configure capture
	ldr r1, =TIM16_CCER
	mov r0, $0x00000001 @ enable capture/compare channel 1
	str r0, [r1]

	ldr r1, =TIM16_BDTR
	ldr r0, [r1]
	orr r0, $(1 << 15) @ set main output enable (MOE)
	str r0, [r1]

	@ ldr r1, =TIM16_DIER
	@ ldr r0, [r1]
	@ orr r0, $0x00000002
	@ str r0, [r1]

	ldr r1, =TIM16_PSC
	mov r0, $7999 @ set prescaler such that the 8MHz clock will be scaled down to 1KHz
	str r0, [r1]

	ldr r1, =TIM16_ARR
	mov r0, $1000 @ reset the counter after one second
	str r0, [r1]

	ldr r1, =TIM16_CCR1
	mov r0, $500 @ in the middle of the timer's cycle, the there will be a match
	str r0, [r1]

	ldr r1, =GPIOA_MODER
	ldr r0, [r1]
	ldr r2, =$0xffff3ffc
	and r0, r2
	ldr r2, =$0x00002001 @ enable GPIOA pin 1 as output and pin 6 as "alternate function"
	orr r0, r2
	str r0, [r1]

	ldr r1, =GPIOA_AFRL
	ldr r0, [r1]
	and r0, $0xf0ffffff
	orr r0, $0x01000000 @ use alternate function 1, i.e. TIM16_CH1
	str r0, [r1]

here:
	ldr r1, =TIM16_CR1
	ldr r0, [r1]
	orr r0, $0x01
	str r0, [r1]

loop:
	b loop

@ vim:ft=armv5
