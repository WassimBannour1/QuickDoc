<template>
  <div class="document-list-container">
    <div class="document-list-header">
      <div class="header-left">
        <button class="back-button" @click="goBackToStep1">
          <i class="fas fa-arrow-left"></i>
          Retour
        </button>
        <h2 class="animated-title">Liste des {{ documentTypeLabel }}</h2>
      </div>
      <button class="create-button" @click="createNewDocument">
        <i class="fas fa-plus"></i>
        Créer une nouvelle {{ documentTypeLabel.toLowerCase() }}
      </button>
    </div>

    <!-- Barre de recherche et filtres -->
    <div class="search-filter-container">
      <div class="search-box">
        <i class="fas fa-search search-icon"></i>
        <input 
          type="text" 
          v-model="searchQuery" 
          placeholder="Rechercher par numéro de série ou client..." 
          @input="handleSearch"
          class="search-input"
        />
        <button v-if="searchQuery" @click="clearSearch" class="clear-search-btn">
          <i class="fas fa-times"></i>
        </button>
      </div>
    </div>

    <div class="document-table-container">
      <!-- Indicateur de chargement -->
      <div v-if="loading" class="loading-indicator">
        <i class="fas fa-spinner fa-spin"></i>
        <p>Chargement des données...</p>
      </div>
      
      <!-- Tableau des documents -->
      <table class="document-table" v-else-if="documents.length > 0">
        <thead>
          <tr>
            <th>#</th>
            <th>Numéro de série</th>
            <th>Client</th>
            <th>Date</th>
            <th>Montant TTC</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(document, index) in documents" :key="document.id" class="document-row">
            <td>{{ index + 1 }}</td>
            <td>{{ document.serie_number }}</td>
            <td>{{ document.client }}</td>
            <td>{{ formatDate(document.date) }}</td>
            <td>{{ formatAmount(document.montant_ttc) }} €</td>
            <td class="actions-cell">
              <button class="action-btn edit-btn" title="Modifier" @click="editDocument(document.id)">
                <i class="fas fa-edit"></i>
              </button>
              <button class="action-btn delete-btn" title="Supprimer" @click="confirmDeleteDocument(document.id)">
                <i class="fas fa-trash"></i>
              </button>
            </td>
          </tr>
        </tbody>
      </table>
      
      <!-- Message si aucun document -->
      <div v-else class="no-documents">
        <i class="fas fa-file-alt no-documents-icon"></i>
        <p>Aucun {{ documentTypeLabel.toLowerCase() }} trouvé</p>
      </div>
    </div>
    
    <!-- Modal de notification -->
    <NotificationModal
      :visible="showNotification"
      :title="documentTypeLabel"
      :message="notificationMessage"
      :type="notificationType"
      :showActions="showActions"
      confirmText="Supprimer"
      cancelText="Annuler"
      @close="closeNotificationModal"
      @confirm="confirmAction"
    />
    
    <!-- Composant d'édition -->
    <DocumentEdit
      v-if="showEditModal"
      :documentId="selectedDocumentId"
      :documentType="typeDocument"
      @back="closeEditModal"
      @updated="handleDocumentUpdated"
      @archive="handleDocumentArchive"
    />
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue';
import axios from 'axios';
import NotificationModal from '../common/NotificationModal.vue';
import DocumentEdit from './DocumentEdit.vue';

// Propriétés reçues du composant parent
const props = defineProps({
  typeDocument: {
    type: String,
    required: true,
    validator: (value) => ['facture', 'devis'].includes(value)
  }
});

// Émetteur d'événements pour signaler le passage à l'étape 1, 3 ou 7
const emit = defineEmits(['nextStep', 'backToStep1', 'goToPreview']);

// État pour les documents et le chargement
const documents = ref([]);
const loading = ref(false);
const error = ref(null);

// État pour la recherche
const searchQuery = ref('');
const searchTimeout = ref(null);

// État pour la modal de notification
const showNotification = ref(false);
const notificationMessage = ref('');
const notificationType = ref('info');
const showActions = ref(false);
const documentToDelete = ref(null);

// État pour l'édition de document
const showEditModal = ref(false);
const selectedDocumentId = ref(null);

// Libellé du type de document (pour l'affichage)
const documentTypeLabel = computed(() => {
  return props.typeDocument === 'facture' ? 'Factures' : 'Devis';
});

// Formatage du montant
const formatAmount = (amount) => {
  return parseFloat(amount).toLocaleString('fr-FR', {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2
  });
};

