const { spawn } = require('child_process');
const path = require('path');
const fs = require('fs');
const util = require('util');

/**
 * Extraire des données structurées à partir du texte brut
 * @param {string} text - Texte extrait par OCR
 * @returns {Object} - Données structurées extraites
 */
function extractStructuredDataFromText(text) {
    // Initialiser un objet pour stocker les données structurées
    const structuredData = {};
    
    // Expressions régulières pour extraire les informations courantes des factures/devis
    const patterns = {
        // Numéro de facture/devis
        invoice_number: /(?:facture|fact|n°|numero)\s*[:\s]?\s*([A-Z0-9\-\/]+)/i,
        // Date de facture/devis
        date: /(\d{1,2}[\/\-]\d{1,2}[\/\-]\d{2,4})/,
        // Montant total
        total_amount: /(?:total|montant|net à payer)[^:]*?:\s*(?:EUR|€|\$)?\s*([0-9\s,.]+)(?:\s*(?:EUR|€|\$))?/i,
        // Montant TVA
        tax_amount: /(?:tva|taxe)[^:]*?:\s*(?:EUR|€|\$)?\s*([0-9\s,.]+)(?:\s*(?:EUR|€|\$))?/i,
        // Nom du client
        client_name: /(?:client|destinataire)[^:]*?:\s*([A-Za-z\s.]+)/i
    };
    
    // Extraire les informations en utilisant les expressions régulières
    for (const [key, pattern] of Object.entries(patterns)) {
        const match = text.match(pattern);
        if (match && match[1]) {
            structuredData[key] = match[1].trim();
        }
    }
    
    // Recherche du nom du client (approche alternative si non trouvé)
    if (!structuredData.client_name) {
        const lines = text.split('\n');
        for (const line of lines) {
            // Ignorer les lignes trop courtes ou contenant des mots clés spécifiques
            if (line.length > 3 && 
                !line.match(/facture|montant|date|total|tva|ht|ttc/i) &&
                line.match(/[A-Z]/) && 
                line.length < 50) {
                structuredData.client_name = line.trim();
                break;
            }
        }
    }
    
    return structuredData;
}

// Chemin vers les scripts Python d'extraction OCR
const pythonScriptPath = path.join(__dirname, '..', 'ocr_extraction.py');
const invoiceOcrScriptPath = path.join(__dirname, '..', 'invoice_ocr.py');
const enhancedInvoiceOcrScriptPath = path.join(__dirname, '..', 'enhanced_invoice_ocr.py');
const tesseractOcrScriptPath = path.join(__dirname, '..', 'tesseract_ocr.py');

// Chemin pour les résultats OCR - chemin spécifié par l'utilisateur
const ocrResultDir = 'C:\\Users\\WESSIM\\Desktop\\pfe code\\PFE_last\\PFE_last\\backend\\ocr result';

// Vérifier si le dossier des résultats existe, sinon le créer
if (!fs.existsSync(ocrResultDir)) {
    fs.mkdirSync(ocrResultDir, { recursive: true });
} else {
    // Nettoyer les fichiers JSON existants dans le dossier des résultats
    try {
        const files = fs.readdirSync(ocrResultDir);
        for (const file of files) {
            if (file.endsWith('_tesseract_ocr.json')) {
                fs.unlinkSync(path.join(ocrResultDir, file));
                console.log(`Fichier JSON supprimé: ${file}`);
            }
        }
    } catch (error) {
        console.error('Erreur lors du nettoyage des fichiers JSON:', error);
    }
}

/**
 * Contrôleur pour l'extraction OCR
 */
