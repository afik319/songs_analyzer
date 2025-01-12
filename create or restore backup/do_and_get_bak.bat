@echo off
set PATH=C:\Program Files\Docker\Docker\resources\bin;%PATH%
setlocal enabledelayedexpansion

REM הגדרת משתנים
set CONTAINER_NAME=sqlserver_container
set BACKUP_FILE_PATH=/tmp/DB.bak
set LOCAL_BACKUP_DIR=%~dp0
set BACKUP_FILE_NAME=DB.bak
set SA_PASSWORD=YourStrongPass123
set ZIP_NAME=songs_backup.zip
set SOURCE_DIR=%~dp0..\static\songs

REM שלב: התחברות כ-root ומחיקת קובץ הגיבוי
echo Connecting as root and deleting the backup file...
docker exec --user root %CONTAINER_NAME% bash -c "rm -f %BACKUP_FILE_PATH%"
timeout /t 1 /nobreak > nul
if %ERRORLEVEL% neq 0 (
    echo Failed to delete the backup file in the container.
    exit /b
)
echo Backup file deleted successfully.

REM שלב 1: יצירת גיבוי של מסד הנתונים בקונטיינר
echo Backing up the database in container %CONTAINER_NAME%...
docker exec --user root -i %CONTAINER_NAME% /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "%SA_PASSWORD%" -Q ^
"BACKUP DATABASE songs TO DISK = '%BACKUP_FILE_PATH%' WITH FORMAT, NAME = 'Full Backup of songs';"
if %ERRORLEVEL% neq 0 (
    echo Failed to back up the database.
    exit /b
)
echo Database backup completed successfully.

REM שלב 2: העתקת קובץ הגיבוי מהקונטיינר למחשב המקומי
echo Copying backup file to local directory...
docker cp %CONTAINER_NAME%:%BACKUP_FILE_PATH% "%LOCAL_BACKUP_DIR%\%BACKUP_FILE_NAME%"
if %ERRORLEVEL% neq 0 (
    echo Failed to copy backup file.
    exit /b
)
echo Backup file copied successfully to %LOCAL_BACKUP_DIR%.

REM שלב נוסף: כיווץ התיקייה static\songs לקובץ ZIP והעברה לתיקייה הנוכחית
echo Compressing the directory ../static/songs into a ZIP file...
powershell -Command "Add-Type -AssemblyName System.IO.Compression.FileSystem; [IO.Compression.ZipFile]::CreateFromDirectory('%SOURCE_DIR%', '%LOCAL_BACKUP_DIR%\%ZIP_NAME%')"
if %ERRORLEVEL% neq 0 (
    echo Failed to create ZIP file.
    exit /b
)
echo ZIP file created successfully: %ZIP_NAME%.

pause