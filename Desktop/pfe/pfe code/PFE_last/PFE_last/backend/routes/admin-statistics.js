/**
 * admin-statistics.js - Routes for admin statistics
 * Provides API endpoints to access real user statistics
 */

const express = require('express');
const router = express.Router();
const userStatsService = require('../services/userstatic');
const templateStatsService = require('../services/templateStats');
const { verifyToken, requireAdminRole } = require('../middleware/authMiddleware');

/**
 * @route   GET /api/admin-statistics/users
 * @desc    Get comprehensive user statistics
 * @access  Admin only
 */
router.get('/users', verifyToken, requireAdminRole, async (req, res) => {
  try {
    const period = req.query.period || 'month';
    
    // Get both user and template statistics in parallel
    const [userStats, templateStats] = await Promise.all([
      userStatsService.getAllUserStatistics(period),
      templateStatsService.getTemplateCounts()
    ]);
    
    // Combine all statistics
    const combinedStats = {
      ...userStats,
      ...templateStats
    };
    
    res.json({
      success: true,
      data: combinedStats
    });
  } catch (error) {
    console.error('Error fetching statistics:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch statistics',
      error: error.message
    });
  }
});

/**
 * @route   GET /api/admin-statistics/users/counts
 * @desc    Get user count statistics only
 * @access  Admin only
 */
router.get('/users/counts', verifyToken, requireAdminRole, async (req, res) => {
  try {
    const counts = await userStatsService.getUserCounts();
    
    res.json({
      success: true,
      data: counts
    });
  } catch (error) {
    console.error('Error fetching user counts:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch user counts',
      error: error.message
    });
  }
});

/**
 * @route   GET /api/admin-statistics/users/new
 * @desc    Get new user statistics
 * @access  Admin only
 */
router.get('/users/new', verifyToken, requireAdminRole, async (req, res) => {
  try {
    const period = req.query.period || 'month';
    const newUsers = await userStatsService.getNewUsers(period);
    
    res.json({
      success: true,
      data: newUsers
    });
  } catch (error) {
    console.error('Error fetching new users statistics:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch new users statistics',
      error: error.message
    });
  }
});

/**
 * @route   GET /api/admin-statistics/users/growth
 * @desc    Get user growth percentage
 * @access  Admin only
 */
router.get('/users/growth', verifyToken, requireAdminRole, async (req, res) => {
  try {
    const period = req.query.period || 'month';
    const growth = await userStatsService.getUserGrowth(period);
    
    res.json({
      success: true,
      data: growth
    });
  } catch (error) {
    console.error('Error calculating user growth:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to calculate user growth',
      error: error.message
    });
  }
});

/**
 * @route   GET /api/admin-statistics/users/recent
 * @desc    Get recently registered users
 * @access  Admin only
 */
router.get('/users/recent', verifyToken, requireAdminRole, async (req, res) => {
  try {
    const limit = parseInt(req.query.limit) || 10;
    const recentUsers = await userStatsService.getRecentUsers(limit);
    
    res.json({
      success: true,
      data: recentUsers
    });
  } catch (error) {
    console.error('Error fetching recent users:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch recent users',
      error: error.message
    });
  }
});

/**
 * @route   GET /api/admin-statistics/users/trends
 * @desc    Get user registration trends (monthly)
 * @access  Admin only
 */
router.get('/users/trends', verifyToken, requireAdminRole, async (req, res) => {
  try {
    const months = parseInt(req.query.months) || 12;
    const trends = await userStatsService.getUserRegistrationTrends(months);
    
    res.json({
      success: true,
      data: trends
    });
  } catch (error) {
    console.error('Error fetching user registration trends:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch user registration trends',
      error: error.message
    });
  }
});

module.exports = router;