const ocrController = {
    /**
     * Extraire le texte d'un document avec OCR
     * @param {Object} req - Requête Express
     * @param {Object} res - Réponse Express
     */
    extractText: async (req, res) => {
        try {
            // Vérifier si des fichiers ont été téléchargés
            if (!req.files || !req.files.documents) {
                return res.status(400).json({
                    success: false,
                    message: 'Aucun fichier téléchargé'
                });
            }

            // S'assurer que le répertoire de résultats existe
            if (!fs.existsSync(ocrResultDir)) {
                fs.mkdirSync(ocrResultDir, { recursive: true });
                console.log(`Dossier de résultats OCR créé: ${ocrResultDir}`);
            }

            // Créer le répertoire pour les fichiers téléchargés s'il n'existe pas
            const uploadDir = path.join(__dirname, '..', 'uploads', 'ocr');
            if (!fs.existsSync(uploadDir)) {
                fs.mkdirSync(uploadDir, { recursive: true });
                console.log(`Dossier d'upload OCR créé: ${uploadDir}`);
            }

            // Traiter les fichiers téléchargés (peut être un seul fichier ou un tableau)
            const documentsArray = Array.isArray(req.files.documents) 
                ? req.files.documents 
                : [req.files.documents];

            const results = [];
            const filePaths = [];

            // Sauvegarder chaque fichier dans le répertoire d'upload
            for (const file of documentsArray) {
                const fileName = `${Date.now()}-${file.name}`;
                const filePath = path.join(uploadDir, fileName);
                
                // Déplacer le fichier vers le répertoire d'upload
                await file.mv(filePath);
                filePaths.push(filePath);
            }

            // Traiter chaque fichier avec le script Python
            for (const filePath of filePaths) {
                try {
                    console.log(`Traitement OCR du fichier: ${filePath}`);
                    // Détecter si c'est une facture (basé sur l'extension ou d'autres heuristiques)
                    const isInvoice = true;  // Pour l'instant, considérons tous les fichiers comme des factures
                    
                    // Déterminer quel script OCR utiliser
                    let resultPath;
                    
                    // Par défaut, utiliser Tesseract OCR sauf si 'easyocr' est spécifié
                    if (req.query.engine === 'easyocr') {
                        console.log(`Utilisation du moteur EasyOCR pour ${filePath}`);
                        // Vérifier si les scripts existent avant de les appeler
                        if (isInvoice && fs.existsSync(enhancedInvoiceOcrScriptPath)) {
                            resultPath = await runEnhancedInvoiceOcrScript(filePath);
                        } else if (fs.existsSync(pythonScriptPath)) {
                            resultPath = await runPythonScript(filePath);
                        } else {
                            // Fallback to Tesseract if EasyOCR scripts don't exist
                            console.log(`Scripts EasyOCR non trouvés, utilisation de Tesseract à la place`);
                            resultPath = await runTesseractOcrScript(filePath);
                        }
                    } else {
                        // Utiliser Tesseract OCR par défaut
                        console.log(`Utilisation du moteur Tesseract OCR pour ${filePath}`);
                        resultPath = await runTesseractOcrScript(filePath);
                    }
                    
                    if (resultPath) {
                        // Vérifier si le fichier résultat existe
                        if (fs.existsSync(resultPath)) {
                            // Lire le contenu du fichier résultat (maintenant uniquement TXT)
                            const fileContent = fs.readFileSync(resultPath, 'utf8');
                            const extractedText = fileContent;
                            
                            // Analyser le texte pour extraire des données structurées
                            const structuredData = extractStructuredDataFromText(extractedText);
                            
                            results.push({
                                originalFile: path.basename(filePath),
                                resultFile: path.basename(resultPath),
                                resultPath: resultPath,
                                extractedText: extractedText,
                                structuredData: structuredData
                            });
                            
                            console.log(`Texte extrait avec succès pour ${path.basename(filePath)}`);
                        } else {
                            console.error(`Fichier résultat non trouvé: ${resultPath}`);
                            results.push({
                                originalFile: path.basename(filePath),
                                error: `Fichier résultat non trouvé: ${resultPath}`
                            });
                        }
                    } else {
                        console.error(`Échec de l'extraction OCR pour ${path.basename(filePath)}`);
                        results.push({
                            originalFile: path.basename(filePath),
                            error: `Échec de l'extraction OCR`
                        });
                    }
                } catch (error) {
                    console.error(`Erreur lors du traitement du fichier ${filePath}:`, error);
                    results.push({
                        originalFile: path.basename(filePath),
                        error: error.message
                    });
                }
            }

            // Envoyer les résultats au client
            return res.status(200).json({
                success: true,
                message: 'Extraction OCR terminée',
                results: results
            });
        } catch (error) {
            console.error('Erreur lors de l\'extraction OCR:', error);
            return res.status(500).json({
                success: false,
                message: 'Erreur lors de l\'extraction OCR',
                error: error.message
            });
        }
    },

    /**
     * Récupérer le résultat d'une extraction OCR
     * @param {Object} req - Requête Express
     * @param {Object} res - Réponse Express
     */
    getOcrResult: async (req, res) => {
        try {
            const { filename } = req.params;
            
            if (!filename) {
                return res.status(400).json({
                    success: false,
                    message: 'Nom de fichier non spécifié'
                });
            }

            const filePath = path.join(ocrResultDir, filename);
            
            // Vérifier si le fichier existe
            if (!fs.existsSync(filePath)) {
                return res.status(404).json({
                    success: false,
                    message: 'Fichier non trouvé'
                });
            }

            // Lire le contenu du fichier
            const content = fs.readFileSync(filePath, 'utf8');
            
            return res.status(200).json({
                success: true,
                filename: filename,
                content: content
            });
        } catch (error) {
            console.error('Erreur lors de la récupération du résultat OCR:', error);
            return res.status(500).json({
                success: false,
                message: 'Erreur lors de la récupération du résultat OCR',
                error: error.message
            });
        }
    },

    /**
     * Traitement du texte extrait pour en extraire des données structurées
     * @param {Object} req - Requête Express
     * @param {Object} res - Réponse Express
     */
    processExtractedText: async (req, res) => {
        try {
            const { text } = req.body;
            
            if (!text) {
                return res.status(400).json({
                    success: false,
                    message: 'Texte non fourni'
                });
            }

            console.log('Traitement du texte extrait...');
            
            // Utiliser la fonction d'extraction de données structurées
            const structuredData = extractStructuredDataFromText(text);
            
            // Enrichir les données avec des informations supplémentaires
            const enhancedData = {
                typeDocument: text.toLowerCase().includes('facture') ? 'facture' : 
                              text.toLowerCase().includes('devis') ? 'devis' : 'document',
                ...structuredData,
                // Ajouter d'autres champs si nécessaire
                dateTraitement: new Date().toISOString()
            };
            
            return res.status(200).json({
                success: true,
                message: 'Texte traité avec succès',
                data: enhancedData
            });
        } catch (error) {
            console.error('Erreur lors du traitement du texte:', error);
            return res.status(500).json({
                success: false,
                message: 'Erreur lors du traitement du texte',
                error: error.message
            });
        }
    }
};

