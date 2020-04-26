#define CS PORTD.F0

#define WRITE_CONTROL_REG 0x8E
#define READ_CONTROL_REG 0x0E
#define WRITE_TIME_REG 0x80
#define WRITE_DATE_REG 0x84
#define READ_TIME_REG 0x00
#define READ_DATE_REG 0x04
typedef unsigned char byte;

byte spi_transfer(byte info){
   SSPBUF = info;
   while(!SSPSTAT.BF);
   return SSPBUF;
}

byte convertValueIN(byte value){
  byte convertedVal = value - 6 * (value >> 4);
  return convertedVal ;
}

byte convertValueOUT(byte value){
  byte convertedVal = value +6 * (value / 10);
  return convertedVal ;
}


void setTime(byte * info){
   char i = 0;
   CS = 0;
   Delay_ms(10);
   spi_transfer(info[0]);
   for (i = 1; i < 4; i++)
   {  
     spi_transfer(convertValueOUT(info[i]));
   }
   CS = 1;
   Delay_ms(10);
}
void readTime(byte * currentTime){
   char i = 0;
   CS = 0;
   Delay_ms(10);
   spi_transfer(currentTime[0]);
   for (i = 1; i < 4; i++)
   {  
     currentTime[i] = spi_transfer(0x00);
   }
   CS = 1;
   Delay_ms(10);
}

void RTC_init(char freq){
   byte config;
   CS = 0;
   spi_transfer(READ_CONTROL_REG);
   config = spi_transfer(0x00);
   CS = 1;
   Delay_ms(100);
}

void main() {
   byte text[10], i;
   byte date[] = {0x84,26,04,20}, date2[4] = {0x00}, sec;
   byte time[] = {0x80,59,30,05}, time2[4];
   UART1_Init(9600);
   UART1_Write_Text("inicio de la prueba");
   TRISC.F3 = 0; //CLK SPI
   TRISC.F5 = 0; //MOSI - SDO
   TRISC.F4 = 1; //MISO - SDI
   TRISD.F0 = 0; //CS
   SSPSTAT = 0X00;
   SSPCON =  0X20;
   CS = 1;
   Delay_ms(2000);
   RTC_init(1);
   setTime(date);
   setTime(time);
   Delay_ms(5000);
   while(1){
      readTime(date2);
      UART1_Write_Text("[");
      for (i = 3; i > 0; i--)
      {
        IntToStr(convertValueIN(date2[i]), text);
        UART1_Write_Text(text);
      }
      UART1_Write_Text("]");
      Delay_ms(500);
      
   }
}