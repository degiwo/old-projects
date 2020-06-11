import pandas as pd


class TimesheetData:
    def __init__(self):
        self.df_workpackages = pd.read_csv('data/workpackages.csv')
        self.lst_workpackages = self.df_workpackages['workpackage'].unique()


class RecordData:
    def __init__(self, date):
        self.date = date
        self.records = pd.DataFrame(columns=['starttime', 'endtime', 'workpackage'])