/**
 * Exécuter le script Python d'extraction OCR
 * @param {string} filePath - Chemin du fichier à traiter
 * @returns {Promise<string|null>} - Chemin du fichier résultat ou null en cas d'erreur
 */
function runPythonScript(filePath) {
    return new Promise((resolve, reject) => {
        // Définir le chemin Python à utiliser (utilisant le dossier des requirements)
        const pythonPath = 'python';
        
        console.log(`Exécution du script Python: ${pythonScriptPath}`);
        console.log(`Fichier à traiter: ${filePath}`);
        
        // Lancer le processus Python
        const pythonProcess = spawn(pythonPath, [pythonScriptPath, filePath]);
        
        let resultPath = null;
        let errorOutput = '';

        // Capturer la sortie standard
        pythonProcess.stdout.on('data', (data) => {
            const output = data.toString();
            console.log(`Python stdout: ${output}`);
            
            // Extraire le chemin du fichier résultat - pattern modifié pour supporter les problèmes d'encodage
            const match = output.match(/Texte extrait .+ dans: (.+\.txt)/);
            if (match && match[1]) {
                resultPath = match[1];
                console.log(`Résultat OCR détecté: ${resultPath}`);
            }
        });

        // Capturer la sortie d'erreur
        pythonProcess.stderr.on('data', (data) => {
            errorOutput += data.toString();
            console.error(`Python stderr: ${data}`);
        });

        // Gérer la fin du processus
        pythonProcess.on('close', (code) => {
            if (code !== 0) {
                console.error(`Le processus Python s'est terminé avec le code ${code}`);
                console.error(`Erreur: ${errorOutput}`);
                reject(new Error(`Échec de l'extraction OCR avec le code ${code}: ${errorOutput}`));
            } else if (!resultPath) {
                console.warn('Aucun chemin de fichier résultat trouvé dans la sortie Python');
                resolve(null);
            } else {
                resolve(resultPath);
            }
        });

        // Gérer les erreurs du processus
        pythonProcess.on('error', (error) => {
            console.error(`Erreur lors du lancement du processus Python: ${error.message}`);
            reject(error);
        });
    });
}

