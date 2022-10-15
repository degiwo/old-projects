from os import path

from flask import Flask
from flask_login import LoginManager
from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()
BASE_DIR = path.abspath(path.dirname(__file__))
DB_NAME = "database.db"


def create_app():
    app = Flask(__name__)
    app.config["SECRET_KEY"] = "We have to store it somewhere else"
    app.config["SQLALCHEMY_DATABASE_URI"] = f"sqlite:///{path.join(BASE_DIR, DB_NAME)}"
    db.init_app(app)

    from .auth import auth
    from .views import views

    app.register_blueprint(auth, url_prefix="/")
    app.register_blueprint(views, url_prefix="/")

    from .models import Note, Result, User

    create_database(app)

    login_manager = LoginManager()
    login_manager.login_view = "auth.login"
    login_manager.init_app(app)

    @login_manager.user_loader
    def load_user(id):
        return User.query.get(int(id))

    return app


def create_database(app):
    if not path.exists("learn_flask/" + DB_NAME):
        with app.app_context():
            db.create_all()
            print("Database created successfully!")
