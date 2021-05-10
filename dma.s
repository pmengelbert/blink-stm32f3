.syntax unified
.thumb
.global main

RCC_AHBENR = 0x40021014

DMA1_BASE = 0x40020000
DMA_CCR1 = 0x40020008
DMA_CNDTR1 = 0x4002000c
DMA_CPAR1 = 0x40020010
DMA_CMAR1 = 0x40020014

.data
.asciz "poetic thoughts elude me"

.text
main:
	ldr r0, =RCC_AHBENR
	ldr r1, [r0]
	orr r1, $0x00000001
	str r1, [r0]

	@ set up DMA
	ldr r0, =DMA_CPAR1
	ldr r1, =__load_data_beg__  @ is this right?
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
	ldr r2, =$(0b111000011000000 & 0x00007fff)
	orr r1, r2
	str r1, [r0]

	ldr r0, =DMA_CCR1
	ldr r1, [r0]
	ldr r3, =$0xfffffffe
	and r1, r3
	mov r2, #1
	orr r1, r2
	str r1, [r0]

	b .


@ vim:ft=armv5