/**
 * Exécuter le script Python d'extraction OCR spécialisé pour les factures
 * @param {string} filePath - Chemin du fichier à traiter
 * @returns {Promise<string|null>} - Chemin du fichier résultat ou null en cas d'erreur
 */
function runInvoiceOcrScript(filePath) {
    return new Promise((resolve, reject) => {
        // Définir le chemin Python à utiliser
        const pythonPath = 'python';
        
        console.log(`Exécution du script Python pour factures: ${invoiceOcrScriptPath}`);
        console.log(`Fichier à traiter: ${filePath}`);
        
        // Lancer le processus Python
        const pythonProcess = spawn(pythonPath, [invoiceOcrScriptPath, filePath]);
        
        let resultPath = null;
        let errorOutput = '';
        
        // Écouter la sortie standard (stdout)
        pythonProcess.stdout.on('data', (data) => {
            const output = data.toString().trim();
            
            // Rechercher le marqueur du chemin de fichier de résultat
            if (output.startsWith('OCR_RESULT_PATH:')) {
                resultPath = output.replace('OCR_RESULT_PATH:', '').trim();
                console.log(`Chemin du résultat OCR facture détecté: ${resultPath}`);
            } else {
                console.log(`Sortie Python (facture): ${output}`);
            }
        });
        
        // Écouter la sortie d'erreur (stderr)
        pythonProcess.stderr.on('data', (data) => {
            const error = data.toString().trim();
            errorOutput += error + '\n';
            console.error(`Erreur Python (facture): ${error}`);
        });
        
        // Écouter la fin du processus
        pythonProcess.on('close', (code) => {
            if (code === 0 && resultPath) {
                console.log(`Script Python de facture terminé avec succès, code: ${code}`);
                resolve(resultPath);
            } else {
                console.error(`Script Python de facture terminé avec des erreurs, code: ${code}`);
                console.error(`Erreurs: ${errorOutput}`);
                reject(new Error(`Erreur lors de l'exécution du script Python (code ${code}): ${errorOutput}`));
            }
        });
        
        // Gérer les erreurs de lancement du processus
        pythonProcess.on('error', (err) => {
            console.error(`Erreur lors du lancement du script Python de facture: ${err.message}`);
            reject(err);
        });
    });
}

/**
 * Exécuter le script Python d'extraction OCR amélioré pour les factures
 * @param {string} filePath - Chemin du fichier à traiter
 * @returns {Promise<string|null>} - Chemin du fichier résultat ou null en cas d'erreur
 */
