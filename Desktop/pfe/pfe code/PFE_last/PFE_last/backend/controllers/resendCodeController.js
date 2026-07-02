const db = require('../config/db');
const nodemailer = require('nodemailer');

// Email configuration
const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: 'quikdoc8@gmail.com',
        pass: 'yzph kfub ggot lsnl'
    }
});

// Resend reset code for password reset
const resendResetCode = async (req, res) => {
    try {
        const { email } = req.body;
        
        // Check if user exists
        const [rows] = await db.query(
            'SELECT * FROM users WHERE email = ?', 
            [email.toLowerCase()]
        );
        
        if (!rows || rows.length === 0) {
            return res.status(404).json({ 
                success: false,
                message: 'Adresse email non trouvée' 
            });
        }

        // Generate new reset code
        const resetCode = Math.floor(100000 + Math.random() * 900000).toString();
        const resetCodeExpiry = new Date(Date.now() + 30 * 60000); // 30 minutes

        // Update user with new reset code
        await db.query(
            'UPDATE users SET reset_code = ?, reset_code_expired = ? WHERE email = ?',
            [resetCode, resetCodeExpiry, email]
        );

        // Send reset code email
        const mailOptions = {
            from: 'quikdoc8@gmail.com',
            to: email,
            subject: 'Nouveau code de réinitialisation de mot de passe QuikDoc',
            html: `
                <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
                    <h1 style="color: #002446; text-align: center;">Nouveau code de réinitialisation</h1>
                    <p style="color: #666;">Vous avez demandé un nouveau code de réinitialisation de mot de passe.</p>
                    <p style="color: #666;">Voici votre nouveau code :</p>
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
        console.log('New reset code generated and email sent for:', email, 'Code:', resetCode);
        
        res.json({ 
            success: true,
            message: 'Nouveau code de réinitialisation envoyé avec succès'
        });

    } catch (error) {
        console.error('Resend reset code error:', error);
        res.status(500).json({ 
            success: false,
            message: 'Erreur lors de l\'envoi du nouveau code de réinitialisation' 
        });
    }
};

// Resend verification code for email verification
const resendVerificationCode = async (req, res) => {
    try {
        const { email } = req.body;
        
        // Check if user exists and is not verified
        const [rows] = await db.query(
            'SELECT * FROM users WHERE email = ? AND is_verified = false', 
            [email.toLowerCase()]
        );
        
        if (!rows || rows.length === 0) {
            return res.status(404).json({ 
                success: false,
                message: 'Adresse email non trouvée ou déjà vérifiée' 
            });
        }

        // Generate new verification code
        const verificationCode = Math.floor(100000 + Math.random() * 900000).toString();
        const verificationExpiry = new Date(Date.now() + 24 * 60 * 60000); // 24 hours

        // Update user with new verification code
        await db.query(
            'UPDATE users SET verification_code = ?, verification_code_expired = ? WHERE email = ?',
            [verificationCode, verificationExpiry, email]
        );

        // Send verification code email
        const mailOptions = {
            from: 'quikdoc8@gmail.com',
            to: email,
            subject: 'Nouveau code de vérification QuikDoc',
            html: `
                <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
                    <h1 style="color: #002446; text-align: center;">Vérification de votre compte</h1>
                    <p style="color: #666;">Vous avez demandé un nouveau code de vérification.</p>
                    <p style="color: #666;">Voici votre nouveau code :</p>
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
        console.log('New verification code generated and email sent for:', email, 'Code:', verificationCode);
        
        res.json({ 
            success: true,
            message: 'Nouveau code de vérification envoyé avec succès'
        });

    } catch (error) {
        console.error('Resend verification code error:', error);
        res.status(500).json({ 
            success: false,
            message: 'Erreur lors de l\'envoi du nouveau code de vérification' 
        });
    }
};

module.exports = {
    resendResetCode,
    resendVerificationCode
}