
_spi_transfer:

;Configurador.c,8 :: 		char spi_transfer(char info){
;Configurador.c,9 :: 		SSPBUF = READ_TIME_REG;
	CLRF       SSPBUF+0
;Configurador.c,10 :: 		while(!SSPSTAT.BF);
L_spi_transfer0:
	BTFSC      SSPSTAT+0, 0
	GOTO       L_spi_transfer1
	GOTO       L_spi_transfer0
L_spi_transfer1:
;Configurador.c,11 :: 		SSPSTAT.BF = 0;
	BCF        SSPSTAT+0, 0
;Configurador.c,12 :: 		return SSPBUF;
	MOVF       SSPBUF+0, 0
	MOVWF      R0+0
;Configurador.c,13 :: 		}
L_end_spi_transfer:
	RETURN
; end of _spi_transfer

_get_time:

;Configurador.c,15 :: 		void get_time(){
;Configurador.c,17 :: 		char i = 0;
	CLRF       get_time_i_L0+0
;Configurador.c,18 :: 		CS = 0;
	BCF        PORTD+0, 0
;Configurador.c,19 :: 		UART1_Write_Text("LEYENDO TIEMPO");
	MOVLW      ?lstr1_Configurador+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Configurador.c,20 :: 		for (i = 0; i < 8; i++)
	CLRF       get_time_i_L0+0
L_get_time2:
	MOVLW      8
	SUBWF      get_time_i_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_get_time3
;Configurador.c,22 :: 		IntToStr(spi_transfer(READ_TIME_REG),text);
	CLRF       FARG_spi_transfer_info+0
	CALL       _spi_transfer+0
	MOVF       R0+0, 0
	MOVWF      FARG_IntToStr_input+0
	CLRF       FARG_IntToStr_input+1
	MOVLW      get_time_text_L0+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;Configurador.c,23 :: 		UART1_Write_Text(text);
	MOVLW      get_time_text_L0+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Configurador.c,20 :: 		for (i = 0; i < 8; i++)
	INCF       get_time_i_L0+0, 1
;Configurador.c,24 :: 		}
	GOTO       L_get_time2
L_get_time3:
;Configurador.c,25 :: 		CS = 1;
	BSF        PORTD+0, 0
;Configurador.c,26 :: 		}
L_end_get_time:
	RETURN
; end of _get_time

_main:

;Configurador.c,28 :: 		void main() {
;Configurador.c,30 :: 		UART1_Init(9600);
	MOVLW      25
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;Configurador.c,31 :: 		UART1_Write_Text("inicio de la prueba");
	MOVLW      ?lstr2_Configurador+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Configurador.c,32 :: 		TRISC.F3 = 0; //CLK SPI
	BCF        TRISC+0, 3
;Configurador.c,33 :: 		TRISC.F5 = 0; //MOSI - SDO
	BCF        TRISC+0, 5
;Configurador.c,34 :: 		TRISC.F4 = 1; //MISO - SDI
	BSF        TRISC+0, 4
;Configurador.c,35 :: 		TRISD.F0 = 0; //CS
	BCF        TRISD+0, 0
;Configurador.c,36 :: 		SSPSTAT = 0X40;
	MOVLW      64
	MOVWF      SSPSTAT+0
;Configurador.c,37 :: 		SSPCON =  0X20;
	MOVLW      32
	MOVWF      SSPCON+0
;Configurador.c,38 :: 		CS = 1;
	BSF        PORTD+0, 0
;Configurador.c,39 :: 		Delay_ms(1000);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_main5:
	DECFSZ     R13+0, 1
	GOTO       L_main5
	DECFSZ     R12+0, 1
	GOTO       L_main5
	DECFSZ     R11+0, 1
	GOTO       L_main5
	NOP
	NOP
;Configurador.c,40 :: 		CS = 0;
	BCF        PORTD+0, 0
;Configurador.c,41 :: 		UART1_Write_Text("Configurando: ");
	MOVLW      ?lstr3_Configurador+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Configurador.c,42 :: 		spi_transfer(READ_CONTROL_REG);
	MOVLW      14
	MOVWF      FARG_spi_transfer_info+0
	CALL       _spi_transfer+0
;Configurador.c,43 :: 		IntToStr(spi_transfer(0x00),text);
	CLRF       FARG_spi_transfer_info+0
	CALL       _spi_transfer+0
	MOVF       R0+0, 0
	MOVWF      FARG_IntToStr_input+0
	CLRF       FARG_IntToStr_input+1
	MOVLW      main_text_L0+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;Configurador.c,44 :: 		UART1_Write_Text(text);
	MOVLW      main_text_L0+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Configurador.c,45 :: 		CS = 1;
	BSF        PORTD+0, 0
;Configurador.c,46 :: 		Delay_ms(1000);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
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
;Configurador.c,47 :: 		while(1){
L_main7:
;Configurador.c,48 :: 		get_time();
	CALL       _get_time+0
;Configurador.c,49 :: 		Delay_ms(1500);
	MOVLW      8
	MOVWF      R11+0
	MOVLW      157
	MOVWF      R12+0
	MOVLW      5
	MOVWF      R13+0
L_main9:
	DECFSZ     R13+0, 1
	GOTO       L_main9
	DECFSZ     R12+0, 1
	GOTO       L_main9
	DECFSZ     R11+0, 1
	GOTO       L_main9
	NOP
	NOP
;Configurador.c,50 :: 		}
	GOTO       L_main7
;Configurador.c,51 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
