const db = require('../config/db');

// Create a new user with verification code
const createUser = (userData, callback) => {
  const query = `
    INSERT INTO users (
      first_name, 
      last_name, 
      email, 
      password, 
      role, 
      verification_code, 
      verification_code_expired,
      reset_code,
      reset_code_expired,
      is_verified
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`;

  db.query(
    query, 
    [
      userData.first_name,
      userData.last_name,
      userData.email,
      userData.password,
      userData.role,
      userData.verification_code,
      userData.verification_code_expired,
      null, // Initial reset_code is null
      null, // Initial reset_code_expired is null
      false // Default is_verified to false
    ],
    (err, results) => {
      if (err) {
        callback(err, null);
      } else {
        callback(null, results);
      }
    }
  );
};

// Find user by email
const findUserByEmail = (email, callback) => {
  const query = 'SELECT * FROM users WHERE email = ?';
  console.log('Searching for email:', email); // Add this log
  
  db.query(query, [email], (err, results) => {
    if (err) {
      console.error('Database query error:', err);
      callback(err, null);
    } else {
      console.log('Query results:', results); // Add this log
      callback(null, results[0]);
    }
  });
};

// Find user by ID
const findUserById = (userId, callback) => {
  const query = 'SELECT * FROM users WHERE id = ?';
  
  db.query(query, [userId], (err, results) => {
    if (err) {
      console.error('Database query error:', err);
      callback(err, null);
    } else {
      callback(null, results[0]);
    }
  });
};

// Find user by ID with Promise
const findUserByIdPromise = async (userId) => {
  return new Promise((resolve, reject) => {
    const query = 'SELECT * FROM users WHERE id = ?';
    
    db.query(query, [userId], (err, results) => {
      if (err) {
        reject(err);
      } else {
        resolve(results[0]);
      }
    });
  });
};

// Verify user's email using verification code
const verifyEmail = (email, verificationCode, callback) => {
  const query = `
    UPDATE users 
    SET is_verified = true 
    WHERE email = ? 
    AND verification_code = ? 
    AND verification_code_expired > NOW()
    AND is_verified = false`;

  db.query(query, [email, verificationCode], (err, results) => {
    if (err) {
      callback(err, null);
    } else {
      callback(null, results.affectedRows > 0);
    }
  });
};

// Update verification code
const updateVerificationCode = (email, newCode, expirationTime, callback) => {
  const query = `
    UPDATE users 
    SET verification_code = ?, 
        verification_code_expired = ? 
    WHERE email = ?`;

  db.query(query, [newCode, expirationTime, email], (err, results) => {
    if (err) {
      callback(err, null);
    } else {
      callback(null, results.affectedRows > 0);
    }
  });
};

module.exports = {
  createUser,
  findUserByEmail,
  findUserById,
  findUserByIdPromise,
  verifyEmail,
  updateVerificationCode
};
