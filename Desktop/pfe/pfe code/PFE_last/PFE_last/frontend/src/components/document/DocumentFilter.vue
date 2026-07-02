<template>
  <div class="document-filter-container">
    <div class="filter-header">
      <h2>Filtrage et tri des documents</h2>
      <p class="filter-description">Utilisez les options avancées pour filtrer et trier vos documents</p>
    </div>

    <div class="filter-panel">
      <div class="filter-section">
        <h3 class="section-title">Filtres avancés</h3>
        
        <div class="filter-grid">
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
            <label>Période</label>
            <div class="date-range">
              <div class="date-input-group">
                <label class="sublabel">Du</label>
                <input 
                  type="date" 
                  v-model="filters.dateFrom" 
                  @change="applyFilters"
                  class="date-input"
                />
              </div>
              <div class="date-input-group">
                <label class="sublabel">Au</label>
                <input 
                  type="date" 
                  v-model="filters.dateTo" 
                  @change="applyFilters"
                  class="date-input"
                />
              </div>
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

          <div class="filter-group">
            <label>Montant</label>
            <div class="amount-range">
              <div class="amount-input-group">
                <label class="sublabel">Min</label>
                <input 
                  type="number" 
                  v-model="filters.amountMin" 
                  @change="applyFilters"
                  class="amount-input"
                  placeholder="0"
                  min="0"
                />
              </div>
              <div class="amount-input-group">
                <label class="sublabel">Max</label>
                <input 
                  type="number" 
                  v-model="filters.amountMax" 
                  @change="applyFilters"
                  class="amount-input"
                  placeholder="Max"
                  min="0"
                />
              </div>
            </div>
          </div>

          <div class="filter-group">
            <label>Mots-clés</label>
            <div class="tags-input-container">
              <input 
                type="text" 
                v-model="tagInput" 
                @keydown.enter.prevent="addTag"
                placeholder="Ajouter un mot-clé et appuyer sur Entrée"
                class="tags-input"
              />
              <div class="tags-list" v-if="filters.tags.length > 0">
                <div v-for="(tag, index) in filters.tags" :key="index" class="tag">
                  {{ tag }}
                  <button @click="removeTag(index)" class="remove-tag">&times;</button>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div class="filter-actions">
          <button @click="resetFilters" class="reset-button">
            <i class="fas fa-undo"></i> Réinitialiser les filtres
          </button>
          <button @click="applyFilters" class="apply-button">
            <i class="fas fa-check"></i> Appliquer les filtres
          </button>
        </div>
      </div>

      <div class="filter-section">
        <h3 class="section-title">Options de tri</h3>
        
        <div class="sort-options">
          <div class="sort-group">
            <label>Trier par</label>
            <select v-model="sortOptions.field" @change="applySorting">
              <option value="date">Date</option>
              <option value="name">Nom</option>
              <option value="type">Type</option>
              <option value="client">Client</option>
              <option value="amount">Montant</option>
              <option value="status">Statut</option>
            </select>
          </div>

          <div class="sort-group">
            <label>Ordre</label>
            <div class="sort-direction">
              <button 
                @click="setSortDirection('asc')" 
                :class="['sort-button', sortOptions.direction === 'asc' ? 'active' : '']">
                <i class="fas fa-sort-amount-down-alt"></i> Croissant
              </button>
              <button 
                @click="setSortDirection('desc')" 
                :class="['sort-button', sortOptions.direction === 'desc' ? 'active' : '']">
                <i class="fas fa-sort-amount-down"></i> Décroissant
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="results-section">
      <div class="results-header">
        <h3 class="section-title">Résultats ({{ filteredDocuments.length }})</h3>
        <div class="view-options">
          <button 
            @click="viewMode = 'grid'" 
            :class="['view-button', viewMode === 'grid' ? 'active' : '']">
            <i class="fas fa-th-large"></i>
          </button>
          <button 
            @click="viewMode = 'list'" 
            :class="['view-button', viewMode === 'list' ? 'active' : '']">
            <i class="fas fa-list"></i>
          </button>
        </div>
      </div>

      <div v-if="loading" class="loading-container">
        <div class="loading-spinner"></div>
        <p>Chargement des documents...</p>
      </div>

      <div v-else-if="filteredDocuments.length === 0" class="no-documents">
        <i class="fas fa-filter no-documents-icon"></i>
        <p>Aucun document ne correspond à vos critères</p>
        <button @click="resetFilters" class="reset-search-btn">
          Réinitialiser les filtres
        </button>
      </div>

      <div v-else :class="['documents-container', viewMode === 'grid' ? 'grid-view' : 'list-view']">
        <!-- Vue en grille -->
        <template v-if="viewMode === 'grid'">
          <div 
            v-for="document in paginatedDocuments" 
            :key="document.id" 
            class="document-card"
            @click="viewDocument(document)"
          >
          <div class="document-icon" :class="`document-type-${document.type}`">
            <i :class="getDocumentIcon(document.type)"></i>
          </div>
          <div class="document-info">
            <h3 class="document-title">{{ document.name }}</h3>
            <p class="document-type">{{ getDocumentTypeName(document.type) }}</p>
            <p class="document-date">{{ formatDate(document.date) }}</p>
            <p class="document-client">{{ document.client.name }}</p>
            <div class="document-amount">{{ formatAmount(document.amount) }}</div>
            <div class="document-status" :class="`status-${document.status}`">
              {{ getStatusName(document.status) }}
            </div>
          </div>
          <div class="document-actions">
            <button @click.stop="previewDocument(document)" class="action-button preview-button" title="Aperçu">
              <i class="fas fa-eye"></i>
            </button>
            <button @click.stop="downloadDocument(document)" class="action-button download-button" title="Télécharger">
              <i class="fas fa-download"></i>
            </button>
            <button @click.stop="emailDocument(document)" class="action-button email-button" title="Envoyer par email">
              <i class="fas fa-envelope"></i>
            </button>
          </div>
        </div>
        </template>

        <!-- Vue en liste -->
        <template v-if="viewMode === 'list'">
          <table class="documents-table">
            <thead>
            <tr>
              <th>Type</th>
              <th>Nom</th>
              <th>Date</th>
              <th>Client</th>
              <th>Montant</th>
              <th>Statut</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr 
              v-for="document in paginatedDocuments" 
              :key="document.id"
              @click="viewDocument(document)"
              class="document-row"
            >
              <td>
                <div class="document-type-icon" :class="`document-type-${document.type}`">
                  <i :class="getDocumentIcon(document.type)"></i>
                </div>
              </td>
              <td>{{ document.name }}</td>
              <td>{{ formatDate(document.date) }}</td>
              <td>{{ document.client.name }}</td>
              <td>{{ formatAmount(document.amount) }}</td>
              <td>
                <div class="document-status" :class="`status-${document.status}`">
                  {{ getStatusName(document.status) }}
                </div>
              </td>
              <td>
                <div class="table-actions">
                  <button @click.stop="previewDocument(document)" class="action-button preview-button" title="Aperçu">
                    <i class="fas fa-eye"></i>
                  </button>
                  <button @click.stop="downloadDocument(document)" class="action-button download-button" title="Télécharger">
                    <i class="fas fa-download"></i>
                  </button>
                  <button @click.stop="emailDocument(document)" class="action-button email-button" title="Envoyer par email">
                    <i class="fas fa-envelope"></i>
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
        </template>
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
const loading = ref(true);
const documents = ref([]);
const clients = ref([]);
const currentPage = ref(1);
const itemsPerPage = 10;
const viewMode = ref('grid');
const tagInput = ref('');

