const express = require('express');
const router = express.Router();
const paymentController = require('../controllers/paymentController');
console.log('paymentController:', paymentController);
const { authenticateToken } = require('../middleware/authMiddleware');

// Use the controller functions directly
router.post('/create', authenticateToken, paymentController.createPayment);
router.get('/user/:userId', authenticateToken, paymentController.getUserPayments);
router.get('/verify/:sessionId', authenticateToken, paymentController.verifyPayment);

module.exports = router;