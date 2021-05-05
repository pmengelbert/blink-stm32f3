.syntax unified
.thumb
.text

RCC_AHBENR = 0x40021014
GPIOA_MODER = 0x48000000
GPIOA_OTYPER = 0x48000004
GPIOA_OSPEEDR = 0x48000008
GPIOA_OPUPDR = 0x4800000c
GPIOA_ODR = 0x48000014

.global main
main:
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
	orr r0, $0x00000001
	and r0, $0xfffffffd
	str r0, [r1]
loop:
	b loop

