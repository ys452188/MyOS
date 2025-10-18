;引导扇区
bits 16      ;告诉汇编器生成的是16位代码,CPU此时是 16 位寻址
org 0x7c00   ;加载基址是0x7C00

mov si, msg  ;主程序入口
call print_string    ;输出"正在启动内核..."
jmp $        ;跳转到自身,相当于无限循环,以避免未定义行为

print_string:
    lodsb    ;lodsb指令会用SI指向的内存逐字节取数据(从 DS:SI 取一个字节到 AL，然后 SI++)
    or al, al
    jz .done ;检查字符串结尾
    mov ah, 0x0e
    int 0x10
    jmp print_string
.done:
    ret

msg db "正在启动内核...", 0  ;定义字符串，末尾补 0 作为结束符
;填充
;$ = 当前地址，$$ = 本节开头地址。
;($-$$) = 代码和数据目前占用的字节数。
;510-($-$$) = 还差多少字节到第 510 字节。
;db 0 = 填充 0，使整个文件长度到达 510 字节。
times 510-($-$$) db 0
dw 0xAA55    ; MBR 魔数
