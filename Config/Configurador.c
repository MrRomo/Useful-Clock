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
     spi_transfer(info[i]);
   }
   CS = 1;
   Delay_ms(10);
}
unsigned char readData() {
   unsigned char dato;
   while (1){
     if(UART1_Data_Ready()){
        dato = UART1_Read();
        return dato;
     }
   }
}

unsigned char ascii2hex(){
    unsigned char dato = 0, datoh = 0;
    dato = readData();
    datoh = readData();
    dato = (dato>='A') ? (dato-55)<<4 : (dato-48)<<4;
    dato += (datoh>='A') ? datoh-55 : datoh-48;
    PORTB = 0xFF;
    return dato;
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
   byte text[10], i, buff[10], check = 0;
   byte date[] = {0x84,0x26,0x04,0x20}, date2[4] = {0x04};
   byte time[] = {0x80,0x59,0x30,0x05}, time2[4] = {0x00};
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
   while (1) {
      check = 0;
      if(UART1_Data_Ready()){
         check = UART1_Read();
         if(check == 'r'){
            readTime(date2);
            readTime(time2);
            for (i = 3; i > 0; i--)
            {
               UART1_Write(convertValueIN(time2[i]));
               UART1_Write(convertValueIN(date2[i]));
            }
         }
         if(check == 's'){
            for(i = 3; i>0; i--){
              time[i] = ascii2hex();
            }
            for(i = 1; i<4; i++){
              date[i] = ascii2hex();
            }
            setTime(date);
            setTime(time);
            UART1_Write_Text("OK\n");
         }
      }
   }
}