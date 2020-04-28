
_spi_transfer:

;Configurador.c,11 :: 		byte spi_transfer(byte info){
;Configurador.c,12 :: 		SSPBUF = info;
	MOVF       FARG_spi_transfer_info+0, 0
	MOVWF      SSPBUF+0
;Configurador.c,13 :: 		while(!SSPSTAT.BF);
L_spi_transfer0:
	BTFSC      SSPSTAT+0, 0
	GOTO       L_spi_transfer1
	GOTO       L_spi_transfer0
L_spi_transfer1:
;Configurador.c,14 :: 		return SSPBUF;
	MOVF       SSPBUF+0, 0
	MOVWF      R0+0
;Configurador.c,15 :: 		}
L_end_spi_transfer:
	RETURN
; end of _spi_transfer

_readData:

;Configurador.c,17 :: 		unsigned char readData() {
;Configurador.c,18 :: 		while (1){
L_readData2:
;Configurador.c,19 :: 		if(UART1_Data_Ready()){
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_readData4
;Configurador.c,20 :: 		return  UART1_Read();
	CALL       _UART1_Read+0
	GOTO       L_end_readData
;Configurador.c,21 :: 		}
L_readData4:
;Configurador.c,22 :: 		}
	GOTO       L_readData2
;Configurador.c,23 :: 		}
L_end_readData:
	RETURN
; end of _readData

_setTime:

;Configurador.c,25 :: 		void setTime(byte * info){
;Configurador.c,26 :: 		char i = 0;
	CLRF       setTime_i_L0+0
;Configurador.c,27 :: 		CS = 0;
	BCF        PORTD+0, 0
;Configurador.c,28 :: 		spi_transfer(0x80);
	MOVLW      128
	MOVWF      FARG_spi_transfer_info+0
	CALL       _spi_transfer+0
;Configurador.c,29 :: 		for (i = 0; i < 7; i++)
	CLRF       setTime_i_L0+0
L_setTime5:
	MOVLW      7
	SUBWF      setTime_i_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_setTime6
;Configurador.c,31 :: 		spi_transfer(info[i]);
	MOVF       setTime_i_L0+0, 0
	ADDWF      FARG_setTime_info+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_spi_transfer_info+0
	CALL       _spi_transfer+0
;Configurador.c,29 :: 		for (i = 0; i < 7; i++)
	INCF       setTime_i_L0+0, 1
;Configurador.c,32 :: 		}
	GOTO       L_setTime5
L_setTime6:
;Configurador.c,33 :: 		CS = 1;
	BSF        PORTD+0, 0
;Configurador.c,34 :: 		Delay_ms(10);
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L_setTime8:
	DECFSZ     R13+0, 1
	GOTO       L_setTime8
	DECFSZ     R12+0, 1
	GOTO       L_setTime8
	NOP
	NOP
;Configurador.c,35 :: 		}
L_end_setTime:
	RETURN
; end of _setTime

_readTime:

;Configurador.c,37 :: 		void readTime(byte * currentTime){
;Configurador.c,38 :: 		char i = 0;
	CLRF       readTime_i_L0+0
;Configurador.c,39 :: 		CS = 0;
	BCF        PORTD+0, 0
;Configurador.c,40 :: 		spi_transfer(0x00);
	CLRF       FARG_spi_transfer_info+0
	CALL       _spi_transfer+0
;Configurador.c,41 :: 		for (i = 0; i < 7; i++)
	CLRF       readTime_i_L0+0
L_readTime9:
	MOVLW      7
	SUBWF      readTime_i_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_readTime10
;Configurador.c,43 :: 		currentTime[i] = spi_transfer(0x00);
	MOVF       readTime_i_L0+0, 0
	ADDWF      FARG_readTime_currentTime+0, 0
	MOVWF      FLOC__readTime+0
	CLRF       FARG_spi_transfer_info+0
	CALL       _spi_transfer+0
	MOVF       FLOC__readTime+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;Configurador.c,41 :: 		for (i = 0; i < 7; i++)
	INCF       readTime_i_L0+0, 1
;Configurador.c,44 :: 		}
	GOTO       L_readTime9
L_readTime10:
;Configurador.c,45 :: 		CS = 1;
	BSF        PORTD+0, 0
;Configurador.c,46 :: 		}
L_end_readTime:
	RETURN
; end of _readTime

_initConfig:

