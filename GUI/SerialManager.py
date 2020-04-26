import serial
import sys
from Watch import Watch
class SerialManager():

    def __init__(self):
        self.isWork = 0
        self.puerto = serial.Serial('COM1', 9600)

    def send(self, msg):
        self.isWork = 1
        self.puerto.write(msg.encode())
        respuesta = self.puerto.readline().decode()
        if(respuesta == 'OK\n'):
            print('Tiempo enviado correctamente...')
        
        elif(respuesta == 'BAD\n'):
            print('Fallo envio de tiempo...')

        
    def receive(self):
        # if(not(self.isWork)):
        self.puerto.flushInput()
        self.puerto.write('r'.encode())
        util = Watch()
        res = []
        for i in range(6):
            res.append(int.from_bytes(self.puerto.read(),sys.byteorder))
        print(res)
        res = list(map(util.fillZero, res))  
        res = '{x[0]}:{x[2]}:{x[4]}|{x[5]}/{x[3]}/{x[1]}'.format(x=res)
        return res

        
