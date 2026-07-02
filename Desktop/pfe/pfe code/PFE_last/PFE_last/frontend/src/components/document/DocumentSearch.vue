<template>
  <div class="document-search-container">
    <div class="search-header">
      <h2>Recherche et affichage des documents</h2>
      <p class="search-description">Recherchez et consultez tous vos documents archivés</p>
    </div>

    <div class="search-tools">
      <div class="search-bar">
        <i class="fas fa-search search-icon"></i>
        <input 
          type="text" 
          v-model="searchQuery" 
          placeholder="Rechercher par nom, type, client..." 
          @input="handleSearch"
          class="search-input"
        />
        <button v-if="searchQuery" @click="clearSearch" class="clear-search">
          <i class="fas fa-times"></i>
        </button>
      </div>

      <div class="search-filters">
        <button @click="showFilters = !showFilters" class="filter-button">
          <i class="fas fa-filter"></i> Filtres
          <i :class="showFilters ? 'fas fa-chevron-up' : 'fas fa-chevron-down'"></i>
        </button>
      </div>
    </div>

    <div v-if="showFilters" class="filters-panel">
      <div class="filter-group">
        <label>Type de document</label>
        <select v-model="filters.type" @change="applyFilters">
          <option value="">Tous les types</option>
          <option value="facture">Facture</option>
          <option value="devis">Devis</option>
          <option value="bon_livraison">Bon de livraison</option>
          <option value="contrat">Contrat</option>
        </select>
      </div>

      <div class="filter-group">
        <label>Date</label>
        <div class="date-range">
          <input 
            type="date" 
            v-model="filters.dateFrom" 
            @change="applyFilters"
            class="date-input"
          />
          <span>à</span>
          <input 
            type="date" 
            v-model="filters.dateTo" 
            @change="applyFilters"
            class="date-input"
          />
        </div>
      </div>

      <div class="filter-group">
        <label>Client</label>
        <select v-model="filters.client" @change="applyFilters">
          <option value="">Tous les clients</option>
          <option v-for="client in clients" :key="client.id" :value="client.id">
            {{ client.name }}
          </option>
        </select>
      </div>

      <div class="filter-group">
        <label>Statut</label>
        <select v-model="filters.status" @change="applyFilters">
          <option value="">Tous les statuts</option>
          <option value="draft">Brouillon</option>
          <option value="sent">Envoyé</option>
          <option value="paid">Payé</option>
          <option value="overdue">En retard</option>
        </select>
      </div>

      <div class="filter-actions">
        <button @click="resetFilters" class="reset-button">
          <i class="fas fa-undo"></i> Réinitialiser
        </button>
        <button @click="applyFilters" class="apply-button">
          <i class="fas fa-check"></i> Appliquer
        </button>
      </div>
    </div>

    <div class="documents-list">
      <div v-if="loading" class="loading-container">
        <div class="loading-spinner"></div>
        <p>Chargement des documents...</p>
      </div>

      <div v-else-if="filteredDocuments.length === 0" class="no-documents">
        <i class="fas fa-file-alt no-documents-icon"></i>
        <p>Aucun document trouvé</p>
        <p class="no-documents-hint">Essayez de modifier vos critères de recherche</p>
      </div>

      <div v-else class="documents-grid">
        <div 
          v-for="document in filteredDocuments" 
          :key="document.id" 
          class="document-card"
          @click="viewDocument(document)"
        >
          <div class="document-icon">
            <i :class="getDocumentIcon(document.type)"></i>
          </div>
          <div class="document-info">
            <h3 class="document-title">{{ document.name }}</h3>
            <p class="document-type">{{ getDocumentTypeName(document.type) }}</p>
            <p class="document-date">{{ formatDate(document.date) }}</p>
            <p class="document-client">{{ document.client.name }}</p>
            <div class="document-status" :class="`status-${document.status}`">
              {{ getStatusName(document.status) }}
            </div>
          </div>
          <div class="document-actions">
            <button @click.stop="previewDocument(document)" class="action-button preview-button">
              <i class="fas fa-eye"></i>
            </button>
            <button @click.stop="downloadDocument(document)" class="action-button download-button">
              <i class="fas fa-download"></i>
            </button>
            <button @click.stop="emailDocument(document)" class="action-button email-button">
              <i class="fas fa-envelope"></i>
            </button>
          </div>
        </div>
      </div>

      <div v-if="filteredDocuments.length > 0" class="pagination">
        <button 
          @click="prevPage" 
          :disabled="currentPage === 1"
          class="pagination-button"
        >
          <i class="fas fa-chevron-left"></i>
        </button>
        <span class="pagination-info">Page {{ currentPage }} sur {{ totalPages }}</span>
        <button 
          @click="nextPage" 
          :disabled="currentPage === totalPages"
          class="pagination-button"
        >
          <i class="fas fa-chevron-right"></i>
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router';

