const db = require('../config/db');

/**
 * Contrôleur pour la gestion des données de la table 'remplissage'
 * Cette table contient les informations des factures et devis
 */

// Récupérer tous les documents (factures et devis) avec filtres optionnels
exports.getAllDocuments = async (req, res) => {
    try {
        const userId = req.user.id || req.user.userId; // Utiliser l'ID disponible
        const { type_document, client_id, date_from, date_to, montant_min, montant_max, status, search } = req.query;
        
        // Construction de la requête SQL de base avec jointure sur la table users
        // Using INNER JOIN with document table to only show documents that have PDF files
        let query = `
            SELECT r.*, r.serie_number, c.name as client_name, c.last_name as client_last_name, c.email as client_email, 
                   d.status as document_status, u.entreprise_name, d.file_path
            FROM remplissage r
            INNER JOIN document d ON r.id = d.remplissage_id
            LEFT JOIN clients c ON r.client_id = c.id
            LEFT JOIN users u ON r.owner_id = u.id
            WHERE r.owner_id = ?
        `;
        
        // Paramètres pour la requête
        const params = [userId];
        
        // Ajout des filtres si présents
        if (type_document) {
            query += " AND r.type_document = ?";
            params.push(type_document);
        }
        
        if (client_id) {
            query += " AND r.client_id = ?";
            params.push(client_id);
        }
        
        if (date_from) {
            query += " AND r.created_at >= ?";
            params.push(date_from);
        }
        
        if (date_to) {
            query += " AND r.created_at <= ?";
            params.push(date_to);
        }
        
        if (montant_min) {
            query += " AND r.montant_ttc >= ?";
            params.push(montant_min);
        }
        
        if (montant_max) {
            query += " AND r.montant_ttc <= ?";
            params.push(montant_max);
        }
        
        if (status && status !== 'all') {
            // Gestion du statut en utilisant la colonne status de la table document
            // Accepte directement les valeurs en français du frontend
            if (status === 'Non envoyée') {
                query += " AND d.status = 'not_sent'";
            } else if (status === 'Envoyée') {
                query += " AND d.status = 'sent'";
            } else if (status === 'Non payée') {
                query += " AND d.status = 'unpaid'";
            } else if (status === 'Payée') {
                query += " AND d.status = 'paid'";
            } else if (status === 'En retard') {
                query += " AND d.status = 'overdue'";
            } else if (status === 'Annulée') {
                query += " AND d.status = 'cancelled'";
            } else if (status === 'Acceptée') {
                query += " AND d.status = 'accepted'";
            } else {
                // Si le statut n'est pas reconnu, on utilise la valeur telle quelle
                query += " AND d.status = ?";
                params.push(status);
            }
        }
        
        if (search) {
            query += " AND (c.name LIKE ? OR c.last_name LIKE ? OR r.nom_entreprise LIKE ? OR u.entreprise_name LIKE ?)";
            const searchTerm = `%${search}%`;
            params.push(searchTerm, searchTerm, searchTerm, searchTerm);
        }
        
        // Ajout de l'ordre de tri
        query += " ORDER BY r.created_at DESC";
        
        // Exécution de la requête
        const [rows] = await db.query(query, params);
        
        // Transformation des données pour correspondre au format attendu par le frontend
        const documents = rows.map(doc => ({
            id: doc.id,
            reference: `${doc.type_document === 'facture' ? 'FACT' : 'DEVIS'}-${doc.id}`,
            date: doc.created_at,
            company: doc.entreprise_name || doc.nom_entreprise,
            client: `${doc.client_name || ''} ${doc.client_last_name || ''}`.trim(),
            client_id: doc.client_id,
            amount: doc.montant_ttc,
            status: doc.document_status || 'Non envoyée',
            type: doc.type_document,
            // Utiliser serie_number s'il existe, sinon utiliser la référence formatée
            name: doc.serie_number || `${doc.type_document === 'facture' ? 'FACT' : 'DEVIS'}-${doc.id}`
        }));
        
        res.status(200).json({
            success: true,
            data: documents
        });
    } catch (error) {
        console.error('Erreur lors de la récupération des documents:', error);
        res.status(500).json({
            success: false,
            message: 'Erreur lors de la récupération des documents',
            error: error.message
        });
    }
};

