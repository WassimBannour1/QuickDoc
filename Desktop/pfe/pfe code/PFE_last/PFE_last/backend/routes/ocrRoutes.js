const express = require('express');
const router = express.Router();
const path = require('path');
const fs = require('fs');
const ocrController = require('../controllers/ocrController');

// Route for OCR extraction - using express-fileupload middleware
// which is already configured in server.js
router.post('/extract', ocrController.extractText);

// Route to get OCR result
router.get('/result/:filename', ocrController.getOcrResult);

// Route to process extracted text with local model (kept for compatibility)
// Route to process extracted text directly with OCR controller
router.post('/process-text', ocrController.processExtractedText);

module.exports = router;