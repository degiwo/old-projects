"""
Flask Application: run this script to create website and predict endpoint.
"""
import os
from flask import Flask, request, render_template
import numpy as np
import joblib

# Initialize app and model
app = Flask(__name__)
model = joblib.load("models/linear_model.pkl")

# Get version from VERSION file
with open("VERSION", 'r') as version_file:
    __version = version_file.read().strip()


# Routes of app
@app.route("/")
def index():
    return render_template("index.html")


@app.route("/version")
def version():
    return f"Version: v{__version}"


@app.route("/predict", methods=["POST"])
def predict():
    float_features = [float(x) for x in request.form.values()]
    features = [np.array(float_features)]
    prediction = model.predict(features)
    return render_template("index.html", prediction_text=f"The predicted price is {round(prediction[0], 2)}")


if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    app.run(debug=True, host="0.0.0.0", port=port)
