DIR_TMP		:= /tmp/os_dev
DIR_ROOT 	:= .
DIR_BUILD 	:= $(DIR_ROOT)/build
DIR_SRC 	:= $(DIR_ROOT)/src
DIR_BOOT	:= $(DIR_SRC)/bootloader
DIR_KERNEL	:= $(DIR_SRC)/kernel
DIR_DRIVERS	:= $(DIR_SRC)/drivers

C_SOURCES	:= $(shell find $(DIR_KERNEL) $(DIR_DRIVERS) -name \*.c)
H_SOURCES	:= $(shell find $(DIR_KERNEL) $(DIR_DRIVERS) -name \*.h)
OBJECTS		:= $(patsubst %.c, $(DIR_BUILD)/%.o, $(notdir $(C_SOURCES)))



CC 			:= i686-elf-gcc
CC_FLAGS 	:= -ffreestanding -c

LD			:= i686-elf-ld
LD_FLAGS	:= --oformat binary

AS			:= i686-elf-gcc 
AS_FLAGS	:= -c


build: $(DIR_BUILD)/os.iso

run:
	docker-compose run make build
	mkdir -p $(DIR_TMP)
	cp $(DIR_BUILD)/os.iso $(DIR_TMP)
	qemu-system-i386 -drive format=raw,file=$(DIR_TMP)/os.iso

$(DIR_BUILD)/os.iso: $(DIR_BUILD)/bootloader.bin $(DIR_BUILD)/kernel.bin
	@dd if=/dev/zero of=$@ bs=512 count=2880 status=none
	@dd if=$(word 1,$^) of=$@ conv=notrunc seek=0 bs=512 count=1 status=none
	@dd if=$(word 2,$^) of=$@ conv=notrunc seek=1 bs=512 count=10 status=none

$(DIR_BUILD)/kernel.bin: $(DIR_BUILD)/kernel_loader.o $(OBJECTS)
	$(LD) $(LD_FLAGS) -Ttext 0x1000 $^ -o $@

$(DIR_BUILD)/kernel_loader.o: $(DIR_KERNEL)/kernel_loader.S
	$(AS) $(AS_FLAGS) $< -o $@

$(DIR_BUILD)/bootloader.bin: $(DIR_BUILD)/bootloader.o
	$(LD) $(LD_FLAGS) -Ttext 0x7c00 -o $@ $<

$(DIR_BUILD)/bootloader.o: $(DIR_BOOT)/bootloader.S $(wildcard $(DIR_BOOT)/include/*.S)
	$(AS) $(AS_FLAGS) -o $@ $<

$(DIR_BUILD)/%.o: $(DIR_KERNEL)/%.c $(H_SOURCES)
	$(CC) $(CC_FLAGS) $< -o $@

$(DIR_BUILD)/%.o: $(DIR_DRIVERS)/%.c $(H_SOURCES)
	$(CC) $(CC_FLAGS) $< -o $@

force:

clean:
	rm -rf $(DIR_BUILD)/*