// Router
const router = useRouter();

// State
const searchQuery = ref('');
const showFilters = ref(false);
const loading = ref(true);
const documents = ref([]);
const clients = ref([]);
const currentPage = ref(1);
const itemsPerPage = 12;

// Filters
const filters = ref({
  type: '',
  dateFrom: '',
  dateTo: '',
  client: '',
  status: ''
});

// Fetch documents (mock data for now)
onMounted(async () => {
  try {
    // Simulate API call
    await new Promise(resolve => setTimeout(resolve, 1000));
    
    // Mock data
    documents.value = [
      {
        id: 1,
        name: 'Facture #2023-001',
        type: 'facture',
        date: '2023-05-15',
        client: { id: 1, name: 'Entreprise ABC' },
        status: 'paid',
        amount: 1250.50
      },
      {
        id: 2,
        name: 'Devis #2023-002',
        type: 'devis',
        date: '2023-05-10',
        client: { id: 2, name: 'Société XYZ' },
        status: 'sent',
        amount: 3450.75
      },
      {
        id: 3,
        name: 'Bon de livraison #2023-003',
        type: 'bon_livraison',
        date: '2023-05-20',
        client: { id: 1, name: 'Entreprise ABC' },
        status: 'draft',
        amount: 0
      },
      {
        id: 4,
        name: 'Contrat #2023-004',
        type: 'contrat',
        date: '2023-04-30',
        client: { id: 3, name: 'Client Particulier' },
        status: 'overdue',
        amount: 5000
      },
      {
        id: 5,
        name: 'Facture #2023-005',
        type: 'facture',
        date: '2023-04-15',
        client: { id: 2, name: 'Société XYZ' },
        status: 'paid',
        amount: 750.25
      },
      {
        id: 6,
        name: 'Devis #2023-006',
        type: 'devis',
        date: '2023-04-10',
        client: { id: 3, name: 'Client Particulier' },
        status: 'sent',
        amount: 1200
      }
    ];
    
    // Mock clients
    clients.value = [
      { id: 1, name: 'Entreprise ABC' },
      { id: 2, name: 'Société XYZ' },
      { id: 3, name: 'Client Particulier' }
    ];
    
    loading.value = false;
  } catch (error) {
    console.error('Erreur lors du chargement des documents:', error);
    loading.value = false;
  }
});

// Computed
const filteredDocuments = computed(() => {
  let result = [...documents.value];
  
  // Apply search query
  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase();
    result = result.filter(doc => 
      doc.name.toLowerCase().includes(query) ||
      doc.type.toLowerCase().includes(query) ||
      doc.client.name.toLowerCase().includes(query)
    );
  }
  
  // Apply filters
  if (filters.value.type) {
    result = result.filter(doc => doc.type === filters.value.type);
  }
  
  if (filters.value.dateFrom) {
    result = result.filter(doc => new Date(doc.date) >= new Date(filters.value.dateFrom));
  }
  
  if (filters.value.dateTo) {
    result = result.filter(doc => new Date(doc.date) <= new Date(filters.value.dateTo));
  }
  
  if (filters.value.client) {
    result = result.filter(doc => doc.client.id === parseInt(filters.value.client));
  }
  
  if (filters.value.status) {
    result = result.filter(doc => doc.status === filters.value.status);
  }
  
  // Pagination
  const startIndex = (currentPage.value - 1) * itemsPerPage;
  const endIndex = startIndex + itemsPerPage;
  
  return result.slice(startIndex, endIndex);
});

const totalDocuments = computed(() => {
  let result = [...documents.value];
  
  // Apply search query
  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase();
    result = result.filter(doc => 
      doc.name.toLowerCase().includes(query) ||
      doc.type.toLowerCase().includes(query) ||
      doc.client.name.toLowerCase().includes(query)
    );
  }
  
  // Apply filters
  if (filters.value.type) {
    result = result.filter(doc => doc.type === filters.value.type);
  }
  
  if (filters.value.dateFrom) {
    result = result.filter(doc => new Date(doc.date) >= new Date(filters.value.dateFrom));
  }
  
  if (filters.value.dateTo) {
    result = result.filter(doc => new Date(doc.date) <= new Date(filters.value.dateTo));
  }
  
  if (filters.value.client) {
    result = result.filter(doc => doc.client.id === parseInt(filters.value.client));
  }
  
  if (filters.value.status) {
    result = result.filter(doc => doc.status === filters.value.status);
  }
  
  return result.length;
});

