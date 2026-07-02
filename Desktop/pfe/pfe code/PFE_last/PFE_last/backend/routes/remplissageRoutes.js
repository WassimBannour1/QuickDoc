const express = require('express');
const router = express.Router();
const { verifyToken, requireClientRole, requireEnterpriseRole } = require('../middleware/authMiddleware');
const remplissageController = require('../controllers/remplissageController');

// Middleware de journalisation des requêtes
const logRequest = (req, res, next) => {
    const timestamp = new Date().toISOString();
    console.log(`=== ${timestamp} ===`);
    console.log(`${req.method} ${req.baseUrl}${req.path}`);
    console.log('Headers:', req.headers);
    console.log('Body:', req.body);

    // Ajout de la journalisation des réponses
    const oldSend = res.send;
    res.send = function(data) {
        console.log('Response:', data);
        oldSend.apply(res, arguments);
    };

    next();
};

// Toutes les routes nécessitent une authentification
router.use(verifyToken);

// Routes pour les documents (factures et devis) - accessibles aux clients et aux administrateurs d'entreprise
router.get('/remplissage', logRequest, verifyToken, remplissageController.getAllDocuments);
router.get('/remplissage/:id', logRequest, verifyToken, remplissageController.getDocumentById);
router.delete('/remplissage/:id', logRequest, verifyToken, remplissageController.deleteDocument);

// Route pour créer un nouveau document avec des produits associés
router.post('/remplissage/create', logRequest, verifyToken, remplissageController.createManualFillDocument);

// Routes spécifiques pour les factures - accessibles aux clients et aux administrateurs d'entreprise
// Utilisation du contrôleur dédié aux factures
const facturesController = require('../controllers/facturesController');
router.get('/factures', logRequest, verifyToken, facturesController.getAllFactures);
router.post('/factures/:id/payment-status', logRequest, verifyToken, facturesController.updatePaymentStatus);
router.delete('/factures/:id', logRequest, verifyToken, remplissageController.deleteDocument);

// Routes spécifiques pour les devis - accessibles aux clients et aux administrateurs d'entreprise
// Utilisation du contrôleur dédié aux devis
const devisController = require('../controllers/devisController');
router.get('/devis', logRequest, verifyToken, devisController.getAllDevis);
router.delete('/devis/:id', logRequest, verifyToken, remplissageController.deleteDocument);

module.exports = router;