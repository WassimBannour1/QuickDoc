const db = require('../config/db');

class RemplissagePrimerie {
  /**
   * Récupère les données pour l'affichage dans l'étape 2 (liste des documents)
   * @param {string} typeDocument - Type de document ('facture' ou 'devis')
   * @param {number} userId - ID de l'utilisateur connecté
   * @param {Object} filters - Filtres de recherche (optionnel)
   * @returns {Promise<Array>} - Liste des documents formatés pour l'affichage
   */
  static async getDocumentsByType(typeDocument, userId, filters = {}) {
    try {
      // Construction de la requête de base
      let query = `
        SELECT 
          r.id,
          r.serie_number,
          CONCAT(c.name, ' ', c.last_name) AS client,
          c.name AS client_name,
          c.last_name AS client_last_name,
          r.date_document AS date,
          r.montant_ttc
        FROM 
          remplissage r
        JOIN 
          clients c ON r.client_id = c.id
        LEFT JOIN
          document d ON r.id = d.remplissage_id
        WHERE 
          r.type_document = ? 
          AND r.owner_id = ?
          AND d.id IS NULL
      `;
      
      // Paramètres pour la requête
      const queryParams = [typeDocument, userId];
      
      // Ajout des filtres si présents
      if (filters.search) {
        query += ` AND (r.serie_number LIKE ? OR CONCAT(c.name, ' ', c.last_name) LIKE ?)`;
        const searchTerm = `%${filters.search}%`;
        queryParams.push(searchTerm, searchTerm);
      }
      
      // Ajout de l'ordre de tri
      query += ` ORDER BY r.date_document DESC`;

      const [rows] = await db.query(query, queryParams);
      return rows;
    } catch (error) {
      console.error('Erreur lors de la récupération des documents:', error);
      throw error;
    }
  }

  /**
   * Récupère un document spécifique par son ID
   * @param {number} documentId - ID du document
   * @param {number} userId - ID de l'utilisateur connecté
   * @returns {Promise<Object>} - Document formaté pour l'affichage
   */
  static async getDocumentById(documentId, userId) {
    try {
      const query = `
        SELECT 
          r.id,
          r.serie_number,
          CONCAT(c.name, ' ', c.last_name) AS client,
          r.date_document AS date,
          r.montant_ttc
        FROM 
          remplissage r
        JOIN 
          clients c ON r.client_id = c.id
        WHERE 
          r.id = ? 
          AND r.owner_id = ?
      `;

      const [rows] = await db.query(query, [documentId, userId]);
      
      if (rows.length === 0) {
        return null;
      }
      
      return rows[0];
    } catch (error) {
      console.error('Erreur lors de la récupération du document:', error);
      throw error;
    }
  }
  
  /**
   * Récupère les données complètes d'un document pour l'édition
   * @param {number} documentId - ID du document
   * @param {number} userId - ID de l'utilisateur connecté
   * @returns {Promise<Object>} - Document complet avec toutes les informations pour l'édition
   */
  static async getDocumentDetailsForEdit(documentId, userId) {
    try {
      // 1. Récupérer les informations de base du document
      const documentQuery = `
        SELECT 
          r.id,
          r.type_document,
          r.serie_number,
          r.date_document,
          r.montant_ht,
          r.total_remise,
          r.total_net_ht,
          r.montant_tva,
          r.montant_ttc,
          r.details_bancaire,
          r.avertissement,
          r.client_id,
          r.entreprise_id
        FROM 
          remplissage r
        WHERE 
          r.id = ? 
          AND r.owner_id = ?
      `;

      const [documentRows] = await db.query(documentQuery, [documentId, userId]);
      
      if (documentRows.length === 0) {
        return null;
      }
      
      const documentData = documentRows[0];
      
      // 2. Récupérer les informations du client
      const clientQuery = `
        SELECT 
          id,
          name,
          last_name,
          email,
          phone,
          address
        FROM 
          clients
        WHERE 
          id = ?
      `;

      const [clientRows] = await db.query(clientQuery, [documentData.client_id]);
      const clientData = clientRows.length > 0 ? clientRows[0] : null;
      
      // 3. Récupérer les informations de l'entreprise
      const entrepriseQuery = `
        SELECT 
          id,
          nom_entreprise,
          email_entreprise,
          telephone,
          adresse,
          ville,
          pays,
          siret
        FROM 
          entreprises
        WHERE 
          id = ?
      `;

      const [entrepriseRows] = await db.query(entrepriseQuery, [documentData.entreprise_id]);
      const entrepriseData = entrepriseRows.length > 0 ? entrepriseRows[0] : null;
      
      // 4. Récupérer les produits associés au document
      const produitsQuery = `
        SELECT 
          rp.id,
          rp.product_id,
          rp.quantity,
          rp.unit_price,
          rp.unit,
          rp.total_price,
          rp.ref,
          rp.tva,
          p.name
        FROM 
          remplissage_products rp
        JOIN 
          products p ON rp.product_id = p.id
        WHERE 
          rp.remplissage_id = ?
      `;

      const [produitsRows] = await db.query(produitsQuery, [documentId]);
      
      // 5. Formater les données pour le frontend
      const formattedData = {
        document: {
          id: documentData.id,
          type: documentData.type_document,
          date: documentData.date_document,
          numeroSerie: documentData.serie_number
        },
        entreprise: {
          id: entrepriseData?.id || null,
          nom: entrepriseData?.nom_entreprise || '',
          email: entrepriseData?.email_entreprise || '',
          telephone: entrepriseData?.telephone || '',
          adresse: [entrepriseData?.adresse, entrepriseData?.ville, entrepriseData?.pays].filter(Boolean).join(', '),
          siret: entrepriseData?.siret || ''
        },
        client: {
          id: clientData?.id || null,
          nom: clientData ? `${clientData.name} ${clientData.last_name}`.trim() : '',
          email: clientData?.email || '',
          telephone: clientData?.phone || '',
          adresse: clientData?.address || ''
        },
        produits: produitsRows.map(produit => ({
          id: produit.product_id,
          reference: produit.ref || '',
          nom: produit.name || '',
          quantite: produit.quantity || 1,
          prixUnitaire: produit.unit_price || 0,
          totalHT: produit.total_price || 0,
          tvaPercentage: produit.tva || 20
        })),
        calculs: {
          totalHT: documentData.montant_ht || 0,
          totalRemise: documentData.total_remise || 0,
          totalNetHT: documentData.total_net_ht || 0,
          totalTVA: documentData.montant_tva || 0,
          totalTTC: documentData.montant_ttc || 0
        },
        detailsBancaires: {
          informations: documentData.details_bancaire || ''
        },
        avertissement: {
          message: documentData.avertissement || ''
        }
      };
      
      return formattedData;
    } catch (error) {
      console.error('Erreur lors de la récupération des détails du document:', error);
      throw error;
    }
  }

