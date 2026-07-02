#!/usr/bin/env python3
"""
Tesseract OCR Extraction Script
This script processes images and PDF files to extract text from invoices and quotes using Tesseract OCR.
Optimized for French language documents, particularly invoices (factures) and quotes (devis).
Usage: python tesseract_ocr.py <file_path>
"""

import os
import sys
import cv2
import numpy as np
import pytesseract
import time
import argparse
import logging
import json
import re
import tempfile
from pdf2image import convert_from_path
from PIL import Image
from pathlib import Path
from skimage import filters, morphology

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

# Set CPU optimization environment variables
os.environ['OMP_NUM_THREADS'] = '4'  # Use 4 threads for OpenMP
os.environ['MKL_NUM_THREADS'] = '4'  # Intel Math Kernel Library optimization
os.environ['NUMEXPR_NUM_THREADS'] = '4'  # NumExpr optimization
os.environ['OPENBLAS_NUM_THREADS'] = '4'  # OpenBLAS optimization

# Set path to Tesseract executable
pytesseract.pytesseract.tesseract_cmd = r'C:\Program Files\Tesseract-OCR\tesseract.exe'  # Standard installation path

# Process optimization constants
MAX_IMAGE_DIMENSION = 3000  # Maximum dimension for image processing
DPI = 300  # DPI for PDF conversion

# Regular expressions for French invoices and quotes
INVOICE_PATTERNS = {
    'invoice_number': r'(?i)(?:facture|fact)[^\d]*(\d+[-/\w]*)',
    'invoice_date': r'(?i)(?:date|du)[^:]*?:\s*(\d{1,2}[/-]\d{1,2}[/-]\d{2,4}|\d{1,2}\s+(?:janvier|février|mars|avril|mai|juin|juillet|août|septembre|octobre|novembre|décembre)\s+\d{2,4})',
    'total_amount': r'(?i)(?:total|montant|net à payer)[^:]*?:\s*(?:EUR|€|\$)?\s*([0-9\s,.]+)(?:\s*(?:EUR|€|\$))?',
    'tax_amount': r'(?i)(?:tva|taxe)[^:]*?:\s*(?:EUR|€|\$)?\s*([0-9\s,.]+)(?:\s*(?:EUR|€|\$))?',
    'client_name': r'(?i)(?:client|destinataire)[^:]*?:\s*([A-Za-z\s.]+)',
    'payment_due': r'(?i)(?:échéance|date d\'échéance)[^:]*?:\s*(\d{1,2}[/-]\d{1,2}[/-]\d{2,4}|\d{1,2}\s+(?:janvier|février|mars|avril|mai|juin|juillet|août|septembre|octobre|novembre|décembre)\s+\d{2,4})',
}

QUOTE_PATTERNS = {
    'quote_number': r'(?i)(?:devis|ref)[^\d]*(\d+[-/\w]*)',
    'quote_date': r'(?i)(?:date|du)[^:]*?:\s*(\d{1,2}[/-]\d{1,2}[/-]\d{2,4}|\d{1,2}\s+(?:janvier|février|mars|avril|mai|juin|juillet|août|septembre|octobre|novembre|décembre)\s+\d{2,4})',
    'valid_until': r'(?i)(?:valable jusqu\'au|validité)[^:]*?:\s*(\d{1,2}[/-]\d{1,2}[/-]\d{2,4}|\d{1,2}\s+(?:janvier|février|mars|avril|mai|juin|juillet|août|septembre|octobre|novembre|décembre)\s+\d{2,4})',
    'total_amount': r'(?i)(?:total|montant)[^:]*?:\s*(?:EUR|€|\$)?\s*([0-9\s,.]+)(?:\s*(?:EUR|€|\$))?',
    'client_name': r'(?i)(?:client|destinataire)[^:]*?:\s*([A-Za-z\s.]+)',
}

