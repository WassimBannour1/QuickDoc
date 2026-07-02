<template>
  <div class="factures-view">
    <!-- En-tête avec titre -->
    <div class="factures-header">
      <h2 class="animated-title">Gestion des Factures</h2>
    </div>
    
    <!-- Modal de prévisualisation du document -->
    <div v-if="showPreviewModal" class="modal-overlay" @click.self="closePreviewModal">
      <div class="preview-modal">
        <div class="modal-header">
          <h3>{{ selectedDocument ? selectedDocument.reference : '' }}</h3>
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
                <h4><i class="fas fa-file-invoice"></i> Informations générales</h4>
                <div class="info-grid">
                  <div class="info-item">
                    <span class="info-label"><i class="fas fa-hashtag"></i> Référence:</span>
                    <span class="info-value">{{ selectedDocument ? selectedDocument.reference : '' }}</span>
                  </div>
                  <div class="info-item">
                    <span class="info-label"><i class="fas fa-calendar-alt"></i> Date:</span>
                    <span class="info-value">{{ selectedDocument ? formatDate(selectedDocument.date) : '' }}</span>
                  </div>
                  <div class="info-item">
                    <span class="info-label"><i class="fas fa-tag"></i> Statut:</span>
                    <span v-if="selectedDocument" :class="['status-badge', selectedDocument.status]">
                      {{ selectedDocument ? getStatusLabel(selectedDocument.status) : '' }}
                    </span>
                  </div>
                  <div class="info-item">
                    <span class="info-label"><i class="fas fa-euro-sign"></i> Montant:</span>
                    <span class="info-value">{{ selectedDocument ? formatAmount(selectedDocument.amount) : '' }}</span>
                  </div>
                </div>
              </div>
              
              <div class="info-section">
                <h4><i class="fas fa-building"></i> Client</h4>
                <div class="info-grid">
                  <div class="info-item">
                    <span class="info-label"><i class="fas fa-briefcase"></i> Entreprise:</span>
                    <span class="info-value">{{ selectedDocument ? selectedDocument.company : '' }}</span>
                  </div>
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
            <button @click="downloadDocument(selectedDocument)" class="action-btn download-btn" title="Télécharger le document">
              <i class="fas fa-download"></i> Télécharger
            </button>
            <button @click="closePreviewModal" class="action-btn close-btn" title="Fermer la prévisualisation">
              <i class="fas fa-times"></i> Fermer
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Barre de recherche et filtres -->
    <div class="search-filter-container">
      <div class="search-bar">
        <div class="search-input-container">
          <i class="fas fa-search search-icon"></i>
          <input 
            type="text" 
            v-model="searchQuery" 
            placeholder="Rechercher une facture..." 
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
      <div v-if="showAdvancedSearch" class="advanced-search">
        <div class="advanced-search-row">
          <div class="advanced-search-field">
            <label>Référence</label>
            <input type="text" v-model="advancedFilters.reference" @input="applyFilters" />
          </div>
          <div class="advanced-search-field">
            <label>Entreprise</label>
            <input type="text" v-model="advancedFilters.company" @input="applyFilters" />
          </div>
          <div class="advanced-search-field date-range">
            <label>Date</label>
            <div class="date-inputs">
              <input type="date" v-model="advancedFilters.dateFrom" @change="applyFilters" />
              <span>à</span>
              <input type="date" v-model="advancedFilters.dateTo" @change="applyFilters" />
            </div>
          </div>
        </div>
        <div class="advanced-search-row">
          <div class="advanced-search-field">
            <label>Montant min</label>
            <input type="number" v-model="advancedFilters.amountMin" @input="applyFilters" />
          </div>
          <div class="advanced-search-field">
            <label>Montant max</label>
            <input type="number" v-model="advancedFilters.amountMax" @input="applyFilters" />
          </div>
          <div class="advanced-search-field">
            <label>Statut</label>
            <select v-model="advancedFilters.status" @change="applyFilters">
              <option value="">Tous</option>
              <option value="paid">Payé</option>
              <option value="unpaid">Non payé</option>
              <option value="cancelled">Annulé</option>
            </select>
          </div>
        </div>
        <div class="advanced-search-actions">
          <button @click="resetFilters" class="btn-reset-filters">
            <i class="fas fa-undo"></i> Réinitialiser
          </button>
        </div>
      </div>
    </div>

    <!-- Tableau des factures -->
    <div class="factures-table-container">
      <table class="factures-table" v-if="filteredFactures.length > 0">
        <thead>
          <tr>
            <th @click="sortBy('reference')" class="sortable">
              Référence
              <i v-if="sortKey === 'reference'" :class="sortIconClass"></i>
            </th>
            <th @click="sortBy('date')" class="sortable">
              Date
              <i v-if="sortKey === 'date'" :class="sortIconClass"></i>
            </th>
            <th @click="sortBy('company')" class="sortable">
              Entreprise
              <i v-if="sortKey === 'company'" :class="sortIconClass"></i>
            </th>
            <th @click="sortBy('amount')" class="sortable">
              Montant TTC
              <i v-if="sortKey === 'amount'" :class="sortIconClass"></i>
            </th>
            <th @click="sortBy('status')" class="sortable">
              Statut
              <i v-if="sortKey === 'status'" :class="sortIconClass"></i>
            </th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="facture in paginatedFactures" :key="facture.id">
            <td>{{ facture.reference }}</td>
            <td>{{ formatDate(facture.date) }}</td>
            <td>{{ facture.company }}</td>
            <td>{{ formatAmount(facture.amount) }}</td>
            <td>
              <span :class="['status-badge', facture.status]">
                {{ getStatusLabel(facture.status) }}
              </span>
            </td>
            <td class="actions-cell">
              <button @click.stop="previewDocument(facture)" class="action-btn view" title="Voir la facture">
                <i class="fas fa-eye"></i>
              </button>
              <button @click.stop="downloadDocument(facture)" class="action-btn download" title="Télécharger">
                <i class="fas fa-download"></i>
              </button>
              <button 
                v-if="facture.status === 'unpaid'" 
                @click.stop="navigateToPayment(facture)" 
                class="action-btn payment" 
                title="Paiement"
              >
                <i class="fas fa-credit-card"></i>
              </button>
            </td>
          </tr>
        </tbody>
      </table>

      <!-- Message si aucune facture -->
      <div v-else class="no-factures">
        <i class="fas fa-file-invoice"></i>
        <p>Aucune facture ne correspond à vos critères</p>
        <button @click="resetFilters" class="btn-reset">
          Réinitialiser les filtres
        </button>
      </div>
    </div>

    <!-- Pagination -->
    <div class="pagination" v-if="filteredFactures.length > 0">
      <button 
        @click="prevPage" 
        :disabled="currentPage === 1" 
        class="pagination-btn"
      >
        <i class="fas fa-chevron-left"></i>
      </button>
      <span class="page-info">
        Page {{ currentPage }} sur {{ totalPages }}
      </span>
      <button 
        @click="nextPage" 
        :disabled="currentPage === totalPages" 
        class="pagination-btn"
      >
        <i class="fas fa-chevron-right"></i>
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import api from '@/services/api';
import remplissageService from '@/services/remplissageService';
import documentService from '@/services/documentService';
import pdfViewerService from '@/services/pdfViewerService';
import { useMainStore } from '@/stores';

