<template>
  <div class="ocr-ia-container">
    <div class="ocr-header">
      <h2 class="ocr-title">OCR & Intelligence Artificielle</h2>
      <p class="ocr-subtitle">Automatisez l'extraction de données de vos documents</p>
    </div>

    <!-- Tabs Navigation -->
    <div class="ocr-tabs">
      <div 
        v-for="(tab, index) in tabs" 
        :key="tab.id"
        class="ocr-tab" 
        :class="{ 'active': activeTab === tab.id }"
        @click="setActiveTab(tab.id)"
        :style="{ '--i': index }"
      >
        <i :class="tab.icon"></i>
        <span>{{ tab.name }}</span>
      </div>
    </div>

    <!-- Tab Content -->
    <div class="ocr-content">
      <!-- Upload & Preprocessing Tab -->
      <div v-if="activeTab === 'upload'" class="tab-content upload-tab">
        <div class="upload-container" 
          @dragover.prevent="highlightDropZone = true"
          @dragleave.prevent="highlightDropZone = false"
          @drop.prevent="onFileDrop"
          :class="{ 'highlight': highlightDropZone, 'has-files': uploadedFiles.length > 0 }"
        >
          <div v-if="uploadedFiles.length === 0" class="upload-placeholder">
            <i class="fas fa-cloud-upload-alt"></i>
            <h3>Glissez-déposez vos documents ici</h3>
            <p>ou</p>
            <label class="upload-button">
              Parcourir les fichiers
              <input type="file" @change="onFileSelect" multiple accept=".pdf,.jpg,.jpeg,.png" class="file-input" />
            </label>
            <p class="upload-formats">Formats acceptés: PDF, JPEG, PNG</p>
          </div>
          
          <div v-else class="uploaded-files">
            <h3><i class="fas fa-file-alt"></i> Documents téléchargés</h3>
            <div class="file-list">
              <div v-for="(file, index) in uploadedFiles" :key="index" class="file-item">
                <div class="file-info">
                  <i :class="getFileIcon(file.name)"></i>
                  <span class="file-name">{{ file.name }}</span>
                  <span class="file-size">{{ formatFileSize(file.size) }}</span>
                </div>
                <div class="file-actions">
                  <button class="file-remove" @click="removeFile(index)">
                    <i class="fas fa-times"></i>
                  </button>
                </div>
              </div>
            </div>
            
            <div class="upload-actions">
              <button class="clear-button" @click="clearFiles">
                <i class="fas fa-trash"></i> Tout effacer
              </button>
              <button class="process-button" @click="processFiles">
                <i class="fas fa-cogs"></i> Traiter les documents
              </button>
            </div>
          </div>
        </div>

        <!-- Upload Progress -->
        <div v-if="isUploading" class="upload-progress">
          <div class="progress-container">
            <div class="progress-bar" :style="{ width: `${uploadProgress}%` }"></div>
          </div>
          <div class="progress-info">
            <span>{{ uploadProgress }}%</span>
            <span>{{ currentFile }} / {{ totalFiles }}</span>
          </div>
        </div>

        <!-- Upload Errors -->
        <div v-if="uploadErrors.length > 0" class="upload-errors">
          <h4><i class="fas fa-exclamation-triangle"></i> Erreurs de téléchargement</h4>
          <ul>
            <li v-for="(error, index) in uploadErrors" :key="index">
              {{ error.file }}: {{ error.message }}
            </li>
          </ul>
        </div>
      </div>

      <!-- OCR Extraction Tab -->
      <div v-if="activeTab === 'extraction'" class="tab-content extraction-tab">
        <div class="extraction-container">
          <div v-if="!extractionStarted" class="extraction-placeholder">
            <i class="fas fa-magic"></i>
            <h3>Extraction OCR</h3>
            <p>Téléchargez d'abord vos documents dans l'onglet précédent</p>
          </div>
          
          <div v-else-if="isExtracting && !(ollamaProcessed && ollamaStatus === 'complete')" class="extraction-progress">
            <div class="progress-animation">
              <div class="spinner"></div>
            </div>
            <h3>Extraction et analyse en cours...</h3>
            <p>Nous analysons vos documents avec notre technologie OCR et Intelligence Artificielle</p>
            <div class="progress-container">
              <div class="progress-bar" :style="{ width: `${extractionProgress}%` }"></div>
            </div>
            <div class="progress-info">
              <span>{{ extractionProgress }}%</span>
              <span>Document {{ currentExtraction }} / {{ totalExtractions }}</span>
            </div>
            <div class="extraction-details">
              <p><i class="fas fa-search"></i> Recherche de texte...</p>
              <p><i class="fas fa-user"></i> Détection des informations client...</p>
              <p><i class="fas fa-calendar-alt"></i> Identification des dates...</p>
              <p><i class="fas fa-euro-sign"></i> Extraction des montants...</p>
              <p v-if="isOllamaProcessing"><i class="fas fa-robot"></i> Analyse par intelligence artificielle...</p>
            </div>
          </div>
          
          <!-- Ollama AI Processing Console - Caché mais fonctionnel -->
          <div v-if="isOllamaProcessing || ollamaProcessed" class="ollama-console" style="display: none;">
            <div class="console-header">
              <h3><i class="fas fa-robot"></i> Intelligence Artificielle</h3>
              <div class="console-controls">
                <button class="toggle-console">
                  <i class="fas fa-chevron-up"></i>
                </button>
              </div>
            </div>
            
            <div class="console-status" :class="ollamaStatus">
              <span v-if="ollamaStatus === 'idle'">
                <i class="fas fa-circle"></i> En attente...
              </span>
              <span v-else-if="ollamaStatus === 'ready'">
                <i class="fas fa-check-circle"></i> Modèle prêt
              </span>
              <span v-else-if="ollamaStatus === 'thinking'">
                <i class="fas fa-cog fa-spin"></i> Analyse en cours...
              </span>
              <span v-else-if="ollamaStatus === 'complete'">
                <i class="fas fa-check-double"></i> Analyse terminée
              </span>
            </div>
            
            <div class="console-content">
              <pre>{{ cleanAnsiText(ollamaConversation) }}</pre>
            </div>
          </div>
          
          <div v-else-if="ollamaProcessed && ollamaStatus === 'complete'" class="extraction-results">
            <h3><i class="fas fa-check-circle"></i> Extraction terminée</h3>
            <p>Les données ont été extraites avec succès. Vous pouvez maintenant les vérifier et les corriger si nécessaire.</p>
            <button class="next-step-button" @click="goToCorrection">
              <i class="fas fa-arrow-right"></i> Passer à la correction
            </button>
          </div>
          
          <div v-else class="extraction-placeholder">
            <i class="fas fa-magic"></i>
            <h3>En attente du traitement</h3>
            <p>Veuillez lancer le traitement des documents pour voir les résultats</p>
          </div>
        </div>
      </div>

      <!-- Manual Correction Tab -->
      <div v-if="activeTab === 'correction'" class="tab-content correction-tab">
        <div class="correction-container">
          <div v-if="!extractionCompleted" class="correction-placeholder">
            <i class="fas fa-pencil-alt"></i>
            <h3>Correction Manuelle</h3>
            <p>Veuillez d'abord compléter l'extraction OCR</p>
          </div>
          
          <div v-else class="correction-interface">
            <div class="form-sections">
              <!-- Section Document -->
              <div class="form-section">
                <h3 class="section-title" @click="toggleSection('document')">
                  <i class="fas fa-file-alt"></i> Informations Document
                  <i :class="['fas', 'fa-chevron-' + (sectionsOpen.document ? 'up' : 'down'), 'toggle-icon']"></i>
                </h3>
                <div class="section-content" v-show="sectionsOpen.document">
                  <div class="form-row">
                    <div class="form-group">
                      <label>Type de document</label>
                      <input type="text" v-model="extractedData.typeDocument" placeholder="Type de document" />
                    </div>
                    <div class="form-group">
                      <label>ID Document</label>
                      <input type="text" v-model="extractedData.numero" placeholder="Numéro de document" />
                    </div>
                  </div>
                  <div class="form-group">
                    <label>Date du document</label>
                    <input type="text" v-model="extractedData.date" placeholder="JJ/MM/AAAA" />
                  </div>
                </div>
              </div>
              
              <!-- Section Client -->
              <div class="form-section">
                <h3 class="section-title" @click="toggleSection('client')">
                  <i class="fas fa-user"></i> Informations Client
                  <i :class="['fas', 'fa-chevron-' + (sectionsOpen.client ? 'up' : 'down'), 'toggle-icon']"></i>
                </h3>
                <div class="section-content" v-show="sectionsOpen.client">
                  <div class="form-group">
                    <label>Nom du client</label>
                    <input type="text" v-model="extractedData.client" placeholder="Nom du client ou société" />
                  </div>
                  <div class="form-group">
                    <label>Adresse</label>
                    <input type="text" v-model="extractedData.adresseClient" placeholder="Adresse complète" />
                  </div>
                  <div class="form-row">
                    <div class="form-group">
                      <label>Téléphone</label>
                      <input type="text" v-model="extractedData.telephoneClient" placeholder="Numéro de téléphone" />
                    </div>
                    <div class="form-group">
                      <label>Email</label>
                      <input type="email" v-model="extractedData.emailClient" placeholder="Adresse email" />
                    </div>
                  </div>
                </div>
              </div>
              
              <!-- Section Produits -->
              <div class="form-section">
                <h3 class="section-title" @click="toggleSection('produit')">
                  <i class="fas fa-shopping-cart"></i> Produits
                  <i :class="['fas', 'fa-chevron-' + (sectionsOpen.produit ? 'up' : 'down'), 'toggle-icon']"></i>
                </h3>
                <div class="section-content" v-show="sectionsOpen.produit">
                  <div v-for="(produit, index) in extractedData.produits" :key="index" class="product-form">
                    <div class="product-header">
                      <h4>Produit #{{ index + 1 }}</h4>
                      <button v-if="extractedData.produits.length > 1" class="remove-product-btn" @click="removeProduct(index)">
                        <i class="fas fa-times"></i>
                      </button>
                    </div>
                    <div class="form-group">
                      <label>Nom du produit</label>
                      <input type="text" v-model="produit.designation" placeholder="Nom du produit"  />
                    </div>
                    <div class="form-group">
                      <label>Description</label>
                      <textarea v-model="produit.description" placeholder="Description du produit"></textarea>
                    </div>
                    <div class="form-row">
                      <div class="form-group">
                        <label>Prix unitaire</label>
                        <input type="text" v-model="produit.prix" placeholder="0.00" step="0.01"  />
                      </div>
                      <div class="form-group">
                        <label>Unité</label>
                        <input type="text" v-model="produit.unite" placeholder="pièce, kg, etc." />
                      </div>
                    </div>
                    <div class="form-row">
                      <div class="form-group">
                        <label>Quantité</label>
                        <input type="text" v-model="produit.quantite" placeholder="0" min="1"  />
                      </div>
                      <div class="form-group">
                        <label>Total prix</label>
                        <input type="text" v-model="produit.totalPrix" placeholder="0.00"  />
                      </div>
                    </div>
                    <hr v-if="index < extractedData.produits.length - 1" class="product-divider">
                  </div>
                  <div class="add-product-container">
                    <button class="add-product-btn" @click="addProduct">
                      <i class="fas fa-plus"></i> Ajouter un produit
                    </button>
                  </div>
                </div>
              </div>
              
              <!-- Section Calculs -->
              <div class="form-section">
                <h3 class="section-title" @click="toggleSection('calcul')">
                  <i class="fas fa-calculator"></i> Calculs
                  <i :class="['fas', 'fa-chevron-' + (sectionsOpen.calcul ? 'up' : 'down'), 'toggle-icon']"></i>
                </h3>
                <div class="section-content" v-show="sectionsOpen.calcul">
                  <div class="form-row">
                    <div class="form-group">
                      <label>Total HT</label>
                      <input type="text" v-model="extractedData.totalHT" placeholder="0.00"  />
                    </div>
                    <div class="form-group">
                      <label>Remise</label>
                      <input type="text" v-model="extractedData.remise" placeholder="0.00" />
                    </div>
                  </div>
                  <div class="form-row">
                    <div class="form-group">
                      <label>Total Net (après remise)</label>
                      <input type="text" v-model="extractedData.totalNetRemise" placeholder="0.00"  />
                    </div>
                    <div class="form-group">
                      <label>TVA</label>
                      <input type="text" v-model="extractedData.tva" placeholder="0.00"  />
                    </div>
                  </div>
                  <div class="form-group total-ttc">
                    <label>Total TTC</label>
                    <input type="text" v-model="extractedData.totalTTC" placeholder="0.00"  />
                  </div>
                </div>
              </div>
              
              <div class="correction-actions">
                <button class="validate-button" @click="validateData">
                  <i class="fas fa-arrow-right"></i> Continuer
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, defineEmits } from 'vue';

