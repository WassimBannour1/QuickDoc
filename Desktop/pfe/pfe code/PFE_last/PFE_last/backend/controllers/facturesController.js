const db = require('../config/db');
const nodemailer = require('nodemailer');

// Configuration du transporteur d'email (même que pour l'authentification)
const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: 'quikdoc8@gmail.com',
        pass: 'yzph kfub ggot lsnl'
    }
});

// Envoyer une facture par email
exports.sendFactureByEmail = async (req, res) => {
    try {
        const factureId = req.params.id;
        const { to, subject, message, attachPdf } = req.body;
        const userId = req.user.id || req.user.userId; // Utiliser l'un ou l'autre ID disponible

        // Vérifier que la facture appartient bien à l'utilisateur
        const [rows] = await db.query(
            `SELECT r.*, c.name as client_name, c.last_name as client_last_name 
            FROM remplissage r 
            LEFT JOIN clients c ON r.client_id = c.id 
            WHERE r.id = ? AND r.owner_id = ? AND r.type_document = 'facture'`,
            [factureId, userId]
        );

        if (rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Facture non trouvée'
            });
        }

        const facture = {
            id: rows[0].id,
            reference: `FACTURE-${rows[0].id}`,
            date: rows[0].created_at,
            company: rows[0].entreprise_name || rows[0].nom_entreprise,
            amount: rows[0].montant_ttc,
            status: rows[0].document_status || (rows[0].date_paiement ? 'payée' : (new Date(rows[0].delai_paiement) < new Date() ? 'en retard' : 'en attente')),
            state: rows[0].date_paiement ? 'payée' : (new Date(rows[0].delai_paiement) < new Date() ? 'en retard' : 'en attente')
        };

        // Préparer les options de l'email
        const mailOptions = {
            from: 'quikdoc8@gmail.com',
            to: to,
            subject: subject || `Facture ${facture.reference}`,
            html: `
                <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
                    <h1 style="color: #002446; text-align: center;">Facture ${facture.reference}</h1>
                    <p style="color: #666;">${message || `Veuillez trouver ci-joint la facture ${facture.reference}.`}</p>
                    <div style="background-color: #f5f5f5; padding: 20px; border-radius: 5px; margin: 20px 0;">
                        <h3 style="color: #002446; margin-top: 0;">Détails de la facture</h3>
                        <p><strong>Référence:</strong> ${facture.reference}</p>
                        <p><strong>Date:</strong> ${new Date(facture.date).toLocaleDateString()}</p>
                        <p><strong>Entreprise:</strong> ${facture.company}</p>
                        <p><strong>Montant:</strong> ${facture.amount} €</p>
                        <p><strong>État:</strong> ${facture.status}</p>
                    </div>
                    <p style="color: #666;">Cordialement,</p>
                    <p style="color: #666;">L'équipe QuikDoc</p>
                    <div style="text-align: center; margin-top: 30px; color: #999; font-size: 12px;">
                        <p>Cet email a été envoyé automatiquement, merci de ne pas y répondre.</p>
                    </div>
                </div>
            `
        };

        // Si on doit joindre le PDF
        if (attachPdf) {
            try {
                console.log('Pièce jointe demandée pour la facture:', factureId);
                
                // Récupérer le document depuis la table document en utilisant le remplissage_id
                const [documents] = await db.query(
                    'SELECT * FROM document WHERE remplissage_id = ?',
                    [factureId]
                );
                
                if (documents.length === 0) {
                    console.log(`Aucun document trouvé avec remplissage_id: ${factureId}`);
                } else {
                    const document = documents[0];
                    console.log('Document trouvé:', document);
                    
                    if (document.file_path) {
                        // Essayer différents chemins pour trouver le fichier
                        const fs = require('fs');
                        const path = require('path');
                        
                        const possiblePaths = [
                            document.file_path,
                            path.resolve(__dirname, '..', document.file_path),
                            path.resolve(__dirname, '..', 'uploads', 'documents', path.basename(document.file_path))
                        ];
                        
                        let filePath = null;
                        
                        // Essayer chaque chemin jusqu'à trouver un qui existe
                        for (const possiblePath of possiblePaths) {
                            if (fs.existsSync(possiblePath)) {
                                filePath = possiblePath;
                                console.log(`Fichier trouvé à: ${filePath}`);
                                break;
                            }
                        }
                        
                        if (filePath) {
                            // Ajouter la pièce jointe à l'email
                            mailOptions.attachments = [{
                                filename: `Facture_${facture.reference}.pdf`,
                                path: filePath
                            }];
                            console.log('Pièce jointe ajoutée à l\'email:', filePath);
                        } else {
                            console.log('Fichier non trouvé aux emplacements suivants:', possiblePaths);
                        }
                    } else {
                        console.log('Le document n\'a pas de chemin de fichier');
                    }
                }
            } catch (attachError) {
                console.error('Erreur lors de l\'ajout de la pièce jointe:', attachError);
            }
        }

        // Envoyer l'email
        await transporter.sendMail(mailOptions);

        res.json({
            success: true,
            message: 'Facture envoyée par email avec succès'
        });

    } catch (error) {
        console.error('Erreur lors de l\'envoi de la facture par email:', error);
        res.status(500).json({
            success: false,
            message: 'Erreur lors de l\'envoi de la facture par email'
        });
    }
};