// Formatage de la date
const formatDate = (dateString) => {
  if (!dateString) return '';
  const date = new Date(dateString);
  return date.toLocaleDateString('fr-FR', {
    day: '2-digit',
    month: '2-digit',
    year: 'numeric'
  });
};

// Fonction pour charger les documents depuis l'API
const fetchDocuments = async () => {
  loading.value = true;
  error.value = null;
  
  try {
    // Construire l'URL avec les paramètres de recherche si nécessaire
    let url = `/api/primerie/documents/${props.typeDocument}`;
    if (searchQuery.value) {
      url += `?search=${encodeURIComponent(searchQuery.value)}`;
    }
    
    // Appel à l'API pour récupérer les documents
    const response = await axios.get(url, {
      headers: {
        'Authorization': `Bearer ${localStorage.getItem('token')}`
      }
    });
    
    if (response.data.success) {
      documents.value = response.data.data;
    } else {
      error.value = response.data.message || 'Erreur lors du chargement des documents';
      showNotificationModal('error', error.value);
    }
  } catch (err) {
    console.error('Erreur lors de la récupération des documents:', err);
    error.value = err.response?.data?.message || 'Erreur de connexion au serveur';
    showNotificationModal('error', error.value);
  } finally {
    loading.value = false;
  }
};

// Fonction pour gérer la recherche avec debounce
const handleSearch = () => {
  // Annuler le timeout précédent s'il existe
  if (searchTimeout.value) {
    clearTimeout(searchTimeout.value);
  }
  
  // Définir un nouveau timeout pour éviter trop d'appels API
  searchTimeout.value = setTimeout(() => {
    fetchDocuments();
  }, 300); // Attendre 300ms après la dernière frappe
};

// Fonction pour effacer la recherche
const clearSearch = () => {
  searchQuery.value = '';
  fetchDocuments();
};

// Fonction pour créer un nouveau document (passer à l'étape 3)
const createNewDocument = () => {
  emit('nextStep', props.typeDocument);
};

// Fonction pour revenir à l'étape 1
const goBackToStep1 = () => {
  emit('backToStep1');
};

// Fonction pour supprimer un document
const deleteDocument = async (documentId) => {
  try {
    const response = await axios.delete(`/api/primerie/document/${documentId}`, {
      headers: {
        'Authorization': `Bearer ${localStorage.getItem('token')}`
      }
    });
    
    if (response.data.success) {
      // Rafraîchir la liste des documents
      fetchDocuments();
      showNotificationModal('success', 'Document supprimé avec succès');
    } else {
      showNotificationModal('error', response.data.message || 'Erreur lors de la suppression');
    }
  } catch (err) {
    console.error('Erreur lors de la suppression du document:', err);
    showNotificationModal('error', err.response?.data?.message || 'Erreur de connexion au serveur');
  }
};

// Fonction pour confirmer la suppression d'un document
const confirmDeleteDocument = (documentId) => {
  documentToDelete.value = documentId;
  showNotificationModal('warning', 'Êtes-vous sûr de vouloir supprimer ce document ?', true);
};

// Fonction pour éditer un document
const editDocument = (documentId) => {
  selectedDocumentId.value = documentId;
  showEditModal.value = true;
};

// Fonction pour fermer la modal d'édition
const closeEditModal = () => {
  showEditModal.value = false;
  selectedDocumentId.value = null;
};

// Fonction pour gérer la mise à jour d'un document
const handleDocumentUpdated = () => {
  closeEditModal();
  fetchDocuments();
  showNotificationModal('success', 'Document mis à jour avec succès');
};

// Fonction pour gérer l'archivage d'un document et passer à l'aperçu
const handleDocumentArchive = (documentData) => {
  closeEditModal();
  // Émettre un événement pour passer à l'étape 7 (aperçu) avec les données du document
  emit('goToPreview', documentData);
};

// Fonction pour afficher la modal de notification
const showNotificationModal = (type, message, withActions = false) => {
  notificationType.value = type;
  notificationMessage.value = message;
  showActions.value = withActions;
  showNotification.value = true;
};

// Fonction pour confirmer l'action dans la modal
const confirmAction = () => {
  if (documentToDelete.value) {
    deleteDocument(documentToDelete.value);
    documentToDelete.value = null;
  }
};

// Fonction pour fermer la modal de notification
const closeNotificationModal = () => {
  showNotification.value = false;
  documentToDelete.value = null;
};

// Charger les documents au montage du composant
onMounted(() => {
  fetchDocuments();
});
</script>

