"""Main entrypoint of application"""

from teambuilder.app import app

if __name__ == "__main__":
    app.run_server(debug=True)
