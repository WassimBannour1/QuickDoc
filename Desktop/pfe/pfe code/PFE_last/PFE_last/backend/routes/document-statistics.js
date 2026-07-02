/**
 * document-statistics.js - Routes for document statistics
 * Provides API endpoints to access real document statistics
 */

const express = require('express');
const router = express.Router();
const docStatsService = require('../services/documentStats');
const { verifyToken, requireAdminRole } = require('../middleware/authMiddleware');

/**
 * @route   GET /api/document-statistics
 * @desc    Get comprehensive document statistics
 * @access  Admin only
 */
router.get('/', verifyToken, requireAdminRole, async (req, res) => {
  try {
    const period = req.query.period || 'month';
    const documentStats = await docStatsService.getAllDocumentStatistics(period);
    
    res.json({
      success: true,
      data: documentStats
    });
  } catch (error) {
    console.error('Error fetching document statistics:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch document statistics',
      error: error.message
    });
  }
});

/**
 * @route   GET /api/document-statistics/counts
 * @desc    Get document count statistics only
 * @access  Admin only
 */
router.get('/counts', verifyToken, requireAdminRole, async (req, res) => {
  try {
    const counts = await docStatsService.getDocumentCounts();
    
    res.json({
      success: true,
      data: counts
    });
  } catch (error) {
    console.error('Error fetching document counts:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch document counts',
      error: error.message
    });
  }
});

/**
 * @route   GET /api/document-statistics/growth
 * @desc    Get document growth statistics
 * @access  Admin only
 */
router.get('/growth', verifyToken, requireAdminRole, async (req, res) => {
  try {
    const period = req.query.period || 'month';
    const growth = await docStatsService.getDocumentGrowth(period);
    
    res.json({
      success: true,
      data: growth
    });
  } catch (error) {
    console.error('Error calculating document growth:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to calculate document growth',
      error: error.message
    });
  }
});

/**
 * @route   GET /api/document-statistics/trends
 * @desc    Get document trends statistics
 * @access  Admin only
 */
router.get('/trends', verifyToken, requireAdminRole, async (req, res) => {
  try {
    const months = parseInt(req.query.months) || 12;
    const trends = await docStatsService.getDocumentTrends(months);
    
    res.json({
      success: true,
      data: trends
    });
  } catch (error) {
    console.error('Error fetching document trends:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch document trends',
      error: error.message
    });
  }
});

/**
 * @route   GET /api/document-statistics/financial
 * @desc    Get financial statistics
 * @access  Admin only
 */
router.get('/financial', verifyToken, requireAdminRole, async (req, res) => {
  try {
    const financials = await docStatsService.getFinancialStats();
    
    res.json({
      success: true,
      data: financials
    });
  } catch (error) {
    console.error('Error fetching financial statistics:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch financial statistics',
      error: error.message
    });
  }
});

module.exports = router;
