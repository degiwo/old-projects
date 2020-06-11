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


class StartStopButton(QPushButton):
    def __init__(self):
        super().__init__('Start')
        self.clicked.connect(self.set_text)
        self.clicked.connect(self.get_time)

    def set_text(self):
        if self.text() == 'Start':
            self.setText('Stop')
        else:
            self.setText('Start')

    def get_time(self):
        if self.text() == 'Start':
            txt = 'Endtime:'
        else:
            txt = 'Starttime:'
        print(txt, QDateTime.currentDateTime().toString())