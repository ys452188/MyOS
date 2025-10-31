# 编译内核入口和内核
echo "编译内核入口..."
clang --target=aarch64-none-elf -mcpu=cortex-a53 -O2 -ffreestanding -c kernel_entry.s -o kernel_entry.o
echo "编译内核..."
clang --target=aarch64-none-elf -mcpu=cortex-a53 -O2 -ffreestanding -c kernel.c -o kernel.o
# 链接
echo "链接..."
ld.lld --entry=_start -o kernel.elf -T linker.ld kernel_entry.o kernel.o
# 转换为裸二进制
llvm-objcopy -O binary kernel.elf kernel.bin
echo "删文件"
rm kernel_entry.o kernel.o
# 在 QEMU virt 虚拟机中测试（无 BIOS，直接加载）
#qemu-system-aarch64 -machine virt -cpu cortex-a53 -nographic -bios none -kernel kernel.bin
