#define CS PORTD.F0

#define WRITE_CONTROL_REG 0x8E
#define READ_CONTROL_REG 0x0E
#define WRITE_TIME_REG 0x80
#define READ_TIME_REG 0x00

char spi_transfer(char info){
   SSPBUF = READ_TIME_REG;
   while(!SSPSTAT.BF);
   SSPSTAT.BF = 0;
   return SSPBUF;
}

void get_time(){
   char text[10];
   char i = 0;
   CS = 0;               
   UART1_Write_Text("LEYENDO TIEMPO");
   for (i = 0; i < 8; i++)
   {
   IntToStr(spi_transfer(READ_TIME_REG),text);
   UART1_Write_Text(text);
   }
   CS = 1;
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
   Delay_ms(1000);
   CS = 0;
   UART1_Write_Text("Configurando: ");
   spi_transfer(READ_CONTROL_REG);
   IntToStr(spi_transfer(0x00),text);
   UART1_Write_Text(text);
   CS = 1;
   Delay_ms(1000);
   while(1){
      get_time();
      Delay_ms(1500);
   }
}