;Configurador.c,48 :: 		void initConfig(){
;Configurador.c,49 :: 		UART1_Init(9600);
	MOVLW      25
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;Configurador.c,50 :: 		TRISC.F3 = 0; //CLK SPI
	BCF        TRISC+0, 3
;Configurador.c,51 :: 		TRISC.F5 = 0; //MOSI - SDO
	BCF        TRISC+0, 5
;Configurador.c,52 :: 		TRISC.F4 = 1; //MISO - SDI
	BSF        TRISC+0, 4
;Configurador.c,53 :: 		TRISD.F0 = 0; //CS
	BCF        TRISD+0, 0
;Configurador.c,54 :: 		SSPSTAT = 0X80;
	MOVLW      128
	MOVWF      SSPSTAT+0
;Configurador.c,55 :: 		SSPCON =  0X20;
	MOVLW      32
	MOVWF      SSPCON+0
;Configurador.c,56 :: 		CS = 1;
	BSF        PORTD+0, 0
;Configurador.c,57 :: 		Delay_ms(10);
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L_initConfig12:
	DECFSZ     R13+0, 1
	GOTO       L_initConfig12
	DECFSZ     R12+0, 1
	GOTO       L_initConfig12
	NOP
	NOP
;Configurador.c,59 :: 		}
L_end_initConfig:
	RETURN
; end of _initConfig

_main:

;Configurador.c,61 :: 		void main() {
;Configurador.c,62 :: 		byte text[10], i, buff[10], check = 0, date[] = {0x59,0x30,0x05,0x00,0x28,0x04,0x20}, date2[7] = {0x00};
	CLRF       main_check_L0+0
	MOVLW      89
	MOVWF      main_date_L0+0
	MOVLW      48
	MOVWF      main_date_L0+1
	MOVLW      5
	MOVWF      main_date_L0+2
	CLRF       main_date_L0+3
	MOVLW      40
	MOVWF      main_date_L0+4
	MOVLW      4
	MOVWF      main_date_L0+5
	MOVLW      32
	MOVWF      main_date_L0+6
	CLRF       main_date2_L0+0
	CLRF       main_date2_L0+1
	CLRF       main_date2_L0+2
	CLRF       main_date2_L0+3
	CLRF       main_date2_L0+4
	CLRF       main_date2_L0+5
	CLRF       main_date2_L0+6
;Configurador.c,63 :: 		initConfig();
	CALL       _initConfig+0
;Configurador.c,64 :: 		setTime(date);
	MOVLW      main_date_L0+0
	MOVWF      FARG_setTime_info+0
	CALL       _setTime+0
;Configurador.c,65 :: 		while (1) {
L_main13:
;Configurador.c,66 :: 		check = 0;
	CLRF       main_check_L0+0
;Configurador.c,67 :: 		if(UART1_Data_Ready()){
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main15
;Configurador.c,68 :: 		check = UART1_Read();
	CALL       _UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      main_check_L0+0
;Configurador.c,69 :: 		if(check == 'r'){
	MOVF       R0+0, 0
	XORLW      114
	BTFSS      STATUS+0, 2
	GOTO       L_main16
;Configurador.c,70 :: 		readTime(date2);
	MOVLW      main_date2_L0+0
	MOVWF      FARG_readTime_currentTime+0
	CALL       _readTime+0
;Configurador.c,71 :: 		for (i = 0; i <7; i++)
	CLRF       main_i_L0+0
L_main17:
	MOVLW      7
	SUBWF      main_i_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main18
;Configurador.c,73 :: 		UART1_Write(date2[i]);
	MOVF       main_i_L0+0, 0
	ADDLW      main_date2_L0+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;Configurador.c,71 :: 		for (i = 0; i <7; i++)
	INCF       main_i_L0+0, 1
;Configurador.c,74 :: 		}
	GOTO       L_main17
L_main18:
;Configurador.c,75 :: 		}
L_main16:
;Configurador.c,76 :: 		if(check == 's'){
	MOVF       main_check_L0+0, 0
	XORLW      115
	BTFSS      STATUS+0, 2
	GOTO       L_main20
;Configurador.c,77 :: 		for(i = 0; i<7; i++){
	CLRF       main_i_L0+0
L_main21:
	MOVLW      7
	SUBWF      main_i_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main22
;Configurador.c,78 :: 		date[i] =readData();
	MOVF       main_i_L0+0, 0
	ADDLW      main_date_L0+0
	MOVWF      FLOC__main+0
	CALL       _readData+0
	MOVF       FLOC__main+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;Configurador.c,77 :: 		for(i = 0; i<7; i++){
	INCF       main_i_L0+0, 1
;Configurador.c,79 :: 		}
	GOTO       L_main21
L_main22:
;Configurador.c,80 :: 		setTime(date);
	MOVLW      main_date_L0+0
	MOVWF      FARG_setTime_info+0
	CALL       _setTime+0
;Configurador.c,81 :: 		UART1_Write_Text("OK\n");
	MOVLW      ?lstr1_Configurador+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Configurador.c,82 :: 		}
L_main20:
;Configurador.c,83 :: 		}
L_main15:
;Configurador.c,84 :: 		}
	GOTO       L_main13
;Configurador.c,85 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
