const db = require('../config/db');

// Create a new product
const createProduct = async (productData) => {
  try {
    const query = `
      INSERT INTO products (
        owner_id,
        name,
        description,
        unit_price,
        unit,
        stock_quantity,
        subcategory_id
      ) VALUES (?, ?, ?, ?, ?, ?, ?)`;

    const [result] = await db.query(
      query, 
      [
        productData.owner_id,
        productData.name,
        productData.description,
        productData.unit_price,
        productData.unit,
        productData.stock_quantity || 0,
        productData.subcategory_id
      ]
    );
    
    return { id: result.insertId, ...productData };
  } catch (error) {
    throw error;
  }
};

// Get all products for a specific user
const getProductsByUserId = async (userId, filters = {}) => {
  try {
    let query = `
      SELECT p.*, s.name as subcategory_name, c.name as category_name, c.id as category_id
      FROM products p
      LEFT JOIN subcategories s ON p.subcategory_id = s.id
      LEFT JOIN categories c ON s.category_id = c.id
      WHERE p.owner_id = ?`;
    
    const queryParams = [userId];
    
    // Apply filters if provided
    if (filters.name) {
      query += " AND p.name LIKE ?";
      queryParams.push(`%${filters.name}%`);
    }
    
    if (filters.category_id) {
      query += " AND c.id = ?";
      queryParams.push(filters.category_id);
    }
    
    if (filters.subcategory_id) {
      query += " AND p.subcategory_id = ?";
      queryParams.push(filters.subcategory_id);
    }
    
    if (filters.price_min) {
      query += " AND p.unit_price >= ?";
      queryParams.push(filters.price_min);
    }
    
    if (filters.price_max) {
      query += " AND p.unit_price <= ?";
      queryParams.push(filters.price_max);
    }
    
    if (filters.stock_min) {
      query += " AND p.stock_quantity >= ?";
      queryParams.push(filters.stock_min);
    }
    
    if (filters.stock_max) {
      query += " AND p.stock_quantity <= ?";
      queryParams.push(filters.stock_max);
    }
    
    // Filtrage par état de stock
    if (filters.stock_status) {
      switch(filters.stock_status) {
        case 'out':
          query += " AND p.stock_quantity <= 0";
          break;
        case 'low':
          query += " AND p.stock_quantity > 0 AND p.stock_quantity < 10";
          break;
        case 'normal':
          query += " AND p.stock_quantity >= 10";
          break;
      }
    }
    
    // Add sorting
    const sortField = filters.sort_by || 'name';
    const sortOrder = filters.sort_order || 'ASC';
    query += ` ORDER BY p.${sortField} ${sortOrder}`;
    
    const [rows] = await db.query(query, queryParams);
    return rows;
  } catch (error) {
    throw error;
  }
};

// Get a product by ID
const getProductById = async (productId, userId) => {
  try {
    const [rows] = await db.query(
      `SELECT p.*, s.name as subcategory_name, c.name as category_name, c.id as category_id
       FROM products p
       LEFT JOIN subcategories s ON p.subcategory_id = s.id
       LEFT JOIN categories c ON s.category_id = c.id
       WHERE p.id = ? AND p.owner_id = ?`,
      [productId, userId]
    );
    
    if (rows.length === 0) {
      return null;
    }
    
    return rows[0];
  } catch (error) {
    throw error;
  }
};

// Update a product
const updateProduct = async (productId, productData, userId) => {
  try {
    const query = `
      UPDATE products 
      SET 
        name = ?,
        description = ?,
        unit_price = ?,
        unit = ?,
        stock_quantity = ?,
        subcategory_id = ?
      WHERE id = ? AND owner_id = ?`;

    const [result] = await db.query(
      query,
      [
        productData.name,
        productData.description,
        productData.unit_price,
        productData.unit,
        productData.stock_quantity,
        productData.subcategory_id,
        productId,
        userId
      ]
    );
    
    if (result.affectedRows === 0) {
      return null;
    }
    
    return { id: productId, ...productData };
  } catch (error) {
    throw error;
  }
};

// Delete a product
const deleteProduct = async (productId, userId) => {
  try {
    const [result] = await db.query(
      'DELETE FROM products WHERE id = ? AND owner_id = ?',
      [productId, userId]
    );
    
    return result.affectedRows > 0;
  } catch (error) {
    throw error;
  }
};

// Update product stock quantity
const updateStock = async (productId, quantity, userId) => {
  try {
    const [result] = await db.query(
      'UPDATE products SET stock_quantity = ? WHERE id = ? AND owner_id = ?',
      [quantity, productId, userId]
    );
    
    return result.affectedRows > 0;
  } catch (error) {
    throw error;
  }
};

// Search products by name or description
const searchProducts = async (searchTerm, userId) => {
  try {
    const searchPattern = `%${searchTerm}%`;
    const [rows] = await db.query(
      `SELECT p.*, s.name as subcategory_name, c.name as category_name, c.id as category_id
       FROM products p
       LEFT JOIN subcategories s ON p.subcategory_id = s.id
       LEFT JOIN categories c ON s.category_id = c.id
       WHERE p.owner_id = ? AND 
       (p.name LIKE ? OR p.description LIKE ?)
       ORDER BY p.name ASC`,
      [userId, searchPattern, searchPattern]
    );
    
    return rows;
  } catch (error) {
    throw error;
  }
};

// Check if a product name is unique for a user
const checkUnique = async (name, userId, excludeId = null) => {
  try {
    let query = 'SELECT COUNT(*) as count FROM products WHERE owner_id = ? AND name = ?';
    let params = [userId, name];
    
    // If excludeId is provided, exclude that product from the check
    if (excludeId) {
      query += ' AND id != ?';
      params.push(excludeId);
    }
    
    const [rows] = await db.query(query, params);
    return rows[0].count === 0; // Return true if no records found (unique)
  } catch (error) {
    throw error;
  }
};

module.exports = {
  createProduct,
  getProductsByUserId,
  getProductById,
  updateProduct,
  deleteProduct,
  updateStock,
  searchProducts,
  checkUnique
};