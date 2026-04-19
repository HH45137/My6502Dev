.include "emu_setting.asm"

.target "6502"
.format "prg"


*=$02a7	; sys 679

MAIN_S:
	; 设置字符串地址
	lda #<SET_STRING_S
	sta $fb
	lda #>SET_STRING_S
	sta $fc

	; 调用显示子程序
	jsr PRINT_STR_S

	; 死循环保持画面
	jmp *


PRINT_STR_S:
	ldy #$00
@loop:  
	lda ($fb),y
	beq @done
	and #$3f
	sta $0400,y
	lda #$01
	sta $d800,y
	iny
	jmp @loop
@done:  rts


SET_STRING_S:
	.text "I LOVE CCB EVERYDAY!"
	.byte $00
