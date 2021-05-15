AS=/usr/arm-none-eabi/bin/as
LD=/usr/arm-none-eabi/bin/ld
OC=/usr/arm-none-eabi/bin/objcopy

all:
	$(AS) -o $(FILE).o $(FILE).s
	$(AS) -o startup.o startup.s
	$(LD) -o $(FILE) $(FILE).o startup.o -Tstm32f303.ld
	$(OC) -O binary $(FILE) $(FILE).bin
