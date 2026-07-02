# Tesseract OCR Installation Instructions

## Manual Download and Installation

Since the direct download is not working, please follow these steps to install Tesseract OCR:

1. **Download Tesseract OCR for Windows**:
   - Visit the official GitHub repository: https://github.com/UB-Mannheim/tesseract/releases
   - Download the latest version (v5.4.0.20240606) - look for `tesseract-ocr-w64-setup-5.4.0.20240606.exe` (47.9 MB)

2. **Install Tesseract**:
   - Run the downloaded installer
   - **Important**: When prompted, make sure to:
     - Select "Additional language data (download)"
     - Check the "French" language option
     - **Check "Add Tesseract to PATH"** (extremely important)
   - Complete the installation

3. **Verify Installation**:
   - Open a new Command Prompt or PowerShell window (important to open a new window)
   - Run: `tesseract --version`
   - If you see version information, Tesseract is installed correctly
   - Run: `tesseract --list-langs` to confirm French (fra) is available

## Already Installed Python Requirements

The following Python packages have already been installed:
- pytesseract==0.3.10
- pdf2image==1.16.3
- opencv-python==4.8.0.74
- numpy==1.24.3
- Pillow==10.0.0
- scikit-image==0.21.0

## Testing the Installation

After installing Tesseract:

1. Open a new command prompt
2. Navigate to this directory
3. Run: `python test_tesseract.py`

If everything is working correctly, you'll see confirmation messages.

## Using Tesseract OCR with Your Application

Once installed, you can use the Tesseract-based OCR system by calling your API endpoint with:
```
POST /api/ocr/extract?engine=tesseract
```

This will use the CPU-based Tesseract OCR engine instead of EasyOCR, which should avoid the CUDA timeout issues you were experiencing with your NVIDIA GeForce MX110 GPU.
