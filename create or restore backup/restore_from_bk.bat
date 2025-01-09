@echo off
setlocal enabledelayedexpansion

REM הגדרת משתנים
set CONTAINER_NAME=sqlserver_container
set BACKUP_FILE_NAME=DB.bak
set BACKUP_FILE_PATH=/tmp/%BACKUP_FILE_NAME%
set LOCAL_BACKUP_DIR=%~dp0
set ZIP_NAME=songs_backup.zip
set DEST_DIR=%~dp0..\static\songs

REM שלב 1: מחיקת קובץ הגיבוי אם הוא קיים בתוך הקונטיינר
echo Checking if backup file exists in the container and deleting if necessary...
docker exec --user root -i %CONTAINER_NAME% /bin/bash -c "if [ -f '%BACKUP_FILE_PATH%' ]; then rm -f '%BACKUP_FILE_PATH%'; echo 'Existing backup file deleted.'; else echo 'No existing backup file found.'; fi"
if %ERRORLEVEL% neq 0 (
    echo Failed to delete backup file in the container.
    exit /b
)
timeout /t 1 /nobreak >nul
echo Finish waiting

REM שלב 2: העתקת קובץ הגיבוי מהמחשב המקומי לקונטיינר החדש
echo Copying backup file to the new container...
docker cp "%LOCAL_BACKUP_DIR%\%BACKUP_FILE_NAME%" %CONTAINER_NAME%:%BACKUP_FILE_PATH%
if %ERRORLEVEL% neq 0 (
    echo Failed to copy backup file to the new container.
    exit /b
)
echo Backup file copied successfully to /tmp/DB.bak in the new container.

REM שלב 3: שחזור מסד הנתונים מהקובץ DB.bak
echo Restoring the database from backup file...
docker exec --user root -i %CONTAINER_NAME% /opt/mssql-tools/bin/sqlcmd -S localhost,1433 -U SA -P "YourStrongPass123" -Q "USE master; ALTER DATABASE songs SET SINGLE_USER WITH ROLLBACK IMMEDIATE; RESTORE DATABASE songs FROM DISK = '/tmp/DB.bak' WITH REPLACE, MOVE 'songs' TO '/var/opt/mssql/data/songs.mdf', MOVE 'songs_log' TO '/var/opt/mssql/data/songs_log.ldf'; ALTER DATABASE songs SET MULTI_USER;"
if %ERRORLEVEL% neq 0 (
    echo Failed to restore the database.
    exit /b
)
echo Database restored successfully!

REM שלב נוסף: ביטול כיווץ קובץ ZIP והעתקת התוכן לתיקייה static\songs
echo Extracting ZIP file and restoring static\songs directory...
powershell -Command "Expand-Archive -Path '%LOCAL_BACKUP_DIR%\%ZIP_NAME%' -DestinationPath '%DEST_DIR%' -Force"
if %ERRORLEVEL% neq 0 (
    echo Failed to extract ZIP file.
    exit /b
)
echo ZIP file extracted successfully and static\songs directory restored.

echo All tasks completed successfully!
pause