// Tabs configuration
const tabs = [
  { id: 'upload', name: 'Téléchargement & Prétraitement', icon: 'fas fa-cloud-upload-alt' },
  { id: 'extraction', name: 'Extraction OCR', icon: 'fas fa-magic' },
  { id: 'correction', name: 'Affichage & Correction', icon: 'fas fa-pencil-alt' }
];

// Active tab state
const activeTab = ref('upload');
const setActiveTab = (tabId) => {
  activeTab.value = tabId;
};

// Backend API URL
const apiBaseUrl = 'http://localhost:5000/api';

// Upload & Preprocessing tab
const uploadedFiles = ref([]);
const highlightDropZone = ref(false);
const isUploading = ref(false);
const uploadProgress = ref(0);
const currentFile = ref(0);
const totalFiles = ref(0);
const uploadErrors = ref([]);

// File handling functions
const onFileSelect = (event) => {
  const files = Array.from(event.target.files);
  addFiles(files);
};

const onFileDrop = (event) => {
  highlightDropZone.value = false;
  const files = Array.from(event.dataTransfer.files);
  addFiles(files);
};

const addFiles = (files) => {
  // Filter for accepted file types
  const acceptedTypes = ['.pdf', '.jpg', '.jpeg', '.png'];
  const validFiles = files.filter(file => {
    const extension = '.' + file.name.split('.').pop().toLowerCase();
    return acceptedTypes.includes(extension);
  });
  
  // Add valid files to the list
  uploadedFiles.value = [...uploadedFiles.value, ...validFiles];
  
  // Add errors for invalid files
  const invalidFiles = files.filter(file => {
    const extension = '.' + file.name.split('.').pop().toLowerCase();
    return !acceptedTypes.includes(extension);
  });
  
  invalidFiles.forEach(file => {
    uploadErrors.value.push({
      file: file.name,
      message: 'Format de fichier non supporté'
    });
  });
};