// Initialisation du router pour la navigation
const router = useRouter();

// Initialisation du store pour accéder aux données utilisateur
const store = useMainStore();

// État des filtres et de la recherche
const searchQuery = ref('');

// Fonctions pour les nouvelles actions
const printDocument = (document) => {
  console.log('Impression du document:', document.reference);
  // Logique d'impression à implémenter
  window.print();
};

const shareDocument = (document) => {
  console.log('Partage du document:', document.reference);
  // Logique de partage à implémenter
  // Par exemple, ouvrir une boîte de dialogue pour partager par email
  alert(`Fonctionnalité de partage pour ${document.reference} sera bientôt disponible`);
};
const showAdvancedSearch = ref(false);
const currentStatusFilter = ref('all');
const advancedFilters = ref({
  reference: '',
  company: '',
  dateFrom: '',
  dateTo: '',
  amountMin: '',
  amountMax: '',
  status: ''
});

// État du tri
const sortKey = ref('date');
const sortDirection = ref('desc');

// État de la pagination
const currentPage = ref(1);
const itemsPerPage = 10;

// Données des factures (simulées pour le moment)
const factures = ref([]);

// Filtres rapides disponibles
const quickFilters = [
  { label: 'Tous', value: 'all' },
  { label: 'Payé', value: 'paid' },
  { label: 'Non payé', value: 'unpaid' }
];

// Chargement des factures depuis l'API
const loadFactures = async () => {
  try {
    // Préparation des filtres pour l'API
    const apiFilters = {
      ...advancedFilters.value,
      search: searchQuery.value
    };
    
    // Si l'utilisateur est un client, ajouter son client_id au filtre
    if (store.user && store.user.role === 'client') {
      // Récupérer le client_id associé à l'utilisateur connecté
      // Note: Dans un cas réel, vous pourriez avoir besoin de faire une requête API pour obtenir le client_id
      apiFilters.client_id = store.user.client_id;
      console.log('Filtrage des factures pour le client_id:', apiFilters.client_id);
    }
    
    // Utilisation du service remplissageService pour récupérer les factures
    const response = await remplissageService.getFactures(apiFilters);
    
    if (response.success && response.data) {
      // Transformation des données pour correspondre au format attendu par le composant
      factures.value = response.data.map(item => ({
        id: item.id,
        reference: item.serie_number || item.reference || `FACT-${item.id}`,
        date: item.date,
        company: item.company || item.nom_entreprise,
        amount: item.amount || item.montant_ttc,
        status: item.status_client || item.status || item.document_status || 'unpaid'
      }));
      console.log('Factures chargées:', factures.value.length);
    } else {
      factures.value = [];
      console.log('Aucune facture trouvée');
    }
  } catch (error) {
    console.error('Erreur lors du chargement des factures:', error);
    factures.value = [];
  }
};

