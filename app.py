import sys
from PyQt5.QtWidgets import QApplication, QWidget, QVBoxLayout
from widgets import DateTimeLabel, WorkpackageCombobox, DescriptionTextbox, StartStopButton


class Window(QWidget):
    def __init__(self):
        super().__init__()
        self.layout = QVBoxLayout()

        self.lbl = DateTimeLabel()
        self.cmbox = WorkpackageCombobox()
        self.txt = DescriptionTextbox()
        self.btn = StartStopButton()

        self.layout.addWidget(self.lbl)
        self.layout.addWidget(self.cmbox)
        self.layout.addWidget(self.txt)
        self.layout.addWidget(self.btn)

        self.btn.clicked.connect(self.disable_cmbox)
        self.btn.clicked.connect(self.pass_data)

    def disable_cmbox(self):
        if self.btn.text() == 'Start':
            self.cmbox.setEnabled(True)
        else:
            self.cmbox.setEnabled(False)

    def pass_data(self):
        self.btn.workpackage = self.cmbox.currentText()
        self.btn.description = self.txt.toPlainText()

    def draw(self):
        self.setLayout(self.layout)
        self.show()


if __name__ == '__main__':
    app = QApplication(sys.argv)
    window = Window()
    window.draw()
    app.exec_()
