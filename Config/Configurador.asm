
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

_convertValueIN:

;Configurador.c,17 :: 		byte convertValueIN(byte value){
;Configurador.c,18 :: 		byte convertedVal = value - 6 * (value >> 4);
	MOVF       FARG_convertValueIN_value+0, 0
	MOVWF      R0+0
	RRF        R0+0, 1
	BCF        R0+0, 7
	RRF        R0+0, 1
	BCF        R0+0, 7
	RRF        R0+0, 1
	BCF        R0+0, 7
	RRF        R0+0, 1
	BCF        R0+0, 7
	MOVLW      6
	MOVWF      R4+0
	CALL       _Mul_8X8_U+0
	MOVF       R0+0, 0
	SUBWF      FARG_convertValueIN_value+0, 0
	MOVWF      R0+0
	MOVF       R0+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	CLRF       R0+1
	SUBWF      R0+1, 1
;Configurador.c,19 :: 		return convertedVal ;
;Configurador.c,20 :: 		}
L_end_convertValueIN:
	RETURN
; end of _convertValueIN

_convertValueOUT:

;Configurador.c,22 :: 		byte convertValueOUT(byte value){
;Configurador.c,23 :: 		byte convertedVal = value +6 * (value / 10);
	MOVLW      10
	MOVWF      R4+0
	MOVF       FARG_convertValueOUT_value+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVLW      6
	MOVWF      R4+0
	CALL       _Mul_8X8_U+0
	MOVF       FARG_convertValueOUT_value+0, 0
	ADDWF      R0+0, 1
	BTFSC      STATUS+0, 0
	INCF       R0+1, 1
;Configurador.c,24 :: 		return convertedVal ;
;Configurador.c,25 :: 		}
L_end_convertValueOUT:
	RETURN
; end of _convertValueOUT

_setTime:

;Configurador.c,28 :: 		void setTime(byte * info){
;Configurador.c,29 :: 		char i = 0;
	CLRF       setTime_i_L0+0
;Configurador.c,30 :: 		CS = 0;
	BCF        PORTD+0, 0
;Configurador.c,31 :: 		Delay_ms(10);
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L_setTime2:
	DECFSZ     R13+0, 1
	GOTO       L_setTime2
	DECFSZ     R12+0, 1
	GOTO       L_setTime2
	NOP
	NOP
;Configurador.c,32 :: 		spi_transfer(info[0]);
	MOVF       FARG_setTime_info+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_spi_transfer_info+0
	CALL       _spi_transfer+0
;Configurador.c,33 :: 		for (i = 1; i < 4; i++)
	MOVLW      1
	MOVWF      setTime_i_L0+0
L_setTime3:
	MOVLW      4
	SUBWF      setTime_i_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_setTime4
;Configurador.c,35 :: 		spi_transfer(info[i]);
	MOVF       setTime_i_L0+0, 0
	ADDWF      FARG_setTime_info+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_spi_transfer_info+0
	CALL       _spi_transfer+0
;Configurador.c,33 :: 		for (i = 1; i < 4; i++)
	INCF       setTime_i_L0+0, 1
;Configurador.c,36 :: 		}
	GOTO       L_setTime3
L_setTime4:
;Configurador.c,37 :: 		CS = 1;
	BSF        PORTD+0, 0
;Configurador.c,38 :: 		Delay_ms(10);
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L_setTime6:
	DECFSZ     R13+0, 1
	GOTO       L_setTime6
	DECFSZ     R12+0, 1
	GOTO       L_setTime6
	NOP
	NOP
;Configurador.c,39 :: 		}
L_end_setTime:
	RETURN
; end of _setTime

_readData:

;Configurador.c,40 :: 		unsigned char readData() {
;Configurador.c,42 :: 		while (1){
L_readData7:
;Configurador.c,43 :: 		if(UART1_Data_Ready()){
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_readData9
;Configurador.c,44 :: 		dato = UART1_Read();
	CALL       _UART1_Read+0
;Configurador.c,45 :: 		return dato;
	GOTO       L_end_readData
;Configurador.c,46 :: 		}
L_readData9:
;Configurador.c,47 :: 		}
	GOTO       L_readData7
;Configurador.c,48 :: 		}
L_end_readData:
	RETURN
; end of _readData

_ascii2hex:

;Configurador.c,50 :: 		unsigned char ascii2hex(){
;Configurador.c,51 :: 		unsigned char dato = 0, datoh = 0;
	CLRF       ascii2hex_dato_L0+0
	CLRF       ascii2hex_datoh_L0+0
;Configurador.c,52 :: 		dato = readData();
	CALL       _readData+0
	MOVF       R0+0, 0
	MOVWF      ascii2hex_dato_L0+0
;Configurador.c,53 :: 		datoh = readData();
	CALL       _readData+0
	MOVF       R0+0, 0
	MOVWF      ascii2hex_datoh_L0+0
;Configurador.c,54 :: 		dato = (dato>='A') ? (dato-55)<<4 : (dato-48)<<4;
	MOVLW      65
	SUBWF      ascii2hex_dato_L0+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_ascii2hex10
	MOVLW      55
	SUBWF      ascii2hex_dato_L0+0, 0
	MOVWF      ?FLOC___ascii2hexT23+0
	MOVLW      4
	MOVWF      R0+0
	MOVLW      0
	MOVWF      ?FLOC___ascii2hexT23+1
	MOVF       R0+0, 0
L__ascii2hex42:
	BTFSC      STATUS+0, 2
	GOTO       L__ascii2hex43
	RLF        ?FLOC___ascii2hexT23+0, 1
	RLF        ?FLOC___ascii2hexT23+1, 1
	BCF        ?FLOC___ascii2hexT23+0, 0
	ADDLW      255
	GOTO       L__ascii2hex42
L__ascii2hex43:
	GOTO       L_ascii2hex11
L_ascii2hex10:
	MOVLW      48
	SUBWF      ascii2hex_dato_L0+0, 0
	MOVWF      ?FLOC___ascii2hexT23+0
	MOVLW      4
	MOVWF      R0+0
	MOVLW      0
	MOVWF      ?FLOC___ascii2hexT23+1
	MOVF       R0+0, 0
L__ascii2hex44:
	BTFSC      STATUS+0, 2
	GOTO       L__ascii2hex45
	RLF        ?FLOC___ascii2hexT23+0, 1
	RLF        ?FLOC___ascii2hexT23+1, 1
	BCF        ?FLOC___ascii2hexT23+0, 0
	ADDLW      255
	GOTO       L__ascii2hex44
L__ascii2hex45:
L_ascii2hex11:
	MOVF       ?FLOC___ascii2hexT23+0, 0
	MOVWF      ascii2hex_dato_L0+0
;Configurador.c,55 :: 		dato += (datoh>='A') ? datoh-55 : datoh-48;
	MOVLW      65
	SUBWF      ascii2hex_datoh_L0+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_ascii2hex12
	MOVLW      55
	SUBWF      ascii2hex_datoh_L0+0, 0
	MOVWF      ?FLOC___ascii2hexT28+0
	MOVLW      0
	MOVWF      ?FLOC___ascii2hexT28+1
	GOTO       L_ascii2hex13
L_ascii2hex12:
	MOVLW      48
	SUBWF      ascii2hex_datoh_L0+0, 0
	MOVWF      ?FLOC___ascii2hexT28+0
	MOVLW      0
	MOVWF      ?FLOC___ascii2hexT28+1
L_ascii2hex13:
	MOVF       ?FLOC___ascii2hexT28+0, 0
	ADDWF      ascii2hex_dato_L0+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      ascii2hex_dato_L0+0
;Configurador.c,56 :: 		PORTB = 0xFF;
	MOVLW      255
	MOVWF      PORTB+0
;Configurador.c,57 :: 		return dato;
;Configurador.c,58 :: 		}
L_end_ascii2hex:
	RETURN
; end of _ascii2hex

_readTime:

;Configurador.c,61 :: 		void readTime(byte * currentTime){
;Configurador.c,62 :: 		char i = 0;
	CLRF       readTime_i_L0+0
;Configurador.c,63 :: 		CS = 0;
	BCF        PORTD+0, 0
;Configurador.c,64 :: 		Delay_ms(10);
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L_readTime14:
	DECFSZ     R13+0, 1
	GOTO       L_readTime14
	DECFSZ     R12+0, 1
	GOTO       L_readTime14
	NOP
	NOP
;Configurador.c,65 :: 		spi_transfer(currentTime[0]);
	MOVF       FARG_readTime_currentTime+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_spi_transfer_info+0
	CALL       _spi_transfer+0
;Configurador.c,66 :: 		for (i = 1; i < 4; i++)
	MOVLW      1
	MOVWF      readTime_i_L0+0
L_readTime15:
	MOVLW      4
	SUBWF      readTime_i_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_readTime16
;Configurador.c,68 :: 		currentTime[i] = spi_transfer(0x00);
	MOVF       readTime_i_L0+0, 0
	ADDWF      FARG_readTime_currentTime+0, 0
	MOVWF      FLOC__readTime+0
	CLRF       FARG_spi_transfer_info+0
	CALL       _spi_transfer+0
	MOVF       FLOC__readTime+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;Configurador.c,66 :: 		for (i = 1; i < 4; i++)
	INCF       readTime_i_L0+0, 1
;Configurador.c,69 :: 		}
	GOTO       L_readTime15