// Filtrage des factures
const filteredFactures = computed(() => {
  let result = [...factures.value];
  
  // Filtre par statut (filtres rapides)
  if (currentStatusFilter.value !== 'all') {
    result = result.filter(facture => facture.status === currentStatusFilter.value);
  }
  
  // Filtre par recherche globale
  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase();
    result = result.filter(facture => 
      facture.reference.toLowerCase().includes(query) ||
      facture.company.toLowerCase().includes(query) ||
      facture.amount.toString().includes(query)
    );
  }
  
  // Filtres avancés
  if (advancedFilters.value.reference) {
    const query = advancedFilters.value.reference.toLowerCase();
    result = result.filter(facture => facture.reference.toLowerCase().includes(query));
  }
  
  if (advancedFilters.value.company) {
    const query = advancedFilters.value.company.toLowerCase();
    result = result.filter(facture => facture.company.toLowerCase().includes(query));
  }
  
  if (advancedFilters.value.dateFrom) {
    result = result.filter(facture => new Date(facture.date) >= new Date(advancedFilters.value.dateFrom));
  }
  
  if (advancedFilters.value.dateTo) {
    result = result.filter(facture => new Date(facture.date) <= new Date(advancedFilters.value.dateTo));
  }
  
  if (advancedFilters.value.amountMin) {
    result = result.filter(facture => facture.amount >= parseFloat(advancedFilters.value.amountMin));
  }
  
  if (advancedFilters.value.amountMax) {
    result = result.filter(facture => facture.amount <= parseFloat(advancedFilters.value.amountMax));
  }
  
  if (advancedFilters.value.status) {
    result = result.filter(facture => facture.status === advancedFilters.value.status);
  }
  
  // Tri des résultats
  result.sort((a, b) => {
    let comparison = 0;
    
    switch (sortKey.value) {
      case 'reference':
        comparison = a.reference.localeCompare(b.reference);
        break;
      case 'date':
        comparison = new Date(a.date) - new Date(b.date);
        break;
      case 'company':
        comparison = a.company.localeCompare(b.company);
        break;
      case 'amount':
        comparison = a.amount - b.amount;
        break;
      case 'status':
        comparison = a.status.localeCompare(b.status);
        break;
      default:
        comparison = 0;
    }
    
    return sortDirection.value === 'asc' ? comparison : -comparison;
  });
  
  return result;
});

// Pagination
const totalPages = computed(() => {
  return Math.ceil(filteredFactures.value.length / itemsPerPage);
});

const paginatedFactures = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage;
  const end = start + itemsPerPage;
  return filteredFactures.value.slice(start, end);
});

const nextPage = () => {
  if (currentPage.value < totalPages.value) {
    currentPage.value++;
  }
};

const prevPage = () => {
  if (currentPage.value > 1) {
    currentPage.value--;
  }
};

// Chargement initial des factures
onMounted(() => {
  loadFactures();
});

// Fonctions utilitaires
const formatDate = (dateString) => {
  const options = { day: '2-digit', month: '2-digit', year: 'numeric' };
  return new Date(dateString).toLocaleDateString('fr-FR', options);
};

const formatAmount = (amount) => {
  return new Intl.NumberFormat('fr-FR', { style: 'currency', currency: 'EUR' }).format(amount);
};

const getStatusLabel = (status) => {
  switch (status) {
    case 'paid': return 'Payé';
    case 'unpaid': return 'Non payé';
    case 'cancelled': return 'Annulé';
    case 'pending': return 'En attente';
    case 'accepted': return 'Accepté';
    case 'rejected': return 'Rejeté';
    case 'overdue': return 'En retard';
    default: return status;
  }
};

// Gestion des filtres et de la recherche
const toggleAdvancedSearch = () => {
  showAdvancedSearch.value = !showAdvancedSearch.value;
};

const clearSearch = () => {
  searchQuery.value = '';
  applyFilters();
};

const setStatusFilter = (status) => {
  currentStatusFilter.value = status;
  applyFilters();
};

const resetFilters = () => {
  searchQuery.value = '';
  currentStatusFilter.value = 'all';
  advancedFilters.value = {
    reference: '',
    company: '',
    dateFrom: '',
    dateTo: '',
    amountMin: '',
    amountMax: '',
    status: ''
  };
  applyFilters();
};

const applyFilters = () => {
  currentPage.value = 1; // Retour à la première page après filtrage
  // Recharger les factures avec les nouveaux filtres
  loadFactures();
};

// Tri des colonnes
const sortBy = (key) => {
  if (sortKey.value === key) {
    sortDirection.value = sortDirection.value === 'asc' ? 'desc' : 'asc';
  } else {
    sortKey.value = key;
    sortDirection.value = 'asc';
  }
};

const sortIconClass = computed(() => {
  return sortDirection.value === 'asc' ? 'fas fa-sort-up' : 'fas fa-sort-down';
});

