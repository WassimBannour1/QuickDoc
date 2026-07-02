const clientModel = require('../models/client');
const userModel = require('../models/user');

// Create a new client
const createClient = async (req, res) => {
  try {
    // Extract client data from request body
    const clientData = {
      owner_id: req.body.owner_id || req.user.id, // Use provided owner_id or default to current user
      name: req.body.name,
      last_name: req.body.last_name,
      email: req.body.email,
      phone: req.body.phone,
      address: req.body.address,
      cin: req.body.cin
    };

    // Validate required fields
    if (!clientData.name || !clientData.last_name || !clientData.email) {
      return res.status(400).json({
        success: false,
        message: 'Le nom, le prénom et l\'email sont obligatoires'
      });
    }

    // Check if there's a user with the same email and role 'client'
    try {
      // Utiliser une requête SQL directe pour trouver l'utilisateur par email plus rapidement
      const query = `
        SELECT id, role FROM users 
        WHERE email = ? 
        LIMIT 1
      `;
      
      // Exécuter la requête directement via la connexion à la base de données
      const db = require('../config/db');
      const [users] = await db.query(query, [clientData.email]);
      const user = users[0];
      
      if (!user) {
        // Option 1: Create a client without a user account
        clientData.user_id = null;
        
        // Create client in database
        const newClient = await clientModel.createClient(clientData);
        
        // Return success response
        return res.status(201).json({
          success: true,
          message: 'Client créé avec succès (sans compte utilisateur)',
          data: newClient,
          warning: 'Aucun compte utilisateur n\'a été trouvé pour cet email. Le client a été créé sans compte utilisateur associé.'
        });
        
        // Option 2: Return an error (commented out, using Option 1 instead)
        /*
        return res.status(404).json({
          success: false,
          message: 'Aucun compte utilisateur avec cet email n\'existe. Le client doit avoir un compte utilisateur avec le rôle "client".',
          field: 'email'
        });
        */
      }
      
      if (user.role !== 'client') {
        return res.status(400).json({
          success: false,
          message: 'L\'utilisateur associé doit avoir le rôle "client"',
          field: 'email'
        });
      }
      
      // Set the user_id to the found user's id
      clientData.user_id = user.id;
      
    } catch (error) {
      console.error('Error verifying user by email:', error);
      return res.status(500).json({
        success: false,
        message: 'Une erreur est survenue lors de la vérification de l\'utilisateur',
        error: error.message
      });
    }

    // If user_id is explicitly provided (overriding the email match), verify that user
    if (req.body.user_id && req.body.user_id !== clientData.user_id) {
      try {
        const user = await userModel.findUserByIdPromise(req.body.user_id);
        
        if (!user) {
          return res.status(404).json({
            success: false,
            message: 'L\'utilisateur associé n\'existe pas',
            field: 'user_id'
          });
        }
        
        if (user.role !== 'client') {
          return res.status(400).json({
            success: false,
            message: 'L\'utilisateur associé doit avoir le rôle "client"',
            field: 'user_id'
          });
        }
        
        // Override the user_id with the explicitly provided one
        clientData.user_id = req.body.user_id;
      } catch (error) {
        console.error('Error verifying user:', error);
        return res.status(500).json({
          success: false,
          message: 'Une erreur est survenue lors de la vérification de l\'utilisateur',
          error: error.message
        });
      }
    }

    // Check if email is unique
    if (clientData.email) {
      const isEmailUnique = await clientModel.checkUnique('email', clientData.email, clientData.user_id);
      if (!isEmailUnique) {
        return res.status(409).json({
          success: false,
          message: 'Cette adresse email est déjà utilisée',
          field: 'email'
        });
      }
    }

    // Check if CIN is unique
    if (clientData.cin) {
      const isCinUnique = await clientModel.checkUnique('cin', clientData.cin, clientData.user_id);
      if (!isCinUnique) {
        return res.status(409).json({
          success: false,
          message: 'Ce numéro d\'identification est déjà utilisé',
          field: 'cin'
        });
      }
    }

    // Create client in database
    const newClient = await clientModel.createClient(clientData);

    // Return success response
    return res.status(201).json({
      success: true,
      message: 'Client créé avec succès',
      data: newClient
    });
  } catch (error) {
    console.error('Error creating client:', error);
    return res.status(500).json({
      success: false,
      message: 'Une erreur est survenue lors de la création du client',
      error: error.message
    });
  }
};

// Get all clients for the authenticated user
const getClients = async (req, res) => {
  try {
    const userId = req.user.id; // Assuming user ID is available from authentication middleware
    const clients = await clientModel.getClientsByUserId(userId);

    return res.status(200).json({
      success: true,
      data: clients
    });
  } catch (error) {
    console.error('Error fetching clients:', error);
    return res.status(500).json({
      success: false,
      message: 'Une erreur est survenue lors de la récupération des clients',
      error: error.message
    });
  }
};

// Get a specific client by ID
const getClientById = async (req, res) => {
  try {
    const clientId = req.params.id;
    const userId = req.user.id; // Assuming user ID is available from authentication middleware

    const client = await clientModel.getClientById(clientId, userId);

    if (!client) {
      return res.status(404).json({
        success: false,
        message: 'Client non trouvé'
      });
    }

    return res.status(200).json({
      success: true,
      data: client
    });
  } catch (error) {
    console.error('Error fetching client:', error);
    return res.status(500).json({
      success: false,
      message: 'Une erreur est survenue lors de la récupération du client',
      error: error.message
    });
  }
};

