import sys
from PyQt5.QtWidgets import QApplication, QWidget, QVBoxLayout, QLabel
from PyQt5.QtCore import QTimer, QDateTime


class Window(QWidget):
    def __init__(self):
        super().__init__()
        self.layout = QVBoxLayout()

        self.lbl = QLabel('Test')
        self.layout.addWidget(self.lbl)
        self.timer = QTimer(self)
        self.timer.timeout.connect(self.update_time)
        self.timer.start(1000)
        self.update_time()

    def update_time(self):
        self.lbl.setText(QDateTime.currentDateTime().toString())

    def draw(self):
        self.setLayout(self.layout)
        self.show()


if __name__ == '__main__':
    app = QApplication(sys.argv)
    window = Window()
    window.draw()
    app.exec_()
