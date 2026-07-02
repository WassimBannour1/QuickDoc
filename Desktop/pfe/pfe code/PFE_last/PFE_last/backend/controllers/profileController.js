const db = require('../config/db');
const fs = require('fs');
const path = require('path');
const bcrypt = require('bcrypt');
const util = require('util');
const multer = require('multer');

// La configuration de Multer pour le téléchargement de logo a été supprimée car cette fonctionnalité n'est plus nécessaire

// Dossier pour stocker les photos de profil
const UPLOAD_DIR = path.join(__dirname, '../uploads/profiles');

// Créer le dossier s'il n'existe pas
try {
    if (!fs.existsSync(UPLOAD_DIR)) {
        fs.mkdirSync(UPLOAD_DIR, { recursive: true });
        console.log(`Dossier créé: ${UPLOAD_DIR}`);
    } else {
        console.log(`Dossier existant: ${UPLOAD_DIR}`);
    }
} catch (error) {
    console.error(`Erreur lors de la création du dossier ${UPLOAD_DIR}:`, error);
}

// La fonction processLogoUpload a été supprimée car la fonctionnalité de téléchargement de logo n'est plus nécessaire

// Update user profile
const updateProfile = async (req, res) => {
    try {
        
        // After upload is processed, req.body is populated with form fields
        const { id } = req.params;
        let { first_name, last_name, email, current_password, new_password, remove_logo } = req.body;
        let enterpriseData = req.body.enterprise || {};
        
        // Convert enterprise data from FormData format if needed
        if (typeof enterpriseData === 'string') {
            try {
                enterpriseData = JSON.parse(enterpriseData);
            } catch (e) {
                // If it's not valid JSON, it might be in another format
                // In FormData, fields might come as enterprise[field_name]
                enterpriseData = {};
                Object.keys(req.body).forEach(key => {
                    if (key.startsWith('enterprise[') && key.endsWith(']')) {
                        const fieldName = key.slice(11, -1); // Extract field name from enterprise[field_name]
                        enterpriseData[fieldName] = req.body[key];
                    }
                });
            }
        }
        
        // Validation des données
        if (email && !email.match(/^[^\s@]+@[^\s@]+\.[^\s@]+$/)) {
            return res.status(400).json({
                success: false,
                message: 'Format d\'email invalide'
            });
        }
        
        if (new_password && new_password.length < 8) {
            return res.status(400).json({
                success: false,
                message: 'Le mot de passe doit contenir au moins 8 caractères'
            });
        }
        
        // Vérifier si l'utilisateur existe
        const [user] = await db.query('SELECT * FROM users WHERE id = ?', [id]);
        
        if (!user || user.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Utilisateur non trouvé'
            });
        }
        
        // Vérifier si l'email est déjà utilisé par un autre utilisateur
        if (email && email.toLowerCase() !== user[0].email) {
            const [existingUser] = await db.query(
                'SELECT * FROM users WHERE email = ? AND id != ?',
                [email.toLowerCase(), id]
            );
            
            if (existingUser && existingUser.length > 0) {
                return res.status(400).json({
                    success: false,
                    message: 'Cet email est déjà utilisé par un autre utilisateur'
                });
            }
        }
        
        // Préparer les données à mettre à jour
        const updateData = {};
        
        if (first_name) updateData.first_name = first_name.trim();
        if (last_name) updateData.last_name = last_name.trim();
        if (email) updateData.email = email.toLowerCase().trim();
        
        // Traiter le changement de mot de passe si nécessaire
        if (new_password) {
            console.log('Changement de mot de passe demandé sans vérification du mot de passe actuel');
            
            // Stocker le mot de passe en texte brut sans hachage
            updateData.password = new_password;
            console.log('Nouveau mot de passe stocké en texte brut avec succès');
        }
        
        // Le nom de l'entreprise a été retiré de la base de données

        
        // Nous n'utilisons plus de photos de profil, nous utilisons la première lettre du prénom à la place
        // Suppression du code de gestion des photos de profil
        
        // Construire la requête SQL pour la mise à jour
        console.log('Données à mettre à jour:', updateData);
        console.log('Fichier présent:', req.file ? 'Oui' : 'Non');
        console.log('Chemin local de photo:', req.body.local_photo_path ? 'Présent' : 'Absent');
        
        // Vérifier si des données ont été modifiées par rapport aux données actuelles
        let hasChanges = false;
        
        if (first_name && first_name.trim() !== user[0].first_name) hasChanges = true;
        if (last_name && last_name.trim() !== user[0].last_name) hasChanges = true;
        if (email && email.toLowerCase().trim() !== user[0].email) hasChanges = true;
        if (new_password) hasChanges = true;
        
        // Vérifier les changements dans les données d'entreprise
        if (user[0].role === 'enterprise_admin' && req.body.enterprise) {
            // Si des données d'entreprise sont présentes, considérer qu'il y a des changements
            hasChanges = true;
            console.log('Données d\'entreprise présentes, considérant qu\'il y a des changements');
        }
        
        console.log('Des changements détectés:', hasChanges);
        
        if (!hasChanges) {
            console.log('Aucune donnée à mettre à jour détectée');
            return res.status(400).json({
                success: false,
                message: 'Aucune donnée à mettre à jour'
            });
        }
        
        if (Object.keys(updateData).length > 0) {
            const updateFields = Object.keys(updateData).map(key => `${key} = ?`).join(', ');
            const updateValues = Object.values(updateData);
            updateValues.push(id); // Ajouter l'ID à la fin pour la clause WHERE
            
            // Exécuter la mise à jour
            try {
                await db.query(
                    `UPDATE users SET ${updateFields} WHERE id = ?`,
                    updateValues
                );
                console.log(`Profil utilisateur ${id} mis à jour avec succès`);
            } catch (dbError) {
                console.error('Erreur lors de la mise à jour dans la base de données:', dbError);
                return res.status(500).json({
                    success: false,
                    message: 'Erreur lors de la mise à jour du profil dans la base de données'
                });
            }
        }
        
        // Récupérer les données mises à jour de l'utilisateur
        const [updatedUser] = await db.query(
            'SELECT id, first_name, last_name, email, role, is_verified, created_at FROM users WHERE id = ?',
            [id]
        );
        
        // Vérifier si des données d'entreprise ont été envoyées pour un admin d'entreprise
        if (updatedUser[0].role === 'enterprise_admin' && req.body.enterprise) {
            try {
                // Vérifier si une entrée d'entreprise existe déjà pour cet utilisateur
                const [existingEnterprise] = await db.query(
                    'SELECT * FROM entreprises WHERE owner_id = ?',
                    [id]
                );
                
                // Analyser les données d'entreprise si elles sont au format JSON
                let enterpriseData;
                if (typeof req.body.enterprise === 'string') {
                    try {
                        enterpriseData = JSON.parse(req.body.enterprise);
                        console.log('Données d\'entreprise JSON analysées:', enterpriseData);
                    } catch (jsonError) {
                        console.error('Erreur lors de l\'analyse des données d\'entreprise JSON:', jsonError);
                        enterpriseData = req.body.enterprise;
                    }
                } else {
                    enterpriseData = req.body.enterprise;
                }
                
                console.log('Données d\'entreprise reçues:', enterpriseData);
                
                if (existingEnterprise && existingEnterprise.length > 0) {
                    // Mettre à jour l'entreprise existante
                    const updateFields = [];
                    const updateValues = [];
                    
                    // Toujours définir logo_path à NULL
                    updateFields.push('logo_path = ?');
                    updateValues.push(null);
                    
                    // Supprimer l'ancien logo s'il existe
                    if (existingEnterprise[0].logo_path) {
                        const oldLogoPath = path.join(__dirname, '../uploads/logo entreprise', existingEnterprise[0].logo_path);
                        if (fs.existsSync(oldLogoPath)) {
                            fs.unlinkSync(oldLogoPath);
                        }
                    }
                    
                    // Mettre à jour tous les champs, qu'ils aient changé ou non
                    updateFields.push('nom_entreprise = ?');
                    updateValues.push(enterpriseData.nom_entreprise || existingEnterprise[0].nom_entreprise);
                    
                    updateFields.push('email_entreprise = ?');
                    updateValues.push(enterpriseData.email_entreprise || existingEnterprise[0].email_entreprise);
                    
                    updateFields.push('pays = ?');
                    updateValues.push(enterpriseData.pays || existingEnterprise[0].pays);
                    
                    updateFields.push('ville = ?');
                    updateValues.push(enterpriseData.ville || existingEnterprise[0].ville);
                    
                    updateFields.push('adresse = ?');
                    updateValues.push(enterpriseData.adresse || existingEnterprise[0].adresse);
                    
                    updateFields.push('code_postal = ?');
                    updateValues.push(enterpriseData.code_postal || existingEnterprise[0].code_postal);
                    
                    updateFields.push('devise = ?');
                    updateValues.push(enterpriseData.devise || existingEnterprise[0].devise || 'TND');
                    
                    updateFields.push('secteur_activite = ?');
                    updateValues.push(enterpriseData.secteur_activite || existingEnterprise[0].secteur_activite);
                    
                    updateFields.push('telephone = ?');
                    updateValues.push(enterpriseData.telephone || existingEnterprise[0].telephone);
                    
                    if (updateFields.length > 0) {
                        // Ajouter l'ID de l'entreprise pour la clause WHERE
                        updateValues.push(existingEnterprise[0].id);
                        
                        // Exécuter la mise à jour
                        await db.query(
                            `UPDATE entreprises SET ${updateFields.join(', ')} WHERE id = ?`,
                            updateValues
                        );
                    }
                } else {
                    // Créer une nouvelle entrée d'entreprise si aucune n'existe
                    // logo_path est toujours NULL
                    const logoPath = null;
                    
                    await db.query(
                        'INSERT INTO entreprises (owner_id, siret, nom_entreprise, email_entreprise, logo_path, pays, ville, adresse, code_postal, devise, secteur_activite, telephone) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
                        [
                            id,
                            enterpriseData.siret,
                            enterpriseData.nom_entreprise,
                            enterpriseData.email_entreprise || null,
                            logoPath,
                            enterpriseData.pays || null,
                            enterpriseData.ville || null,
                            enterpriseData.adresse || null,
                            enterpriseData.code_postal || null,
                            enterpriseData.devise || 'TND',
                            enterpriseData.secteur_activite || null,
                            enterpriseData.telephone || null
                        ]
                    );
                }
                
                // Récupérer les données mises à jour de l'entreprise
                const [updatedEnterprise] = await db.query(
                    'SELECT * FROM entreprises WHERE owner_id = ?',
                    [id]
                );
                
                // Ajouter les données d'entreprise à la réponse
                if (updatedEnterprise && updatedEnterprise.length > 0) {
                    updatedUser[0].enterprise = updatedEnterprise[0];
                }
            } catch (enterpriseError) {
                console.error('Erreur lors de la mise à jour des données d\'entreprise:', enterpriseError);
                // Continuer malgré l'erreur pour renvoyer au moins les données utilisateur mises à jour
            }
        }
        
        // Formater la réponse
        const userData = {
            ...updatedUser[0]
        };
        
        res.json({
            success: true,
            message: 'Profil mis à jour avec succès',
            user: userData
        });
        
    } catch (error) {
        console.error('Erreur lors de la mise à jour du profil:', error);
        // Fournir un message d'erreur plus détaillé
        let errorMessage = 'Une erreur est survenue lors de la mise à jour du profil';
        
        // Vérifier si l'erreur est liée au fichier
        if (error.message && error.message.includes('fichier')) {
            errorMessage = `Erreur avec la photo de profil: ${error.message}`;
        }
        
        // Vérifier si l'erreur est liée à la base de données
        if (error.code && (error.code === 'ER_DUP_ENTRY' || error.code.includes('ER_'))) {
            errorMessage = `Erreur de base de données: ${error.message}`;
        }
        
        res.status(500).json({
            success: false,
            message: errorMessage
        });
    }
};