function runEnhancedInvoiceOcrScript(filePath) {
    return new Promise((resolve, reject) => {
        // Définir le chemin Python à utiliser
        const pythonPath = 'python';
        
        console.log(`Exécution du script Python amélioré pour factures: ${enhancedInvoiceOcrScriptPath}`);
        console.log(`Fichier à traiter: ${filePath}`);
        
        // Lancer le processus Python
        const pythonProcess = spawn(pythonPath, [enhancedInvoiceOcrScriptPath, filePath]);
        
        let resultPath = null;
        let errorOutput = '';
        
        // Écouter la sortie standard (stdout)
        pythonProcess.stdout.on('data', (data) => {
            const output = data.toString().trim();
            
            // Rechercher le marqueur du chemin de fichier de résultat
            if (output.startsWith('OCR_RESULT_PATH:')) {
                resultPath = output.replace('OCR_RESULT_PATH:', '').trim();
                console.log(`Chemin du résultat OCR amélioré détecté: ${resultPath}`);
            } else {
                console.log(`Sortie Python (OCR amélioré): ${output}`);
            }
        });
        
        // Écouter la sortie d'erreur (stderr)
        pythonProcess.stderr.on('data', (data) => {
            const error = data.toString().trim();
            errorOutput += error + '\n';
            console.error(`Erreur Python (OCR amélioré): ${error}`);
        });
        
        // Écouter la fin du processus
        pythonProcess.on('close', (code) => {
            if (code === 0 && resultPath) {
                console.log(`Script Python OCR amélioré terminé avec succès, code: ${code}`);
                resolve(resultPath);
            } else {
                console.error(`Script Python OCR amélioré terminé avec des erreurs, code: ${code}`);
                console.error(`Erreurs: ${errorOutput}`);
                reject(new Error(`Erreur lors de l'exécution du script Python amélioré (code ${code}): ${errorOutput}`));
            }
        });
        
        // Gérer les erreurs de lancement du processus
        pythonProcess.on('error', (err) => {
            console.error(`Erreur lors du lancement du script Python OCR amélioré: ${err.message}`);
            reject(err);
        });
    });
}

/**
 * Exécuter le script Python Tesseract OCR optimisé pour les factures et devis français
 * @param {string} filePath - Chemin du fichier à traiter
 * @returns {Promise<string|null>} - Chemin du fichier résultat ou null en cas d'erreur
 */
