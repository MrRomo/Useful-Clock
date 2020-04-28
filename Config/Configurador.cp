#line 1 "C:/Users/wwrik/Documents/Code/Micros/Reloj SPI/Config/Configurador.c"








typedef unsigned char byte;

byte spi_transfer(byte info){
 SSPBUF = info;
 while(!SSPSTAT.BF);
 return SSPBUF;
}

unsigned char readData() {
 while (1){
 if(UART1_Data_Ready()){
 return UART1_Read();
 }
 }
}

void setTime(byte * info){
 char i = 0;
  PORTD.F0  = 0;
 spi_transfer(0x80);
 for (i = 0; i < 7; i++)
 {
 spi_transfer(info[i]);
 }
  PORTD.F0  = 1;
 Delay_ms(10);
}

void readTime(byte * currentTime){
 char i = 0;
  PORTD.F0  = 0;
 spi_transfer(0x00);
 for (i = 0; i < 7; i++)
 {
 currentTime[i] = spi_transfer(0x00);
 }
  PORTD.F0  = 1;
}

void initConfig(){
 UART1_Init(9600);
 TRISC.F3 = 0;
 TRISC.F5 = 0;
 TRISC.F4 = 1;
 TRISD.F0 = 0;
 SSPSTAT = 0X80;
 SSPCON = 0X20;
  PORTD.F0  = 1;
 Delay_ms(10);

}

void main() {
 byte text[10], i, buff[10], check = 0, date[] = {0x59,0x30,0x05,0x00,0x28,0x04,0x20}, date2[7] = {0x00};
 initConfig();
 setTime(date);
 while (1) {
 check = 0;
 if(UART1_Data_Ready()){
 check = UART1_Read();
 if(check == 'r'){
 readTime(date2);
 for (i = 0; i <7; i++)
 {
 UART1_Write(date2[i]);
 }
 }
 if(check == 's'){
 for(i = 0; i<7; i++){
 date[i] =readData();
 }
 setTime(date);
 UART1_Write_Text("OK\n");
 }
 }
 }
}