// Update a client
const updateClient = async (req, res) => {
  try {
    const clientId = req.params.id;
    const userId = req.user.id; // Assuming user ID is available from authentication middleware

    // Extract client data from request body
    const clientData = {
      name: req.body.name,
      last_name: req.body.last_name,
      email: req.body.email,
      phone: req.body.phone,
      address: req.body.address,
      cin: req.body.cin,
      owner_id: req.body.owner_id || null, // Use provided owner_id or keep it null
      user_id: req.body.user_id // Allow updating user_id if provided
    };

    // Validate required fields
    if (!clientData.name || !clientData.last_name) {
      return res.status(400).json({
        success: false,
        message: 'Le nom et le prénom sont obligatoires'
      });
    }

    // If user_id is provided, verify that the user exists and has role 'client'
    if (clientData.user_id) {
      try {
        const user = await userModel.findUserByIdPromise(clientData.user_id);
        
        if (!user) {
          return res.status(404).json({
            success: false,
            message: 'L\'utilisateur associé n\'existe pas',
            field: 'user_id'
          });
        }
        
        if (user.role !== 'client') {
          return res.status(400).json({
            success: false,
            message: 'L\'utilisateur associé doit avoir le rôle "client"',
            field: 'user_id'
          });
        }
      } catch (error) {
        console.error('Error verifying user:', error);
        return res.status(500).json({
          success: false,
          message: 'Une erreur est survenue lors de la vérification de l\'utilisateur',
          error: error.message
        });
      }
    }

    // Check if email is unique (excluding current client)
    if (clientData.email) {
      const isEmailUnique = await clientModel.checkUnique('email', clientData.email, userId, clientId);
      if (!isEmailUnique) {
        return res.status(409).json({
          success: false,
          message: 'Cette adresse email est déjà utilisée par un autre client',
          field: 'email'
        });
      }
    }

    // Check if CIN is unique (excluding current client)
    if (clientData.cin) {
      const isCinUnique = await clientModel.checkUnique('cin', clientData.cin, userId, clientId);
      if (!isCinUnique) {
        return res.status(409).json({
          success: false,
          message: 'Ce numéro d\'identification est déjà utilisé par un autre client',
          field: 'cin'
        });
      }
    }

    // Update client in database
    const updatedClient = await clientModel.updateClient(clientId, clientData, userId);

    if (!updatedClient) {
      return res.status(404).json({
        success: false,
        message: 'Client non trouvé ou vous n\'avez pas les droits pour le modifier'
      });
    }

    return res.status(200).json({
      success: true,
      message: 'Client mis à jour avec succès',
      data: updatedClient
    });
  } catch (error) {
    console.error('Error updating client:', error);
    return res.status(500).json({
      success: false,
      message: 'Une erreur est survenue lors de la mise à jour du client',
      error: error.message
    });
  }
};

// Delete a client
const deleteClient = async (req, res) => {
  try {
    const clientId = req.params.id;
    const userId = req.user.id; // Assuming user ID is available from authentication middleware

    const result = await clientModel.deleteClient(clientId, userId);

    if (!result) {
      return res.status(404).json({
        success: false,
        message: 'Client non trouvé ou vous n\'avez pas les droits pour le supprimer'
      });
    }

    return res.status(200).json({
      success: true,
      message: 'Client supprimé avec succès'
    });
  } catch (error) {
    console.error('Error deleting client:', error);
    return res.status(500).json({
      success: false,
      message: 'Une erreur est survenue lors de la suppression du client',
      error: error.message
    });
  }
};

// Search clients
const searchClients = async (req, res) => {
  try {
    const { query } = req.query;
    const userId = req.user.id; // Assuming user ID is available from authentication middleware

    if (!query) {
      // If no search query provided, return all clients
      return getClients(req, res);
    }

    const clients = await clientModel.searchClients(query, userId);

    return res.status(200).json({
      success: true,
      data: clients
    });
  } catch (error) {
    console.error('Error searching clients:', error);
    return res.status(500).json({
      success: false,
      message: 'Une erreur est survenue lors de la recherche des clients',
      error: error.message
    });
  }
};

// Check if a field value is unique
const checkUnique = async (req, res) => {
  try {
    const { field, value, exclude_id } = req.query;
    const userId = req.user.id;

    // Validate field parameter
    if (!field || !['email', 'cin'].includes(field)) {
      return res.status(400).json({
        success: false,
        message: 'Champ invalide. Seuls email et cin sont autorisés.'
      });
    }

    // Validate value parameter
    if (!value) {
      return res.status(400).json({
        success: false,
        message: 'La valeur à vérifier est requise'
      });
    }

    const isUnique = await clientModel.checkUnique(field, value, userId, exclude_id || null);

    return res.status(200).json({
      success: true,
      unique: isUnique
    });
  } catch (error) {
    console.error(`Error checking uniqueness for ${req.query.field}:`, error);
    return res.status(500).json({
      success: false,
      message: 'Une erreur est survenue lors de la vérification',
      error: error.message
    });
  }
};

module.exports = {
  createClient,
  getClients,
  getClientById,
  updateClient,
  deleteClient,
  searchClients,
  checkUnique
};