/**
 * documentStats.js - Service for admin statistics related to documents
 * Provides functions to fetch real document statistics from the database
 */

const pool = require('../config/db');
const moment = require('moment');

/**
 * Get total counts for invoices and quotes
 * @returns {Promise} Object containing document count statistics
 */
const getDocumentCounts = async () => {
  try {
    // Get total invoices count with PDF documents
    const [invoiceResult] = await pool.query(
      `SELECT COUNT(DISTINCT r.id) as count 
       FROM remplissage r 
       INNER JOIN document d ON r.id = d.remplissage_id 
       WHERE r.type_document = 'facture'`
    );
    
    // Get total quotes count with PDF documents
    const [quoteResult] = await pool.query(
      `SELECT COUNT(DISTINCT r.id) as count 
       FROM remplissage r 
       INNER JOIN document d ON r.id = d.remplissage_id 
       WHERE r.type_document = 'devis'`
    );
    
    return {
      totalInvoices: invoiceResult[0].count,
      totalQuotations: quoteResult[0].count
    };
  } catch (error) {
    console.error('Error getting document counts:', error);
    throw error;
  }
};

/**
 * Calculate the growth percentage compared to previous period for documents
 * @param {string} period - Time period (day, week, month, year)
 * @returns {Promise} Object containing growth statistics
 */
const getDocumentGrowth = async (period) => {
  try {
    let currentDateFilter, previousDateFilter;
    
    switch (period) {
      case 'day':
        currentDateFilter = 'DATE(r.created_at) = CURDATE()';
        previousDateFilter = 'DATE(r.created_at) = DATE_SUB(CURDATE(), INTERVAL 1 DAY)';
        break;
      case 'week':
        currentDateFilter = 'YEARWEEK(r.created_at, 1) = YEARWEEK(CURDATE(), 1)';
        previousDateFilter = 'YEARWEEK(r.created_at, 1) = YEARWEEK(DATE_SUB(CURDATE(), INTERVAL 1 WEEK), 1)';
        break;
      case 'month':
        currentDateFilter = 'YEAR(r.created_at) = YEAR(CURDATE()) AND MONTH(r.created_at) = MONTH(CURDATE())';
        previousDateFilter = 'EXTRACT(YEAR_MONTH FROM r.created_at) = EXTRACT(YEAR_MONTH FROM DATE_SUB(CURDATE(), INTERVAL 1 MONTH))';
        break;
      case 'year':
        currentDateFilter = 'YEAR(r.created_at) = YEAR(CURDATE())';
        previousDateFilter = 'YEAR(r.created_at) = YEAR(DATE_SUB(CURDATE(), INTERVAL 1 YEAR))';
        break;
      default:
        return { invoiceGrowth: 0, quotationGrowth: 0 }; // No growth calculation for 'all' period
    }
    
    // Calculate invoice growth
    const [currentInvoices] = await pool.query(
      `SELECT COUNT(DISTINCT r.id) as count 
       FROM remplissage r 
       INNER JOIN document d ON r.id = d.remplissage_id 
       WHERE r.type_document = 'facture' AND ${currentDateFilter}`
    );
    
    const [previousInvoices] = await pool.query(
      `SELECT COUNT(DISTINCT r.id) as count 
       FROM remplissage r 
       INNER JOIN document d ON r.id = d.remplissage_id 
       WHERE r.type_document = 'facture' AND ${previousDateFilter}`
    );
    
    // Calculate quote growth
    const [currentQuotes] = await pool.query(
      `SELECT COUNT(DISTINCT r.id) as count 
       FROM remplissage r 
       INNER JOIN document d ON r.id = d.remplissage_id 
       WHERE r.type_document = 'devis' AND ${currentDateFilter}`
    );
    
    const [previousQuotes] = await pool.query(
      `SELECT COUNT(DISTINCT r.id) as count 
       FROM remplissage r 
       INNER JOIN document d ON r.id = d.remplissage_id 
       WHERE r.type_document = 'devis' AND ${previousDateFilter}`
    );
    
    // Calculate percentage growth for invoices
    let invoiceGrowth = 0;
    const currentInvoiceCount = currentInvoices[0].count;
    const previousInvoiceCount = previousInvoices[0].count;
    
    if (previousInvoiceCount > 0) {
      invoiceGrowth = ((currentInvoiceCount - previousInvoiceCount) / previousInvoiceCount) * 100;
    } else if (currentInvoiceCount > 0) {
      invoiceGrowth = 100;
    }
    
    // Calculate percentage growth for quotes
    let quoteGrowth = 0;
    const currentQuoteCount = currentQuotes[0].count;
    const previousQuoteCount = previousQuotes[0].count;
    
    if (previousQuoteCount > 0) {
      quoteGrowth = ((currentQuoteCount - previousQuoteCount) / previousQuoteCount) * 100;
    } else if (currentQuoteCount > 0) {
      quoteGrowth = 100;
    }
    
    return { 
      invoiceGrowth: Math.round(invoiceGrowth * 10) / 10,
      quotationGrowth: Math.round(quoteGrowth * 10) / 10
    };
  } catch (error) {
    console.error('Error calculating document growth:', error);
    throw error;
  }
};

/**
 * Get monthly document counts (invoices and quotes)
 * @param {number} months - Number of months to include
 * @returns {Promise} Object containing monthly document data
 */
