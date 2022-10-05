from flask import Flask, render_template

app = Flask(__name__)


@app.route("/")
@app.route("/home")
def home_page():
    data = [
        {"id": 1, "time": "08:00 - 09:00"},
        {"id": 2, "time": "09:00 - 10:00"},
        {"id": 3, "time": "10:00 - 10:45"}
    ]
    return render_template("home.html", data=data)


@app.route("/about")
def about_page():
    return render_template("about.html", username="me")
