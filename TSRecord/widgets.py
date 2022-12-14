from PyQt5.QtWidgets import QLabel, QComboBox, QPushButton, QTextEdit
from PyQt5.QtCore import QTimer, QDateTime, QDate
from data import TimesheetData, RecordData


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
        self.lst = TimesheetData().lst_workpackages
        self.addItems(self.lst)


class DescriptionTextbox(QTextEdit):
    def __init__(self):
        super().__init__()
        self.setReadOnly(False)


class StartStopButton(QPushButton):
    def __init__(self):
        super().__init__('Start')
        self.record_data = RecordData(QDate.currentDate())

        self.starttime = None
        self.workpackage = None
        self.description = None

        # order is important!
        self.clicked.connect(self.save_record)
        self.clicked.connect(self.set_text)

    def set_text(self):
        if self.text() == 'Start':
            self.setText('Stop')
        else:
            self.setText('Start')

    def save_record(self):
        if self.text() == 'Start':
            self.starttime = QDateTime.currentDateTime().toString('dd.MM.yyyy hh:mm')
        else:
            new_record = {'starttime': [self.starttime],
                          'endtime': [QDateTime.currentDateTime().toString('dd.MM.yyyy hh:mm')],
                          'workpackage': [self.workpackage],
                          'description': [self.description]}
            self.record_data.log_record(new_record)