<style scoped>
.document-list-container {
  padding: 2rem;
  background-color: #f9fafc;
  border-radius: 10px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
}

.document-list-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 2rem;
  gap: 2.5rem;
}

.header-left {
  display: flex;
  align-items: center;
  gap: 2.5rem;
  flex: 1;
  justify-content: flex-start;
  padding-left: 3rem;
}

.back-button {
  background: linear-gradient(135deg, #002446, #003a6c);
  color: white;
  border: none;
  border-radius: 25px;
  padding: 0.8rem 1.5rem;
  font-size: 1rem;
  font-weight: 500;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  transition: all 0.3s ease;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.back-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
}

.animated-title {
  color: #002446;
  font-size: 1.8rem;
  font-weight: 600;
  position: relative;
  animation: fadeIn 0.5s ease forwards;
  text-align: center;
  flex: 1;
}

.create-button {
  background: linear-gradient(135deg, #002446, #003a6c);
  color: white;
  border: none;
  border-radius: 25px;
  padding: 0.8rem 1.5rem;
  font-size: 1rem;
  font-weight: 500;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  transition: all 0.3s ease;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.create-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
}

.create-button i {
  font-size: 0.9rem;
}

/* Tableau des documents */
.document-table-container {
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  overflow: hidden;
  transition: all 0.3s ease;
}

.document-table-container:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.12);
}

.document-table {
  width: 100%;
  border-collapse: collapse;
  text-align: left;
}

.document-table th,
.document-table td {
  padding: 1rem;
  border-bottom: 1px solid #eaedf3;
}

.document-table th {
  background-color: #f5f7fa;
  color: #4a5568;
  font-weight: 600;
  font-size: 0.9rem;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.document-table tbody tr {
  transition: background-color 0.2s ease;
  animation: fadeIn 0.5s ease forwards;
}

.document-table tbody tr:hover {
  background-color: #f0f8ff;
}

.document-row {
  animation-fill-mode: both;
}

.document-row:nth-child(1) { animation-delay: 0.05s; }
.document-row:nth-child(2) { animation-delay: 0.1s; }
.document-row:nth-child(3) { animation-delay: 0.15s; }
.document-row:nth-child(4) { animation-delay: 0.2s; }
.document-row:nth-child(5) { animation-delay: 0.25s; }

.actions-cell {
  display: flex;
  gap: 0.5rem;
  justify-content: center;
}

.action-btn {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  border: none;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.2s ease;
  color: white;
}

.edit-btn {
  background-color: #4299e1;
}

.delete-btn {
  background-color: #e53e3e;
}

.action-btn:hover {
  transform: scale(1.1);
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
}

.no-documents {
  padding: 3rem;
  text-align: center;
  color: #718096;
}

.no-documents-icon {
  font-size: 3rem;
  margin-bottom: 1rem;
  opacity: 0.5;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* Indicateur de chargement */
.loading-indicator {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 3rem;
  color: #718096;
  animation: fadeIn 0.5s ease forwards;
}

.loading-indicator i {
  font-size: 2rem;
  margin-bottom: 1rem;
  color: #002446;
}

.loading-indicator p {
  font-size: 1rem;
}

/* Animation de rotation pour le spinner */
@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.fa-spin {
  animation: spin 1s linear infinite;
}

/* Styles pour la barre de recherche et filtres */
.search-filter-container {
  margin-bottom: 1.5rem;
  background-color: white;
  border-radius: 8px;
  padding: 1rem;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  transition: all 0.3s ease;
}

.search-filter-container:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.12);
}

.search-box {
  position: relative;
  display: flex;
  align-items: center;
}

.search-icon {
  position: absolute;
  left: 12px;
  color: #718096;
}

.search-input {
  width: 100%;
  padding: 0.8rem 1rem 0.8rem 2.5rem;
  border: 1px solid #e2e8f0;
  border-radius: 25px;
  font-size: 1rem;
  transition: all 0.2s ease;
  color: #4a5568;
}

.search-input:focus {
  outline: none;
  border-color: #002446;
  box-shadow: 0 0 0 3px rgba(0, 36, 70, 0.1);
}

.clear-search-btn {
  position: absolute;
  right: 12px;
  background: none;
  border: none;
  color: #718096;
  cursor: pointer;
  font-size: 0.9rem;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 20px;
  height: 20px;
  border-radius: 50%;
  transition: all 0.2s ease;
}

.clear-search-btn:hover {
  background-color: #e2e8f0;
  color: #4a5568;
}
</style>