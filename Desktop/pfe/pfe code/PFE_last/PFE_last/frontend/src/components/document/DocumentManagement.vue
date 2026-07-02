<template>
  <div class="document-management">

    <!-- Barre de recherche et filtres -->
    <div class="search-filter-container">
      <div class="search-bar">
        <div class="search-input-container">
          <i class="fas fa-search search-icon"></i>
          <input 
            type="text" 
            v-model="searchQuery" 
            :placeholder="`Rechercher un ${activeTab === 'factures' ? 'facture' : 'devis'}...`" 
            class="search-input"
            @input="applyFilters"
          />
          <button v-if="searchQuery" @click="clearSearch" class="clear-search">
            <i class="fas fa-times"></i>
          </button>
        </div>
        <button @click="toggleAdvancedSearch" class="advanced-search-toggle">
          <i :class="showAdvancedSearch ? 'fas fa-chevron-up' : 'fas fa-chevron-down'"></i>
          Recherche avancée
        </button>
      </div>

      <!-- Filtres rapides -->
      <div class="quick-filters">
        <button 
          v-for="filter in quickFilters" 
          :key="filter.value" 
          @click="setStatusFilter(filter.value)" 
          :class="['filter-btn', { active: currentStatusFilter === filter.value }]"
        >
          {{ filter.label }}
        </button>
      </div>

      <!-- Recherche avancée (collapsible) -->
      <div class="advanced-search" v-if="showAdvancedSearch">
        <div class="filter-row">
          <div class="filter-group">
            <label>Statut</label>
            <select v-model="filters.status" @change="applyFilters">
              <option value="">Tous les statuts</option>
              <template v-if="activeTab === 'factures'">
                <option value="Non envoyée">Non envoyée</option>
                <option value="En retard">En retard</option>
                <option value="Non payée">Non payée</option>
                <option value="Payée">Payée</option>
              </template>
              <template v-else>
                <option value="Envoyée">Envoyée</option>
                <option value="Annulée">Annulée</option>
                <option value="Non envoyée">Non envoyée</option>
                <option value="Acceptée">Acceptée</option>
              </template>
            </select>
          </div>
          
          <div class="filter-group">
            <label>Date de début</label>
            <input type="date" v-model="filters.dateFrom" @change="applyFilters" />
          </div>
          
          <div class="filter-group">
            <label>Date de fin</label>
            <input type="date" v-model="filters.dateTo" @change="applyFilters" />
          </div>
          
          <div class="filter-group">
            <label>Montant min</label>
            <input type="number" v-model="filters.amountMin" placeholder="0" @input="applyFilters" />
          </div>
          
          <div class="filter-group">
            <label>Montant max</label>
            <input type="number" v-model="filters.amountMax" placeholder="5000" @input="applyFilters" />
          </div>
        </div>
        
        <div class="filter-actions">
          <button @click="resetFilters" class="reset-btn">
            <i class="fas fa-undo"></i> Réinitialiser
          </button>
          <button @click="applyFilters" class="apply-btn">
            <i class="fas fa-check"></i> Appliquer
          </button>
        </div>
      </div>
    </div>

    <!-- Liste des documents -->
    <div class="documents-container">
      <!-- Barre d'actions -->
      <div class="action-bar">
        <div class="view-options">
          <button @click="viewMode = 'list'" :class="['view-btn', { active: viewMode === 'list' }]">
            <i class="fas fa-list"></i>
          </button>
          <button @click="viewMode = 'grid'" :class="['view-btn', { active: viewMode === 'grid' }]">
            <i class="fas fa-th-large"></i>
          </button>
        </div>
        
        <div class="sort-options">
          <label>Trier par:</label>
          <select v-model="sortOption" @change="applyFilters">
            <option value="date-desc">Date (récent)</option>
            <option value="date-asc">Date (ancien)</option>
            <option value="amount-desc">Montant (élevé)</option>
            <option value="amount-asc">Montant (faible)</option>
            <option value="name-asc">Nom (A-Z)</option>
            <option value="name-desc">Nom (Z-A)</option>
          </select>
        </div>
      </div>

      <!-- Affichage en mode liste -->
      <div v-if="viewMode === 'list' && !loading" class="documents-list">
        <table class="documents-table">
          <thead>
            <tr>
              <th @click="sortBy('name')">Numéro <i class="fas fa-sort"></i></th>
              <th @click="sortBy('client')">Client <i class="fas fa-sort"></i></th>
              <th @click="sortBy('date')">Date <i class="fas fa-sort"></i></th>
              <th @click="sortBy('amount')">Montant <i class="fas fa-sort"></i></th>
              <th @click="sortBy('status')">Statut <i class="fas fa-sort"></i></th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="doc in documents" :key="doc.id" @click="openDocumentPreview(doc)" class="document-row">
              <td>{{ doc.name }}</td>
              <td>{{ doc.client.name }}</td>
              <td>{{ formatDate(doc.date) }}</td>
              <td>{{ formatAmount(doc.amount) }}</td>
              <td>
                <span :class="['status-badge', doc.status]">
                  {{ getStatusLabel(doc.status) }}
                </span>
              </td>
              <td class="actions-cell">
                <button @click.stop="openDocumentPreview(doc)" class="action-btn preview-btn" title="Aperçu">
                  <i class="fas fa-eye"></i>
                </button>
                <button @click.stop="downloadDocument(doc)" class="action-btn download-btn" title="Télécharger">
                  <i class="fas fa-download"></i>
                </button>
                <button @click.stop="openEmailForm(doc)" class="action-btn email-btn" title="Envoyer par email">
                  <i class="fas fa-envelope"></i>
                </button>
                <button @click.stop="deleteDocument(doc)" class="action-btn delete-btn" title="Supprimer">
                  <i class="fas fa-trash"></i>
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- Affichage en mode grille -->
      <div v-else-if="viewMode === 'grid' && !loading" class="documents-grid">
        <div v-for="doc in documents" :key="doc.id" class="document-card" @click="openDocumentPreview(doc)">
          <div class="document-card-header">
            <span :class="['status-indicator', doc.status]"></span>
            <span class="document-type">
              <i :class="activeTab === 'factures' ? 'fas fa-file-invoice-dollar' : 'fas fa-file-contract'"></i>
            </span>
          </div>
          <div class="document-card-body">
            <h3 class="document-name">{{ doc.name }}</h3>
            <p class="document-client">{{ doc.client.name }}</p>
            <p class="document-date">{{ formatDate(doc.date) }}</p>
            <p class="document-amount">{{ formatAmount(doc.amount) }}</p>
            <span :class="['status-badge', doc.status]">
              {{ getStatusLabel(doc.status) }}
            </span>
          </div>
          <div class="document-card-actions">
            <button @click.stop="openDocumentPreview(doc)" class="action-btn preview-btn" title="Aperçu">
              <i class="fas fa-eye"></i>
            </button>
            <button @click.stop="downloadDocument(doc)" class="action-btn download-btn" title="Télécharger">
              <i class="fas fa-download"></i>
            </button>
            <button @click.stop="openEmailForm(doc)" class="action-btn email-btn" title="Envoyer par email">
              <i class="fas fa-envelope"></i>
            </button>
            <button @click.stop="deleteDocument(doc)" class="action-btn delete-btn" title="Supprimer">
              <i class="fas fa-trash"></i>
            </button>
          </div>
        </div>
      </div>

      <!-- État de chargement -->
      <div v-if="loading" class="loading-state">
        <div class="spinner"></div>
        <p>Chargement des documents...</p>
      </div>

      <!-- État vide -->
      <div v-if="!loading && documents.length === 0" class="empty-state">
        <i class="fas fa-folder-open empty-icon"></i>
        <h3>Aucun document trouvé</h3>
        <p>Aucun {{ activeTab === 'factures' ? 'facture' : 'devis' }} ne correspond à vos critères de recherche.</p>
        <button @click="resetFilters" class="reset-btn">
          <i class="fas fa-undo"></i> Réinitialiser les filtres
        </button>
      </div>

      <!-- Pagination -->
      <div v-if="!loading && documents.length > 0" class="pagination">
        <button 
          @click="prevPage" 
          :disabled="currentPage === 1" 
          class="pagination-btn prev-btn"
        >
          <i class="fas fa-chevron-left"></i> Précédent
        </button>
        
        <div class="pagination-info">
          Page {{ currentPage }} sur {{ totalPages }}
        </div>
        
        <button 
          @click="nextPage" 
          :disabled="currentPage === totalPages" 
          class="pagination-btn next-btn"
        >
          Suivant <i class="fas fa-chevron-right"></i>
        </button>
      </div>
    </div>

    <!-- Modal d'aperçu du document -->
    <div v-if="showPreviewModal" class="modal-overlay" @click.self="closePreviewModal">
      <div class="preview-modal">
        <div class="modal-header">
          <h3>{{ selectedDocument ? selectedDocument.name : '' }}</h3>
          <button @click="closePreviewModal" class="close-btn">
            <i class="fas fa-times"></i>
          </button>
        </div>
        
        <div class="modal-body">
          <div class="document-preview">
            <!-- Affichage PDF avec le service de visualisation -->
            <div class="pdf-preview" :style="{ transform: `scale(${zoomLevel})` }">
              <iframe 
                :src="previewUrl" 
                class="pdf-iframe" 
                width="100%" 
                height="100%"
                frameborder="0"
                allowfullscreen
                sandbox="allow-scripts allow-same-origin allow-forms"
              ></iframe>
            </div>
            
            <!-- Informations du document -->
            <div class="document-info">
              <div class="info-section">
                <h4>Informations générales</h4>
                <div class="info-grid">
                  <div class="info-item">
                    <span class="info-label">Numéro:</span>
                    <span class="info-value">{{ selectedDocument ? selectedDocument.name : '' }}</span>
                  </div>
                  <div class="info-item">
                    <span class="info-label">Date:</span>
                    <span class="info-value">{{ selectedDocument ? formatDate(selectedDocument.date) : '' }}</span>
                  </div>
                  <div class="info-item">
                    <span class="info-label">Statut:</span>
                    <span v-if="selectedDocument" :class="['status-badge', selectedDocument.status]">
                      {{ selectedDocument ? getStatusLabel(selectedDocument.status) : '' }}
                    </span>
                  </div>
                  <div class="info-item">
                    <span class="info-label">Montant:</span>
                    <span class="info-value">{{ selectedDocument ? formatAmount(selectedDocument.amount) : '' }}</span>
                  </div>
                </div>
              </div>
              
              <div class="info-section">
                <h4>Client</h4>
                <div class="info-grid">
                  <div class="info-item">
                    <span class="info-label">Nom:</span>
                    <span class="info-value">{{ selectedDocument ? selectedDocument.client.name : '' }}</span>
                  </div>
                  <!-- Autres informations client (à compléter) -->
                </div>
              </div>
            </div>
          </div>
        </div>
        
        <div class="modal-footer">
          <div class="preview-toolbar">
            <div class="zoom-controls">
              <button @click="zoomOut" class="zoom-button" :disabled="zoomLevel <= 0.5" title="Réduire">
                <i class="fas fa-search-minus"></i>
              </button>
              <span class="zoom-level">{{ Math.round(zoomLevel * 100) }}%</span>
              <button @click="zoomIn" class="zoom-button" :disabled="zoomLevel >= 2" title="Agrandir">
                <i class="fas fa-search-plus"></i>
              </button>
            </div>
            <div class="page-controls">
              <button @click="prevPreviewPage" class="page-button" :disabled="previewCurrentPage <= 1" title="Page précédente">
                <i class="fas fa-chevron-left"></i>
              </button>
              <span class="page-info">{{ previewCurrentPage }} / {{ previewTotalPages }}</span>
              <button @click="nextPreviewPage" class="page-button" :disabled="previewCurrentPage >= previewTotalPages" title="Page suivante">
                <i class="fas fa-chevron-right"></i>
              </button>
            </div>
          </div>
          <div class="action-buttons">
            <button @click="downloadDocument(selectedDocument)" class="action-btn download-btn">
              <i class="fas fa-download"></i> Télécharger
            </button>
            <button @click="openEmailForm(selectedDocument)" class="action-btn email-btn">
              <i class="fas fa-envelope"></i> Envoyer par email
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Modal d'envoi par email -->
    <div v-if="showEmailModal" class="modal-overlay" @click.self="closeEmailModal">
      <div class="email-modal">
        <div class="modal-header">
          <h3>Envoyer par email</h3>
          <button @click="closeEmailModal" class="close-btn">
            <i class="fas fa-times"></i>
          </button>
        </div>
        
        <div class="modal-body">
          <form @submit.prevent="sendEmail" class="email-form">
            <div class="form-group">
              <label for="email-to">Destinataire</label>
              <input 
                type="email" 
                id="email-to" 
                v-model="emailForm.to" 
                placeholder="email@exemple.com" 
                required
              />
            </div>
            
            <div class="form-group">
              <label for="email-subject">Objet</label>
              <input 
                type="text" 
                id="email-subject" 
                v-model="emailForm.subject" 
                :placeholder="`${activeTab === 'factures' ? 'Facture' : 'Devis'} ${selectedDocument ? selectedDocument.name : ''}`" 
                required
              />
            </div>
            
            <div class="form-group">
              <label for="email-message">Message</label>
              <textarea 
                id="email-message" 
                v-model="emailForm.message" 
                :placeholder="`Veuillez trouver ci-joint ${activeTab === 'factures' ? 'la facture' : 'le devis'} ${selectedDocument ? selectedDocument.name : ''}.`" 
                rows="5" 
                required
              ></textarea>
            </div>
            
            <div class="form-group checkbox-group">
              <input type="checkbox" id="attach-pdf" v-model="emailForm.attachPdf" checked />
              <label for="attach-pdf">Joindre le document en PDF</label>
            </div>
          </form>
        </div>
        
        <div class="modal-footer">
          <button @click="closeEmailModal" class="cancel-btn">
            <i class="fas fa-times"></i> Annuler
          </button>
          <button @click="sendEmail" class="send-btn" :disabled="sending">
            <i class="fas fa-paper-plane"></i> {{ sending ? 'Envoi en cours...' : 'Envoyer' }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue';
import documentService from '@/services/documentService';
import remplissageService from '@/services/remplissageService';
import emailService from '@/services/emailService';
import pdfViewerService from '@/services/pdfViewerService';
import api from '@/services/api';

// Props pour définir l'onglet initial (factures ou devis)
const props = defineProps({
  initialTab: {
    type: String,
    default: 'factures',
    validator: (value) => ['factures', 'devis'].includes(value)
  }
});

// État de l'interface
const activeTab = ref(props.initialTab);
const loading = ref(true);
const documents = ref([]);
const searchQuery = ref('');
const showAdvancedSearch = ref(false);
const currentStatusFilter = ref('all');
const viewMode = ref('list');
const sortOption = ref('date-desc');
const currentPage = ref(1);
const itemsPerPage = ref(10);
const totalItems = ref(0);
const totalPages = computed(() => Math.ceil(totalItems.value / itemsPerPage.value));

// Filtres
const filters = ref({
  type: '',
  status: '',
  dateFrom: '',
  dateTo: '',
  amountMin: '',
  amountMax: '',
  search: ''
});

// Filtres rapides - différents selon le type de document
const quickFilters = computed(() => {
  if (activeTab.value === 'factures') {
    return [
      { label: 'Tous', value: 'all' },
      { label: 'En retard', value: 'En retard' },
      { label: 'Non payés', value: 'Non payée' },
      { label: 'Payés', value: 'Payée' }
    ];
  } else { // devis
    return [
      { label: 'Tous', value: 'all' },
      { label: 'Envoyés', value: 'Envoyée' },
      { label: 'Acceptés', value: 'Acceptée' },
      { label: 'Annulés', value: 'Annulée' }
    ];
  }
});

// Modal d'aperçu
const showPreviewModal = ref(false);
const selectedDocument = ref(null);
const previewUrl = ref('');
const pdfLoading = ref(false);
const pdfLoadError = ref(false);
const pdfErrorMessage = ref('');
const previewCurrentPage = ref(1);
const previewTotalPages = ref(1);
const zoomLevel = ref(1);

// Modal d'envoi par email
const showEmailModal = ref(false);
const sending = ref(false);
const emailForm = ref({
  to: '',
  subject: '',
  message: '',
  attachPdf: true
});

// Charger les documents
const loadDocuments = async () => {
  loading.value = true;
  try {
    console.log('Début du chargement des documents, type:', activeTab.value);
    
    // Préparation des filtres pour l'API
    const apiFilters = {
      search: searchQuery.value,
      date_from: filters.value.dateFrom,
      date_to: filters.value.dateTo,
      montant_min: filters.value.amountMin,
      montant_max: filters.value.amountMax,
      status: filters.value.status
    };
    
    console.log('Filtres appliqués:', apiFilters);
    let response;
    
    // Appel au service remplissageService pour récupérer les documents
    if (activeTab.value === 'factures') {
      console.log('Appel API pour récupérer les factures...');
      response = await remplissageService.getFactures(apiFilters);
      console.log('Données factures reçues:', response);
console.log('Données devis reçues:', response);
    } else {
      console.log('Appel API pour récupérer les devis...');
      response = await remplissageService.getDevis(apiFilters);
      console.log('Données devis reçues:', response);
    }
    
    if (response && response.success && response.data) {
      console.log('Nombre de documents reçus:', response.data.length);
      
      // Transformation des données pour correspondre au format attendu par le composant
      allDocumentsData.value = response.data.map(item => {
        console.log('Item traité:', item);
        // Vérifier si paymentDeadline existe et est valide
        const hasValidDeadline = item.paymentDeadline && item.paymentDeadline !== '0000-00-00' && item.paymentDeadline !== 'null';
        
        return {
          id: item.id,
          name: item.name || item.reference || `${activeTab.value === 'factures' ? 'FACT' : 'DEVIS'}-${item.id}`, // Utiliser serie_number s'il existe, sinon utiliser la référence formatée
          type: activeTab.value === 'factures' ? 'invoice' : 'quote',
          date: item.date || item.created_at, // Correspond à created_at dans la table remplissage
          client: {
            name: item.client || `Client ${item.client_id}`, // Format: nom + prénom du client
            id: item.client_id
          },
          company: item.company || item.nom_entreprise, // Correspond à nom_entreprise
          amount: item.amount || item.montant_ttc, // Correspond à montant_ttc
          status: item.status, // Statut provenant directement de la table document
          paymentDeadline: hasValidDeadline ? item.paymentDeadline : null, // Délai de paiement pour les factures
          // Conversion du statut anglais en français pour l'affichage si nécessaire
          pdfUrl: documentService.getPdfUrl({
            id: item.id,
            type: activeTab.value === 'factures' ? 'invoice' : 'quote'
          })
        };
      });
      
      totalItems.value = allDocumentsData.value.length;
      console.log('Documents transformés:', allDocumentsData.value);
      
      // Appliquer le tri
      applySorting();
      
      // Appliquer la pagination
      applyPagination();
    } else {
      console.error('Réponse invalide:', response);
      allDocumentsData.value = [];
      documents.value = [];
      totalItems.value = 0;
      console.log('Aucune donnée reçue ou erreur dans la réponse');
    }
  } catch (error) {
    console.error('Erreur lors du chargement des documents:', error);
    // Gérer l'erreur (afficher un message, etc.)
    allDocumentsData.value = [];
    documents.value = [];
    totalItems.value = 0;
  } finally {
    loading.value = false;
  }
};

// Appliquer les filtres
const applyFilters = () => {
  filters.value.search = searchQuery.value;
  currentPage.value = 1; // Réinitialiser la pagination
  loadDocuments();
};

// Réinitialiser les filtres
const resetFilters = () => {
  searchQuery.value = '';
  currentStatusFilter.value = 'all';
  filters.value = {
    type: activeTab.value === 'factures' ? 'invoice' : 'quote',
    status: '',
    dateFrom: '',
    dateTo: '',
    amountMin: '',
    amountMax: '',
    search: ''
  };
  applyFilters();
};

// Définir le filtre de statut
const setStatusFilter = (status) => {
  currentStatusFilter.value = status;
  filters.value.status = status === 'all' ? '' : status;
  applyFilters();
};

// Effacer la recherche
const clearSearch = () => {
  searchQuery.value = '';
  applyFilters();
};

// Basculer l'affichage de la recherche avancée
const toggleAdvancedSearch = () => {
  showAdvancedSearch.value = !showAdvancedSearch.value;
};

// Trier les documents
const sortBy = (field) => {
  const currentSort = sortOption.value.split('-');
  const currentField = currentSort[0];
  const currentDirection = currentSort[1];
  
  let newDirection = 'asc';
  if (field === currentField) {
    newDirection = currentDirection === 'asc' ? 'desc' : 'asc';
  }
  
  sortOption.value = `${field}-${newDirection}`;
  applySorting();
};

// Appliquer le tri
const applySorting = () => {
  const [field, direction] = sortOption.value.split('-');
  
  allDocumentsData.value.sort((a, b) => {
    let valueA, valueB;
    
    // Déterminer les valeurs à comparer
    switch (field) {
      case 'name':
        valueA = a.name;
        valueB = b.name;
        break;
      case 'client':
        valueA = a.client.name;
        valueB = b.client.name;
        break;
      case 'date':
        valueA = new Date(a.date);
        valueB = new Date(b.date);
        break;
      case 'amount':
        valueA = parseFloat(a.amount) || 0;
        valueB = parseFloat(b.amount) || 0;
        break;
      case 'status':
        valueA = a.status;
        valueB = b.status;
        break;
      case 'paymentDeadline':
        // Gestion du tri par délai de paiement
        valueA = a.paymentDeadline ? new Date(a.paymentDeadline) : new Date(8640000000000000); // Date max si pas de délai
        valueB = b.paymentDeadline ? new Date(b.paymentDeadline) : new Date(8640000000000000);
        break;
      default:
        valueA = a.date;
        valueB = b.date;
    }
    
    // Comparer les valeurs
    if (valueA < valueB) return direction === 'asc' ? -1 : 1;
    if (valueA > valueB) return direction === 'asc' ? 1 : -1;
    return 0;
  });
  
  applyPagination();
};

// Appliquer la pagination
const allDocumentsData = ref([]);
const applyPagination = () => {
  const start = (currentPage.value - 1) * itemsPerPage.value;
  const end = start + itemsPerPage.value;
  
  // Filtrer les documents pour la page actuelle
  documents.value = allDocumentsData.value.slice(start, end);
};

// Navigation de pagination
const nextPage = () => {
  if (currentPage.value < totalPages.value) {
    currentPage.value++;
    applyPagination();
  }
};

const prevPage = () => {
  if (currentPage.value > 1) {
    currentPage.value--;
    applyPagination();
  }
};

// Ouvrir l'aperçu du document
const openDocumentPreview = async (doc) => {
  try {
    console.log('Ouverture de l\'aperçu pour le document:', doc);
    selectedDocument.value = doc;
    pdfLoading.value = true;
    
    // Vérifier si le document est valide
    if (!doc || !doc.id) {
      console.error('Document invalide pour l\'aperçu');
      window.$notification.error('Erreur d\'aperçu : Impossible d\'afficher l\'aperçu: document invalide');
      pdfLoading.value = false;
      return;
    }
    
    // Récupérer les informations du document en utilisant le remplissage_id
    console.log(`Récupération du document avec remplissage_id: ${doc.id}`);
    const response = await documentService.getDocumentById(doc.id);
    
    if (!response.data || !response.data.success || !response.data.document) {
      throw new Error(`Document avec le remplissage_id ${doc.id} non trouvé`);
    }
    
    const document = response.data.document;
    console.log('Document récupéré:', document);
    
    // Initialiser les valeurs de pagination
    previewCurrentPage.value = 1;
    previewTotalPages.value = 1; // Sera mis à jour si disponible
    
    // Utiliser le service documentService pour générer l'URL de visualisation
    // Cette URL pointe directement vers le fichier PDF stocké en utilisant l'ID du document (pas le remplissage_id)
    const viewUrl = await documentService.getPdfViewUrl(document.id);
    
    // Utiliser le service de visualisation PDF pour générer une URL optimisée
    // qui affichera correctement le PDF dans l'iframe
    previewUrl.value = pdfViewerService.getOptimalViewerUrl(viewUrl);
    
    console.log(`URL de prévisualisation générée: ${previewUrl.value}`);
    
    // Afficher la modale
    showPreviewModal.value = true;
    pdfLoading.value = false;
  } catch (error) {
    console.error('Erreur lors de l\'ouverture de l\'aperçu:', error);
    window.$notification.error(`Erreur d'aperçu : Erreur lors de l'affichage de l'aperçu: ${error.message || 'Une erreur est survenue'}`);
    pdfLoading.value = false;
  }
};

// Fermer l'aperçu du document
const closePreviewModal = () => {
  showPreviewModal.value = false;
  selectedDocument.value = null;
  previewUrl.value = '';
  previewCurrentPage.value = 1;
  zoomLevel.value = 1;
};

// Contrôles de zoom pour la prévisualisation
const zoomIn = () => {
  if (zoomLevel.value < 2) {
    zoomLevel.value += 0.1;
  }
};

const zoomOut = () => {
  if (zoomLevel.value > 0.5) {
    zoomLevel.value -= 0.1;
  }
};

// Navigation entre les pages du PDF
const nextPreviewPage = () => {
  if (previewCurrentPage.value < previewTotalPages.value) {
    previewCurrentPage.value++;
  }
};

const prevPreviewPage = () => {
  if (previewCurrentPage.value > 1) {
    previewCurrentPage.value--;
  }
};

// Télécharger le document
const downloadDocument = async (doc) => {
  try {
    // Vérifier si le document a un ID valide
    if (!doc || !doc.id) {
      console.error('Document invalide ou sans ID');
      window.$notification.error('Erreur de téléchargement : Impossible de télécharger le document: ID manquant');
      return;
    }
    
    // Afficher un message de chargement
    console.log(`Téléchargement du document avec remplissage_id: ${doc.id} en cours...`);
    
    try {
      // Récupérer d'abord le document depuis la table document en utilisant le remplissage_id
      console.log(`Récupération du document avec remplissage_id: ${doc.id}`);
      const response = await documentService.getDocumentById(doc.id);
      
      if (!response.data || !response.data.success || !response.data.document) {
        throw new Error(`Document avec le remplissage_id ${doc.id} non trouvé`);
      }
      
      const document = response.data.document;
      console.log('Document récupéré pour téléchargement:', document);
      
      // Utiliser l'ID du document (pas le remplissage_id) pour le téléchargement
      await documentService.downloadDocument(document.id);
      
      console.log(`Téléchargement du document ${document.id} terminé`);
    } catch (error) {
      console.error(`Erreur lors de la récupération ou du téléchargement du document:`, error);
      window.$notification.error(`Erreur de téléchargement : ${error.message || 'Une erreur est survenue'}`);
    }
  } catch (error) {
    console.error(`Erreur lors du téléchargement du document:`, error);
    window.$notification.error(`Erreur de téléchargement : ${error.message || 'Une erreur est survenue'}`);
  }
};

// Ouvrir le formulaire d'envoi par email
const openEmailForm = (doc) => {
  selectedDocument.value = doc;
  
  // Préremplir le formulaire avec un message plus professionnel
  const isFacture = activeTab.value === 'factures';
  const docType = isFacture ? 'facture' : 'devis';
  const docName = doc.name;
  const montant = doc.amount ? formatAmount(doc.amount) : '';
  const dateDoc = doc.date ? formatDate(doc.date) : '';
  
  // Message plus détaillé et professionnel
  let defaultMessage = '';
  
  if (isFacture) {
    defaultMessage = `Bonjour,

Veuillez trouver ci-joint votre facture ${docName} d'un montant de ${montant} datée du ${dateDoc}.

Cette facture est disponible en format PDF dans les pièces jointes de cet email.

Pour toute question concernant cette facture, n'hésitez pas à nous contacter.

Nous vous remercions de votre confiance.

Cordialement,
L'équipe QuikDoc`;
  } else {
    defaultMessage = `Bonjour,

Veuillez trouver ci-joint votre devis ${docName} d'un montant de ${montant} daté du ${dateDoc}.

Ce devis est disponible en format PDF dans les pièces jointes de cet email.

Pour toute question ou pour valider ce devis, n'hésitez pas à nous contacter.

Nous vous remercions de votre confiance.

Cordialement,
L'équipe QuikDoc`;
  }
  
  emailForm.value = {
    to: '', // Dans une application réelle, on pourrait préremplir avec l'email du client
    cc: '',
    subject: `${isFacture ? 'Facture' : 'Devis'} ${docName} - QuikDoc`,
    message: defaultMessage,
    attachPdf: true
  };
  
  showEmailModal.value = true;
};

// Fermer le formulaire d'envoi par email
const closeEmailModal = () => {
  showEmailModal.value = false;
};

// Envoyer l'email
const sendEmail = async () => {
  sending.value = true;
  try {
    // S'assurer que le document sélectionné est valide
    if (!selectedDocument.value || !selectedDocument.value.id) {
      throw new Error('Document invalide pour l\'envoi d\'email');
    }
    
    // Préparer les données pour l'API
    const emailData = {
      to: emailForm.value.to,
      subject: emailForm.value.subject,
      message: emailForm.value.message,
      attachPdf: emailForm.value.attachPdf,
      documentId: selectedDocument.value.id,
      documentType: activeTab.value === 'factures' ? 'facture' : 'devis'
    };
    
    console.log('Données d\'email pour envoi:', emailData);
    
    // Si la case "Joindre le document en PDF" est cochée, récupérer le file_path depuis la table document
    if (emailData.attachPdf) {
      try {
        // Récupérer le document depuis la table document en utilisant le remplissage_id (qui est l'id du document sélectionné)
        const documentResponse = await api.get(`/api/protected/documents/file-path/${selectedDocument.value.id}`);
        
        if (documentResponse.data && documentResponse.data.success && documentResponse.data.document && documentResponse.data.document.file_path) {
          console.log('Chemin du fichier PDF trouvé:', documentResponse.data.document.file_path);
          emailData.filePath = documentResponse.data.document.file_path;
        } else {
          console.warn('Aucun chemin de fichier trouvé pour ce document, utilisation de l\'URL PDF par défaut');
        }
      } catch (filePathError) {
        console.error('Erreur lors de la récupération du chemin du fichier:', filePathError);
        // Continuer avec l'URL PDF par défaut en cas d'erreur
      }
    }
    
    // Vérifier si le document a une URL PDF valide (utilisé comme fallback si file_path n'est pas disponible)
    if (selectedDocument.value.pdfUrl && !emailData.filePath) {
      console.log('URL du PDF à joindre:', selectedDocument.value.pdfUrl);
      emailData.pdfUrl = selectedDocument.value.pdfUrl;
    }
    
    // Déterminer le type de document
    const documentType = activeTab.value === 'factures' ? 'facture' : 'devis';
    
    // Utiliser le service email pour envoyer le document
    const response = await emailService.sendDocumentEmail({
      documentId: selectedDocument.value.id,
      documentType: documentType,
      to: emailData.to,
      subject: emailData.subject,
      message: emailData.message,
      attachPdf: emailData.attachPdf,
      filePath: emailData.filePath, // Ajouter le chemin du fichier PDF s'il est disponible
      pdfUrl: emailData.pdfUrl // Fallback si le file_path n'est pas disponible
    });
    
    console.log('Réponse de l\'envoi d\'email:', response);
    
    // Afficher une notification de succès avec un message convivial
    window.$notification.success('Succès ! ' + (activeTab.value === 'factures' ? 'Facture envoyée par email avec succès' : 'Devis envoyé par email avec succès'));
    closeEmailModal();
  } catch (error) {
    console.error('Erreur lors de l\'envoi de l\'email:', error);
    
    let errorMessage = 'Une erreur est survenue lors de l\'envoi de l\'email. Veuillez réessayer.';
    
    if (error.response && error.response.data && error.response.data.message) {
      errorMessage = error.response.data.message;
    } else if (error.message) {
      errorMessage = error.message;
    }
    
    // Afficher une notification d'erreur
    window.$notification.error('Erreur d\'envoi : ' + errorMessage);
  } finally {
    sending.value = false;
  }
};

// Modifier le document
const editDocument = (doc) => {
  // Dans une application réelle, on redirigerait vers la page d'édition
  console.log(`Modification du document ${doc.id}`);
  window.$notification.info(`Modification : Redirection vers la page d'édition du document ${doc.name}.`);
};

// Supprimer le document
const deleteDocument = async (doc) => {
  if (confirm(`Êtes-vous sûr de vouloir supprimer ${activeTab.value === 'factures' ? 'la facture' : 'le devis'} ${doc.name} ?`)) {
    try {
      console.log(`Tentative de suppression du document ${doc.id}`);
      
      // Appel à l'API pour supprimer le document selon son type
      let response;
      if (activeTab.value === 'factures') {
        // Pour les factures, utiliser l'API de suppression de factures
        response = await api.delete(`/api/factures/${doc.id}`);
      } else {
        // Pour les devis, utiliser l'API de suppression de devis
        response = await api.delete(`/api/devis/${doc.id}`);
      }
      
      if (response && response.data && response.data.success) {
        // Suppression réussie, mettre à jour l'interface
        documents.value = documents.value.filter(d => d.id !== doc.id);
        window.$notification.success(`Suppression réussie : Le document ${doc.name} a été supprimé.`);
      } else {
        window.$notification.error(`Erreur : Impossible de supprimer le document ${doc.name}.`);
      }
    } catch (error) {
      console.error(`Erreur lors de la suppression du document:`, error);
      window.$notification.error(`Erreur : Impossible de supprimer le document ${doc.name}. ${error.message || ''}`);
    }
  }
};

// Formater la date
const formatDate = (dateString) => {
  if (!dateString || dateString === '0000-00-00' || dateString === 'null') {
    return 'Non défini';
  }
  try {
    const date = new Date(dateString);
    // Vérifier si la date est valide
    if (isNaN(date.getTime())) {
      return 'Non défini';
    }
    return new Intl.DateTimeFormat('fr-FR').format(date);
  } catch (error) {
    console.error('Erreur lors du formatage de la date:', error);
    return 'Non défini';
  }
};

// Formater le montant
const formatAmount = (amount) => {
  return new Intl.NumberFormat('fr-FR', { style: 'currency', currency: 'EUR' }).format(amount);
};

// Obtenir le libellé du statut
const getStatusLabel = (status) => {
  // Mapper les statuts internes anglais vers les valeurs d'affichage en français
  const statusMap = {
    'not_sent': 'Non envoyée',
    'sent': 'Envoyée',
    'unpaid': 'Non payée',
    'paid': 'Payée',
    'overdue': 'En retard',
    'cancelled': 'Annulée',
    'accepted': 'Acceptée'
  };
  
  // Si le statut est déjà en français (venant du frontend), le retourner tel quel
  // Sinon, utiliser le mapping ou retourner le statut original si pas de mapping
  return statusMap[status] || status;
};

// Gestion des erreurs de chargement du PDF
const handlePdfError = (event) => {
  console.error('Erreur lors du chargement du PDF:', event);
  pdfLoading.value = false;
  pdfLoadError.value = true;
  pdfErrorMessage.value = 'Impossible de charger le PDF. Le fichier est peut-être manquant ou non accessible.';
};

// Gestion du chargement du PDF
const handlePdfLoad = (event) => {
  console.log('PDF chargé avec succès');
  pdfLoading.value = false;
  
  // Vérifier si l'iframe a réellement chargé un PDF et non une page d'erreur
  try {
    const iframe = event.target;
    
    // Si l'iframe est vide ou contient une page d'erreur HTML, considérer comme une erreur
    if (iframe.contentDocument && 
        (iframe.contentDocument.body.innerHTML.includes('error') || 
         iframe.contentDocument.body.innerHTML.includes('Error'))) {
      pdfLoadError.value = true;
      pdfErrorMessage.value = 'Le document PDF ne peut pas être affiché correctement.';
    }
  } catch (e) {
    // Une erreur de sécurité cross-origin signifie généralement que le PDF s'est bien chargé
    console.log('Exception attendue lors de la vérification du contenu de l\'iframe (probablement cross-origin):', e);
  }
};

// Charger les documents au montage du composant
onMounted(() => {
  console.log('Composant DocumentManagement monté, chargement des documents...');
  loadDocuments();
});

// Surveiller les changements d'onglet pour recharger les documents
watch(activeTab, () => {
  console.log("Changement d'onglet détecté:", activeTab.value);
  resetFilters();
  loadDocuments();
});

// Observer les changements de l'onglet initial (quand l'utilisateur navigue entre les vues)
watch(() => props.initialTab, (newTab) => {
  if (newTab !== activeTab.value) {
    activeTab.value = newTab;
    resetFilters();
    loadDocuments();
  }
});
</script>

<style scoped>
/* Styles généraux */
.document-management {
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  gap: 20px;
}

/* En-tête */
.document-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.animated-title {
  font-size: 1.8rem;
  color: #2c3e50;
  position: relative;
  margin: 0;
  padding-bottom: 8px;
}

.animated-title::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 0;
  width: 60px;
  height: 3px;
  background: linear-gradient(90deg, #3498db, #2980b9);
  border-radius: 3px;
}

.document-tabs {
  display: flex;
  gap: 10px;
}

.tab-btn {
  padding: 10px 20px;
  border: none;
  border-radius: 5px;
  background-color: #f5f5f5;
  color: #555;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  gap: 8px;
}

.tab-btn i {
  font-size: 1rem;
}

.tab-btn.active {
  background-color: #3498db;
  color: white;
}

.tab-btn:hover:not(.active) {
  background-color: #e0e0e0;
}

/* Barre de recherche et filtres */
.search-filter-container {
  display: flex;
  flex-direction: column;
  gap: 15px;
  background-color: #f9f9f9;
  border-radius: 8px;
  padding: 15px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
}

.search-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 15px;
}

