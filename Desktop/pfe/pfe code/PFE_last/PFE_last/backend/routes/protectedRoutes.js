const express = require('express');
const router = express.Router();
const { verifyToken, requireClientRole } = require('../middleware/authMiddleware');
const devisController = require('../controllers/devisController');
const documentController = require('../controllers/documentController');

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

// All routes in this file require authentication
router.use(verifyToken);

// Routes that require client role
router.get('/devis', logRequest, requireClientRole, devisController.getAllDevis);
router.post('/devis', logRequest, requireClientRole, devisController.createDevis);
router.get('/devis/:id', logRequest, requireClientRole, devisController.getDevisById);
router.put('/devis/:id', logRequest, requireClientRole, devisController.updateDevis);
router.delete('/devis/:id', logRequest, requireClientRole, devisController.deleteDevis);
router.post('/devis/:id/email', logRequest, devisController.sendDevisByEmail);
router.post('/devis/:id/accept', logRequest, devisController.acceptDevis);
router.post('/devis/:id/reject', logRequest, devisController.rejectDevis);
// Routes pour les factures
const facturesController = require('../controllers/facturesController');
router.get('/factures', logRequest, requireClientRole, facturesController.getAllFactures);
router.get('/factures/:id', logRequest, requireClientRole, facturesController.getFactureById);
router.post('/factures/:id/email', logRequest, facturesController.sendFactureByEmail);
router.post('/factures/:id/payment-status', logRequest, facturesController.updatePaymentStatus);

// Document routes
router.get('/documents', logRequest, documentController.getAllDocuments);
router.get('/documents/:id', logRequest, documentController.getDocumentById);
router.get('/documents/by-remplissage/:id', logRequest, documentController.getDocumentByRemplissageId);
router.get('/documents/file-path/:id', logRequest, documentController.getDocumentFilePath);
router.get('/documents/:id/download', logRequest, documentController.downloadDocument);
router.get('/documents/:id/view', logRequest, documentController.viewDocument);
router.post('/documents/:id/email', logRequest, documentController.sendDocumentByEmail);
router.post('/documents/archive', logRequest, documentController.archiveDocument);

// Profile routes that require authentication but not specific role
router.get('/profile', logRequest, (req, res) => {
    res.json({
        success: true,
        message: 'Profil utilisateur',
        user: req.user
    });
});

router.use(errorHandler);

module.exports = router;