<template>
  <div class="document-export-container">
    <div class="export-header">
      <h2>Exportation et téléchargement de documents</h2>
      <p class="export-description">Exportez vos documents en différents formats et téléchargez-les</p>
    </div>

    <div class="export-tools">
      <div class="search-bar">
        <i class="fas fa-search search-icon"></i>
        <input 
          type="text" 
          v-model="searchQuery" 
          placeholder="Rechercher un document..." 
          @input="handleSearch"
          class="search-input"
        />
        <button v-if="searchQuery" @click="clearSearch" class="clear-search">
          <i class="fas fa-times"></i>
        </button>
      </div>
    </div>

    <div class="documents-list">
      <div v-if="loading" class="loading-container">
        <div class="loading-spinner"></div>
        <p>Chargement des documents...</p>
      </div>

      <div v-else-if="filteredDocuments.length === 0" class="no-documents">
        <i class="fas fa-file-export no-documents-icon"></i>
        <p>Aucun document trouvé</p>
        <p class="no-documents-hint">Essayez de modifier vos critères de recherche</p>
      </div>

      <div v-else class="documents-grid">
        <div 
          v-for="document in filteredDocuments" 
          :key="document.id" 
          class="document-card"
        >
          <div class="document-icon" :class="`document-type-${document.type}`">
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
            <button @click="previewDocument(document)" class="action-button preview-button" title="Aperçu">
              <i class="fas fa-eye"></i>
            </button>
            <button @click="downloadDocument(document)" class="action-button download-button" title="Télécharger">
              <i class="fas fa-download"></i>
            </button>
            <button @click="exportToPdf(document)" class="action-button export-button" title="Exporter en PDF">
              <i class="fas fa-file-pdf"></i>
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

    <!-- Modal d'exportation -->
    <div v-if="showExportModal" class="export-modal-overlay" @click="closeExportModal">
      <div class="export-modal" @click.stop>
        <div class="modal-header">
          <h3>Options d'exportation</h3>
          <button @click="closeExportModal" class="close-modal">
            <i class="fas fa-times"></i>
          </button>
        </div>
        <div class="modal-body">
          <div class="form-group">
            <label>Format d'exportation</label>
            <div class="format-options">
              <div 
                class="format-option" 
                :class="{ 'selected': exportFormat === 'pdf' }"
                @click="exportFormat = 'pdf'"
              >
                <i class="fas fa-file-pdf"></i>
                <span>PDF</span>
              </div>
              <div 
                class="format-option" 
                :class="{ 'selected': exportFormat === 'excel' }"
                @click="exportFormat = 'excel'"
              >
                <i class="fas fa-file-excel"></i>
                <span>Excel</span>
              </div>
              <div 
                class="format-option" 
                :class="{ 'selected': exportFormat === 'csv' }"
                @click="exportFormat = 'csv'"
              >
                <i class="fas fa-file-csv"></i>
                <span>CSV</span>
              </div>
            </div>
          </div>
          <div class="form-group">
            <label>Options</label>
            <div class="checkbox-group">
              <input type="checkbox" id="includeHeader" v-model="exportOptions.includeHeader" />
              <label for="includeHeader">Inclure l'en-tête</label>
            </div>
            <div class="checkbox-group">
              <input type="checkbox" id="includeFooter" v-model="exportOptions.includeFooter" />
              <label for="includeFooter">Inclure le pied de page</label>
            </div>
            <div class="checkbox-group">
              <input type="checkbox" id="includeSignature" v-model="exportOptions.includeSignature" />
              <label for="includeSignature">Inclure la signature</label>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button @click="closeExportModal" class="cancel-button">
            Annuler
          </button>
          <button @click="confirmExport" class="export-button" :disabled="isExporting">
            <i class="fas fa-file-export"></i> 
            {{ isExporting ? 'Exportation en cours...' : 'Exporter' }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import documentService from '@/services/documentService';

// Router
const router = useRouter();

// State
const searchQuery = ref('');
const loading = ref(true);
const documents = ref([]);
const currentPage = ref(1);
const itemsPerPage = 12;
const showExportModal = ref(false);
const selectedDocument = ref(null);
const exportFormat = ref('pdf');
const isExporting = ref(false);

// Export options
const exportOptions = ref({
  includeHeader: true,
  includeFooter: true,
  includeSignature: false
});

// Fetch documents
onMounted(async () => {
  try {
    loading.value = true;
    const response = await documentService.getDocuments();
    documents.value = response.data.documents;
    loading.value = false;
  } catch (error) {
    console.error('Erreur lors du chargement des documents:', error);
    loading.value = false;
  }
});

// Computed properties
const filteredDocuments = computed(() => {
  if (!searchQuery.value) {
    return paginatedDocuments.value;
  }
  
  const query = searchQuery.value.toLowerCase();
  const filtered = documents.value.filter(doc => 
    doc.name.toLowerCase().includes(query) ||
    doc.client.name.toLowerCase().includes(query) ||
    getDocumentTypeName(doc.type).toLowerCase().includes(query)
  );
  
  return filtered.slice(
    (currentPage.value - 1) * itemsPerPage,
    currentPage.value * itemsPerPage
  );
});

const paginatedDocuments = computed(() => {
  return documents.value.slice(
    (currentPage.value - 1) * itemsPerPage,
    currentPage.value * itemsPerPage
  );
});

const totalPages = computed(() => {
  return Math.ceil(documents.value.length / itemsPerPage);
});

// Methods
const handleSearch = () => {
  currentPage.value = 1;
};

const clearSearch = () => {
  searchQuery.value = '';
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

const previewDocument = (document) => {
  router.push({
    path: '/admin-entreprise/document-preview',
    query: { id: document.id }
  });
};

const downloadDocument = async (document) => {
  try {
    const response = await documentService.downloadDocument(document.id);
    alert(response.message);
  } catch (error) {
    console.error('Erreur lors du téléchargement:', error);
    alert('Erreur lors du téléchargement du document');
  }
};

const exportToPdf = (document) => {
  selectedDocument.value = document;
  showExportModal.value = true;
};

const closeExportModal = () => {
  showExportModal.value = false;
};

const confirmExport = async () => {
  try {
    isExporting.value = true;
    
    // Appel au service pour exporter le document
    const response = await documentService.exportDocumentToPdf(
      selectedDocument.value.id, 
      exportFormat.value,
      exportOptions.value
    );
    
    // Afficher le message de succès
    alert(response.message);
    
    // Fermer la modal
    showExportModal.value = false;
    isExporting.value = false;
  } catch (error) {
    console.error('Erreur lors de l\'exportation:', error);
    alert('Erreur lors de l\'exportation du document');
    isExporting.value = false;
  }
};

// Utility methods
const formatDate = (dateString) => {
  const options = { year: 'numeric', month: 'long', day: 'numeric' };
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
.document-export-container {
  padding: 20px;
  height: 100%;
  display: flex;
  flex-direction: column;
}

.export-header {
  margin-bottom: 20px;
}

.export-header h2 {
  font-size: 1.5rem;
  color: #1e293b;
  margin-bottom: 5px;
}

.export-description {
  color: #64748b;
  font-size: 0.9rem;
}

.export-tools {
  display: flex;
  justify-content: space-between;
  margin-bottom: 20px;
}

.search-bar {
  position: relative;
  width: 100%;
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
  border-radius: 8px;
  font-size: 0.9rem;
  color: #334155;
  background-color: #f8fafc;
  transition: all 0.2s ease;
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
  font-size: 0.9rem;
}

.documents-list {
  flex: 1;
  overflow-y: auto;
}

.loading-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 200px;
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
  height: 200px;
  color: #64748b;
  text-align: center;
}

.no-documents-icon {
  font-size: 3rem;
  color: #94a3b8;
  margin-bottom: 15px;
}

.no-documents-hint {
  font-size: 0.9rem;
  color: #94a3b8;
  margin-top: 5px;
}

.documents-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 20px;
}

.document-card {
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
  padding: 15px;
  transition: all 0.2s ease;
  position: relative;
  border: 1px solid #e2e8f0;
}

.document-card:hover {
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  transform: translateY(-2px);
}

.document-icon {
  width: 40px;
  height: 40px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 10px;
  font-size: 1.2rem;
}

.document-type-facture {
  background-color: #e0f2fe;
  color: #0369a1;
}

.document-type-devis {
  background-color: #f3e8ff;
  color: #7c3aed;
}

.document-type-bon_livraison {
  background-color: #fef3c7;
  color: #d97706;
}

.document-type-contrat {
  background-color: #dcfce7;
  color: #16a34a;
}

.document-info {
  margin-bottom: 15px;
}

.document-title {
  font-size: 1.1rem;
  font-weight: 600;
  color: #1e293b;
  margin: 0 0 5px 0;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.document-type,
.document-date,
.document-client {
  font-size: 0.9rem;
  color: #64748b;
  margin: 3px 0;
}

.document-status {
  display: inline-block;
  padding: 3px 8px;
  border-radius: 4px;
  font-size: 0.8rem;
  font-weight: 500;
  margin-top: 5px;
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
  color: #16a34a;
}

.status-overdue {
  background-color: #fee2e2;
  color: #dc2626;
}

.document-actions {
  display: flex;
  gap: 5px;
  position: absolute;
  top: 15px;
  right: 15px;
}

.action-button {
  width: 30px;
  height: 30px;
  border-radius: 4px;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #f8fafc;
  border: 1px solid #e2e8f0;
  color: #64748b;
  cursor: pointer;
  transition: all 0.2s ease;
}

.preview-button:hover {
  background-color: #e0f2fe;
  color: #0369a1;
  border-color: #bae6fd;
}

.download-button:hover {
  background-color: #dcfce7;
  color: #16a34a;
  border-color: #bbf7d0;
}

.export-button:hover {
  background-color: #fef3c7;
  color: #d97706;
  border-color: #fde68a;
}

.pagination {
  display: flex;
  justify-content: center;
  align-items: center;
  margin-top: 20px;
  padding: 10px 0;
}

.pagination-button {
  width: 30px;
  height: 30px;
  border-radius: 4px;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #f8fafc;
  border: 1px solid #e2e8f0;
  color: #64748b;
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
  margin: 0 10px;
  font-size: 0.9rem;
  color: #64748b;
}

/* Modal Styles */
.export-modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.export-modal {
  background-color: white;
  border-radius: 8px;
  width: 500px;
  max-width: 90%;
  max-height: 90vh;
  overflow-y: auto;
  box-shadow: 0 10px 15px rgba(0, 0, 0, 0.1);
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px 20px;
  border-bottom: 1px solid #e2e8f0;
}

.modal-header h3 {
  margin: 0;
  font-size: 1.2rem;
  color: #1e293b;
}

.close-modal {
  background: none;
  border: none;
  color: #64748b;
  font-size: 1.2rem;
  cursor: pointer;
}

.modal-body {
  padding: 20px;
}

.form-group {
  margin-bottom: 20px;
}

.form-group label {
  display: block;
  margin-bottom: 10px;
  font-size: 0.9rem;
  color: #475569;
  font-weight: 500;
}

.format-options {
  display: flex;
  gap: 15px;
}

.format-option {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 15px;
  border: 2px solid #e2e8f0;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.2s ease;
}

.format-option i {
  font-size: 2rem;
  margin-bottom: 10px;
  color: #64748b;
}

.format-option span {
  font-size: 0.9rem;
  color: #475569;
  font-weight: 500;
}

.format-option.selected {
  border-color: #3b82f6;
  background-color: #eff6ff;
}

.format-option.selected i,
.format-option.selected span {
  color: #3b82f6;
}

.format-option:hover:not(.selected) {
  border-color: #cbd5e1;
  background-color: #f8fafc;
}

.checkbox-group {
  display: flex;
  align-items: center;
  margin-bottom: 10px;
}

.checkbox-group input {
  margin-right: 10px;
}

.checkbox-group label {
  margin: 0;
  font-size: 0.9rem;
  color: #475569;
  font-weight: normal;
}

.modal-footer {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  padding: 15px 20px;
  border-top: 1px solid #e2e8f0;
}

.cancel-button,
.export-button {
  padding: 8px 16px;
  border-radius: 6px;
  font-size: 0.9rem;
  font-weight: 500;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 8px;
  transition: all 0.2s ease;
}

.cancel-button {
  background-color: #f1f5f9;
  border: 1px solid #e2e8f0;
  color: #64748b;
}

.cancel-button:hover {
  background-color: #e2e8f0;
}

.export-button {
  background-color: #f59e0b;
  border: 1px solid #d97706;
  color: white;
}

.export-button:hover:not(:disabled) {
  background-color: #d97706;
}

.export-button:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}
</style>