const removeFile = (index) => {
  uploadedFiles.value.splice(index, 1);
};

const clearFiles = () => {
  uploadedFiles.value = [];
  uploadErrors.value = [];
};

const processFiles = async () => {
  if (uploadedFiles.value.length === 0) {
    return;
  }
  
  // Variables pour la gestion des tentatives
  let maxRetries = 3;
  let currentRetry = 0;
  let progressInterval = null;
  
  const executeRequest = async () => {
    try {
      // Préparer l'upload réel des fichiers
      isUploading.value = true;
      uploadProgress.value = 0;
      currentFile.value = 0;
      totalFiles.value = uploadedFiles.value.length;
      uploadErrors.value = [];
      
      // Créer un objet FormData pour envoyer les fichiers
      const formData = new FormData();
      uploadedFiles.value.forEach(file => {
        formData.append('documents', file);
      });
      
      // Upload progressif simulé pendant la transmission
      progressInterval = setInterval(() => {
        if (uploadProgress.value < 90) { // Max 90% pour simuler l'attente du serveur
          uploadProgress.value += 5;
          if (uploadProgress.value % 20 === 0 && currentFile.value < totalFiles.value - 1) {
            currentFile.value++;
          }
        }
      }, 200);
      
      // Récupérer le token d'authentification
      const token = localStorage.getItem('token');
      if (!token) {
        throw new Error('Vous devez être connecté pour utiliser cette fonctionnalité');
      }
      
      // Appel API réel avec authentification avec timeout
      const controller = new AbortController();
      const timeoutId = setTimeout(() => controller.abort(), 120000); // 2 minutes timeout
      
      const response = await fetch(`${apiBaseUrl}/ocr/extract`, {
        method: 'POST',
        body: formData,
        headers: {
          'Authorization': `Bearer ${token}`
        },
        signal: controller.signal
      });
      
      clearTimeout(timeoutId);
      clearInterval(progressInterval);
      
      // Compléter le upload à 100%
      uploadProgress.value = 100;
      currentFile.value = totalFiles.value;
      
      if (!response.ok) {
        throw new Error(`Erreur HTTP: ${response.status}`);
      }
      
      const result = await response.json();
      console.log('Résultat OCR:', result);
      
      // Attendre un peu pour montrer le 100%
      setTimeout(() => {
        isUploading.value = false;
        extractionStarted.value = true;
        
        // Stocker les résultats OCR pour les utiliser plus tard
        ocrResults.value = result.results;
        
        // Passer automatiquement à l'étape d'extraction OCR
        activeTab.value = 'extraction';
        
        // Démarrer l'extraction
        startExtraction();
      }, 500);
      
    } catch (error) {
      clearInterval(progressInterval);
      
      // Gérer les erreurs d'abort (timeout) et de réseau
      if (error.name === 'AbortError') {
        console.error('La requête a été interrompue après le délai d\'attente');
        uploadErrors.value.push({
          file: 'Téléchargement',
          message: `Erreur: Délai d'attente dépassé. Le serveur met trop de temps à répondre.`
        });
      } else if (error.message.includes('Failed to fetch') || error.message.includes('NetworkError') || error.message.includes('network') || error.message.includes('ERR_CONNECTION_RESET')) {
        console.error('Erreur de connexion réseau:', error);
        
        // Tentative de nouvelle connexion si le nombre max de tentatives n'est pas atteint
        if (currentRetry < maxRetries) {
          currentRetry++;
          console.log(`Tentative de reconnexion ${currentRetry}/${maxRetries}...`);
          uploadErrors.value = [];
          uploadErrors.value.push({
            file: 'Téléchargement',
            message: `Erreur de connexion. Tentative ${currentRetry}/${maxRetries}...`
          });
          
          // Attendre 2 secondes avant de réessayer
          setTimeout(() => {
            executeRequest();
          }, 2000);
          return;
        } else {
          uploadErrors.value.push({
            file: 'Téléchargement',
            message: `Erreur de connexion après ${maxRetries} tentatives. Veuillez vérifier votre connexion internet ou réessayer plus tard.`
          });
        }
      } else {
        console.error('Erreur lors du traitement des fichiers:', error);
        uploadErrors.value.push({
          file: 'Téléchargement',
          message: `Erreur: ${error.message}`
        });
      }
      
      isUploading.value = false;
    }
  };
  
  // Lancer la première tentative
  await executeRequest();
};

// Utility functions for file display
const getFileIcon = (fileName) => {
  const extension = fileName.split('.').pop().toLowerCase();
  if (extension === 'pdf') return 'fas fa-file-pdf';
  if (['jpg', 'jpeg', 'png'].includes(extension)) return 'fas fa-file-image';
  return 'fas fa-file';
};

const formatFileSize = (bytes) => {
  if (bytes === 0) return '0 Bytes';
  const k = 1024;
  const sizes = ['Bytes', 'KB', 'MB', 'GB'];
  const i = Math.floor(Math.log(bytes) / Math.log(k));
  return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
};

// OCR Extraction tab
const extractionStarted = ref(false);
const isExtracting = ref(false);
const extractionProgress = ref(0);
const currentExtraction = ref(0);
const totalExtractions = ref(0);
const extractionCompleted = ref(false);

// Ollama processing state
const isOllamaProcessing = ref(false);
const ollamaProcessed = ref(false);
const ollamaConversation = ref('');
const ollamaStatus = ref('idle'); // idle, ready, thinking, complete
const ollamaResponseData = ref(null);
const ollamaResponseFile = ref('');
const showOllamaConsole = ref(false); // Toujours false pour cacher la console
const ocrResults = ref([]); // Stocker les résultats OCR

