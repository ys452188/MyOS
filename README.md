# MyOS:微型操作系统   By硫酸铜非常好吃
书写语言：汇编、C语言
特点：
- 可以在串口输出一个字符串
---
## 启动流程：
```text
[BIOS] → 加载boot.asm到0x7C00 → 输出文字 → 跳转加载内核 → 执行kernel_entry.s → 调用kernel.c的kmain()
```
## 编译：
```bash
bash ./compile.sh
```
## 源文件：
- boot.asm：引导扇区
- kernel_entry.s：内核入口
- kernel.c：内核
- compile.sh：编译脚本
- link.ld：链接脚本