const db = require('../config/db');

// Create a new client
const createClient = async (clientData) => {
  try {
    const query = `
      INSERT INTO clients (
        user_id,
        owner_id,
        name,
        last_name,
        email,
        phone,
        address,
        cin
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)`;

    const [result] = await db.query(
      query, 
      [
        clientData.user_id,
        clientData.owner_id,
        clientData.name,
        clientData.last_name,
        clientData.email,
        clientData.phone,
        clientData.address,
        clientData.cin
      ]
    );
    
    return { id: result.insertId, ...clientData };
  } catch (error) {
    throw error;
  }
};

// Get all clients for a specific user
const getClientsByUserId = async (userId) => {
  try {
    const [rows] = await db.query(
      'SELECT * FROM clients WHERE user_id = ? OR owner_id = ? ORDER BY created_at DESC',
      [userId, userId]
    );
    return rows;
  } catch (error) {
    throw error;
  }
};

// Get a client by ID
const getClientById = async (clientId, userId) => {
  try {
    const [rows] = await db.query(
      'SELECT * FROM clients WHERE id = ? AND (user_id = ? OR owner_id = ?)',
      [clientId, userId, userId]
    );
    
    if (rows.length === 0) {
      return null;
    }
    
    return rows[0];
  } catch (error) {
    throw error;
  }
};

// Update a client
const updateClient = (clientId, clientData, userId) => {
  return new Promise((resolve, reject) => {
    // Prepare the SET clause for the SQL query
    const setClause = [];
    const queryParams = [];

    // Add each field to the SET clause if it exists in clientData
    if (clientData.name !== undefined) {
      setClause.push('name = ?');
      queryParams.push(clientData.name);
    }
    if (clientData.last_name !== undefined) {
      setClause.push('last_name = ?');
      queryParams.push(clientData.last_name);
    }
    if (clientData.email !== undefined) {
      setClause.push('email = ?');
      queryParams.push(clientData.email);
    }
    if (clientData.phone !== undefined) {
      setClause.push('phone = ?');
      queryParams.push(clientData.phone);
    }
    if (clientData.address !== undefined) {
      setClause.push('address = ?');
      queryParams.push(clientData.address);
    }
    if (clientData.cin !== undefined) {
      setClause.push('CIN = ?');
      queryParams.push(clientData.cin);
    }
    if (clientData.owner_id !== undefined) {
      setClause.push('owner_id = ?');
      queryParams.push(clientData.owner_id);
    }
    if (clientData.user_id !== undefined) {
      setClause.push('user_id = ?');
      queryParams.push(clientData.user_id);
    }

    // If no fields to update, resolve with null
    if (setClause.length === 0) {
      return resolve(null);
    }

    // Add client ID and user ID to query parameters
    queryParams.push(clientId);
    queryParams.push(userId);

    // Construct the SQL query
    const query = `
      UPDATE clients 
      SET ${setClause.join(', ')} 
      WHERE id = ? AND (user_id = ? OR owner_id = ?)
    `;

    // Add owner_id to query parameters for the WHERE clause
    queryParams.push(userId);

    // Execute the query
    db.query(query, queryParams, (error, results) => {
      if (error) {
        return reject(error);
      }

      // If no rows affected, client not found or doesn't belong to user
      if (results.affectedRows === 0) {
        return resolve(null);
      }

      // Get the updated client
      getClientById(clientId, userId)
        .then(client => resolve(client))
        .catch(error => reject(error));
    });
  });
};

// Delete a client
const deleteClient = async (clientId, userId) => {
  try {
    const [result] = await db.query(
      'DELETE FROM clients WHERE id = ? AND (user_id = ? OR owner_id = ?)',
      [clientId, userId, userId]
    );
    
    return result.affectedRows > 0;
  } catch (error) {
    throw error;
  }
};

// Search clients by name, email, or phone
const searchClients = async (searchTerm, userId) => {
  try {
    const searchPattern = `%${searchTerm}%`;
    const [rows] = await db.query(
      `SELECT * FROM clients 
       WHERE (user_id = ? OR owner_id = ?) AND 
       (name LIKE ? OR last_name LIKE ? OR email LIKE ? OR phone LIKE ? OR cin LIKE ?)
       ORDER BY created_at DESC`,
      [userId, userId, searchPattern, searchPattern, searchPattern, searchPattern, searchPattern]
    );
    
    return rows;
  } catch (error) {
    throw error;
  }
};

// Check if a field value is unique
const checkUnique = async (field, value, userId, excludeId = null) => {
  try {
    let query = `SELECT COUNT(*) as count FROM clients WHERE (user_id = ? OR owner_id = ?) AND ${field} = ?`;
    let params = [userId, userId, value];
    
    // If excludeId is provided, exclude that client from the check
    if (excludeId) {
      query += ' AND id != ?';
      params.push(excludeId);
    }
    
    const [rows] = await db.query(query, params);
    return rows[0].count === 0; // Return true if no records found (unique)
  } catch (error) {
    throw error;
  }
};

module.exports = {
  createClient,
  getClientsByUserId,
  getClientById,
  updateClient,
  deleteClient,
  searchClients,
  checkUnique
};