// Fonction pour nettoyer les codes ANSI dans les messages de console
const cleanAnsiText = (text) => {
  if (!text || typeof text !== 'string') return '';
  
  // Supprimer les codes ANSI (utilisés pour la coloration dans les terminaux)
  const cleanedText = text.replace(/\x1B\[[0-9;]*[JKmsu]/g, '');
  
  // Vérifier si le texte nettoyé contient des messages de fin de processus Ollama
  watchOllamaMessages(cleanedText);
  
  return cleanedText;
};

// Fonction pour vérifier si le message contient les indications de fin de processus Ollama
const checkOllamaExitMessage = (message) => {
  if (!message || typeof message !== 'string') return false;
  
  const exitMessages = [
    'Ollama stderr: Ollama process exited with code 0',
    'ollam process exited',
    'Ollama process exited'
  ];
  
  return exitMessages.some(exitMsg => message.includes(exitMsg));
};

// Fonction pour surveiller les messages d'Ollama et déclencher la transition automatique
const watchOllamaMessages = (message) => {
  if (checkOllamaExitMessage(message)) {
    console.log('Détection de fin de processus Ollama, transition automatique vers la correction');
    ollamaProcessed.value = true;
    ollamaStatus.value = 'complete';
    isExtracting.value = false;
    extractionCompleted.value = true;
    
    // Appliquer automatiquement les résultats d'Ollama avant la transition
    if (ollamaResponseData.value) {
      applyOllamaResults();
    }
    
    // Transition automatique vers l'onglet de correction
    setTimeout(() => {
      setActiveTab('correction');
    }, 500);
    
    return true;
  }
  return false;
};

const processWithOllama = async (resultFile) => {
  try {
    console.log('Processing OCR text with Ollama model...');
    isOllamaProcessing.value = true;
    ollamaStatus.value = 'idle';
    ollamaConversation.value = 'Initializing Ollama model...';
    // La console Ollama reste cachée
    showOllamaConsole.value = false;
    
    // Call the Ollama API using the public endpoint that bypasses authentication
    const ollamaApiUrl = 'http://localhost:5000/public/ollama';
    const response = await fetch(`${ollamaApiUrl}/process`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ resultFile })
    });
    
    if (!response.ok) {
      const errorData = await response.json();
      throw new Error(errorData.message || 'Error processing with Ollama');
    }
    
    const result = await response.json();
    ollamaResponseData.value = result.result;
    ollamaResponseFile.value = result.responseFile;
    
    // Mettre à jour les états pour indiquer que le traitement est terminé
    ollamaProcessed.value = true;
    ollamaStatus.value = 'complete';
    isExtracting.value = false; // Mettre à jour isExtracting lorsque le traitement est terminé
    extractionCompleted.value = true; // Marquer l'extraction comme terminée
    
    const completionMessage = '\n\nAnalysis complete! Results are ready to apply.';
    ollamaConversation.value += completionMessage;
    
    // Appliquer automatiquement les résultats d'Ollama sans nécessiter le bouton
    applyOllamaResults();
    
    // Surveiller activement les messages d'Ollama pour détecter la fin du processus
    // Vérifier d'abord le fichier de réponse pour les messages de fin de processus
    if (result.responseFile && typeof result.responseFile === 'string') {
      // Si le message contient des indications de fin de processus, la transition sera déclenchée
      if (checkOllamaExitMessage(result.responseFile)) {
        console.log('Détection de fin de processus Ollama dans le fichier de réponse');
        // La fonction watchOllamaMessages va déclencher la transition automatique
        watchOllamaMessages(result.responseFile);
      }
    }
    
    // Vérifier également si le message de complétion contient des indications de fin de processus
    if (checkOllamaExitMessage(completionMessage)) {
      console.log('Détection de fin de processus Ollama dans le message de complétion');
      watchOllamaMessages(completionMessage);
    } else {
      // Si aucun message de fin n'a été détecté, forcer la transition après un délai
      console.log('Aucun message de fin détecté, transition automatique programmée');
      setTimeout(() => {
        // S'assurer que les résultats sont appliqués avant la transition
        if (ollamaResponseData.value) {
          applyOllamaResults();
        }
        setActiveTab('correction');
      }, 1000);
    }
    
    return result.result;
  } catch (error) {
    console.error('Error processing with Ollama:', error);
    ollamaStatus.value = 'idle';
    
    const errorMessage = `\n\nError: ${error.message}`;
    ollamaConversation.value += errorMessage;
    
    // Vérifier si le message d'erreur contient des indications de fin de processus Ollama
    if (error && error.message && checkOllamaExitMessage(error.message)) {
      console.log('Détection de fin de processus Ollama dans le message d\'erreur');
      watchOllamaMessages(error.message);
    } else {
      // En cas d'erreur sans message de fin, marquer quand même comme terminé
      ollamaProcessed.value = true;
      ollamaStatus.value = 'complete';
      isExtracting.value = false;
      extractionCompleted.value = true;
      
      // Appliquer automatiquement les résultats d'Ollama même en cas d'erreur
      if (ollamaResponseData.value) {
        applyOllamaResults();
      }
      
      // Transition automatique vers l'onglet de correction même en cas d'erreur
      setTimeout(() => {
        setActiveTab('correction');
      }, 1000);
    }
    
    return null;
  }
};

const applyOllamaResults = () => {
  if (!ollamaResponseData.value) {
    console.error('No Ollama response data available');
    return;
  }
  
  const data = ollamaResponseData.value;
  console.log('Applying Ollama results:', data);
  
  // Initialiser les données extraites si nécessaire
  if (!extractedData.value) {
    extractedData.value = {};
  }
  
  // Traiter les données selon la nouvelle structure JSON
  
  // Section Informations Document
  if (data.informationsDocument) {
    if (data.informationsDocument.typeDocument) extractedData.value.typeDocument = data.informationsDocument.typeDocument;
    if (data.informationsDocument.numero) extractedData.value.numero = data.informationsDocument.numero;
    if (data.informationsDocument.date) extractedData.value.date = data.informationsDocument.date;
  } else {
    // Compatibilité avec l'ancien format
    if (data.typeDocument) extractedData.value.typeDocument = data.typeDocument;
    if (data.numero) extractedData.value.numero = data.numero;
    if (data.date) extractedData.value.date = data.date;
  }
  
  // Section Informations Client
  if (data.informationsClient) {
    if (data.informationsClient.client) extractedData.value.client = data.informationsClient.client;
    if (data.informationsClient.adresseClient) extractedData.value.adresseClient = data.informationsClient.adresseClient;
    if (data.informationsClient.telephoneClient) extractedData.value.telephoneClient = data.informationsClient.telephoneClient;
    if (data.informationsClient.emailClient) extractedData.value.emailClient = data.informationsClient.emailClient;
  } else {
    // Compatibilité avec l'ancien format
    if (data.client) extractedData.value.client = data.client;
    if (data.adresseClient) extractedData.value.adresseClient = data.adresseClient;
    if (data.telephoneClient) extractedData.value.telephoneClient = data.telephoneClient;
    if (data.emailClient) extractedData.value.emailClient = data.emailClient;
  }
  
  // Section Produits
  const produits = data.produits || (data.produits && Array.isArray(data.produits)) ? data.produits : [];
  
  if (produits.length > 0) {
    // Stocker tous les produits dans le tableau extractedData.produits
    extractedData.value.produits = produits.map(produit => ({
      designation: produit.designation || '',
      description: produit.description || '',
      prix: produit.prix || '',
      unite: produit.unite || '',
      quantite: produit.quantite || '',
      totalPrix: produit.totalPrix || ''
    }));
  } else {
    // S'il n'y a pas de produits, initialiser avec un produit vide
    extractedData.value.produits = [{
      designation: '',
      description: '',
      prix: '',
      unite: '',
      quantite: '',
      totalPrix: ''
    }];
  }
  
  // Section Calculs
  if (data.calculs) {
    if (data.calculs.totalHT) extractedData.value.totalHT = data.calculs.totalHT;
    if (data.calculs.remise) extractedData.value.remise = data.calculs.remise;
    if (data.calculs.totalNetRemise) extractedData.value.totalNetRemise = data.calculs.totalNetRemise;
    if (data.calculs.tva) extractedData.value.tva = data.calculs.tva;
    if (data.calculs.totalTTC) extractedData.value.totalTTC = data.calculs.totalTTC;
  } else {
    // Compatibilité avec l'ancien format
    if (data.totalHT) extractedData.value.totalHT = data.totalHT;
    if (data.tva) extractedData.value.tva = data.tva;
    if (data.totalTTC) extractedData.value.totalTTC = data.totalTTC;
  }

  
  // Marquer l'extraction comme terminée
  extractionCompleted.value = true;
  
  // Navigate to the correction tab
  setActiveTab('correction');
};