// Supprimer un document (facture ou devis)
exports.deleteDocument = async (req, res) => {
    try {
        const userId = req.user.id || req.user.userId;
        const documentId = req.params.id;

        // Vérifier que le document existe et appartient à l'utilisateur
        const [existingDoc] = await db.query(
            'SELECT * FROM remplissage WHERE id = ? AND owner_id = ?',
            [documentId, userId]
        );

        if (existingDoc.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Document non trouvé ou accès non autorisé'
            });
        }

        // Suppression du document
        await db.query('DELETE FROM remplissage WHERE id = ? AND owner_id = ?', [documentId, userId]);

        res.status(200).json({
            success: true,
            message: 'Document supprimé avec succès'
        });
    } catch (error) {
        console.error(`Erreur lors de la suppression du document ${req.params.id}:`, error);
        res.status(500).json({
            success: false,
            message: 'Erreur lors de la suppression du document',
            error: error.message
        });
    }
};

// Récupérer un document spécifique par son ID
exports.getDocumentById = async (req, res) => {
    try {
        const userId = req.user.id || req.user.userId;
        const userRole = req.user.role;
        const documentId = req.params.id;
        
        // Construction de la requête SQL de base avec jointure sur la table users
        // Using INNER JOIN with document table to only show documents that have PDF files
        let query = `
            SELECT r.*, c.*, d.status as document_status,
                   c.name as client_name, c.last_name as client_last_name, c.email as client_email,
                   u.entreprise_name, d.file_path
            FROM remplissage r
            INNER JOIN document d ON r.id = d.remplissage_id
            LEFT JOIN clients c ON r.client_id = c.id
            LEFT JOIN users u ON r.owner_id = u.id
            WHERE r.id = ?
        `;
        
        // Paramètres pour la requête
        let params = [documentId];
        
        // Si l'utilisateur est un client, vérifier que le document lui appartient
        if (userRole === 'client') {
            query += ` AND c.user_id = ?`;
            params.push(userId);
        } else {
            // Pour les autres rôles (admin, enterprise), vérifier que l'utilisateur est le propriétaire
            query += ` AND r.owner_id = ?`;
            params.push(userId);
        }
        
        const [rows] = await db.query(query, params);
        
        if (rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Document non trouvé ou accès non autorisé'
            });
        }
        
        const document = rows[0];
        
        // Utiliser entreprise_name de la table users si disponible, sinon utiliser nom_entreprise
        document.company = document.entreprise_name || document.nom_entreprise;
        
        // Transformation des données pour correspondre au format attendu par le frontend
        const formattedDocument = {
            id: document.id,
            reference: `${document.type_document === 'facture' ? 'FACT' : 'DEVIS'}-${document.id}`,
            date: document.created_at,
            company: document.nom_entreprise,
            client: {
                id: document.client_id,
                name: document.client_name,
                lastName: document.client_last_name,
                email: document.client_email,
                address: document.address
            },
            product: {
                id: document.produit_id,
                name: document.product_name,
                description: document.product_description,
                unitPrice: document.unit_price
            },
            quantity: document.quantite,
            amountHT: document.montant_ht,
            tva: document.taux_tva,
            amountTVA: document.montant_tva,
            amountTTC: document.montant_ttc,
            paymentDeadline: document.delai_paiement,
            status: document.document_status || document.status_devis || document.status || 'Non envoyée',
            type: document.type_document,
            templateId: document.template_id
        };
        
        res.status(200).json({
            success: true,
            data: formattedDocument
        });
    } catch (error) {
        console.error(`Erreur lors de la récupération du document ${req.params.id}:`, error);
        res.status(500).json({
            success: false,
            message: 'Erreur lors de la récupération du document',
            error: error.message
        });
    }
};

// Supprimer un document (facture ou devis)
exports.deleteDocument = async (req, res) => {
    try {
        const userId = req.user.id || req.user.userId;
        const documentId = req.params.id;

        // Vérifier que le document existe et appartient à l'utilisateur
        const [existingDoc] = await db.query(
            'SELECT * FROM remplissage WHERE id = ? AND owner_id = ?',
            [documentId, userId]
        );

        if (existingDoc.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Document non trouvé ou accès non autorisé'
            });
        }

        // Suppression du document
        await db.query('DELETE FROM remplissage WHERE id = ? AND owner_id = ?', [documentId, userId]);

        res.status(200).json({
            success: true,
            message: 'Document supprimé avec succès'
        });
    } catch (error) {
        console.error(`Erreur lors de la suppression du document ${req.params.id}:`, error);
        res.status(500).json({
            success: false,
            message: 'Erreur lors de la suppression du document',
            error: error.message
        });
    }
};

