import serial
import sys
from Watch import Watch
from time import sleep as delay

class SerialManager():

    def __init__(self):
        self.isWork = 0
        self.puerto = serial.Serial('COM1', 9600)

    def send(self, msg):
        self.isWork = 1
        delay(0.1)
        print("enviando", msg)
        self.puerto.flushInput()
        self.puerto.write('s'.encode())
        for i in msg:
            i = i +6 * (i // 10)
            print('Sendind: ', i.to_bytes(1,'big'))
            self.puerto.write(i.to_bytes(1,'big'))
        respuesta = self.puerto.readline().decode()
        if(respuesta == 'OK\n'):
            print('Tiempo enviado correctamente...')
        elif(respuesta == 'BAD\n'):
            print('Fallo envio de tiempo...')
        self.isWork = 0
        
    def receive(self):
        if(not(self.isWork)):
            self.puerto.flushInput()
            self.puerto.write('r'.encode())
            util = Watch()
            res = []
            for i in range(7):
                temp = self.puerto.read()
                byteIn = int.from_bytes(temp,sys.byteorder)
                res.append(byteIn - 6 * (byteIn >> 4))
            print(res)
            res = list(map(util.fillZero, res))  
            res = '{x[2]}:{x[1]}:{x[0]}|{x[4]}/{x[5]}/{x[6]}'.format(x=res)
            return res

        
