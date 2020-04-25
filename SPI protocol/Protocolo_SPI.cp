#line 1 "C:/Users/Carlos/Micros II/Protocolo_SPI.c"

void main() {
 TRISC.F3 = 0;
 TRISC.F5 = 0;
 TRISC.F4 = 1;
 TRISD.F0 = 0;
 SSPSTAT = 0X40;
 SSPCON = 0X20;
  PORTD.F0  = 1;
 Delay_ms(100);
 while(1){
  PORTD.F0  = 0;
 SSPBUF = 'H';
 while(!SSPSTAT.BF);
 SSPBUF = 'O';
 while(!SSPSTAT.BF);
 SSPBUF = 'L';
 while(!SSPSTAT.BF);
 SSPBUF = 'A';
 while(!SSPSTAT.BF);
  PORTD.F0  = 1;
 Delay_ms(500);
 }

}
