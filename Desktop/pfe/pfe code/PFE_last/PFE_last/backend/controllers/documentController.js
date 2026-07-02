const path = require('path');
const fs = require('fs');
const db = require('../config/db');

/**
 * Get all documents
 * @param {Object} req - HTTP request object
 * @param {Object} res - HTTP response object
 */
exports.getAllDocuments = async (req, res) => {
  try {
    // Simplified query to avoid reference columns that might not exist
    const query = `
      SELECT d.*
      FROM document d
      ORDER BY d.created_at DESC
    `;
    
    const [documents] = await db.query(query);
    
    res.json({
      success: true,
      message: 'Documents récupérés avec succès',
      documents
    });
  } catch (error) {
    console.error('Error getting documents:', error);
    res.status(500).json({
      success: false,
      message: 'Erreur lors de la récupération des documents',
      error: error.message
    });
  }
};

/**
 * Get document file path by ID
 * @param {Object} req - HTTP request object
 * @param {Object} res - HTTP response object
 */
exports.getDocumentFilePath = async (req, res) => {
  try {
    const documentId = req.params.id;
    console.log(`Récupération du chemin du fichier pour le document ID: ${documentId}`);
    
    // Query to get document file path
    const query = `
      SELECT d.*
      FROM document d
      WHERE d.id = ?
    `;
    
    const [documents] = await db.query(query, [documentId]);
    
    if (documents.length === 0) {
      console.log(`Document avec ID ${documentId} non trouvé`);
      return res.status(404).json({
        success: false,
        message: 'Document non trouvé'
      });
    }
    
    const document = documents[0];
    console.log(`Document trouvé:`, document);
    
    // Check if file path exists in document
    if (!document.file_path) {
      console.log(`Document ${documentId} n'a pas de chemin de fichier`);
      return res.status(404).json({
        success: false,
        message: 'Chemin de fichier non disponible'
      });
    }
    
    // Try different approaches to resolving the file path
    let filePath;
    const possiblePaths = [];
    
    // 1. Direct path as stored in the database
    possiblePaths.push(document.file_path);
    
    // 2. Relative to backend root
    possiblePaths.push(path.resolve(__dirname, '..', document.file_path));
    
    // 3. Just use the filename in the uploads/documents directory
    const filename = path.basename(document.file_path);
    possiblePaths.push(path.resolve(__dirname, '..', 'uploads', 'documents', filename));
    
    // Log all paths we're going to try
    console.log('Attempting to find file at these locations:');
    possiblePaths.forEach(path => console.log(`- ${path}`));
    
    // Try each path until we find one that exists
    for (const possiblePath of possiblePaths) {
      if (fs.existsSync(possiblePath)) {
        filePath = possiblePath;
        console.log(`Found file at: ${filePath}`);
        break;
      }
    }
    
    // If no file was found after trying all possible paths
    if (!filePath) {
      console.log('File not found at any of the possible locations');
      
      return res.status(404).json({
        success: false,
        message: 'Fichier non trouvé sur le serveur',
        debug: {
          filePath: document.file_path,
          triedPaths: possiblePaths
        }
      });
    }
    
    // Return the document with file path
    res.json({
      success: true,
      message: 'Chemin du fichier récupéré avec succès',
      document: {
        ...document,
        file_path: filePath
      }
    });
    
  } catch (error) {
    console.error('Error getting document file path:', error);
    res.status(500).json({
      success: false,
      message: 'Erreur lors de la récupération du chemin du fichier',
      error: error.message
    });
  }
};

/**
 * Get document by ID
 * @param {Object} req - HTTP request object
 * @param {Object} res - HTTP response object
 */
exports.getDocumentById = async (req, res) => {
  try {
    const documentId = req.params.id;
    
    // Simplified query to avoid reference columns that might not exist
    const query = `
      SELECT d.*
      FROM document d
      WHERE d.id = ?
    `;
    
    const [documents] = await db.query(query, [documentId]);
    
    if (documents.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Document non trouvé'
      });
    }
    
    res.json({
      success: true,
      message: 'Document récupéré avec succès',
      document: documents[0]
    });
  } catch (error) {
    console.error('Error getting document:', error);
    res.status(500).json({
      success: false,
      message: 'Erreur lors de la récupération du document',
      error: error.message
    });
  }
};

