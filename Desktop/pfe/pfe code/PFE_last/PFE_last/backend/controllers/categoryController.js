const categoryModel = require('../models/category');

// Create a new category
const createCategory = async (req, res) => {
  try {
    // Extract category data from request body
    const categoryData = {
      owner_id: req.user.id, // Assuming user ID is available from authentication middleware
      name: req.body.name
    };

    // Validate required fields
    if (!categoryData.name) {
      return res.status(400).json({
        success: false,
        message: 'Le nom de la catégorie est obligatoire'
      });
    }

    // Check if name is unique for this user
    const isNameUnique = await categoryModel.checkUnique(categoryData.name, categoryData.owner_id);
    if (!isNameUnique) {
      return res.status(409).json({
        success: false,
        message: 'Ce nom de catégorie existe déjà',
        field: 'name'
      });
    }

    // Create category in database
    const newCategory = await categoryModel.createCategory(categoryData);

    // Return success response
    return res.status(201).json({
      success: true,
      message: 'Catégorie créée avec succès',
      data: newCategory
    });
  } catch (error) {
    console.error('Error creating category:', error);
    return res.status(500).json({
      success: false,
      message: 'Une erreur est survenue lors de la création de la catégorie',
      error: error.message
    });
  }
};

// Get all categories for the authenticated user
const getCategories = async (req, res) => {
  try {
    const userId = req.user.id; // Assuming user ID is available from authentication middleware
    const categories = await categoryModel.getCategoriesByUserId(userId);

    return res.status(200).json({
      success: true,
      data: categories
    });
  } catch (error) {
    console.error('Error fetching categories:', error);
    return res.status(500).json({
      success: false,
      message: 'Une erreur est survenue lors de la récupération des catégories',
      error: error.message
    });
  }
};

// Get a specific category by ID
const getCategoryById = async (req, res) => {
  try {
    const categoryId = req.params.id;
    const userId = req.user.id; // Assuming user ID is available from authentication middleware

    const category = await categoryModel.getCategoryById(categoryId, userId);

    if (!category) {
      return res.status(404).json({
        success: false,
        message: 'Catégorie non trouvée'
      });
    }

    return res.status(200).json({
      success: true,
      data: category
    });
  } catch (error) {
    console.error('Error fetching category:', error);
    return res.status(500).json({
      success: false,
      message: 'Une erreur est survenue lors de la récupération de la catégorie',
      error: error.message
    });
  }
};

// Update a category
const updateCategory = async (req, res) => {
  try {
    const categoryId = req.params.id;
    const userId = req.user.id; // Assuming user ID is available from authentication middleware

    // Extract category data from request body
    const categoryData = {
      name: req.body.name
    };

    // Validate required fields
    if (!categoryData.name) {
      return res.status(400).json({
        success: false,
        message: 'Le nom de la catégorie est obligatoire'
      });
    }

    // Check if name is unique (excluding current category)
    const isNameUnique = await categoryModel.checkUnique(categoryData.name, userId, categoryId);
    if (!isNameUnique) {
      return res.status(409).json({
        success: false,
        message: 'Ce nom de catégorie existe déjà',
        field: 'name'
      });
    }

    // Update category in database
    const updatedCategory = await categoryModel.updateCategory(categoryId, categoryData, userId);

    if (!updatedCategory) {
      return res.status(404).json({
        success: false,
        message: 'Catégorie non trouvée ou vous n\'avez pas les droits pour la modifier'
      });
    }

    return res.status(200).json({
      success: true,
      message: 'Catégorie mise à jour avec succès',
      data: updatedCategory
    });
  } catch (error) {
    console.error('Error updating category:', error);
    return res.status(500).json({
      success: false,
      message: 'Une erreur est survenue lors de la mise à jour de la catégorie',
      error: error.message
    });
  }
};

// Delete a category
const deleteCategory = async (req, res) => {
  try {
    const categoryId = req.params.id;
    const userId = req.user.id; // Assuming user ID is available from authentication middleware

    const result = await categoryModel.deleteCategory(categoryId, userId);

    if (!result) {
      return res.status(404).json({
        success: false,
        message: 'Catégorie non trouvée ou vous n\'avez pas les droits pour la supprimer'
      });
    }

    return res.status(200).json({
      success: true,
      message: 'Catégorie supprimée avec succès'
    });
  } catch (error) {
    console.error('Error deleting category:', error);
    return res.status(500).json({
      success: false,
      message: 'Une erreur est survenue lors de la suppression de la catégorie',
      error: error.message
    });
  }
};

// Check if a field value is unique
const checkUnique = async (req, res) => {
  try {
    const { name } = req.query;
    const userId = req.user.id;
    const excludeId = req.query.excludeId || null;

    if (!name) {
      return res.status(400).json({
        success: false,
        message: 'Le nom de la catégorie est requis pour la vérification'
      });
    }

    const isUnique = await categoryModel.checkUnique(name, userId, excludeId);

    return res.status(200).json({
      success: true,
      isUnique: isUnique
    });
  } catch (error) {
    console.error('Error checking uniqueness:', error);
    return res.status(500).json({
      success: false,
      message: 'Une erreur est survenue lors de la vérification',
      error: error.message
    });
  }
};

module.exports = {
  createCategory,
  getCategories,
  getCategoryById,
  updateCategory,
  deleteCategory,
  checkUnique
};