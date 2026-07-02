const express = require('express');
const router = express.Router();
const GlobalStatsModel = require('../models/globalStatsModel');
const verifyToken = require('../middleware/verifyToken');
const verifyAdmin = require('../middleware/verifyAdmin');

// Apply middleware to ensure only admin users can access these routes
router.use(verifyToken);
router.use(verifyAdmin);

// Get dashboard statistics for SuperAdmin
router.get('/dashboard', async (req, res) => {
    try {
        // Get dashboard counts
        const counts = await GlobalStatsModel.getDashboardCounts();
        
        // Get recent users
        const recentUsers = await GlobalStatsModel.getRecentUsers(5);
        
        // Get recent documents
        const recentDocs = await GlobalStatsModel.getRecentDocuments(5);
        
        res.json({
            success: true,
            data: {
                users: counts.usersCount,
                enterprises: counts.enterprisesCount,
                documents: counts.documentsCount,
                clients: counts.clientsCount,
                products: counts.productsCount,
                totalRevenue: counts.totalRevenue,
                recentUsers,
                recentDocs
            }
        });
    } catch (error) {
        console.error('Error fetching SuperAdmin dashboard data:', error);
        res.status(500).json({
            success: false,
            message: 'Failed to fetch SuperAdmin dashboard data',
            error: error.message
        });
    }
});

// Get platform growth data
router.get('/platform-growth', async (req, res) => {
    try {
        const timeRange = req.query.timeRange || 'year';
        const growthData = await GlobalStatsModel.getPlatformGrowth(timeRange);
        
        res.json({
            success: true,
            data: growthData
        });
    } catch (error) {
        console.error('Error fetching platform growth data:', error);
        res.status(500).json({
            success: false,
            message: 'Failed to fetch platform growth data',
            error: error.message
        });
    }
});

// Get subscription distribution
router.get('/subscription-distribution', async (req, res) => {
    try {
        const distributionData = await GlobalStatsModel.getSubscriptionDistribution();
        
        res.json({
            success: true,
            data: distributionData
        });
    } catch (error) {
        console.error('Error fetching subscription distribution data:', error);
        res.status(500).json({
            success: false,
            message: 'Failed to fetch subscription distribution data',
            error: error.message
        });
    }
});

// Get top enterprises by revenue
router.get('/top-enterprises', async (req, res) => {
    try {
        const limit = req.query.limit || 10;
        const enterpriseData = await GlobalStatsModel.getRevenueByEnterprise(limit);
        
        res.json({
            success: true,
            data: enterpriseData
        });
    } catch (error) {
        console.error('Error fetching top enterprises data:', error);
        res.status(500).json({
            success: false,
            message: 'Failed to fetch top enterprises data',
            error: error.message
        });
    }
});

// Get user activity metrics
router.get('/user-activity', async (req, res) => {
    try {
        const days = req.query.days || 30;
        const activityData = await GlobalStatsModel.getUserActivity(days);
        
        res.json({
            success: true,
            data: activityData
        });
    } catch (error) {
        console.error('Error fetching user activity data:', error);
        res.status(500).json({
            success: false,
            message: 'Failed to fetch user activity data',
            error: error.message
        });
    }
});

module.exports = router;
