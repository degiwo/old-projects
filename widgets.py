from PyQt5.QtWidgets import QLabel
from PyQt5.QtCore import QTimer, QDateTime


class DateTimeLabel(QLabel):
    def __init__(self, parent):
        super().__init__()
        self.timer = QTimer(parent)
        self.timer.timeout.connect(self.update_time)
        self.timer.start(1000)
        self.update_time()

    def update_time(self):
        self.setText(QDateTime.currentDateTime().toString())