.search-input-container {
  position: relative;
  flex: 1;
}

.search-icon {
  position: absolute;
  left: 12px;
  top: 50%;
  transform: translateY(-50%);
  color: #aaa;
}

.search-input {
  width: 100%;
  padding: 12px 40px 12px 40px;
  border: 1px solid #ddd;
  border-radius: 6px;
  font-size: 1rem;
  transition: border-color 0.3s ease;
}

.search-input:focus {
  border-color: #3498db;
  outline: none;
}

.clear-search {
  position: absolute;
  right: 12px;
  top: 50%;
  transform: translateY(-50%);
  background: none;
  border: none;
  color: #aaa;
  cursor: pointer;
  font-size: 0.9rem;
}

.clear-search:hover {
  color: #555;
}

.advanced-search-toggle {
  background-color: transparent;
  border: 1px solid #ddd;
  border-radius: 6px;
  padding: 10px 15px;
  color: #555;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 8px;
  transition: all 0.3s ease;
}

.advanced-search-toggle:hover {
  background-color: #f0f0f0;
}

.quick-filters {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.filter-btn {
  padding: 8px 15px;
  border: 1px solid #ddd;
  border-radius: 20px;
  background-color: white;
  color: #555;
  cursor: pointer;
  transition: all 0.3s ease;
  font-size: 0.9rem;
}

.filter-btn.active {
  background-color: #3498db;
  color: white;
  border-color: #3498db;
}

.filter-btn:hover:not(.active) {
  background-color: #f0f0f0;
}

.advanced-search {
  background-color: white;
  border-radius: 6px;
  padding: 15px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
  animation: slideDown 0.3s ease;
}

@keyframes slideDown {
  from { opacity: 0; transform: translateY(-10px); }
  to { opacity: 1; transform: translateY(0); }
}

.filter-row {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  gap: 15px;
  margin-bottom: 15px;
}

.filter-group {
  display: flex;
  flex-direction: column;
  gap: 5px;
}

.filter-group label {
  font-size: 0.9rem;
  color: #555;
  font-weight: 500;
}

.filter-group input,
.filter-group select {
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 5px;
  font-size: 0.9rem;
}

.filter-group input:focus,
.filter-group select:focus {
  border-color: #3498db;
  outline: none;
}

.filter-group input[type="date"] {
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 5px;
  font-size: 0.9rem;
}

.filter-actions {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
}

.reset-btn,
.apply-btn {
  padding: 8px 15px;
  border-radius: 5px;
  cursor: pointer;
  font-weight: 500;
  display: flex;
  align-items: center;
  gap: 5px;
  transition: all 0.3s ease;
}

.reset-btn {
  background-color: transparent;
  border: 1px solid #ddd;
  color: #555;
}

.reset-btn:hover {
  background-color: #f0f0f0;
}

.apply-btn {
  background-color: #3498db;
  border: 1px solid #3498db;
  color: white;
}

.apply-btn:hover {
  background-color: #2980b9;
}

/* Liste des documents */
.documents-container {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 15px;
  background-color: white;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
  overflow: hidden;
}

.action-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
}