// Récupérer toutes les factures
exports.getAllFactures = async (req, res) => {
    req.query.type_document = 'facture';
    return exports.getAllDocuments(req, res);
};

// Récupérer tous les devis
exports.getAllDevis = async (req, res) => {
    req.query.type_document = 'devis';
    return exports.getAllDocuments(req, res);
};

// Créer un nouveau document (facture ou devis)
exports.createDocument = async (req, res) => {
    try {
        const userId = req.user.id || req.user.userId;
        const {
            client_id,
            produit_id,
            template_id,
            type_document,
            quantite,
            montant_ht,
            montant_tva,
            taux_tva,
            montant_ttc,
            nom_entreprise,
            adresse_entreprise,
            delai_paiement
        } = req.body;

        // Validation des données
        if (!client_id || !produit_id || !template_id || !type_document || !quantite || !montant_ht || !taux_tva || !montant_ttc || !nom_entreprise) {
            return res.status(400).json({
                success: false,
                message: 'Données manquantes pour la création du document'
            });
        }

        // Construction de la requête SQL pour l'insertion
        const query = `
            INSERT INTO remplissage (
                client_id,
                produit_id,
                owner_id,
                template_id,
                type_document,
                quantite,
                montant_ht,
                montant_tva,
                taux_tva,
                montant_ttc,
                nom_entreprise,
                adresse_entreprise,
                delai_paiement,
                source
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        `;

        const params = [
            client_id,
            produit_id,
            userId,
            template_id,
            type_document,
            quantite,
            montant_ht,
            montant_tva,
            taux_tva,
            montant_ttc,
            nom_entreprise,
            adresse_entreprise || null,
            delai_paiement || null,
            'manual'
        ];

        // Exécution de la requête
        const [result] = await db.query(query, params);

        // Récupération du document créé
        const documentId = result.insertId;
        const [newDocument] = await db.query('SELECT * FROM remplissage WHERE id = ?', [documentId]);

        res.status(201).json({
            success: true,
            message: `${type_document === 'facture' ? 'Facture' : 'Devis'} créé avec succès`,
            data: {
                id: documentId,
                reference: `${type_document === 'facture' ? 'FACT' : 'DEVIS'}-${documentId}`,
                ...newDocument[0]
            }
        });
    } catch (error) {
        console.error('Erreur lors de la création du document:', error);
        res.status(500).json({
            success: false,
            message: 'Erreur lors de la création du document',
            error: error.message
        });
    }
};

// Supprimer un document (facture ou devis)
exports.deleteDocument = async (req, res) => {
    try {
        const userId = req.user.id || req.user.userId;
        const documentId = req.params.id;

        // Vérifier que le document existe et appartient à l'utilisateur
        const [existingDoc] = await db.query(
            'SELECT * FROM remplissage WHERE id = ? AND owner_id = ?',
            [documentId, userId]
        );

        if (existingDoc.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Document non trouvé ou accès non autorisé'
            });
        }

        // Suppression du document
        await db.query('DELETE FROM remplissage WHERE id = ? AND owner_id = ?', [documentId, userId]);

        res.status(200).json({
            success: true,
            message: 'Document supprimé avec succès'
        });
    } catch (error) {
        console.error(`Erreur lors de la suppression du document ${req.params.id}:`, error);
        res.status(500).json({
            success: false,
            message: 'Erreur lors de la suppression du document',
            error: error.message
        });
    }
};

