const RemplissagePrimerie = require('../models/remplissagePrimerie');

/**
 * Contrôleur pour la gestion des données de la table 'remplissage' formatées pour l'affichage dans l'étape 2
 */

// Récupérer tous les documents d'un type spécifique (factures ou devis) avec filtres optionnels
const getDocumentsByType = async (req, res) => {
  try {
    const userId = req.user.id || req.user.userId; // Utiliser l'ID disponible
    const { typeDocument } = req.params;
    
    // Vérifier que le type de document est valide
    if (!['facture', 'devis'].includes(typeDocument)) {
      return res.status(400).json({ 
        success: false, 
        message: 'Type de document invalide. Doit être "facture" ou "devis".' 
      });
    }
    
    // Extraire les filtres de la requête
    const filters = {};
    if (req.query.search) {
      filters.search = req.query.search;
    }
    
    // Récupérer les documents depuis le modèle avec les filtres
    const documents = await RemplissagePrimerie.getDocumentsByType(typeDocument, userId, filters);
    
    // Retourner les documents formatés
    return res.status(200).json({
      success: true,
      data: documents
    });
  } catch (error) {
    console.error('Erreur lors de la récupération des documents:', error);
    return res.status(500).json({
      success: false,
      message: 'Erreur lors de la récupération des documents',
      error: error.message
    });
  }
};

// Récupérer un document spécifique par son ID
const getDocumentById = async (req, res) => {
  try {
    const userId = req.user.id || req.user.userId; // Utiliser l'ID disponible
    const { id } = req.params;
    
    // Récupérer le document depuis le modèle
    const document = await RemplissagePrimerie.getDocumentById(id, userId);
    
    // Vérifier si le document existe
    if (!document) {
      return res.status(404).json({
        success: false,
        message: 'Document non trouvé'
      });
    }
    
    // Retourner le document formaté
    return res.status(200).json({
      success: true,
      data: document
    });
  } catch (error) {
    console.error('Erreur lors de la récupération du document:', error);
    return res.status(500).json({
      success: false,
      message: 'Erreur lors de la récupération du document',
      error: error.message
    });
  }
};

// Récupérer les détails complets d'un document pour l'édition
const getDocumentDetailsForEdit = async (req, res) => {
  try {
    const userId = req.user.id || req.user.userId; // Utiliser l'ID disponible
    const { id } = req.params;
    
    // Récupérer les détails complets du document depuis le modèle
    const documentDetails = await RemplissagePrimerie.getDocumentDetailsForEdit(id, userId);
    
    // Vérifier si le document existe
    if (!documentDetails) {
      return res.status(404).json({
        success: false,
        message: 'Document non trouvé'
      });
    }
    
    // Retourner les détails du document formatés pour l'édition
    return res.status(200).json({
      success: true,
      data: documentDetails
    });
  } catch (error) {
    console.error('Erreur lors de la récupération des détails du document:', error);
    return res.status(500).json({
      success: false,
      message: 'Erreur lors de la récupération des détails du document',
      error: error.message
    });
  }
};

// Supprimer un document par son ID
const deleteDocument = async (req, res) => {
  try {
    const userId = req.user.id || req.user.userId; // Utiliser l'ID disponible
    const { id } = req.params;
    
    // Supprimer le document depuis le modèle
    const result = await RemplissagePrimerie.deleteDocument(id, userId);
    
    // Vérifier si le document a été supprimé
    if (!result) {
      return res.status(404).json({
        success: false,
        message: 'Document non trouvé ou vous n\'êtes pas autorisé à le supprimer'
      });
    }
    
    // Retourner une confirmation de suppression
    return res.status(200).json({
      success: true,
      message: 'Document supprimé avec succès'
    });
  } catch (error) {
    console.error('Erreur lors de la suppression du document:', error);
    return res.status(500).json({
      success: false,
      message: 'Erreur lors de la suppression du document',
      error: error.message
    });
  }
};

// Mettre à jour un document existant
const updateDocument = async (req, res) => {
  try {
    const userId = req.user.id || req.user.userId; // Utiliser l'ID disponible
    const { id } = req.params;
    const documentData = req.body;
    
    // Mettre à jour le document via le modèle
    const result = await RemplissagePrimerie.updateDocument(id, userId, documentData);
    
    // Vérifier si le document a été mis à jour
    if (!result) {
      return res.status(404).json({
        success: false,
        message: 'Document non trouvé ou vous n\'êtes pas autorisé à le modifier'
      });
    }
    
    // Récupérer le document mis à jour pour le retourner dans la réponse
    const updatedDocument = await RemplissagePrimerie.getDocumentDetailsForEdit(id, userId);
    
    // Retourner une confirmation de mise à jour avec les données mises à jour
    return res.status(200).json({
      success: true,
      message: 'Document mis à jour avec succès',
      data: updatedDocument
    });
  } catch (error) {
    console.error('Erreur lors de la mise à jour du document:', error);
    return res.status(500).json({
      success: false,
      message: 'Erreur lors de la mise à jour du document',
      error: error.message
    });
  }
};

module.exports = {
  getDocumentsByType,
  getDocumentById,
  getDocumentDetailsForEdit,
  deleteDocument,
  updateDocument
};