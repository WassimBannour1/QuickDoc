const Template = require('../models/template');
const fs = require('fs');
const path = require('path');

// Get all templates (predefined for everyone, custom only for the user who created them)
exports.getAllTemplates = async (req, res) => {
  const userId = req.user.id; // Assuming user info is in the request after authentication
  const docType = req.query.docType; // Get document type from query parameters

  try {
    const results = await Template.getAllTemplates(userId, docType);
    
    return res.status(200).json({
      success: true,
      count: results.length,
      data: results
    });
  } catch (err) {
    console.error('Error fetching templates:', err);
    return res.status(500).json({ 
      success: false, 
      message: 'Error fetching templates', 
      error: err.message 
    });
  }
};

// Get predefined templates
exports.getPredefinedTemplates = async (req, res) => {
  const docType = req.query.docType; // Get document type from query parameters

  try {
    const results = await Template.getPredefinedTemplates(docType);
    
    return res.status(200).json({
      success: true,
      count: results.length,
      data: results
    });
  } catch (err) {
    console.error('Error fetching predefined templates:', err);
    return res.status(500).json({ 
      success: false, 
      message: 'Error fetching predefined templates', 
      error: err.message 
    });
  }
};

// Get user's custom templates
exports.getCustomTemplates = async (req, res) => {
  const userId = req.user.id; // Assuming user info is in the request after authentication
  const docType = req.query.docType; // Get document type from query parameters

  try {
    const results = await Template.getCustomTemplates(userId, docType);
    
    return res.status(200).json({
      success: true,
      count: results.length,
      data: results
    });
  } catch (err) {
    console.error('Error fetching custom templates:', err);
    return res.status(500).json({ 
      success: false, 
      message: 'Error fetching custom templates', 
      error: err.message 
    });
  }
};

// Get template by ID
exports.getTemplateById = async (req, res) => {
  const id = req.params.id;

  try {
    const results = await Template.getTemplateById(id);
    
    if (results.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Template not found'
      });
    }
    
    return res.status(200).json({
      success: true,
      data: results[0]
    });
  } catch (err) {
    console.error('Error fetching template:', err);
    return res.status(500).json({ 
      success: false, 
      message: 'Error fetching template', 
      error: err.message 
    });
  }
};

// Create new template
exports.createTemplate = async (req, res) => {
  try {
    console.log('Backend - Creating template with type:', req.body.type);
    
    // Extract template data from request body
    const templateData = {
      name: req.body.name ? req.body.name.trim() : '',
      type: req.body.type || 'custom', // Default to custom if not specified
      created_by: req.user.id, // Assuming user ID is available from authentication middleware
      html_structure: req.body.html_structure,
      design_config: req.body.design_config,
      Doc_type: req.body.Doc_type || 'facture', // Default to 'facture' if not specified
      preview_image_path: req.previewImagePath || null // Use the path set by handleFileUpload middleware
    };

    // Validate required fields
    if (!templateData.name) {
      return res.status(400).json({
        success: false,
        message: 'Le nom du template est obligatoire'
      });
    }

    if (!templateData.html_structure) {
      return res.status(400).json({
        success: false,
        message: 'La structure HTML est obligatoire',
        field: 'html_structure'
      });
    }

    // Validate Doc_type field
    if (templateData.Doc_type && !['facture', 'devis'].includes(templateData.Doc_type.toLowerCase())) {
      return res.status(400).json({
        success: false,
        message: 'Le type de document doit être "facture" ou "devis"',
        field: 'Doc_type'
      });
    }

    // Create template in database
    const result = await Template.createTemplate(templateData);
    
    if (!result || !result.insertId) {
      throw new Error('Erreur lors de la création du template');
    }
    
    // Get the created template
    const createdTemplate = await Template.getTemplateById(result.insertId);
    
    if (!createdTemplate || createdTemplate.length === 0) {
      throw new Error('Template créé mais impossible de récupérer les détails');
    }
    
    return res.status(201).json({
      success: true,
      message: 'Template créé avec succès',
      data: createdTemplate[0]
    });
    
  } catch (error) {
    console.error('Error creating template:', error);
    return res.status(500).json({
      success: false,
      message: 'Erreur lors de la création du template: ' + error.message
    });
  }
};

