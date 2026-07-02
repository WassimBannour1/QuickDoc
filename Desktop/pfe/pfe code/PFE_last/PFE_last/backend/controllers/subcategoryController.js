const subcategoryModel = require('../models/subcategory');
const categoryModel = require('../models/category');

// Create a new subcategory
const createSubcategory = async (req, res) => {
  try {
    // Extract subcategory data from request body
    const subcategoryData = {
      category_id: req.body.category_id,
      name: req.body.name
    };

    // Validate required fields
    if (!subcategoryData.name) {
      return res.status(400).json({
        success: false,
        message: 'Le nom de la sous-catégorie est obligatoire'
      });
    }

    if (!subcategoryData.category_id) {
      return res.status(400).json({
        success: false,
        message: 'La catégorie parente est obligatoire'
      });
    }

    // Verify that the category exists and belongs to the user
    const userId = req.user.id;
    const category = await categoryModel.getCategoryById(subcategoryData.category_id, userId);
    if (!category) {
      return res.status(404).json({
        success: false,
        message: 'Catégorie parente non trouvée ou accès non autorisé'
      });
    }

    // Check if name is unique within the category
    const isNameUnique = await subcategoryModel.checkUnique(subcategoryData.name, subcategoryData.category_id);
    if (!isNameUnique) {
      return res.status(409).json({
        success: false,
        message: 'Ce nom de sous-catégorie existe déjà dans cette catégorie',
        field: 'name'
      });
    }

    // Create subcategory in database
    const newSubcategory = await subcategoryModel.createSubcategory(subcategoryData);

    // Return success response
    return res.status(201).json({
      success: true,
      message: 'Sous-catégorie créée avec succès',
      data: newSubcategory
    });
  } catch (error) {
    console.error('Error creating subcategory:', error);
    return res.status(500).json({
      success: false,
      message: 'Une erreur est survenue lors de la création de la sous-catégorie',
      error: error.message
    });
  }
};

// Get all subcategories for a specific category
const getSubcategoriesByCategory = async (req, res) => {
  try {
    const categoryId = req.params.categoryId;
    const userId = req.user.id;

    // Verify that the category exists and belongs to the user
    const category = await categoryModel.getCategoryById(categoryId, userId);
    if (!category) {
      return res.status(404).json({
        success: false,
        message: 'Catégorie non trouvée ou accès non autorisé'
      });
    }

    const subcategories = await subcategoryModel.getSubcategoriesByCategoryId(categoryId);

    return res.status(200).json({
      success: true,
      data: subcategories
    });
  } catch (error) {
    console.error('Error fetching subcategories:', error);
    return res.status(500).json({
      success: false,
      message: 'Une erreur est survenue lors de la récupération des sous-catégories',
      error: error.message
    });
  }
};

// Get all subcategories for the authenticated user
const getAllSubcategories = async (req, res) => {
  try {
    const userId = req.user.id;
    const subcategories = await subcategoryModel.getSubcategoriesByUserId(userId);

    return res.status(200).json({
      success: true,
      data: subcategories
    });
  } catch (error) {
    console.error('Error fetching all subcategories:', error);
    return res.status(500).json({
      success: false,
      message: 'Une erreur est survenue lors de la récupération des sous-catégories',
      error: error.message
    });
  }
};

// Get a specific subcategory by ID
const getSubcategoryById = async (req, res) => {
  try {
    const subcategoryId = req.params.id;
    const userId = req.user.id;

    const subcategory = await subcategoryModel.getSubcategoryById(subcategoryId);

    if (!subcategory) {
      return res.status(404).json({
        success: false,
        message: 'Sous-catégorie non trouvée'
      });
    }

    // Verify that the parent category belongs to the user
    if (subcategory.category_id) {
      const category = await categoryModel.getCategoryById(subcategory.category_id, userId);
      if (!category) {
        return res.status(403).json({
          success: false,
          message: 'Accès non autorisé à cette sous-catégorie'
        });
      }
    }

    return res.status(200).json({
      success: true,
      data: subcategory
    });
  } catch (error) {
    console.error('Error fetching subcategory:', error);
    return res.status(500).json({
      success: false,
      message: 'Une erreur est survenue lors de la récupération de la sous-catégorie',
      error: error.message
    });
  }
};

