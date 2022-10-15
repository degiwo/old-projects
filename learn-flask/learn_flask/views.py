import json

from flask import Blueprint, flash, jsonify, render_template, request
from flask_login import current_user, login_required

from . import db
from .models import Note, Result

views = Blueprint("views", __name__)


@views.route("/", methods=["GET", "POST"])
@login_required
def home():
    if request.method == "POST":
        note = request.form.get("note")

        if len(note) < 1:
            flash("Note is too short!", category="error")
        else:
            new_note = Note(text=note, user_id=current_user.id)
            db.session.add(new_note)
            db.session.commit()
            flash("Note added!", category="success")
    return render_template("home.html", user=current_user)


@views.route("/results", methods=["GET", "POST"])
@login_required
def results():
    if request.method == "POST":
        player1 = request.form.get("player1")
        frame1 = request.form.get("frame1")
        player2 = request.form.get("player2")
        frame2 = request.form.get("frame2")
        new_result = Result(
            player=player1, frame=f"{frame1}-{frame2}", opponent=player2)
        db.session.add(new_result)
        db.session.commit()
        flash("Result added!", category="success")
    return render_template("results.html", user=current_user, results=Result.query.all())


@views.app_errorhandler(404)
def page_not_found(e):
    return render_template("404.html", user=current_user), 404


@views.route("/delete-note", methods=["POST"])
def delete_note():
    data = json.loads(request.data)
    noteId = data["noteId"]
    note = Note.query.get(noteId)
    if note:
        if note.user_id == current_user.id:
            db.session.delete(note)
            db.session.commit()

    return jsonify({})
