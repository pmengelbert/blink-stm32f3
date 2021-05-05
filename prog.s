.syntax unified
.thumb

.global main
.text
main:
	ldr r0, =$0x48000000
	ldr r7, =$(1 << 17)
	mov r1, $4
	eor r2, r2
	mov r3, $2

	ldr r6, =$0x40020000
	ldr r5, [r6, $0x14]
	orr r7, r5, r7
	str r7, [r6, $0x14]
	str r1, [r0]
	str r2, [r0, $0x04]
	str r2, [r0, $0x08]
	str r2, [r0, $0x0c]
	str r3, [r0, $0x18]
loop:
	b loop

