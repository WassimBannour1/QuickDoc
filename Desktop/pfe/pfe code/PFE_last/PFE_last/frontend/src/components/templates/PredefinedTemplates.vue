<template>
  <div class="predefined-templates">
    <h2 class="section-title">Modèles Prédéfinis</h2>
    <p class="section-description">Sélectionnez un modèle prédéfini pour votre {{ documentType }}</p>
    
    <div class="search-filter-container">
      <div class="search-box">
        <i class="fas fa-search"></i>
        <input 
          type="text" 
          v-model="searchQuery" 
          placeholder="Rechercher un modèle..." 
          @input="filterTemplates"
        >
      </div>
    </div>
    
    <div v-if="loading" class="loading-container">
      <div class="spinner"></div>
      <p>Chargement des modèles...</p>
    </div>
    
    <div v-else-if="filteredTemplates.length === 0" class="no-templates">
      <i class="fas fa-search"></i>
      <p>Aucun modèle trouvé. Veuillez modifier vos critères de recherche.</p>
    </div>
    
    <div v-else class="templates-grid">
      <div 
        v-for="template in filteredTemplates" 
        :key="template.id"
        class="template-card"
        :class="{ 'selected': selectedTemplate && selectedTemplate.id === template.id }"
        @click="selectTemplate(template)"
      >
        <div class="badge-container">
          <span class="doc-type-badge">{{ getDocumentTypeLabel(template) }}</span>
        </div>
        <div class="template-preview">
          <div class="template-name-placeholder">
            {{ template.name }}
          </div>
        </div>
        <div class="template-info">
          <h3>{{ template.name }}</h3>
          <div class="template-meta">
            <span class="template-category">{{ getCategoryLabel(template) }}</span>
          </div>
          <div class="template-actions">
            <button class="btn-icon" @click.stop="previewTemplate(template)" title="Aperçu">
              <i class="fas fa-eye"></i>
            </button>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Preview Modal -->
    <div v-if="showPreviewModal" class="modal-overlay" @click="closePreviewModal">
      <div class="modal-content" @click.stop>
        <div class="modal-header">
          <h3>{{ selectedPreviewTemplate ? selectedPreviewTemplate.name : 'Aperçu du modèle' }}</h3>
          <button class="btn-close" @click="closePreviewModal">
            <i class="fas fa-times"></i>
          </button>
        </div>
        
        <div class="modal-body">
          <iframe 
            v-if="previewHtml" 
            :srcdoc="previewHtml" 
            class="preview-frame"
          ></iframe>
          <div v-else class="preview-placeholder">
            <div class="spinner"></div>
            <p>Chargement de l'aperçu...</p>
          </div>
        </div>
        
        <div class="modal-footer">
          <button class="btn-primary" @click="closePreviewModal">Fermer</button>
        </div>
      </div>
    </div>
    
    <div class="action-buttons">
      <button class="btn-secondary" @click="$emit('go-back')">Retour</button>
    </div>
  </div>
</template>

<script>
import { getPredefinedTemplates } from '@/services/templateService';

