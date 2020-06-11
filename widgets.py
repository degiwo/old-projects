from PyQt5.QtWidgets import QLabel, QComboBox, QPushButton
from PyQt5.QtCore import QTimer, QDateTime


class DateTimeLabel(QLabel):
    def __init__(self):
        super().__init__()
        self.timer = QTimer()
        self.timer.timeout.connect(self.update_time)
        self.timer.start(1000)
        self.update_time()

    def update_time(self):
        self.setText(QDateTime.currentDateTime().toString())


class WorkpackageCombobox(QComboBox):
    def __init__(self):
        super().__init__()
        self.addItems(['AP1', 'AP2'])

class StartButton(QPushButton):
    def __init__(self):
        super().__init__('Start')
        self.clicked.connect(self.set_start)

    def set_start(self):
        print(QDateTime.currentDateTime().toString())