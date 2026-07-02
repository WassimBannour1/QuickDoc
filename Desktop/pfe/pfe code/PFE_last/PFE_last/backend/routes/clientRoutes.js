const express = require('express');
const router = express.Router();
const clientController = require('../controllers/clientController');
const { verifyToken } = require('../middleware/authMiddleware');

// Create a new client
router.post('/', verifyToken, clientController.createClient);

// Check if a field value is unique
router.get('/check-unique', verifyToken, clientController.checkUnique);

// Get all clients for the authenticated user
router.get('/', verifyToken, clientController.getClients);

// Search clients
router.get('/search', verifyToken, clientController.searchClients);

// Get a specific client by ID
router.get('/:id', verifyToken, clientController.getClientById);

// Update a client
router.put('/:id', verifyToken, clientController.updateClient);

// Delete a client
router.delete('/:id', verifyToken, clientController.deleteClient);

module.exports = router;