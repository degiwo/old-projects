from flask import Flask

def create_app():
    flask_app = Flask("ml_api")

    from api.controller import prediction_app
    flask_app.register_blueprint(prediction_app)

    return flask_app