async function runTesseractOcrScript(filePath) {
    // Nombre maximum de tentatives en cas d'échec
    const maxRetries = 2;
    let currentRetry = 0;
    
    // Fonction pour exécuter le processus avec gestion des tentatives
    const executeProcess = () => {
        return new Promise((resolve, reject) => {
            const resultDir = ocrResultDir;
            const fileName = path.basename(filePath);
            const fileBase = path.parse(fileName).name;
            // Utiliser uniquement le format TXT pour les résultats
            const resultPath = path.join(resultDir, `${fileBase}_tesseract_ocr.txt`);
            
            console.log(`Exécution de Tesseract OCR pour ${fileName}... (tentative ${currentRetry + 1}/${maxRetries + 1})`);
            console.log(`Script: ${tesseractOcrScriptPath}`);
            console.log(`Résultat attendu: ${resultPath}`);
            
            // Vérifier si le fichier résultat existe déjà
            if (fs.existsSync(resultPath)) {
                console.log(`Résultat existe déjà: ${resultPath}. Suppression...`);
                try {
                    fs.unlinkSync(resultPath);
                    // Vérifier s'il existe un fichier JSON correspondant et le supprimer
                    const jsonPath = resultPath.replace('_tesseract_ocr.txt', '_tesseract_ocr.json');
                    if (fs.existsSync(jsonPath)) {
                        fs.unlinkSync(jsonPath);
                        console.log(`Fichier JSON supprimé: ${jsonPath}`);
                    }
                } catch (err) {
                    console.error(`Erreur lors de la suppression du fichier existant: ${err.message}`);
                }
            }
            
            // Définir un timeout pour le processus Python (3 minutes max)
            let processTimeout = null;
            let processFinished = false;
            
            // Configuration de l'environnement pour la performance Python
            const env = Object.assign({}, process.env, {
                // Forcer l'utilisation du CPU mode pour éviter les timeouts CUDA
                'CUDA_VISIBLE_DEVICES': '', // Désactiver CUDA
                'OMP_NUM_THREADS': '4', // Limiter les threads OpenMP
                'MKL_NUM_THREADS': '4', // Limiter les threads Intel MKL
                'PYTHONUNBUFFERED': '1', // Sortie Python non-bufferisée
                'TESSDATA_PREFIX': 'C:\\Program Files\\Tesseract-OCR\\tessdata' // Chemin vers les données Tesseract
            });
            
            // Utiliser python pour exécuter le script avec les options optimisées
            const pythonProcess = spawn('python', [
                tesseractOcrScriptPath,
                filePath,
                '--output', resultDir,
                '--type', 'auto'
            ], { env: env });
            
            // Définir un timeout pour terminer le processus s'il prend trop de temps
            processTimeout = setTimeout(() => {
                if (!processFinished) {
                    console.error(`Timeout atteint pour le traitement OCR de ${fileName}`);
                    try {
                        // Essayer de terminer proprement le processus
                        pythonProcess.kill('SIGTERM');
                        
                        // Dans 5 secondes, forcer la fermeture si nécessaire
                        setTimeout(() => {
                            if (!processFinished) {
                                pythonProcess.kill('SIGKILL');
                            }
                        }, 5000);
                        
                        reject(new Error(`Timeout dépassé pour le traitement OCR de ${fileName}`));
                    } catch (err) {
                        console.error(`Erreur lors de la tentative d'arrêt du processus: ${err.message}`);
                        reject(err);
                    }
                }
            }, 180000); // 3 minutes
            
            // Buffer pour la sortie standard (éviter de stocker trop de données en mémoire)
            let stdoutChunks = [];
            pythonProcess.stdout.on('data', (data) => {
                // Limiter la taille du buffer pour éviter les fuites de mémoire
                if (stdoutChunks.length > 10) {
                    stdoutChunks.shift(); // Supprimer les anciennes données
                }
                stdoutChunks.push(data.toString().trim());
                console.log(`Tesseract OCR (stdout): ${data.toString().trim()}`);
            });
            
            // Buffer pour la sortie d'erreur
            let stderrChunks = [];
            pythonProcess.stderr.on('data', (data) => {
                // Limiter la taille du buffer pour éviter les fuites de mémoire
                if (stderrChunks.length > 10) {
                    stderrChunks.shift(); // Supprimer les anciennes données
                }
                stderrChunks.push(data.toString().trim());
                console.error(`Tesseract OCR (stderr): ${data.toString().trim()}`);
            });
            
            // Gérer la fin du processus
            pythonProcess.on('close', (code) => {
                processFinished = true;
                
                // Annuler le timeout puisque le processus est terminé
                if (processTimeout) {
                    clearTimeout(processTimeout);
                    processTimeout = null;
                }
                
                if (code === 0) {
                    console.log(`Tesseract OCR terminé avec succès pour ${fileName}`);
                    
                    // Vérifier si le fichier résultat a été créé
                    if (fs.existsSync(resultPath)) {
                        console.log(`Fichier résultat trouvé: ${resultPath}`);
                        resolve(resultPath);
                    } else {
                        console.error(`Fichier résultat non trouvé après exécution: ${resultPath}`);
                        reject(new Error(`Fichier résultat non trouvé après exécution: ${resultPath}`));
                    }
                } else {
                    console.error(`Tesseract OCR a échoué avec le code de sortie ${code}`);
                    console.error(`Sortie d'erreur: ${stderrChunks.join('\n')}`);
                    reject(new Error(`Tesseract OCR a échoué avec le code de sortie ${code}`));
                }
            });
            
            // Gérer les erreurs de processus
            pythonProcess.on('error', (err) => {
                processFinished = true;
                
                // Annuler le timeout puisque le processus a rencontré une erreur
                if (processTimeout) {
                    clearTimeout(processTimeout);
                    processTimeout = null;
                }
                
                console.error(`Erreur lors du lancement de Tesseract OCR: ${err.message}`);
                reject(err);
            });
        });
    };
    
    // Exécuter le processus avec gestion des tentatives
    try {
        return await executeProcess();
    } catch (error) {
        console.error(`Échec de l'OCR (tentative ${currentRetry + 1}/${maxRetries + 1}): ${error.message}`);
        
        // Si nous n'avons pas atteint le nombre maximum de tentatives, réessayer
        if (currentRetry < maxRetries) {
            currentRetry++;
            console.log(`Nouvelle tentative d'OCR (${currentRetry + 1}/${maxRetries + 1}) pour ${path.basename(filePath)}...`);
            
            // Attendre 2 secondes avant de réessayer
            await new Promise(resolve => setTimeout(resolve, 2000));
            return runTesseractOcrScript(filePath); // Appel récursif avec le même chemin de fichier
        } else {
            // Toutes les tentatives ont échoué
            throw error;
        }
    }
}

module.exports = ocrController;