/**
 * Get document by remplissage_id
 * @param {Object} req - HTTP request object
 * @param {Object} res - HTTP response object
 */
exports.getDocumentByRemplissageId = async (req, res) => {
  try {
    const remplissageId = req.params.id;
    console.log(`Recherche de document avec remplissage_id: ${remplissageId}`);
    
    // Query to find document by remplissage_id
    const query = `
      SELECT d.*
      FROM document d
      WHERE d.remplissage_id = ?
    `;
    
    const [documents] = await db.query(query, [remplissageId]);
    
    if (documents.length === 0) {
      console.log(`Aucun document trouvé avec remplissage_id: ${remplissageId}`);
      return res.status(404).json({
        success: false,
        message: `Document avec remplissage_id ${remplissageId} non trouvé`
      });
    }
    
    console.log(`Document trouvé avec remplissage_id ${remplissageId}:`, documents[0]);
    res.json({
      success: true,
      message: 'Document récupéré avec succès',
      document: documents[0]
    });
  } catch (error) {
    console.error(`Error getting document by remplissage_id ${req.params.id}:`, error);
    res.status(500).json({
      success: false,
      message: 'Erreur lors de la récupération du document',
      error: error.message
    });
  }
};

/**
 * Download document file
 * @param {Object} req - HTTP request object
 * @param {Object} res - HTTP response object
 */
exports.downloadDocument = async (req, res) => {
  try {
    const documentId = req.params.id;
    console.log(`Download requested for document ID: ${documentId}`);
    
    // Essayer d'abord de trouver le document par son ID direct
    let query = `
      SELECT d.*, r.id as remplissage_id
      FROM document d
      LEFT JOIN remplissage r ON d.remplissage_id = r.id
      WHERE d.id = ?
    `;
    
    let [documents] = await db.query(query, [documentId]);
    
    // Si aucun document n'est trouvé, essayer de chercher par remplissage_id
    if (documents.length === 0) {
      console.log(`Document with ID ${documentId} not found, trying as remplissage_id`);
      
      query = `
        SELECT d.*, r.id as remplissage_id
        FROM document d
        LEFT JOIN remplissage r ON d.remplissage_id = r.id
        WHERE d.remplissage_id = ?
      `;
      
      [documents] = await db.query(query, [documentId]);
    }
    
    if (documents.length === 0) {
      console.log(`No document found with ID or remplissage_id ${documentId}`);
      return res.status(404).json({
        success: false,
        message: 'Document non trouvé'
      });
    }
    
    const document = documents[0];
    console.log(`Found document:`, document);
    
    // Check if file path exists in document
    if (!document.file_path) {
      console.log(`Document ${documentId} has no file_path`);
      return res.status(404).json({
        success: false,
        message: 'Chemin de fichier non disponible'
      });
    }
    
    // Try different approaches to resolving the file path
    let filePath;
    const possiblePaths = [];
    
    // 1. Direct path as stored in the database
    possiblePaths.push(document.file_path);
    
    // 2. Relative to backend root
    possiblePaths.push(path.resolve(__dirname, '..', document.file_path));
    
    // 3. Just use the filename in the uploads/documents directory
    const filename = path.basename(document.file_path);
    possiblePaths.push(path.resolve(__dirname, '..', 'uploads', 'documents', filename));
    
    // 4. Try with remplissage_id as filename
    if (document.remplissage_id) {
      possiblePaths.push(path.resolve(__dirname, '..', 'uploads', 'documents', `${document.remplissage_id}.pdf`));
    }
    
    // Log all paths we're going to try
    console.log('Attempting to find file at these locations:');
    possiblePaths.forEach(path => console.log(`- ${path}`));
    
    // Try each path until we find one that exists
    for (const possiblePath of possiblePaths) {
      if (fs.existsSync(possiblePath)) {
        filePath = possiblePath;
        console.log(`Found file at: ${filePath}`);
        break;
      }
    }
    
    // If no file was found after trying all possible paths
    if (!filePath) {
      console.log('File not found at any of the possible locations');
      
      // For debugging - show what files are in the uploads/documents directory
      const uploadsDir = path.resolve(__dirname, '..', 'uploads', 'documents');
      console.log(`Looking in uploads directory: ${uploadsDir}`);
      
      if (fs.existsSync(uploadsDir)) {
        const files = fs.readdirSync(uploadsDir);
        console.log(`Files in uploads directory:`, files);
      } else {
        console.log(`Uploads directory does not exist: ${uploadsDir}`);
        
        // Try to create the uploads directory
        try {
          fs.mkdirSync(uploadsDir, { recursive: true });
          console.log(`Created uploads directory: ${uploadsDir}`);
        } catch (err) {
          console.error(`Failed to create uploads directory: ${err.message}`);
        }
      }
      
      return res.status(404).json({
        success: false,
        message: 'Fichier non trouvé sur le serveur',
        debug: {
          filePath: document.file_path,
          triedPaths: possiblePaths
        }
      });
    }
    
    // Get file name from path
    const fileName = path.basename(filePath);
    console.log(`Sending file: ${fileName}`);
    
    // Set appropriate headers for file download
    res.setHeader('Content-Disposition', `attachment; filename="${fileName}"`);
    res.setHeader('Content-Type', 'application/pdf');
    res.setHeader('Cache-Control', 'no-cache');
    res.setHeader('Content-Length', fs.statSync(filePath).size);
    
    // Use fs.readFile instead of createReadStream for more reliable delivery
    fs.readFile(filePath, (err, data) => {
      if (err) {
        console.error(`Error reading file: ${err.message}`);
        return res.status(500).json({
          success: false,
          message: 'Erreur lors de la lecture du fichier',
          error: err.message
        });
      }
      
      // Send the file data as response
      res.end(data);
    });
    
  } catch (error) {
    console.error('Error downloading document:', error);
    res.status(500).json({
      success: false,
      message: 'Erreur lors du téléchargement du document',
      error: error.message
    });
  }
};

