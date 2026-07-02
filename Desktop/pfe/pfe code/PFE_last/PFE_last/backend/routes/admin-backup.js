/**
 * admin-backup.js - Routes for admin database backup
 * Provides API endpoints to create database backups
 */

const express = require('express');
const router = express.Router();
const fs = require('fs');
const path = require('path');
const { verifyToken, requireAdminRole } = require('../middleware/authMiddleware');
const backupService = require('../services/backupService');

// Get the backup directory path
const backupDir = path.join(__dirname, '..', 'backup');

/**
 * @route   GET /api/admin/backup-database
 * @desc    Generate and download a database backup
 * @access  Admin only
 */
router.get('/backup-database', verifyToken, requireAdminRole, async (req, res) => {
  let backupFilePath = null;
  
  try {
    // Create the database backup
    backupFilePath = await backupService.createDatabaseBackup();
    
    // Check if file exists
    if (!fs.existsSync(backupFilePath)) {
      return res.status(500).json({
        success: false,
        message: 'Failed to create backup file'
      });
    }
    
    // Set headers for file download
    const filename = path.basename(backupFilePath);
    res.setHeader('Content-Type', 'application/sql');
    res.setHeader('Content-Disposition', `attachment; filename=${filename}`);
    
    // Stream the file to the client
    const fileStream = fs.createReadStream(backupFilePath);
    fileStream.pipe(res);
    
    // Keep the backup file in the backup directory
    // No cleanup needed as we want to keep the backups
    
  } catch (error) {
    console.error('Error in backup route:', error);
    
    // Clean up file if it was created
    if (backupFilePath) {
      backupService.cleanupBackupFile(backupFilePath);
    }
    
    // Send error response
    res.status(500).json({
      success: false,
      message: 'Failed to create database backup',
      error: error.message
    });
  }
});

/**
 * @route   GET /api/admin-backup/download/:filename
 * @desc    Download a specific backup file by filename
 * @access  Admin only
 */
router.get('/download/:filename', verifyToken, requireAdminRole, async (req, res) => {
  try {
    const { filename } = req.params;
    
    // Validate filename to prevent directory traversal attacks
    if (!filename || filename.includes('..') || filename.includes('/') || filename.includes('\\')) {
      return res.status(400).json({
        success: false,
        message: 'Invalid filename'
      });
    }
    
    // Build the path to the backup file
    const filePath = path.join(backupDir, filename);
    
    // Check if file exists
    if (!fs.existsSync(filePath)) {
      return res.status(404).json({
        success: false,
        message: 'Backup file not found'
      });
    }
    
    // Set headers for file download
    res.setHeader('Content-Type', 'application/sql');
    res.setHeader('Content-Disposition', `attachment; filename=${filename}`);
    
    // Stream the file to the client
    const fileStream = fs.createReadStream(filePath);
    fileStream.pipe(res);
    
  } catch (error) {
    console.error('Error downloading backup file:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to download backup file',
      error: error.message
    });
  }
});

/**
 * @route   GET /api/admin-backup/list
 * @desc    List all available database backups
 * @access  Admin only
 */
router.get('/list', verifyToken, requireAdminRole, async (req, res) => {
  try {
    // Read all files in the backup directory
    const files = fs.readdirSync(backupDir);
    
    // Filter for .sql files and get their stats
    const backups = files
      .filter(file => file.endsWith('.sql'))
      .map(file => {
        const filePath = path.join(backupDir, file);
        const stats = fs.statSync(filePath);
        
        return {
          filename: file,
          path: `/backups/${file}`, // URL path for direct download
          size: stats.size,
          created: stats.mtime
        };
      })
      // Sort by creation date (newest first)
      .sort((a, b) => b.created - a.created);
    
    res.json({
      success: true,
      data: backups
    });
  } catch (error) {
    console.error('Error listing backups:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to list database backups',
      error: error.message
    });
  }
});

module.exports = router;