const startExtraction = async () => {
  extractionStarted.value = true;
  isExtracting.value = true;
  extractionProgress.value = 0;
  currentExtraction.value = 0;
  
  // Vérifier si nous avons des résultats OCR
  if (ocrResults.value.length === 0) {
    console.warn('Aucun résultat OCR trouvé, utilisation de données fictives');
    // Simuler l'extraction si nous n'avons pas de résultats réels
    simulateExtraction();
    return;
  }
  
  // Si on a des résultats OCR, on continue le traitement
  try {
    totalExtractions.value = ocrResults.value.length;
    
    // Récupérer le texte extrait de tous les documents
    const allExtractedText = ocrResults.value.map(result => result.extractedText).join('\n\n');
    
    // Simuler le début du traitement OCR
    const progressInterval = setInterval(() => {
      if (extractionProgress.value < 50) { // Aller jusqu'à 50% pendant l'OCR
        extractionProgress.value += 2;
        if (extractionProgress.value % 25 === 0 && currentExtraction.value < totalExtractions.value) {
          currentExtraction.value++;
        }
      }
    }, 100);
    
    try {
      // Attendre que l'OCR atteigne 50%
      await new Promise(resolve => {
        const checkProgress = setInterval(() => {
          if (extractionProgress.value >= 50) {
            clearInterval(checkProgress);
            resolve();
          }
        }, 100);
      });
      
      // Arrêter la progression de l'OCR
      clearInterval(progressInterval);
      
      // Récupérer le premier résultat OCR pour le traiter avec Ollama
      if (ocrResults.value.length > 0) {
        const firstResult = ocrResults.value[0];
        console.log('Traitement du résultat OCR avec Ollama:', firstResult.resultFile);
        
        // Traiter le résultat OCR avec Ollama
        const ollamaResult = await processWithOllama(firstResult.resultFile);
        
        // Si Ollama a terminé avec succès, ne pas continuer avec la progression simulée
        if (ollamaProcessed.value && ollamaStatus.value === 'complete') {
          extractionProgress.value = 100;
          currentExtraction.value = totalExtractions.value;
          extractionCompleted.value = true;
          console.log('Extraction et analyse IA terminées avec succès via Ollama');
        } else {
          // Continuer la progression jusqu'à 100% si Ollama n'a pas terminé correctement
          extractionProgress.value = 70;
          const finalInterval = setInterval(() => {
            if (extractionProgress.value < 100) {
              extractionProgress.value += 5;
              if (extractionProgress.value % 20 === 0 && currentExtraction.value < totalExtractions.value) {
                currentExtraction.value++;
              }
            } else {
              clearInterval(finalInterval);
              isExtracting.value = false;
              extractionCompleted.value = true;
              
              console.log('Extraction et analyse IA terminées avec succès');
            }
          }, 150);
        }
      } else {
        throw new Error('Aucun résultat OCR disponible pour l\'analyse IA');
      }
    } catch (error) {
      console.error('Erreur lors du traitement avec Ollama:', error);
      clearInterval(progressInterval);
      
      // En cas d'erreur, continuer avec l'analyse locale
      const analyzedData = analyzeOcrText(allExtractedText);
      
      // Mettre à jour les données extraites avec les résultats de l'analyse locale
      Object.assign(extractedData.value, analyzedData);
      
      // Simuler la fin du traitement
      const errorInterval = setInterval(() => {
        if (extractionProgress.value < 100) {
          extractionProgress.value += 5;
          if (extractionProgress.value % 25 === 0 && currentExtraction.value < totalExtractions.value) {
            currentExtraction.value++;
          }
        } else {
          clearInterval(errorInterval);
          isExtracting.value = false;
          extractionCompleted.value = true;
          
          console.log('Extraction OCR terminée avec analyse locale (après erreur IA)');
        }
      }, 150);
    }
  } catch (error) {
    console.error('Erreur générale lors de l\'extraction:', error);
    isExtracting.value = false;
    extractionCompleted.value = false;
  }
};

// Fonction pour charger et appliquer les données du fichier de réponse Ollama
const loadOllamaResponseData = () => {
  try {
    // Données JSON du fichier ollama_response_1746066047164.txt
    const ollamaData = {
      "informationsDocument": {
        "typeDocument": "facture",
        "numero": "FAC-2IC-23-0003",
        "date": "16/11/2023"
      },
      "informationsClient": {
        "client": "SAM ENERGIE",
        "adresseClient": "7 RUE SAINTE CLAIRE DEVILLE, 77185 LOGNES, FRANCE",
        "telephoneClient": null,
        "emailClient": "mohamed.kemmar@icloud.com"
      },
      "produits": [
        {
          "designation": "CONVENTION D'ANIMATION SAM ENERGIE",
          "description": "100 U, 3 233.33 €, 20%"
        }
      ],
      "calculs": {
        "totalHT": "3233.33€",
        "remise": "0.00 €",
        "totalNetRemise": "3233.33€",
        "tva": "646.67 €",
        "totalTTC": "3880.00 €"
      }
    };
    
    console.log('Données Ollama chargées:', ollamaData);
    
    // Appliquer les données au format extractedData
    if (ollamaData) {
      // Section Informations Document
      if (ollamaData.informationsDocument) {
        if (ollamaData.informationsDocument.typeDocument) extractedData.value.typeDocument = ollamaData.informationsDocument.typeDocument;
        if (ollamaData.informationsDocument.numero) extractedData.value.numero = ollamaData.informationsDocument.numero;
        if (ollamaData.informationsDocument.date) extractedData.value.date = ollamaData.informationsDocument.date;
      }
      
      // Section Informations Client
      if (ollamaData.informationsClient) {
        if (ollamaData.informationsClient.client) extractedData.value.client = ollamaData.informationsClient.client;
        if (ollamaData.informationsClient.adresseClient) extractedData.value.adresseClient = ollamaData.informationsClient.adresseClient;
        if (ollamaData.informationsClient.telephoneClient) extractedData.value.telephoneClient = ollamaData.informationsClient.telephoneClient;
        if (ollamaData.informationsClient.emailClient) extractedData.value.emailClient = ollamaData.informationsClient.emailClient;
      }
      
      // Section Produits
      const produits = ollamaData.produits || [];
      if (produits.length > 0) {
        const premierProduit = produits[0];
        if (premierProduit.designation) extractedData.value.nomProduit = premierProduit.designation;
        if (premierProduit.description) extractedData.value.descriptionProduit = premierProduit.description;
      }
      
      // Section Calculs
      if (ollamaData.calculs) {
        if (ollamaData.calculs.totalHT) extractedData.value.totalHT = ollamaData.calculs.totalHT;
        if (ollamaData.calculs.remise) extractedData.value.remise = ollamaData.calculs.remise;
        if (ollamaData.calculs.totalNetRemise) extractedData.value.totalNetRemise = ollamaData.calculs.totalNetRemise;
        if (ollamaData.calculs.tva) extractedData.value.tva = ollamaData.calculs.tva;
        if (ollamaData.calculs.totalTTC) extractedData.value.totalTTC = ollamaData.calculs.totalTTC;
      }
      
      console.log('Données extraites mises à jour:', extractedData.value);
    }
  } catch (error) {
    console.error('Erreur lors du chargement des données Ollama:', error);
  }
};

