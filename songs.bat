@echo off

REM הפעלת app.py בחלון נפרד
start cmd /c "call venv\Scripts\activate && python app.py"

REM המתנה לעליית השרת
echo Waiting for the server to start...
:CHECK_SERVER
curl -s http://127.0.0.1:5000 >nul 2>&1
if %errorlevel% neq 0 (
    timeout /t 1 >nul
    goto CHECK_SERVER
)

REM השרת פעיל, פתח את Chrome
echo Server is running! Opening browser...
start chrome http://127.0.0.1:5000

exit
