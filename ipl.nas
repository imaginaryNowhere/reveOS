; reveOS-ipl
; TAB=4

CYLS	EQU		10				; CYLS��??10

		ORG		0x7c00			; ??�������?�n��

; ��?FAT12��?�M��

		JMP		entry
		DB		0x90			
		DB		"reve-ipl"		; ??�於��
		DW		512				; ?�����512��?
		DB		1				; ?���Ƒ召?1�����
		DW		1				; FAT�N�n�ʒu����1�����?�n
		DB		2				; 2��FAT
		DW		224				; ��?����??224?
		DW		2880			; ��?�L2880�����
		DB		0xf0			; ��????0xf0
		DW		9				; FAT?9���?
		DW		18				; 1����(����)18�����
		DW		2				; 2����?
		DD		0				; �s�g�p����
		DD		2880			; �d�ʎ�?�召
		DB		0,0,0x29		; 
		DD		0xffffffff		; ��?
		DB		"reveOS     "	; ��?���i11��?�j
		DB		"FAT12   "		; ��?�i�����i8��?�j
		RESB	18				; ��o18��?

		entry:
		MOV		AX,0			; �񑶊�I���n��
		MOV		SS,AX
		MOV		SP,0x7c00
		MOV		DS,AX

		MOV		AX,0x0820		; ?���������ʒu�C10����?�t��
		MOV		ES,AX
		MOV		CH,0			; ����0
		MOV		DH,0			; ��?0
		MOV		CL,2			; ���2
readloop:
		MOV		SI,0			; �񑶊�SI?��??��?�I����
retry:
		MOV		AH,0x02			; BIOS?����?
		MOV		AL,1			; ?1�����
		MOV		BX,0
		MOV		DL,0x00			; ??��A
		INT		0x13			; ?�p��?BIOS
		JNC		next			; �v�L�o?��next
		ADD		SI,1			; 
		CMP		SI,5			; 
		JAE		error			; SI >= 5 ��?��error
		MOV		AH,0x00
		MOV		DL,0x00			; 
		INT		0x13			; �o?�@�d�u??��
		JMP		retry
next:
		MOV		AX,ES			
		ADD		AX,0x0020
		MOV		ES,AX			; ?���n������512��?(0X200)�C���Ӎ�??ES:BX�����n���\�������B�s�\?ES����ADD
		ADD		CL,1			; ���꘢���
		CMP		CL,18			; 
		JBE		readloop		; CL <= 18 ��?��readloop
		MOV		CL,1
		ADD		DH,1			; ��?1
		CMP		DH,2
		JB		readloop		; DH < 2 ��?��readloop
		MOV		DH,0
		ADD		CH,1
		CMP		CH,CYLS
		JB		readloop		; CH < CYLS ��?��readloop

; �ȏ�?��FAT12??10�����ʎ������C���n��0x08200?�n�C184320��?

fin:
		HLT						; CPU��~
		JMP		fin				; ��?�z?

error:
		MOV		SI,msg
putloop:						; BIOS?������
		MOV		AL,[SI]
		ADD		SI,1			; �꘢�꘢?������
		CMP		AL,0
		JE		fin
		MOV		AH,0x0e			; BIOS?������
		MOV		BX,15			; 
		INT		0x10			; ?�pBIOS
		JMP		putloop
msg:
		DB		0x0a, 0x0a		; ?��?�s��
		DB		"load error"
		DB		0x0a			; ?�s��
		DB		0

		RESB	0x7dfe-$		; ����?�꒼��0x7dfe�U��0

		DB		0x55, 0xaa		;??��?��?�u