// Télécharger le document
const downloadDocument = async (facture) => {
  try {
    // Vérifier si le document a un ID valide
    if (!facture || !facture.id) {
      console.error('Document invalide ou sans ID');
      return;
    }
    
    // Afficher un message de chargement
    console.log(`Téléchargement de la facture ${facture.id} en cours...`);
    
    // Utiliser le service de document pour télécharger le PDF
    await documentService.downloadDocument(facture.id);
    
    console.log(`Téléchargement de la facture ${facture.id} terminé`);
  } catch (error) {
    console.error(`Erreur lors du téléchargement de la facture:`, error);
  }
};

// Naviguer vers la page de paiement et mettre à jour le statut de paiement
const navigateToPayment = async (facture) => {
  try {
    if (!facture || !facture.id) {
      console.error('Facture invalide ou sans ID');
      return;
    }
    
    console.log(`Mise à jour du statut de paiement pour la facture ${facture.id}`);
    
    // Appeler l'API pour mettre à jour le statut de paiement
    try {
      const response = await api.post(`/api/factures/${facture.id}/payment-status`);
      
      if (response.data.success) {
        console.log('Statut de paiement mis à jour avec succès');
        
        // Mettre à jour le statut localement
        facture.status = 'paid';
        facture.status_client = 'paid';
        
        // Recharger les factures pour mettre à jour l'affichage
        await loadFactures();
      } else {
        console.error('Erreur lors de la mise à jour du statut de paiement:', response.data.message);
      }
    } catch (apiError) {
      console.error('Erreur API lors de la mise à jour du statut de paiement:', apiError);
    }
    
    console.log(`Redirection vers la page de paiement pour la facture ${facture.id}`);
    
    // Utiliser le router pour naviguer vers la page de paiement avec l'ID de la facture
    router.push({
      path: '/payment',
      query: { factureId: facture.id, status_client: 'paid' }
    });
  } catch (error) {
    console.error(`Erreur lors de la redirection vers la page de paiement:`, error);
  }
};

// États pour la prévisualisation modale
const showPreviewModal = ref(false);
const selectedDocument = ref(null);
const previewUrl = ref('');
const previewCurrentPage = ref(1);
const previewTotalPages = ref(1);
const zoomLevel = ref(1);

// Prévisualiser le document
const previewDocument = async (facture) => {
  try {
    // Vérifier si le document a un ID valide
    if (!facture || !facture.id) {
      console.error('Document invalide ou sans ID');
      return;
    }
    
    console.log(`Prévisualisation de la facture ${facture.id} en cours...`);
    
    // Stocker le document sélectionné
    selectedDocument.value = facture;
    
    // Récupérer les informations du document
    const response = await documentService.getDocumentById(facture.id);
    const document = response.data.document;
    
    // Initialiser les valeurs de pagination
    previewCurrentPage.value = 1;
    previewTotalPages.value = 1; // Sera mis à jour si disponible
    
    // Utiliser le service documentService pour générer l'URL de visualisation
    // Cette URL pointe directement vers le fichier PDF stocké dans file_path
    const viewUrl = documentService.getPdfViewUrl(facture.id);
    
    // Utiliser le service de visualisation PDF pour générer une URL optimisée
    // qui affichera correctement le PDF dans l'iframe
    previewUrl.value = pdfViewerService.getOptimalViewerUrl(viewUrl);
    
    console.log(`URL de prévisualisation générée: ${previewUrl.value}`);
    
    // Afficher la modal
    showPreviewModal.value = true;
    
    console.log(`Prévisualisation de la facture ${facture.id} préparée`);
  } catch (error) {
    console.error(`Erreur lors de la prévisualisation de la facture:`, error);
  }
};

// Fermer la modal de prévisualisation
const closePreviewModal = () => {
  showPreviewModal.value = false;
  selectedDocument.value = null;
  previewUrl.value = '';
  previewCurrentPage.value = 1;
  zoomLevel.value = 1;
};

// Contrôles de zoom
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

// Navigation entre les pages du document prévisualisé
const nextPreviewPage = async () => {
  if (previewCurrentPage.value < previewTotalPages.value) {
    previewCurrentPage.value++;
    await updatePreviewUrl();
  }
};

const prevPreviewPage = async () => {
  if (previewCurrentPage.value > 1) {
    previewCurrentPage.value--;
    await updatePreviewUrl();
  }
};

// Mettre à jour l'URL de prévisualisation
const updatePreviewUrl = async () => {
  try {
    if (selectedDocument.value && selectedDocument.value.id) {
      // Utiliser le service documentService pour générer l'URL de visualisation
      // avec la page actuelle (si le backend supporte la pagination)
      const viewUrl = documentService.getPdfViewUrl(selectedDocument.value.id);
      
      // Ajouter le paramètre de page si nécessaire
      const urlWithPage = `${viewUrl}&page=${previewCurrentPage.value}`;
      
      // Utiliser le service de visualisation PDF pour générer une URL optimisée
      previewUrl.value = pdfViewerService.getOptimalViewerUrl(urlWithPage);
      
      console.log(`URL de prévisualisation mise à jour: ${previewUrl.value}`);
    }
  } catch (error) {
    console.error('Erreur lors de la mise à jour de l\'aperçu:', error);
  }
};