  /**
   * Supprime un document par son ID
   * @param {number} documentId - ID du document à supprimer
   * @param {number} userId - ID de l'utilisateur connecté
   * @returns {Promise<boolean>} - True si le document a été supprimé, false sinon
   */
  static async deleteDocument(documentId, userId) {
    try {
      // Vérifier que le document appartient bien à l'utilisateur avant de le supprimer
      const query = `
        DELETE FROM remplissage
        WHERE id = ? AND owner_id = ?
      `;

      const [result] = await db.query(query, [documentId, userId]);
      
      // Retourne true si au moins une ligne a été affectée (document supprimé)
      return result.affectedRows > 0;
    } catch (error) {
      console.error('Erreur lors de la suppression du document:', error);
      throw error;
    }
  }

  /**
   * Met à jour un document existant
   * @param {number} documentId - ID du document à mettre à jour
   * @param {number} userId - ID de l'utilisateur connecté
   * @param {Object} documentData - Données du document à mettre à jour
   * @returns {Promise<boolean>} - True si le document a été mis à jour, false sinon
   */
  static async updateDocument(documentId, userId, documentData) {
    try {
      // Commencer une transaction
      await db.query('START TRANSACTION');
      
      // Formater la date correctement pour MySQL (YYYY-MM-DD)
      let formattedDate = documentData.date;
      if (formattedDate && formattedDate.includes('T')) {
        formattedDate = formattedDate.split('T')[0];
      }
      
      // 1. Mettre à jour les informations de base du document
      const documentUpdateQuery = `
        UPDATE remplissage
        SET 
          serie_number = ?,
          type_document = ?,
          date_document = ?,
          montant_ht = ?,
          total_remise = ?,
          montant_tva = ?,
          montant_ttc = ?,
          details_bancaire = ?,
          avertissement = ?,
          client_id = ?,
          entreprise_id = ?,
          updated_at = NOW()
        WHERE 
          id = ? 
          AND owner_id = ?
      `;

      const documentValues = [
        documentData.serie_number,
        documentData.type,
        formattedDate,
        documentData.calculs.total_ht,
        documentData.calculs.total_remise,
        documentData.calculs.total_tva,
        documentData.calculs.total_ttc,
        documentData.details_bancaires,
        documentData.avertissement,
        documentData.client.id,
        documentData.entreprise.id,
        documentId,
        userId
      ];

      const [documentResult] = await db.query(documentUpdateQuery, documentValues);
      
      // Vérifier si le document a été mis à jour
      if (documentResult.affectedRows === 0) {
        await db.query('ROLLBACK');
        return false;
      }
      
      // 2. Supprimer les anciens produits associés au document
      const deleteProductsQuery = `
        DELETE FROM remplissage_products
        WHERE remplissage_id = ?
      `;
      
      await db.query(deleteProductsQuery, [documentId]);
      
      // 3. Insérer les nouveaux produits
      if (documentData.produits && documentData.produits.length > 0) {
        const insertProductsQuery = `
          INSERT INTO remplissage_products 
          (remplissage_id, product_id, quantity, unit_price, unit, total_price, ref, tva) 
          VALUES ?
        `;
        
        const productsValues = documentData.produits.map(produit => [
          documentId,
          produit.id,
          produit.quantite,
          produit.prix_unitaire,
          'unité', // Valeur par défaut
          produit.total_ht,
          produit.reference,
          produit.tva_percentage
        ]);
        
        await db.query(insertProductsQuery, [productsValues]);
      }
      
      // Valider la transaction
      await db.query('COMMIT');
      
      return true;
    } catch (error) {
      // En cas d'erreur, annuler la transaction
      await db.query('ROLLBACK');
      console.error('Erreur lors de la mise à jour du document:', error);
      throw error;
    }
  }
}

module.exports = RemplissagePrimerie;