// Récupérer toutes les factures
exports.getAllFactures = async (req, res) => {
    try {
        // Récupérer l'ID et le rôle de l'utilisateur à partir du token
        const userId = req.user.id || req.user.userId;
        const userRole = req.user.role;
        const { client_id, client_name, date_from, date_to, montant_min, montant_max, status, search } = req.query;
        
        // Construction de la requête SQL de base avec jointure sur la table document, users et entreprises
        // Using INNER JOIN with document table to only show documents that have PDF files
        let query = `
            SELECT r.*, r.serie_number, c.name as client_name, c.last_name as client_last_name, c.email as client_email, 
                   d.status as document_status, d.status_client, e.nom_entreprise as entreprise_name, d.file_path
            FROM remplissage r 
            INNER JOIN document d ON r.id = d.remplissage_id
            LEFT JOIN clients c ON r.client_id = c.id 
            LEFT JOIN users u ON r.owner_id = u.id
            LEFT JOIN entreprises e ON u.id = e.owner_id
            WHERE `;
        
        // Paramètres pour la requête
        let params = [];
        
        // Si l'utilisateur est un client, filtrer par client_id associé à cet utilisateur
        if (userRole === 'client') {
            query += `c.user_id = ? AND r.type_document = 'facture'`;
            params.push(userId);
        } else {
            // Pour les autres rôles (admin, enterprise_admin), filtrer par owner_id
            query += `r.owner_id = ? AND r.type_document = 'facture'`;
            params.push(userId);
        }
        
        // Ajout des filtres si présents
        if (client_id) {
            query += " AND r.client_id = ?";
            params.push(client_id);
        }
        
        if (client_name) {
            // Recherche par nom de client - amélioration pour une meilleure correspondance
            const searchTerms = client_name.trim().toLowerCase().split(/\s+/);
            
            if (searchTerms.length === 1) {
                // Si un seul terme, rechercher dans le prénom, le nom ou la combinaison des deux
                const pattern = `%${searchTerms[0]}%`;
                query += " AND (LOWER(c.name) LIKE ? OR LOWER(c.last_name) LIKE ? OR LOWER(CONCAT(c.name, ' ', c.last_name)) LIKE ? OR LOWER(CONCAT(c.last_name, ' ', c.name)) LIKE ?)"; 
                params.push(pattern, pattern, pattern, pattern);
            } else {
                // Si plusieurs termes, essayer différentes combinaisons
                let conditions = [];
                let queryParams = [];
                
                // Pour chaque terme, vérifier s'il correspond au prénom ou au nom
                searchTerms.forEach(term => {
                    const pattern = `%${term}%`;
                    conditions.push("LOWER(c.name) LIKE ?");
                    queryParams.push(pattern);
                    
                    conditions.push("LOWER(c.last_name) LIKE ?");
                    queryParams.push(pattern);
                });
                
                // Rechercher la chaîne complète dans les combinaisons nom+prénom et prénom+nom
                const fullPattern = `%${client_name.toLowerCase()}%`;
                conditions.push("LOWER(CONCAT(c.name, ' ', c.last_name)) LIKE ?");
                queryParams.push(fullPattern);
                
                conditions.push("LOWER(CONCAT(c.last_name, ' ', c.name)) LIKE ?");
                queryParams.push(fullPattern);
                
                query += ` AND (${conditions.join(" OR ")})`;
                params.push(...queryParams);
            }
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
            params.push(parseFloat(montant_min));
        }
        
        if (montant_max) {
            query += " AND r.montant_ttc <= ?";
            params.push(parseFloat(montant_max));
        }
        
        if (status && status !== 'all') {
            // Gestion du statut en utilisant la colonne status_client de la table document
            query += " AND d.status_client = ?";
            params.push(status);
            console.log('Condition ajoutée pour statut_client:', status);
        }
        
        if (search) {
            // Amélioration de la recherche pour les noms complets
            const searchTerm = search.trim();
            let searchConditions = [];
            let searchParams = [];
            
            // Recherche avec LIKE pour chaque colonne pertinente
            const pattern = `%${searchTerm}%`;
            
            // Recherche dans le nom et prénom individuellement avec insensibilité à la casse
            searchConditions.push("LOWER(c.name) LIKE LOWER(?)");
            searchParams.push(pattern);
            
            searchConditions.push("LOWER(c.last_name) LIKE LOWER(?)");
            searchParams.push(pattern);
            
            // Recherche dans le nom de l'entreprise
            searchConditions.push("LOWER(r.nom_entreprise) LIKE LOWER(?)");
            searchParams.push(pattern);
            
            // Recherche dans la concaténation du nom et prénom (dans les deux sens)
            searchConditions.push("LOWER(CONCAT(c.name, ' ', c.last_name)) LIKE LOWER(?)");
            searchParams.push(pattern);
            
            searchConditions.push("LOWER(CONCAT(c.last_name, ' ', c.name)) LIKE LOWER(?)");
            searchParams.push(pattern);
            
            // Recherche par référence (numéro de facture)
            searchConditions.push("LOWER(CONCAT('FACTURE-', r.id)) LIKE LOWER(?)");
            searchParams.push(pattern);
            
            // Si le terme de recherche contient un espace, essayer de le diviser en prénom/nom
            if (searchTerm.includes(' ')) {
                const terms = searchTerm.split(/\s+/);
                if (terms.length >= 2) {
                    // Recherche où le premier terme est le prénom et le second est le nom
                    searchConditions.push("(LOWER(c.name) LIKE LOWER(?) AND LOWER(c.last_name) LIKE LOWER(?))");
                    searchParams.push(`%${terms[0]}%`, `%${terms[1]}%`);
                    
                    // Recherche où le premier terme est le nom et le second est le prénom
                    searchConditions.push("(LOWER(c.last_name) LIKE LOWER(?) AND LOWER(c.name) LIKE LOWER(?))");
                    searchParams.push(`%${terms[0]}%`, `%${terms[1]}%`);
                }
            }
            
            query += ` AND (${searchConditions.join(" OR ")})`;
            params.push(...searchParams);
            
            console.log('Recherche par terme:', searchTerm);
            console.log('Conditions de recherche:', searchConditions.join(" OR "));
            console.log('Paramètres de recherche:', searchParams);
        }
        
        // Ajout de l'ordre de tri
        query += " ORDER BY r.created_at DESC";
        
        console.log('Requête SQL pour les factures:', query);
        console.log('Paramètres:', params);
        
        // Exécution de la requête
        const [rows] = await db.query(query, params);
        console.log(`Nombre de factures trouvées: ${rows.length}`);
        
        // Transformer les données pour correspondre au format attendu par le frontend
        const factures = rows.map(doc => ({
            id: doc.id,
            reference: doc.serie_number || `FACTURE-${doc.id}`,
            date: doc.created_at,
            company: doc.entreprise_name || doc.nom_entreprise,
            client: `${doc.client_name || ''} ${doc.client_last_name || ''}`.trim(),
            client_id: doc.client_id,
            amount: doc.montant_ttc,
            paymentDeadline: doc.delai_paiement,
            status: doc.document_status || (doc.date_paiement ? 'payée' : (new Date(doc.delai_paiement) < new Date() ? 'en retard' : 'en attente')),
            status_client: doc.status_client || (doc.date_paiement ? 'paid' : (new Date(doc.delai_paiement) < new Date() ? 'overdue' : 'unpaid')),
            type: 'facture',
            // Utiliser serie_number s'il existe, sinon utiliser la référence formatée
            name: doc.serie_number || `FACTURE-${doc.id}`
        }));

        res.json({
            success: true,
            data: factures
        });
    } catch (error) {
        console.error('Erreur lors de la récupération des factures:', error);
        res.status(500).json({
            success: false,
            message: 'Erreur lors de la récupération des factures'
        });
    }
};

