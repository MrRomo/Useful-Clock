#define CS PORTD.F0

#define WRITE_CONTROL_REG 0x8E
#define READ_CONTROL_REG 0x0E
#define WRITE_TIME_REG 0x80
#define READ_TIME_REG 0x00

unsigned char spi_transfer(unsigned char info){
   SSPBUF = info;
   while(!SSPSTAT.BF);
   SSPSTAT.BF = 0;
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
   CS = 0;
   Delay_ms(100);
   UART1_Write_Text("LEYENDO TIEMPO");
   spi_transfer(READ_TIME_REG) ;
   timeVals->ss = convertValueIN(spi_transfer(0x00));
   timeVals->mm = convertValueIN(spi_transfer(0x01));
   // timeVals->hh = convertValueIN(spi_transfer(0x00));
   // timeVals->dy = convertValueIN(spi_transfer(0x00));
   // timeVals->d = convertValueIN(spi_transfer(0x00));
   // timeVals->m = convertValueIN(spi_transfer(0x00));
   // timeVals->y = convertValueIN(spi_transfer(0x00));
   CS = 1;
   // print_date(timeVals);
}
void setTime(){
   UART1_Write_Text("Seteando el tiempo");
   CS = 0;
   Delay_ms(100);
   spi_transfer(0x81);
   spi_transfer(0x19);
   CS = 1;
   Delay_ms(10) ;
}


void RTC_init(char freq){
   unsigned char config;
   CS = 0;
   spi_transfer(READ_CONTROL_REG);
   config = spi_transfer(0x00);
   CS = 1;
   Delay_ms(100);
}

void main() {
   char text[10];
   UART1_Init(9600);
   UART1_Write_Text("inicio de la prueba");
   TRISC.F3 = 0; //CLK SPI
   TRISC.F5 = 0; //MOSI - SDO
   TRISC.F4 = 1; //MISO - SDI
   TRISD.F0 = 0; //CS
   SSPSTAT = 0X40;
   SSPCON =  0X20;
   CS = 1;
   Delay_ms(2000);
   RTC_init(1);
   setTime();
   while(1){

   }
}