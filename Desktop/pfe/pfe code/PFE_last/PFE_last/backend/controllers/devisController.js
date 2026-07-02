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

// Envoyer un devis par email
exports.sendDevisByEmail = async (req, res) => {
    try {
        const devisId = req.params.id;
        const { to, subject, message, attachPdf } = req.body;
        const userId = req.user.id || req.user.userId;

        // Vérifier que le devis existe
        const [rows] = await db.query(
            `SELECT r.*, c.name as client_name, c.last_name as client_last_name, d.status as document_status 
            FROM remplissage r 
            LEFT JOIN clients c ON r.client_id = c.id 
            LEFT JOIN document d ON r.id = d.remplissage_id
            WHERE r.id = ? AND r.type_document = 'devis'`,
            [devisId]
        );

        if (rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Devis non trouvé'
            });
        }

        const devis = {
            id: rows[0].id,
            reference: `DEVIS-${rows[0].id}`,
            date: rows[0].created_at,
            company: rows[0].entreprise_name || rows[0].nom_entreprise,
            amount: rows[0].montant_ttc,
            status: rows[0].document_status || 'Non envoyé'
        };

        // Préparer les options de l'email
        const mailOptions = {
            from: 'quikdoc8@gmail.com',
            to: to,
            subject: subject || `Devis ${devis.reference}`,
            html: `
                <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; border: 1px solid #e0e0e0; border-radius: 8px; overflow: hidden;">
                    <div style="background-color: #002446; padding: 20px; text-align: center;">
                        <h1 style="color: #ffffff; margin: 0;">Devis ${devis.reference}</h1>
                    </div>
                    <div style="padding: 30px;">
                        <p style="color: #444; line-height: 1.5;">${message || `Veuillez trouver ci-joint le devis ${devis.reference}.`}</p>
                        <div style="background-color: #f5f5f5; padding: 20px; border-radius: 5px; margin: 20px 0; border-left: 4px solid #002446;">
                            <h3 style="color: #002446; margin-top: 0;">Détails du devis</h3>
                            <p><strong>Référence:</strong> ${devis.reference}</p>
                            <p><strong>Date:</strong> ${new Date(devis.date).toLocaleDateString()}</p>
                            <p><strong>Entreprise:</strong> ${devis.company}</p>
                            <p><strong>Montant:</strong> ${devis.amount} €</p>
                            <p><strong>État:</strong> ${devis.status}</p>
                        </div>
                        <p style="color: #444; margin-bottom: 5px;">Cordialement,</p>
                        <p style="color: #444; font-weight: bold; margin-top: 0;">L'équipe QuikDoc</p>
                    </div>
                    <div style="background-color: #f5f5f5; padding: 15px; text-align: center; color: #777; font-size: 12px;">
                        <p style="margin: 0;">Cet email a été envoyé automatiquement, merci de ne pas y répondre.</p>
                        <p style="margin: 5px 0 0 0;">© ${new Date().getFullYear()} QuikDoc - Tous droits réservés</p>
                    </div>
                </div>
            `
        };

        // Si on doit joindre le PDF
        if (attachPdf) {
            try {
                console.log('Pièce jointe demandée pour le devis:', devisId);
                
                // Récupérer le document depuis la table document en utilisant le remplissage_id
                const [documents] = await db.query(
                    'SELECT * FROM document WHERE remplissage_id = ?',
                    [devisId]
                );
                
                if (documents.length === 0) {
                    console.log(`Aucun document trouvé avec remplissage_id: ${devisId}`);
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
                                filename: `Devis_${devis.reference}.pdf`,
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
            message: 'Devis envoyé par email avec succès',
            notification: {
                type: 'success',
                title: 'Email envoyé !',
                message: 'Le devis a été envoyé avec succès au destinataire.',
                icon: 'paper-plane',
                color: '#1e3a8a', // Couleur de la barre latérale (bleu foncé)
                duration: 5000,
                position: 'top-right'
            }
        });

    } catch (error) {
        console.error('Erreur lors de l\'envoi du devis par email:', error);
        res.status(500).json({
            success: false,
            message: 'Erreur lors de l\'envoi du devis par email'
        });
    }
};