// Mettre à jour un document existant
exports.updateDocument = async (req, res) => {
    try {
        const userId = req.user.id || req.user.userId;
        const documentId = req.params.id;
        const updateData = req.body;

        // Vérifier que le document existe et appartient à l'utilisateur
        const [existingDoc] = await db.query(
            'SELECT * FROM remplissage WHERE id = ? AND owner_id = ?',
            [documentId, userId]
        );

        if (existingDoc.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Document non trouvé ou accès non autorisé'
            });
        }

        // Construction de la requête de mise à jour
        let query = 'UPDATE remplissage SET ';
        const params = [];
        const allowedFields = [
            'client_id', 'produit_id', 'template_id', 'quantite',
            'montant_ht', 'montant_tva', 'taux_tva', 'montant_ttc',
            'nom_entreprise', 'adresse_entreprise', 'delai_paiement'
        ];

        // Ajout des champs à mettre à jour
        const updates = [];
        for (const field of allowedFields) {
            if (updateData[field] !== undefined) {
                updates.push(`${field} = ?`);
                params.push(updateData[field]);
            }
        }

        // Si aucun champ à mettre à jour
        if (updates.length === 0) {
            return res.status(400).json({
                success: false,
                message: 'Aucune donnée valide à mettre à jour'
            });
        }

        // Finalisation de la requête
        query += updates.join(', ');
        query += ' WHERE id = ? AND owner_id = ?';
        params.push(documentId, userId);

        // Exécution de la mise à jour
        await db.query(query, params);

        // Récupération du document mis à jour
        const [updatedDoc] = await db.query(
            'SELECT * FROM remplissage WHERE id = ?',
            [documentId]
        );

        res.status(200).json({
            success: true,
            message: 'Document mis à jour avec succès',
            data: updatedDoc[0]
        });
    } catch (error) {
        console.error(`Erreur lors de la mise à jour du document ${req.params.id}:`, error);
        res.status(500).json({
            success: false,
            message: 'Erreur lors de la mise à jour du document',
            error: error.message
        });
    }
};

// Supprimer un document (facture ou devis)
exports.deleteDocument = async (req, res) => {
    try {
        const userId = req.user.id || req.user.userId;
        const documentId = req.params.id;

        // Vérifier que le document existe et appartient à l'utilisateur
        const [existingDoc] = await db.query(
            'SELECT * FROM remplissage WHERE id = ? AND owner_id = ?',
            [documentId, userId]
        );

        if (existingDoc.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Document non trouvé ou accès non autorisé'
            });
        }

        // Suppression du document
        await db.query('DELETE FROM remplissage WHERE id = ? AND owner_id = ?', [documentId, userId]);

        res.status(200).json({
            success: true,
            message: 'Document supprimé avec succès'
        });
    } catch (error) {
        console.error(`Erreur lors de la suppression du document ${req.params.id}:`, error);
        res.status(500).json({
            success: false,
            message: 'Erreur lors de la suppression du document',
            error: error.message
        });
    }
};

// Supprimer un document
exports.deleteDocument = async (req, res) => {
    try {
        const userId = req.user.id || req.user.userId;
        const documentId = req.params.id;

        // Vérifier que le document existe et appartient à l'utilisateur
        const [existingDoc] = await db.query(
            'SELECT * FROM remplissage WHERE id = ? AND owner_id = ?',
            [documentId, userId]
        );

        if (existingDoc.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Document non trouvé ou accès non autorisé'
            });
        }

        // Suppression du document
        await db.query('DELETE FROM remplissage WHERE id = ? AND owner_id = ?', [documentId, userId]);

        res.status(200).json({
            success: true,
            message: 'Document supprimé avec succès'
        });
    } catch (error) {
        console.error(`Erreur lors de la suppression du document ${req.params.id}:`, error);
        res.status(500).json({
            success: false,
            message: 'Erreur lors de la suppression du document',
            error: error.message
        });
    }
};

// Supprimer un document (facture ou devis)
exports.deleteDocument = async (req, res) => {
    try {
        const userId = req.user.id || req.user.userId;
        const documentId = req.params.id;

        // Vérifier que le document existe et appartient à l'utilisateur
        const [existingDoc] = await db.query(
            'SELECT * FROM remplissage WHERE id = ? AND owner_id = ?',
            [documentId, userId]
        );

        if (existingDoc.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Document non trouvé ou accès non autorisé'
            });
        }

        // Suppression du document
        await db.query('DELETE FROM remplissage WHERE id = ? AND owner_id = ?', [documentId, userId]);

        res.status(200).json({
            success: true,
            message: 'Document supprimé avec succès'
        });
    } catch (error) {
        console.error(`Erreur lors de la suppression du document ${req.params.id}:`, error);
        res.status(500).json({
            success: false,
            message: 'Erreur lors de la suppression du document',
            error: error.message
        });
    }
};

// Importer la méthode createManualFillDocument depuis le contrôleur manualFillController
const manualFillController = require('./manualFillController');
exports.createManualFillDocument = manualFillController.createManualFillDocument;