.view-options {
  display: flex;
  gap: 5px;
}

.view-btn {
  padding: 8px;
  border: 1px solid #ddd;
  background-color: white;
  border-radius: 5px;
  cursor: pointer;
  color: #555;
  transition: all 0.3s ease;
}

.view-btn.active {
  background-color: #3498db;
  color: white;
  border-color: #3498db;
}

.view-btn:hover:not(.active) {
  background-color: #f0f0f0;
}

.sort-options {
  display: flex;
  align-items: center;
  gap: 10px;
}

.sort-options label {
  font-size: 0.9rem;
  color: #555;
}

.sort-options select {
  padding: 8px;
  border: 1px solid #ddd;
  border-radius: 5px;
  font-size: 0.9rem;
}

/* Indicateurs de statut pour la vue en grille */
.status-indicator {
  display: block;
  width: 12px;
  height: 12px;
  border-radius: 50%;
  position: absolute;
  top: 10px;
  right: 10px;
}

.status-indicator.draft,
.status-indicator.not_sent,
.status-indicator[class*="Non envoyée"] {
  background-color: #555;
}

.status-indicator.sent,
.status-indicator[class*="Envoyée"] {
  background-color: #0288d1;
}

.status-indicator.paid,
.status-indicator[class*="Payée"] {
  background-color: #388e3c;
}

