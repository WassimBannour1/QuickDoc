const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');
const resendCodeController = require('../controllers/resendCodeController');

// Enhanced request logging middleware
const logRequest = (req, res, next) => {
    const timestamp = new Date().toISOString();
    console.log(`=== ${timestamp} ===`);
    console.log(`${req.method} ${req.baseUrl}${req.path}`);
    console.log('Headers:', req.headers);
    console.log('Body:', req.body);

    // Add response logging
    const oldSend = res.send;
    res.send = function(data) {
        console.log('Response:', data);
        oldSend.apply(res, arguments);
    };

    next();
};

// Add error handling middleware
const errorHandler = (err, req, res, next) => {
    console.error('Route Error:', err);
    res.status(500).json({
        success: false,
        message: 'Une erreur est survenue'
    });
};

// Import authentication middleware
const { verifyToken, requireClientRole } = require('../middleware/authMiddleware');

// Middleware pour extraire le token et vérifier l'authentification
const extractToken = (req) => {
    if (req.headers.authorization && req.headers.authorization.startsWith('Bearer ')) {
        return req.headers.authorization.split(' ')[1];
    }
    return null;
};

router.post('/signup', logRequest, authController.signup);
router.post('/verify-email', logRequest, authController.verifyEmail);
router.post('/signin', logRequest, authController.signin);
router.post('/forgot-password', logRequest, authController.forgotPassword);
router.post('/verify-reset-code', logRequest, authController.verifyResetCode);
router.post('/reset-password', logRequest, authController.resetPassword);
router.post('/resend-code', logRequest, resendCodeController.resendResetCode);
router.post('/resend-verification', logRequest, resendCodeController.resendVerificationCode);

// Endpoint pour récupérer les informations de l'utilisateur connecté
router.get('/me', logRequest, verifyToken, async (req, res) => {
    try {
        // L'ID utilisateur est maintenant disponible dans req.user.userId grâce au middleware verifyToken
        const userId = req.user.userId;

        // Récupérer les informations de l'utilisateur depuis la base de données
        const [rows] = await require('../config/db').query(
            'SELECT id, first_name, last_name, email, role FROM users WHERE id = ?',
            [userId]
        );

        if (!rows || rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Utilisateur non trouvé'
            });
        }

        // Renvoyer les informations de l'utilisateur
        res.json({
            success: true,
            user: rows[0]
        });
    } catch (error) {
        console.error('Error in /me endpoint:', error);
        res.status(500).json({
            success: false,
            message: 'Erreur lors de la récupération des informations utilisateur'
        });
    }
});

router.use(errorHandler);

module.exports = router;