// Obtenir l'URL de prévisualisation du PDF
const getPdfViewUrl = () => {
  if (!selectedDocument.value || !selectedDocument.value.id) {
    return '';
  }
  
  // Utiliser le service documentService pour générer l'URL avec authentification
  // Cette URL pointe vers le fichier PDF stocké dans file_path de la table document
  const token = localStorage.getItem('token');
  const timestamp = Date.now();
  return `${api.defaults.baseURL || ''}/api/protected/documents/${selectedDocument.value.id}/view?token=${token}&t=${timestamp}`;
};

// Chargement initial des données
onMounted(() => {
  loadFactures();
});
</script>

<style scoped>
/* Styles pour la prévisualisation modale */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.7);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  backdrop-filter: blur(3px);
  animation: fadeIn 0.3s ease-out;
}

.preview-modal {
  background-color: white;
  border-radius: 12px;
  width: 90%;
  max-width: 1200px;
  height: 90vh;
  display: flex;
  flex-direction: column;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.25);
  overflow: hidden;
  animation: modalSlideIn 0.4s cubic-bezier(0.16, 1, 0.3, 1);
  border-left: 4px solid #1a237e;
}

@keyframes modalSlideIn {
  from { transform: translateY(30px); opacity: 0; }
  to { transform: translateY(0); opacity: 1; }
}

.modal-header {
  padding: 18px 24px;
  border-bottom: 1px solid #e2e8f0;
  display: flex;
  justify-content: space-between;
  align-items: center;
  background-color: #f8fafc;
}

.modal-header h3 {
  margin: 0;
  font-size: 1.3rem;
  color: #1a237e;
  font-weight: 600;
  display: flex;
  align-items: center;
}

.modal-header h3::before {
  content: '\f15c';
  font-family: 'Font Awesome 5 Free';
  font-weight: 900;
  margin-right: 10px;
  color: #3949ab;
}

.modal-header .close-btn {
  background: none;
  border: none;
  font-size: 1.2rem;
  color: #64748b;
  cursor: pointer;
  width: 36px;
  height: 36px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s ease;
}

.modal-header .close-btn:hover {
  background-color: #f1f5f9;
  color: #1a237e;
  transform: rotate(90deg);
}

.modal-body {
  flex: 1;
  overflow: auto;
  padding: 24px;
  background-color: #fff;
}

.document-preview {
  display: flex;
  height: 100%;
  gap: 24px;
}

.pdf-preview {
  flex: 2;
  border: 1px solid #e2e8f0;
  border-radius: 8px;
  overflow: hidden;
  height: 100%;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  transition: transform 0.3s ease;
  transform-origin: center center;
}

.pdf-iframe {
  border: none;
  width: 100%;
  height: 100%;
}

.document-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 20px;
  overflow-y: auto;
  animation: slideInRight 0.5s ease-out;
}

@keyframes slideInRight {
  from { transform: translateX(20px); opacity: 0; }
  to { transform: translateX(0); opacity: 1; }
}

.info-section {
  background-color: #f8fafc;
  border-radius: 10px;
  padding: 18px;
  border: 1px solid #e2e8f0;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
  transition: all 0.3s ease;
}

.info-section:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  transform: translateY(-2px);
}

.info-section h4 {
  margin-top: 0;
  margin-bottom: 15px;
  color: #1a237e;
  font-size: 1.1rem;
  border-bottom: 2px solid #c5cae9;
  padding-bottom: 10px;
  display: flex;
  align-items: center;
  gap: 8px;
}

.info-section h4 i {
  color: #3949ab;
}

.info-grid {
  display: grid;
  gap: 14px;
}

.info-item {
  display: flex;
  flex-direction: column;
  gap: 6px;
  animation: fadeIn 0.5s ease-out;
}

.info-label {
  font-size: 0.9rem;
  color: #64748b;
  display: flex;
  align-items: center;
  gap: 6px;
}

.info-label i {
  color: #3949ab;
  font-size: 0.85rem;
}

.info-value {
  font-size: 1rem;
  color: #334155;
  font-weight: 500;
  padding: 4px 0;
}

.modal-footer {
  padding: 18px 24px;
  border-top: 1px solid #e2e8f0;
  display: flex;
  justify-content: space-between;
  align-items: center;
  background-color: #f8fafc;
}

.preview-toolbar {
  display: flex;
  gap: 24px;
}

.zoom-controls, .page-controls {
  display: flex;
  align-items: center;
  gap: 12px;
  background-color: white;
  border-radius: 30px;
  padding: 6px 12px;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.08);
}

.zoom-button, .page-button {
  background-color: white;
  border: 1px solid #e2e8f0;
  border-radius: 50%;
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #1a237e;
  cursor: pointer;
  transition: all 0.2s ease;
}

.zoom-button:hover, .page-button:hover {
  background-color: #e8eaf6;
  transform: translateY(-2px);
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
}

.zoom-button:disabled, .page-button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
  transform: none;
  box-shadow: none;
}