.status-indicator.unpaid,
.status-indicator[class*="Non payée"] {
  background-color: #ff8f00;
}

.status-indicator.overdue,
.status-indicator[class*="En retard"] {
  background-color: #d32f2f;
}

.status-indicator.cancelled,
.status-indicator[class*="Annulée"] {
  background-color: #9e9e9e;
}

.status-indicator.accepted,
.status-indicator[class*="Acceptée"] {
  background-color: #00796b;
}

/* Mode liste */
.documents-list {
  width: 100%;
  overflow-x: auto;
}

.documents-table {
  width: 100%;
  border-collapse: collapse;
}

.documents-table th {
  background-color: #f5f5f5;
  padding: 12px 15px;
  text-align: left;
  font-weight: 600;
  color: #555;
  border-bottom: 1px solid #ddd;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.documents-table th:hover {
  background-color: #e0e0e0;
}

.documents-table td {
  padding: 12px 15px;
  border-bottom: 1px solid #eee;
  color: #333;
}

.document-row {
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.document-row:hover {
  background-color: #f9f9f9;
}

.status-badge {
  display: inline-block;
  padding: 5px 10px;
  border-radius: 20px;
  font-size: 0.8rem;
  font-weight: 500;
}

.status-badge.draft,
.status-badge.not_sent,
.status-badge[class*="Non envoyée"] {
  background-color: #f0f0f0;
  color: #555;
}

.status-badge.sent,
.status-badge[class*="Envoyée"] {
  background-color: #e1f5fe;
  color: #0288d1;
}

.status-badge.paid,
.status-badge[class*="Payée"] {
  background-color: #e8f5e9;
  color: #388e3c;
}

.status-badge.unpaid,
.status-badge[class*="Non payée"] {
  background-color: #fff8e1;
  color: #ff8f00;
}

.status-badge.overdue,
.status-badge[class*="En retard"] {
  background-color: #ffebee;
  color: #d32f2f;
}

.status-badge.cancelled,
.status-badge[class*="Annulée"] {
  background-color: #fafafa;
  color: #9e9e9e;
}

.status-badge.accepted,
.status-badge[class*="Acceptée"] {
  background-color: #e0f2f1;
  color: #00796b;
}

.actions-cell {
  white-space: nowrap;
  display: flex;
  gap: 5px;
}

.action-btn {
  padding: 6px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  transition: all 0.3s ease;
  color: white;
}

.preview-btn {
  background-color: #3498db;
}

.download-btn {
  background-color: #2ecc71;
}

.email-btn {
  background-color: #9b59b6;
}

.edit-btn {
  background-color: #f39c12;
}

.delete-btn {
  background-color: #e74c3c;
}

.action-btn:hover {
  opacity: 0.8;
}

/* Mode grille */
.documents-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 20px;
}

