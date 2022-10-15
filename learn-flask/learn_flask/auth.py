from flask import Blueprint, flash, redirect, render_template, request, url_for
from flask_login import current_user, login_required, login_user, logout_user
from werkzeug.security import check_password_hash, generate_password_hash

from . import db
from .models import User

auth = Blueprint("auth", __name__)


@auth.route("/login", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        email = request.form.get("inputEmail")
        password = request.form.get("inputPassword")

        user = User.query.filter_by(email=email).first()
        if user:
            if check_password_hash(user.password, password):
                flash("Logged in successfully!", category="success")
                login_user(user, remember=True)
                return redirect(url_for("views.home"))
            else:
                flash("Incorrect password, try again.", category="error")
        else:
            flash("Email does not exist.", category="error")
    return render_template("login.html", user=current_user)


@auth.route("/logout")
@login_required
def logout():
    logout_user()
    return redirect(url_for("auth.login"))


@auth.route("/sign-up", methods=["GET", "POST"])
def sign_up():
    if request.method == "POST":
        email = request.form.get("inputEmail")
        password1 = request.form.get("inputPassword1")
        password2 = request.form.get("inputPassword2")

        user = User.query.filter_by(email=email).first()

        if user:
            flash("Email already exists.", category="error")
        elif len(email) < 1:
            flash("Please enter a valid Email adress.", category="error")
        elif len(password1) < 6:
            flash("Password must be at least 6 characters.", category="error")
        elif password1 != password2:
            flash("Passwords do not match.", category="error")
        else:
            new_user = User(
                email=email, password=generate_password_hash(
                    password1, method="sha256")
            )
            db.session.add(new_user)
            db.session.commit()
            login_user(user, remember=True)
            flash("Account created!", category="success")
            return redirect(url_for("views.home"))

    return render_template("sign_up.html", user=current_user)
