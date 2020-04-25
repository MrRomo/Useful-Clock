#define CS PORTD.F0

void set_value(unsigned int valor){
   unsigned char temporal = 0;
   temporal = ((valor >> 8) & 0x0F ) | 0x30;
   CS = 0;
     SSPBUF = temporal;
     while(!SSPSTAT.BF);
     SSPBUF = (char)valor;
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
       for(i=0; i<4096; i++){
          set_value(i*20);
          Delay_ms(5);
       }
       Delay_ms(500);
    }
}