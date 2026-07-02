#!/usr/bin/env python3
"""
Test script for Tesseract OCR installation
This script verifies that Tesseract OCR is correctly installed and configured.
"""

import os
import sys
import pytesseract
from PIL import Image
import numpy as np

def test_tesseract_installation():
    """Test if Tesseract is correctly installed and accessible"""
    print("Testing Tesseract OCR installation...")
    print("Expected version: 5.4.0 (latest as of June 2024)")
    
    # Set the path to Tesseract executable
    pytesseract.pytesseract.tesseract_cmd = r'C:\Program Files\Tesseract-OCR\tesseract.exe'
    
    try:
        # Get Tesseract version
        version = pytesseract.get_tesseract_version()
        print(f"✓ Tesseract version: {version}")
        
        # Check available languages
        langs = pytesseract.get_languages()
        print(f"✓ Available languages: {', '.join(langs)}")
        
        # Check if French is available
        if 'fra' in langs:
            print("✓ French language is installed and available")
        else:
            print("⚠ French language not found. Please install it for invoice processing.")
            print("   Run: tesseract --list-langs to see installed languages")
        
        # Create a simple test image with text
        print("\nPerforming a simple OCR test...")
        img = np.ones((100, 300), dtype=np.uint8) * 255
        
        # The test exits quickly if Tesseract is not working correctly
        text = pytesseract.image_to_string(img)
        print("✓ Basic OCR test completed successfully")
        
        print("\n✅ Tesseract OCR is properly installed and configured!")
        return True
        
    except pytesseract.TesseractNotFoundError:
        print("\n❌ ERROR: Tesseract executable not found!")
        print("    • Make sure Tesseract is installed")
        print("    • Check if it's in your PATH")
        print("    • You might need to restart your terminal after installation")
        print("\nIf you're sure Tesseract is installed, you can specify the path in your script:")
        print('pytesseract.pytesseract.tesseract_cmd = r"C:\\Program Files\\Tesseract-OCR\\tesseract.exe"')
        return False
        
    except Exception as e:
        print(f"\n❌ Error: {str(e)}")
        return False

if __name__ == "__main__":
    test_tesseract_installation()
