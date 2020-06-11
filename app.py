import sys
from PyQt5.QtWidgets import QApplication, QWidget, QVBoxLayout
from widgets import DateTimeLabel, WorkpackageCombobox, StartButton


class Window(QWidget):
    def __init__(self):
        super().__init__()
        self.layout = QVBoxLayout()

        self.layout.addWidget(DateTimeLabel())
        self.layout.addWidget(WorkpackageCombobox())
        self.layout.addWidget(StartButton())

    def draw(self):
        self.setLayout(self.layout)
        self.show()


if __name__ == '__main__':
    app = QApplication(sys.argv)
    window = Window()
    window.draw()
    app.exec_()
