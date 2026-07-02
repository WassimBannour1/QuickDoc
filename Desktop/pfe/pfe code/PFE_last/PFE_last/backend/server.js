const express = require('express');
const cors = require('cors');
const db = require('./config/db');
const fileUpload = require('express-fileupload');
require('dotenv').config();
const app = express();

// Body parser middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// File upload middleware
app.use(fileUpload({
  createParentPath: true,
  limits: { fileSize: 50 * 1024 * 1024 }, // 50MB max file size
  useTempFiles: true,
  tempFileDir: '/tmp/'
}));

// Enhanced CORS configuration with more specific settings
app.use(cors({
    origin: function(origin, callback) {
        // Allow requests with no origin (like mobile apps, curl requests)
        if(!origin) return callback(null, true);
        
        // List of allowed origins
        const allowedOrigins = [
            'http://localhost:5173',
            'https://mozilla.github.io'
        ];
        
        if(allowedOrigins.indexOf(origin) !== -1 || !origin) {
            callback(null, true);
        } else {
            callback(new Error('Not allowed by CORS'));
        }
    },
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization', 'Accept'],
    exposedHeaders: ['Content-Type', 'Authorization'],
    preflightContinue: false,
    optionsSuccessStatus: 204
}));

// Augmenter les limites pour les requêtes volumineuses
app.use(express.json({ limit: '50mb' }));
app.use(express.urlencoded({ limit: '50mb', extended: true }));

// Augmenter le timeout des requêtes
app.use((req, res, next) => {
    res.setTimeout(300000, () => { // 5 minutes
        console.log('Request has timed out.');
        res.status(408).send('Request Timeout');
    });
    next();
});

// Request logging middleware
app.use((req, res, next) => {
    console.log(`\n=== ${new Date().toISOString()} ===`);
    console.log(`${req.method} ${req.path}`);
    console.log('Headers:', JSON.stringify(req.headers, null, 2));
    console.log('Body:', JSON.stringify(req.body, null, 2));
    next();
});

// Database connection check
const testConnection = async () => {
    try {
        const connection = await db.getConnection();
        console.log('Connected to database: pfe_db');
        connection.release();
    } catch (err) {
        console.error('Error connecting to the database:', err);
    }
};

testConnection();

// Add your routes
const authRoutes = require('./routes/authRoutes');
const profileRoutes = require('./routes/profileRoutes');
const protectedRoutes = require('./routes/protectedRoutes');
const remplissageRoutes = require('./routes/remplissageRoutes');
const remplissagePrimerieRoutes = require('./routes/remplissagePrimerieRoutes'); // Added remplissage primerie routes
const clientRoutes = require('./routes/clientRoutes');
const adminRoutes = require('./routes/adminRoutes'); // Added admin routes
const templateRoutes = require('./routes/templates'); // Added template routes
const path = require('path');

// Add payment routes import
const paymentRoutes = require('./routes/paymentRoutes');

// Servir les fichiers statiques (photos de profil, logos d'entreprise et backups)
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));
app.use('/logo-entreprise', express.static(path.join(__dirname, 'uploads/logo entreprise')));
app.use('/backups', express.static(path.join(__dirname, 'backup')));

app.use('/api/auth', authRoutes);
app.use('/api/users', profileRoutes);
app.use('/api/protected', protectedRoutes);
app.use('/api', remplissageRoutes);
app.use('/api/primerie', remplissagePrimerieRoutes); // Add remplissage primerie routes

// Add client routes
app.use('/api/clients', clientRoutes);

// Add category routes
const categoryRoutes = require('./routes/categoryRoutes');
app.use('/api/categories', categoryRoutes);

// Add product routes
const productRoutes = require('./routes/productRoutes');
app.use('/api/products', productRoutes);

// Add payment routes
app.use('/api/payment', paymentRoutes);

// Add OCR routes
const ocrRoutes = require('./routes/ocrRoutes');
app.use('/api/ocr', ocrRoutes);

// Add Statistics routes
const statisticsRoutes = require('./controllers/entrepriseStatsController.js');
app.use('/api/statistics', statisticsRoutes);

// Add Admin routes
app.use('/api/admin', adminRoutes);

// Add Admin Statistics routes
const adminStatisticsRoutes = require('./routes/admin-statistics');
app.use('/api/admin-statistics', adminStatisticsRoutes);

// Add Document Statistics routes
const documentStatisticsRoutes = require('./routes/document-statistics');
app.use('/api/document-statistics', documentStatisticsRoutes);

// Add Admin Backup routes
const adminBackupRoutes = require('./routes/admin-backup');
app.use('/api/admin-backup', adminBackupRoutes);

// Add Template routes
app.use('/api/templates', templateRoutes);


// Add Ollama routes with public access (not under /api to avoid global auth)
const ollamaRoutes = require('./routes/ollamaRoutes');
const bypassAuth = require('./middleware/bypassAuthMiddleware');
app.use('/public/ollama', bypassAuth, ollamaRoutes);
// Note: publicOllamaRoutes has been removed 


// Error handling middleware
app.use((err, req, res, next) => {
    console.error('Server error:', err);
    res.status(500).json({
        success: false,
        message: 'Erreur serveur interne'
    });
});

// Handle 404
app.use((req, res) => {
    res.status(404).json({
        success: false,
        message: 'Route non trouvée'
    });
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
    console.log(`\n=== Server is running ===`);
    console.log(`Server URL: http://localhost:${PORT}`);
    console.log(`Time: ${new Date().toISOString()}`);
});