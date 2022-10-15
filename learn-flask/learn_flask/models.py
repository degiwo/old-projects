from flask_login import UserMixin
from sqlalchemy.sql import func

from . import db


class Note(db.Model):  # type: ignore
    id = db.Column(db.Integer, primary_key=True)
    text = db.Column(db.Text(10000))
    date = db.Column(db.DateTime(timezone=True), default=func.now())
    user_id = db.Column(db.Integer, db.ForeignKey("user.id"))


class User(db.Model, UserMixin):  # type: ignore
    id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.String(150), unique=True)
    password = db.Column(db.String(150))
    notes = db.relationship("Note")


class Result(db.Model):  # type: ignore
    id = db.Column(db.Integer, primary_key=True)
    player = db.Column(db.String(150))
    frame = db.Column(db.String(150))
    opponent = db.Column(db.String(150))
