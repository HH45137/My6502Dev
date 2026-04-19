.include "emu_setting.asm"

.target "6502"
.format "prg"


*=$02a7	; 读取程序Ready后用户手动执行命令sys 679启动这个程序

MAIN_S:
	; 设置字符串地址
	lda #<SET_STRING_S		; 将字符串地址的低字节部分作为立即数写入寄存器A
	sta $fb					; 将寄存器A里面的字符串的低字节部分写入立即数表示的零页地址fb
	lda #>SET_STRING_S		; 将字符串地址的高字节部分作为立即数写入寄存器A
	sta $fc					; 将寄存器A里面的字符串的高字节部分写入立即数表示的零页地址fc

	; 调用显示子程序
	jsr PRINT_STR_S

	; 死循环保持画面
	jmp *		; *表示当前执行的指令的地址


PRINT_STR_S:
	ldy #$00		; 初始化索引y为立即数0
@loop:  
	lda ($fb),y		; 间接变址寻址，一个个读取字符串，y相当于index
	beq @done
	and #$3f		; 寄存器A与立即数做与运算，保留低6位，做到PETSCLL转屏幕代码
	sta $0400,y		; 将寄存器A里面的屏幕代码写入立即数表示的屏幕内存地址，y作为偏移
	lda #$01		; 将立即数作为背景颜色写入寄存器A
	sta $d800,y		; 将寄存器A里面的字颜色写入立即数表示的字颜色内存地址，y作为偏移，与屏幕内存地址一一对应
	iny				; y++
	jmp @loop
@done:  rts


SET_STRING_S:
	.text "I LOVE CCB EVERYDAY!"
	.byte $00	; 字符串结束标志
