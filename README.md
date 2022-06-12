# todoapp

A Todo-App via Command Line Interface (CLI).

## Set up development environment

This project is set up with [Visual Studio Code](https://code.visualstudio.com/) and [poetry](https://python-poetry.org/). To start developing in the intended environment, run

    cd path/to/project
    poetry shell
    code .

## Usage
### Initialize todo list
    python -m todoapp init
### Add a todo task
    python -m todoapp add <task description>
### List all todos
    python -m todoapp list
### Mark a todo task as complete
    python -m todoapp complete <task ID>
### Remove a todo task from the list
    python -m todoapp remove <task ID>
