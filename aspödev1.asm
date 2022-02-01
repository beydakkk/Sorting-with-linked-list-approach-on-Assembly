SSEG 	SEGMENT PARA STACK 'STACK'
		DW 32 DUP (?)

SSEG 	ENDS

DSEG	SEGMENT PARA 'DATA'
head    DW 0
dizi    DW 100 DUP(?)
link    DW 100 DUP(?)

CR	EQU 13
LF	EQU 10

A1   	DB '                   MENU',0
cizgi   DB CR,LF,'----------------------------------------------',0
A2 		DB CR,LF, '1-Diziyi Olusturma',0
A3 		DB CR,LF, '2-Diziyi Gorsellestirme',0
A4		DB CR,LF, '3-Diziye Eleman Ekleme',0
A5		DB CR,LF, 'Dizinin eleman sayisini giriniz: ' ,0
AD      DB CR,LF, '                BEYDA GULER',0
NO      DB CR,LF, '                  19011010',0
ADNO    DB CR,LF, '            BEYDA GULER 19011010',0
A6      DB CR,LF, 'eleman ekle:',0
A7      DB CR,LF, ' ',0
A8      DB CR,LF, '4-Cikis',0
A9      DB CR,LF, '--->',0
B1      DB CR,LF, ' - ',0
IND     DB CR,LF, 'INDIS ',0
D       DB CR,LF, 'DIZI  ',0
L       DB CR,LF, 'LINK  ',0
X       DB CR,LF, 'Islem seciniz-->',0
kac_eleman DB CR,LF, 'Kac eleman eklemek istiyorsunuz',0
cik     DB CR,LF, 'Cikis Yapildi',0
HATA	DB CR, LF, 'Dikkat !!! Sayi vermediniz yeniden giris yapiniz.!!!  ', 0
n 		DW ?
j       DW 0

secim   DW ?

DSEG 	ENDS 

CSEG 	SEGMENT PARA 'CODE'
	ASSUME CS:CSEG, DS:DSEG, SS:SSEG
MAIN 	PROC FAR

		PUSH DS
        XOR AX,AX
        PUSH AX
        MOV AX, DSEG 
        MOV DS, AX
		
		MOV AX, OFFSET AD
		CALL PUT_STR
		MOV AX, OFFSET NO
		CALL PUT_STR
		MOV AX, OFFSET cizgi
		CALL PUT_STR
		MOV AX, OFFSET A7
		CALL PUT_STR
		MOV AX, OFFSET A1 ;A1'i yazdır
		CALL PUT_STR
		MOV AX, OFFSET A2
		CALL PUT_STR
		MOV AX, OFFSET A3
		CALL PUT_STR
		MOV AX, OFFSET A4
		CALL PUT_STR
		MOV AX, OFFSET A8
		CALL PUT_STR
		
		
ANA_MENU: MOV AX, OFFSET X
		CALL PUT_STR
		CALL GETN
		MOV secim,AX
		CMP secim,1
		JE MENU1
		CMP secim,2
		JE MENU2
		CMP secim,3
		JE MENU3
		CMP secim,4
		JE CİKİS
		
		XOR SI,SI
		
MENU1:  MOV AX,OFFSET ADNO
		CALL PUT_STR
		MOV AX, OFFSET A5
		CALL PUT_STR
		CALL GETN
		MOV n,AX
    	MOV CX,n
don:	MOV AX,OFFSET A6
		CALL PUT_STR
		CALL GETN
		MOV dizi[SI],AX
		CALL LISTE
		PUSH DX
		MOV DX,j
		INC DX
		INC DX
		MOV j,DX
		POP DX
		ADD SI,2
		LOOP don
		JMP ANA_MENU



MENU2: CALL GORSELLESTİR
	   JMP ANA_MENU

MENU3:  
		
		CALL EKLE
		
		CALL LISTE
		INC j
		INC j
		ADD SI,2
		
		
		JMP ANA_MENU
		
CİKİS:  MOV AX, OFFSET cik
		CALL PUT_STR
		MOV AX, OFFSET ADNO
		CALL PUT_STR

		RETF

MAIN ENDP
 
EKLE PROC NEAR
		
		MOV AX,OFFSET A6 
		CALL PUT_STR
		
		CALL GETN
		INC n
		MOV dizi[SI],AX
		
	RET
EKLE ENDP

GORSELLESTİR PROC NEAR
		PUSH SI
		MOV AX,OFFSET ADNO
		CALL PUT_STR
		MOV AX,OFFSET IND
		CALL PUT_STR
		XOR SI,SI
		MOV CX,n
dongu:  MOV AX,SI
		CALL PUTN 
		MOV AX,' '
		CALL PUTC
		MOV AX, '-'
		CALL PUTC
		MOV AX,' '
		CALL PUTC
		INC SI
		LOOP dongu
		MOV AX,OFFSET D
		CALL PUT_STR
		XOR SI,SI
		MOV CX,n
