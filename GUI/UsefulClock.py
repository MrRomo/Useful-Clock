# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'UsefulClock.ui'
#
# Created by: PyQt5 UI code generator 5.9.2
#
# WARNING! All changes made in this file will be lost!

from PyQt5 import QtCore, QtGui, QtWidgets
from PyQt5.QtCore import Qt, QThread, pyqtSignal
from time import sleep as delay


from Watch import Watch
from SerialManager import SerialManager

fromSys = False

class RefreshClock(QThread):
    change_value = pyqtSignal(str)
    def run(self):
        self.fromSys = True
        watch = Watch()
        while 1:
            if(self.fromSys):
                date = watch.getTimeStr() 
                self.change_value.emit(date)
            delay(1)

class ReceiveTime(QThread):
    change_value = pyqtSignal(str)
    def run(self):
        self.fromSys = True
        self.serialManager = SerialManager()
        while(1):
            if(not(self.fromSys)):
                date = self.serialManager.receive()
                self.change_value.emit(date)
            delay(0.5)
    


class Ui_Dialog(object):
    def setupUi(self, Dialog):
        self.fromSys = False
        self.works = True
        Dialog.setObjectName("Dialog")
        Dialog.resize(400, 334)
        self.pushButton_2 = QtWidgets.QPushButton(Dialog)
        self.pushButton_2.setGeometry(QtCore.QRect(30, 220, 101, 41))
        self.pushButton_2.setObjectName("pushButton_2")
        self.pushButton_3 = QtWidgets.QPushButton(Dialog)
        self.pushButton_3.setGeometry(QtCore.QRect(150, 220, 101, 41))
        self.pushButton_3.setObjectName("pushButton_3")
        self.pushButton_4 = QtWidgets.QPushButton(Dialog)
        self.pushButton_4.setGeometry(QtCore.QRect(270, 220, 101, 41))
        self.pushButton_4.setObjectName("pushButton_4")
        self.pushButton_5 = QtWidgets.QPushButton(Dialog)
        self.pushButton_5.setGeometry(QtCore.QRect(30, 270, 341, 41))
        self.pushButton_5.setObjectName("pushButton_5")
        self.label = QtWidgets.QLabel(Dialog)
        self.label.setGeometry(QtCore.QRect(40, 9, 331, 41))
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Preferred, QtWidgets.QSizePolicy.Preferred)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.label.sizePolicy().hasHeightForWidth())
        self.label.setSizePolicy(sizePolicy)
        font = QtGui.QFont()
        font.setPointSize(26)
        font.setBold(True)
        font.setUnderline(False)
        font.setWeight(75)
        self.label.setFont(font)
        self.label.setLayoutDirection(QtCore.Qt.LeftToRight)
        self.label.setAlignment(QtCore.Qt.AlignCenter)
        self.label.setObjectName("label")
        self.hexBox = QtWidgets.QListWidget(Dialog)
        self.hexBox.setGeometry(QtCore.QRect(30, 60, 341, 61))
        font = QtGui.QFont()
        font.setPointSize(33)
        font.setBold(True)
        font.setWeight(75)
        self.hexBox.setFont(font)
        self.hexBox.setSizeAdjustPolicy(QtWidgets.QAbstractScrollArea.AdjustIgnored)
        self.hexBox.setObjectName("hexBox")
        item = QtWidgets.QListWidgetItem()
        self.hexBox.addItem(item)
        self.hexBox_2 = QtWidgets.QListWidget(Dialog)
        self.hexBox_2.setGeometry(QtCore.QRect(30, 140, 341, 61))
        font = QtGui.QFont()
        font.setPointSize(33)
        font.setBold(True)
        font.setWeight(75)
        self.hexBox_2.setFont(font)
        self.hexBox_2.viewport().setProperty("cursor", QtGui.QCursor(QtCore.Qt.CrossCursor))
        self.hexBox_2.setSizeAdjustPolicy(QtWidgets.QAbstractScrollArea.AdjustIgnored)
        self.hexBox_2.setObjectName("hexBox_2")
        item = QtWidgets.QListWidgetItem()
        self.hexBox_2.addItem(item)

        self.retranslateUi(Dialog)
        QtCore.QMetaObject.connectSlotsByName(Dialog)

        self.updateTimeThread = RefreshClock()
        self.updateTimeThread.change_value.connect(self.updateTime)
        self.updateTimeThread.start()

        self.receiveTimeThread = ReceiveTime()
        self.receiveTimeThread.change_value.connect(self.updateTime)
        self.receiveTimeThread.start()


        self.pushButton_5.clicked.connect(self.updateSource)
        self.pushButton_2.clicked.connect(self.sendTime)

    def updateSource(self):
        self.receiveTimeThread.fromSys = self.updateTimeThread.fromSys = not(self.receiveTimeThread.fromSys)

    def updateTime(self, msg):
        if(self.works):
            temp = msg.split('|')
            if(len(temp)>1):
                item = self.hexBox.item(0)
                item.setText(self.translate("Dialog", temp[0]))
                item = self.hexBox_2.item(0)
                item.setText(self.translate("Dialog", temp[1]))

    def sendTime(self):
        self.works = False
        self.receiveTimeThread.fromSys = self.updateTimeThread.fromSys = True
        watch = Watch()
        self.receiveTimeThread.serialManager.send(watch.getTimeHex())
        self.works = True
      

    def retranslateUi(self, Dialog):
        self.translate = _translate = QtCore.QCoreApplication.translate
        Dialog.setWindowTitle(_translate("Dialog", "Dialog"))
        self.pushButton_2.setText(_translate("Dialog", "Update"))
        self.pushButton_3.setText(_translate("Dialog", "Refresh"))
        self.pushButton_4.setText(_translate("Dialog", "Stop"))
        self.pushButton_5.setText(_translate("Dialog", "Switch Clock"))
        self.label.setText(_translate("Dialog", "Useful Clock"))
        __sortingEnabled = self.hexBox.isSortingEnabled()
        self.hexBox.setSortingEnabled(False)
        item = self.hexBox.item(0)
        item.setText(_translate("Dialog", "10:59:50"))
        self.hexBox.setSortingEnabled(__sortingEnabled)
        __sortingEnabled = self.hexBox_2.isSortingEnabled()
        self.hexBox_2.setSortingEnabled(False)
        item = self.hexBox_2.item(0)
        item.setText(_translate("Dialog", "26/04/20"))
        self.hexBox_2.setSortingEnabled(__sortingEnabled)


if __name__ == "__main__":
    import sys
    app = QtWidgets.QApplication(sys.argv)
    Dialog = QtWidgets.QDialog()
    ui = Ui_Dialog()
    ui.setupUi(Dialog)
    Dialog.show()
    sys.exit(app.exec_())

