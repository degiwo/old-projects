# req: selenium==2.53.6, Firefox==46.0.1

import pandas as pd
from selenium import webdriver
from selenium.webdriver.firefox.firefox_profile import FirefoxProfile
from selenium.webdriver.support.ui import Select
import pyinputplus as pyip


class API:
    def __init__(self, workpackages, records):
        self.profile = FirefoxProfile()
        self.browser = webdriver.Firefox(firefox_profile=self.profile)

        self.workpackages = workpackages
        self.records = records

    def login(self):
        self.browser.get('http://timesheet.optware.de/timesheet/')

        self.browser.find_element_by_link_text('Anmelden').click()
        self.browser.find_element_by_id('username').send_keys('dwon')

        pw = pyip.inputPassword()
        pw_elem = self.browser.find_element_by_name('password')
        pw_elem.send_keys(pw)
        pw_elem.submit()

    def open_sheet(self):
        self.browser.get('https://timesheet.optware.de/timesheet/'
                         'index.php?PHPSESSID=ud87v73u5v4qrq9vkat7cvqln4&moduleID=301&showDate=today')
        self.browser.find_element_by_xpath('//*[@title="Neuen Eintrag hinzufügen"]').click()

    def choose_workpackage(self, workpackage):
        entries = self.workpackages.loc[self.workpackages['workpackage'] == workpackage].reset_index()
        for i in range(entries.shape[0]):
            if i == 0:
                Select(self.browser.find_element_by_id('ProjectList')).select_by_value(entries['value'][i])
            else:
                pass

    def add_entry(self):
        Select(self.browser.find_element_by_name('timeEndHour')).select_by_value('17')
        self.browser.find_element_by_id('Submit').click()

    def logout(self):
        self.browser.quit()


if __name__ == '__main__':
    workpackages = pd.read_csv('data/workpackages.csv', names=['workpackage', 'step', 'value', 'comment'])
    records = pd.read_csv('data/20200616.csv', header=None, names=['start', 'end', 'workpackage', 'description'])

    api = API(workpackages=workpackages, records=records)
    api.login()
    api.open_sheet()
    api.choose_workpackage('Operative Leitung')
    api.add_entry()

    api.logout()
