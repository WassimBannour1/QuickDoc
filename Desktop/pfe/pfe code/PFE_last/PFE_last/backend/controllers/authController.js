const db = require('../config/db');
const nodemailer = require('nodemailer');
const bcrypt = require('bcrypt');
const saltRounds = 10; // Nombre de tours pour le hachage bcrypt

// Add this email configuration
const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: 'quikdoc8@gmail.com', // Email pour l'envoi des notifications
        pass: 'yzph kfub ggot lsnl'  // Mot de passe d'application
    }
});

const forgotPassword = async (req, res) => {
    try {
        const { email } = req.body;
        const [rows] = await db.query(
            'SELECT * FROM users WHERE email = ?', 
            [email.toLowerCase()]
        );
        
        if (!rows || rows.length === 0) {
            console.log('User not found for email:', email);
            return res.status(404).json({ 
                success: false,
                message: 'Adresse email non trouvée' 
            });
        }

        // Generate reset code
        const resetCode = Math.floor(100000 + Math.random() * 900000).toString();
        const resetCodeExpiry = new Date(Date.now() + 30 * 60000); // 30 minutes

        // Update user with reset code
        await db.query(
            'UPDATE users SET reset_code = ?, reset_code_expired = ? WHERE email = ?',
            [resetCode, resetCodeExpiry, email]
        );

        // Send reset code email
        const mailOptions = {
            from: 'quikdoc8@gmail.com',
            to: email,
            subject: 'Code de réinitialisation de mot de passe QuikDoc',
            html: `
                <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
                    <h1 style="color: #002446; text-align: center;">Réinitialisation de mot de passe</h1>
                    <p style="color: #666;">Vous avez demandé une réinitialisation de mot de passe.</p>
                    <p style="color: #666;">Voici votre code de réinitialisation :</p>
                    <div style="background-color: #f5f5f5; padding: 20px; border-radius: 5px; text-align: center; margin: 20px 0;">
                        <h2 style="color: #002446; font-size: 32px; margin: 0;">${resetCode}</h2>
                    </div>
                    <p style="color: #666;">Ce code expirera dans 30 minutes.</p>
                    <p style="color: #666;">Si vous n'avez pas demandé de réinitialisation de mot de passe, veuillez ignorer cet email.</p>
                    <div style="text-align: center; margin-top: 30px; color: #999; font-size: 12px;">
                        <p>Cet email a été envoyé automatiquement, merci de ne pas y répondre.</p>
                    </div>
                </div>
            `
        };

        await transporter.sendMail(mailOptions);
        console.log('Reset code generated and email sent for:', email, 'Code:', resetCode);
        
        res.json({ 
            success: true,
            message: 'Code de réinitialisation envoyé avec succès'
        });

    } catch (error) {
        console.error('Forgot password error:', error);
        res.status(500).json({ 
            success: false,
            message: 'Erreur lors de la réinitialisation du mot de passe' 
        });
    }
};

const verifyResetCode = async (req, res) => {
    try {
        const { email, code } = req.body;
        const [rows] = await db.query(
            'SELECT * FROM users WHERE email = ? AND reset_code = ? AND reset_code_expired > NOW()',
            [email.toLowerCase(), code.toUpperCase()]
        );

        if (!rows || rows.length === 0) {
            console.log('No matching records found');
            return res.status(400).json({
                success: false,
                message: 'Code invalide ou expiré'
            });
        }

        console.log('Valid code found, sending success response');
        res.json({
            success: true,
            message: 'Code vérifié avec succès'
        });

    } catch (error) {
        console.error('Error in verifyResetCode:', error);
        console.error('Stack trace:', error.stack);
        res.status(500).json({
            success: false,
            message: 'Une erreur est survenue lors de la vérification du code'
        });
    }
};

