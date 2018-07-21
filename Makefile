include makefile.conf

PROJECT=test

.PHONY: clean

DEFINES=-D__STARTUP_CLEAR_BSS -D__START=main -D__NO_SYSTEM_INIT

OBJECTS += main.o
OBJECTS += startup_ARMCM3.o

TOOLCHAIN=arm-none-eabi-
CFLAGS=$(ARCH_FLAGS) $(DEFINES) $(CPU_DEFINES) $(INCLUDES) -Wall -g #-ffunction-sections -fdata-sections -fno-builtin
LFLAGS=--specs=nosys.specs -Wl,--gc-sections -Wl,-Map=$(PROJECT).map -Tlink.ld

%.o: %.S
	$(TOOLCHAIN)gcc $(CFLAGS) -c -o $@ $<

%.o: %.c
	$(TOOLCHAIN)gcc $(CFLAGS) -c -o $@ $<

$(PROJECT).bin: $(PROJECT).elf
	$(TOOLCHAIN)objcopy -O binary $< $@

$(PROJECT).elf: $(OBJECTS)
	$(TOOLCHAIN)gcc $(LFLAGS) $^ $(CFLAGS) -o $@

clean:
	rm -f *.bin *.map *.elf $(CPUDIR) output.txt
	find . -name '*.o' -delete

flash:
	st-flash write $(PROJECT).bin 0x8000000