// Accepter un devis
exports.acceptDevis = async (req, res) => {
    try {
        const devisId = req.params.id;
        const userId = req.user.id || req.user.userId;
        const userRole = req.user.role;

        // Vérifier que le devis existe
        let query = `
            SELECT r.*, d.id as document_id, d.status, d.status_client
            FROM remplissage r 
            INNER JOIN document d ON r.id = d.remplissage_id
            WHERE r.id = ? AND r.type_document = 'devis'`;
        
        // Paramètres pour la requête
        let params = [devisId];
        
        // Si l'utilisateur est un client, vérifier qu'il est bien le client associé au devis
        if (userRole === 'client') {
            query += ` AND r.client_id IN (SELECT id FROM clients WHERE user_id = ?)`;
            params.push(userId);
        } else {
            // Pour les autres rôles (admin, enterprise_admin), vérifier qu'ils sont bien le propriétaire
            query += ` AND r.owner_id = ?`;
            params.push(userId);
        }
        
        const [rows] = await db.query(query, params);

        if (rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Devis non trouvé ou vous n\'avez pas les droits pour le modifier'
            });
        }

        const devis = rows[0];
        const documentId = devis.document_id;

        // Mettre à jour le statut du document
        await db.query(
            `UPDATE document SET status = 'Acceptée', status_client = 'accepted' WHERE id = ?`,
            [documentId]
        );

        res.json({
            success: true,
            message: 'Devis accepté avec succès',
            notification: {
                type: 'success',
                title: 'Devis accepté !',
                message: 'Le devis a été marqué comme accepté.',
                icon: 'check-circle',
                color: '#1e3a8a',
                duration: 5000,
                position: 'top-right'
            }
        });

    } catch (error) {
        console.error('Erreur lors de l\'acceptation du devis:', error);
        res.status(500).json({
            success: false,
            message: 'Erreur lors de l\'acceptation du devis'
        });
    }
};

// Refuser un devis
exports.rejectDevis = async (req, res) => {
    try {
        const devisId = req.params.id;
        const userId = req.user.id || req.user.userId;
        const userRole = req.user.role;

        // Vérifier que le devis existe
        let query = `
            SELECT r.*, d.id as document_id, d.status, d.status_client
            FROM remplissage r 
            INNER JOIN document d ON r.id = d.remplissage_id
            WHERE r.id = ? AND r.type_document = 'devis'`;
        
        // Paramètres pour la requête
        let params = [devisId];
        
        // Si l'utilisateur est un client, vérifier qu'il est bien le client associé au devis
        if (userRole === 'client') {
            query += ` AND r.client_id IN (SELECT id FROM clients WHERE user_id = ?)`;
            params.push(userId);
        } else {
            // Pour les autres rôles (admin, enterprise_admin), vérifier qu'ils sont bien le propriétaire
            query += ` AND r.owner_id = ?`;
            params.push(userId);
        }
        
        const [rows] = await db.query(query, params);

        if (rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Devis non trouvé ou vous n\'avez pas les droits pour le modifier'
            });
        }

        const devis = rows[0];
        const documentId = devis.document_id;

        // Mettre à jour le statut du document
        await db.query(
            `UPDATE document SET status = 'Annulée', status_client = 'canceled' WHERE id = ?`,
            [documentId]
        );

        res.json({
            success: true,
            message: 'Devis refusé avec succès',
            notification: {
                type: 'success',
                title: 'Devis refusé !',
                message: 'Le devis a été marqué comme annulé.',
                icon: 'times-circle',
                color: '#1e3a8a',
                duration: 5000,
                position: 'top-right'
            }
        });

    } catch (error) {
        console.error('Erreur lors du refus du devis:', error);
        res.status(500).json({
            success: false,
            message: 'Erreur lors du refus du devis'
        });
    }
};

