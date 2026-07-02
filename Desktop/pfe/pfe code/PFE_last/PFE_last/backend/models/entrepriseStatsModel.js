const db = require('../config/db');
const moment = require('moment');

const EntrepriseStatsModel = {
    async getDashboardCounts(userId) {
        const [facturesResult] = await db.query(
            'SELECT COUNT(*) as count FROM remplissage WHERE type_document = "facture" AND owner_id = ?',
            [userId]
        );
        const [devisResult] = await db.query(
            'SELECT COUNT(*) as count FROM remplissage WHERE type_document = "devis" AND owner_id = ?',
            [userId]
        );
        const [clientsResult] = await db.query(
            'SELECT COUNT(*) as count FROM clients WHERE user_id = ?',
            [userId]
        );
        const [productsResult] = await db.query(
            'SELECT COUNT(*) as count FROM products WHERE owner_id = ?',
            [userId]
        );
        const [montantResult] = await db.query(
            'SELECT SUM(montant_ttc) as total FROM remplissage WHERE type_document = "facture" AND owner_id = ?',
            [userId]
        );
        return {
            facturesCount: facturesResult[0].count || 0,
            devisCount: devisResult[0].count || 0,
            clientsCount: clientsResult[0].count || 0,
            productsCount: productsResult[0].count || 0,
            montantTotal: montantResult[0].total || 0,
        };
    },

    async getRecentClients(userId, limit = 5) {
        const [recentClients] = await db.query(
            'SELECT id, name, email, created_at FROM clients WHERE user_id = ? ORDER BY created_at DESC LIMIT ?',
            [userId, limit]
        );
        return recentClients;
    },

    async getRecentDocuments(userId, limit = 5) {
        const [recentDocs] = await db.query(`
            SELECT r.id, r.type_document, r.serie_number, r.montant_ttc, r.created_at, 
                   c.name, c.last_name 
            FROM remplissage r
            LEFT JOIN clients c ON r.client_id = c.id 
            WHERE r.owner_id = ? 
            ORDER BY r.created_at DESC 
            LIMIT ?
        `, [userId, limit]);
        return recentDocs;
    },

    async getTotalAmounts(userId) {
        const [totalAmounts] = await db.query(
            'SELECT SUM(montant_ht) as total_ht, SUM(montant_tva) as total_tva, SUM(montant_ttc) as total_ttc, SUM(total_remise) as total_remise FROM remplissage WHERE type_document = "facture" AND owner_id = ?',
            [userId]
        );
        return {
            ht: totalAmounts[0]?.total_ht || 0, // Alias from SUM(montant_ht)
            tva: totalAmounts[0]?.total_tva || 0, // Alias from SUM(montant_tva)
            ttc: totalAmounts[0]?.total_ttc || 0,
            remise: totalAmounts[0]?.total_remise || 0,
        };
    },

    async getIncomeChartData(userId, period) {
        let groupBy = '';
        let dateRange = '';

        switch (period) {
            case 'week':
                groupBy = 'DATE_FORMAT(created_at, "%Y-%m-%d")';
                dateRange = `WHERE owner_id = ? AND type_document = 'facture' AND created_at >= DATE_SUB(CURDATE(), INTERVAL 1 WEEK)`;
                break;
            case 'month':
                groupBy = 'DATE_FORMAT(created_at, "%Y-%m-%d")';
                dateRange = `WHERE owner_id = ? AND type_document = 'facture' AND created_at >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)`;
                break;
            case 'quarter':
                groupBy = 'DATE_FORMAT(created_at, "%Y-%u")'; // Group by year-week for quarters
                dateRange = `WHERE owner_id = ? AND type_document = 'facture' AND created_at >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)`;
                break;
            case 'year':
                groupBy = 'DATE_FORMAT(created_at, "%Y-%m")'; // Group by year-month
                dateRange = `WHERE owner_id = ? AND type_document = 'facture' AND created_at >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)`;
                break;
            default: // Default to month if period is invalid
                groupBy = 'DATE_FORMAT(created_at, "%Y-%m-%d")';
                dateRange = `WHERE owner_id = ? AND type_document = 'facture' AND created_at >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)`;
        }

        const query = `
            SELECT ${groupBy} as date, SUM(montant_ttc) as total
            FROM remplissage
            ${dateRange}
            GROUP BY date
            ORDER BY date ASC;
        `;

        const [results] = await db.query(query, [userId]);

        const labels = results.map(r => {
            if (period === 'quarter') return moment(r.date + '-1', 'YYYY-WW-E').format('YYYY-MM-DD'); // Adjust week format
            if (period === 'year') return moment(r.date, 'YYYY-MM').format('MMM YYYY');
            return moment(r.date).format('DD MMM');
        });
        const values = results.map(r => r.total);

        return { labels, values };
    },

    async getDocumentDistribution(userId) {
        const query = `
            SELECT type_document, COUNT(*) as count, SUM(montant_ttc) as total_amount
            FROM remplissage
            WHERE owner_id = ? AND (type_document = 'facture' OR type_document = 'devis')
            GROUP BY type_document;
        `;
        const [results] = await db.query(query, [userId]);

        const labels = [];
        const counts = [];
        const amounts = [];

        const factureData = results.find(r => r.type_document === 'facture');
        const devisData = results.find(r => r.type_document === 'devis');

        if (factureData) {
            labels.push('Factures');
            counts.push(factureData.count);
            amounts.push(factureData.total_amount);
        } else {
            labels.push('Factures');
            counts.push(0);
            amounts.push(0);
        }

        if (devisData) {
            labels.push('Devis');
            counts.push(devisData.count);
            amounts.push(devisData.total_amount);
        } else {
            labels.push('Devis');
            counts.push(0);
            amounts.push(0);
        }
        return { labels, counts, amounts };
    },

    async getProductStatistics(userId) {
        const [totalProductsResult] = await db.query(
            'SELECT COUNT(*) as count FROM products WHERE owner_id = ?',
            [userId]
        );

        const [productsBySubCategory] = await db.query(`
            SELECT s.name as nom_sous_categorie, COUNT(p.id) as product_count, SUM(p.unit_price * p.stock_quantity) as total_value
            FROM products p
            JOIN subcategories s ON p.subcategory_id = s.id
            WHERE p.owner_id = ?
            GROUP BY s.name
        `, [userId]);

        const [lowStockProducts] = await db.query(
            'SELECT name, stock_quantity, unit_price FROM products WHERE owner_id = ? AND stock_quantity < 5 ORDER BY stock_quantity ASC LIMIT 10',
            [userId]
        );

        const [totalInventoryValueResult] = await db.query(
            'SELECT SUM(unit_price * stock_quantity) as total_value FROM products WHERE owner_id = ?',
            [userId]
        );

        return {
            totalProducts: totalProductsResult[0].count || 0,
            subcategories: {
                labels: productsBySubCategory.map(item => item.nom_sous_categorie),
                counts: productsBySubCategory.map(item => item.product_count),
                values: productsBySubCategory.map(item => item.total_value || 0)
            },
            lowStockProducts: lowStockProducts.map(p => ({ name: p.name, stock_quantity: p.stock_quantity, unit_price: p.unit_price || 0 })),
            totalValue: totalInventoryValueResult[0].total_value || 0
        };
    },

    async getClientGrowthData(userId, timeRange = 'year') {
        let dateFormat;
        let groupBy;
        let monthsLookback;
        let queryDateFormat;

        switch(timeRange) {
            case 'week':
                queryDateFormat = '%Y-%m-%d'; // Daily for the last week
                groupBy = 'DATE(created_at)';
                monthsLookback = 1/4; // Approx 1 week in terms of months for cutoff
                break;
            case 'month':
                queryDateFormat = '%Y-%m-%d'; // Daily for the last month
                groupBy = 'DATE(created_at)';
                monthsLookback = 1;
                break;
            case 'quarter':
                queryDateFormat = '%Y-%u'; // Weekly for the last quarter (3 months)
                groupBy = 'YEARWEEK(created_at, 1)';
                monthsLookback = 3;
                break;
            case 'year':
            default:
                queryDateFormat = '%Y-%m'; // Monthly for the last year
                groupBy = 'YEAR(created_at), MONTH(created_at)';
                monthsLookback = 12;
                break;
        }

        const cutoffDate = moment().subtract(monthsLookback * 30, 'days').format('YYYY-MM-DD HH:mm:ss');

        const query = `
            SELECT 
                DATE_FORMAT(created_at, ?) as period, 
                COUNT(*) as count
            FROM clients
            WHERE user_id = ? AND created_at >= ?
            GROUP BY ${groupBy}
            ORDER BY period ASC
        `;
        
        const [clientsData] = await db.query(query, [queryDateFormat, userId, cutoffDate]);

        const labels = clientsData.map(entry => {
            if (timeRange === 'year') return moment(entry.period, 'YYYY-MM').format('MMM YYYY');
            if (timeRange === 'quarter') return moment(entry.period + '-1', 'YYYY-WW-E').format('YYYY-MM-DD'); // Week format
            return moment(entry.period).format('DD MMM');
        });
        const values = clientsData.map(entry => entry.count);

        return { labels, values };
    }
};


module.exports = EntrepriseStatsModel;