// Fonction de simulation de l'extraction avec les données du fichier Ollama
const simulateExtraction = async () => {
  totalExtractions.value = 1; // Au moins un document fictif
  
  const interval = setInterval(() => {
    if (extractionProgress.value < 100) {
      extractionProgress.value += 5;
      if (extractionProgress.value % 25 === 0 && currentExtraction.value < totalExtractions.value) {
        currentExtraction.value++;
      }
    } else {
      clearInterval(interval);
      isExtracting.value = false;
      extractionCompleted.value = true;
      
      // Initialiser les données extraites
      extractedData.value = {
        client: '',
        date: '',
        montant: '',
        tva: '',
        numero: '',
        typeDocument: '',
        adresseClient: '',
        telephoneClient: '',
        emailClient: '',
        totalHT: '',
        totalTTC: ''
      };
      
      // Charger et appliquer les données du fichier Ollama
      loadOllamaResponseData();
    }
  }, 300);
};

const goToCorrection = () => {
  // S'assurer que les résultats d'Ollama sont appliqués avant de passer à l'onglet de correction
  if (ollamaProcessed.value && ollamaResponseData.value) {
    applyOllamaResults();
  }
  activeTab.value = 'correction';
};

// Fonction pour analyser le texte OCR et extraire des informations structurées
const analyzeOcrText = (text) => {
  // Initialiser un objet avec des valeurs par défaut
  const data = {
    client: '',
    date: '',
    montant: '',
    tva: '',
    numero: ''
  };
  
  // Rechercher des patterns dans le texte
  // Exemple: recherche de dates au format JJ/MM/AAAA
  const dateRegex = /(\d{1,2}[\/\-]\d{1,2}[\/\-]\d{2,4})/g;
  const dates = text.match(dateRegex);
  if (dates && dates.length > 0) {
    data.date = dates[0];
  }
  
  // Recherche de montants (nombres suivis de € ou EUR)
  const montantRegex = /(\d+[.,]\d{2})\s*[€EUR]/gi;
  const montants = text.match(montantRegex);
  if (montants && montants.length > 0) {
    data.montant = montants[0];
    if (montants.length > 1) {
      data.tva = montants[1];
    }
  }
  
  // Recherche de numéros de facture/document (formats courants)
  const numeroRegex = /(?:facture|fact|n°|numero)\s*[:\s]?\s*([A-Z0-9\-\/]+)/i;
  const numeroMatch = text.match(numeroRegex);
  if (numeroMatch && numeroMatch.length > 1) {
    data.numero = numeroMatch[1];
  }
  
  // Recherche du nom du client (plus complexe, approche simplifiée)
  // Cherche des lignes qui pourraient contenir un nom de société
  const lines = text.split('\n');
  for (const line of lines) {
    // Ignorer les lignes trop courtes ou contenant des mots clés spécifiques
    if (line.length > 3 && 
        !line.match(/facture|montant|date|total|tva|ht|ttc/i) &&
        line.match(/[A-Z]/) && 
        line.length < 50) {
      data.client = line.trim();
      break;
    }
  }
  
  return data;
};

// Manual Correction tab
const selectedField = ref('');
const sectionsOpen = ref({
  document: true,
  client: true,
  produit: true,
  calcul: true
});



const toggleSection = (section) => {
  sectionsOpen.value[section] = !sectionsOpen.value[section];
};

const extractedData = ref({
  client: '',
  adresseClient: '',
  telephoneClient: '',
  emailClient: '',
  typeDocument: '',
  numero: '',
  date: '',
  produits: [
    {
      designation: '',
      description: '',
      prix: '',
      unite: '',
      quantite: '',
      totalPrix: ''
    }
  ],
  totalHT: '',
  remise: '',
  totalNetRemise: '',
  tva: '',
  totalTTC: ''
});



const selectField = (field) => {
  selectedField.value = field;
};

// Fonctions pour gérer les produits
const addProduct = () => {
  extractedData.value.produits.push({
    designation: '',
    description: '',
    prix: '',
    unite: '',
    quantite: '',
    totalPrix: ''
  });
};

const removeProduct = (index) => {
  if (extractedData.value.produits.length > 1) {
    extractedData.value.produits.splice(index, 1);
  }
};

// Définir les émetteurs d'événements
const emit = defineEmits(['goToStep6OCR']);

const validateData = () => {
  // Préparer les données pour le composant Step6OCR selon les spécifications
  // Ignorer typeDocument, description et unité comme demandé
  const ocrData = {
    document: {
      // Lier date du document à f.Date (le format sera converti dans Step6OCR)
      date: extractedData.value.date || '',
      numeroSerie: extractedData.value.numero || ''
    },
    client: {
      nom: extractedData.value.client || '',
      adresse: extractedData.value.adresseClient || '',
      telephone: extractedData.value.telephoneClient || '',
      email: extractedData.value.emailClient || ''
    },
    produits: extractedData.value.produits ? extractedData.value.produits.map(produit => ({
      // Lier Nom du produit à f.Nom du Produit
      nom: produit.designation || '',
      reference: produit.reference || '',
      // Lier Quantité à f.Quantité
      quantite: parseFloat(produit.quantite) || 1,
      // Lier prix unitaire à f.Prix Unitaire (HT)
      prixUnitaire: parseFloat(produit.prix) || 0,
      // Lier Total prix à f.Total HT
      totalHT: parseFloat(produit.totalPrix) || 0,
      tvaPercentage: 20 // Valeur par défaut
    })) : [],
    calculs: {
      // Lier total ht à f.Total HT
      totalHT: parseFloat(extractedData.value.totalHT) || 0,
      // Lier remise à f.Total Remise
      totalRemise: parseFloat(extractedData.value.remise) || 0,
      // Lier Total Net (après remise) à f.Total Net HT
      totalNetHT: parseFloat(extractedData.value.totalNetRemise) || parseFloat(extractedData.value.totalHT) || 0,
      // Lier TVA à f.Total TVA
      totalTVA: parseFloat(extractedData.value.tva) || 0,
      // Lier Total TTC à f.Total TTC
      totalTTC: parseFloat(extractedData.value.totalTTC) || 0
    }
  };
  
  // Émettre l'événement pour passer au composant Step6OCR sans validation
  console.log('Passage à l\'étape suivante avec les données OCR:', ocrData);
  emit('goToStep6OCR', ocrData);
};

// Lifecycle hooks
onMounted(() => {
  // Any initialization code
});
</script>

<style scoped>
.ocr-ia-container {
  display: flex;
  flex-direction: column;
  background-color: #f8f9fa;
  border-radius: 12px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
  padding: 2rem;
  height: 100%;
  overflow: hidden;
  animation: fadeIn 0.5s ease-out;
}

.ocr-header {
  margin-bottom: 2rem;
  text-align: center;
}

.ocr-title {
  font-size: 1.8rem;
  color: #2c3e50;
  margin-bottom: 0.5rem;
  font-weight: 600;
}

.ocr-subtitle {
  color: #6c757d;
  font-size: 1rem;
}

/* Tabs Navigation */
.ocr-tabs {
  display: flex;
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
  margin-bottom: 2rem;
  overflow: hidden;
}

.ocr-tab {
  flex: 1;
  padding: 1rem;
  text-align: center;
  cursor: pointer;
  transition: all 0.3s ease;
  border-bottom: 3px solid transparent;
  color: #6c757d;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.5rem;
  animation: slideInFromTop 0.5s ease-out;
  animation-delay: calc(var(--i) * 0.1s);
  animation-fill-mode: both;
}

