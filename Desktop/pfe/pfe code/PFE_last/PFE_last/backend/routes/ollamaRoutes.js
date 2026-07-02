const express = require('express');
const router = express.Router();
const ollamaController = require('../controllers/ollamaController');

// Import middleware but make it optional
let authMiddleware;
try {
    const auth = require('../middleware/authMiddleware');
    authMiddleware = auth.verifyToken;
} catch (error) {
    // Fallback middleware that passes through without authentication
    authMiddleware = (req, res, next) => {
        console.log('Authentication bypassed for Ollama routes');
        next();
    };
}

// Custom middleware to attempt auth but continue even if it fails
const optionalAuth = (req, res, next) => {
    // If no Authorization header, just continue
    if (!req.headers.authorization) {
        console.log('No auth token provided for Ollama route, continuing without authentication');
        return next();
    }
    
    // Otherwise try to authenticate, but continue either way
    try {
        authMiddleware(req, res, next);
    } catch (error) {
        console.log('Auth error in Ollama route, continuing anyway:', error.message);
        next();
    }
};

// Route for processing OCR text with Ollama - no auth required
router.post('/process', ollamaController.processWithOllama);

// Route for getting a specific Ollama response - no auth required
router.get('/response/:filename', ollamaController.getOllamaResponse);

// Route for listing all Ollama responses - no auth required
router.get('/responses', ollamaController.listOllamaResponses);

module.exports = router;
