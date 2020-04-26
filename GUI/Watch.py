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
            return s

    def getRealTime(self):
        self.currentDT = datetime.datetime.now()
        temp = [self.currentDT.hour,self.currentDT.minute,self.currentDT.second,
                self.currentDT.day,self.currentDT.month,self.currentDT.year-2000]
        return list(map(self.fillZero, temp))                      

    def pushTime(self):
        time = datetime.datetime.now()

    def getTimeHex(self):
        temp = ':{x[0]}{x[1]}{x[2]}{x[3]}{x[4]}{x[5]}'.format(x=self.getRealTime())
        return temp

    def getTimeStr(self):
        temp = '{x[0]}:{x[1]}:{x[2]}|{x[3]}/{x[4]}/{x[5]}'.format(x=self.getRealTime())
        return temp


