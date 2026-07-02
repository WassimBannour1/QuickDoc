const productModel = require('../models/product');
const subcategoryModel = require('../models/subcategory');
const categoryModel = require('../models/category');

// Create a new product
const createProduct = async (req, res) => {
  try {
    // Extract product data from request body
    const productData = {
      owner_id: req.user.id, // Assuming user ID is available from authentication middleware
      name: req.body.name,
      description: req.body.description,
      unit_price: req.body.unit_price,
      unit: req.body.unit,
      stock_quantity: req.body.stock_quantity || 0,
      subcategory_id: req.body.subcategory_id
    };

    // Validate required fields
    if (!productData.name) {
      return res.status(400).json({
        success: false,
        message: 'Le nom du produit est obligatoire'
      });
    }

    if (!productData.unit_price || isNaN(productData.unit_price) || productData.unit_price <= 0) {
      return res.status(400).json({
        success: false,
        message: 'Le prix unitaire doit être un nombre positif',
        field: 'unit_price'
      });
    }

    // Check if name is unique for this user
    const isNameUnique = await productModel.checkUnique(productData.name, productData.owner_id);
    if (!isNameUnique) {
      return res.status(409).json({
        success: false,
        message: 'Ce nom de produit existe déjà',
        field: 'name'
      });
    }

    // Verify subcategory exists and belongs to the user if provided
    if (productData.subcategory_id) {
      const subcategory = await subcategoryModel.getSubcategoryById(productData.subcategory_id);
      if (!subcategory) {
        return res.status(404).json({
          success: false,
          message: 'Sous-catégorie non trouvée',
          field: 'subcategory_id'
        });
      }

      // Verify the subcategory's category belongs to the user
      if (subcategory.category_id) {
        const category = await categoryModel.getCategoryById(subcategory.category_id, productData.owner_id);
        if (!category) {
          return res.status(403).json({
            success: false,
            message: 'Accès non autorisé à cette sous-catégorie',
            field: 'subcategory_id'
          });
        }
      }
    }

    // Create product in database
    const newProduct = await productModel.createProduct(productData);

    // Return success response
    return res.status(201).json({
      success: true,
      message: 'Produit créé avec succès',
      data: newProduct
    });
  } catch (error) {
    console.error('Error creating product:', error);
    return res.status(500).json({
      success: false,
      message: 'Une erreur est survenue lors de la création du produit',
      error: error.message
    });
  }
};

// Get all products for the authenticated user with optional filters
const getProducts = async (req, res) => {
  try {
    const userId = req.user.id; // Assuming user ID is available from authentication middleware
    
    // Extract filter parameters from query string
    const filters = {
      name: req.query.name || req.query.search,
      category_id: req.query.category_id,
      subcategory_id: req.query.subcategory_id,
      price_min: req.query.price_min,
      price_max: req.query.price_max,
      stock_min: req.query.stock_min,
      stock_max: req.query.stock_max,
      stock_status: req.query.stock_status,
      sort_by: req.query.sort_by,
      sort_order: req.query.sort_order
    };

    const products = await productModel.getProductsByUserId(userId, filters);

    return res.status(200).json({
      success: true,
      data: products
    });
  } catch (error) {
    console.error('Error fetching products:', error);
    return res.status(500).json({
      success: false,
      message: 'Une erreur est survenue lors de la récupération des produits',
      error: error.message
    });
  }
};

// Get a specific product by ID
const getProductById = async (req, res) => {
  try {
    const productId = req.params.id;
    const userId = req.user.id; // Assuming user ID is available from authentication middleware

    const product = await productModel.getProductById(productId, userId);

    if (!product) {
      return res.status(404).json({
        success: false,
        message: 'Produit non trouvé'
      });
    }

    return res.status(200).json({
      success: true,
      data: product
    });
  } catch (error) {
    console.error('Error fetching product:', error);
    return res.status(500).json({
      success: false,
      message: 'Une erreur est survenue lors de la récupération du produit',
      error: error.message
    });
  }
};

// Update a product
const updateProduct = async (req, res) => {
  try {
    const productId = req.params.id;
    const userId = req.user.id; // Assuming user ID is available from authentication middleware

    // Extract product data from request body
    const productData = {
      name: req.body.name,
      description: req.body.description,
      unit_price: req.body.unit_price,
      unit: req.body.unit,
      stock_quantity: req.body.stock_quantity,
      subcategory_id: req.body.subcategory_id
    };

    // Validate required fields
    if (!productData.name) {
      return res.status(400).json({
        success: false,
        message: 'Le nom du produit est obligatoire'
      });
    }

    if (!productData.unit_price || isNaN(productData.unit_price) || productData.unit_price <= 0) {
      return res.status(400).json({
        success: false,
        message: 'Le prix unitaire doit être un nombre positif',
        field: 'unit_price'
      });
    }

    // Check if name is unique (excluding current product)
    const isNameUnique = await productModel.checkUnique(productData.name, userId, productId);
    if (!isNameUnique) {
      return res.status(409).json({
        success: false,
        message: 'Ce nom de produit existe déjà',
        field: 'name'
      });
    }

    // Verify subcategory exists and belongs to the user if provided
    if (productData.subcategory_id) {
      const subcategory = await subcategoryModel.getSubcategoryById(productData.subcategory_id);
      if (!subcategory) {
        return res.status(404).json({
          success: false,
          message: 'Sous-catégorie non trouvée',
          field: 'subcategory_id'
        });
      }

      // Verify the subcategory's category belongs to the user
      if (subcategory.category_id) {
        const category = await categoryModel.getCategoryById(subcategory.category_id, userId);
        if (!category) {
          return res.status(403).json({
            success: false,
            message: 'Accès non autorisé à cette sous-catégorie',
            field: 'subcategory_id'
          });
        }
      }
    }

    // Update product in database
    const updatedProduct = await productModel.updateProduct(productId, productData, userId);

    if (!updatedProduct) {
      return res.status(404).json({
        success: false,
        message: 'Produit non trouvé ou vous n\'avez pas les droits pour le modifier'
      });
    }

    return res.status(200).json({
      success: true,
      message: 'Produit mis à jour avec succès',
      data: updatedProduct
    });
  } catch (error) {
    console.error('Error updating product:', error);
    return res.status(500).json({
      success: false,
      message: 'Une erreur est survenue lors de la mise à jour du produit',
      error: error.message
    });
  }
};