dongu2:	MOV AX,dizi[SI]
		CALL PUTN
		MOV AX,' '
		CALL PUTC
		MOV AX, '-'
		CALL PUTC
		MOV AX,' '
		CALL PUTC
		ADD SI,2
		LOOP dongu2
		MOV AX,OFFSET L
		CALL PUT_STR
		XOR SI,SI
		MOV CX,n
dongu3:	MOV AX,link[SI]
		CMP AX,0
		JL yaz
		PUSH BX
		XOR BX,BX
		MOV BL,2
		DIV BL
		POP BX
yaz:	CALL PUTN
		MOV AX,' '
		CALL PUTC
		MOV AX, '-'
		CALL PUTC
		MOV AX,' '
		CALL PUTC
		ADD SI,2
		LOOP dongu3
		POP SI
	RET
GORSELLESTİR ENDP


LISTE PROC NEAR
		PUSH SI
		PUSH BX
		XOR DI,DI ; tmp=0
		MOV BX,j
		CMP BX,0   ; j= 0 mı yani ilk eleman mı kontrolü
		JNE degil  
		MOV link[BX],-1
		JMP son
		
degil:
		MOV DI,head
		
tekrar:	CMP link[DI],-1
		JE kontrol
		MOV DX,dizi[DI]
		CMP DX,dizi[BX]
		JG kontrol
		MOV SI,DI
		MOV DI,link[DI]
		JMP tekrar
		
		
kontrol:CMP link[DI],-1
		JNE kontrol2
		MOV DX,dizi[BX]
		CMP DX,dizi[DI]
		JL kontrol2
		MOV link[DI],BX
		MOV link[BX],-1
		JMP son
		
		 
kontrol2:
		MOV DX,dizi[BX]
		PUSH DI
		MOV DI,head
		CMP DX,dizi[DI]
		JG false
		MOV link[BX],DI
		MOV DI,BX
		MOV head,DI
		POP DI
		JMP son
		
false:  POP DI
		MOV link[SI],BX
		MOV link[BX],DI
			
son:	POP BX
		POP SI 


	RET 
LISTE ENDP

GETC	PROC NEAR
        ;------------------------------------------------------------------------
        ; Klavyeden basılan karakteri AL yazmacına alır ve ekranda gösterir. 
        ; işlem sonucunda sadece AL etkilenir. 
        ;------------------------------------------------------------------------
        MOV AH, 1h
        INT 21H
        RET 
GETC	ENDP 

PUTC	PROC NEAR
        ;------------------------------------------------------------------------
        ; AL yazmacındaki değeri ekranda gösterir. DL ve AH değişiyor. AX ve DX 
        ; yazmaçlarının değerleri korumak için PUSH/POP yapılır. 
        ;------------------------------------------------------------------------
        PUSH AX
        PUSH DX
        MOV DL, AL
        MOV AH,2
        INT 21H
        POP DX
        POP AX
        RET 
PUTC 	ENDP 

GETN 	PROC NEAR
        ;------------------------------------------------------------------------
        ; Klavyeden basılan sayiyi okur, sonucu AX yazmacı üzerinden dondurur. 
        ; DX: sayının işaretli olup/olmadığını belirler. 1 (+), -1 (-) demek 
        ; BL: hane bilgisini tutar 
        ; CX: okunan sayının islenmesi sırasındaki ara değeri tutar. 
        ; AL: klavyeden okunan karakteri tutar (ASCII)
        ; AX zaten dönüş değeri olarak değişmek durumundadır. Ancak diğer 
        ; yazmaçların önceki değerleri korunmalıdır. 
        ;------------------------------------------------------------------------
        PUSH BX
        PUSH CX
        PUSH DX
GETN_START:
        MOV DX, 1	                        ; sayının şimdilik + olduğunu varsayalım 
        XOR BX, BX 	                        ; okuma yapmadı Hane 0 olur. 
        XOR CX,CX	                        ; ara toplam değeri de 0’dır. 
NEW:
        CALL GETC	                        ; klavyeden ilk değeri AL’ye oku. 
        CMP AL,CR 
        JE FIN_READ	                        ; Enter tuşuna basilmiş ise okuma biter
        CMP  AL, '-'	                        ; AL ,'-' mi geldi ? 
        JNE  CTRL_NUM	                        ; gelen 0-9 arasında bir sayı mı?
NEGATIVE:
        MOV DX, -1	                        ; - basıldı ise sayı negatif, DX=-1 olur
        JMP NEW		                        ; yeni haneyi al
