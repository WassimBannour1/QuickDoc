/**
 * staticadmin.js - Service for admin statistics related to users
 * Provides functions to fetch real user statistics from the database
 */

const pool = require('../config/db');
const moment = require('moment');

/**
 * Get total number of users and distribution by role
 * @returns {Promise} Object containing user count statistics
 */
const getUserCounts = async () => {
  try {
    // Get total users count
    const [totalResult] = await pool.query(
      'SELECT COUNT(*) as total FROM users'
    );
    
    // Get counts by role
    const [roleResults] = await pool.query(
      'SELECT role, COUNT(*) as count FROM users GROUP BY role'
    );
    
    // Get count of deactivated accounts (is_verified = 0)
    const [deactivatedResult] = await pool.query(
      'SELECT COUNT(*) as count FROM users WHERE is_verified = 0'
    );
    
    console.log('Deactivated users query result:', deactivatedResult);
    
    // Get count of deactivated accounts by role
    const [deactivatedByRoleResults] = await pool.query(
      'SELECT role, COUNT(*) as count FROM users WHERE is_verified = 0 GROUP BY role'
    );
    
    // Format the role distribution data
    const roleDistribution = { admin: 0, enterprise_admin: 0, client: 0 };
    roleResults.forEach(row => {
      roleDistribution[row.role] = row.count;
    });
    
    // Format the deactivated role distribution data
    const deactivatedRoleDistribution = { admin: 0, enterprise_admin: 0, client: 0 };
    deactivatedByRoleResults.forEach(row => {
      deactivatedRoleDistribution[row.role] = row.count;
    });
    
    return {
      totalUsers: totalResult[0].total,
      usersByRole: roleDistribution,
      deactivatedUsers: deactivatedResult[0].count,
      deactivatedByRole: deactivatedRoleDistribution
    };
  } catch (error) {
    console.error('Error getting user counts:', error);
    throw error;
  }
};

/**
 * Get new users registered in the current period (day, week, month, year)
 * @param {string} period - Time period (day, week, month, year, all)
 * @returns {Promise} Object containing new user statistics
 */
const getNewUsers = async (period) => {
  try {
    let dateFilter = '';
    
    switch (period) {
      case 'day':
        dateFilter = 'WHERE DATE(created_at) = CURDATE()';
        break;
      case 'week':
        dateFilter = 'WHERE YEARWEEK(created_at, 1) = YEARWEEK(CURDATE(), 1)';
        break;
      case 'month':
        dateFilter = 'WHERE YEAR(created_at) = YEAR(CURDATE()) AND MONTH(created_at) = MONTH(CURDATE())';
        break;
      case 'year':
        dateFilter = 'WHERE YEAR(created_at) = YEAR(CURDATE())';
        break;
      default:
        dateFilter = '';
    }
    
    const query = `SELECT COUNT(*) as count FROM users ${dateFilter}`;
    const [result] = await pool.query(query);
    
    return { newUsers: result[0].count };
  } catch (error) {
    console.error('Error getting new users count:', error);
    throw error;
  }
};

/**
 * Calculate the growth percentage compared to previous period
 * @param {string} period - Time period (day, week, month, year)
 * @returns {Promise} Object containing growth statistics
 */
