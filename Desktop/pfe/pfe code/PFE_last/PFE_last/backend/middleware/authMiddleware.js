const jwt = require('jsonwebtoken');

// Middleware to verify JWT token and check user role
const verifyToken = (req, res, next) => {
    let token;
    
    // Get the token from the Authorization header
    const authHeader = req.headers.authorization;
    
    // Log the authorization header for debugging
    console.log('Authorization header:', authHeader);
    
    // Check for token in Authorization header
    if (authHeader && authHeader.startsWith('Bearer ')) {
        token = authHeader.split(' ')[1];
        console.log('Token from Authorization header:', token ? `${token.substring(0, 10)}...` : 'undefined');
    } 
    // Check for token in query parameters (for direct downloads)
    else if (req.query.token) {
        token = req.query.token;
        console.log('Token from query parameter:', token ? `${token.substring(0, 10)}...` : 'undefined');
    }
    
    // If no token found in either location
    if (!token || token.trim() === '') {
        console.log('No valid token found');
        return res.status(401).json({
            success: false,
            message: 'Accès non autorisé. Token manquant.'
        });
    }
    
    try {
        // Verify the token
        const decoded = jwt.verify(token, process.env.JWT_SECRET || 'your-secret-key'); // Use environment variable or fallback to default
        
        // Add the user info to the request object
        req.user = decoded;
        
        // Ensure consistent user ID property
        if (decoded.userId && !decoded.id) {
            req.user.id = decoded.userId;
        } else if (decoded.id && !decoded.userId) {
            req.user.userId = decoded.id;
        }
        
        console.log('Token successfully verified for user:', req.user.id || req.user.userId);
        
        next();
    } catch (error) {
        console.error('Token verification error:', error);
        return res.status(401).json({
            success: false,
            message: 'Token invalide ou expiré'
        });
    }
};

// Middleware to check if user has client role
const requireClientRole = (req, res, next) => {
    if (!req.user) {
        return res.status(401).json({
            success: false,
            message: 'Utilisateur non authentifié'
        });
    }

    if (req.user.role !== 'client' && req.user.role !== 'admin' && req.user.role !== 'enterprise') {
        return res.status(403).json({
            success: false,
            message: 'Accès refusé. Rôle client, admin ou enterprise requis.'
        });
    }

    next();
};

// Middleware to check if user has enterprise admin role
const requireEnterpriseRole = (req, res, next) => {
    if (!req.user) {
        return res.status(401).json({
            success: false,
            message: 'Utilisateur non authentifié'
        });
    }

    if (req.user.role !== 'enterprise' && req.user.role !== 'enterprise_admin' && req.user.role !== 'admin') {
        return res.status(403).json({
            success: false,
            message: 'Accès refusé. Rôle administrateur d\'entreprise requis.'
        });
    }

    next();
};

// Middleware to check if user has admin role
const requireAdminRole = (req, res, next) => {
    if (!req.user) {
        return res.status(401).json({
            success: false,
            message: 'Utilisateur non authentifié'
        });
    }

    if (req.user.role !== 'admin') {
        return res.status(403).json({
            success: false,
            message: 'Accès refusé. Rôle administrateur requis.'
        });
    }

    next();
};

module.exports = {
    authenticateToken: verifyToken, 
    verifyToken,
    requireClientRole,
    requireEnterpriseRole,
    requireAdminRole
};