const resetPassword = async (req, res) => {
    try {
        const { email, code, newPassword } = req.body;
        
        console.log('Reset password request received:', { email, code, hasPassword: !!newPassword });
        
        // Verify the reset code is valid and not expired
        const [rows] = await db.query(
            'SELECT * FROM users WHERE email = ? AND reset_code = ? AND reset_code_expired > NOW()',
            [email.toLowerCase(), code]
        );

        if (!rows || rows.length === 0) {
            console.log('Invalid reset code or expired code for email:', email);
            return res.status(400).json({
                success: false,
                message: 'Code invalide ou expiré'
            });
        }

        // Hacher le nouveau mot de passe avant de l'enregistrer
        const hashedPassword = await bcrypt.hash(newPassword, saltRounds);

        // Update the user's password with hashed password
        await db.query(
            'UPDATE users SET password = ?, reset_code = NULL, reset_code_expired = NULL WHERE email = ?',
            [hashedPassword, email.toLowerCase()]
        );

        console.log('Password successfully reset for email:', email);
        
        res.json({
            success: true,
            message: 'Mot de passe réinitialisé avec succès'
        });

    } catch (error) {
        console.error('Reset password error:', error);
        console.error('Stack trace:', error.stack);
        res.status(500).json({
            success: false,
            message: 'Une erreur est survenue lors de la réinitialisation du mot de passe'
        });
    }
};

const signup = async (req, res) => {
    try {
        const { first_name, last_name, email, password, role, raison_sociale, siret } = req.body;
        
        // Vérifier si l'utilisateur existe déjà dans la table users
        const [existingUser] = await db.query(
            'SELECT * FROM users WHERE email = ?',
            [email.toLowerCase()]
        );

        if (existingUser.length > 0) {
            return res.status(400).json({
                success: false,
                message: 'Cet email est déjà utilisé'
            });
        }

        // Vérifier si l'email existe dans la table clients (pour un compte existant)
        const [existingClient] = await db.query(
            'SELECT * FROM clients WHERE email = ?',
            [email.toLowerCase()]
        );

        const isExistingClient = existingClient.length > 0;

        // For enterprise_admin role, check if SIRET already exists
        if (role === 'enterprise_admin') {
            if (!siret || siret.length !== 14 || !/^\d+$/.test(siret)) {
                return res.status(400).json({
                    success: false,
                    message: 'Le numéro SIRET doit contenir exactement 14 chiffres'
                });
            }

            if (!raison_sociale) {
                return res.status(400).json({
                    success: false,
                    message: 'La raison sociale est requise pour une entreprise'
                });
            }

            // Check if SIRET already exists in entreprises table
            const [existingSiret] = await db.query(
                'SELECT * FROM entreprises WHERE siret = ?',
                [siret]
            );

            if (existingSiret.length > 0) {
                return res.status(400).json({
                    success: false,
                    message: 'Ce numéro SIRET est déjà enregistré'
                });
            }
        }

        // Generate verification code
        const verificationCode = Math.floor(100000 + Math.random() * 900000).toString();
        const verificationExpiry = new Date(Date.now() + 24 * 60 * 60000); // 24 hours

        // Hacher le mot de passe avant de l'enregistrer
        const hashedPassword = await bcrypt.hash(password, saltRounds);

        // Insert new user with verification code and hashed password
        const [result] = await db.query(
            'INSERT INTO users (first_name, last_name, email, password, role, verification_code, verification_code_expired, is_verified, isActive) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
            [first_name, last_name, email.toLowerCase(), hashedPassword, role, verificationCode, verificationExpiry, false, 1]
        );

        const newUserId = result.insertId;

        // Si l'email existe dans la table clients, mettre à jour la colonne user_id
        if (isExistingClient) {
            await db.query(
                'UPDATE clients SET user_id = ? WHERE email = ?',
                [newUserId, email.toLowerCase()]
            );
            console.log(`Client existant trouvé pour l'email ${email}, user_id mis à jour avec ${newUserId}`);
        }

        // For enterprise_admin role, create an entry in the entreprises table
        if (role === 'enterprise_admin' && newUserId) {
            // Create the enterprise record
            await db.query(
                'INSERT INTO entreprises (siret, owner_id, nom_entreprise) VALUES (?, ?, ?)',
                [siret, newUserId, raison_sociale]
            );
        }

        // Send verification email
        const mailOptions = {
            from: 'quikdoc8@gmail.com',
            to: email,
            subject: 'Vérification de votre compte QuikDoc',
            html: `
                <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
                    <h1 style="color: #002446; text-align: center;">Bienvenue sur QuikDoc!</h1>
                    <p style="color: #666;">Cher(e) ${first_name},</p>
                    <p style="color: #666;">Merci de vous être inscrit. Pour activer votre compte, veuillez utiliser le code de vérification suivant :</p>
                    <div style="background-color: #f5f5f5; padding: 20px; border-radius: 5px; text-align: center; margin: 20px 0;">
                        <h2 style="color: #002446; font-size: 32px; margin: 0;">${verificationCode}</h2>
                    </div>
                    <p style="color: #666;">Ce code expirera dans 24 heures.</p>
                    <p style="color: #666;">Si vous n'avez pas créé de compte sur QuikDoc, veuillez ignorer cet email.</p>
                    <div style="text-align: center; margin-top: 30px; color: #999; font-size: 12px;">
                        <p>Cet email a été envoyé automatiquement, merci de ne pas y répondre.</p>
                    </div>
                </div>
            `
        };

        await transporter.sendMail(mailOptions);
        console.log('Verification email sent to:', email);

        // Message différent selon si c'est un nouveau compte ou un compte existant
        const message = isExistingClient 
            ? 'Compte créé avec succès! Votre profil client existant a été lié à votre nouveau compte. Veuillez vérifier votre email pour activer votre compte.'
            : 'Inscription réussie! Veuillez vérifier votre email pour activer votre compte.';

        res.status(201).json({
            success: true,
            message: message,
            isExistingClient: isExistingClient
        });

    } catch (error) {
        console.error('Signup error:', error);
        res.status(500).json({
            success: false,
            message: 'Erreur lors de l\'inscription'
        });
    }
};