const getUserGrowth = async (period) => {
  try {
    let currentQuery, previousQuery;
    
    switch (period) {
      case 'day':
        currentQuery = 'SELECT COUNT(*) as count FROM users WHERE DATE(created_at) = CURDATE()';
        previousQuery = 'SELECT COUNT(*) as count FROM users WHERE DATE(created_at) = DATE_SUB(CURDATE(), INTERVAL 1 DAY)';
        break;
      case 'week':
        currentQuery = 'SELECT COUNT(*) as count FROM users WHERE YEARWEEK(created_at, 1) = YEARWEEK(CURDATE(), 1)';
        previousQuery = 'SELECT COUNT(*) as count FROM users WHERE YEARWEEK(created_at, 1) = YEARWEEK(DATE_SUB(CURDATE(), INTERVAL 1 WEEK), 1)';
        break;
      case 'month':
        currentQuery = 'SELECT COUNT(*) as count FROM users WHERE YEAR(created_at) = YEAR(CURDATE()) AND MONTH(created_at) = MONTH(CURDATE())';
        previousQuery = 'SELECT COUNT(*) as count FROM users WHERE EXTRACT(YEAR_MONTH FROM created_at) = EXTRACT(YEAR_MONTH FROM DATE_SUB(CURDATE(), INTERVAL 1 MONTH))';
        break;
      case 'year':
        currentQuery = 'SELECT COUNT(*) as count FROM users WHERE YEAR(created_at) = YEAR(CURDATE())';
        previousQuery = 'SELECT COUNT(*) as count FROM users WHERE YEAR(created_at) = YEAR(DATE_SUB(CURDATE(), INTERVAL 1 YEAR))';
        break;
      default:
        return { growth: 0 }; // No growth calculation for 'all' period
    }
    
    const [currentResult] = await pool.query(currentQuery);
    const [previousResult] = await pool.query(previousQuery);
    
    const currentCount = currentResult[0].count;
    const previousCount = previousResult[0].count;
    
    // Calculate percentage growth
    let growth = 0;
    if (previousCount > 0) {
      growth = ((currentCount - previousCount) / previousCount) * 100;
    } else if (currentCount > 0) {
      growth = 100; // If previous period had no users but current does, 100% growth
    }
    
    return { userGrowth: Math.round(growth * 10) / 10 }; // Round to 1 decimal place
  } catch (error) {
    console.error('Error calculating user growth:', error);
    throw error;
  }
};

/**
 * Get list of recently registered users
 * @param {number} limit - Number of recent users to return
 * @returns {Promise} Array of recent user objects
 */
const getRecentUsers = async (limit = 5) => {
  try {
    const [users] = await pool.query(
      'SELECT id, first_name, last_name, email, role, created_at FROM users ORDER BY created_at DESC LIMIT ?',
      [limit]
    );
    
    return { recentUsers: users };
  } catch (error) {
    console.error('Error getting recent users:', error);
    throw error;
  }
};

/**
 * Get user registration trends (count by month)
 * @param {number} months - Number of months to include
 * @returns {Promise} Object containing monthly registration data
 */
const getUserRegistrationTrends = async (months = 6) => {
  try {
    const [results] = await pool.query(
      `SELECT 
        DATE_FORMAT(created_at, '%Y-%m') as month,
        COUNT(*) as count
      FROM users
      WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL ? MONTH)
      GROUP BY DATE_FORMAT(created_at, '%Y-%m')
      ORDER BY month ASC`,
      [months]
    );
    
    // Fill in missing months with zero counts
    const trends = [];
    const today = moment();
    
    for (let i = months - 1; i >= 0; i--) {
      const monthDate = moment().subtract(i, 'months');
      const monthKey = monthDate.format('YYYY-MM');
      
      const existingData = results.find(item => item.month === monthKey);
      
      trends.push({
        month: monthKey,
        count: existingData ? existingData.count : 0,
        label: monthDate.format('MMM YYYY')
      });
    }
    
    return { registrationTrends: trends };
  } catch (error) {
    console.error('Error getting user registration trends:', error);
    throw error;
  }
};

/**
 * Get all user statistics in a single call
 * @param {string} period - Time period filter (day, week, month, year, all)
 * @returns {Promise} Comprehensive user statistics
 */
const getAllUserStatistics = async (period = 'month') => {
  try {
    // Run all queries in parallel for better performance
    const [counts, newUsers, growth, recentUsers, trends] = await Promise.all([
      getUserCounts(),
      getNewUsers(period),
      getUserGrowth(period),
      getRecentUsers(10),
      getUserRegistrationTrends(12)
    ]);
    
    // Combine all statistics
    return {
      ...counts,
      ...newUsers,
      ...growth,
      ...recentUsers,
      ...trends
    };
  } catch (error) {
    console.error('Error getting all user statistics:', error);
    throw error;
  }
};

module.exports = {
  getUserCounts,
  getNewUsers,
  getUserGrowth,
  getRecentUsers,
  getUserRegistrationTrends,
  getAllUserStatistics
};