// Récupérer tous les devis
exports.getAllDevis = async (req, res) => {
    try {
        // Récupérer l'ID et le rôle de l'utilisateur à partir du token
        const userId = req.user.id || req.user.userId;
        const userRole = req.user.role;
        const { client_id, client_name, date_from, date_to, montant_min, montant_max, status, search } = req.query;
        
        // Construction de la requête SQL de base avec jointure sur la table users et entreprises
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
            query += `c.user_id = ? AND r.type_document = 'devis'`;
            params.push(userId);
        } else {
            // Pour les autres rôles (admin, enterprise_admin), filtrer par owner_id
            query += `r.owner_id = ? AND r.type_document = 'devis'`;
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
                // Utilisation de LIKE avec % au début et à la fin pour une recherche plus flexible
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
                
                // Ajouter une condition pour rechercher chaque terme dans n'importe quel ordre
                // Cela permet de trouver des correspondances même si l'ordre des mots est différent
                const combinedCondition = searchTerms.map(term => {
                    return `(LOWER(c.name) LIKE '%${term}%' OR LOWER(c.last_name) LIKE '%${term}%')`;
                }).join(" AND ");
                
                conditions.push(`(${combinedCondition})`);
                
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
            // Les valeurs attendues sont: 'pending', 'accepted', 'rejected'
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
            
            // Recherche par référence (numéro de devis)
            searchConditions.push("LOWER(CONCAT('DEVIS-', r.id)) LIKE LOWER(?)");
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
                    
                    // Recherche où les termes peuvent apparaître dans n'importe quel ordre
                    // Cela permet de trouver des correspondances même si l'utilisateur entre les termes dans un ordre différent
                    let flexibleConditions = [];
                    terms.forEach(term => {
                        const termPattern = `%${term}%`;
                        flexibleConditions.push("LOWER(c.name) LIKE LOWER(?)");
                        searchParams.push(termPattern);
                        flexibleConditions.push("LOWER(c.last_name) LIKE LOWER(?)");
                        searchParams.push(termPattern);
                    });
                    searchConditions.push(`(${flexibleConditions.join(" OR ")})`); 
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
        
        console.log('Requête SQL pour les devis:', query);
        console.log('Paramètres:', params);
        
        // Exécution de la requête
        const [rows] = await db.query(query, params);
        console.log(`Nombre de devis trouvés: ${rows.length}`);
        
        // Transformer les données pour correspondre au format attendu par le frontend
        const devis = rows.map(doc => ({
            id: doc.id,
            reference: doc.serie_number || `DEVIS-${doc.id}`,
            date: doc.created_at,
            company: doc.entreprise_name || doc.nom_entreprise,
            client: `${doc.client_name || ''} ${doc.client_last_name || ''}`.trim(),
            client_id: doc.client_id,
            amount: doc.montant_ttc,
            status: doc.document_status || 'Non envoyé',
            status_client: doc.status_client || 'pending',
            type: 'devis',
            // Utiliser serie_number s'il existe, sinon utiliser la référence formatée
            name: doc.serie_number || `DEVIS-${doc.id}`
        }));

        res.json({
            success: true,
            data: devis
        });
    } catch (error) {
        console.error('Erreur lors de la récupération des devis:', error);
        res.status(500).json({
            success: false,
            message: 'Erreur lors de la récupération des devis'
        });
    }
};

// Récupérer un devis par son ID
exports.getDevisById = async (req, res) => {
    try {
        const devisId = req.params.id;
        const userId = req.user.id || req.user.userId;
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
        let params = [devisId];
        
        // Si l'utilisateur est un client, filtrer par client_id associé à cet utilisateur
        if (userRole === 'client') {
            query += `c.user_id = ? AND r.type_document = 'devis'`;
            params.push(userId);
        } else {
            // Pour les autres rôles (admin, enterprise_admin), filtrer par owner_id
            query += `r.owner_id = ? AND r.type_document = 'devis'`;
            params.push(userId);
        }
        
        // Exécuter la requête
        const [rows] = await db.query(query, params);

        if (rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Devis non trouvé'
            });
        }

        // Transformer les données pour correspondre au format attendu
        const devis = {
            id: rows[0].id,
            reference: rows[0].serie_number || `DEVIS-${rows[0].id}`,
            date: rows[0].created_at,
            company: rows[0].entreprise_name || rows[0].nom_entreprise,
            client: {
                name: `${rows[0].client_name || ''} ${rows[0].client_last_name || ''}`.trim(),
                id: rows[0].client_id,
                email: rows[0].client_email
            },
            amount: rows[0].montant_ttc,
            status: rows[0].document_status || 'Non envoyé',
            status_client: rows[0].status_client || 'pending',
            type: 'devis'
        };

        res.json({
            success: true,
            data: devis
        });
    } catch (error) {
        console.error('Erreur lors de la récupération du devis:', error);
        res.status(500).json({
            success: false,
            message: 'Erreur lors de la récupération du devis'
        });
    }
};

