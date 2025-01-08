@echo off
start cmd /c "call venv\Scripts\activate && python app.py"
start chrome http://127.0.0.1:5000
exit