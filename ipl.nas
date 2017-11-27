; reveOS-ipl
; TAB=4

CYLS	EQU		10				; CYLSè??10

		ORG		0x7c00			; ??æà¶?n¬

; ¶?FAT12¥?M§

		JMP		entry
		DB		0x90			
		DB		"reve-ipl"		; ??æ¼Ì
		DW		512				; ?¢îæ512?
		DB		1				; ?¢âÆå¬?1¢îæ
		DW		1				; FATNnÊu¸æ1¢îæ?n
		DB		2				; 2¢FAT
		DW		224				; ¥?ªÚ??224?
		DW		2880			; ¥?L2880¢îæ
		DB		0xf0			; ¥????0xf0
		DW		9				; FAT?9îæ?
		DW		18				; 1¥¹(Ê)18¢îæ
		DW		2				; 2¢¥?
		DD		0				; sgpªæ
		DD		2880			; dÊ¥?å¬
		DB		0,0,0x29		; 
		DD		0xffffffff		; É?
		DB		"reveOS     "	; ¥?¼i11?j
		DB		"FAT12   "		; ¥?i®¼i8?j
		RESB	18				; óo18?

		entry:
		MOV		AX,0			; ñ¶íIn»
		MOV		SS,AX
		MOV		SP,0x7c00
		MOV		DS,AX

		MOV		AX,0x0820		; ?üà¶ÊuC10Ê?tæ
		MOV		ES,AX
		MOV		CH,0			; Ê0
		MOV		DH,0			; ¥?0
		MOV		CL,2			; îæ2
readloop:
		MOV		SI,0			; ñ¶íSI?¶??¸?I
retry:
		MOV		AH,0x02			; BIOS?ü¥?
		MOV		AL,1			; ?1¢îæ
		MOV		BX,0
		MOV		DL,0x00			; ??íA
		INT		0x13			; ?p¥?BIOS
		JNC		next			; vLo?next
		ADD		SI,1			; 
		CMP		SI,5			; 
		JAE		error			; SI >= 5 µ?error
		MOV		AH,0x00
		MOV		DL,0x00			; 
		INT		0x13			; o?@du??í
		JMP		retry
next:
		MOV		AX,ES			
		ADD		AX,0x0020
		MOV		ES,AX			; ?ün¬úÁ512?(0X200)CÓ??ES:BXà¶n¬\¦û®Bs\?ES¼ÚADD
		ADD		CL,1			; ºê¢îæ
		CMP		CL,18			; 
		JBE		readloop		; CL <= 18 µ?readloop
		MOV		CL,1
		ADD		DH,1			; ¥?1
		CMP		DH,2
		JB		readloop		; DH < 2 µ?readloop
		MOV		DH,0
		ADD		CH,1
		CMP		CH,CYLS
		JB		readloop		; CH < CYLS µ?readloop

; Èã?üFAT12??10¢Êà¶C¸n¬0x08200?nC184320?

fin:
		HLT						; CPUâ~
		JMP		fin				; Ù?z?

error:
		MOV		SI,msg
putloop:						; BIOS?¦
		MOV		AL,[SI]
		ADD		SI,1			; ê¢ê¢?¦
		CMP		AL,0
		JE		fin
		MOV		AH,0x0e			; BIOS?¦
		MOV		BX,15			; 
		INT		0x10			; ?pBIOS
		JMP		putloop
msg:
		DB		0x0a, 0x0a		; ?¢?s
		DB		"load error"
		DB		0x0a			; ?s
		DB		0

		RESB	0x7dfe-$		; ¸?ê¼0x7dfeUü0

		DB		0x55, 0xaa		;??æ?©?u