// Créer un nouveau devis
exports.createDevis = async (req, res) => {
    try {
        const { client_id, template_id, montant_ht, taux_tva, montant_tva, montant_ttc, nom_entreprise, adresse_entreprise, delai_paiement } = req.body;
        const userId = req.user.id;

        // Insérer le nouveau devis dans la table remplissage
        const [result] = await db.query(
            `INSERT INTO remplissage 
            (client_id, owner_id, template_id, type_document, 
            montant_ht, montant_tva, taux_tva, montant_ttc, nom_entreprise, adresse_entreprise, delai_paiement) 
            VALUES (?, ?, ?, 'devis', ?, ?, ?, ?, ?, ?, ?)`,
            [client_id, userId, template_id, montant_ht, montant_tva, taux_tva, montant_ttc, nom_entreprise, adresse_entreprise, delai_paiement]
        );

        res.status(201).json({
            success: true,
            message: 'Devis créé avec succès',
            devisId: result.insertId
        });
    } catch (error) {
        console.error('Erreur lors de la création du devis:', error);
        res.status(500).json({
            success: false,
            message: 'Erreur lors de la création du devis'
        });
    }
};

// Mettre à jour un devis existant
exports.updateDevis = async (req, res) => {
    try {
        const devisId = req.params.id;
        const { client_id, template_id, montant_ht, taux_tva, montant_tva, montant_ttc, nom_entreprise, adresse_entreprise, delai_paiement } = req.body;
        const userId = req.user.id;

        // Vérifier que le devis appartient bien à l'utilisateur
        const [checkRows] = await db.query(
            'SELECT id FROM remplissage WHERE id = ? AND owner_id = ? AND type_document = "devis"',
            [devisId, userId]
        );

        if (checkRows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Devis non trouvé ou non autorisé'
            });
        }

        // Mettre à jour le devis dans la table remplissage
        await db.query(
            `UPDATE remplissage SET 
            client_id = ?, template_id = ?, 
            montant_ht = ?, montant_tva = ?, taux_tva = ?, montant_ttc = ?, 
            nom_entreprise = ?, adresse_entreprise = ?, delai_paiement = ? 
            WHERE id = ? AND type_document = 'devis'`,
            [client_id, template_id, montant_ht, montant_tva, taux_tva, montant_ttc, nom_entreprise, adresse_entreprise, delai_paiement, devisId]
        );

        res.json({
            success: true,
            message: 'Devis mis à jour avec succès'
        });
    } catch (error) {
        console.error('Erreur lors de la mise à jour du devis:', error);
        res.status(500).json({
            success: false,
            message: 'Erreur lors de la mise à jour du devis'
        });
    }
};

// Supprimer un devis
exports.deleteDevis = async (req, res) => {
    try {
        const devisId = req.params.id;
        const userId = req.user.id;

        // Vérifier que le devis appartient bien à l'utilisateur
        const [checkRows] = await db.query(
            'SELECT id FROM remplissage WHERE id = ? AND owner_id = ? AND type_document = "devis"',
            [devisId, userId]
        );

        if (checkRows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Devis non trouvé ou non autorisé'
            });
        }

        // Supprimer le devis de la table remplissage
        await db.query('DELETE FROM remplissage WHERE id = ? AND type_document = "devis"', [devisId]);

        res.json({
            success: true,
            message: 'Devis supprimé avec succès'
        });
    } catch (error) {
        console.error('Erreur lors de la suppression du devis:', error);
        res.status(500).json({
            success: false,
            message: 'Erreur lors de la suppression du devis'
        });
    }
};