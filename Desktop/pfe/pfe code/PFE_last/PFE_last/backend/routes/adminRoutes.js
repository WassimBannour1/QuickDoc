const express = require('express');
const router = express.Router();
const { verifyToken, requireAdminRole } = require('../middleware/authMiddleware');
const db = require('../config/db');

// Enhanced request logging middleware 
const logRequest = (req, res, next) => {
    const timestamp = new Date().toISOString();
    console.log(`=== ${timestamp} ===`);
    console.log(`${req.method} ${req.baseUrl}${req.path}`);
    console.log('Headers:', req.headers);
    console.log('Body:', req.body);

    // Add response logging
    const oldSend = res.send;
    res.send = function(data) {
        console.log('Response:', data);
        oldSend.apply(res, arguments);
    };

    next();
};

// Endpoint to check if user is admin
router.get('/check-admin', [logRequest, verifyToken, requireAdminRole], async (req, res) => {
    try {
        const userId = req.user.userId;
        
        // Fetch the admin user details
        const [rows] = await db.query(
            'SELECT id, first_name, last_name, email, role FROM users WHERE id = ? AND role = "admin"', 
            [userId]
        );
        
        if (!rows || rows.length === 0) {
            return res.status(403).json({
                success: false,
                message: 'Accès non autorisé. Rôle administrateur requis.'
            });
        }
        
        res.json({
            success: true,
            message: 'Accès administrateur confirmé',
            user: rows[0]
        });
    } catch (error) {
        console.error('Error checking admin status:', error);
        res.status(500).json({
            success: false,
            message: 'Erreur lors de la vérification du statut administrateur'
        });
    }
});

// Endpoint to get all users (for admin dashboard)
router.get('/users', [logRequest, verifyToken, requireAdminRole], async (req, res) => {
    try {
        const [rows] = await db.query(
            'SELECT id, first_name, last_name, email, role, is_verified, isActive, created_at FROM users ORDER BY created_at DESC'
        );
        
        res.json({
            success: true,
            users: rows
        });
    } catch (error) {
        console.error('Error fetching users:', error);
        res.status(500).json({
            success: false,
            message: 'Erreur lors de la récupération des utilisateurs'
        });
    }
});

// Endpoint to update user status (activate/deactivate)
router.put('/users/:id/toggle-status', [logRequest, verifyToken, requireAdminRole], async (req, res) => {
    try {
        const userId = req.params.id;
        
        // Get current status
        const [userRows] = await db.query(
            'SELECT isActive FROM users WHERE id = ?',
            [userId]
        );
        
        if (!userRows || userRows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Utilisateur non trouvé'
            });
        }
        
        const newStatus = userRows[0].isActive ? 0 : 1;
        
        // Update status
        await db.query(
            'UPDATE users SET isActive = ? WHERE id = ?',
            [newStatus, userId]
        );
        
        res.json({
            success: true,
            message: `Statut de l'utilisateur mis à jour avec succès`,
            status: newStatus === 1
        });
    } catch (error) {
        console.error('Error toggling user status:', error);
        res.status(500).json({
            success: false,
            message: `Erreur lors de la mise à jour du statut de l'utilisateur`
        });
    }
});

// Add more admin endpoints as needed...

module.exports = router;
