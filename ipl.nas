; reveOS-ipl
; TAB=4

CYLS	EQU		10				; CYLS定义为10，读入10个柱面

		ORG		0x7c00			; 程序装载地址

; FAT12信息

		JMP		entry
		DB		0x90			
		DB		"reve-ipl"		; 启动区名称
		DW		512				; 扇区大小
		DB		1				; 簇大小(一个扇区)
		DW		1				; FAT起始位置(第一个扇区)
		DB		2				; FAT个数为2
		DW		224				; 根目录224个
		DW		2880			; 磁盘大小2880
		DB		0xf0			; 磁盘种类为0xf0
		DW		9				; FAT长度为9个扇区
		DW		18				; 1个磁道有18个扇区
		DW		2				; 磁头数为2
		DD		0				; 不适用分区
		DD		2880			; 重写一次磁盘大小
		DB		0,0,0x29		; 
		DD		0xffffffff		; 卷标
		DB		"reveOS     "	; 磁盘名称
		DB		"FAT12   "		; 磁盘格式名称
		RESB	18				; 空出18个字节

		entry:
		MOV		AX,0			; 初始化寄存器
		MOV		SS,AX
		MOV		SP,0x7c00
		MOV		DS,AX

		MOV		AX,0x0820		; 读到内存的0x08200
		MOV		ES,AX
		MOV		CH,0			; 柱面0
		MOV		DH,0			; 磁头0
		MOV		CL,2			; 扇区2
readloop:
		MOV		SI,0			; SI记录读盘失败次数 读五次
retry:
		MOV		AH,0x02			; BIOS读入磁盘
		MOV		AL,1			; 读1个扇区
		MOV		BX,0
		MOV		DL,0x00			; A驱动器
		INT		0x13			; BIOS读入磁盘
		JNC		next			;
		ADD		SI,1			; 
		CMP		SI,5			; 
		JAE		error			; SI >= 5 跳转至error
		MOV		AH,0x00
		MOV		DL,0x00			; 
		INT		0x13			; 重置驱动器
		JMP		retry
next:
		MOV		AX,ES			
		ADD		AX,0x0020
		MOV		ES,AX			; 内存地址后移512(0x200)。此处为ES:BX内存表示
		ADD		CL,1			; 
		CMP		CL,18			; 
		JBE		readloop		; CL <= 18 跳转readloop
		MOV		CL,1
		ADD		DH,1			; 磁头1
		CMP		DH,2
		JB		readloop		; DH < 2 跳转readloop
		MOV		DH,0
		ADD		CH,1
		CMP		CH,CYLS
		JB		readloop		; CH < CYLS 跳转readloop

; 从软盘读入184320字节，到内存0x08200
		MOV		[0x0ff0],CH		;将磁盘装载内容的结束地址存入内存	
		JMP		0xc200					
fin:
		HLT						; CPU停止
		JMP		fin				; 无限循环

error:
		MOV		SI,msg
putloop:						; BIOS显示
		MOV		AL,[SI]
		ADD		SI,1			; 每次显示一个文字
		CMP		AL,0
		JE		fin
		MOV		AH,0x0e			; 
		MOV		BX,15			; 
		INT		0x10			; 调用显卡BIOS
		JMP		putloop
msg:
		DB		0x0a, 0x0a		; 两个换行符
		DB		"load error"
		DB		0x0a			; 换行符
		DB		0

		RESB	0x7dfe-$		; 从此处直到0x7dfe填0

		DB		0x55, 0xaa		; 启动区结束

