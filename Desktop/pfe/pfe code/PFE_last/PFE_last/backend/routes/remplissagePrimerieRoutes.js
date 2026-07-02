const express = require('express');
const router = express.Router();
const { verifyToken } = require('../middleware/authMiddleware');
const { logRequest } = require('../middleware/logMiddleware');
const { 
  getDocumentsByType,
  getDocumentById,
  getDocumentDetailsForEdit,
  deleteDocument,
  updateDocument
} = require('../controllers/remplissagePrimerieController');

// Routes pour les documents (factures et devis)
router.get('/documents/:typeDocument', verifyToken, logRequest, getDocumentsByType);
router.get('/document/:id', verifyToken, logRequest, getDocumentById);
router.get('/document/:id/edit', verifyToken, logRequest, getDocumentDetailsForEdit);
router.put('/document/:id', verifyToken, logRequest, updateDocument);
router.delete('/document/:id', verifyToken, logRequest, deleteDocument);

module.exports = router;