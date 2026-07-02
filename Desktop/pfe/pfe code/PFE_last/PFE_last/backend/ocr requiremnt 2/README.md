# Tesseract OCR Setup for Invoice and Quote Processing

This document explains how to set up Tesseract OCR for French invoice and quote processing.

## Prerequisites

1. Python 3.10 (already installed)
2. Tesseract OCR engine

## Installation Steps

### 1. Install Tesseract OCR

1. Download the Tesseract installer for Windows:
   - Go to https://github.com/UB-Mannheim/tesseract/wiki
   - Download the latest version (64-bit recommended)
   - Current recommended version: `tesseract-ocr-w64-setup-v5.3.1.20230401.exe`

2. Run the installer with these settings:
   - Install the French language data files when prompted
   - Add Tesseract to the PATH
   - Default install location is: `C:\Program Files\Tesseract-OCR`

### 2. Install Python Dependencies

Run the following command from this directory:

```bash
pip install -r requirements.txt
```

## Testing the Installation

To verify Tesseract is properly installed:

1. Open a command prompt
2. Run: `tesseract --version`
3. You should see version information, not "command not found"

## Using the Tesseract OCR Engine

Two ways to use the new Tesseract OCR:

1. **API Endpoint with Query Parameter**:
   - When calling the OCR endpoint, add `?engine=tesseract` to use Tesseract instead of EasyOCR.
   - Example: `POST /api/ocr/extract?engine=tesseract`

2. **Command Line**:
   - Run directly: `python tesseract_ocr.py path/to/your/invoice.pdf`
   - Optional flags: 
     - `--output /path/to/output/dir` to specify output directory
     - `--type invoice` or `--type quote` to specify document type (default: auto-detect)

## Comparison with EasyOCR

- **Performance**: Tesseract typically runs faster than EasyOCR, especially on CPU-only systems
- **Memory Usage**: Tesseract uses less memory than EasyOCR
- **Language Support**: Both support French
- **Structured Data**: The Tesseract implementation includes specialized regex patterns for French invoices and quotes

Unlike EasyOCR (which had CUDA timeout issues), Tesseract works entirely on CPU and doesn't require GPU support.