def preprocess_image(image):
    """
    Apply preprocessing techniques to improve OCR accuracy for invoices and quotes
    
    Args:
        image: OpenCV image (numpy array)
        
    Returns:
        Preprocessed image
    """
    # Check if image is already grayscale
    if len(image.shape) == 3:
        gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    else:
        gray = image.copy()
    
    # Resize if image is too large (to improve processing speed)
    height, width = gray.shape
    max_dim = MAX_IMAGE_DIMENSION
    if max(height, width) > max_dim:
        scale_factor = max_dim / max(height, width)
        new_height, new_width = int(height * scale_factor), int(width * scale_factor)
        gray = cv2.resize(gray, (new_width, new_height), interpolation=cv2.INTER_AREA)
        logger.info(f"Resized image from {height}x{width} to {new_height}x{new_width}")
    
    # Apply noise reduction
    gray = cv2.GaussianBlur(gray, (3, 3), 0)
    
    # Apply adaptive thresholding to handle varying lighting conditions
    # This works well for document images with text
    thresh = cv2.adaptiveThreshold(gray, 255, cv2.ADAPTIVE_THRESH_GAUSSIAN_C, 
                                   cv2.THRESH_BINARY, 11, 7)
    
    # Apply morphological operations to remove noise and fill small gaps
    kernel = np.ones((1, 1), np.uint8)
    opening = cv2.morphologyEx(thresh, cv2.MORPH_OPEN, kernel)
    
    # Dilate to make text more prominent (helps with thin text in invoices)
    kernel = np.ones((1, 1), np.uint8)
    dilated = cv2.dilate(opening, kernel, iterations=1)
    
    return dilated