CTRL_NUM:
        CMP AL, '0'	                        ; sayının 0-9 arasında olduğunu kontrol et.
        JB error 
        CMP AL, '9'
        JA error		                ; değil ise HATA mesajı verilecek
        SUB AL,'0'	                        ; rakam alındı, haneyi toplama dâhil et 
        MOV BL, AL	                        ; BL’ye okunan haneyi koy 
        MOV AX, 10 	                        ; Haneyi eklerken *10 yapılacak 
        PUSH DX		                        ; MUL komutu DX’i bozar işaret için saklanmalı
        MUL CX		                        ; DX:AX = AX * CX
        POP DX		                        ; işareti geri al 
        MOV CX, AX	                        ; CX deki ara değer *10 yapıldı 
        ADD CX, BX 	                        ; okunan haneyi ara değere ekle 
        JMP NEW 		                ; klavyeden yeni basılan değeri al 
ERROR:
        MOV AX, OFFSET HATA 
        CALL PUT_STR	                        ; HATA mesajını göster 
        JMP GETN_START                          ; o ana kadar okunanları unut yeniden sayı almaya başla 
FIN_READ:
        MOV AX, CX	                        ; sonuç AX üzerinden dönecek 
        CMP DX, 1	                        ; İşarete göre sayıyı ayarlamak lazım 
        JE FIN_GETN
        NEG AX		                        ; AX = -AX
FIN_GETN:
        POP DX
        POP CX
        POP DX
        RET 
GETN 	ENDP 


PUTN 	PROC NEAR
        ;------------------------------------------------------------------------
        ; AX de bulunan sayiyi onluk tabanda hane hane yazdırır. 
        ; CX: haneleri 10’a bölerek bulacağız, CX=10 olacak
        ; DX: 32 bölmede işleme dâhil olacak. Soncu etkilemesin diye 0 olmalı 
        ;------------------------------------------------------------------------
        PUSH CX
        PUSH DX 	
        XOR DX,	DX 	                        ; DX 32 bit bölmede soncu etkilemesin diye 0 olmalı 
        PUSH DX		                        ; haneleri ASCII karakter olarak yığında saklayacağız.
                                                ; Kaç haneyi alacağımızı bilmediğimiz için yığına 0 
                                                ; değeri koyup onu alana kadar devam edelim.
        MOV CX, 10	                        ; CX = 10
        CMP AX, 0
        JGE CALC_DIGITS	
        NEG AX 		                        ; sayı negatif ise AX pozitif yapılır. 
        PUSH AX		                        ; AX sakla 
        MOV AL, '-'	                        ; işareti ekrana yazdır. 
        CALL PUTC
        POP AX		                        ; AX’i geri al 
        
CALC_DIGITS:
        DIV CX  		                ; DX:AX = AX/CX  AX = bölüm DX = kalan 
        ADD DX, '0'	                        ; kalan değerini ASCII olarak bul 
        PUSH DX		                        ; yığına sakla 
        XOR DX,DX	                        ; DX = 0
        CMP AX, 0	                        ; bölen 0 kaldı ise sayının işlenmesi bitti demek
        JNE CALC_DIGITS	                        ; işlemi tekrarla 
        
DISP_LOOP:
                                                ; yazılacak tüm haneler yığında. En anlamlı hane üstte 
                                                ; en az anlamlı hane en alta ve onu altında da 
                                                ; sona vardığımızı anlamak için konan 0 değeri var. 
        POP AX		                        ; sırayla değerleri yığından alalım
        CMP AX, 0 	                        ; AX=0 olursa sona geldik demek 
        JE END_DISP_LOOP 
        CALL PUTC 	                        ; AL deki ASCII değeri yaz
        JMP DISP_LOOP                           ; işleme devam
        
END_DISP_LOOP:
        POP DX 
        POP CX
        RET
PUTN 	ENDP 

PUT_STR	PROC NEAR
        ;------------------------------------------------------------------------
        ; AX de adresi verilen sonunda 0 olan dizgeyi karakter karakter yazdırır.
        ; BX dizgeye indis olarak kullanılır. Önceki değeri saklanmalıdır. 
        ;------------------------------------------------------------------------
	PUSH BX 
        MOV BX,	AX			        ; Adresi BX’e al 
        MOV AL, BYTE PTR [BX]	                ; AL’de ilk karakter var 
PUT_LOOP:   
        CMP AL,0		
        JE  PUT_FIN 			        ; 0 geldi ise dizge sona erdi demek
        CALL PUTC 			        ; AL’deki karakteri ekrana yazar
        INC BX 				        ; bir sonraki karaktere geç
        MOV AL, BYTE PTR [BX]
        JMP PUT_LOOP			        ; yazdırmaya devam 
PUT_FIN:
	POP BX
	RET 
PUT_STR	ENDP

CSEG 	ENDS 
	END MAIN