// Récupérer une facture par son ID
exports.getFactureById = async (req, res) => {
    try {
        const factureId = req.params.id;
        const userId = req.user.id || req.user.userId; // Utiliser l'un ou l'autre ID disponible
        const userRole = req.user.role;

        // Construire la requête SQL en fonction du rôle de l'utilisateur
        let query = `
            SELECT r.*, c.name as client_name, c.last_name as client_last_name, c.email as client_email, d.status as document_status,
                   d.status_client, u.entreprise_name, d.file_path
            FROM remplissage r 
            INNER JOIN document d ON r.id = d.remplissage_id
            LEFT JOIN clients c ON r.client_id = c.id 
            LEFT JOIN users u ON r.owner_id = u.id
            WHERE r.id = ? AND `;
            
        // Paramètres pour la requête
        let params = [factureId];
        
        // Si l'utilisateur est un client, filtrer par client_id associé à cet utilisateur
        if (userRole === 'client') {
            query += `c.user_id = ? AND r.type_document = 'facture'`;
            params.push(userId);
        } else {
            // Pour les autres rôles (admin, enterprise_admin), filtrer par owner_id
            query += `r.owner_id = ? AND r.type_document = 'facture'`;
            params.push(userId);
        }
        
        // Exécuter la requête
        const [rows] = await db.query(query, params);

        if (rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Facture non trouvée'
            });
        }

        // Transformer les données pour correspondre au format attendu
        const facture = {
            id: rows[0].id,
            reference: rows[0].serie_number || `FACTURE-${rows[0].id}`,
            date: rows[0].created_at,
            company: rows[0].entreprise_name || rows[0].nom_entreprise,
            client: {
                name: `${rows[0].client_name || ''} ${rows[0].client_last_name || ''}`.trim(),
                id: rows[0].client_id,
                email: rows[0].client_email
            },
            amount: rows[0].montant_ttc,
            paymentDeadline: rows[0].delai_paiement,
            status: rows[0].document_status || (rows[0].date_paiement ? 'payée' : (new Date(rows[0].delai_paiement) < new Date() ? 'en retard' : 'en attente')),
            status_client: rows[0].status_client || (rows[0].date_paiement ? 'paid' : (new Date(rows[0].delai_paiement) < new Date() ? 'overdue' : 'unpaid')),
            type: 'facture'
        };

        res.json({
            success: true,
            data: facture
        });
    } catch (error) {
        console.error('Erreur lors de la récupération de la facture:', error);
        res.status(500).json({
            success: false,
            message: 'Erreur lors de la récupération de la facture'
        });
    }
};