def deskew_image(image):
    """
    Deskew (straighten) the image to improve OCR results
    
    Args:
        image: OpenCV image
        
    Returns:
        Deskewed image
    """
    # Convert to grayscale if not already
    if len(image.shape) == 3:
        gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    else:
        gray = image.copy()
    
    # Calculate skew angle
    edges = cv2.Canny(gray, 50, 150, apertureSize=3)
    lines = cv2.HoughLines(edges, 1, np.pi/180, 100)
    
    if lines is None:
        return image  # No lines detected, return original image
    
    # Calculate skew angle
    angles = []
    for line in lines:
        rho, theta = line[0]
        if theta < np.pi/4 or theta > 3*np.pi/4:  # Only consider mostly horizontal lines
            angles.append(theta)
    
    if not angles:
        return image
    
    median_angle = np.median(angles)
    skew_angle = np.degrees(median_angle - np.pi/2)
    
    # If angle is too large, it's likely an error - ignore it
    if abs(skew_angle) > 20:
        return image
    
    # Rotate to correct skew
    (h, w) = gray.shape
    center = (w // 2, h // 2)
    M = cv2.getRotationMatrix2D(center, skew_angle, 1.0)
    rotated = cv2.warpAffine(image, M, (w, h), flags=cv2.INTER_CUBIC, 
                            borderMode=cv2.BORDER_REPLICATE)
    
    return rotated

def extract_info_from_text(text, document_type="invoice"):
    """
    Extract structured information from OCR text based on document type
    
    Args:
        text: Extracted OCR text
        document_type: Type of document ('invoice' or 'quote')
        
    Returns:
        Dictionary with structured information
    """
    patterns = INVOICE_PATTERNS if document_type == "invoice" else QUOTE_PATTERNS
    structured_data = {}
    
    for key, pattern in patterns.items():
        match = re.search(pattern, text)
        if match:
            structured_data[key] = match.group(1).strip()
    
    return structured_data

def extract_text_from_image(image_path, document_type="auto"):
    """
    Extract text from an image file using Tesseract OCR, optimized for French invoices and quotes
    
    Args:
        image_path: Path to the image file
        document_type: Type of document ('auto', 'invoice', or 'quote')
        
    Returns:
        Dictionary with extracted text and structured information
    """
    start_time = time.time()
    logger.info(f"Processing image: {image_path}")
    
    # Load the image
    try:
        image = cv2.imread(image_path)
        if image is None:
            raise ValueError(f"Failed to load image: {image_path}")
    except Exception as e:
        logger.error(f"Error loading image: {str(e)}")
        return {"error": f"Error loading image: {str(e)}"}
    
    # Preprocess the image
    logger.info("Preprocessing image...")
    processed_image = preprocess_image(image)
    
    # Deskew the image if needed
    deskewed_image = deskew_image(processed_image)
    
    # Convert OpenCV image to PIL image for Tesseract
    pil_image = Image.fromarray(deskewed_image)
    
    # Extract text using Tesseract with French language
    logger.info("Running Tesseract OCR with French language...")
    text = pytesseract.image_to_string(
        pil_image, 
        lang='fra',  # French language
        config='--oem 3 --psm 1'  # OEM 3 = default OCR engine, PSM 1 = automatic page segmentation
    )
    
    # Determine document type if set to auto
    if document_type == "auto":
        if re.search(r'(?i)facture|fact\.|fac[ .#]|f\d{2}-\d+', text):
            document_type = "invoice"
            logger.info("Detected document type: Invoice")
        elif re.search(r'(?i)devis|proposition|offre|quote|cotation', text):
            document_type = "quote"
            logger.info("Detected document type: Quote")
        else:
            document_type = "invoice"  # Default to invoice
            logger.info("Unable to determine document type, defaulting to: Invoice")
    
    # Extract structured information
    structured_data = extract_info_from_text(text, document_type)
    
    # Calculate processing time
    processing_time = time.time() - start_time
    logger.info(f"OCR completed in {processing_time:.2f} seconds")
    
    return {
        "text": text,
        "document_type": document_type,
        "structured_data": structured_data,
        "processing_time": processing_time
    }

def extract_text_from_pdf(pdf_path, document_type="auto"):
    """
    Extract text from a PDF file using Tesseract OCR
    
    Args:
        pdf_path: Path to the PDF file
        document_type: Type of document ('auto', 'invoice', or 'quote')
        
    Returns:
        Dictionary with extracted text and structured information
    """
    start_time = time.time()
    logger.info(f"Processing PDF: {pdf_path}")
    
    try:
        # Create a temporary directory to store PDF page images
        with tempfile.TemporaryDirectory() as temp_dir:
            # Set Poppler path explicitly
            poppler_path = r"C:\poppler-24.08.0\bin"
            # Verify if Poppler directory exists
            if not os.path.exists(poppler_path):
                # Try finding Poppler through PATH
                if os.environ.get('PATH', '').find('poppler') != -1:
                    # Try to extract Poppler path from PATH
                    for path_dir in os.environ.get('PATH', '').split(os.pathsep):
                        if 'poppler' in path_dir.lower() and os.path.exists(path_dir):
                            poppler_path = path_dir
                            break
            logger.info(f"Using Poppler path: {poppler_path}")
            
            # Convert PDF to images
            logger.info(f"Converting PDF to images with DPI={DPI}...")
            pdf_pages = convert_from_path(
                pdf_path, 
                dpi=DPI,
                output_folder=temp_dir,
                fmt="jpeg",
                thread_count=4,  # Use 4 threads for conversion
                poppler_path=poppler_path  # Explicitly set Poppler path
            )
            
            logger.info(f"PDF contains {len(pdf_pages)} pages")
            
            all_text = ""
            page_results = []
            
            # Process each page
            for i, page in enumerate(pdf_pages):
                logger.info(f"Processing page {i+1}/{len(pdf_pages)}")
                
                # Convert PIL image to OpenCV format
                img = np.array(page)
                img = cv2.cvtColor(img, cv2.COLOR_RGB2BGR)
                
                # Preprocess the image
                processed_img = preprocess_image(img)
                
                # Deskew the image
                deskewed_img = deskew_image(processed_img)
                
                # Convert back to PIL for Tesseract
                pil_img = Image.fromarray(deskewed_img)
                
                # Extract text using Tesseract
                page_text = pytesseract.image_to_string(
                    pil_img,
                    lang='fra',  # French language
                    config='--oem 3 --psm 1'
                )
                
                all_text += page_text + "\n\n--- Page Break ---\n\n"
                page_results.append(page_text)
            
            # Determine document type if set to auto (use first page for detection)
            if document_type == "auto":
                first_page_text = page_results[0] if page_results else ""
                if re.search(r'(?i)facture|fact\.|fac[ .#]|f\d{2}-\d+', first_page_text):
                    document_type = "invoice"
                    logger.info("Detected document type: Invoice")
                elif re.search(r'(?i)devis|proposition|offre|quote|cotation', first_page_text):
                    document_type = "quote"
                    logger.info("Detected document type: Quote")
                else:
                    document_type = "invoice"  # Default to invoice
                    logger.info("Unable to determine document type, defaulting to: Invoice")
            
            # Extract structured information (use full text for better extraction)
            structured_data = extract_info_from_text(all_text, document_type)
            
            # Calculate processing time
            processing_time = time.time() - start_time
            logger.info(f"PDF OCR completed in {processing_time:.2f} seconds")
            
            return {
                "text": all_text,
                "document_type": document_type,
                "structured_data": structured_data,
                "processing_time": processing_time,
                "page_count": len(pdf_pages)
            }
    
    except Exception as e:
        logger.error(f"Error processing PDF: {str(e)}")
        return {"error": f"Error processing PDF: {str(e)}"}

def determine_file_type(file_path):
    """
    Determine if the file is an image or PDF
    
    Args:
        file_path: Path to the file
        
    Returns:
        String 'image' or 'pdf'
    """
    file_ext = os.path.splitext(file_path)[1].lower()
    
    if file_ext in ['.pdf']:
        return 'pdf'
    elif file_ext in ['.jpg', '.jpeg', '.png', '.bmp', '.tiff', '.tif', '.webp']:
        return 'image'
    else:
        raise ValueError(f"Unsupported file type: {file_ext}")

def process_file(file_path, output_dir=None, document_type="auto"):
    """
    Process a file for OCR and save results in plain text format only
    
    Args:
        file_path: Path to the file to process
        output_dir: Directory to save results (if None, use the standard ocr result directory)
        document_type: Type of document ('auto', 'invoice', or 'quote')
        
    Returns:
        Path to the result file (TXT version)
    """
    try:
        # Set default output directory if not provided
        if output_dir is None:
            output_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'ocr result')
        
        # Create output directory if it doesn't exist
        os.makedirs(output_dir, exist_ok=True)
        
        # Generate output file path for text format only
        file_name = os.path.basename(file_path)
        file_base, _ = os.path.splitext(file_name)
        text_output_path = os.path.join(output_dir, f"{file_base}_tesseract_ocr.txt")
        
        # Process file based on type
        file_type = determine_file_type(file_path)
        
        if file_type == 'pdf':
            result = extract_text_from_pdf(file_path, document_type)
        elif file_type == 'image':
            result = extract_text_from_image(file_path, document_type)
        else:
            raise ValueError(f"Unsupported file type: {file_type}")
        
        # Add file info to result
        result['original_file'] = file_path
        result['result_file'] = text_output_path
        
        # Save plain text result (just the extracted text)
        with open(text_output_path, 'w', encoding='utf-8') as f:
            f.write(result['text'])
        
        logger.info(f"OCR plain text saved to: {text_output_path}")
        
        # Return path to the text file
        return text_output_path
    
    except Exception as e:
        logger.error(f"Error processing file: {str(e)}")
        return None

def main():
    parser = argparse.ArgumentParser(description="Tesseract OCR for French invoices and quotes")
    parser.add_argument("file", help="Path to the file (image or PDF) to process")
    parser.add_argument("--output", "-o", help="Directory to save results")
    parser.add_argument("--type", "-t", choices=["auto", "invoice", "quote"], 
                        default="auto", help="Document type")
    
    args = parser.parse_args()
    
    try:
        result_path = process_file(args.file, args.output, args.type)
        if result_path:
            logger.info(f"OCR completed successfully. Results saved to: {result_path}")
            sys.exit(0)
        else:
            logger.error("OCR processing failed")
            sys.exit(1)
    except Exception as e:
        logger.error(f"Error: {str(e)}")
        sys.exit(1)

if __name__ == "__main__":
    main()
