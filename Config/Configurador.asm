
_spi_transfer:

;Configurador.c,8 :: 		unsigned char spi_transfer(unsigned char info){
;Configurador.c,9 :: 		SSPBUF = info;
	MOVF       FARG_spi_transfer_info+0, 0
	MOVWF      SSPBUF+0
;Configurador.c,10 :: 		while(!SSPSTAT.BF);
L_spi_transfer0:
	BTFSC      SSPSTAT+0, 0
	GOTO       L_spi_transfer1
	GOTO       L_spi_transfer0
L_spi_transfer1:
;Configurador.c,12 :: 		return SSPBUF;
	MOVF       SSPBUF+0, 0
	MOVWF      R0+0
;Configurador.c,13 :: 		}
L_end_spi_transfer:
	RETURN
; end of _spi_transfer

_convertValueIN:

;Configurador.c,24 :: 		unsigned char convertValueIN(unsigned char value){
;Configurador.c,25 :: 		unsigned char convertedVal = value - 6 * (value >> 4) ;
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
;Configurador.c,26 :: 		return convertedVal ;
;Configurador.c,27 :: 		}
L_end_convertValueIN:
	RETURN
; end of _convertValueIN

_convertValueOUT:

;Configurador.c,28 :: 		unsigned char convertValueOUT(unsigned char value){
;Configurador.c,29 :: 		unsigned char convertedVal = value + 6 * (value / 10);
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
;Configurador.c,30 :: 		return convertedVal ;
;Configurador.c,31 :: 		}
L_end_convertValueOUT:
	RETURN
; end of _convertValueOUT

_print_date:

;Configurador.c,33 :: 		void print_date(timeParameters_t * dataTime){
;Configurador.c,34 :: 		UART1_Write_Text(dataTime->ss);
	MOVF       FARG_print_date_dataTime+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Configurador.c,35 :: 		UART1_Write_Text(dataTime->mm);
	INCF       FARG_print_date_dataTime+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Configurador.c,36 :: 		UART1_Write_Text(dataTime->hh);
	MOVLW      2
	ADDWF      FARG_print_date_dataTime+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Configurador.c,37 :: 		UART1_Write_Text(dataTime->dy);
	MOVLW      3
	ADDWF      FARG_print_date_dataTime+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Configurador.c,38 :: 		UART1_Write_Text(dataTime->d);
	MOVLW      4
	ADDWF      FARG_print_date_dataTime+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Configurador.c,39 :: 		UART1_Write_Text(dataTime->m);
	MOVLW      5
	ADDWF      FARG_print_date_dataTime+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Configurador.c,40 :: 		UART1_Write_Text(dataTime->y);
	MOVLW      6
	ADDWF      FARG_print_date_dataTime+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Configurador.c,41 :: 		UART1_Write_Text(dataTime->d);
	MOVLW      4
	ADDWF      FARG_print_date_dataTime+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Configurador.c,42 :: 		}
L_end_print_date:
	RETURN
; end of _print_date

_get_time:

;Configurador.c,43 :: 		void get_time(){
;Configurador.c,45 :: 		char i = 0;
;Configurador.c,47 :: 		CS = 0;
	BCF        PORTD+0, 0
;Configurador.c,48 :: 		Delay_ms(100);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_get_time2:
	DECFSZ     R13+0, 1
	GOTO       L_get_time2
	DECFSZ     R12+0, 1
	GOTO       L_get_time2
	NOP
	NOP
;Configurador.c,49 :: 		UART1_Write_Text("LEYENDO TIEMPO");
	MOVLW      ?lstr1_Configurador+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Configurador.c,50 :: 		spi_transfer(READ_TIME_REG) ;
	CLRF       FARG_spi_transfer_info+0
	CALL       _spi_transfer+0
;Configurador.c,51 :: 		timeVals->ss = convertValueIN(spi_transfer(0x00));
	MOVF       get_time_timeVals_L0+0, 0
	MOVWF      FLOC__get_time+0
	CLRF       FARG_spi_transfer_info+0
	CALL       _spi_transfer+0
	MOVF       R0+0, 0
	MOVWF      FARG_convertValueIN_value+0
	CALL       _convertValueIN+0
	MOVF       FLOC__get_time+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;Configurador.c,52 :: 		timeVals->mm = convertValueIN(spi_transfer(0x01));
	INCF       get_time_timeVals_L0+0, 0
	MOVWF      FLOC__get_time+0
	MOVLW      1
	MOVWF      FARG_spi_transfer_info+0
	CALL       _spi_transfer+0
	MOVF       R0+0, 0
	MOVWF      FARG_convertValueIN_value+0
	CALL       _convertValueIN+0
	MOVF       FLOC__get_time+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;Configurador.c,58 :: 		CS = 1;
	BSF        PORTD+0, 0
;Configurador.c,60 :: 		}
L_end_get_time:
	RETURN