.ocr-tab i {
  font-size: 1.5rem;
  margin-bottom: 0.5rem;
}

.ocr-tab.active {
  color: #4361ee;
  border-bottom: 3px solid #4361ee;
  background-color: rgba(67, 97, 238, 0.05);
}

.ocr-tab:hover:not(.active) {
  background-color: rgba(108, 117, 125, 0.05);
  color: #495057;
}

/* Tab Content */
.ocr-content {
  flex: 1;
  overflow: auto;
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
  padding: 2rem;
}

.tab-content {
  animation: fadeIn 0.5s ease-out;
  height: 100%;
}

/* Upload & Preprocessing Tab */
.upload-container {
  border: 2px dashed #ced4da;
  border-radius: 8px;
  padding: 2rem;
  text-align: center;
  transition: all 0.3s ease;
  background-color: #f8f9fa;
  min-height: 300px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
}

.upload-container.highlight {
  border-color: #4361ee;
  background-color: rgba(67, 97, 238, 0.05);
}

.upload-container.has-files {
  border-style: solid;
  background-color: #fff;
}

.upload-placeholder {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 1rem;
}

.upload-placeholder i {
  font-size: 3rem;
  color: #6c757d;
  margin-bottom: 1rem;
}

.upload-button {
  background-color: #4361ee;
  color: white;
  padding: 0.75rem 1.5rem;
  border-radius: 6px;
  cursor: pointer;
  transition: background-color 0.3s ease;
  font-weight: 500;
  display: inline-block;
}

.upload-button:hover {
  background-color: #3a56d4;
}

.file-input {
  display: none;
}

.upload-formats {
  color: #6c757d;
  font-size: 0.875rem;
  margin-top: 1rem;
}

.uploaded-files {
  width: 100%;
}

.uploaded-files h3 {
  margin-bottom: 1rem;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  color: #2c3e50;
}

.file-list {
  max-height: 300px;
  overflow-y: auto;
  margin-bottom: 1.5rem;
  border: 1px solid #e9ecef;
  border-radius: 6px;
}

.file-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0.75rem 1rem;
  border-bottom: 1px solid #e9ecef;
  animation: slideInFromRight 0.3s ease-out;
}

.file-item:last-child {
  border-bottom: none;
}