// Update template
exports.updateTemplate = async (req, res) => {
  const id = req.params.id;
  const userId = req.user.id; // Assuming user info is in the request after authentication
  
  try {
    console.log(`Controller - Updating template with ID ${id}...`);
    
    // First check if the template exists and belongs to the user
    const results = await Template.getTemplateById(id);
    
    if (results.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Template not found'
      });
    }
    
    const template = results[0];
    
    // Check if the template belongs to the user or is predefined
    if (template.created_by !== userId && template.type === 'custom') {
      return res.status(403).json({
        success: false,
        message: 'Not authorized to update this template'
      });
    }
    
    // Parse design_config if it's a string
    let designConfig = req.body.design_config;
    if (typeof designConfig === 'string') {
      try {
        designConfig = JSON.parse(designConfig);
      } catch (error) {
        console.error('Error parsing design_config:', error);
        return res.status(400).json({
          success: false,
          message: 'Invalid design_config format'
        });
      }
    }
    
    // Get Doc_type from request or use existing value
    const docType = req.body.Doc_type || template.Doc_type || 'facture';
    
    // Validate Doc_type field
    if (docType && !['facture', 'devis'].includes(docType.toLowerCase())) {
      return res.status(400).json({
        success: false,
        message: 'Le type de document doit être "facture" ou "devis"',
        field: 'Doc_type'
      });
    }
    
    // Get preview image path from middleware or use existing value
    const previewImagePath = req.previewImagePath || template.preview_image_path;
    
    // Get the new name from request or use existing
    const newName = req.body.name || template.name;
    
    const templateData = {
      name: newName,
      created_by: userId,
      html_structure: req.body.html_structure || template.html_structure,
      design_config: designConfig || template.design_config,
      Doc_type: docType,
      preview_image_path: previewImagePath
    };
    
    // Update the template
    const result = await Template.updateTemplate(id, templateData);
    
    if (result.affectedRows === 0) {
      return res.status(404).json({
        success: false,
        message: 'Template not found or not authorized to update'
      });
    }
    
    console.log('Template updated successfully');
    
    return res.status(200).json({
      success: true,
      message: 'Template updated successfully',
      data: { id, ...templateData }
    });
    
  } catch (error) {
    console.error('Error updating template:', error);
    return res.status(500).json({ 
      success: false, 
      message: 'Error updating template', 
      error: error.message 
    });
  }
};

// Delete template (physical deletion - legacy method)
exports.deleteTemplate = async (req, res) => {
  const id = req.params.id;
  const userId = req.user.id; // Assuming user info is in the request after authentication

  try {
    // First check if the template exists and belongs to the user
    const template = await Template.getTemplateById(id);
    
    if (!template || template.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Template not found'
      });
    }
    
    // Check if the template belongs to the user or is predefined
    if (template[0].created_by !== userId && template[0].type === 'custom') {
      return res.status(403).json({
        success: false,
        message: 'Not authorized to delete this template'
      });
    }
    
    // Instead of physical deletion, use soft delete
    await Template.softDeleteTemplate(id, userId);
    
    return res.status(200).json({
      success: true,
      message: 'Template deleted successfully'
    });
  } catch (err) {
    console.error('Error deleting template:', err);
    return res.status(500).json({ 
      success: false, 
      message: 'Error deleting template', 
      error: err.message 
    });
  }
};

// Soft delete template (logical deletion)
exports.softDeleteTemplate = async (req, res) => {
  const id = req.params.id;
  const userId = req.user.id; // Assuming user info is in the request after authentication

  try {
    // First check if the template exists and belongs to the user
    const template = await Template.getTemplateById(id);
    
    if (!template || template.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Template not found'
      });
    }
    
    // Check if the template belongs to the user or is predefined
    if (template[0].created_by !== userId && template[0].type === 'custom') {
      return res.status(403).json({
        success: false,
        message: 'Not authorized to delete this template'
      });
    }
    
    // Mark the template as deleted
    await Template.softDeleteTemplate(id, userId);
    
    return res.status(200).json({
      success: true,
      message: 'Template marked as deleted successfully'
    });
  } catch (err) {
    console.error('Error marking template as deleted:', err);
    return res.status(500).json({ 
      success: false, 
      message: 'Error marking template as deleted', 
      error: err.message 
    });
  }
};
