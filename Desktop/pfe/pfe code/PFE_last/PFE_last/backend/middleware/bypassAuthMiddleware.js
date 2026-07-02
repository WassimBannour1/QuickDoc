/**
 * Bypass authentication middleware for routes that should be accessible without authentication
 * This is used for routes like OCR and Ollama that need to be accessible without a login
 */
const bypassAuth = (req, res, next) => {
    console.log('Bypassing authentication for public route:', req.path);
    next();
};

module.exports = bypassAuth;