/**
 * View document file
 * @param {Object} req - HTTP request object
 * @param {Object} res - HTTP response object
 */
exports.viewDocument = async (req, res) => {
  try {
    const documentId = req.params.id;
    console.log(`Tentative d'affichage du document avec ID: ${documentId}`);
    
    // Essayer d'abord de trouver le document par son ID direct
    let query = `
      SELECT d.*, r.id as remplissage_id
      FROM document d
      LEFT JOIN remplissage r ON d.remplissage_id = r.id
      WHERE d.id = ?
    `;
    
    let [documents] = await db.query(query, [documentId]);
    
    // Si aucun document n'est trouvé, essayer de chercher par remplissage_id
    if (documents.length === 0) {
      console.log(`Document with ID ${documentId} not found, trying as remplissage_id`);
      
      query = `
        SELECT d.*, r.id as remplissage_id
        FROM document d
        LEFT JOIN remplissage r ON d.remplissage_id = r.id
        WHERE d.remplissage_id = ?
      `;
      
      [documents] = await db.query(query, [documentId]);
    }
    
    if (documents.length === 0) {
      console.log(`No document found with ID or remplissage_id ${documentId}`);
      return res.status(404).json({
        success: false,
        message: 'Document non trouvé'
      });
    }
    
    const document = documents[0];
    console.log(`Document trouvé:`, document);
    
    if (!document.file_path) {
      console.log(`Chemin du fichier non trouvé pour le document ${documentId}`);
      return res.status(404).json({
        success: false,
        message: 'Chemin du fichier non trouvé pour ce document'
      });
    }
    
    // Try different paths to find the file
    const possiblePaths = [];
    
    // 1. Direct path as stored in the database
    possiblePaths.push(document.file_path);
    
    // 2. Relative to backend root
    possiblePaths.push(path.resolve(__dirname, '..', document.file_path));
    
    // 3. Just use the filename in the uploads/documents directory
    const filename = path.basename(document.file_path);
    possiblePaths.push(path.resolve(__dirname, '..', 'uploads', 'documents', filename));
    
    // 4. Try with remplissage_id as filename
    if (document.remplissage_id) {
      possiblePaths.push(path.resolve(__dirname, '..', 'uploads', 'documents', `${document.remplissage_id}.pdf`));
    }
    
    console.log(`Recherche du fichier aux chemins suivants:`);
    possiblePaths.forEach(path => console.log(`- ${path}`));
    
    let fileExists = false;
    let finalPath = '';
    
    // Try each path until we find one that exists
    for (const possiblePath of possiblePaths) {
      if (fs.existsSync(possiblePath)) {
        fileExists = true;
        finalPath = possiblePath;
        console.log(`Fichier trouvé à: ${finalPath}`);
        break;
      }
    }
    
    if (!fileExists) {
      console.error('Fichier non trouvé à aucun des emplacements:');
      console.log('Chemins essayés:', possiblePaths);
      
      // Try to list files in uploads/documents directory for debugging
      try {
        const uploadsDir = path.resolve(__dirname, '..', 'uploads', 'documents');
        if (fs.existsSync(uploadsDir)) {
          const files = fs.readdirSync(uploadsDir);
          console.log('Fichiers dans le répertoire uploads/documents:', files);
        } else {
          console.log('Le répertoire uploads/documents n\'existe pas, création en cours...');
          fs.mkdirSync(uploadsDir, { recursive: true });
          console.log(`Répertoire uploads créé: ${uploadsDir}`);
        }
      } catch (err) {
        console.error('Erreur lors de la liste des fichiers dans le répertoire uploads:', err);
      }
      
      return res.status(404).json({
        success: false,
        message: 'Fichier non trouvé',
        debug: {
          filePath: document.file_path,
          triedPaths: possiblePaths
        }
      });
    }
    
    // Read file and send as response
    console.log(`Lecture et envoi du fichier: ${finalPath}`);
    const fileContent = fs.readFileSync(finalPath);
    
    // Set appropriate headers for PDF download
    res.setHeader('Content-Type', 'application/pdf');
    res.setHeader('Content-Disposition', `inline; filename="${path.basename(finalPath)}"`);
    
    // Send file content
    res.send(fileContent);
    console.log(`Fichier envoyé avec succès: ${finalPath}`);
  } catch (error) {
    console.error('Erreur lors de l\'affichage du document:', error);
    res.status(500).json({
      success: false,
      message: 'Erreur lors de l\'affichage du document',
      error: error.message
    });
  }
};