const totalPages = computed(() => {
  return Math.ceil(totalDocuments.value / itemsPerPage);
});

// Methods
const handleSearch = () => {
  currentPage.value = 1; // Reset to first page on search
};

const clearSearch = () => {
  searchQuery.value = '';
  handleSearch();
};

const applyFilters = () => {
  currentPage.value = 1; // Reset to first page on filter change
};

const resetFilters = () => {
  filters.value = {
    type: '',
    dateFrom: '',
    dateTo: '',
    client: '',
    status: ''
  };
  applyFilters();
};

const prevPage = () => {
  if (currentPage.value > 1) {
    currentPage.value--;
  }
};

const nextPage = () => {
  if (currentPage.value < totalPages.value) {
    currentPage.value++;
  }
};

const viewDocument = (document) => {
  router.push(`/admin-entreprise/document-preview?id=${document.id}`);
};

const previewDocument = (document) => {
  router.push(`/admin-entreprise/document-preview?id=${document.id}`);
};

const downloadDocument = (document) => {
  router.push(`/admin-entreprise/document-export?id=${document.id}`);
};

const emailDocument = (document) => {
  router.push(`/admin-entreprise/document-email?id=${document.id}`);
};

const formatDate = (dateString) => {
  const options = { year: 'numeric', month: 'short', day: 'numeric' };
  return new Date(dateString).toLocaleDateString('fr-FR', options);
};

const getDocumentIcon = (type) => {
  const icons = {
    'facture': 'fas fa-file-invoice-dollar',
    'devis': 'fas fa-file-contract',
    'bon_livraison': 'fas fa-truck',
    'contrat': 'fas fa-file-signature'
  };
  
  return icons[type] || 'fas fa-file-alt';
};

const getDocumentTypeName = (type) => {
  const types = {
    'facture': 'Facture',
    'devis': 'Devis',
    'bon_livraison': 'Bon de livraison',
    'contrat': 'Contrat'
  };
  
  return types[type] || 'Document';
};

const getStatusName = (status) => {
  const statuses = {
    'draft': 'Brouillon',
    'sent': 'Envoyé',
    'paid': 'Payé',
    'overdue': 'En retard'
  };
  
  return statuses[status] || 'Inconnu';
};
</script>

<style scoped>
.document-search-container {
  padding: 20px;
  background-color: #f9fafb;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
}

.search-header {
  margin-bottom: 20px;
}

.search-header h2 {
  font-size: 1.5rem;
  color: #1e293b;
  margin-bottom: 5px;
}

.search-description {
  color: #64748b;
  font-size: 0.9rem;
}

.search-tools {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.search-bar {
  flex: 1;
  position: relative;
  max-width: 500px;
}

.search-icon {
  position: absolute;
  left: 12px;
  top: 50%;
  transform: translateY(-50%);
  color: #64748b;
}

.search-input {
  width: 100%;
  padding: 10px 40px 10px 35px;
  border: 1px solid #e2e8f0;
  border-radius: 6px;
  font-size: 0.9rem;
  transition: all 0.3s ease;
}

.search-input:focus {
  border-color: #3b82f6;
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.2);
  outline: none;
}

.clear-search {
  position: absolute;
  right: 10px;
  top: 50%;
  transform: translateY(-50%);
  background: none;
  border: none;
  color: #64748b;
  cursor: pointer;
  padding: 5px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.clear-search:hover {
  background-color: #f1f5f9;
}

.filter-button {
  display: flex;
  align-items: center;
  gap: 8px;
  background-color: #f1f5f9;
  border: 1px solid #e2e8f0;
  border-radius: 6px;
  padding: 8px 16px;
  font-size: 0.9rem;
  color: #334155;
  cursor: pointer;
  transition: all 0.2s ease;
}

.filter-button:hover {
  background-color: #e2e8f0;
}

.filters-panel {
  background-color: #ffffff;
  border: 1px solid #e2e8f0;
  border-radius: 8px;
  padding: 20px;
  margin-bottom: 20px;
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  gap: 20px;
  animation: slideDown 0.3s ease-out forwards;
}

.filter-group {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.filter-group label {
  font-size: 0.85rem;
  font-weight: 500;
  color: #475569;
}

.filter-group select,
.filter-group input {
  padding: 8px 12px;
  border: 1px solid #e2e8f0;
  border-radius: 6px;
  font-size: 0.9rem;
  color: #334155;
  background-color: #f8fafc;
  transition: all 0.2s ease;
}

.filter-group select:focus,
.filter-group input:focus {
  border-color: #3b82f6;
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.2);
  outline: none;
}

.date-range {
  display: flex;
  align-items: center;
  gap: 8px;
}

.date-range span {
  color: #64748b;
  font-size: 0.8rem;
}

.date-input {
  flex: 1;
  min-width: 0;
}

.filter-actions {
  grid-column: 1 / -1;
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  margin-top: 10px;
}

.reset-button,
.apply-button {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 16px;
  border-radius: 6px;
  font-size: 0.9rem;
  cursor: pointer;
  transition: all 0.2s ease;
}

.reset-button {
  background-color: #f1f5f9;
  border: 1px solid #e2e8f0;
  color: #64748b;
}

.reset-button:hover {
  background-color: #e2e8f0;
}

.apply-button {
  background-color: #3b82f6;
  border: 1px solid #2563eb;
  color: white;
}

.apply-button:hover {
  background-color: #2563eb;
}

.loading-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 40px;
  color: #64748b;
}

