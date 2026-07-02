const fs = require('fs');
const path = require('path');
const { spawn } = require('child_process');

// Directory paths
const ocrResultDir = 'C:\\Users\\WESSIM\\Desktop\\pfe code\\PFE_last\\PFE_last\\backend\\ocr result';
const ollamaAnswerDir = 'C:\\Users\\WESSIM\\Desktop\\pfe code\\PFE_last\\PFE_last\\backend\\ollama answer';

// Create directories if they don't exist
if (!fs.existsSync(ollamaAnswerDir)) {
    fs.mkdirSync(ollamaAnswerDir, { recursive: true });
    console.log(`Ollama answer directory created: ${ollamaAnswerDir}`);
}

/**
 * Controller for Ollama interactions
 */
const ollamaController = {
    /**
     * Process OCR text with Ollama model
     * @param {Object} req - Express request
     * @param {Object} res - Express response
     */
    processWithOllama: async (req, res) => {
        try {
            console.log('Processing OCR with Ollama, request body:', req.body);
            const { resultFile } = req.body;
            
            if (!resultFile) {
                return res.status(400).json({
                    success: false,
                    message: 'No OCR result file specified'
                });
            }
            
            // Read OCR text from the result file
            const resultFilePath = path.join(ocrResultDir, resultFile);
            if (!fs.existsSync(resultFilePath)) {
                return res.status(404).json({
                    success: false,
                    message: `OCR result file not found: ${resultFile}`
                });
            }
            
            const ocrText = fs.readFileSync(resultFilePath, 'utf8');
            
            // Generate a unique filename for Ollama response (using .json extension)
            const timestamp = Date.now();
            const responseFilename = `ollama_response_${timestamp}.json`;
            const responseFilePath = path.join(ollamaAnswerDir, responseFilename);
            
            // Prompt optimisé pour Ollama avec instructions claires et format attendu
            // Inclure les instructions système directement dans le prompt puisque --system n'est pas supporté
            const prompt = `COMMENCER À LIRE ATTENTIVEMENT CES INSTRUCTIONS ESSENTIELLES:

Tu es un assistant spécialisé dans l'extraction de données à partir de texte OCR.
Ta mission est d'extraire des informations spécifiques et de retourner UNIQUEMENT un objet JSON brut et valide.

RÈGLES CRITIQUES À SUIVRE ABSOLUMENT:
1. NE JAMAIS utiliser de formatage Markdown (ne jamais inclure \`\`\`json ou \`\`\`)
2. NE JAMAIS ajouter de texte avant ou après le JSON
3. NE JAMAIS utiliser de commentaires dans le JSON (pas de // ou /* */)
4. NE JAMAIS ajouter d'explications, de notes ou de clarifications
5. COMMENCER ta réponse DIRECTEMENT par { (accolade ouvrante)
6. TERMINER ta réponse par } (accolade fermante)
7. RETOURNER UNIQUEMENT LE JSON BRUT, RIEN D'AUTRE

FORMAT DE RÉPONSE ATTENDU:
{
  ...contenu JSON...
}

Voici le schéma JSON à remplir à partir du texte OCR. RESPECTE STRICTEMENT CETTE STRUCTURE SANS AJOUTER DE CHAMPS SUPPLÉMENTAIRES:

{
  "informationsDocument": {
    "typeDocument": "type de document (facture, devis, etc.)",
    "numero": "numéro du document",
    "date": "date du document au format JJ/MM/AAAA"
  },
  "informationsClient": {
    "client": "nom du client ou société",
    "adresseClient": "adresse complète du client",
    "telephoneClient": "numéro de téléphone du client",
    "emailClient": "adresse email du client"
  },
  "produits": [
    {
      "designation": "nom du produit",
      "description": "description du produit",
      "prix": "prix unitaire",
      "unite": "unité (pièce, kg, etc.)",
      "quantite": "quantité",
      "totalPrix": "prix total du produit"
    }
  ],
  "calculs": {
    "totalHT": "montant total HT",
    "remise": "montant de la remise",
    "totalNetRemise": "montant total après remise",
    "tva": "montant de la TVA",
    "totalTTC": "montant total TTC"
  }
}

ATTENTION: LE JSON FINAL DOIT CONTENIR UNIQUEMENT LES SECTIONS CI-DESSUS. NE JAMAIS AJOUTER D'AUTRES SECTIONS COMME "facture", "paiement", ou toute autre section non présente dans le schéma.

INSTRUCTIONS SPÉCIFIQUES:
- RESPECTE EXACTEMENT LA STRUCTURE JSON FOURNIE SANS AJOUTER D'AUTRES CHAMPS
- Utilise "introuvable" pour les champs non trouvés
- Pour les montants, extrais uniquement les valeurs numériques sans symboles (€, $, etc.)
- Pour les dates, utilise le format JJ/MM/AAAA
- Pour les produits, ajoute TOUS les produits identifiés dans le document
- Pour les champs numériques, assure-toi qu'ils sont au format numérique (sans espaces, virgules pour les milliers ou symboles de devise)
- Vérifie la cohérence des calculs quand c'est possible
- NE CRÉE PAS de nouvelles sections comme "facture", "paiement", "IBAN", etc.

RAPPEL FINAL: TA RÉPONSE DOIT COMMENCER PAR { ET SE TERMINER PAR } SANS AUCUN AUTRE TEXTE

Texte OCR à analyser:
${ocrText}`;
            
            // Save the prompt to a file for reference (only for logging purposes)
            const promptFileName = `prompt_${timestamp}.txt`;
            const promptFilePath = path.join(ollamaAnswerDir, promptFileName);
            fs.writeFileSync(promptFilePath, prompt, 'utf8');
            console.log(`Saved prompt to ${promptFilePath}`);
            
            // Run the Ollama process in the background for API handling
            console.log('Starting Ollama process for API handling...');
            
            // Créer un fichier temporaire pour stocker le prompt
            const tempPromptFile = path.join(ollamaAnswerDir, `temp_prompt_${timestamp}.txt`);
            fs.writeFileSync(tempPromptFile, prompt, 'utf8');
            
            // Utiliser une approche simple pour exécuter Ollama avec le prompt en entrée
            console.log('Executing Ollama with direct command approach...');
            
            // Utiliser la redirection pour envoyer le prompt au modèle
            const ollamaProcess = spawn('cmd.exe', [
                '/c',
                `type "${tempPromptFile}" | ollama run qwen2.5:1.5b`
            ], {
                shell: true,
                windowsHide: true // Masquer la fenêtre cmd pour éviter qu'elle soit visible
            });
            
            let modelOutput = '';
            
            ollamaProcess.stdout.on('data', (data) => {
                const output = data.toString();
                modelOutput += output;
                console.log('Received output from Ollama:', output.substring(0, 100));
            });
            
            ollamaProcess.stderr.on('data', (data) => {
                console.error(`Ollama stderr: ${data}`);
            });
            
            ollamaProcess.on('close', (code) => {
                console.log(`Ollama process exited with code ${code}`);
                
                try {
                    // Ensure the model output is valid JSON
                    let jsonOutput = modelOutput;
                    
                    try {
                        // Nettoyage amélioré: traitement plus robuste des délimiteurs markdown et commentaires
                        let cleanedOutput = modelOutput;
                        
                        // Étape 1: Supprimer tous les délimiteurs de code markdown (```json, ```, etc.)
                        cleanedOutput = cleanedOutput.replace(/```(?:json|javascript)?\s*/g, '');
                        
                        // Étape 2: Supprimer tous les types de commentaires JavaScript
                        // Supprimer les commentaires de ligne (//...)
                        cleanedOutput = cleanedOutput.replace(/\/\/.*$/gm, '');
                        // Supprimer les commentaires multi-lignes (/* ... */)
                        cleanedOutput = cleanedOutput.replace(/\/\*[\s\S]*?\*\//g, '');
                        
                        // Étape 3: Supprimer tout texte avant le premier { et après le dernier }
                        const firstBrace = cleanedOutput.indexOf('{');
                        const lastBrace = cleanedOutput.lastIndexOf('}');
                        
                        if (firstBrace !== -1 && lastBrace !== -1 && lastBrace > firstBrace) {
                            cleanedOutput = cleanedOutput.substring(firstBrace, lastBrace + 1);
                            
                            // Étape 4: Nettoyer les commentaires à l'intérieur du JSON
                            // Diviser en lignes pour un traitement plus précis
                            let jsonLines = cleanedOutput.split('\n');
                            
                            // Filtrer les lignes de commentaires et les lignes vides
                            jsonLines = jsonLines.filter(line => {
                                const trimmedLine = line.trim();
                                return !(trimmedLine.startsWith('//') || trimmedLine === '');
                            });
                            
                            // Traiter chaque ligne pour supprimer les commentaires en fin de ligne
                            jsonLines = jsonLines.map(line => {
                                // Supprimer les commentaires après le contenu JSON sur la même ligne
                                const commentIndex = line.indexOf('//');
                                if (commentIndex > 0) {
                                    return line.substring(0, commentIndex).trim();
                                }
                                return line;
                            });
                            
                            // Reconstruire le JSON
                            cleanedOutput = jsonLines.join('\n');
                            
                            // Étape 5: Corriger les problèmes courants de syntaxe JSON
                            // Supprimer les virgules traînantes avant les accolades/crochets fermants
                            cleanedOutput = cleanedOutput.replace(/,\s*([\]\}])/g, '$1');
                            
                            // Essayer de parser le JSON nettoyé
                            JSON.parse(cleanedOutput);
                            jsonOutput = cleanedOutput;
                            console.log('Successfully parsed cleaned JSON output');
                        } else {
                            throw new Error('No valid JSON structure found');
                        }
                    } catch (jsonError) {
                        console.warn('Cleaned output is not valid JSON, attempting more aggressive extraction...', jsonError.message);
                        
                        try {
                            // Approche alternative: extraction plus agressive du JSON
                            // Rechercher un objet JSON valide dans la sortie
                            const jsonMatch = modelOutput.match(/\{[\s\S]*?\}/g);
                            
                            if (jsonMatch && jsonMatch.length > 0) {
                                // Prendre le plus grand match comme candidat probable
                                let candidateJson = jsonMatch.reduce((a, b) => a.length > b.length ? a : b);
                                
                                // Nettoyer les commentaires dans le candidat JSON
                                candidateJson = candidateJson.replace(/\/\/.*$/gm, '');
                                candidateJson = candidateJson.replace(/\/\*[\s\S]*?\*\//g, '');
                                
                                // Supprimer les virgules traînantes
                                candidateJson = candidateJson.replace(/,\s*([\]\}])/g, '$1');
                                
                                // Vérifier si c'est un JSON valide
                                JSON.parse(candidateJson);
                                jsonOutput = candidateJson;
                                console.log('Successfully extracted valid JSON using aggressive approach');
                            } else {
                                throw new Error('No JSON object found in output');
                            }
                        } catch (extractError) {
                            console.error('Failed to extract valid JSON from Ollama output:', extractError);
                            // Dernière tentative: essayer de reconstruire un JSON minimal à partir de la structure attendue
                            try {
                                // Créer un objet JSON minimal avec la structure attendue
                                const minimalJson = {
                                    "informationsDocument": {
                                        "typeDocument": "Not detected",
                                        "numero": "Not detected",
                                        "date": "Not detected"
                                    },
                                    "informationsClient": {
                                        "client": "Not detected",
                                        "adresseClient": "Not detected",
                                        "telephoneClient": "Not detected",
                                        "emailClient": "Not detected"
                                    },
                                    "produits": [],
                                    "calculs": {
                                        "totalHT": "Not detected",
                                        "remise": "Not detected",
                                        "totalNetRemise": "Not detected",
                                        "tva": "Not detected",
                                        "totalTTC": "Not detected"
                                    }
                                };
                                
                                // Utiliser ce JSON minimal comme fallback
                                jsonOutput = JSON.stringify(minimalJson);
                                console.log('Using minimal JSON structure as fallback');
                            } catch (fallbackError) {
                                console.error('Failed to create fallback JSON:', fallbackError);
                                // En dernier recours, utiliser un objet vide
                                jsonOutput = '{}';
                            }
                        }
                    }
                    
                    // Format the JSON output properly before saving
                    try {
                        // Try to parse and then stringify to ensure proper JSON formatting
                        const jsonObject = JSON.parse(jsonOutput);
                        
                        // Vérifier et corriger la structure du JSON selon le schéma attendu
                        const expectedSchema = {
                            "informationsDocument": {
                                "typeDocument": "",
                                "numero": "",
                                "date": ""
                            },
                            "informationsClient": {
                                "client": "",
                                "adresseClient": "",
                                "telephoneClient": "",
                                "emailClient": ""
                            },
                            "produits": [],
                            "calculs": {
                                "totalHT": "",
                                "remise": "",
                                "totalNetRemise": "",
                                "tva": "",
                                "totalTTC": ""
                            }
                        };
                        
                        // Fonction pour s'assurer que l'objet suit le schéma attendu
                        const ensureValidStructure = (obj, schema) => {
                            const result = {};
                            
                            // Parcourir le schéma et s'assurer que chaque propriété existe
                            Object.keys(schema).forEach(key => {
                                if (typeof schema[key] === 'object' && !Array.isArray(schema[key])) {
                                    // Propriété de type objet
                                    result[key] = obj && typeof obj[key] === 'object' && !Array.isArray(obj[key]) 
                                        ? ensureValidStructure(obj[key], schema[key])
                                        : ensureValidStructure({}, schema[key]);
                                } else if (Array.isArray(schema[key])) {
                                    // Propriété de type tableau
                                    result[key] = obj && Array.isArray(obj[key]) ? obj[key] : [];
                                } else {
                                    // Propriété de type primitif
                                    result[key] = obj && obj[key] !== undefined ? obj[key] : "Not detected";
                                }
                            });
                            
                            return result;
                        };
                        
                        // Appliquer la validation de structure
                        const validatedJson = ensureValidStructure(jsonObject, expectedSchema);
                        jsonOutput = JSON.stringify(validatedJson, null, 2);
                        console.log('Successfully formatted and validated JSON structure');
                    } catch (formatError) {
                        console.warn('Could not format JSON output, saving as is:', formatError);
                    }
                    
                    // Save the JSON output to the response file
                    fs.writeFileSync(responseFilePath, jsonOutput, 'utf8');
                    console.log(`Saved Ollama response as JSON to ${responseFilePath}`);
                    
                    // Clean up the temporary prompt file
                    if (fs.existsSync(tempPromptFile)) {
                        fs.unlinkSync(tempPromptFile);
                    }
                    
                    // Send the response to the client
                    // Assurer que nous envoyons toujours un objet JSON valide au client
                    let resultData;
                    try {
                        // Si c'est une chaîne JSON, la parser en objet pour la réponse
                        if (typeof jsonOutput === 'string') {
                            resultData = JSON.parse(jsonOutput);
                        } else {
                            resultData = jsonOutput;
                        }
                    } catch (parseError) {
                        console.warn('Could not parse JSON output for response, creating a valid fallback:', parseError);
                        // Créer un objet JSON minimal comme fallback
                        resultData = {
                            "informationsDocument": {
                                "typeDocument": "Not detected",
                                "numero": "Not detected",
                                "date": "Not detected"
                            },
                            "informationsClient": {
                                "client": "Not detected",
                                "adresseClient": "Not detected",
                                "telephoneClient": "Not detected",
                                "emailClient": "Not detected"
                            },
                            "produits": [],
                            "calculs": {
                                "totalHT": "Not detected",
                                "remise": "Not detected",
                                "totalNetRemise": "Not detected",
                                "tva": "Not detected",
                                "totalTTC": "Not detected"
                            }
                        };
                        
                        // Réécrire le fichier avec le JSON valide
                        fs.writeFileSync(responseFilePath, JSON.stringify(resultData, null, 2), 'utf8');
                        console.log(`Rewrote response file with valid JSON fallback`);
                    }
                    
                    res.status(200).json({
                        success: true,
                        message: 'Ollama processing completed successfully',
                        result: resultData,
                        responseFile: responseFilename
                    });
                } catch (error) {
                    console.error('Error processing Ollama response:', error);
                    res.status(500).json({
                        success: false,
                        message: 'Error processing Ollama response',
                        error: error.message
                    });
                }
            });
        } catch (error) {
            console.error('Error processing with Ollama:', error);
            return res.status(500).json({
                success: false,
                message: 'Error processing with Ollama',
                error: error.message
            });
        }
    },
    
    /**
     * Get a specific Ollama response file
     * @param {Object} req - Express request
     * @param {Object} res - Express response
     */
    getOllamaResponse: async (req, res) => {
        try {
            const { filename } = req.params;
            
            if (!filename) {
                return res.status(400).json({
                    success: false,
                    message: 'No filename specified'
                });
            }
            
            const filePath = path.join(ollamaAnswerDir, filename);
            
            if (!fs.existsSync(filePath)) {
                return res.status(404).json({
                    success: false,
                    message: `File not found: ${filename}`
                });
            }
            
            const fileContent = fs.readFileSync(filePath, 'utf8');
            
            return res.status(200).json({
                success: true,
                content: fileContent
            });
        } catch (error) {
            console.error('Error getting Ollama response:', error);
            return res.status(500).json({
                success: false,
                message: 'Error getting Ollama response',
                error: error.message
            });
        }
    },
    
    /**
     * List all Ollama response files
     * @param {Object} req - Express request
     * @param {Object} res - Express response
     */
    listOllamaResponses: async (req, res) => {
        try {
            if (!fs.existsSync(ollamaAnswerDir)) {
                return res.status(200).json({
                    success: true,
                    responses: []
                });
            }
            
            const files = fs.readdirSync(ollamaAnswerDir);
            const responseFiles = files.filter(file => file.startsWith('ollama_response_'));
            
            const responses = responseFiles.map(file => {
                const filePath = path.join(ollamaAnswerDir, file);
                const stats = fs.statSync(filePath);
                
                return {
                    filename: file,
                    createdAt: stats.birthtime,
                    size: stats.size
                };
            });
            
            return res.status(200).json({
                success: true,
                responses
            });
        } catch (error) {
            console.error('Error listing Ollama responses:', error);
            return res.status(500).json({
                success: false,
                message: 'Error listing Ollama responses',
                error: error.message
            });
        }
    }
};

module.exports = ollamaController;
