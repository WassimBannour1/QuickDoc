/**
 * backupService.js - Service for database backup operations
 * Provides functions to backup the MySQL database using direct queries
 */

const fs = require('fs');
const path = require('path');
const os = require('os');
const pool = require('../config/db');

// Set the backup directory to a specific location
const backupDir = path.join(__dirname, '..', 'backup');

// Ensure the backup directory exists
if (!fs.existsSync(backupDir)) {
  fs.mkdirSync(backupDir, { recursive: true });
  console.log(`Created backup directory: ${backupDir}`);
}

/**
 * Get all tables in the database
 * @returns {Promise<Array>} List of table names
 */
async function getAllTables() {
  const [tables] = await pool.query('SHOW TABLES');
  return tables.map(table => Object.values(table)[0]);
}

/**
 * Get the CREATE TABLE statement for a table
 * @param {string} tableName - Name of the table
 * @returns {Promise<string>} CREATE TABLE statement
 */
async function getTableCreateStatement(tableName) {
  const [result] = await pool.query(`SHOW CREATE TABLE \`${tableName}\``);
  return result[0]['Create Table'];
}

/**
 * Get all rows from a table
 * @param {string} tableName - Name of the table
 * @returns {Promise<Array>} Table rows
 */
async function getTableData(tableName) {
  const [rows] = await pool.query(`SELECT * FROM \`${tableName}\``);
  return rows;
}

/**
 * Generate an INSERT statement for a row
 * @param {string} tableName - Name of the table
 * @param {Object} row - Row data
 * @returns {string} INSERT statement
 */
function generateInsertStatement(tableName, row) {
  const columns = Object.keys(row)
    .map(col => `\`${col}\``)
    .join(', ');
    
  const values = Object.values(row)
    .map(val => {
      if (val === null) return 'NULL';
      if (typeof val === 'number') return val;
      if (typeof val === 'boolean') return val ? 1 : 0;
      if (val instanceof Date) return `'${val.toISOString().slice(0, 19).replace('T', ' ')}'`;
      // Escape single quotes for SQL
      return `'${String(val).replace(/'/g, "\\'")}'`;
    })
    .join(', ');
    
  return `INSERT INTO \`${tableName}\` (${columns}) VALUES (${values});`;
}

/**
 * Create a backup of the entire database using direct queries
 * @returns {Promise<string>} Path to the backup file
 */
async function createDatabaseBackup() {
  try {
    // Create a timestamped filename
    const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
    const backupFilePath = path.join(backupDir, `quikdoc_backup_${timestamp}.sql`);
    
    console.log(`Starting database backup to ${backupFilePath}`);
    
    // Get list of all tables
    const tables = await getAllTables();
    console.log(`Found ${tables.length} tables`);
    
    // Create a write stream to the backup file
    const writeStream = fs.createWriteStream(backupFilePath);
    
    // Add header
    writeStream.write(`-- QuikDoc Database Backup\n`);
    writeStream.write(`-- Generated: ${new Date().toISOString()}\n`);
    writeStream.write(`-- ------------------------------------------------------\n\n`);
    
    // Process each table
    for (const tableName of tables) {
      console.log(`Processing table: ${tableName}`);
      
      // Add table drop statement
      writeStream.write(`-- Table structure for table \`${tableName}\`\n`);
      writeStream.write(`DROP TABLE IF EXISTS \`${tableName}\`;\n`);
      
      // Add create table statement
      const createStatement = await getTableCreateStatement(tableName);
      writeStream.write(`${createStatement};\n\n`);
      
      // Get table data
      const rows = await getTableData(tableName);
      
      if (rows.length > 0) {
        writeStream.write(`-- Data for table \`${tableName}\`\n`);
        
        // Generate INSERT statements
        for (const row of rows) {
          const insertStatement = generateInsertStatement(tableName, row);
          writeStream.write(`${insertStatement}\n`);
        }
        
        writeStream.write(`\n`);
      }
    }
    
    // Close the write stream
    writeStream.end();
    
    // Wait for the file to be fully written
    await new Promise((resolve, reject) => {
      writeStream.on('finish', resolve);
      writeStream.on('error', reject);
    });
    
    console.log('Database backup completed successfully');
    
    return backupFilePath;
  } catch (error) {
    console.error('Error creating database backup:', error);
    throw error;
  }
}

/**
 * Clean up temporary backup files
 * @param {string} filePath - Path to file to delete
 */
async function cleanupBackupFile(filePath) {
  try {
    if (fs.existsSync(filePath)) {
      fs.unlinkSync(filePath);
      console.log(`Temporary backup file deleted: ${filePath}`);
    }
  } catch (error) {
    console.error('Error cleaning up backup file:', error);
  }
}

module.exports = {
  createDatabaseBackup,
  cleanupBackupFile
};
