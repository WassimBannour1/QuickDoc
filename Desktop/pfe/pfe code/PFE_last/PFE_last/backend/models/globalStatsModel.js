const db = require('../config/db');
const moment = require('moment');

const GlobalStatsModel = {
    async getDashboardCounts() {
        // Total users across the platform
        const [usersResult] = await db.query(
            'SELECT COUNT(*) as count FROM users'
        );

        // Total enterprises (non-admin users)
        const [enterprisesResult] = await db.query(
            'SELECT COUNT(*) as count FROM users WHERE role != "admin"'
        );

        // Total documents across all users
        const [documentsResult] = await db.query(
            'SELECT COUNT(*) as count FROM remplissage'
        );

        // Total clients across all users
        const [clientsResult] = await db.query(
            'SELECT COUNT(*) as count FROM clients'
        );

        // Total products across all users
        const [productsResult] = await db.query(
            'SELECT COUNT(*) as count FROM products'
        );

        // Total revenue across all users
        const [revenueResult] = await db.query(
            'SELECT SUM(montant_ttc) as total FROM remplissage WHERE type_document = "facture"'
        );

        return {
            usersCount: usersResult[0].count || 0,
            enterprisesCount: enterprisesResult[0].count || 0,
            documentsCount: documentsResult[0].count || 0,
            clientsCount: clientsResult[0].count || 0,
            productsCount: productsResult[0].count || 0,
            totalRevenue: revenueResult[0].total || 0,
        };
    },

    async getRecentUsers(limit = 5) {
        const [recentUsers] = await db.query(`
            SELECT id, name, email, created_at, role, subscription_status
            FROM users 
            ORDER BY created_at DESC 
            LIMIT ?
        `, [limit]);
        
        return recentUsers;
    },

    async getRecentDocuments(limit = 5) {
        const [recentDocs] = await db.query(`
            SELECT r.id, r.type_document, r.serie_number, r.montant_ttc, r.created_at,
                   u.name as enterprise_name, u.email as enterprise_email
            FROM remplissage r
            JOIN users u ON r.owner_id = u.id
            ORDER BY r.created_at DESC
            LIMIT ?
        `, [limit]);

        return recentDocs;
    },

    async getPlatformGrowth(timeRange = 'year') {
        let dateFormat, groupBy;
        const now = moment();
        let startDate;
        
        switch(timeRange) {
            case 'week':
                startDate = moment().subtract(7, 'days').format('YYYY-MM-DD');
                dateFormat = '%Y-%m-%d';
                groupBy = 'DATE_FORMAT(created_at, "%Y-%m-%d")';
                break;
            case 'month':
                startDate = moment().subtract(30, 'days').format('YYYY-MM-DD');
                dateFormat = '%Y-%m-%d';
                groupBy = 'DATE_FORMAT(created_at, "%Y-%m-%d")';
                break;
            case 'quarter':
                startDate = moment().subtract(90, 'days').format('YYYY-MM-DD');
                dateFormat = '%Y-%m-%d';
                groupBy = 'DATE_FORMAT(created_at, "%Y-%m-%d")';
                break;
            case 'year':
            default:
                startDate = moment().subtract(12, 'months').format('YYYY-MM-DD');
                dateFormat = '%Y-%m';
                groupBy = 'DATE_FORMAT(created_at, "%Y-%m")';
                break;
        }

        // User growth over time
        const [userGrowth] = await db.query(`
            SELECT ${groupBy} as date, COUNT(*) as count
            FROM users
            WHERE created_at >= ?
            GROUP BY date
            ORDER BY date ASC
        `, [startDate]);

        // Document growth over time
        const [docGrowth] = await db.query(`
            SELECT ${groupBy} as date, COUNT(*) as count
            FROM remplissage
            WHERE created_at >= ?
            GROUP BY date
            ORDER BY date ASC
        `, [startDate]);

        // Revenue growth over time
        const [revenueGrowth] = await db.query(`
            SELECT ${groupBy} as date, SUM(montant_ttc) as total
            FROM remplissage
            WHERE created_at >= ? AND type_document = 'facture'
            GROUP BY date
            ORDER BY date ASC
        `, [startDate]);

        return {
            userGrowth: userGrowth.map(item => ({
                date: item.date,
                count: item.count
            })),
            docGrowth: docGrowth.map(item => ({
                date: item.date,
                count: item.count
            })),
            revenueGrowth: revenueGrowth.map(item => ({
                date: item.date,
                total: item.total || 0
            }))
        };
    },

    async getSubscriptionDistribution() {
        const [subscriptionData] = await db.query(`
            SELECT subscription_status, COUNT(*) as count
            FROM users
            WHERE role != 'admin'
            GROUP BY subscription_status
        `);

        // Format data for frontend charts
        const labels = [];
        const counts = [];

        subscriptionData.forEach(item => {
            labels.push(item.subscription_status || 'None');
            counts.push(item.count);
        });

        return {
            labels,
            counts,
            data: subscriptionData
        };
    },

    async getRevenueByEnterprise(limit = 10) {
        const [enterpriseRevenue] = await db.query(`
            SELECT u.id, u.name, SUM(r.montant_ttc) as total_revenue, COUNT(r.id) as document_count
            FROM users u
            JOIN remplissage r ON u.id = r.owner_id
            WHERE r.type_document = 'facture'
            GROUP BY u.id
            ORDER BY total_revenue DESC
            LIMIT ?
        `, [limit]);

        return enterpriseRevenue.map(item => ({
            id: item.id,
            name: item.name,
            totalRevenue: item.total_revenue || 0,
            documentCount: item.document_count
        }));
    },

    async getUserActivity(days = 30) {
        const startDate = moment().subtract(days, 'days').format('YYYY-MM-DD');
        
        // Active users (with document creation activity)
        const [activeUsers] = await db.query(`
            SELECT COUNT(DISTINCT owner_id) as count
            FROM remplissage
            WHERE created_at >= ?
        `, [startDate]);
        
        // Total users
        const [totalUsers] = await db.query(`
            SELECT COUNT(*) as count
            FROM users
            WHERE role != 'admin'
        `);
        
        // Activity by document type
        const [activityByDocType] = await db.query(`
            SELECT type_document, COUNT(*) as count
            FROM remplissage
            WHERE created_at >= ?
            GROUP BY type_document
        `, [startDate]);
        
        return {
            activeUsers: activeUsers[0].count || 0,
            totalUsers: totalUsers[0].count || 0,
            activityRate: totalUsers[0].count ? 
                Math.round((activeUsers[0].count / totalUsers[0].count) * 100) : 0,
            activityByDocType: activityByDocType.map(item => ({
                type: item.type_document,
                count: item.count
            }))
        };
    }
};

module.exports = GlobalStatsModel;
