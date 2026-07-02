const express = require('express');
const router = express.Router();

router.get('/test', (req, res) => {
  res.json({ message: 'Backend is working!' });
});
const bcrypt = require('bcrypt');
const userModel = require('../models/user');
const nodemailer = require('nodemailer');
const jwt = require('jsonwebtoken'); // Add this at the top with other requires

// Configure your email transporter
const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: 'quikdoc8@gmail.com',
    pass: 'yzph kfub ggot lsnl' // App Password
  }
});

router.post('/signup', async (req, res) => {
  try {
    const { first_name, last_name, email, password, role } = req.body;

    // Generate verification code
    const verification_code = Math.floor(100000 + Math.random() * 900000).toString();
    console.log('Generated verification code:', verification_code);
    
    // Set expiration time (24 hours from now)
    const verification_code_expired = new Date(Date.now() + 24 * 60 * 60 * 1000);

    // Check if user already exists
    userModel.findUserByEmail(email, async (err, existingUser) => {
      if (err) {
        console.error('Database error:', err);
        return res.status(500).json({ error: 'Database error' });
      }
      
      console.log('Existing user check:', existingUser); // Add this log
      
      if (existingUser) {
        return res.status(400).json({ error: 'Cet email est déjà utilisé', message: 'Cet email est déjà utilisé' });
      }

      // Ne pas hacher le mot de passe pour le stocker en texte brut
      const hashedPassword = password; // Stockage en texte brut

      // Create new user data object
      const userData = {
        first_name,
        last_name,
        email,
        password: hashedPassword,
        role,
        verification_code,
        verification_code_expired
      };

      // Create new user
      userModel.createUser(userData, async (err, result) => {
        if (err) {
          console.error('Error creating user:', err);
          return res.status(500).json({ error: 'Error creating user' });
        }
        console.log('User created with verification code:', verification_code);

        // Send verification email
        const mailOptions = {
          from: 'quikdoc8@gmail.com',
          to: email,
          subject: 'Email Verification',
          html: `
            <h1>Email Verification</h1>
            <p>Your verification code is: <strong>${verification_code}</strong></p>
            <p>This code will expire in 24 hours.</p>
          `
        };

        try {
          await transporter.sendMail(mailOptions);
          console.log('Email sent with verification code:', verification_code);
          res.status(201).json({
            message: 'User created successfully. Please check your email for verification.',
            userId: result.insertId
          });
        } catch (error) {
          res.status(500).json({ error: 'Error sending verification email' });
        }
      });
    });
  } catch (error) {
    console.error('Server error:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

// Verify email endpoint
router.post('/verify-email', (req, res) => {
  const { email, code } = req.body;

  userModel.verifyEmail(email, code, (err, isVerified) => {
    if (err) {
      return res.status(500).json({ error: 'Database error' });
    }

    if (!isVerified) {
      return res.status(400).json({ error: 'Invalid or expired verification code' });
    }

    res.json({ 
      success: true,
      message: 'Email verified successfully',
      status: 'success'
    });
  });
});

// Sign in endpoint
router.post('/signin', async (req, res) => {
  try {
    const { email, password } = req.body;

    userModel.findUserByEmail(email, async (err, user) => {
      if (err) {
        console.error('Database error:', err);
        return res.status(500).json({ error: 'Database error' });
      }

      if (!user) {
        return res.status(404).json({ error: 'Compte non trouvé. Veuillez vous inscrire.' });
      }

      // Check if email is verified
      if (!user.is_verified) {
        return res.status(403).json({ error: 'Veuillez vérifier votre email avant de vous connecter.' });
      }

      // Comparaison directe du mot de passe en texte brut
      if (password !== user.password) {
        return res.status(401).json({ error: 'Email ou mot de passe incorrect.' });
      }

      // Generate JWT token with proper payload
      const token = jwt.sign(
        { userId: user.id, email: user.email, role: user.role },
        'your-secret-key', // Replace with your actual secret key
        { expiresIn: '24h' }
      );

      res.json({
        success: true,
        message: 'Connexion réussie',
        token,
        user: {
          id: user.id,
          email: user.email,
          first_name: user.first_name,
          last_name: user.last_name,
          role: user.role
        }
      });
    });
  } catch (error) {
    console.error('Server error:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

module.exports = router;