export default {
  name: 'PredefinedTemplates',
  props: {
    documentType: {
      type: String,
      required: true,
      validator: value => ['devis', 'facture'].includes(value)
    }
  },
  data() {
    return {
      templates: [],
      filteredTemplates: [],
      selectedTemplate: null,
      searchQuery: '',
      loading: true,
      showPreviewModal: false,
      selectedPreviewTemplate: null,
      previewHtml: null
    };
  },
  async created() {
    try {
      await this.fetchTemplates();
    } catch (error) {
      console.error('Error fetching templates:', error);
      this.$toast.error('Erreur lors du chargement des modèles');
    } finally {
      this.loading = false;
    }
  },
  methods: {
    async fetchTemplates() {
      const response = await getPredefinedTemplates();
      if (response.success) {
        console.log('Templates récupérés:', response.data);
        
        // Ne pas filtrer les templates, afficher tous les modèles prédéfinis
        this.templates = response.data;
        
        this.filterTemplates();
      } else {
        throw new Error(response.message || 'Failed to fetch templates');
      }
    },
    filterTemplates() {
      let filtered = [...this.templates];
      
      // Apply search query filter
      if (this.searchQuery.trim()) {
        const query = this.searchQuery.toLowerCase();
        filtered = filtered.filter(template => 
          template.name.toLowerCase().includes(query)
        );
      }
      
      this.filteredTemplates = filtered;
    },
    selectTemplate(template) {
      this.selectedTemplate = template;
    },
    confirmSelection() {
      if (this.selectedTemplate) {
        this.$emit('template-selected', this.selectedTemplate);
      }
    },
    getCategoryLabel(template) {
      return 'Modèle';
    },
    getDocumentTypeLabel(template) {
      // Utiliser directement la colonne Doc_type de la table
      if (template.Doc_type) {
        return template.Doc_type.toLowerCase() === 'devis' ? 'Devis' : 'Facture';
      }
      
      // Fallback sur designConfig si Doc_type n'est pas disponible
      try {
        const designConfig = typeof template.design_config === 'string' 
          ? JSON.parse(template.design_config) 
          : template.design_config;
        
        if (designConfig && designConfig.documentType) {
          return designConfig.documentType.toLowerCase() === 'devis' ? 'Devis' : 'Facture';
        }
      } catch (error) {
        console.error('Error parsing design_config:', error);
      }
      
      // Valeur par défaut
      return 'Facture';
    },
    previewTemplate(template) {
      this.selectedPreviewTemplate = template;
      this.showPreviewModal = true;
      
      // Générer l'aperçu HTML du template
      try {
        // Si le template a une structure HTML, l'utiliser
        if (template.html_structure) {
          this.previewHtml = template.html_structure;
        } else {
          // Sinon, créer un aperçu simple
          this.previewHtml = `
            <html>
              <head>
                <style>
                  body { font-family: Arial, sans-serif; padding: 20px; }
                  h1 { color: #333; }
                  .preview-info { color: #666; }
                </style>
              </head>
              <body>
                <h1>${template.name}</h1>
                <p class="preview-info">Type: ${this.getDocumentTypeLabel(template)}</p>
                <p>Ceci est un aperçu du modèle ${template.name}.</p>
              </body>
            </html>
          `;
        }
      } catch (error) {
        console.error('Error generating preview:', error);
        this.previewHtml = '<p>Erreur lors de la génération de l\'aperçu</p>';
      }
    },
    
    closePreviewModal() {
      this.showPreviewModal = false;
      this.selectedPreviewTemplate = null;
      this.previewHtml = null;
    },
    
    selectAndContinue() {
      if (this.selectedPreviewTemplate) {
        this.selectedTemplate = this.selectedPreviewTemplate;
        this.closePreviewModal();
        this.confirmSelection();
      }
    }
  }
};
</script>

<style scoped>
.predefined-templates {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

.section-title {
  font-size: 1.8rem;
  color: #333;
  margin-bottom: 10px;
  text-align: center;
}

.section-description {
  color: #666;
  text-align: center;
  margin-bottom: 30px;
}

.search-filter-container {
  display: flex;
  justify-content: space-between;
  margin-bottom: 20px;
}

.search-box {
  position: relative;
  flex: 1;
  max-width: 400px;
}

.search-box i {
  position: absolute;
  left: 15px;
  top: 50%;
  transform: translateY(-50%);
  color: #999;
}

.search-box input {
  width: 100%;
  padding: 12px 15px 12px 40px;
  border: 1px solid #ddd;
  border-radius: 5px;
  font-size: 0.9rem;
}

.filter-dropdown select {
  padding: 12px 15px;
  border: 1px solid #ddd;
  border-radius: 5px;
  font-size: 0.9rem;
  background-color: white;
  cursor: pointer;
}

.templates-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
  gap: 25px;
  margin-bottom: 30px;
}

.template-card {
  border-radius: 10px;
  overflow: hidden;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
  cursor: pointer;
  transition: all 0.3s ease;
  border: 2px solid transparent;
  background-color: white;
  position: relative;
}

.template-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
}

.template-card.selected {
  border-color: #4bc0c0;
}

.template-preview {
  height: 180px;
  overflow: hidden;
  position: relative;
}