const getDocumentTrends = async (months = 12) => {
  try {
    // Get monthly invoice counts
    const [invoiceResults] = await pool.query(
      `SELECT 
        DATE_FORMAT(r.created_at, '%Y-%m') as month,
        COUNT(DISTINCT r.id) as count
      FROM remplissage r
      INNER JOIN document d ON r.id = d.remplissage_id
      WHERE r.created_at >= DATE_SUB(CURDATE(), INTERVAL ? MONTH)
      AND r.type_document = 'facture'
      GROUP BY DATE_FORMAT(r.created_at, '%Y-%m')
      ORDER BY month ASC`,
      [months]
    );
    
    // Get monthly quote counts
    const [quoteResults] = await pool.query(
      `SELECT 
        DATE_FORMAT(r.created_at, '%Y-%m') as month,
        COUNT(DISTINCT r.id) as count
      FROM remplissage r
      INNER JOIN document d ON r.id = d.remplissage_id
      WHERE r.created_at >= DATE_SUB(CURDATE(), INTERVAL ? MONTH)
      AND r.type_document = 'devis'
      GROUP BY DATE_FORMAT(r.created_at, '%Y-%m')
      ORDER BY month ASC`,
      [months]
    );
    
    // Format the results to include all months
    const documentsByMonth = {};
    const today = moment();
    
    for (let i = months - 1; i >= 0; i--) {
      const monthDate = moment().subtract(i, 'months');
      const monthKey = monthDate.format('YYYY-MM');
      
      const invoiceData = invoiceResults.find(item => item.month === monthKey);
      const quoteData = quoteResults.find(item => item.month === monthKey);
      
      documentsByMonth[monthKey] = {
        factures: invoiceData ? invoiceData.count : 0,
        devis: quoteData ? quoteData.count : 0
      };
    }
    
    return { documentsByMonth };
  } catch (error) {
    console.error('Error getting document trends:', error);
    throw error;
  }
};

/**
 * Get financial statistics from the documents
 * @returns {Promise} Object containing financial statistics
 */
const getFinancialStats = async () => {
  try {
    // Get the total financial amounts from invoices
    const [amountResults] = await pool.query(
      `SELECT 
        SUM(r.montant_ht) as totalHT,
        SUM(r.total_remise) as totalRemise,
        SUM(r.total_net_ht) as totalNetHT,
        SUM(r.montant_tva) as totalTVA,
        SUM(r.montant_ttc) as totalTTC
      FROM remplissage r
      INNER JOIN document d ON r.id = d.remplissage_id
      WHERE r.type_document = 'facture'`
    );
    
    // Get monthly revenue
    const [revenueResults] = await pool.query(
      `SELECT 
        DATE_FORMAT(r.created_at, '%Y-%m') as month,
        SUM(r.montant_ttc) as revenue
      FROM remplissage r
      INNER JOIN document d ON r.id = d.remplissage_id
      WHERE r.type_document = 'facture'
      AND r.created_at >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)
      GROUP BY DATE_FORMAT(r.created_at, '%Y-%m')
      ORDER BY month ASC`
    );
    
    // Format the monthly revenue results
    const revenueByMonth = {};
    const today = moment();
    
    for (let i = 11; i >= 0; i--) {
      const monthDate = moment().subtract(i, 'months');
      const monthKey = monthDate.format('YYYY-MM');
      
      const monthData = revenueResults.find(item => item.month === monthKey);
      revenueByMonth[monthKey] = monthData ? parseFloat(monthData.revenue) : 0;
    }
    
    // Calculate revenue growth percentage
    const lastMonthKey = Object.keys(revenueByMonth).slice(-1)[0];
    const previousMonthKey = Object.keys(revenueByMonth).slice(-2)[0];
    
    let revenueGrowth = 0;
    if (revenueByMonth[previousMonthKey] > 0) {
      revenueGrowth = ((revenueByMonth[lastMonthKey] - revenueByMonth[previousMonthKey]) / revenueByMonth[previousMonthKey]) * 100;
    } else if (revenueByMonth[lastMonthKey] > 0) {
      revenueGrowth = 100;
    }
    
    return {
      totalRevenue: amountResults[0].totalTTC || 0,
      revenueGrowth: Math.round(revenueGrowth * 10) / 10,
      amounts: {
        totalHT: amountResults[0].totalHT || 0,
        totalRemise: amountResults[0].totalRemise || 0,
        totalNetHT: amountResults[0].totalNetHT || 0,
        totalTVA: amountResults[0].totalTVA || 0,
        totalTTC: amountResults[0].totalTTC || 0
      },
      revenueByMonth
    };
  } catch (error) {
    console.error('Error getting financial statistics:', error);
    throw error;
  }
};

/**
 * Get all document statistics in a single call
 * @param {string} period - Time period filter (day, week, month, year, all)
 * @returns {Promise} Comprehensive document statistics
 */
const getAllDocumentStatistics = async (period = 'month') => {
  try {
    // Run all queries in parallel for better performance
    const [counts, growth, trends, financials] = await Promise.all([
      getDocumentCounts(),
      getDocumentGrowth(period),
      getDocumentTrends(12),
      getFinancialStats()
    ]);
    
    // Combine all statistics
    return {
      ...counts,
      ...growth,
      ...trends,
      ...financials
    };
  } catch (error) {
    console.error('Error getting all document statistics:', error);
    throw error;
  }
};

module.exports = {
  getDocumentCounts,
  getDocumentGrowth,
  getDocumentTrends,
  getFinancialStats,
  getAllDocumentStatistics
};