const verifyEmail = async (req, res) => {
    try {
        const { email, code } = req.body;
        const [rows] = await db.query(
            'SELECT * FROM users WHERE email = ? AND verification_code = ? AND verification_code_expired > NOW() AND is_verified = false',
            [email.toLowerCase(), code]
        );

        if (!rows || rows.length === 0) {
            return res.status(400).json({
                success: false,
                message: 'Code invalide ou expiré'
            });
        }

        // Update user as verified
        await db.query(  // Removed .promise()
            'UPDATE users SET is_verified = true WHERE email = ?',
            [email.toLowerCase()]
        );

        res.json({
            success: true,
            message: 'Email vérifié avec succès'
        });

    } catch (error) {
        console.error('Email verification error:', error);
        res.status(500).json({
            success: false,
            message: 'Erreur lors de la vérification de l\'email'
        });
    }
};

const signin = async (req, res) => {
    const { email, password } = req.body;

    try {
        // Récupérer l'utilisateur par email uniquement
        const [rows] = await db.execute(
            'SELECT * FROM users WHERE email = ?',
            [email.toLowerCase()]
        );

        if (!rows || rows.length === 0) {
            return res.status(401).json({
                success: false,
                message: 'Email ou mot de passe incorrect'
            });
        }
        
        // Comparer le mot de passe fourni avec le hash stocké
        const passwordMatch = await bcrypt.compare(password, rows[0].password);
        
        if (!passwordMatch) {
            return res.status(401).json({
                success: false,
                message: 'Email ou mot de passe incorrect'
            });
        }

        if (!rows[0].is_verified) {
            return res.status(403).json({
                success: false,
                message: 'Veuillez vérifier votre email avant de vous connecter'
            });
        }
        
        // Vérification si le compte est actif (ajouté)
        if (rows[0].isActive === 0) {
            return res.status(403).json({
                success: false,
                message: 'Votre compte a été désactivé par un administrateur. Veuillez contacter le support.'
            });
        }

        // Générer un token JWT valide
        const jwt = require('jsonwebtoken');
        const token = jwt.sign(
            { 
                userId: rows[0].id,
                email: rows[0].email,
                role: rows[0].role 
            }, 
            process.env.JWT_SECRET || 'your-secret-key',
            { expiresIn: '24h' }
        );

        // For enterprise admin, fetch enterprise details
        let enterpriseData = null;
        if (rows[0].role === 'enterprise_admin') {
            const [enterprise] = await db.query(
                'SELECT * FROM entreprises WHERE owner_id = ?',
                [rows[0].id]
            );
            
            if (enterprise && enterprise.length > 0) {
                enterpriseData = enterprise[0];
            }
        }

        // Send more user data in response with token
        res.status(200).json({
            success: true,
            message: 'Connexion réussie',
            token: token,
            user: {
                id: rows[0].id,
                email: rows[0].email,
                first_name: rows[0].first_name,
                last_name: rows[0].last_name,
                role: rows[0].role,
                enterprise: enterpriseData // Include enterprise data if available
            }
        });

    } catch (error) {
        console.error('Signin error:', error);
        res.status(500).json({
            success: false,
            message: 'Erreur de connexion à la base de données'
        });
    }
};

// Update the exports
module.exports = {
    signup,
    forgotPassword,
    verifyResetCode,
    resetPassword,
    verifyEmail,
    signin
};