.template-name-placeholder {
  height: 150px;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #f5f5f5;
  color: #666;
  font-weight: bold;
  text-align: center;
  padding: 10px;
}

.badge-container {
  position: absolute;
  top: 0;
  right: 0;
  z-index: 1000;
  padding: 5px;
  pointer-events: none;
}

.doc-type-badge {
  background-color: #ff6b6b;
  color: white;
  padding: 5px 10px;
  border-radius: 5px;
  font-size: 0.9rem;
  font-weight: bold;
  text-transform: uppercase;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
  display: inline-block !important;
  opacity: 1 !important;
  visibility: visible !important;
}

.template-preview img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s ease;
}

.template-card:hover .template-preview img {
  transform: scale(1.05);
}

.template-info {
  padding: 15px;
}

.template-info h3 {
  margin: 0 0 10px 0;
  font-size: 1.1rem;
  color: #333;
}

.template-meta {
  display: flex;
  align-items: center;
}

.template-category {
  background-color: #f0f0f0;
  color: #666;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 0.8rem;
}

.loading-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 50px 0;
}

.spinner {
  width: 40px;
  height: 40px;
  border: 4px solid #f3f3f3;
  border-top: 4px solid #4bc0c0;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin-bottom: 15px;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.no-templates {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 50px 0;
  color: #999;
}

.no-templates i {
  font-size: 3rem;
  margin-bottom: 15px;
}

.action-buttons {
  display: flex;
  justify-content: space-between;
  margin-top: 20px;
}

.btn-primary, .btn-secondary {
  padding: 10px 25px;
  border-radius: 5px;
  font-size: 1rem;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.btn-primary {
  background-color: #4bc0c0;
  color: white;
  border: none;
}

.btn-primary:hover {
  background-color: #3da3a3;
}

.btn-primary:disabled {
  background-color: #cccccc;
  cursor: not-allowed;
}

.btn-secondary {
  background-color: #f5f5f5;
  color: #333;
  border: 1px solid #ddd;
}

.btn-secondary:hover {
  background-color: #e5e5e5;
}

.template-actions {
  display: flex;
  justify-content: flex-end;
  margin-top: 10px;
}

.btn-icon {
  background: none;
  border: none;
  cursor: pointer;
  width: 32px;
  height: 32px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #f5f5f5;
  color: #666;
  margin-left: 5px;
  transition: all 0.2s ease;
}

.btn-icon:hover {
  background-color: #4bc0c0;
  color: white;
}

.btn-icon i {
  font-size: 14px;
}

/* Modal Styles */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.modal-content {
  background-color: white;
  border-radius: 8px;
  width: 90%;
  max-width: 800px;
  max-height: 90vh;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
}

.modal-header {
  padding: 15px 20px;
  border-bottom: 1px solid #eee;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.modal-header h3 {
  margin: 0;
  color: #333;
}

.btn-close {
  background: none;
  border: none;
  font-size: 1.2rem;
  cursor: pointer;
  color: #999;
}

.btn-close:hover {
  color: #333;
}

.modal-body {
  padding: 20px;
  overflow-y: auto;
  flex: 1;
}

.preview-frame {
  width: 100%;
  height: 500px;
  border: 1px solid #ddd;
  border-radius: 4px;
}

.preview-placeholder {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 300px;
}

.spinner {
  width: 40px;
  height: 40px;
  border: 4px solid #f3f3f3;
  border-top: 4px solid #4bc0c0;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin-bottom: 15px;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.modal-footer {
  padding: 15px 20px;
  border-top: 1px solid #eee;
  display: flex;
  justify-content: flex-end;
  gap: 10px;
}

.btn-secondary {
  background-color: #f5f5f5;
  color: #333;
  border: 1px solid #ddd;
  padding: 8px 15px;
  border-radius: 4px;
  cursor: pointer;
}

.btn-primary {
  background-color: #4bc0c0;
  color: white;
  border: none;
  padding: 8px 15px;
  border-radius: 4px;
  cursor: pointer;
}

.btn-secondary:hover {
  background-color: #e5e5e5;
}

.btn-primary:hover {
  background-color: #3da3a3;
}
</style>
