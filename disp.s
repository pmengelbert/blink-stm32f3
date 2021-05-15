.syntax unified
.thumb

RCC_AHBENR =    0x40021014

GPIOA_MODER =   0x48000000
GPIOA_OTYPER =  0x48000004
GPIOA_OSPEEDR = 0x48000008
GPIOA_OPUPDR =  0x4800000c
GPIOA_ODR = 	0x48000014
GPIOA_AFRL = 	0x48000020

DMA1_BASE = 0x40020000
DMA_CCR1 = 0x40020008
DMA_CNDTR1 = 0x4002000c @ numdata
DMA_CPAR1 = 0x40020010
DMA_CMAR1 = 0x40020014

.global main

.data
disp_row_0: .byte 0x03
disp_row_1: .byte 0x0d
disp_row_2: .byte 0x16

.text

main:
@ turn on the clock for GPIO and DMA
turn_on_clocks:
	@ set up gpio clock and dma clock
	ldr r1, =RCC_AHBENR
	ldr r0, [r1]
	ldr r2, =$0xfffdfffe
	and r0, r2
	ldr r2, =$0x00020001
	orr r0, r2
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
end:
	b .

@ vim:ft=armv5