// Créer une nouvelle facture
exports.createFacture = async (req, res) => {
    try {
        const { client_id, produit_id, template_id, quantite, montant_ht, taux_tva, montant_tva, montant_ttc, nom_entreprise, adresse_entreprise, delai_paiement, date_paiement } = req.body;
        const userId = req.user.id || req.user.userId;

        // Insérer la nouvelle facture dans la table remplissage
        const [result] = await db.query(
            `INSERT INTO remplissage 
            (client_id, produit_id, owner_id, template_id, type_document, quantite, 
            montant_ht, montant_tva, taux_tva, montant_ttc, nom_entreprise, adresse_entreprise, delai_paiement, date_paiement) 
            VALUES (?, ?, ?, ?, 'facture', ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
            [client_id, produit_id, userId, template_id, quantite, montant_ht, montant_tva, taux_tva, montant_ttc, nom_entreprise, adresse_entreprise, delai_paiement, date_paiement]
        );

        res.status(201).json({
            success: true,
            message: 'Facture créée avec succès',
            factureId: result.insertId
        });
    } catch (error) {
        console.error('Erreur lors de la création de la facture:', error);
        res.status(500).json({
            success: false,
            message: 'Erreur lors de la création de la facture'
        });
    }
};

// Mettre à jour le statut de paiement d'une facture
exports.updatePaymentStatus = async (req, res) => {
    try {
        const factureId = req.params.id;
        const userId = req.user.id || req.user.userId;
        const userRole = req.user.role;

        // Vérifier que la facture existe et appartient à l'utilisateur ou est accessible par le client
        let query = `
            SELECT r.id, r.owner_id, c.user_id as client_user_id
            FROM remplissage r
            LEFT JOIN clients c ON r.client_id = c.id
            WHERE r.id = ? AND r.type_document = 'facture'
        `;
        
        const [rows] = await db.query(query, [factureId]);
        
        if (rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Facture non trouvée'
            });
        }
        
        // Vérifier les permissions selon le rôle
        if (userRole === 'client' && rows[0].client_user_id !== userId) {
            return res.status(403).json({
                success: false,
                message: 'Vous n\'avez pas les droits pour modifier cette facture'
            });
        } else if (userRole !== 'client' && rows[0].owner_id !== userId) {
            return res.status(403).json({
                success: false,
                message: 'Vous n\'avez pas les droits pour modifier cette facture'
            });
        }
        
        // Mettre à jour le statut dans la table document
        await db.query(
            `UPDATE document 
             SET status = 'Payée', status_client = 'paid' 
             WHERE remplissage_id = ?`,
            [factureId]
        );
        
        // Ne pas mettre à jour la date de paiement dans la table remplissage comme demandé par l'utilisateur
        
        res.json({
            success: true,
            message: 'Statut de paiement mis à jour avec succès'
        });
        
    } catch (error) {
        console.error('Erreur lors de la mise à jour du statut de paiement:', error);
        res.status(500).json({
            success: false,
            message: 'Erreur lors de la mise à jour du statut de paiement'
        });
    }
};

// Mettre à jour une facture existante
exports.updateFacture = async (req, res) => {
    try {
        const factureId = req.params.id;
        const { client_id, produit_id, template_id, quantite, montant_ht, taux_tva, montant_tva, montant_ttc, nom_entreprise, adresse_entreprise, delai_paiement, date_paiement } = req.body;
        const userId = req.user.id || req.user.userId;

        // Vérifier que la facture appartient bien à l'utilisateur
        const [checkRows] = await db.query(
            'SELECT id FROM remplissage WHERE id = ? AND owner_id = ? AND type_document = "facture"',
            [factureId, userId]
        );

        if (checkRows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Facture non trouvée ou non autorisée'
            });
        }

        // Mettre à jour la facture dans la table remplissage
        await db.query(
            `UPDATE remplissage SET 
            client_id = ?, produit_id = ?, template_id = ?, quantite = ?, 
            montant_ht = ?, montant_tva = ?, taux_tva = ?, montant_ttc = ?, 
            nom_entreprise = ?, adresse_entreprise = ?, delai_paiement = ?, date_paiement = ? 
            WHERE id = ? AND type_document = 'facture'`,
            [client_id, produit_id, template_id, quantite, montant_ht, montant_tva, taux_tva, montant_ttc, nom_entreprise, adresse_entreprise, delai_paiement, date_paiement, factureId]
        );

        res.json({
            success: true,
            message: 'Facture mise à jour avec succès'
        });
    } catch (error) {
        console.error('Erreur lors de la mise à jour de la facture:', error);
        res.status(500).json({
            success: false,
            message: 'Erreur lors de la mise à jour de la facture'
        });
    }
};

// Supprimer une facture
exports.deleteFacture = async (req, res) => {
    try {
        const factureId = req.params.id;
        const userId = req.user.id || req.user.userId;

        // Vérifier que la facture appartient bien à l'utilisateur
        const [checkRows] = await db.query(
            'SELECT id FROM remplissage WHERE id = ? AND owner_id = ? AND type_document = "facture"',
            [factureId, userId]
        );

        if (checkRows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Facture non trouvée ou non autorisée'
            });
        }

        // Supprimer la facture de la table remplissage
        await db.query('DELETE FROM remplissage WHERE id = ? AND type_document = "facture"', [factureId]);

        res.json({
            success: true,
            message: 'Facture supprimée avec succès'
        });
    } catch (error) {
        console.error('Erreur lors de la suppression de la facture:', error);
        res.status(500).json({
            success: false,
            message: 'Erreur lors de la suppression de la facture'
        });
    }
};
