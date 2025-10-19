#echo "编译引导扇区(boot.asm)"
#nasm -f bin boot.asm -o boot.bin     #编译boot.asm
#编译内核
echo "编译内核(kernel.c)"
clang -target aarch64-none-elf -ffreestanding -c kernel.c -o kernel.o
echo "编译内核入口(kernel_entry.s)"
clang -target aarch64-none-elf -c kernel_entry.s -o kernel_entry.o
echo "链接"
ld.lld -T link.ld -o MyOS.elf kernel_entry.o kernel.o
#删除编译时产生的其他文件
rm kernel_entry.o kernel.o #boot.bin
llvm-objcopy -O binary MyOS.elf MyOS.img
echo "编译完成,镜像为 MyOS.img"