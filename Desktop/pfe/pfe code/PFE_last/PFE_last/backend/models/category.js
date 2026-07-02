const db = require('../config/db');

// Create a new category
const createCategory = async (categoryData) => {
  try {
    const query = `
      INSERT INTO categories (
        name,
        owner_id
      ) VALUES (?, ?)`;

    const [result] = await db.query(
      query, 
      [
        categoryData.name,
        categoryData.owner_id
      ]
    );
    
    return { id: result.insertId, ...categoryData };
  } catch (error) {
    throw error;
  }
};

// Get all categories for a specific user
const getCategoriesByUserId = async (userId) => {
  try {
    const [rows] = await db.query(
      'SELECT * FROM categories WHERE owner_id = ? ORDER BY name ASC',
      [userId]
    );
    return rows;
  } catch (error) {
    throw error;
  }
};

// Get a category by ID
const getCategoryById = async (categoryId, userId) => {
  try {
    const [rows] = await db.query(
      'SELECT * FROM categories WHERE id = ? AND owner_id = ?',
      [categoryId, userId]
    );
    
    if (rows.length === 0) {
      return null;
    }
    
    return rows[0];
  } catch (error) {
    throw error;
  }
};

// Update a category
const updateCategory = async (categoryId, categoryData, userId) => {
  try {
    const query = `
      UPDATE categories 
      SET 
        name = ?
      WHERE id = ? AND owner_id = ?`;

    const [result] = await db.query(
      query,
      [
        categoryData.name,
        categoryId,
        userId
      ]
    );
    
    if (result.affectedRows === 0) {
      return null;
    }
    
    return { id: categoryId, ...categoryData };
  } catch (error) {
    throw error;
  }
};

// Delete a category
const deleteCategory = async (categoryId, userId) => {
  try {
    // First update any subcategories to set their category_id to null
    await db.query(
      'UPDATE subcategories SET category_id = NULL WHERE category_id = ?',
      [categoryId]
    );
    
    // Then delete the category
    const [result] = await db.query(
      'DELETE FROM categories WHERE id = ? AND owner_id = ?',
      [categoryId, userId]
    );
    
    return result.affectedRows > 0;
  } catch (error) {
    throw error;
  }
};

// Check if a category name is unique for a user
const checkUnique = async (name, userId, excludeId = null) => {
  try {
    let query = 'SELECT COUNT(*) as count FROM categories WHERE owner_id = ? AND name = ?';
    let params = [userId, name];
    
    // If excludeId is provided, exclude that category from the check
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
  createCategory,
  getCategoriesByUserId,
  getCategoryById,
  updateCategory,
  deleteCategory,
  checkUnique
};