// Delete a product
const deleteProduct = async (req, res) => {
  try {
    const productId = req.params.id;
    const userId = req.user.id; // Assuming user ID is available from authentication middleware

    const result = await productModel.deleteProduct(productId, userId);

    if (!result) {
      return res.status(404).json({
        success: false,
        message: 'Produit non trouvé ou vous n\'avez pas les droits pour le supprimer'
      });
    }

    return res.status(200).json({
      success: true,
      message: 'Produit supprimé avec succès'
    });
  } catch (error) {
    console.error('Error deleting product:', error);
    return res.status(500).json({
      success: false,
      message: 'Une erreur est survenue lors de la suppression du produit',
      error: error.message
    });
  }
};

// Update product stock
const updateStock = async (req, res) => {
  try {
    const productId = req.params.id;
    const userId = req.user.id; // Assuming user ID is available from authentication middleware
    const { quantity } = req.body;

    // Validate quantity
    if (quantity === undefined || isNaN(quantity) || quantity < 0) {
      return res.status(400).json({
        success: false,
        message: 'La quantité doit être un nombre positif ou nul',
        field: 'quantity'
      });
    }

    // Update stock in database
    const result = await productModel.updateStock(productId, quantity, userId);

    if (!result) {
      return res.status(404).json({
        success: false,
        message: 'Produit non trouvé ou vous n\'avez pas les droits pour le modifier'
      });
    }

    return res.status(200).json({
      success: true,
      message: 'Stock mis à jour avec succès'
    });
  } catch (error) {
    console.error('Error updating stock:', error);
    return res.status(500).json({
      success: false,
      message: 'Une erreur est survenue lors de la mise à jour du stock',
      error: error.message
    });
  }
};

// Search products
const searchProducts = async (req, res) => {
  try {
    const userId = req.user.id; // Assuming user ID is available from authentication middleware
    const { term } = req.query;

    if (!term) {
      return res.status(400).json({
        success: false,
        message: 'Le terme de recherche est requis'
      });
    }

    const products = await productModel.searchProducts(term, userId);

    return res.status(200).json({
      success: true,
      data: products
    });
  } catch (error) {
    console.error('Error searching products:', error);
    return res.status(500).json({
      success: false,
      message: 'Une erreur est survenue lors de la recherche des produits',
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
        message: 'Le nom du produit est requis pour la vérification'
      });
    }

    const isUnique = await productModel.checkUnique(name, userId, excludeId);

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

// Adjust product stock with reason
const adjustStock = async (req, res) => {
  try {
    const productId = req.params.id;
    const userId = req.user.id;
    const { quantity, reason, note } = req.body;

    // Validate quantity
    if (quantity === undefined || isNaN(quantity)) {
      return res.status(400).json({
        success: false,
        message: 'La quantité doit être un nombre valide',
        field: 'quantity'
      });
    }

    // Validate reason
    if (!reason) {
      return res.status(400).json({
        success: false,
        message: 'La raison de l\'ajustement est requise',
        field: 'reason'
      });
    }

    // Get current product to calculate new stock
    const product = await productModel.getProductById(productId, userId);
    
    if (!product) {
      return res.status(404).json({
        success: false,
        message: 'Produit non trouvé ou vous n\'avez pas les droits pour le modifier'
      });
    }

    // Calculate new stock quantity
    const newQuantity = product.stock_quantity + parseInt(quantity);
    
    // Don't allow negative stock
    if (newQuantity < 0) {
      return res.status(400).json({
        success: false,
        message: 'La quantité en stock ne peut pas être négative',
        field: 'quantity'
      });
    }

    // Update stock in database
    const result = await productModel.updateStock(productId, newQuantity, userId);

    // Here you would also log the stock adjustment in a stock_adjustments table
    // This would require creating a new model and table for stock adjustments
    // For now, we'll just update the stock

    return res.status(200).json({
      success: true,
      message: 'Stock ajusté avec succès',
      data: {
        previous_quantity: product.stock_quantity,
        adjustment: parseInt(quantity),
        new_quantity: newQuantity,
        reason: reason,
        note: note || ''
      }
    });
  } catch (error) {
    console.error('Error adjusting stock:', error);
    return res.status(500).json({
      success: false,
      message: 'Une erreur est survenue lors de l\'ajustement du stock',
      error: error.message
    });
  }
};

module.exports = {
  createProduct,
  getProducts,
  getProductById,
  updateProduct,
  deleteProduct,
  updateStock,
  searchProducts,
  checkUnique,
  adjustStock
};