.zoom-level, .page-info {
  font-size: 0.9rem;
  color: #334155;
  font-weight: 500;
  min-width: 60px;
  text-align: center;
}

.action-buttons {
  display: flex;
  gap: 12px;
}

.action-btn {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 10px 16px;
  border-radius: 30px;
  font-size: 0.95rem;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
}

.download-btn {
  background-color: #1a237e;
  border: none;
  color: white;
}

.download-btn:hover {
  background-color: #3949ab;
  transform: translateY(-2px);
  box-shadow: 0 4px 10px rgba(26, 35, 126, 0.3);
}

.close-btn {
  background-color: white;
  border: 1px solid #e2e8f0;
  color: #334155;
}

.close-btn:hover {
  background-color: #f1f5f9;
  transform: translateY(-2px);
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
}

/* Responsive design pour la prévisualisation */
@media (max-width: 992px) {
  .document-preview {
    flex-direction: column;
  }
  
  .pdf-preview {
    flex: 1;
    min-height: 400px;
  }
  
  .document-info {
    flex: none;
  }
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}

@keyframes slideIn {
  from { transform: translateX(-20px); opacity: 0; }
  to { transform: translateX(0); opacity: 1; }
}

@keyframes pulse {
  0% { transform: scale(1); }
  50% { transform: scale(1.05); }
  100% { transform: scale(1); }
}

.factures-view {
  padding: 20px;
  background-color: #f8f9fa;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
  animation: fadeIn 0.5s ease-out;
  border-top: 4px solid #1a237e; /* Ajout d'une bordure bleu foncé */
}

/* En-tête */
.factures-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.factures-header h2 {
  font-size: 1.8rem;
  color: #333;
  margin: 0;
  position: relative;
}

.animated-title {
  animation: slideIn 0.7s ease-out;
  padding-bottom: 5px;
}

.animated-title::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 0;
  width: 0;
  height: 3px;
  background: linear-gradient(90deg, #1a237e, #3949ab); /* Changement pour bleu foncé */
  animation: lineGrow 1.5s forwards ease-out;
}

@keyframes lineGrow {
  to { width: 100%; }
}

.btn-add-facture {
  background-color: #1a237e; /* Changement pour bleu foncé */
  color: white;
  border: none;
  border-radius: 4px;
  padding: 10px 15px;
  font-size: 0.9rem;
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
}

.btn-add-facture:hover {
  background-color: #3949ab; /* Bleu foncé plus clair au survol */
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
}

/* Barre de recherche et filtres */
.search-filter-container {
  margin-bottom: 20px;
  background-color: white;
  border-radius: 8px;
  padding: 15px;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
}

.search-bar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 15px;
}

.search-input-container {
  position: relative;
  flex: 1;
  margin-right: 15px;
}

.search-icon {
  position: absolute;
  left: 10px;
  top: 50%;
  transform: translateY(-50%);
  color: #aaa;
}

.search-input {
  width: 100%;
  padding: 10px 10px 10px 35px;
  border: 1px solid #c5cae9; /* Bordure bleu clair */
  border-radius: 4px;
  font-size: 0.9rem;
  transition: all 0.3s ease;
}

.search-input:focus {
  outline: none;
  border-color: #1a237e; /* Bordure bleu foncé au focus */
  box-shadow: 0 0 0 2px rgba(26, 35, 126, 0.2); /* Ombre bleu foncé */
}

.clear-search {
  position: absolute;
  right: 10px;
  top: 50%;
  transform: translateY(-50%);
  background: none;
  border: none;
  color: #aaa;
  cursor: pointer;
}

.advanced-search-toggle {
  background: none;
  border: none;
  color: #666;
  display: flex;
  align-items: center;
  gap: 5px;
  cursor: pointer;
  font-size: 0.9rem;
}

/* Filtres rapides */
.quick-filters {
  display: flex;
  gap: 10px;
  margin-bottom: 15px;
}

.filter-btn {
  padding: 8px 15px;
  border: 1px solid #ddd;
  border-radius: 20px;
  background-color: white;
  color: #666;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
  box-shadow: 0 1px 3px rgba(0,0,0,0.1);
  position: relative;
  overflow: hidden;
}

.filter-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0,0,0,0.1);
}

.filter-btn.active {
  background-color: #1a237e; /* Changement pour bleu foncé */
  color: white;
  border-color: #1a237e;
  box-shadow: 0 4px 10px rgba(26, 35, 126, 0.3);
}

.filter-btn::after {
  content: '';
  position: absolute;
  top: 50%;
  left: 50%;
  width: 5px;
  height: 5px;
  background: rgba(255, 255, 255, 0.5);
  opacity: 0;
  border-radius: 100%;
  transform: scale(1, 1) translate(-50%, -50%);
  transform-origin: 50% 50%;
}

.filter-btn:active::after {
  animation: ripple 0.6s ease-out;
}

@keyframes ripple {
  0% {
    transform: scale(0, 0);
    opacity: 0.5;
  }
  100% {
    transform: scale(20, 20);
    opacity: 0;
  }
}

