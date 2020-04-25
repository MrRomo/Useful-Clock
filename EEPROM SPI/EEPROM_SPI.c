#define CS PORTD.F0
#define WREN 0x06
#define WRITE 0x02
#define READ 0x03

void write_eeprom(unsigned char dato, unsigned char dir){
   CS = 0;
      SSPBUF = WREN;
      while(!SSPSTAT.BF);
   CS = 1;
   
   CS = 0;
     SSPBUF = WRITE;
     while(!SSPSTAT.BF);
     SSPBUF = dir;
     while(!SSPSTAT.BF);
     SSPBUF = dato;
     while(!SSPSTAT.BF);
   CS = 1;
}


void read_eeprom(unsigned char dir){
   CS = 0;
     SSPBUF = READ;
     while(!SSPSTAT.BF);
     SSPBUF = dir;
     while(!SSPSTAT.BF);
     SSPBUF = 0xFF;
     while(!SSPSTAT.BF);
   CS = 1;
}

void main() {
    unsigned int valor = 0, i=0;
    unsigned char temporal = 0;
    TRISC.F3 = 0; //CLK SPI
    TRISC.F5 = 0; //MOSI - SDO
    TRISC.F4 = 1; //MISO - SDI
    TRISD.F0 = 0; //CS
    SSPSTAT = 0X40;
    SSPCON =  0X20;
    CS = 1;
    Delay_ms(100);
    while(1){
       //write_eeprom(0x50, 0x20);
       //Delay_ms(5);
       read_eeprom(0x20);
       Delay_ms(500);
    }
}