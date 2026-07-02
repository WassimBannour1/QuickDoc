@echo off
echo ===============================================================
echo Tesseract OCR Installation Guide
echo ===============================================================
echo.
echo This script will help you install Tesseract OCR for your invoice OCR system.
echo.
echo Please follow these steps:
echo.
echo 1. Download Tesseract OCR for Windows from:
echo    https://github.com/UB-Mannheim/tesseract/wiki
echo    (Recommended version: tesseract-ocr-w64-setup-v5.3.1.20230401.exe)
echo.
echo 2. During installation:
echo    - Select Additional language data (French)
echo    - Make sure to add Tesseract to your PATH
echo.
echo 3. After installation, test if Tesseract is properly installed by:
echo    a. Opening a new command prompt
echo    b. Running: tesseract --version
echo.
echo 4. If you see version information, Tesseract is installed correctly.
echo.
echo ===============================================================
echo Opening the download page in your browser...
echo.
start "" "https://github.com/UB-Mannheim/tesseract/wiki"
echo.
echo After installing Tesseract, let's verify the installation.
echo Press any key when Tesseract installation is complete...
pause
echo.
echo Checking if Tesseract is installed...
where tesseract
if %ERRORLEVEL% EQU 0 (
    echo.
    echo Success! Tesseract OCR is installed and available in your PATH.
    echo.
    tesseract --version
    echo.
    echo Your Tesseract OCR script is ready to use!
    echo You can run it with: python tesseract_ocr.py <file_path>
) else (
    echo.
    echo Tesseract not found in PATH.
    echo.
    echo Please make sure you:
    echo 1. Installed Tesseract OCR correctly
    echo 2. Added Tesseract to your PATH during installation
    echo 3. Restarted your command prompt after installation
    echo.
    echo Try running 'tesseract --version' in a new command prompt.
)
echo.
echo Press any key to exit...
pause
