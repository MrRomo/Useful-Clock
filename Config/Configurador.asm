
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
;Configurador.c,35 :: 		spi_transfer(convertValueOUT(info[i]));
	MOVF       setTime_i_L0+0, 0
	ADDWF      FARG_setTime_info+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_convertValueOUT_value+0
	CALL       _convertValueOUT+0
	MOVF       R0+0, 0
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

_readTime:

;Configurador.c,40 :: 		void readTime(byte * currentTime){
;Configurador.c,41 :: 		char i = 0;
	CLRF       readTime_i_L0+0
;Configurador.c,42 :: 		CS = 0;
	BCF        PORTD+0, 0
;Configurador.c,43 :: 		Delay_ms(10);
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L_readTime7:
	DECFSZ     R13+0, 1
	GOTO       L_readTime7
	DECFSZ     R12+0, 1
	GOTO       L_readTime7
	NOP
	NOP
;Configurador.c,44 :: 		spi_transfer(currentTime[0]);
	MOVF       FARG_readTime_currentTime+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_spi_transfer_info+0
	CALL       _spi_transfer+0
;Configurador.c,45 :: 		for (i = 1; i < 4; i++)
	MOVLW      1
	MOVWF      readTime_i_L0+0
L_readTime8:
	MOVLW      4
	SUBWF      readTime_i_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_readTime9
;Configurador.c,47 :: 		currentTime[i] = spi_transfer(0x00);
	MOVF       readTime_i_L0+0, 0
	ADDWF      FARG_readTime_currentTime+0, 0
	MOVWF      FLOC__readTime+0
	CLRF       FARG_spi_transfer_info+0
	CALL       _spi_transfer+0
	MOVF       FLOC__readTime+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;Configurador.c,45 :: 		for (i = 1; i < 4; i++)
	INCF       readTime_i_L0+0, 1
;Configurador.c,48 :: 		}
	GOTO       L_readTime8
L_readTime9:
;Configurador.c,49 :: 		CS = 1;
	BSF        PORTD+0, 0
;Configurador.c,50 :: 		Delay_ms(10);
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L_readTime11:
	DECFSZ     R13+0, 1
	GOTO       L_readTime11
	DECFSZ     R12+0, 1
	GOTO       L_readTime11
	NOP
	NOP
;Configurador.c,51 :: 		}
L_end_readTime:
	RETURN
; end of _readTime

_RTC_init:

;Configurador.c,53 :: 		void RTC_init(char freq){
;Configurador.c,55 :: 		CS = 0;
	BCF        PORTD+0, 0
;Configurador.c,56 :: 		spi_transfer(READ_CONTROL_REG);
	MOVLW      14
	MOVWF      FARG_spi_transfer_info+0
	CALL       _spi_transfer+0
;Configurador.c,57 :: 		config = spi_transfer(0x00);
	CLRF       FARG_spi_transfer_info+0
	CALL       _spi_transfer+0
;Configurador.c,58 :: 		CS = 1;
	BSF        PORTD+0, 0
;Configurador.c,59 :: 		Delay_ms(100);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_RTC_init12:
	DECFSZ     R13+0, 1
	GOTO       L_RTC_init12
	DECFSZ     R12+0, 1
	GOTO       L_RTC_init12
	NOP
	NOP
;Configurador.c,60 :: 		}
L_end_RTC_init:
	RETURN
; end of _RTC_init

_main:

;Configurador.c,62 :: 		void main() {
;Configurador.c,64 :: 		byte date[] = {0x84,26,04,20}, date2[4] = {0x00}, sec;
	MOVLW      132
	MOVWF      main_date_L0+0
	MOVLW      26
	MOVWF      main_date_L0+1
	MOVLW      4
	MOVWF      main_date_L0+2
	MOVLW      20
	MOVWF      main_date_L0+3
	CLRF       main_date2_L0+0
	CLRF       main_date2_L0+1
	CLRF       main_date2_L0+2
	CLRF       main_date2_L0+3
	MOVLW      128
	MOVWF      main_time_L0+0
	MOVLW      59
	MOVWF      main_time_L0+1
	MOVLW      30
	MOVWF      main_time_L0+2
	MOVLW      5
	MOVWF      main_time_L0+3
;Configurador.c,66 :: 		UART1_Init(9600);
	MOVLW      25
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;Configurador.c,67 :: 		UART1_Write_Text("inicio de la prueba");
	MOVLW      ?lstr1_Configurador+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Configurador.c,68 :: 		TRISC.F3 = 0; //CLK SPI
	BCF        TRISC+0, 3
;Configurador.c,69 :: 		TRISC.F5 = 0; //MOSI - SDO
	BCF        TRISC+0, 5
;Configurador.c,70 :: 		TRISC.F4 = 1; //MISO - SDI
	BSF        TRISC+0, 4
;Configurador.c,71 :: 		TRISD.F0 = 0; //CS
	BCF        TRISD+0, 0
;Configurador.c,72 :: 		SSPSTAT = 0X00;
	CLRF       SSPSTAT+0
;Configurador.c,73 :: 		SSPCON =  0X20;
	MOVLW      32
	MOVWF      SSPCON+0
;Configurador.c,74 :: 		CS = 1;
	BSF        PORTD+0, 0
;Configurador.c,75 :: 		Delay_ms(2000);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_main13:
	DECFSZ     R13+0, 1
	GOTO       L_main13
	DECFSZ     R12+0, 1
	GOTO       L_main13
	DECFSZ     R11+0, 1
	GOTO       L_main13
	NOP
	NOP
;Configurador.c,76 :: 		RTC_init(1);
	MOVLW      1
	MOVWF      FARG_RTC_init_freq+0
	CALL       _RTC_init+0
;Configurador.c,77 :: 		setTime(date);
	MOVLW      main_date_L0+0
	MOVWF      FARG_setTime_info+0
	CALL       _setTime+0
;Configurador.c,78 :: 		setTime(time);
	MOVLW      main_time_L0+0
	MOVWF      FARG_setTime_info+0
	CALL       _setTime+0
;Configurador.c,79 :: 		Delay_ms(5000);
	MOVLW      26
	MOVWF      R11+0
	MOVLW      94
	MOVWF      R12+0
	MOVLW      110
	MOVWF      R13+0
L_main14:
	DECFSZ     R13+0, 1
	GOTO       L_main14
	DECFSZ     R12+0, 1
	GOTO       L_main14
	DECFSZ     R11+0, 1
	GOTO       L_main14
	NOP
;Configurador.c,80 :: 		while(1){
L_main15:
;Configurador.c,81 :: 		readTime(date2);
	MOVLW      main_date2_L0+0
	MOVWF      FARG_readTime_currentTime+0
	CALL       _readTime+0
;Configurador.c,82 :: 		UART1_Write_Text("[");
	MOVLW      ?lstr2_Configurador+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Configurador.c,83 :: 		for (i = 3; i > 0; i--)
	MOVLW      3
	MOVWF      main_i_L0+0
L_main17:
	MOVF       main_i_L0+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L_main18
;Configurador.c,85 :: 		IntToStr(convertValueIN(date2[i]), text);
	MOVF       main_i_L0+0, 0
	ADDLW      main_date2_L0+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_convertValueIN_value+0
	CALL       _convertValueIN+0
	MOVF       R0+0, 0
	MOVWF      FARG_IntToStr_input+0
	CLRF       FARG_IntToStr_input+1
	MOVLW      main_text_L0+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;Configurador.c,86 :: 		UART1_Write_Text(text);
	MOVLW      main_text_L0+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Configurador.c,83 :: 		for (i = 3; i > 0; i--)
	DECF       main_i_L0+0, 1
;Configurador.c,87 :: 		}
	GOTO       L_main17
L_main18:
;Configurador.c,88 :: 		UART1_Write_Text("]");
	MOVLW      ?lstr3_Configurador+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Configurador.c,89 :: 		Delay_ms(500);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
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
;Configurador.c,91 :: 		}
	GOTO       L_main15
;Configurador.c,92 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