// Récupérer les informations du profil utilisateur
const getProfile = async (req, res) => {
    try {
        const { id } = req.params;
        
        // Récupérer les informations de l'utilisateur sans le mot de passe
        const [user] = await db.query(
            'SELECT id, first_name, last_name, email, role, is_verified, created_at FROM users WHERE id = ?',
            [id]
        );
        
        if (!user || user.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Utilisateur non trouvé'
            });
        }
        
        // Formater la réponse
        const userData = {
            ...user[0]
        };
        
        // Si l'utilisateur est un admin d'entreprise, récupérer les données de l'entreprise
        if (userData.role === 'enterprise_admin') {
            try {
                // Récupérer les données de l'entreprise associée à cet utilisateur
                const [enterprise] = await db.query(
                    'SELECT * FROM entreprises WHERE owner_id = ?',
                    [id]
                );
                
                if (enterprise && enterprise.length > 0) {
                    userData.enterprise = enterprise[0];
                }
            } catch (enterpriseError) {
                console.error('Erreur lors de la récupération des données d\'entreprise:', enterpriseError);
                // Continuer malgré l'erreur pour renvoyer au moins les données utilisateur
            }
        }
        
        res.json({
            success: true,
            user: userData
        });
        
    } catch (error) {
        console.error('Erreur lors de la récupération du profil:', error);
        res.status(500).json({
            success: false,
            message: 'Une erreur est survenue lors de la récupération du profil'
        });
    }
};

// La fonction serveLogo a été supprimée car la fonctionnalité de téléchargement de logo n'est plus nécessaire

module.exports = {
    updateProfile,
    getProfile
};