AS=/usr/arm-none-eabi/bin/as
LD=/usr/arm-none-eabi/bin/ld
OC=/usr/arm-none-eabi/bin/objcopy

all: build
	$(AS) -o build/$(FILE).o $(FILE).s
	$(AS) -o build/startup.o startup.s
	$(LD) -o build/$(FILE) build/$(FILE).o build/startup.o -Tstm32f303.ld
	$(OC) -O binary build/$(FILE) build/$(FILE).bin

build:
	mkdir -p build

flash: $(FILE).bin
	st-flash write build/$(FILE).bin 0x8000000
