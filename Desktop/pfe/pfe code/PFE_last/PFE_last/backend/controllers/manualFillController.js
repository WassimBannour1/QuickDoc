const db = require('../config/db');

/**
 * Contrôleur pour la gestion du remplissage manuel des documents
 * Ce contrôleur permet de sauvegarder les données du formulaire dans les tables remplissage et remplissage_products
 */

// Créer un nouveau document avec des produits associés
exports.createManualFillDocument = async (req, res) => {
    try {
        const userId = req.user.id || req.user.userId;
        const { remplissageData, products } = req.body;

        // Validation des données
        if (!remplissageData || !products || !Array.isArray(products)) {
            return res.status(400).json({
                success: false,
                message: 'Données manquantes ou invalides pour la création du document'
            });
        }

        // Vérifier que l'utilisateur est bien le propriétaire
        if (remplissageData.owner_id !== userId) {
            return res.status(403).json({
                success: false,
                message: 'Vous n\'êtes pas autorisé à créer un document pour un autre utilisateur'
            });
        }

        // Démarrer une transaction pour garantir l'intégrité des données
        const connection = await db.getConnection();
        await connection.beginTransaction();

        try {
            // Insertion dans la table remplissage
            const [remplissageResult] = await connection.query(
                `INSERT INTO remplissage (
                    entreprise_id,
                    client_id,
                    template_id,
                    owner_id,
                    serie_number,
                    type_document,
                    montant_ht,
                    total_remise,
                    montant_tva,
                    taux_tva,
                    montant_ttc,
                    details_bancaire,
                    date_document,
                    avertissement,
                    delai_paiement
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
                [
                    remplissageData.entreprise_id,
                    remplissageData.client_id,
                    remplissageData.template_id,
                    remplissageData.owner_id,
                    remplissageData.serie_number,
                    remplissageData.type_document,
                    remplissageData.montant_ht,
                    remplissageData.total_remise,
                    remplissageData.montant_tva,
                    remplissageData.taux_tva,
                    remplissageData.montant_ttc,
                    remplissageData.details_bancaire,
                    remplissageData.date_document,
                    remplissageData.avertissement,
                    remplissageData.delai_paiement
                ]
            );

            const remplissageId = remplissageResult.insertId;

            // Insertion des produits dans la table remplissage_products
            for (const product of products) {
                await connection.query(
                    `INSERT INTO remplissage_products (
                        remplissage_id,
                        product_id,
                        quantity,
                        unit_price,
                        unit,
                        total_price,
                        ref,
                        tva
                    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
                    [
                        remplissageId,
                        product.product_id,
                        product.quantity,
                        product.unit_price,
                        product.unit,
                        product.total_price,
                        product.ref,
                        product.tva
                    ]
                );
            }

            // Valider la transaction
            await connection.commit();

            // Récupérer le document créé avec ses produits
            const [remplissage] = await db.query('SELECT * FROM remplissage WHERE id = ?', [remplissageId]);
            const [remplissageProducts] = await db.query('SELECT * FROM remplissage_products WHERE remplissage_id = ?', [remplissageId]);

            res.status(201).json({
                success: true,
                message: `${remplissageData.type_document === 'facture' ? 'Facture' : 'Devis'} créé avec succès`,
                data: {
                    remplissage: remplissage[0],
                    products: remplissageProducts
                }
            });
        } catch (error) {
            // En cas d'erreur, annuler la transaction
            await connection.rollback();
            throw error;
        } finally {
            // Libérer la connexion
            connection.release();
        }
    } catch (error) {
        console.error('Erreur lors de la création du document:', error);
        res.status(500).json({
            success: false,
            message: 'Erreur lors de la création du document',
            error: error.message
        });
    }
};