.loading-spinner {
  width: 40px;
  height: 40px;
  border: 3px solid #e2e8f0;
  border-top: 3px solid #3b82f6;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin-bottom: 15px;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.no-documents {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 40px;
  color: #64748b;
  text-align: center;
}

.no-documents-icon {
  font-size: 3rem;
  margin-bottom: 15px;
  color: #94a3b8;
}

.no-documents-hint {
  font-size: 0.9rem;
  margin-top: 5px;
  color: #94a3b8;
}

.documents-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 20px;
  margin-bottom: 20px;
}

.document-card {
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
  padding: 20px;
  transition: all 0.3s ease;
  cursor: pointer;
  position: relative;
  overflow: hidden;
  display: flex;
  flex-direction: column;
}

.document-card:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  transform: translateY(-2px);
}

.document-card:hover .document-actions {
  opacity: 1;
  transform: translateY(0);
}

.document-icon {
  width: 50px;
  height: 50px;
  background-color: #f1f5f9;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 15px;
}

.document-icon i {
  font-size: 1.5rem;
  color: #3b82f6;
}

.document-info {
  flex: 1;
}

.document-title {
  font-size: 1.1rem;
  font-weight: 600;
  color: #1e293b;
  margin-bottom: 5px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.document-type {
  font-size: 0.85rem;
  color: #64748b;
  margin-bottom: 8px;
}

.document-date {
  font-size: 0.85rem;
  color: #64748b;
  margin-bottom: 5px;
}

.document-client {
  font-size: 0.85rem;
  color: #334155;
  font-weight: 500;
  margin-bottom: 10px;
}

.document-status {
  display: inline-block;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 0.75rem;
  font-weight: 500;
}

.status-draft {
  background-color: #f1f5f9;
  color: #475569;
}

.status-sent {
  background-color: #e0f2fe;
  color: #0369a1;
}

.status-paid {
  background-color: #dcfce7;
  color: #166534;
}

.status-overdue {
  background-color: #fee2e2;
  color: #b91c1c;
}

.document-actions {
  display: flex;
  gap: 10px;
  margin-top: 15px;
  opacity: 0;
  transform: translateY(10px);
  transition: all 0.3s ease;
}

.action-button {
  width: 36px;
  height: 36px;
  border-radius: 6px;
  display: flex;
  align-items: center;
  justify-content: center;
  border: none;
  cursor: pointer;
  transition: all 0.2s ease;
}

.preview-button {
  background-color: #f1f5f9;
  color: #334155;
}

.preview-button:hover {
  background-color: #e2e8f0;
}

.download-button {
  background-color: #e0f2fe;
  color: #0369a1;
}

.download-button:hover {
  background-color: #bae6fd;
}

.email-button {
  background-color: #f0fdf4;
  color: #166534;
}

.email-button:hover {
  background-color: #dcfce7;
}

.pagination {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 15px;
  margin-top: 20px;
}

.pagination-button {
  width: 36px;
  height: 36px;
  border-radius: 6px;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #f1f5f9;
  border: 1px solid #e2e8f0;
  color: #334155;
  cursor: pointer;
  transition: all 0.2s ease;
}

.pagination-button:hover:not(:disabled) {
  background-color: #e2e8f0;
}

.pagination-button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.pagination-info {
  font-size: 0.9rem;
  color: #64748b;
}

@keyframes slideDown {
  from {
    opacity: 0;
    transform: translateY(-10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
</style>