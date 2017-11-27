; reveOS-ipl
; TAB=4

CYLS	EQU		10				; CYLS定??10

		ORG		0x7c00			; ??区内存装?地址

; 存?FAT12磁?信息

		JMP		entry
		DB		0x90			
		DB		"reve-ipl"		; ??区名称
		DW		512				; ?个扇区512字?
		DB		1				; ?个簇大小?1个扇区
		DW		1				; FAT起始位置从第1个扇区?始
		DB		2				; 2个FAT
		DW		224				; 磁?根目??224?
		DW		2880			; 磁?有2880个扇区
		DB		0xf0			; 磁????0xf0
		DW		9				; FAT?9扇区?
		DW		18				; 1磁道(柱面)18个扇区
		DW		2				; 2个磁?
		DD		0				; 不使用分区
		DD		2880			; 重写磁?大小
		DB		0,0,0x29		; 
		DD		0xffffffff		; 卷?
		DB		"reveOS     "	; 磁?名（11字?）
		DB		"FAT12   "		; 磁?格式名（8字?）
		RESB	18				; 空出18字?

		entry:
		MOV		AX,0			; 寄存器的初始化
		MOV		SS,AX
		MOV		SP,0x7c00
		MOV		DS,AX

		MOV		AX,0x0820		; ?入至内存位置，10柱面?冲区
		MOV		ES,AX
		MOV		CH,0			; 柱面0
		MOV		DH,0			; 磁?0
		MOV		CL,2			; 扇区2
readloop:
		MOV		SI,0			; 寄存器SI?存??失?的次数
retry:
		MOV		AH,0x02			; BIOS?入磁?
		MOV		AL,1			; ?1个扇区
		MOV		BX,0
		MOV		DL,0x00			; ??器A
		INT		0x13			; ?用磁?BIOS
		JNC		next			; 没有出?到next
		ADD		SI,1			; 
		CMP		SI,5			; 
		JAE		error			; SI >= 5 跳?到error
		MOV		AH,0x00
		MOV		DL,0x00			; 
		INT		0x13			; 出?后重置??器
		JMP		retry
next:
		MOV		AX,ES			
		ADD		AX,0x0020
		MOV		ES,AX			; ?入地址增加512字?(0X200)，注意此??ES:BX内存地址表示方式。不能?ES直接ADD
		ADD		CL,1			; 下一个扇区
		CMP		CL,18			; 
		JBE		readloop		; CL <= 18 跳?至readloop
		MOV		CL,1
		ADD		DH,1			; 磁?1
		CMP		DH,2
		JB		readloop		; DH < 2 跳?至readloop
		MOV		DH,0
		ADD		CH,1
		CMP		CH,CYLS
		JB		readloop		; CH < CYLS 跳?至readloop

; 以上?入FAT12??10个柱面至内存，从地址0x08200?始，184320字?

fin:
		HLT						; CPU停止
		JMP		fin				; 无?循?

error:
		MOV		SI,msg
putloop:						; BIOS?示字符
		MOV		AL,[SI]
		ADD		SI,1			; 一个一个?示字符
		CMP		AL,0
		JE		fin
		MOV		AH,0x0e			; BIOS?示字符
		MOV		BX,15			; 
		INT		0x10			; ?用BIOS
		JMP		putloop
msg:
		DB		0x0a, 0x0a		; ?个?行符
		DB		"load error"
		DB		0x0a			; ?行符
		DB		0

		RESB	0x7dfe-$		; 从此?一直到0x7dfe填入0

		DB		0x55, 0xaa		;??区?束?志
