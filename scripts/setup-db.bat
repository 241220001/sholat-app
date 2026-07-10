@echo off
REM =============================================================================
REM Database Setup Script for Tuntunan Sholat App (Windows)
REM Automates MySQL database creation, schema import, and data seeding
REM Usage: setup-db.bat [mysql_user] [mysql_password]
REM =============================================================================

setlocal enabledelayedexpansion

REM Configuration
set MYSQL_USER=%1
set MYSQL_PASS=%2
set DB_NAME=tuntunan_sholat
set SCRIPT_DIR=%~dp0
set SCHEMA_FILE=%SCRIPT_DIR%database\schema.sql
set SEED_FILE=%SCRIPT_DIR%database\seed.sql

if "%MYSQL_USER%"=="" set MYSQL_USER=root
if "%MYSQL_PASS%"=="" set MYSQL_PASS=

REM Print header
echo ==========================================
echo Database Setup Script
echo ==========================================
echo Database: %DB_NAME%
echo User: %MYSQL_USER%
echo Time: %date% %time%
echo ==========================================
echo.

REM Check if MySQL is accessible
echo [1/5] Checking MySQL connection...
mysql -u%MYSQL_USER% -p%MYSQL_PASS% -e "SELECT 1" >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [PASS] MySQL connection successful
) else (
    echo [FAIL] Cannot connect to MySQL
    echo Please check:
    echo   - MySQL service is running in XAMPP Control Panel
    echo   - Username and password are correct
    echo   - Run: setup-db.bat [username] [password]
    exit /b 1
)

REM Check if database files exist
echo.
echo [2/5] Checking database files...
if not exist "%SCHEMA_FILE%" (
    echo [FAIL] Schema file not found: %SCHEMA_FILE%
    exit /b 1
)
if not exist "%SEED_FILE%" (
    echo [FAIL] Seed file not found: %SEED_FILE%
    exit /b 1
)
echo [PASS] Database files found

REM Create database
echo.
echo [3/5] Creating database...
(
    echo DROP DATABASE IF EXISTS %DB_NAME%;
    echo CREATE DATABASE %DB_NAME% CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
) | mysql -u%MYSQL_USER% -p%MYSQL_PASS%

if %ERRORLEVEL% EQU 0 (
    echo [PASS] Database '%DB_NAME%' created
) else (
    echo [FAIL] Failed to create database
    exit /b 1
)

REM Import schema
echo.
echo [4/5] Importing schema...
mysql -u%MYSQL_USER% -p%MYSQL_PASS% %DB_NAME% < "%SCHEMA_FILE%"

if %ERRORLEVEL% EQU 0 (
    echo [PASS] Schema imported successfully
    echo.
    echo Tables created:
    mysql -u%MYSQL_USER% -p%MYSQL_PASS% %DB_NAME% -e "SHOW TABLES;" --skip-column-names | findstr /V "Tables_in_"
) else (
    echo [FAIL] Failed to import schema
    exit /b 1
)

REM Import seed data
echo.
echo [5/5] Importing seed data...
mysql -u%MYSQL_USER% -p%MYSQL_PASS% %DB_NAME% < "%SEED_FILE%"

if %ERRORLEVEL% EQU 0 (
    echo [PASS] Seed data imported successfully
    echo.
    echo Record counts:
    (
        echo SELECT 'kategori' as TableName, COUNT^(*^) as Rows FROM kategori
        echo UNION ALL SELECT 'kelompok', COUNT^(*^) FROM kelompok
        echo UNION ALL SELECT 'gerakan', COUNT^(*^) FROM gerakan
        echo UNION ALL SELECT 'bacaan', COUNT^(*^) FROM bacaan;
    ) | mysql -u%MYSQL_USER% -p%MYSQL_PASS% %DB_NAME% --skip-column-names
) else (
    echo [FAIL] Failed to import seed data
    exit /b 1
)

REM Verify setup
echo.
echo Verifying setup...
for /f %%i in ('mysql -u%MYSQL_USER% -p%MYSQL_PASS% %DB_NAME% -N -e "SELECT COUNT(*) FROM gerakan WHERE id_kategori=1"') do set GERAKAN_COUNT=%%i

if "%GERAKAN_COUNT%"=="13" (
    echo [PASS] Setup verified ^(13 gerakan for dewasa mode^)
) else (
    echo [WARN] Warning: Expected 13 gerakan, found %GERAKAN_COUNT%
)

REM Check .env file
echo.
echo Checking .env configuration...
set ENV_FILE=%SCRIPT_DIR%.env

if exist "%ENV_FILE%" (
    findstr /C:"DB_NAME=%DB_NAME%" "%ENV_FILE%" >nul
    if !ERRORLEVEL! EQU 0 (
        echo [PASS] .env file already configured correctly
    ) else (
        echo [WARN] .env DB_NAME doesn't match %DB_NAME%
        echo   Please update .env file manually
    )
) else (
    echo [WARN] .env file not found
    if exist "%SCRIPT_DIR%.env.example" (
        echo   Creating from .env.example...
        copy "%SCRIPT_DIR%.env.example" "%ENV_FILE%" >nul
        echo [PASS] .env file created
        echo   Please review and update DB_USER and DB_PASS if needed
    ) else (
        echo [FAIL] .env.example not found
        echo   Please create .env manually
    )
)

REM Print success summary
echo.
echo ==========================================
echo [SUCCESS] Database Setup Complete!
echo ==========================================
echo.
echo Next steps:
echo   1. Start Apache in XAMPP Control Panel
echo   2. Test API: http://localhost/sholat-app/backend/api/health.php
echo   3. Open frontend: http://localhost/sholat-app/
echo.
echo Database credentials:
echo   Host: localhost
echo   Database: %DB_NAME%
echo   User: %MYSQL_USER%
echo   Charset: utf8mb4
echo.

endlocal
exit /b 0