/**
 * Archive a document (save PDF to server and create database entry if remplissageId is provided)
 * @param {Object} req - HTTP request object
 * @param {Object} res - HTTP response object
 */
/**
 * Send document by email
 * @param {Object} req - HTTP request object
 * @param {Object} res - HTTP response object
 */
exports.sendDocumentByEmail = async (req, res) => {
  try {
    const documentId = req.params.id;
    const { to, subject, message, attachPdf } = req.body;
    const userId = req.user.id || req.user.userId;

    console.log(`Envoi d'email pour le document ID: ${documentId}`);
    
    // Vérifier que le document existe
    const [documents] = await db.query(
      'SELECT * FROM document WHERE id = ?',
      [documentId]
    );

    if (documents.length === 0) {
      console.log(`Document avec ID ${documentId} non trouvé`);
      return res.status(404).json({
        success: false,
        message: 'Document non trouvé'
      });
    }

    const document = documents[0];
    console.log('Document trouvé:', document);

    // Configuration du transporteur d'email
    const nodemailer = require('nodemailer');
    const transporter = nodemailer.createTransport({
      service: 'gmail',
      auth: {
        user: 'quikdoc8@gmail.com',
        pass: 'yzph kfub ggot lsnl'
      }
    });

    // Préparer les options de l'email
    const mailOptions = {
      from: 'quikdoc8@gmail.com',
      to: to,
      subject: subject || `Document #${document.id}`,
      html: `
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; border: 1px solid #e0e0e0; border-radius: 8px; overflow: hidden;">
          <div style="background-color: #002446; padding: 20px; text-align: center;">
            <h1 style="color: #ffffff; margin: 0;">Document #${document.id}</h1>
          </div>
          <div style="padding: 30px;">
            <p style="color: #444; line-height: 1.5;">${message || `Veuillez trouver ci-joint votre document.`}</p>
            <div style="background-color: #f5f5f5; padding: 20px; border-radius: 5px; margin: 20px 0; border-left: 4px solid #002446;">
              <h3 style="color: #002446; margin-top: 0;">Détails du document</h3>
              <p><strong>ID:</strong> ${document.id}</p>
              <p><strong>Date:</strong> ${new Date(document.created_at).toLocaleDateString()}</p>
              <p><strong>État:</strong> ${document.status || 'Non spécifié'}</p>
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
        console.log('Pièce jointe demandée pour le document:', documentId);
        
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
              filename: `Document_${document.id}.pdf`,
              path: filePath
            }];
            console.log('Pièce jointe ajoutée à l\'email:', filePath);
          } else {
            console.log('Fichier non trouvé aux emplacements suivants:', possiblePaths);
          }
        } else {
          console.log('Le document n\'a pas de chemin de fichier');
        }
      } catch (attachError) {
        console.error('Erreur lors de l\'ajout de la pièce jointe:', attachError);
      }
    }

    // Envoyer l'email
    await transporter.sendMail(mailOptions);

    res.json({
      success: true,
      message: 'Document envoyé par email avec succès',
      notification: {
        type: 'success',
        title: 'Email envoyé !',
        message: 'Le document a été envoyé avec succès au destinataire.',
        icon: 'paper-plane',
        color: '#1e3a8a', // Couleur de la barre latérale (bleu foncé)
        duration: 5000,
      }
    });

  } catch (error) {
    console.error('Erreur lors de l\'envoi du document par email:', error);
    res.status(500).json({
      success: false,
      message: 'Erreur lors de l\'envoi du document par email',
      error: error.message
    });
  }
};

/**
 * Archive a document (save PDF to server and create database entry if remplissageId is provided)
 * @param {Object} req - HTTP request object
 * @param {Object} res - HTTP response object
 */
exports.archiveDocument = async (req, res) => {
  try {
    console.log('Archive document request received');
    
    // Vérifier si un fichier a été envoyé
    if (!req.files || !req.files.pdf) {
      console.log('No file uploaded');
      return res.status(400).json({
        success: false,
        message: 'Aucun fichier PDF n\'a été envoyé'
      });
    }
    
    const pdfFile = req.files.pdf;
    console.log(`File received: ${pdfFile.name}`);
    
    // Récupérer l'ID du remplissage s'il est fourni
    const remplissageId = req.body.remplissageId;
    console.log(`Remplissage ID: ${remplissageId || 'Not provided'}`);
    
    // Créer le répertoire de destination s'il n'existe pas
    const uploadsDir = path.resolve(__dirname, '..', 'uploads', 'documents');
    if (!fs.existsSync(uploadsDir)) {
      fs.mkdirSync(uploadsDir, { recursive: true });
      console.log(`Created uploads directory: ${uploadsDir}`);
    }
    
    // Générer un nom de fichier unique
    const fileName = `${Date.now()}_${pdfFile.name}`;
    const filePath = path.join(uploadsDir, fileName);
    const relativeFilePath = `uploads/documents/${fileName}`;
    
    // Déplacer le fichier vers le répertoire de destination
    await pdfFile.mv(filePath);
    console.log(`File saved to: ${filePath}`);
    
    // Si un ID de remplissage est fourni, créer une entrée dans la table document
    let documentId = null;
    if (remplissageId) {
      try {
        // Importer la connexion à la base de données
        const pool = require('../config/db');
        
        // Récupérer le type de document à partir de l'ID de remplissage
        const [remplissageRows] = await pool.query(
          'SELECT type_document FROM remplissage WHERE id = ?',
          [remplissageId]
        );
        
        // Définir le statut en fonction du type de document
        let status = 'non envoyée'; // Valeur par défaut
        let status_client = null; // Valeur par défaut pour status_client
        
        if (remplissageRows.length > 0) {
          const typeDocument = remplissageRows[0].type_document;
          
          if (typeDocument === 'facture') {
            status = 'Non payée';
            status_client = 'unpaid';
          } else if (typeDocument === 'devis') {
            status = 'Envoyée';
            status_client = 'pending';
          }
        }
        
        // Insérer le document dans la base de données avec le statut approprié et status_client
        const [result] = await pool.query(
          'INSERT INTO document (remplissage_id, file_path, status, status_client) VALUES (?, ?, ?, ?)',
          [remplissageId, relativeFilePath, status, status_client]
        );
        
        documentId = result.insertId;
        console.log(`Document entry created with ID: ${documentId}`);
      } catch (dbError) {
        console.error('Database error:', dbError);
        // Continuer même en cas d'erreur de base de données
      }
    }
    
    // Répondre avec succès
    res.json({
      success: true,
      message: 'Document archivé avec succès',
      fileName: fileName,
      filePath: relativeFilePath,
      documentId: documentId,
      remplissageId: remplissageId || null
    });
    
  } catch (error) {
    console.error('Error archiving document:', error);
    res.status(500).json({
      success: false,
      message: 'Erreur lors de l\'archivage du document',
      error: error.message
    });
  }
};