.document-card {
  border: 1px solid #eee;
  border-radius: 8px;
  overflow: hidden;
  transition: all 0.3s ease;
  cursor: pointer;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
}

.document-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
}

.document-card-header {
  padding: 15px;
  background-color: #f9f9f9;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.status-indicator {
  width: 100%;
  height: 100%;
  border: none;
}

.status-indicator.draft {
  background-color: #9e9e9e;
}

.status-indicator.sent {
  background-color: #0288d1;
}

.status-indicator.paid {
  background-color: #388e3c;
}

.status-indicator.overdue {
  background-color: #d32f2f;
}

.status-indicator.cancelled {
  background-color: #9e9e9e;
}

.document-type i {
  font-size: 1.2rem;
  color: #555;
}

.document-card-body {
  padding: 15px;
}

.document-name {
  margin: 0 0 10px 0;
  font-size: 1.1rem;
  color: #333;
}

.document-client,
.document-date,
.document-amount {
  margin: 5px 0;
  color: #555;
  font-size: 0.9rem;
}

.document-card-actions {
  padding: 10px 15px;
  background-color: #f9f9f9;
  display: flex;
  justify-content: space-between;
}

/* États */
.loading-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 50px 0;
  color: #555;
}

.spinner {
  width: 40px;
  height: 40px;
  border: 3px solid #f3f3f3;
  border-top: 3px solid #3498db;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin-bottom: 15px;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 50px 0;
  color: #555;
  text-align: center;
}