// Update a subcategory
const updateSubcategory = async (req, res) => {
  try {
    const subcategoryId = req.params.id;
    const userId = req.user.id;

    // Extract subcategory data from request body
    const subcategoryData = {
      category_id: req.body.category_id,
      name: req.body.name
    };

    // Validate required fields
    if (!subcategoryData.name) {
      return res.status(400).json({
        success: false,
        message: 'Le nom de la sous-catégorie est obligatoire'
      });
    }

    if (!subcategoryData.category_id) {
      return res.status(400).json({
        success: false,
        message: 'La catégorie parente est obligatoire'
      });
    }

    // Verify that the category exists and belongs to the user
    const category = await categoryModel.getCategoryById(subcategoryData.category_id, userId);
    if (!category) {
      return res.status(404).json({
        success: false,
        message: 'Catégorie parente non trouvée ou accès non autorisé'
      });
    }

    // Get the current subcategory to verify access
    const currentSubcategory = await subcategoryModel.getSubcategoryById(subcategoryId);
    if (!currentSubcategory) {
      return res.status(404).json({
        success: false,
        message: 'Sous-catégorie non trouvée'
      });
    }

    // Verify that the current parent category belongs to the user
    if (currentSubcategory.category_id) {
      const currentCategory = await categoryModel.getCategoryById(currentSubcategory.category_id, userId);
      if (!currentCategory) {
        return res.status(403).json({
          success: false,
          message: 'Accès non autorisé à cette sous-catégorie'
        });
      }
    }

    // Check if name is unique within the category (excluding current subcategory)
    const isNameUnique = await subcategoryModel.checkUnique(
      subcategoryData.name, 
      subcategoryData.category_id, 
      subcategoryId
    );
    if (!isNameUnique) {
      return res.status(409).json({
        success: false,
        message: 'Ce nom de sous-catégorie existe déjà dans cette catégorie',
        field: 'name'
      });
    }

    // Update subcategory in database
    const updatedSubcategory = await subcategoryModel.updateSubcategory(subcategoryId, subcategoryData);

    if (!updatedSubcategory) {
      return res.status(404).json({
        success: false,
        message: 'Sous-catégorie non trouvée'
      });
    }

    return res.status(200).json({
      success: true,
      message: 'Sous-catégorie mise à jour avec succès',
      data: updatedSubcategory
    });
  } catch (error) {
    console.error('Error updating subcategory:', error);
    return res.status(500).json({
      success: false,
      message: 'Une erreur est survenue lors de la mise à jour de la sous-catégorie',
      error: error.message
    });
  }
};

// Delete a subcategory
const deleteSubcategory = async (req, res) => {
  try {
    const subcategoryId = req.params.id;
    const userId = req.user.id;

    // Get the subcategory to verify access
    const subcategory = await subcategoryModel.getSubcategoryById(subcategoryId);
    if (!subcategory) {
      return res.status(404).json({
        success: false,
        message: 'Sous-catégorie non trouvée'
      });
    }

    // Verify that the parent category belongs to the user
    if (subcategory.category_id) {
      const category = await categoryModel.getCategoryById(subcategory.category_id, userId);
      if (!category) {
        return res.status(403).json({
          success: false,
          message: 'Accès non autorisé à cette sous-catégorie'
        });
      }
    }

    const result = await subcategoryModel.deleteSubcategory(subcategoryId);

    if (!result) {
      return res.status(404).json({
        success: false,
        message: 'Sous-catégorie non trouvée'
      });
    }

    return res.status(200).json({
      success: true,
      message: 'Sous-catégorie supprimée avec succès'
    });
  } catch (error) {
    console.error('Error deleting subcategory:', error);
    return res.status(500).json({
      success: false,
      message: 'Une erreur est survenue lors de la suppression de la sous-catégorie',
      error: error.message
    });
  }
};

// Check if a subcategory name is unique within a category
const checkUnique = async (req, res) => {
  try {
    const { name, category_id } = req.query;
    const excludeId = req.query.excludeId || null;

    if (!name || !category_id) {
      return res.status(400).json({
        success: false,
        message: 'Le nom et l\'ID de la catégorie sont requis pour la vérification'
      });
    }

    const isUnique = await subcategoryModel.checkUnique(name, category_id, excludeId);

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
  createSubcategory,
  getSubcategoriesByCategory,
  getAllSubcategories,
  getSubcategoryById,
  updateSubcategory,
  deleteSubcategory,
  checkUnique
};