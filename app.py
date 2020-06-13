import sys
from PyQt5.QtWidgets import QApplication, QWidget, QVBoxLayout
from widgets import DateTimeLabel, WorkpackageCombobox, StartStopButton


class Window(QWidget):
    def __init__(self):
        super().__init__()
        self.layout = QVBoxLayout()

        self.lbl = DateTimeLabel()
        self.cmbox = WorkpackageCombobox()
        self.btn = StartStopButton()

        self.layout.addWidget(self.lbl)
        self.layout.addWidget(self.cmbox)
        self.layout.addWidget(self.btn)

        self.btn.clicked.connect(self.disable_cmbox)
        self.btn.clicked.connect(self.pass_workpackage)

    def disable_cmbox(self):
        if self.btn.text() == 'Start':
            self.cmbox.setEnabled(True)
        else:
            self.cmbox.setEnabled(False)

    def pass_workpackage(self):
        self.btn.workpackage = self.cmbox.currentText()

    def draw(self):
        self.setLayout(self.layout)
        self.show()


if __name__ == '__main__':
    app = QApplication(sys.argv)
    window = Window()
    window.draw()
    app.exec_()
