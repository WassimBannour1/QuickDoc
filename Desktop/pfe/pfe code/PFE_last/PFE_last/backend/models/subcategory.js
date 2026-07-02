const db = require('../config/db');

// Create a new subcategory
const createSubcategory = async (subcategoryData) => {
  try {
    const query = `
      INSERT INTO subcategories (
        category_id,
        name
      ) VALUES (?, ?)`;

    const [result] = await db.query(
      query, 
      [
        subcategoryData.category_id,
        subcategoryData.name
      ]
    );
    
    return { id: result.insertId, ...subcategoryData };
  } catch (error) {
    throw error;
  }
};

// Get all subcategories for a specific category
const getSubcategoriesByCategoryId = async (categoryId) => {
  try {
    const [rows] = await db.query(
      'SELECT * FROM subcategories WHERE category_id = ? ORDER BY name ASC',
      [categoryId]
    );
    return rows;
  } catch (error) {
    throw error;
  }
};

// Get all subcategories for a specific user (via categories)
const getSubcategoriesByUserId = async (userId) => {
  try {
    const [rows] = await db.query(
      `SELECT s.* 
       FROM subcategories s
       JOIN categories c ON s.category_id = c.id
       WHERE c.owner_id = ?
       ORDER BY s.name ASC`,
      [userId]
    );
    return rows;
  } catch (error) {
    throw error;
  }
};

// Get a subcategory by ID
const getSubcategoryById = async (subcategoryId) => {
  try {
    const [rows] = await db.query(
      'SELECT * FROM subcategories WHERE id = ?',
      [subcategoryId]
    );
    
    if (rows.length === 0) {
      return null;
    }
    
    return rows[0];
  } catch (error) {
    throw error;
  }
};

// Update a subcategory
const updateSubcategory = async (subcategoryId, subcategoryData) => {
  try {
    const query = `
      UPDATE subcategories 
      SET 
        category_id = ?,
        name = ?
      WHERE id = ?`;

    const [result] = await db.query(
      query,
      [
        subcategoryData.category_id,
        subcategoryData.name,
        subcategoryId
      ]
    );
    
    if (result.affectedRows === 0) {
      return null;
    }
    
    return { id: subcategoryId, ...subcategoryData };
  } catch (error) {
    throw error;
  }
};

// Delete a subcategory
const deleteSubcategory = async (subcategoryId) => {
  try {
    // First update any products to set their subcategory_id to null
    await db.query(
      'UPDATE products SET subcategory_id = NULL WHERE subcategory_id = ?',
      [subcategoryId]
    );
    
    // Then delete the subcategory
    const [result] = await db.query(
      'DELETE FROM subcategories WHERE id = ?',
      [subcategoryId]
    );
    
    return result.affectedRows > 0;
  } catch (error) {
    throw error;
  }
};

// Check if a subcategory name is unique within a category
const checkUnique = async (name, categoryId, excludeId = null) => {
  try {
    let query = 'SELECT COUNT(*) as count FROM subcategories WHERE category_id = ? AND name = ?';
    let params = [categoryId, name];
    
    // If excludeId is provided, exclude that subcategory from the check
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
  createSubcategory,
  getSubcategoriesByCategoryId,
  getSubcategoriesByUserId,
  getSubcategoryById,
  updateSubcategory,
  deleteSubcategory,
  checkUnique
};