.empty-icon {
  font-size: 3rem;
  color: #ddd;
  margin-bottom: 15px;
}

/* Pagination */
.pagination {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 15px;
  border-top: 1px solid #eee;
  margin-top: auto;
}

.pagination-btn {
  padding: 8px 15px;
  border: 1px solid #ddd;
  border-radius: 5px;
  background-color: white;
  color: #555;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 5px;
  transition: all 0.3s ease;
}

.pagination-btn:hover:not(:disabled) {
  background-color: #f0f0f0;
}

.pagination-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.pagination-info {
  font-size: 0.9rem;
  color: #555;
}

/* Modals */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(26, 35, 126, 0.6);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
  animation: fadeIn 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
  backdrop-filter: blur(5px);
  -webkit-backdrop-filter: blur(5px);
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

.preview-modal,
.email-modal {
  background-color: white;
  border-radius: 12px;
  width: 90%;
  max-width: 1000px;
  max-height: 90vh;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  animation: scaleIn 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
  box-shadow: 0 10px 30px rgba(26, 35, 126, 0.3);
}

.email-modal {
  max-width: 550px;
  transform-origin: center;
}

@keyframes scaleIn {
  from { transform: scale(0.9); opacity: 0; }
  to { transform: scale(1); opacity: 1; }
}

