;reveOS
;TAB=4

		ORG		0xc200		 ;系统装载入内存的0xc200
		
		MOV		AL, 0x13	 ;VGA显卡，300*200*8位色彩
		MOV		AH,	0x00
		INT		0x10
fin:
		HLT
		JMP		fin