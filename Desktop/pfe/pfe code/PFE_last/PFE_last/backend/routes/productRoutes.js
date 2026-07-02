const express = require('express');
const router = express.Router();
const productController = require('../controllers/productController');
const { verifyToken } = require('../middleware/authMiddleware');

// Create a new product
router.post('/', verifyToken, productController.createProduct);

// Check if a field value is unique
router.get('/check-unique', verifyToken, productController.checkUnique);

// Get all products for the authenticated user with optional filters
router.get('/', verifyToken, productController.getProducts);

// Search products
router.get('/search', verifyToken, productController.searchProducts);

// Get a specific product by ID
router.get('/:id', verifyToken, productController.getProductById);

// Update a product
router.put('/:id', verifyToken, productController.updateProduct);

// Update product stock
router.patch('/:id/stock', verifyToken, productController.updateStock);

// Stock adjustment with reason
router.post('/:id/stock-adjustment', verifyToken, productController.adjustStock);

// Delete a product
router.delete('/:id', verifyToken, productController.deleteProduct);

module.exports = router;