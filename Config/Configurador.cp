#line 1 "C:/Users/wwrik/Documents/Code/Micros/Reloj SPI/Config/Configurador.c"







char spi_transfer(char info){
 SSPBUF =  0x00 ;
 while(!SSPSTAT.BF);
 SSPSTAT.BF = 0;
 return SSPBUF;
}

void get_time(){
 char text[10];
 char i = 0;
  PORTD.F0  = 0;
 UART1_Write_Text("LEYENDO TIEMPO");
 for (i = 0; i < 8; i++)
 {
 IntToStr(spi_transfer( 0x00 ),text);
 UART1_Write_Text(text);
 }
  PORTD.F0  = 1;
}

void main() {
 char text[10];
 UART1_Init(9600);
 UART1_Write_Text("inicio de la prueba");
 TRISC.F3 = 0;
 TRISC.F5 = 0;
 TRISC.F4 = 1;
 TRISD.F0 = 0;
 SSPSTAT = 0X40;
 SSPCON = 0X20;
  PORTD.F0  = 1;
 Delay_ms(1000);
  PORTD.F0  = 0;
 UART1_Write_Text("Configurando: ");
 spi_transfer( 0x0E );
 IntToStr(spi_transfer(0x00),text);
 UART1_Write_Text(text);
  PORTD.F0  = 1;
 Delay_ms(1000);
 while(1){
 get_time();
 Delay_ms(1500);
 }
}
