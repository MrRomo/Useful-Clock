import datetime


class Watch():

    def __init__(self):
        self.currentDT = None
        self.timeStr = ''
        self.timeHex = ''
        self.timeArray = []
        self.getRealTime()
    
    def fillZero(self, s):
        if s<10:
            return '0'+str(s)
        else:
            return str(s)

    def getRealTime(self):
        self.currentDT = datetime.datetime.now()
        temp = [self.currentDT.second,self.currentDT.minute,self.currentDT.hour,self.currentDT.weekday(),
                self.currentDT.day,self.currentDT.month,self.currentDT.year-2000]
        # print(self.currentDT)
        # print(self.currentDT.weekday())
        return temp                      

    def pushTime(self):
        time = datetime.datetime.now()
    
    def int2byte(self,s):

        return hex(s).encode() 
 
    def getTimeHex(self):

        return list(map(self.int2byte,self.getRealTime()))

    def getTimeStr(self):
        temp = '{x[2]}:{x[1]}:{x[0]}|{x[4]}/{x[5]}/{x[6]}'.format(x=list(map(self.fillZero, self.getRealTime())))
        return temp


