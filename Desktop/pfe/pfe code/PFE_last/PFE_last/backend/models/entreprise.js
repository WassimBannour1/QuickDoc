const db = require('../config/db');

// Create a new entreprise entry
const createEntreprise = async (entrepriseData) => {
  const query = `
    INSERT INTO entreprises (
      siret,
      owner_id,
      nom_entreprise
    ) VALUES (?, ?, ?)`;

  try {
    const [result] = await db.query(
      query, 
      [
        entrepriseData.siret,
        entrepriseData.owner_id,
        entrepriseData.nom_entreprise
      ]
    );
    return result;
  } catch (err) {
    throw err;
  }
};

// Find entreprise by owner_id
const findEntrepriseByOwnerId = async (owner_id) => {
  const query = 'SELECT * FROM entreprises WHERE owner_id = ?';
  
  try {
    const [rows] = await db.query(query, [owner_id]);
    return rows[0];
  } catch (err) {
    throw err;
  }
};

// Find entreprise by SIRET
const findEntrepriseBySiret = async (siret) => {
  const query = 'SELECT * FROM entreprises WHERE siret = ?';
  
  try {
    const [rows] = await db.query(query, [siret]);
    return rows[0];
  } catch (err) {
    throw err;
  }
};

// Update entreprise information
const updateEntreprise = async (id, updateData) => {
  // Construct the query based on the fields to update
  const fields = Object.keys(updateData)
    .filter(key => updateData[key] !== undefined) // Only include fields that have values
    .map(key => `${key} = ?`)
    .join(', ');

  if (!fields) return null; // No fields to update

  const values = Object.keys(updateData)
    .filter(key => updateData[key] !== undefined)
    .map(key => updateData[key]);
  
  values.push(id); // Add the ID for the WHERE clause

  const query = `UPDATE entreprises SET ${fields} WHERE id = ?`;

  try {
    const [result] = await db.query(query, values);
    return result;
  } catch (err) {
    throw err;
  }
};

module.exports = {
  createEntreprise,
  findEntrepriseByOwnerId,
  findEntrepriseBySiret,
  updateEntreprise
};