L_readTime16:
;Configurador.c,70 :: 		CS = 1;
	BSF        PORTD+0, 0
;Configurador.c,71 :: 		Delay_ms(10);
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L_readTime18:
	DECFSZ     R13+0, 1
	GOTO       L_readTime18
	DECFSZ     R12+0, 1
	GOTO       L_readTime18
	NOP
	NOP
;Configurador.c,72 :: 		}
L_end_readTime:
	RETURN
; end of _readTime

_RTC_init:

;Configurador.c,74 :: 		void RTC_init(char freq){
;Configurador.c,76 :: 		CS = 0;
	BCF        PORTD+0, 0
;Configurador.c,77 :: 		spi_transfer(READ_CONTROL_REG);
	MOVLW      14
	MOVWF      FARG_spi_transfer_info+0
	CALL       _spi_transfer+0
;Configurador.c,78 :: 		config = spi_transfer(0x00);
	CLRF       FARG_spi_transfer_info+0
	CALL       _spi_transfer+0
;Configurador.c,79 :: 		CS = 1;
	BSF        PORTD+0, 0
;Configurador.c,80 :: 		Delay_ms(100);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_RTC_init19:
	DECFSZ     R13+0, 1
	GOTO       L_RTC_init19
	DECFSZ     R12+0, 1
	GOTO       L_RTC_init19
	NOP
	NOP
;Configurador.c,81 :: 		}
L_end_RTC_init:
	RETURN
; end of _RTC_init

_main:

;Configurador.c,83 :: 		void main() {
;Configurador.c,84 :: 		byte text[10], i, buff[10], check = 0;
	CLRF       main_check_L0+0
	MOVLW      132
	MOVWF      main_date_L0+0
	MOVLW      38
	MOVWF      main_date_L0+1
	MOVLW      4
	MOVWF      main_date_L0+2
	MOVLW      32
	MOVWF      main_date_L0+3
	MOVLW      4
	MOVWF      main_date2_L0+0
	CLRF       main_date2_L0+1
	CLRF       main_date2_L0+2
	CLRF       main_date2_L0+3
	MOVLW      128
	MOVWF      main_time_L0+0
	MOVLW      89
	MOVWF      main_time_L0+1
	MOVLW      48
	MOVWF      main_time_L0+2
	MOVLW      5
	MOVWF      main_time_L0+3
	CLRF       main_time2_L0+0
	CLRF       main_time2_L0+1
	CLRF       main_time2_L0+2
	CLRF       main_time2_L0+3
;Configurador.c,87 :: 		UART1_Init(9600);
	MOVLW      25
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;Configurador.c,88 :: 		UART1_Write_Text("inicio de la prueba");
	MOVLW      ?lstr1_Configurador+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Configurador.c,89 :: 		TRISC.F3 = 0; //CLK SPI
	BCF        TRISC+0, 3
;Configurador.c,90 :: 		TRISC.F5 = 0; //MOSI - SDO
	BCF        TRISC+0, 5
;Configurador.c,91 :: 		TRISC.F4 = 1; //MISO - SDI
	BSF        TRISC+0, 4
;Configurador.c,92 :: 		TRISD.F0 = 0; //CS
	BCF        TRISD+0, 0
;Configurador.c,93 :: 		SSPSTAT = 0X00;
	CLRF       SSPSTAT+0
;Configurador.c,94 :: 		SSPCON =  0X20;
	MOVLW      32
	MOVWF      SSPCON+0
;Configurador.c,95 :: 		CS = 1;
	BSF        PORTD+0, 0
;Configurador.c,96 :: 		Delay_ms(2000);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_main20:
	DECFSZ     R13+0, 1
	GOTO       L_main20
	DECFSZ     R12+0, 1
	GOTO       L_main20
	DECFSZ     R11+0, 1
	GOTO       L_main20
	NOP
	NOP
;Configurador.c,97 :: 		RTC_init(1);
	MOVLW      1
	MOVWF      FARG_RTC_init_freq+0
	CALL       _RTC_init+0
;Configurador.c,98 :: 		setTime(date);
	MOVLW      main_date_L0+0
	MOVWF      FARG_setTime_info+0
	CALL       _setTime+0
;Configurador.c,99 :: 		setTime(time);
	MOVLW      main_time_L0+0
	MOVWF      FARG_setTime_info+0
	CALL       _setTime+0
;Configurador.c,100 :: 		Delay_ms(5000);
	MOVLW      26
	MOVWF      R11+0
	MOVLW      94
	MOVWF      R12+0
	MOVLW      110
	MOVWF      R13+0
L_main21:
	DECFSZ     R13+0, 1
	GOTO       L_main21
	DECFSZ     R12+0, 1
	GOTO       L_main21
	DECFSZ     R11+0, 1
	GOTO       L_main21
	NOP
;Configurador.c,101 :: 		while (1) {
L_main22:
;Configurador.c,102 :: 		check = 0;
	CLRF       main_check_L0+0
;Configurador.c,103 :: 		if(UART1_Data_Ready()){
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main24
;Configurador.c,104 :: 		check = UART1_Read();
	CALL       _UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      main_check_L0+0
;Configurador.c,105 :: 		if(check == 'r'){
	MOVF       R0+0, 0
	XORLW      114
	BTFSS      STATUS+0, 2
	GOTO       L_main25
;Configurador.c,106 :: 		readTime(date2);
	MOVLW      main_date2_L0+0
	MOVWF      FARG_readTime_currentTime+0
	CALL       _readTime+0
;Configurador.c,107 :: 		readTime(time2);
	MOVLW      main_time2_L0+0
	MOVWF      FARG_readTime_currentTime+0
	CALL       _readTime+0
;Configurador.c,108 :: 		for (i = 3; i > 0; i--)
	MOVLW      3
	MOVWF      main_i_L0+0
L_main26:
	MOVF       main_i_L0+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L_main27
;Configurador.c,110 :: 		UART1_Write(convertValueIN(time2[i]));
	MOVF       main_i_L0+0, 0
	ADDLW      main_time2_L0+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_convertValueIN_value+0
	CALL       _convertValueIN+0
	MOVF       R0+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;Configurador.c,111 :: 		UART1_Write(convertValueIN(date2[i]));
	MOVF       main_i_L0+0, 0
	ADDLW      main_date2_L0+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_convertValueIN_value+0
	CALL       _convertValueIN+0
	MOVF       R0+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;Configurador.c,108 :: 		for (i = 3; i > 0; i--)
	DECF       main_i_L0+0, 1
;Configurador.c,112 :: 		}
	GOTO       L_main26
L_main27:
;Configurador.c,113 :: 		}
L_main25:
;Configurador.c,114 :: 		if(check == 's'){
	MOVF       main_check_L0+0, 0
	XORLW      115
	BTFSS      STATUS+0, 2
	GOTO       L_main29
;Configurador.c,115 :: 		for(i = 3; i>0; i--){
	MOVLW      3
	MOVWF      main_i_L0+0
L_main30:
	MOVF       main_i_L0+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L_main31
;Configurador.c,116 :: 		time[i] = ascii2hex();
	MOVF       main_i_L0+0, 0
	ADDLW      main_time_L0+0
	MOVWF      FLOC__main+0
	CALL       _ascii2hex+0
	MOVF       FLOC__main+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;Configurador.c,115 :: 		for(i = 3; i>0; i--){
	DECF       main_i_L0+0, 1
;Configurador.c,117 :: 		}
	GOTO       L_main30
L_main31:
;Configurador.c,118 :: 		for(i = 1; i<4; i++){
	MOVLW      1
	MOVWF      main_i_L0+0
L_main33:
	MOVLW      4
	SUBWF      main_i_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main34
;Configurador.c,119 :: 		date[i] = ascii2hex();
	MOVF       main_i_L0+0, 0
	ADDLW      main_date_L0+0
	MOVWF      FLOC__main+0
	CALL       _ascii2hex+0
	MOVF       FLOC__main+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;Configurador.c,118 :: 		for(i = 1; i<4; i++){
	INCF       main_i_L0+0, 1
;Configurador.c,120 :: 		}
	GOTO       L_main33
L_main34:
;Configurador.c,121 :: 		setTime(date);
	MOVLW      main_date_L0+0
	MOVWF      FARG_setTime_info+0
	CALL       _setTime+0
;Configurador.c,122 :: 		setTime(time);
	MOVLW      main_time_L0+0
	MOVWF      FARG_setTime_info+0
	CALL       _setTime+0
;Configurador.c,123 :: 		UART1_Write_Text("OK\n");
	MOVLW      ?lstr2_Configurador+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Configurador.c,124 :: 		}
L_main29:
;Configurador.c,125 :: 		}
L_main24:
;Configurador.c,126 :: 		}
	GOTO       L_main22
;Configurador.c,127 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
