
_write_eeprom:

;EEPROM_SPI.c,6 :: 		void write_eeprom(unsigned char dato, unsigned char dir){
;EEPROM_SPI.c,7 :: 		CS = 0;
	BCF        PORTD+0, 0
;EEPROM_SPI.c,8 :: 		SSPBUF = WREN;
	MOVLW      6
	MOVWF      SSPBUF+0
;EEPROM_SPI.c,9 :: 		while(!SSPSTAT.BF);
L_write_eeprom0:
	BTFSC      SSPSTAT+0, 0
	GOTO       L_write_eeprom1
	GOTO       L_write_eeprom0
L_write_eeprom1:
;EEPROM_SPI.c,10 :: 		CS = 1;
	BSF        PORTD+0, 0
;EEPROM_SPI.c,12 :: 		CS = 0;
	BCF        PORTD+0, 0
;EEPROM_SPI.c,13 :: 		SSPBUF = WRITE;
	MOVLW      2
	MOVWF      SSPBUF+0
;EEPROM_SPI.c,14 :: 		while(!SSPSTAT.BF);
L_write_eeprom2:
	BTFSC      SSPSTAT+0, 0
	GOTO       L_write_eeprom3
	GOTO       L_write_eeprom2
L_write_eeprom3:
;EEPROM_SPI.c,15 :: 		SSPBUF = dir;
	MOVF       FARG_write_eeprom_dir+0, 0
	MOVWF      SSPBUF+0
;EEPROM_SPI.c,16 :: 		while(!SSPSTAT.BF);
L_write_eeprom4:
	BTFSC      SSPSTAT+0, 0
	GOTO       L_write_eeprom5
	GOTO       L_write_eeprom4
L_write_eeprom5:
;EEPROM_SPI.c,17 :: 		SSPBUF = dato;
	MOVF       FARG_write_eeprom_dato+0, 0
	MOVWF      SSPBUF+0
;EEPROM_SPI.c,18 :: 		while(!SSPSTAT.BF);
L_write_eeprom6:
	BTFSC      SSPSTAT+0, 0
	GOTO       L_write_eeprom7
	GOTO       L_write_eeprom6
L_write_eeprom7:
;EEPROM_SPI.c,19 :: 		CS = 1;
	BSF        PORTD+0, 0
;EEPROM_SPI.c,20 :: 		}
L_end_write_eeprom:
	RETURN
; end of _write_eeprom

_read_eeprom:

;EEPROM_SPI.c,23 :: 		void read_eeprom(unsigned char dir){
;EEPROM_SPI.c,24 :: 		CS = 0;
	BCF        PORTD+0, 0
;EEPROM_SPI.c,25 :: 		SSPBUF = READ;
	MOVLW      3
	MOVWF      SSPBUF+0
;EEPROM_SPI.c,26 :: 		while(!SSPSTAT.BF);
L_read_eeprom8:
	BTFSC      SSPSTAT+0, 0
	GOTO       L_read_eeprom9
	GOTO       L_read_eeprom8
L_read_eeprom9:
;EEPROM_SPI.c,27 :: 		SSPBUF = dir;
	MOVF       FARG_read_eeprom_dir+0, 0
	MOVWF      SSPBUF+0
;EEPROM_SPI.c,28 :: 		while(!SSPSTAT.BF);
L_read_eeprom10:
	BTFSC      SSPSTAT+0, 0
	GOTO       L_read_eeprom11
	GOTO       L_read_eeprom10
L_read_eeprom11:
;EEPROM_SPI.c,29 :: 		SSPBUF = 0xFF;
	MOVLW      255
	MOVWF      SSPBUF+0
;EEPROM_SPI.c,30 :: 		while(!SSPSTAT.BF);
L_read_eeprom12:
	BTFSC      SSPSTAT+0, 0
	GOTO       L_read_eeprom13
	GOTO       L_read_eeprom12
L_read_eeprom13:
;EEPROM_SPI.c,31 :: 		CS = 1;
	BSF        PORTD+0, 0
;EEPROM_SPI.c,32 :: 		}
L_end_read_eeprom:
	RETURN
; end of _read_eeprom

_main:

;EEPROM_SPI.c,34 :: 		void main() {
;EEPROM_SPI.c,35 :: 		unsigned int valor = 0, i=0;
;EEPROM_SPI.c,36 :: 		unsigned char temporal = 0;
;EEPROM_SPI.c,37 :: 		TRISC.F3 = 0; //CLK SPI
	BCF        TRISC+0, 3
;EEPROM_SPI.c,38 :: 		TRISC.F5 = 0; //MOSI - SDO
	BCF        TRISC+0, 5
;EEPROM_SPI.c,39 :: 		TRISC.F4 = 1; //MISO - SDI
	BSF        TRISC+0, 4
;EEPROM_SPI.c,40 :: 		TRISD.F0 = 0; //CS
	BCF        TRISD+0, 0
;EEPROM_SPI.c,41 :: 		SSPSTAT = 0X40;
	MOVLW      64
	MOVWF      SSPSTAT+0
;EEPROM_SPI.c,42 :: 		SSPCON =  0X20;
	MOVLW      32
	MOVWF      SSPCON+0
;EEPROM_SPI.c,43 :: 		CS = 1;
	BSF        PORTD+0, 0
;EEPROM_SPI.c,44 :: 		Delay_ms(100);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_main14:
	DECFSZ     R13+0, 1
	GOTO       L_main14
	DECFSZ     R12+0, 1
	GOTO       L_main14
	NOP
	NOP
;EEPROM_SPI.c,45 :: 		while(1){
L_main15:
;EEPROM_SPI.c,48 :: 		read_eeprom(0x20);
	MOVLW      32
	MOVWF      FARG_read_eeprom_dir+0
	CALL       _read_eeprom+0
;EEPROM_SPI.c,49 :: 		Delay_ms(500);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main17:
	DECFSZ     R13+0, 1
	GOTO       L_main17
	DECFSZ     R12+0, 1
	GOTO       L_main17
	DECFSZ     R11+0, 1
	GOTO       L_main17
	NOP
	NOP
;EEPROM_SPI.c,50 :: 		}
	GOTO       L_main15
;EEPROM_SPI.c,51 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
