const express = require('express');
const router = express.Router();
const multer = require('multer');
const path = require('path');
const fs = require('fs');
const profileController = require('../controllers/profileController');

// Configuration de multer pour le téléchargement des photos de profil
const storage = multer.diskStorage({
    destination: function(req, file, cb) {
        // S'assurer que le dossier existe
        const uploadDir = path.join(__dirname, '../uploads/profiles');
        if (!fs.existsSync(uploadDir)) {
            fs.mkdirSync(uploadDir, { recursive: true });
            console.log(`Dossier créé: ${uploadDir}`);
        }
        cb(null, uploadDir);
    },
    filename: function(req, file, cb) {
        // Générer un nom de fichier unique avec timestamp
        const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
        const ext = path.extname(file.originalname) || '.jpg'; // Ajouter une extension par défaut si aucune n'est trouvée
        const filename = 'profile-' + uniqueSuffix + ext;
        console.log('Nom de fichier généré:', filename);
        cb(null, filename);
    }
});

// Filtre pour n'accepter que les images
const fileFilter = (req, file, cb) => {
    if (file.mimetype.startsWith('image/')) {
        cb(null, true);
    } else {
        cb(new Error('Seules les images sont autorisées'), false);
    }
};

const upload = multer({ 
    storage: storage,
    fileFilter: fileFilter,
    limits: {
        fileSize: 5 * 1024 * 1024 // Limite à 5MB
    }
});

// Le middleware handleMulterError a été supprimé car la fonctionnalité de téléchargement de logo n'est plus nécessaire

// Route pour récupérer le profil utilisateur
router.get('/profile/:id', profileController.getProfile);

// Route pour mettre à jour le profil utilisateur
// Utiliser deux routes différentes: une pour les mises à jour avec photo et une pour les mises à jour sans photo
router.put('/profile/:id', express.json(), profileController.updateProfile);

// La route pour servir les logos d'entreprise a été supprimée car cette fonctionnalité n'est plus nécessaire

// Route pour mettre à jour le profil utilisateur avec photo (si nécessaire dans le futur)
// router.put('/profile/:id/with-photo', upload.single('profile_photo'), handleMulterError, profileController.updateProfile);

module.exports = router;