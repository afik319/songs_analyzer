@echo off
set PATH=C:\Program Files\Docker\Docker\resources\bin;%PATH%
setlocal enabledelayedexpansion

REM הגדרת משתנים
set IMAGE_NAME=afik319/mssql-songs-db
set NEW_CONT_NAME=sqlserver_container
set PORT=1433

REM שלב 1: הרצת קונטיינר חדש
echo Creating new container from the image %IMAGE_NAME%...
docker run -d --name %NEW_CONT_NAME% -p %PORT%:1433 -v songs_volume:/var/opt/mssql %IMAGE_NAME%
if %ERRORLEVEL% neq 0 (
    echo Failed to create container.
    exit /b
)
echo New container created successfully.

echo Database restored successfully!
echo All tasks completed successfully!