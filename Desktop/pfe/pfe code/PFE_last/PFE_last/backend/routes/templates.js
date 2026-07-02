const express = require('express');
const router = express.Router();
const templateController = require('../controllers/templateController');
const { verifyToken } = require('../middleware/authMiddleware');
const path = require('path');
const fs = require('fs');

// Helper function to handle file uploads with express-fileupload
const handleFileUpload = (req, res, next) => {
  // If no files were uploaded or no preview_image field, just continue
  if (!req.files || !req.files.preview_image) {
    return next();
  }
  
  try {
    const uploadDir = path.join(__dirname, '../uploads/templates');
    
    // Create directory if it doesn't exist
    if (!fs.existsSync(uploadDir)) {
      fs.mkdirSync(uploadDir, { recursive: true });
    }
    
    const file = req.files.preview_image;
    const ext = path.extname(file.name);
    const allowedFileTypes = ['.jpg', '.jpeg', '.png', '.gif'];
    
    // Check file type
    if (!allowedFileTypes.includes(ext.toLowerCase())) {
      return res.status(400).json({
        success: false,
        message: 'Only image files are allowed!'
      });
    }
    
    // Check file size (5MB limit)
    if (file.size > 5 * 1024 * 1024) {
      return res.status(400).json({
        success: false,
        message: 'File size exceeds 5MB limit!'
      });
    }
    
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    const fileName = 'template-' + uniqueSuffix + ext;
    const filePath = path.join(uploadDir, fileName);
    
    // Move the file to the upload directory
    file.mv(filePath, (err) => {
      if (err) {
        console.error('Error moving file:', err);
        return res.status(500).json({
          success: false,
          message: 'Error uploading file',
          error: err.message
        });
      }
      
      // Add the file path to the request object
      req.previewImagePath = '/uploads/templates/' + fileName;
      next();
    });
  } catch (error) {
    console.error('Error in file upload handler:', error);
    return res.status(500).json({
      success: false,
      message: 'Error processing file upload',
      error: error.message
    });
  }
};

// Get all templates (predefined for everyone, custom only for the user who created them)
router.get('/', verifyToken, templateController.getAllTemplates);

// Get predefined templates
router.get('/predefined', verifyToken, templateController.getPredefinedTemplates);

// Get user's custom templates
router.get('/custom', verifyToken, templateController.getCustomTemplates);

// Get template by ID
router.get('/:id', verifyToken, templateController.getTemplateById);

// Create new template
router.post('/', verifyToken, handleFileUpload, templateController.createTemplate);

// Update template
router.put('/:id', verifyToken, handleFileUpload, templateController.updateTemplate);

// Delete template (maintenu pour compatibilité avec le code existant, mais utilise la suppression logique)
router.delete('/:id', verifyToken, templateController.deleteTemplate);

// Soft delete template (suppression logique)
router.patch('/:id/soft-delete', verifyToken, templateController.softDeleteTemplate);

module.exports = router;
