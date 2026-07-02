#!/usr/bin/env python3
"""
Download Tesseract OCR installer for Windows
"""

import os
import sys
import requests
import time

def download_file(url, destination):
    """Download a file from a URL with progress reporting"""
    try:
        print(f"Downloading from: {url}")
        print(f"Saving to: {destination}")
        
        response = requests.get(url, stream=True)
        response.raise_for_status()
        
        total_size = int(response.headers.get('content-length', 0))
        block_size = 1024  # 1 Kibibyte
        downloaded = 0
        
        start_time = time.time()
        with open(destination, 'wb') as file:
            for data in response.iter_content(block_size):
                downloaded += len(data)
                file.write(data)
                
                # Calculate progress and speed
                percent = int(100 * downloaded / total_size) if total_size > 0 else 0
                elapsed = time.time() - start_time
                speed = downloaded / elapsed if elapsed > 0 else 0
                
                # Calculate estimated time remaining
                if speed > 0 and total_size > 0:
                    eta = (total_size - downloaded) / speed
                    eta_str = f"ETA: {int(eta // 60)}m {int(eta % 60)}s"
                else:
                    eta_str = "ETA: calculating..."
                
                # Display progress
                bar_length = 30
                filled_length = int(bar_length * percent // 100)
                bar = '█' * filled_length + '░' * (bar_length - filled_length)
                
                sys.stdout.write(f"\r|{bar}| {percent}% - {downloaded//(1024*1024)}/{total_size//(1024*1024)} MB - {speed//(1024*1024):.1f} MB/s - {eta_str}")
                sys.stdout.flush()
        
        print("\nDownload completed successfully!")
        print(f"File saved to: {os.path.abspath(destination)}")
        return True
    
    except Exception as e:
        print(f"\nError downloading file: {str(e)}")
        return False

def main():
    # URLs for Tesseract OCR installers
    tesseract_url = "https://digi.bib.uni-mannheim.de/tesseract/tesseract-ocr-w64-setup-v5.3.3.20231218.exe"
    
    # Destination file path
    destination = "tesseract-ocr-w64-setup-v5.3.3.20231218.exe"
    
    # Download Tesseract installer
    success = download_file(tesseract_url, destination)
    
    if success:
        print("\n======================================================================")
        print("NEXT STEPS:")
        print("1. Run the downloaded installer: tesseract-ocr-w64-setup-v5.3.3.20231218.exe")
        print("2. During installation:")
        print("   - Select 'Additional language data (download)'")
        print("   - Choose 'French' language")
        print("   - Make sure to check 'Add Tesseract to PATH'")
        print("3. After installation, run the test script: python test_tesseract.py")
        print("======================================================================")
    else:
        print("\nDownload failed. Please try manually downloading Tesseract from:")
        print("https://github.com/UB-Mannheim/tesseract/releases/")

if __name__ == "__main__":
    main()