/* Recherche avancée */
.advanced-search {
  background-color: #f5f7ff; /* Fond bleu très clair */
  border-radius: 4px;
  padding: 15px;
  margin-top: 10px;
  border-left: 3px solid #1a237e; /* Bordure latérale bleu foncé */
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
  animation: fadeIn 0.5s ease-out;
}

.advanced-search-row {
  display: flex;
  gap: 15px;
  margin-bottom: 15px;
}

.advanced-search-field {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.advanced-search-field label {
  margin-bottom: 5px;
  font-size: 0.85rem;
  color: #666;
}

.advanced-search-field input,
.advanced-search-field select {
  padding: 8px;
  border: 1px solid #c5cae9; /* Bordure bleu clair */
  border-radius: 4px;
  transition: all 0.3s ease;
}

.advanced-search-field input:focus,
.advanced-search-field select:focus {
  outline: none;
  border-color: #1a237e; /* Bordure bleu foncé au focus */
  box-shadow: 0 0 0 2px rgba(26, 35, 126, 0.2); /* Ombre bleu foncé */
}

.date-inputs {
  display: flex;
  align-items: center;
  gap: 10px;
}

.date-inputs span {
  color: #666;
}

.advanced-search-actions {
  display: flex;
  justify-content: flex-end;
}

.btn-reset-filters {
  background: none;
  border: 1px solid #c5cae9; /* Bordure bleu clair */
  border-radius: 4px;
  padding: 8px 12px;
  color: #3949ab; /* Texte bleu */
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 5px;
  font-size: 0.85rem;
  transition: all 0.3s ease;
}

.btn-reset-filters:hover {
  background-color: #e8eaf6; /* Fond bleu très clair */
  transform: translateY(-2px);
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
}

/* Tableau des factures */
.factures-table-container {
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  overflow-x: auto;
  margin-bottom: 20px;
  transition: all 0.3s ease;
  animation: fadeIn 0.8s ease-out;
  border-left: 4px solid #1a237e; /* Ajout d'une bordure bleu foncé */
}

.factures-table-container:hover {
  box-shadow: 0 6px 16px rgba(0, 0, 0, 0.1);
}

.factures-table {
  width: 100%;
  border-collapse: collapse;
}

.factures-table th,
.factures-table td {
  padding: 12px 15px;
  text-align: left;
  border-bottom: 1px solid #eee;
}

.factures-table th {
  background-color: #e8eaf6; /* Fond bleu très clair */
  font-weight: 600;
  color: #1a237e; /* Texte en bleu foncé */
  border-bottom: 2px solid #c5cae9; /* Bordure bleu clair */
}

.factures-table th.sortable {
  cursor: pointer;
  user-select: none;
}

.factures-table th.sortable:hover {
  background-color: #c5cae9; /* Fond bleu clair au survol */
  color: #0d47a1; /* Texte bleu plus foncé */
}

.factures-table th.sortable::after {
  content: '';
  display: inline-block;
  width: 0;
  height: 0;
  margin-left: 5px;
  vertical-align: middle;
  transition: all 0.3s ease;
}

.factures-table tbody tr {
  transition: all 0.3s ease;
  animation: fadeIn 0.5s ease-out;
  animation-fill-mode: both;
}

.factures-table tbody tr:nth-child(1) { animation-delay: 0.05s; }
.factures-table tbody tr:nth-child(2) { animation-delay: 0.1s; }
.factures-table tbody tr:nth-child(3) { animation-delay: 0.15s; }
.factures-table tbody tr:nth-child(4) { animation-delay: 0.2s; }
.factures-table tbody tr:nth-child(5) { animation-delay: 0.25s; }
.factures-table tbody tr:nth-child(6) { animation-delay: 0.3s; }
.factures-table tbody tr:nth-child(7) { animation-delay: 0.35s; }
.factures-table tbody tr:nth-child(8) { animation-delay: 0.4s; }
.factures-table tbody tr:nth-child(9) { animation-delay: 0.45s; }
.factures-table tbody tr:nth-child(10) { animation-delay: 0.5s; }

.factures-table tbody tr:hover {
  background-color: #f5f7ff; /* Fond bleu très clair */
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(26, 35, 126, 0.1); /* Ombre bleu foncé */
}

/* Badges de statut */
.status-badge {
  display: inline-block;
  padding: 5px 10px;
  border-radius: 20px;
  font-size: 0.8rem;
  font-weight: 500;
  transition: all 0.3s ease;
  box-shadow: 0 2px 4px rgba(0,0,0,0.05);
  animation: pulse 2s infinite ease-in-out;
}

.status-badge.paid {
  background: linear-gradient(135deg, #e8f5e9, #c8e6c9);
  color: #2e7d32;
  border-left: 3px solid #2e7d32;
  box-shadow: 0 2px 4px rgba(46, 125, 50, 0.2);
}

.status-badge.unpaid {
  background: linear-gradient(135deg, #ffebee, #ffcdd2);
  color: #c62828;
  border-left: 3px solid #c62828;
  box-shadow: 0 2px 4px rgba(198, 40, 40, 0.2);
}

.status-badge.cancelled {
  background: linear-gradient(135deg, #eeeeee, #e0e0e0);
  color: #757575;
  border-left: 3px solid #757575;
  box-shadow: 0 2px 4px rgba(117, 117, 117, 0.2);
}

.status-badge.pending {
  background: linear-gradient(135deg, #fff8e1, #ffecb3);
  color: #ffa000; /* Texte orange */
  border-left: 3px solid #ffa000;
  box-shadow: 0 2px 4px rgba(255, 160, 0, 0.2);
}

.status-badge.accepted {
  background: linear-gradient(135deg, #e8f5e9, #c8e6c9);
  color: #2e7d32; /* Texte vert */
  border-left: 3px solid #2e7d32;
  box-shadow: 0 2px 4px rgba(46, 125, 50, 0.2);
}

.status-badge.rejected {
  background: linear-gradient(135deg, #ffebee, #ffcdd2);
  color: #c62828; /* Texte rouge */
  border-left: 3px solid #c62828;
  box-shadow: 0 2px 4px rgba(198, 40, 40, 0.2);
}

.status-badge.overdue {
  background: linear-gradient(135deg, #673ab7, #512da8);
  color: #ffffff; /* Texte blanc */
  border-left: 3px solid #311b92;
  box-shadow: 0 2px 4px rgba(49, 27, 146, 0.2);
}

/* Boutons d'action */
.actions-cell {
  display: flex;
  gap: 8px;
}

.action-btn {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  border: none;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
  box-shadow: 0 2px 5px rgba(0,0,0,0.1);
  position: relative;
  overflow: hidden;
}

.action-btn:hover {
  transform: translateY(-3px);
  box-shadow: 0 5px 10px rgba(0,0,0,0.15);
}

.action-btn::after {
  content: '';
  position: absolute;
  top: 50%;
  left: 50%;
  width: 5px;
  height: 5px;
  background: rgba(255, 255, 255, 0.5);
  opacity: 0;
  border-radius: 100%;
  transform: scale(1, 1) translate(-50%, -50%);
  transform-origin: 50% 50%;
}

.action-btn:active::after {
  animation: ripple 0.6s ease-out;
}

.action-btn.view {
  background-color: #e8eaf6; /* Fond bleu très clair */
  color: #1a237e; /* Bleu foncé */
}

.action-btn.view:hover {
  background-color: #c5cae9; /* Bleu clair au survol */
}

.action-btn.download {
  background-color: #e8f5e9;
  color: #2e7d32;
}

.action-btn.download:hover {
  background-color: #c8e6c9;
}

.action-btn.pay {
  background-color: #e3f2fd;
  color: #0d47a1;
}

.action-btn.pay:hover {
  background-color: #bbdefb;
}

.action-btn.payment {
  background-color: #e3f2fd;
  color: #0d47a1;
}

.action-btn.payment:hover {
  background-color: #bbdefb;
}

.action-btn.print {
  background-color: #7e57c2;
  color: white;
}

.action-btn.print:hover {
  background-color: #5e35b1;
}

.action-btn.share {
  background-color: #fb8c00;
  color: white;
}

.action-btn.share:hover {
  background-color: #ef6c00;
}

/* Message si aucune facture */
.no-factures {
  padding: 40px 20px;
  text-align: center;
  color: #3949ab; /* Texte bleu */
  animation: fadeIn 0.8s ease-out;
}

.no-factures i {
  font-size: 3rem;
  color: #c5cae9; /* Icône bleu clair */
  margin-bottom: 15px;
  animation: pulse 2s infinite ease-in-out;
}

.no-factures p {
  margin-bottom: 15px;
  font-weight: 500;
}

.btn-reset {
  background-color: #e8eaf6; /* Fond bleu très clair */
  border: 1px solid #c5cae9; /* Bordure bleu clair */
  border-radius: 4px;
  padding: 8px 15px;
  color: #1a237e; /* Texte bleu foncé */
  cursor: pointer;
  transition: all 0.3s ease;
  font-weight: 500;
}

.btn-reset:hover {
  background-color: #c5cae9; /* Fond bleu clair au survol */
  transform: translateY(-2px);
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
}

/* Pagination */
.pagination {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 15px;
}

.pagination-btn {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  border: 1px solid #c5cae9; /* Bordure bleu clair */
  background-color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.3s ease;
  color: #1a237e; /* Texte en bleu foncé */
}

.pagination-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.pagination-btn:not(:disabled):hover {
  background-color: #e8eaf6; /* Fond bleu très clair au survol */
  transform: translateY(-2px);
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
}

.page-info {
  font-size: 0.9rem;
  color: #666;
}

/* Responsive */
@media (max-width: 768px) {
  .advanced-search-row {
    flex-direction: column;
    gap: 10px;
  }
  
  .factures-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 10px;
  }
  
  .search-bar {
    flex-direction: column;
    align-items: stretch;
  }
  
  .search-input-container {
    margin-right: 0;
    margin-bottom: 10px;
  }
}
</style>