// Filters
const filters = ref({
  type: '',
  dateFrom: '',
  dateTo: '',
  client: '',
  status: '',
  amountMin: '',
  amountMax: '',
  tags: []
});

// Sort options
const sortOptions = ref({
  field: 'date',
  direction: 'desc'
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
      },
      {
        id: 7,
        name: 'Facture #2023-007',
        type: 'facture',
        date: '2023-06-05',
        client: { id: 1, name: 'Entreprise ABC' },
        status: 'overdue',
        amount: 2300.75
      },
      {
        id: 8,
        name: 'Contrat #2023-008',
        type: 'contrat',
        date: '2023-06-12',
        client: { id: 2, name: 'Société XYZ' },
        status: 'draft',
        amount: 4500
      },
      {
        id: 9,
        name: 'Bon de livraison #2023-009',
        type: 'bon_livraison',
        date: '2023-06-18',
        client: { id: 3, name: 'Client Particulier' },
        status: 'sent',
        amount: 0
      },
      {
        id: 10,
        name: 'Devis #2023-010',
        type: 'devis',
        date: '2023-06-25',
        client: { id: 1, name: 'Entreprise ABC' },
        status: 'sent',
        amount: 1850.50
      },
      {
        id: 11,
        name: 'Facture #2023-011',
        type: 'facture',
        date: '2023-07-02',
        client: { id: 2, name: 'Société XYZ' },
        status: 'paid',
        amount: 950.25
      },
      {
        id: 12,
        name: 'Contrat #2023-012',
        type: 'contrat',
        date: '2023-07-10',
        client: { id: 3, name: 'Client Particulier' },
        status: 'draft',
        amount: 3200
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

// Methods for tags
const addTag = () => {
  if (tagInput.value.trim() && !filters.value.tags.includes(tagInput.value.trim())) {
    filters.value.tags.push(tagInput.value.trim());
    tagInput.value = '';
    applyFilters();
  }
};

const removeTag = (index) => {
  filters.value.tags.splice(index, 1);
  applyFilters();
};

// Methods for filtering
const applyFilters = () => {
  currentPage.value = 1; // Reset to first page on filter change
};

const resetFilters = () => {
  filters.value = {
    type: '',
    dateFrom: '',
    dateTo: '',
    client: '',
    status: '',
    amountMin: '',
    amountMax: '',
    tags: []
  };
  applyFilters();
};

// Methods for sorting
const applySorting = () => {
  // Sorting is applied in the computed property
};

const setSortDirection = (direction) => {
  sortOptions.value.direction = direction;
  applySorting();
};

// Methods for pagination
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

// Methods for document actions
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

// Utility methods
const formatDate = (dateString) => {
  const options = { year: 'numeric', month: 'short', day: 'numeric' };
  return new Date(dateString).toLocaleDateString('fr-FR', options);
};

const formatAmount = (amount) => {
  return new Intl.NumberFormat('fr-FR', { style: 'currency', currency: 'EUR' }).format(amount);
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

// Computed properties
const filteredDocuments = computed(() => {
  let result = [...documents.value];
  
  // Apply type filter
  if (filters.value.type) {
    result = result.filter(doc => doc.type === filters.value.type);
  }
  
  // Apply date filters
  if (filters.value.dateFrom) {
    result = result.filter(doc => new Date(doc.date) >= new Date(filters.value.dateFrom));
  }
  
  if (filters.value.dateTo) {
    result = result.filter(doc => new Date(doc.date) <= new Date(filters.value.dateTo));
  }
  
  // Apply client filter
  if (filters.value.client) {
    result = result.filter(doc => doc.client.id === parseInt(filters.value.client));
  }
  
  // Apply status filter
  if (filters.value.status) {
    result = result.filter(doc => doc.status === filters.value.status);
  }
  
  // Apply amount filters
  if (filters.value.amountMin) {
    result = result.filter(doc => doc.amount >= parseFloat(filters.value.amountMin));
  }
  
  if (filters.value.amountMax) {
    result = result.filter(doc => doc.amount <= parseFloat(filters.value.amountMax));
  }
  
  // Apply tags filter
  if (filters.value.tags.length > 0) {
    result = result.filter(doc => {
      // In a real app, you would check if any of the document's tags match the filter tags
      // For this demo, we'll just check if the document name contains any of the tags
      return filters.value.tags.some(tag => 
        doc.name.toLowerCase().includes(tag.toLowerCase())
      );
    });
  }
  
  // Apply sorting
  result.sort((a, b) => {
    let comparison = 0;
    
    switch (sortOptions.value.field) {
      case 'date':
        comparison = new Date(a.date) - new Date(b.date);
        break;
      case 'name':
        comparison = a.name.localeCompare(b.name);
        break;
      case 'type':
        comparison = a.type.localeCompare(b.type);
        break;
      case 'client':
        comparison = a.client.name.localeCompare(b.client.name);
        break;
      case 'amount':
        comparison = a.amount - b.amount;
        break;
      case 'status':
        comparison = a.status.localeCompare(b.status);
        break;
      default:
        comparison = new Date(a.date) - new Date(b.date);
    }
    
    return sortOptions.value.direction === 'asc' ? comparison : -comparison;
  });
  
  return result;
});

const paginatedDocuments = computed(() => {
  const startIndex = (currentPage.value - 1) * itemsPerPage;
  const endIndex = startIndex + itemsPerPage;
  return filteredDocuments.value.slice(startIndex, endIndex);
});

const totalPages = computed(() => {
  return Math.ceil(filteredDocuments.value.length / itemsPerPage);
});
</script>

<style scoped>
.document-filter-container {
  padding: 20px;
  background-color: #f9fafb;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
}

.filter-header {
  margin-bottom: 20px;
}

.filter-header h2 {
  font-size: 1.5rem;
  color: #1e293b;
  margin-bottom: 5px;
}

.filter-description {
  color: #64748b;
  font-size: 0.9rem;
}

.filter-panel {
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
  padding: 20px;
  margin-bottom: 20px;
}

.filter-section {
  margin-bottom: 20px;
}

.filter-section:last-child {
  margin-bottom: 0;
}

.section-title {
  font-size: 1.1rem;
  color: #334155;
  margin-bottom: 15px;
  padding-bottom: 10px;
  border-bottom: 1px solid #e2e8f0;
}

.filter-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
  gap: 20px;
  margin-bottom: 20px;
}

.filter-group {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.filter-group label {
  font-size: 0.9rem;
  font-weight: 500;
  color: #475569;
}

.filter-group select,
.filter-group input,
.tags-input {
  padding: 10px;
  border: 1px solid #e2e8f0;
  border-radius: 6px;
  font-size: 0.9rem;
  color: #334155;
  background-color: #f8fafc;
  transition: all 0.2s ease;
}

.filter-group select:focus,
.filter-group input:focus,
.tags-input:focus {
  border-color: #3b82f6;
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.2);
  outline: none;
}

.date-range,
.amount-range {
  display: flex;
  gap: 10px;
}

.date-input-group,
.amount-input-group {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 5px;
}

.sublabel {
  font-size: 0.8rem;
  color: #64748b;
}

.tags-input-container {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.tags-list {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.tag {
  display: flex;
  align-items: center;
  gap: 5px;
  background-color: #e0f2fe;
  color: #0369a1;
  padding: 5px 10px;
  border-radius: 4px;
  font-size: 0.8rem;
}

.remove-tag {
  background: none;
  border: none;
  color: #0369a1;
  cursor: pointer;
  font-size: 1rem;
  line-height: 1;
  padding: 0;
}

.filter-actions {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
}

.reset-button,
.apply-button {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 10px 15px;
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

/* Styles pour la section des résultats */
.results-section {
  margin-top: 20px;
}

.results-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
}

.view-options {
  display: flex;
  gap: 5px;
}

.view-button {
  width: 36px;
  height: 36px;
  border-radius: 6px;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #f1f5f9;
  border: 1px solid #e2e8f0;
  color: #64748b;
  cursor: pointer;
  transition: all 0.2s ease;
}

.view-button:hover {
  background-color: #e2e8f0;
}


.view-button.active {
  background-color: #3b82f6;
  border-color: #2563eb;
  color: white;
}

/* Styles pour les vues de documents */
.documents-container {
  margin-bottom: 20px;
}

.grid-view {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 20px;
}

.list-view {
  display: block;
}

.documents-table {
  width: 100%;
  border-collapse: collapse;
}

.documents-table th {
  text-align: left;
  padding: 12px 15px;
  background-color: #f8fafc;
  color: #475569;
  font-size: 0.85rem;
  font-weight: 600;
  border-bottom: 1px solid #e2e8f0;
}

.documents-table td {
  padding: 12px 15px;
  border-bottom: 1px solid #e2e8f0;
  color: #334155;
  font-size: 0.9rem;
}

.document-row {
  cursor: pointer;
  transition: all 0.2s ease;
}

.document-row:hover {
  background-color: #f8fafc;
}

.document-type-icon {
  width: 36px;
  height: 36px;
  border-radius: 6px;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #f1f5f9;
}

.document-type-facture {
  color: #0369a1;
}

.document-type-devis {
  color: #7c3aed;
}

.document-type-bon_livraison {
  color: #f59e0b;
}

.document-type-contrat {
  color: #10b981;
}

.table-actions {
  display: flex;
  gap: 5px;
}

/* Styles pour les cartes de documents */
.document-card {
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
  padding: 20px;
  transition: all 0.3s ease;
  cursor: pointer;
  position: relative;
  overflow: hidden;
}

.document-card:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  transform: translateY(-2px);
}

.document-icon {
  width: 50px;
  height: 50px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 15px;
  background-color: #f1f5f9;
}

.document-info {
  margin-bottom: 15px;
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

.document-type, .document-date, .document-client {
  font-size: 0.85rem;
  color: #64748b;
  margin-bottom: 5px;
}

.document-amount {
  font-size: 0.9rem;
  font-weight: 600;
  color: #1e293b;
  margin-bottom: 10px;
}

.document-status {
  display: inline-block;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 0.75rem;
  font-weight: 500;
  margin-bottom: 10px;
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

/* Styles pour la pagination */
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

/* Styles pour les états de chargement et absence de résultats */
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

.reset-search-btn {
  margin-top: 15px;
  padding: 8px 16px;
  background-color: #f1f5f9;
  border: 1px solid #e2e8f0;
  border-radius: 6px;
  color: #334155;
  font-size: 0.9rem;
  cursor: pointer;
  transition: all 0.2s ease;
}

.reset-search-btn:hover {
  background-color: #e2e8f0;
}
</style>

