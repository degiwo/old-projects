import csv

def write_log(string_list):
    with open("results.csv", "a", newline="") as file:
        writer = csv.writer(file, delimiter=",")
        writer.writerow(string_list)