.modal-header {
  padding: 18px 24px;
  background: linear-gradient(135deg, #1a237e, #283593);
  display: flex;
  justify-content: space-between;
  align-items: center;
  border-bottom: none;
}

.modal-header h3 {
  margin: 0;
  color: white;
  font-weight: 500;
  letter-spacing: 0.5px;
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.2);
}

.close-btn {
  background: rgba(255, 255, 255, 0.2);
  border: none;
  font-size: 1rem;
  color: white;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
  width: 32px;
  height: 32px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.close-btn:hover {
  background: rgba(255, 255, 255, 0.3);
  transform: rotate(90deg);
}

.modal-body {
  padding: 24px;
  overflow-y: auto;
  flex: 1;
}

.modal-footer {
  padding: 18px 24px;
  border-top: 1px solid rgba(26, 35, 126, 0.1);
  display: flex;
  justify-content: flex-end;
  gap: 12px;
}

/* Email modal buttons */
.cancel-btn,
.send-btn {
  padding: 12px 20px;
  border-radius: 8px;
  font-size: 0.95rem;
  font-weight: 500;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 8px;
  transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
  border: none;
}

.cancel-btn {
  background-color: rgba(26, 35, 126, 0.05);
  color: #1a237e;
  border: 1px solid rgba(26, 35, 126, 0.1);
}

.cancel-btn:hover {
  background-color: rgba(26, 35, 126, 0.1);
  transform: translateY(-2px);
}

.send-btn {
  background: linear-gradient(135deg, #1a237e, #283593);
  color: white;
  box-shadow: 0 4px 10px rgba(26, 35, 126, 0.2);
}

.send-btn:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 6px 15px rgba(26, 35, 126, 0.3);
}

.send-btn:disabled {
  opacity: 0.7;
  cursor: not-allowed;
}

@keyframes scaleIn {
  from { transform: scale(0.9); opacity: 0; }
  to { transform: scale(1); opacity: 1; }
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

/* Aperçu du document */
.document-preview {
  display: flex;
  gap: 20px;
  height: 60vh;
}

.pdf-preview {
  flex: 2;
  border: 1px solid #eee;
  border-radius: 5px;
  overflow: hidden;
  position: relative;
  background-color: #f5f5f5;
}

/* Email form styles */
.email-form {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.form-group label {
  font-size: 0.9rem;
  font-weight: 500;
  color: #1a237e;
  margin-bottom: 4px;
}

.form-group input,
.form-group textarea {
  padding: 12px 14px;
  border: 2px solid rgba(26, 35, 126, 0.1);
  border-radius: 8px;
  font-size: 0.95rem;
  transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
  background-color: rgba(255, 255, 255, 0.9);
}

.form-group input:focus,
.form-group textarea:focus {
  outline: none;
  border-color: #3f51b5;
  box-shadow: 0 0 0 3px rgba(63, 81, 181, 0.2);
  transform: translateY(-2px);
}

.form-group textarea {
  min-height: 120px;
  resize: vertical;
}

.checkbox-group {
  flex-direction: row;
  align-items: center;
  gap: 10px;
  margin-top: 8px;
}

.checkbox-group input[type="checkbox"] {
  width: 18px;
  height: 18px;
  accent-color: #1a237e;
  cursor: pointer;
}

.checkbox-group label {
  margin-bottom: 0;
  cursor: pointer;
}

.pdf-iframe {
  width: 100%;
  height: 100%;
  border: none;
}

.pdf-loading {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  background-color: rgba(255, 255, 255, 0.9);
  z-index: 5;
}

.pdf-loading .spinner {
  width: 40px;
  height: 40px;
  margin-bottom: 15px;
}

.pdf-iframe {
  width: 100%;
  height: 100%;
  border: none;
}

.pdf-error {
  padding: 30px;
  text-align: center;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  height: 100%;
  gap: 20px;
  color: #555;
}

.pdf-actions {
  display: flex;
  gap: 10px;
}

.pdf-actions a {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 10px 15px;
  background-color: #3498db;
  color: white;
  text-decoration: none;
  border-radius: 5px;
  margin-top: 10px;
  font-weight: 500;
  transition: all 0.3s ease;
}

.pdf-actions a:hover {
  background-color: #2980b9;
  transform: translateY(-2px);
}

.document-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 20px;
  overflow-y: auto;
}

.info-section {
  background-color: #f9f9f9;
  border-radius: 5px;
  padding: 15px;
}

.info-section h4 {
  margin: 0 0 15px 0;
  color: #333;
  font-size: 1.1rem;
  border-bottom: 1px solid #eee;
  padding-bottom: 8px;
}

.info-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 10px;
}

.info-item {
  display: flex;
  flex-direction: column;
  gap: 5px;
}

.info-label {
  font-size: 0.8rem;
  color: #777;
}

.info-value {
  font-size: 0.95rem;
  color: #333;
  font-weight: 500;
}

/* Formulaire d'email */
.email-form {
  display: flex;
  flex-direction: column;
  gap: 20px;
  max-width: 600px;
  margin: 0 auto;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.form-group label {
  font-size: 0.95rem;
  color: #444;
  font-weight: 600;
  letter-spacing: 0.2px;
}

.form-group input,
.form-group textarea {
  padding: 12px 15px;
  border: 1px solid #ddd;
  border-radius: 6px;
  font-size: 1rem;
  transition: all 0.3s ease;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
}

.form-group input:hover,
.form-group textarea:hover {
  border-color: #bbb;
}

.form-group input:focus,
.form-group textarea:focus {
  border-color: #3498db;
  box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.15);
  outline: none;
}

.form-group textarea {
  min-height: 120px;
  resize: vertical;
}

.checkbox-group {
  flex-direction: row;
  align-items: center;
  gap: 12px;
  margin-top: 5px;
}

.checkbox-group input[type="checkbox"] {
  width: 18px;
  height: 18px;
  cursor: pointer;
}

.checkbox-group label {
  cursor: pointer;
  font-weight: 500;
}

.email-modal .modal-footer {
  display: flex;
  justify-content: space-between;
  padding: 20px;
}

.cancel-btn,
.send-btn {
  padding: 12px 24px;
  border-radius: 6px;
  cursor: pointer;
  font-weight: 500;
  font-size: 1rem;
  display: flex;
  align-items: center;
  gap: 10px;
  transition: all 0.3s ease;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
}

.cancel-btn {
  background-color: #f8f9fa;
  border: 1px solid #ddd;
  color: #444;
}

.cancel-btn:hover {
  background-color: #e9ecef;
  border-color: #ccc;
}

.send-btn {
  background-color: #3498db;
  border: 1px solid #3498db;
  color: white;
  min-width: 120px;
  justify-content: center;
}

.send-btn:hover:not(:disabled) {
  background-color: #2980b9;
  transform: translateY(-1px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.send-btn:disabled {
  opacity: 0.7;
  cursor: not-allowed;
}

/* Responsive */
@media (max-width: 768px) {
  .document-preview {
    flex-direction: column;
    height: auto;
  }
  
  .pdf-preview {
    height: 400px;
  }
  
  .filter-row {
    grid-template-columns: 1fr;
  }
  
  .search-bar {
    flex-direction: column;
  }
  
  .documents-grid {
    grid-template-columns: 1fr;
  }
  
  .action-bar {
    flex-direction: column;
    gap: 10px;
    align-items: flex-start;
  }
}
</style>