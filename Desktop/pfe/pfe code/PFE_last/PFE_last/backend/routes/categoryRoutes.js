const express = require('express');
const router = express.Router();
const categoryController = require('../controllers/categoryController');
const subcategoryController = require('../controllers/subcategoryController');
const { verifyToken } = require('../middleware/authMiddleware');

// ==========================================
// IMPORTANT: Order matters in Express routes
// More specific routes must come before generic ones
// ==========================================

// Category routes
// Get all categories for the authenticated user
router.get('/', verifyToken, categoryController.getCategories);

// Create a new category
router.post('/', verifyToken, categoryController.createCategory);

// Subcategory routes
// Get all subcategories (regardless of category)
router.get('/subcategories', verifyToken, subcategoryController.getAllSubcategories);

// Create a new subcategory
router.post('/subcategories', verifyToken, subcategoryController.createSubcategory);

// Get a specific subcategory by ID
router.get('/subcategories/:id', verifyToken, subcategoryController.getSubcategoryById);

// Update a subcategory
router.put('/subcategories/:id', verifyToken, subcategoryController.updateSubcategory);

// Delete a subcategory
router.delete('/subcategories/:id', verifyToken, subcategoryController.deleteSubcategory);

// Get subcategories for a specific category
router.get('/:categoryId/subcategories', verifyToken, subcategoryController.getSubcategoriesByCategory);

// Get a specific category by ID
router.get('/:id', verifyToken, categoryController.getCategoryById);

// Update a category
router.put('/:id', verifyToken, categoryController.updateCategory);

// Delete a category
router.delete('/:id', verifyToken, categoryController.deleteCategory);

module.exports = router;