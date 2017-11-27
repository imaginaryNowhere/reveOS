; reveOS-ipl
; TAB=4

CYLS	EQU		10				; CYLS����Ϊ10������10������

		ORG		0x7c00			; ����װ�ص�ַ

; FAT12��Ϣ

		JMP		entry
		DB		0x90			
		DB		"reve-ipl"		; ����������
		DW		512				; ������С
		DB		1				; �ش�С(һ������)
		DW		1				; FAT��ʼλ��(��һ������)
		DB		2				; FAT����Ϊ2
		DW		224				; ��Ŀ¼224��
		DW		2880			; ���̴�С2880
		DB		0xf0			; ��������Ϊ0xf0
		DW		9				; FAT����Ϊ9������
		DW		18				; 1���ŵ���18������
		DW		2				; ��ͷ��Ϊ2
		DD		0				; �����÷���
		DD		2880			; ��дһ�δ��̴�С
		DB		0,0,0x29		; 
		DD		0xffffffff		; ���
		DB		"reveOS     "	; ��������
		DB		"FAT12   "		; ���̸�ʽ����
		RESB	18				; �ճ�18���ֽ�

		entry:
		MOV		AX,0			; ��ʼ���Ĵ���
		MOV		SS,AX
		MOV		SP,0x7c00
		MOV		DS,AX

		MOV		AX,0x0820		; �����ڴ��0x08200
		MOV		ES,AX
		MOV		CH,0			; ����0
		MOV		DH,0			; ��ͷ0
		MOV		CL,2			; ����2
readloop:
		MOV		SI,0			; SI��¼����ʧ�ܴ��� �����
retry:
		MOV		AH,0x02			; BIOS�������
		MOV		AL,1			; ��1������
		MOV		BX,0
		MOV		DL,0x00			; A������
		INT		0x13			; BIOS�������
		JNC		next			;
		ADD		SI,1			; 
		CMP		SI,5			; 
		JAE		error			; SI >= 5 ��ת��error
		MOV		AH,0x00
		MOV		DL,0x00			; 
		INT		0x13			; ����������
		JMP		retry
next:
		MOV		AX,ES			
		ADD		AX,0x0020
		MOV		ES,AX			; �ڴ��ַ����512(0x200)���˴�ΪES:BX�ڴ��ʾ
		ADD		CL,1			; 
		CMP		CL,18			; 
		JBE		readloop		; CL <= 18 ��תreadloop
		MOV		CL,1
		ADD		DH,1			; ��ͷ1
		CMP		DH,2
		JB		readloop		; DH < 2 ��תreadloop
		MOV		DH,0
		ADD		CH,1
		CMP		CH,CYLS
		JB		readloop		; CH < CYLS ��תreadloop

; �����̶���184320�ֽڣ����ڴ�0x08200
		MOV		[0x0ff0],CH		;������װ�����ݵĽ�����ַ�����ڴ�	
		JMP		0xc200					
fin:
		HLT						; CPUֹͣ
		JMP		fin				; ����ѭ��

error:
		MOV		SI,msg
putloop:						; BIOS��ʾ
		MOV		AL,[SI]
		ADD		SI,1			; ÿ����ʾһ������
		CMP		AL,0
		JE		fin
		MOV		AH,0x0e			; 
		MOV		BX,15			; 
		INT		0x10			; �����Կ�BIOS
		JMP		putloop
msg:
		DB		0x0a, 0x0a		; �������з�
		DB		"load error"
		DB		0x0a			; ���з�
		DB		0

		RESB	0x7dfe-$		; �Ӵ˴�ֱ��0x7dfe��0

		DB		0x55, 0xaa		; ����������

