const express = require('express');
const router = express.Router();
const { verifyToken } = require('../middleware/authMiddleware');
const EntrepriseStatsModel = require('../models/entrepriseStatsModel');

// Get basic statistics (counts)
router.get('/dashboard', verifyToken, async (req, res) => {
    try {
        const userId = req.user.id;
        
        const counts = await EntrepriseStatsModel.getDashboardCounts(userId);
        const recentClients = await EntrepriseStatsModel.getRecentClients(userId);
        const recentDocs = await EntrepriseStatsModel.getRecentDocuments(userId);
        const totals = await EntrepriseStatsModel.getTotalAmounts(userId);

        res.json({
            success: true,
            data: {
                factures: counts.facturesCount,
                devis: counts.devisCount,
                clients: counts.clientsCount,
                products: counts.productsCount,
                montantTotal: counts.montantTotal,
                recentClients,
                recentDocs,
                totals
            }
        });
    } catch (error) {
        console.error('Error fetching dashboard statistics:', error);
        res.status(500).json({
            success: false,
            message: 'Erreur lors de la récupération des statistiques du tableau de bord'
        });
    }
});

// Get client growth statistics
router.get('/client-growth', verifyToken, async (req, res) => {
    try {
        const userId = req.user.id;
        const timeRange = req.query.range || 'year';
        
        const growthData = await EntrepriseStatsModel.getClientGrowthData(userId, timeRange);
        
        res.json({
            success: true,
            data: growthData
        });
    } catch (error) {
        console.error('Error fetching client growth data:', error);
        res.status(500).json({
            success: false,
            message: 'Erreur lors de la récupération des données de croissance client'
        });
    }
});

// Get monthly income data for chart
router.get('/income-chart', verifyToken, async (req, res) => {
    try {
        const userId = req.user.id;
        const timeRange = req.query.range || 'year'; // 'week', 'month', 'quarter', 'year'
        
        const chartData = await EntrepriseStatsModel.getIncomeChartData(userId, timeRange);

        res.json({
            success: true,
            data: chartData
        });
    } catch (error) {
        console.error('Error fetching income chart data:', error);
        res.status(500).json({
            success: false,
            message: 'Erreur lors de la récupération des données du graphique des revenus'
        });
    }
});

// Get document distribution data
router.get('/document-distribution', verifyToken, async (req, res) => {
    try {
        const userId = req.user.id;
        const distributionData = await EntrepriseStatsModel.getDocumentDistribution(userId);
        
        res.json({
            success: true,
            data: distributionData
        });
    } catch (error) {
        console.error('Error fetching document distribution data:', error);
        res.status(500).json({
            success: false,
            message: 'Erreur lors de la récupération des données de distribution de documents'
        });
    }
});

// Get product statistics
router.get('/product-statistics', verifyToken, async (req, res) => {
    try {
        const userId = req.user.id;
        const productStats = await EntrepriseStatsModel.getProductStatistics(userId);
        
        res.json({
            success: true,
            data: productStats
        });
    } catch (error) {
        console.error('Error fetching product statistics:', error);
        res.status(500).json({
            success: false,
            message: 'Erreur lors de la récupération des statistiques de produits'
        });
    }
});

module.exports = router;