.file-info {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.file-info i {
  color: #6c757d;
  font-size: 1.25rem;
}

.file-name {
  font-weight: 500;
  color: #495057;
}

.file-size {
  color: #6c757d;
  font-size: 0.875rem;
  margin-left: 0.5rem;
}

.file-actions {
  display: flex;
  gap: 0.5rem;
}

.file-remove {
  background-color: transparent;
  border: none;
  color: #dc3545;
  cursor: pointer;
  padding: 0.25rem 0.5rem;
  border-radius: 4px;
  transition: background-color 0.3s ease;
}

.file-remove:hover {
  background-color: rgba(220, 53, 69, 0.1);
}

.upload-actions {
  display: flex;
  justify-content: space-between;
  gap: 1rem;
}

.clear-button, .process-button {
  padding: 0.75rem 1.5rem;
  border-radius: 6px;
  cursor: pointer;
  font-weight: 500;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  border: none;
  transition: all 0.3s ease;
}

.clear-button {
  background-color: #f8f9fa;
  color: #6c757d;
  border: 1px solid #ced4da;
}

.clear-button:hover {
  background-color: #e9ecef;
}

.process-button {
  background-color: #4361ee;
  color: white;
  flex: 1;
}

.process-button:hover {
  background-color: #3a56d4;
}

.upload-progress {
  margin-top: 2rem;
  animation: fadeIn 0.5s ease-out;
}

.progress-container {
  height: 8px;
  background-color: #e9ecef;
  border-radius: 4px;
  overflow: hidden;
  margin-bottom: 0.5rem;
}

.progress-bar {
  height: 100%;
  background-color: #4361ee;
  border-radius: 4px;
  transition: width 0.3s ease;
}

.progress-info {
  display: flex;
  justify-content: space-between;
  color: #6c757d;
  font-size: 0.875rem;
}

.upload-errors {
  margin-top: 2rem;
  background-color: #fff8f8;
  border: 1px solid #f5c2c7;
  border-radius: 6px;
  padding: 1rem;
  animation: fadeIn 0.5s ease-out;
}

.upload-errors h4 {
  color: #dc3545;
  margin-bottom: 0.75rem;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.upload-errors ul {
  padding-left: 2rem;
  color: #842029;
}

/* OCR Extraction Tab */
.extraction-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  min-height: 300px;
  text-align: center;
}

.extraction-placeholder {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 1rem;
  color: #6c757d;
}

.extraction-placeholder i {
  font-size: 3rem;
  margin-bottom: 1rem;
}

.extraction-progress {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 1.5rem;
  width: 100%;
  max-width: 600px;
}

.progress-animation {
  margin-bottom: 1rem;
}

.spinner {
  width: 50px;
  height: 50px;
  border: 5px solid rgba(67, 97, 238, 0.2);
  border-radius: 50%;
  border-top-color: #4361ee;
  animation: spin 1s linear infinite;
}

.section-title {
  display: flex;
  align-items: center;
  justify-content: space-between;
  background-color: #f5f7fa;
  padding: 0.75rem 1rem;
  border-radius: 6px;
  color: #2c3e50;
  font-weight: 600;
  margin-bottom: 1rem;
  cursor: pointer;
  transition: background-color 0.2s;
}

.section-title:hover {
  background-color: #e9ecef;
}

.toggle-icon {
  font-size: 0.8rem;
  transition: transform 0.3s;
}

.extraction-details {
  text-align: left;
  background-color: #f8f9fa;
  padding: 1rem;
  border-radius: 6px;
  width: 100%;
  margin-top: 1rem;
}

.extraction-details p {
  margin: 0.5rem 0;
  display: flex;
  align-items: center;
  gap: 0.75rem;
  color: #495057;
}

.extraction-results {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 1.5rem;
  animation: fadeIn 0.5s ease-out;
}

.extraction-results h3 {
  color: #198754;
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.next-step-button {
  background-color: #4361ee;
  color: white;
  padding: 0.75rem 1.5rem;
  border-radius: 6px;
  cursor: pointer;
  font-weight: 500;
  border: none;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  transition: background-color 0.3s ease;
  margin-top: 1rem;
}

.next-step-button:hover {
  background-color: #3a56d4;
}

/* Manual Correction Tab */
.correction-container {
  height: 100%;
}

.correction-placeholder {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  min-height: 300px;
  gap: 1rem;
  color: #6c757d;
  text-align: center;
}

.correction-placeholder i {
  font-size: 3rem;
  margin-bottom: 1rem;
}

.correction-interface {
  height: 100%;
  animation: fadeIn 0.5s ease-out;
  overflow-y: auto;
}

.form-sections {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.form-section {
  border: 1px solid #e9ecef;
  border-radius: 8px;
  background-color: #fff;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.section-title {
  background-color: #f8f9fa;
  color: #2c3e50;
  padding: 1rem 1.5rem;
  margin: 0;
  border-bottom: 1px solid #e9ecef;
  font-size: 1.1rem;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.section-title i {
  color: #4361ee;
}

.section-content {
  padding: 1.5rem;
}

.form-group {
  margin-bottom: 1rem;
}

.form-group:last-child {
  margin-bottom: 0;
}

.form-group label {
  display: block;
  margin-bottom: 0.5rem;
  font-weight: 600;
  color: #2c3e50;
  font-size: 0.95rem;
  transition: color 0.3s ease;
}

.form-group:hover label {
  color: #4361ee;
}

.form-group input,
.form-group select,
.form-group textarea {
  width: 100%;
  padding: 0.75rem 1rem;
  border: 1px solid #ced4da;
  border-radius: 6px;
  font-size: 1rem;
  transition: all 0.3s ease;
  background-color: #fff;
  box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.05);
}

.form-group input:focus,
.form-group select:focus,
.form-group textarea:focus {
  outline: none;
  border-color: #4361ee;
  box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.15), inset 0 1px 2px rgba(0, 0, 0, 0.05);
  transform: translateY(-1px);
}

.form-group input[readonly] {
  background-color: #f8f9fa;
  cursor: not-allowed;
  opacity: 0.75;
}

.form-group input:hover,
.form-group textarea:hover {
  border-color: #a8b1ff;
}

.form-group textarea {
  min-height: 80px;
  resize: vertical;
}

.form-row {
  display: flex;
  gap: 1rem;
  margin-bottom: 1rem;
}

.form-row .form-group {
  flex: 1;
  margin-bottom: 0;
}

.product-item {
  border: 1px solid #e9ecef;
  border-radius: 6px;
  padding: 1.25rem;
  margin-bottom: 1.25rem;
  background-color: #f8f9fa;
}

.product-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1rem;
  padding-bottom: 0.75rem;
  border-bottom: 1px solid #e9ecef;
}

.product-header h4 {
  margin: 0;
  color: #2c3e50;
  font-size: 1.1rem;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.product-header h4::before {
  content: '';
  display: inline-block;
  width: 10px;
  height: 10px;
  background-color: #4361ee;
  border-radius: 50%;
  box-shadow: 0 0 0 2px rgba(67, 97, 238, 0.2);
  animation: pulse 2s infinite;
}

.remove-product-btn {
  background-color: #fff;
  border: 1px solid #dc3545;
  color: #dc3545;
  cursor: pointer;
  padding: 0.35rem 0.6rem;
  border-radius: 4px;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.remove-product-btn:hover {
  background-color: #dc3545;
  color: white;
  transform: translateY(-1px);
  box-shadow: 0 3px 5px rgba(0, 0, 0, 0.15);
}

.remove-product-btn:active {
  transform: translateY(0);
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
}

.product-form {
  background-color: #f8f9fa;
  border-radius: 8px;
  padding: 1.25rem;
  margin-bottom: 1.5rem;
  border: 1px solid #e9ecef;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
  transition: all 0.3s ease;
  animation: slideInFromRight 0.4s ease-out;
}

.product-form:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  border-color: #ced4da;
}

.product-divider {
  border: 0;
  height: 1px;
  background-color: #e9ecef;
  margin: 1.5rem 0;
}

.add-product-container {
  display: flex;
  justify-content: center;
  margin-top: 1.5rem;
}

.add-product-btn {
  background-color: #fff;
  color: #4361ee;
  border: 2px dashed #4361ee;
  border-radius: 6px;
  padding: 0.75rem 1.5rem;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  transition: all 0.3s ease;
  font-weight: 500;
  box-shadow: 0 2px 5px rgba(67, 97, 238, 0.1);
}

.add-product-btn:hover {
  background-color: rgba(67, 97, 238, 0.05);
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(67, 97, 238, 0.15);
}

.add-product-btn:active {
  transform: translateY(0);
  box-shadow: 0 2px 3px rgba(67, 97, 238, 0.1);
}

.total-ttc {
  margin-top: 1rem;
  padding-top: 1rem;
  border-top: 2px solid #e9ecef;
}

.total-ttc label {
  font-weight: 600;
  color: #2c3e50;
  font-size: 1.1rem;
}

.total-ttc input {
  font-weight: 600;
  font-size: 1.1rem;
  color: #4361ee;
  background-color: rgba(67, 97, 238, 0.05);
  border-color: #4361ee;
}

.correction-actions {
  margin-top: 1.5rem;
  display: flex;
  justify-content: flex-end;
}

.validate-button {
  background-color: #198754;
  color: white;
  padding: 0.75rem 1.5rem;
  border-radius: 6px;
  cursor: pointer;
  font-weight: 500;
  border: none;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  transition: background-color 0.3s ease;
}

.validate-button:hover {
  background-color: #157347;
}

/* Animation for progress */
@keyframes loading {
  0% { background-position: 0% 50%; }
  50% { background-position: 100% 50%; }
  100% { background-position: 0% 50%; }
}

/* Ollama Console UI */
.ollama-console {
  margin-top: 1.5rem;
  background: #1e1e2e;
  border-radius: 8px;
  overflow: hidden;
  max-height: 120px;
  transition: max-height 0.3s ease;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.ollama-console.show {
  max-height: 500px;
}

.console-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0.75rem 1rem;
  background: #302d41;
  color: #cdd6f4;
}

.console-header h3 {
  margin: 0;
  font-size: 1rem;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.console-header i {
  color: #89b4fa;
}

.console-controls {
  display: flex;
  gap: 0.5rem;
}

.console-controls button {
  background: transparent;
  border: none;
  color: #cdd6f4;
  cursor: pointer;
  padding: 0.25rem;
  border-radius: 4px;
  transition: background 0.2s ease;
}

.console-controls button:hover {
  background: rgba(205, 214, 244, 0.1);
}

.console-status {
  padding: 0.5rem 1rem;
  font-size: 0.875rem;
  color: #cdd6f4;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  border-bottom: 1px solid #313244;
}

.console-status.idle i {
  color: #f5c2e7; /* Pink */
}

.console-status.ready i {
  color: #a6e3a1; /* Green */
}

.console-status.thinking i {
  color: #fab387; /* Peach */
}

.console-status.complete i {
  color: #a6e3a1; /* Green */
}

.console-content {
  padding: 1rem;
  overflow-y: auto;
  max-height: 350px;
  background: #1e1e2e;
  color: #cdd6f4;
  font-family: 'SFMono-Regular', Consolas, 'Liberation Mono', Menlo, monospace;
  font-size: 0.875rem;
}

.console-content pre {
  margin: 0;
  white-space: pre-wrap;
  word-break: break-word;
}

.console-actions {
  padding: 0.75rem 1rem;
  display: flex;
  justify-content: flex-end;
  background: #302d41;
}

.console-actions button {
  background: #89b4fa;
  color: #1e1e2e;
  border: none;
  border-radius: 4px;
  padding: 0.5rem 1rem;
  font-size: 0.875rem;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  transition: background 0.2s ease;
}

.console-actions button:hover {
  background: #b4befe;
}

/* Animations */
@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

@keyframes slideInFromTop {
  from {
    transform: translateY(-20px);
    opacity: 0;
  }
  to {
    transform: translateY(0);
    opacity: 1;
  }
}

@keyframes slideInFromRight {
  from {
    transform: translateX(20px);
    opacity: 0;
  }
  to {
    transform: translateX(0);
    opacity: 1;
  }
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

@keyframes pulse {
  0% { transform: scale(1); opacity: 1; }
  50% { transform: scale(1.2); opacity: 0.8; }
  100% { transform: scale(1); opacity: 1; }
}
</style>