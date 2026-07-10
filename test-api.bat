@echo off
REM =============================================================================
REM Backend API Test Suite (Windows)
REM Tests all 9 endpoints for sholat-app backend
REM Usage: test-api.bat [base_url]
REM =============================================================================

setlocal enabledelayedexpansion

REM Configuration
if "%1"=="" (
    set BASE_URL=http://localhost/sholat-app/backend/api
) else (
    set BASE_URL=%1
)

set FAILED_TESTS=0
set PASSED_TESTS=0

echo ==========================================
echo Backend API Test Suite
echo ==========================================
echo Base URL: %BASE_URL%
echo Time: %date% %time%
echo ==========================================
echo.

REM Test 1: Health Check
echo [TEST] Health Check
curl -s "%BASE_URL%/health.php" | findstr /C:"\"status\":\"success\"" >nul
if %ERRORLEVEL% EQU 0 (
    echo [PASS] Health Check
    set /a PASSED_TESTS+=1
) else (
    echo [FAIL] Health Check
    set /a FAILED_TESTS+=1
)

REM Test 2: Kelompok Info
echo.
echo [TEST] Kelompok Info
curl -s "%BASE_URL%/kelompok.php" | findstr /C:"\"nama_kelompok\"" >nul
if %ERRORLEVEL% EQU 0 (
    echo [PASS] Kelompok Info
    set /a PASSED_TESTS+=1
) else (
    echo [FAIL] Kelompok Info
    set /a FAILED_TESTS+=1
)

REM Test 3: List Gerakan (Dewasa)
echo.
echo [TEST] List Gerakan (Dewasa^)
curl -s "%BASE_URL%/gerakan.php?kategori=dewasa" | findstr /C:"\"urutan\":1" >nul
if %ERRORLEVEL% EQU 0 (
    echo [PASS] List Gerakan (Dewasa^)
    set /a PASSED_TESTS+=1
) else (
    echo [FAIL] List Gerakan (Dewasa^)
    set /a FAILED_TESTS+=1
)

REM Test 4: List Gerakan (Anak)
echo.
echo [TEST] List Gerakan (Anak^)
curl -s "%BASE_URL%/gerakan.php?kategori=anak" | findstr /C:"\"urutan\":1" >nul
if %ERRORLEVEL% EQU 0 (
    echo [PASS] List Gerakan (Anak^)
    set /a PASSED_TESTS+=1
) else (
    echo [FAIL] List Gerakan (Anak^)
    set /a FAILED_TESTS+=1
)

REM Test 5: Detail Gerakan
echo.
echo [TEST] Detail Gerakan (ID=1^)
curl -s "%BASE_URL%/gerakan.php?id=1" | findstr /C:"\"id_kategori\"" >nul
if %ERRORLEVEL% EQU 0 (
    echo [PASS] Detail Gerakan (ID=1^)
    set /a PASSED_TESTS+=1
) else (
    echo [FAIL] Detail Gerakan (ID=1^)
    set /a FAILED_TESTS+=1
)

REM Test 6: Next Gerakan
echo.
echo [TEST] Next Gerakan
curl -s "%BASE_URL%/gerakan.php?next&id_kategori=1&urutan=1" | findstr /C:"\"urutan\":2" >nul
if %ERRORLEVEL% EQU 0 (
    echo [PASS] Next Gerakan
    set /a PASSED_TESTS+=1
) else (
    echo [FAIL] Next Gerakan
    set /a FAILED_TESTS+=1
)

REM Test 7: Previous Gerakan
echo.
echo [TEST] Previous Gerakan
curl -s "%BASE_URL%/gerakan.php?prev&id_kategori=1&urutan=2" | findstr /C:"\"urutan\":1" >nul
if %ERRORLEVEL% EQU 0 (
    echo [PASS] Previous Gerakan
    set /a PASSED_TESTS+=1
) else (
    echo [FAIL] Previous Gerakan
    set /a FAILED_TESTS+=1
)

REM Test 8: Total Gerakan
echo.
echo [TEST] Total Gerakan
curl -s "%BASE_URL%/gerakan.php?total&kategori=dewasa" | findstr /C:"\"total_gerakan\":13" >nul
if %ERRORLEVEL% EQU 0 (
    echo [PASS] Total Gerakan
    set /a PASSED_TESTS+=1
) else (
    echo [FAIL] Total Gerakan
    set /a FAILED_TESTS+=1
)

REM Test 9: Autoplay Data
echo.
echo [TEST] Autoplay Data
curl -s "%BASE_URL%/gerakan.php?autoplay&kategori=dewasa" | findstr /C:"\"bacaan\"" >nul
if %ERRORLEVEL% EQU 0 (
    echo [PASS] Autoplay Data
    set /a PASSED_TESTS+=1
) else (
    echo [FAIL] Autoplay Data
    set /a FAILED_TESTS+=1
)

REM Test 10: Bacaan by Gerakan
echo.
echo [TEST] Bacaan for Gerakan 2
curl -s "%BASE_URL%/bacaan.php?id_gerakan=2" | findstr /C:"\"teks_arab\"" >nul
if %ERRORLEVEL% EQU 0 (
    echo [PASS] Bacaan for Gerakan 2
    set /a PASSED_TESTS+=1
) else (
    echo [FAIL] Bacaan for Gerakan 2
    set /a FAILED_TESTS+=1
)

REM Error handling tests
echo.
echo ==========================================
echo Error Handling Tests
echo ==========================================
echo.

REM Test 11: Missing kategori
echo [TEST] Error: Missing kategori
curl -s "%BASE_URL%/gerakan.php" | findstr /C:"\"code\":\"INVALID_KATEGORI\"" >nul
if %ERRORLEVEL% EQU 0 (
    echo [PASS] Error: Missing kategori
    set /a PASSED_TESTS+=1
) else (
    echo [FAIL] Error: Missing kategori
    set /a FAILED_TESTS+=1
)

REM Test 12: Invalid kategori
echo.
echo [TEST] Error: Invalid kategori
curl -s "%BASE_URL%/gerakan.php?kategori=invalid" | findstr /C:"\"code\":\"INVALID_KATEGORI\"" >nul
if %ERRORLEVEL% EQU 0 (
    echo [PASS] Error: Invalid kategori
    set /a PASSED_TESTS+=1
) else (
    echo [FAIL] Error: Invalid kategori
    set /a FAILED_TESTS+=1
)

REM Test 13: Invalid ID
echo.
echo [TEST] Error: Invalid ID
curl -s "%BASE_URL%/gerakan.php?id=abc" | findstr /C:"\"code\":\"INVALID_ID\"" >nul
if %ERRORLEVEL% EQU 0 (
    echo [PASS] Error: Invalid ID
    set /a PASSED_TESTS+=1
) else (
    echo [FAIL] Error: Invalid ID
    set /a FAILED_TESTS+=1
)

REM Print summary
echo.
echo ==========================================
echo Test Summary
echo ==========================================
echo Passed: %PASSED_TESTS%
echo Failed: %FAILED_TESTS%
set /a TOTAL_TESTS=PASSED_TESTS+FAILED_TESTS
echo Total:  %TOTAL_TESTS%
echo ==========================================

if %FAILED_TESTS% EQU 0 (
    echo All tests passed!
    exit /b 0
) else (
    echo Some tests failed!
    exit /b 1
)
