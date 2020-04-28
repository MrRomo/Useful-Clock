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

unsigned char readData() {
   while (1){
     if(UART1_Data_Ready()){
        return  UART1_Read();
     }
   }
}

void setTime(byte * info){
   char i = 0;
   CS = 0;
   spi_transfer(0x80);
   for (i = 0; i < 7; i++)
   {  
     spi_transfer(info[i]);
   }
   CS = 1;
   Delay_ms(10);
}

void readTime(byte * currentTime){
   char i = 0;
   CS = 0;
   spi_transfer(0x00);
   for (i = 0; i < 7; i++)
   {  
     currentTime[i] = spi_transfer(0x00);
   }
   CS = 1;
}

void initConfig(){
   UART1_Init(9600);
   TRISC.F3 = 0; //CLK SPI
   TRISC.F5 = 0; //MOSI - SDO
   TRISC.F4 = 1; //MISO - SDI
   TRISD.F0 = 0; //CS
   SSPSTAT = 0X80;
   SSPCON =  0X20;
   CS = 1;
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