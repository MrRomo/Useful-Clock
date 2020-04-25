#line 1 "C:/Users/Carlos/Micros II/EEPROM SPI/EEPROM_SPI.c"





void write_eeprom(unsigned char dato, unsigned char dir){
  PORTD.F0  = 0;
 SSPBUF =  0x06 ;
 while(!SSPSTAT.BF);
  PORTD.F0  = 1;

  PORTD.F0  = 0;
 SSPBUF =  0x02 ;
 while(!SSPSTAT.BF);
 SSPBUF = dir;
 while(!SSPSTAT.BF);
 SSPBUF = dato;
 while(!SSPSTAT.BF);
  PORTD.F0  = 1;
}


void read_eeprom(unsigned char dir){
  PORTD.F0  = 0;
 SSPBUF =  0x03 ;
 while(!SSPSTAT.BF);
 SSPBUF = dir;
 while(!SSPSTAT.BF);
 SSPBUF = 0xFF;
 while(!SSPSTAT.BF);
  PORTD.F0  = 1;
}

void main() {
 unsigned int valor = 0, i=0;
 unsigned char temporal = 0;
 TRISC.F3 = 0;
 TRISC.F5 = 0;
 TRISC.F4 = 1;
 TRISD.F0 = 0;
 SSPSTAT = 0X40;
 SSPCON = 0X20;
  PORTD.F0  = 1;
 Delay_ms(100);
 while(1){


 read_eeprom(0x20);
 Delay_ms(500);
 }
}