; end of _get_time

_setTime:

;Configurador.c,61 :: 		void setTime(){
;Configurador.c,62 :: 		UART1_Write_Text("Seteando el tiempo");
	MOVLW      ?lstr2_Configurador+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Configurador.c,63 :: 		CS = 0;
	BCF        PORTD+0, 0
;Configurador.c,64 :: 		Delay_ms(100);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_setTime3:
	DECFSZ     R13+0, 1
	GOTO       L_setTime3
	DECFSZ     R12+0, 1
	GOTO       L_setTime3
	NOP
	NOP
;Configurador.c,65 :: 		spi_transfer(0x81);
	MOVLW      129
	MOVWF      FARG_spi_transfer_info+0
	CALL       _spi_transfer+0
;Configurador.c,66 :: 		spi_transfer(0x19);
	MOVLW      25
	MOVWF      FARG_spi_transfer_info+0
	CALL       _spi_transfer+0
;Configurador.c,67 :: 		CS = 1;
	BSF        PORTD+0, 0
;Configurador.c,68 :: 		Delay_ms(10) ;
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L_setTime4:
	DECFSZ     R13+0, 1
	GOTO       L_setTime4
	DECFSZ     R12+0, 1
	GOTO       L_setTime4
	NOP
	NOP
;Configurador.c,69 :: 		}
L_end_setTime:
	RETURN
; end of _setTime

_RTC_init:

;Configurador.c,72 :: 		void RTC_init(char freq){
;Configurador.c,74 :: 		CS = 0;
	BCF        PORTD+0, 0
;Configurador.c,75 :: 		spi_transfer(READ_CONTROL_REG);
	MOVLW      14
	MOVWF      FARG_spi_transfer_info+0
	CALL       _spi_transfer+0
;Configurador.c,76 :: 		config = spi_transfer(0x00);
	CLRF       FARG_spi_transfer_info+0
	CALL       _spi_transfer+0
;Configurador.c,77 :: 		CS = 1;
	BSF        PORTD+0, 0
;Configurador.c,78 :: 		Delay_ms(100);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_RTC_init5:
	DECFSZ     R13+0, 1
	GOTO       L_RTC_init5
	DECFSZ     R12+0, 1
	GOTO       L_RTC_init5
	NOP
	NOP
;Configurador.c,79 :: 		}
L_end_RTC_init:
	RETURN
; end of _RTC_init

_main:

;Configurador.c,81 :: 		void main() {
;Configurador.c,83 :: 		UART1_Init(9600);
	MOVLW      25
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;Configurador.c,84 :: 		UART1_Write_Text("inicio de la prueba");
	MOVLW      ?lstr3_Configurador+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Configurador.c,85 :: 		TRISC.F3 = 0; //CLK SPI
	BCF        TRISC+0, 3
;Configurador.c,86 :: 		TRISC.F5 = 0; //MOSI - SDO
	BCF        TRISC+0, 5
;Configurador.c,87 :: 		TRISC.F4 = 1; //MISO - SDI
	BSF        TRISC+0, 4
;Configurador.c,88 :: 		TRISD.F0 = 0; //CS
	BCF        TRISD+0, 0
;Configurador.c,89 :: 		SSPSTAT = 0X40;
	MOVLW      64
	MOVWF      SSPSTAT+0
;Configurador.c,90 :: 		SSPCON =  0X20;
	MOVLW      32
	MOVWF      SSPCON+0
;Configurador.c,91 :: 		CS = 1;
	BSF        PORTD+0, 0
;Configurador.c,92 :: 		Delay_ms(2000);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_main6:
	DECFSZ     R13+0, 1
	GOTO       L_main6
	DECFSZ     R12+0, 1
	GOTO       L_main6
	DECFSZ     R11+0, 1
	GOTO       L_main6
	NOP
	NOP
;Configurador.c,93 :: 		RTC_init(1);
	MOVLW      1
	MOVWF      FARG_RTC_init_freq+0
	CALL       _RTC_init+0
;Configurador.c,94 :: 		setTime();
	CALL       _setTime+0
;Configurador.c,95 :: 		while(1){
L_main7:
;Configurador.c,97 :: 		}
	GOTO       L_main7
;Configurador.c,98 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
