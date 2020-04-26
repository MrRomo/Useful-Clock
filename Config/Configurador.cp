#line 1 "C:/Users/wwrik/Documents/Code/Micros/Reloj SPI/Config/Configurador.c"







unsigned char spi_transfer(unsigned char info){
 SSPBUF = info;
 while(!SSPSTAT.BF);

 return SSPBUF;
}
typedef struct timeParameters{
 unsigned char ss ;
 unsigned char mm ;
 unsigned char hh ;
 unsigned char dy ;
 unsigned char d ;
 unsigned char m ;
 unsigned char y ;
}timeParameters_t ;

unsigned char convertValueIN(unsigned char value){
 unsigned char convertedVal = value - 6 * (value >> 4) ;
 return convertedVal ;
}
unsigned char convertValueOUT(unsigned char value){
 unsigned char convertedVal = value + 6 * (value / 10);
 return convertedVal ;
}

void print_date(timeParameters_t * dataTime){
 UART1_Write_Text(dataTime->ss);
 UART1_Write_Text(dataTime->mm);
 UART1_Write_Text(dataTime->hh);
 UART1_Write_Text(dataTime->dy);
 UART1_Write_Text(dataTime->d);
 UART1_Write_Text(dataTime->m);
 UART1_Write_Text(dataTime->y);
 UART1_Write_Text(dataTime->d);
}
void get_time(){
 timeParameters_t * timeVals;
 char i = 0;
 char text [10];
  PORTD.F0  = 0;
 Delay_ms(100);
 UART1_Write_Text("LEYENDO TIEMPO");
 spi_transfer( 0x00 ) ;
 timeVals->ss = convertValueIN(spi_transfer(0x00));
 timeVals->mm = convertValueIN(spi_transfer(0x01));





  PORTD.F0  = 1;

}
void setTime(){
 UART1_Write_Text("Seteando el tiempo");
  PORTD.F0  = 0;
 Delay_ms(100);
 spi_transfer(0x81);
 spi_transfer(0x19);
  PORTD.F0  = 1;
 Delay_ms(10) ;
}


void RTC_init(char freq){
 unsigned char config;
  PORTD.F0  = 0;
 spi_transfer( 0x0E );
 config = spi_transfer(0x00);
  PORTD.F0  = 1;
 Delay_ms(100);
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
 Delay_ms(2000);
 RTC_init(1);
 setTime();
 while(1){

 }
}
