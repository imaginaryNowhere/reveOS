;reveOS
;TAB=4

;有关BOOT_INFO
CYLS	EQU		0x0ff0			; 读入储存的系统程序结束位置(扇区数)
LEDS	EQU		0x0ff1				
VMODE	EQU		0x0ff2			; 颜色位数信息
SCRNX	EQU		0x0ff4			; 分辨率的x
SCRNY	EQU		0x0ff6			; 分辨率的y
VRAM	EQU		0x0ff8			; 图像缓冲区首地址

		ORG		0xc200			; 系统装载入内存的0xc200
		
		MOV		AL, 0x13	 	; VGA显卡，300*200*8位色彩
		MOV		AH,	0x00
		INT		0x10
		MOV		BYTE [VMODE],8	; 记录画面模式(颜色位数信息，8位)
		MOV		WORD [SCRNX],320
		MOV		WORD [SCRNY],200; 记录分辨率信息
		MOV		DWORD[VRAM],0x000a0000
		; 记录图像缓冲区首地址
		
; 使用BIOS提供函数获取键盘上的LED灯
		MOV		AH,0x02
		INT		x016	;键盘BIOS
		MOV		[LEDS],AL

fin:
		HLT
		JMP		fin