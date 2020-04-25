
_main:

;Protocolo_SPI.c,2 :: 		void main() {
;Protocolo_SPI.c,3 :: 		TRISC.F3 = 0; //CLK SPI
	BCF        TRISC+0, 3
;Protocolo_SPI.c,4 :: 		TRISC.F5 = 0; //MOSI - SDO
	BCF        TRISC+0, 5
;Protocolo_SPI.c,5 :: 		TRISC.F4 = 1; //MISO - SDI
	BSF        TRISC+0, 4
;Protocolo_SPI.c,6 :: 		TRISD.F0 = 0; //CS
	BCF        TRISD+0, 0
;Protocolo_SPI.c,7 :: 		SSPSTAT = 0X40;
	MOVLW      64
	MOVWF      SSPSTAT+0
;Protocolo_SPI.c,8 :: 		SSPCON =  0X20;
	MOVLW      32
	MOVWF      SSPCON+0
;Protocolo_SPI.c,9 :: 		CS = 1;
	BSF        PORTD+0, 0
;Protocolo_SPI.c,10 :: 		Delay_ms(100);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_main0:
	DECFSZ     R13+0, 1
	GOTO       L_main0
	DECFSZ     R12+0, 1
	GOTO       L_main0
	NOP
	NOP
;Protocolo_SPI.c,11 :: 		while(1){
L_main1:
;Protocolo_SPI.c,12 :: 		CS = 0;
	BCF        PORTD+0, 0
;Protocolo_SPI.c,13 :: 		SSPBUF = 'H';
	MOVLW      72
	MOVWF      SSPBUF+0
;Protocolo_SPI.c,14 :: 		while(!SSPSTAT.BF);
L_main3:
	BTFSC      SSPSTAT+0, 0
	GOTO       L_main4
	GOTO       L_main3
L_main4:
;Protocolo_SPI.c,15 :: 		SSPBUF = 'O';
	MOVLW      79
	MOVWF      SSPBUF+0
;Protocolo_SPI.c,16 :: 		while(!SSPSTAT.BF);
L_main5:
	BTFSC      SSPSTAT+0, 0
	GOTO       L_main6
	GOTO       L_main5
L_main6:
;Protocolo_SPI.c,17 :: 		SSPBUF = 'L';
	MOVLW      76
	MOVWF      SSPBUF+0
;Protocolo_SPI.c,18 :: 		while(!SSPSTAT.BF);
L_main7:
	BTFSC      SSPSTAT+0, 0
	GOTO       L_main8
	GOTO       L_main7
L_main8:
;Protocolo_SPI.c,19 :: 		SSPBUF = 'A';
	MOVLW      65
	MOVWF      SSPBUF+0
;Protocolo_SPI.c,20 :: 		while(!SSPSTAT.BF);
L_main9:
	BTFSC      SSPSTAT+0, 0
	GOTO       L_main10
	GOTO       L_main9
L_main10:
;Protocolo_SPI.c,21 :: 		CS = 1;
	BSF        PORTD+0, 0
;Protocolo_SPI.c,22 :: 		Delay_ms(500);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main11:
	DECFSZ     R13+0, 1
	GOTO       L_main11
	DECFSZ     R12+0, 1
	GOTO       L_main11
	DECFSZ     R11+0, 1
	GOTO       L_main11
	NOP
	NOP
;Protocolo_SPI.c,23 :: 		}
	GOTO       L_main1
;Protocolo_SPI.c,25 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
