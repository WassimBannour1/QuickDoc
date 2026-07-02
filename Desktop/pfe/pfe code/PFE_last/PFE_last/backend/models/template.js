const db = require('../config/db');

class Template {
  // Get all templates (predefined for everyone, custom only for the user who created them)
  static async getAllTemplates(userId, docType = null) {
    let query = `
      SELECT * FROM templates 
      WHERE (type = 'predefined' OR (type = 'custom' AND created_by = ?))
      AND (isdeleted IS NULL OR isdeleted = 0)
    `;
    
    let params = [userId];
    
    // Add Doc_type filter if specified
    if (docType) {
      query += ` AND Doc_type = ?`;
      params.push(docType);
    }
    
    query += ` ORDER BY created_at DESC`;
    
    try {
      const [rows] = await db.query(query, params);
      return rows;
    } catch (error) {
      console.error('Error in getAllTemplates:', error);
      throw error;
    }
  }

  // Get all predefined templates
  static async getPredefinedTemplates(docType = null) {
    let query = `
      SELECT * FROM templates 
      WHERE type = 'predefined'
      AND (isdeleted IS NULL OR isdeleted = 0)
    `;
    
    let params = [];
    
    // Add Doc_type filter if specified
    if (docType) {
      query += ` AND Doc_type = ?`;
      params.push(docType);
    }
    
    query += ` ORDER BY created_at DESC`;
    
    try {
      const [rows] = await db.query(query, params);
      return rows;
    } catch (error) {
      console.error('Error in getPredefinedTemplates:', error);
      throw error;
    }
  }

  // Get user's custom templates
  static async getCustomTemplates(userId, docType = null) {
    let query = `
      SELECT * FROM templates 
      WHERE type = 'custom' AND created_by = ?
      AND (isdeleted IS NULL OR isdeleted = 0)
    `;
    
    let params = [userId];
    
    // Add Doc_type filter if specified - Commenting this out to show all templates
    /*
    if (docType) {
      query += ` AND Doc_type = ?`;
      params.push(docType);
    }
    */
    
    query += ` ORDER BY created_at DESC`;
    
    try {
      const [rows] = await db.query(query, params);
      return rows;
    } catch (error) {
      console.error('Error in getCustomTemplates:', error);
      throw error;
    }
  }

  // Get template by ID
  static async getTemplateById(id, callback = null) {
    const query = 'SELECT * FROM templates WHERE id = ?';
    try {
      const [rows] = await db.query(query, [id]);
      
      // If a callback is provided, use it (for compatibility with older code)
      if (callback && typeof callback === 'function') {
        callback(null, rows);
        return;
      }
      
      return rows;
    } catch (error) {
      console.error(`Error in getTemplateById for ID ${id}:`, error);
      
      // If a callback is provided, use it (for compatibility with older code)
      if (callback && typeof callback === 'function') {
        callback(error, []);
        return;
      }
      
      throw error;
    }
  }

  // Create new template
  static async createTemplate(templateData, callback = null) {
    try {
      console.log('Model - Creating template with type:', templateData.type);
      
      const query = `
        INSERT INTO templates 
        (name, type, created_by, html_structure, design_config, Doc_type) 
        VALUES (?, ?, ?, ?, ?, ?)
      `;
      
      const values = [
        templateData.name,
        templateData.type,
        templateData.created_by,
        templateData.html_structure,
        JSON.stringify(templateData.design_config),
        templateData.Doc_type || 'facture' // Default to 'facture' if not specified
      ];
      
      const [result] = await db.query(query, values);
      
      // If a callback is provided for backward compatibility
      if (callback && typeof callback === 'function') {
        callback(null, result);
        return;
      }
      
      return result;
    } catch (error) {
      console.error('Error in createTemplate:', error);
      
      // If a callback is provided for backward compatibility
      if (callback && typeof callback === 'function') {
        callback(error, null);
        return;
      }
      
      throw error;
    }
  }

  // Update template
  static async updateTemplate(id, templateData) {
    try {
      console.log(`Updating template with ID ${id}...`);
      console.log(`Template data for update:`, templateData);
      
      // Suppression de la vérification du nom - On permet de garder le même nom lors de la mise à jour
      
      const query = `
        UPDATE templates 
        SET name = ?, 
            html_structure = ?, 
            design_config = ?, 
            Doc_type = ? 
        WHERE id = ? AND created_by = ?
      `;
      
      const values = [
        templateData.name,
        templateData.html_structure,
        JSON.stringify(templateData.design_config),
        templateData.Doc_type || 'facture', // Default to 'facture' if not specified
        id,
        templateData.created_by
      ];
      
      console.log(`Update query: ${query}`);
      console.log(`Update values:`, values);
      
      const [result] = await db.query(query, values);
      console.log(`Template update result:`, result);
      return result;
    } catch (error) {
      console.error(`Error in updateTemplate for ID ${id}:`, error);
      throw error;
    }
  }

  // Delete template (physical deletion)
  static deleteTemplate(id, userId, callback) {
    const query = 'DELETE FROM templates WHERE id = ? AND created_by = ?';
    db.query(query, [id, userId], callback);
  }
  
  // Soft delete template (logical deletion)
  static async softDeleteTemplate(id, userId) {
    const query = 'UPDATE templates SET isdeleted = 1 WHERE id = ? AND created_by = ?';
    try {
      const [result] = await db.query(query, [id, userId]);
      return result;
    } catch (error) {
      console.error(`Error in softDeleteTemplate for ID ${id}:`, error);
      throw error;
    }
  }
}

module.exports = Template;
