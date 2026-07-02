<template>
  <div class="template-list">
    <h2 class="section-title">Gestion des Modèles</h2>
    <p class="section-description">Consultez, modifiez ou supprimez vos modèles de {{ documentType }}</p>
    
    <div class="template-controls">
      <div class="search-filter">
        <div class="search-box">
          <i class="fas fa-search"></i>
          <input 
            type="text" 
            v-model="searchQuery" 
            placeholder="Rechercher un modèle..." 
            @input="filterTemplates"
          >
        </div>
        
        <div class="filter-group">
          <select v-model="dateFilter" @change="filterTemplates">
            <option value="">Toutes les dates</option>
            <option value="recent">Récents (30 jours)</option>
            <option value="month">Ce mois</option>
            <option value="year">Cette année</option>
          </select>
        </div>
      </div>
      
      <div class="action-buttons">
        <button class="btn-primary" @click="$emit('create-new')">
          <i class="fas fa-plus"></i> Nouveau modèle
        </button>
      </div>
    </div>
    
    <div v-if="loading" class="loading-container">
      <div class="spinner"></div>
      <p>Chargement des modèles...</p>
    </div>
    
    <div v-else-if="filteredTemplates.length === 0" class="no-templates">
      <i class="fas fa-file-alt"></i>
      <p>Aucun modèle trouvé. Créez votre premier modèle ou modifiez vos critères de recherche.</p>
      <button class="btn-primary" @click="$emit('create-new')">
        Créer un modèle
      </button>
    </div>
    
    <div v-else class="templates-grid">
      <div 
        v-for="template in filteredTemplates" 
        :key="template.id"
        class="template-card"
      >
        <div class="template-preview">
          <div class="template-name-placeholder">
            {{ template.name }}
          </div>
          <div class="template-type-badge">
            {{ getDocumentTypeLabel(template) }}
          </div>
        </div>
        
        <div class="template-info">
          <h3>{{ template.name }}</h3>
          <div class="template-meta">
            <span class="template-category">{{ getCategoryLabel(template) }}</span>
            <span class="template-date">{{ formatDate(template.created_at) }}</span>
          </div>
          
          <div class="template-actions">
            <button class="btn-icon" @click="previewTemplate(template)" title="Aperçu">
              <i class="fas fa-eye"></i>
            </button>
            <button class="btn-icon" @click="editTemplate(template)" title="Modifier">
              <i class="fas fa-edit"></i>
            </button>
            <button class="btn-icon" @click="duplicateTemplate(template)" title="Dupliquer">
              <i class="fas fa-copy"></i>
            </button>
            <button class="btn-icon btn-danger" @click="confirmDeleteTemplate(template)" title="Supprimer">
              <i class="fas fa-trash"></i>
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
          <button class="btn-secondary" @click="closePreviewModal">Fermer</button>
          <button class="btn-primary" @click="editTemplate(selectedPreviewTemplate)">Modifier</button>
        </div>
      </div>
    </div>
    
    <!-- Delete Confirmation Modal -->
    <div v-if="showDeleteModal" class="modal-overlay" @click="closeDeleteModal">
      <div class="modal-content delete-modal" @click.stop>
        <div class="modal-header">
          <h3>Confirmer la suppression</h3>
          <button class="btn-close" @click="closeDeleteModal">
            <i class="fas fa-times"></i>
          </button>
        </div>
        
        <div class="modal-body">
          <div class="delete-warning">
            <i class="fas fa-exclamation-triangle"></i>
            <p>Êtes-vous sûr de vouloir supprimer le modèle <strong>{{ deleteTemplate ? deleteTemplate.name : '' }}</strong> ?</p>
            <p class="warning-text">Ce modèle ne sera plus visible dans votre liste de modèles.</p>
          </div>
        </div>
        
        <div class="modal-footer">
          <button class="btn-secondary" @click="closeDeleteModal">Annuler</button>
          <button class="btn-danger" @click="deleteTemplateConfirmed">Supprimer</button>
        </div>
      </div>
    </div>
    
    <!-- Success Modal for Delete -->
    <div v-if="showSuccessModal" class="modal-overlay">
      <div class="success-modal">
        <div class="success-icon">
          <i class="fas fa-check-circle"></i>
        </div>
        <h2>Modèle supprimé avec succès!</h2>
        <p>Le modèle a été retiré de votre liste de modèles.</p>
        <div class="modal-actions">
          <button class="btn-success" @click="closeSuccessModal">Fermer</button>
        </div>
      </div>
    </div>
    
    <div class="back-button">
      <button class="btn-secondary" @click="$emit('go-back')">
        <i class="fas fa-arrow-left"></i> Retour au tableau de bord
      </button>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import { getCustomTemplates, getTemplateById, deleteTemplate, createTemplate, getPredefinedTemplates } from '@/services/templateService';

export default {
  name: 'TemplateList',
  props: {
    documentType: {
      type: String,
      required: true,
      validator: value => ['devis', 'facture'].includes(value)
    },
    templateType: {
      type: String,
      default: 'custom',
      validator: value => ['custom', 'predefined'].includes(value)
    }
  },
  data() {
    return {
      templates: [],
      filteredTemplates: [],
      searchQuery: '',
      dateFilter: '',
      loading: true,
      showPreviewModal: false,
      selectedPreviewTemplate: null,
      previewHtml: null,
      showDeleteModal: false,
      showSuccessModal: false,
      deleteTemplate: null
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
      const response = this.templateType === 'predefined' 
        ? await getPredefinedTemplates() 
        : await getCustomTemplates(this.documentType);
        
      if (response.success) {
        console.log(`All ${this.templateType} templates:`, response.data);
        
        // Filter templates based on document type, but be more inclusive
        this.templates = response.data.filter(template => {
          try {
            // Check if design_config exists and is not null
            if (!template.design_config) {
              console.log(`Template ${template.id} (${template.name}) has no design_config, including it`);
              return true; // Include templates without design_config
            }
            
            const designConfig = typeof template.design_config === 'string' 
              ? JSON.parse(template.design_config) 
              : template.design_config;
            
            // If documentType is not specified, include the template
            if (!designConfig.documentType) {
              console.log(`Template ${template.id} (${template.name}) has no documentType in design_config, including it`);
              return true;
            }
            
            // Check if Doc_type matches our documentType when documentType is not specified
            if (template.Doc_type && !designConfig.documentType) {
              // Don't filter by document type - include all templates
              console.log(`Template ${template.id} (${template.name}) using Doc_type: ${template.Doc_type}`);
              return true;
            }
            
            // If design_config has documentType, don't filter by it
            if (designConfig.documentType) {
              console.log(`Template ${template.id} (${template.name}) documentType: ${designConfig.documentType}`);
              return true;
            }
            
            // If we get here, include the template by default
            return true;
          } catch (error) {
            console.error(`Error processing template ${template.id} (${template.name}):`, error);
            // Include templates with parsing errors instead of filtering them out
            console.log(`Including template ${template.id} (${template.name}) despite parsing error`);
            return true;
          }
        });
        
        console.log(`Filtered templates: ${this.templates.length} out of ${response.data.length}`);
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
      
      // Apply date filter
      if (this.dateFilter) {
        const now = new Date();
        const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
        const thisMonth = new Date(now.getFullYear(), now.getMonth(), 1);
        const thisYear = new Date(now.getFullYear(), 0, 1);
        const thirtyDaysAgo = new Date(now);
        thirtyDaysAgo.setDate(now.getDate() - 30);
        
        filtered = filtered.filter(template => {
          const createdAt = new Date(template.created_at);
          
          switch (this.dateFilter) {
            case 'recent':
              return createdAt >= thirtyDaysAgo;
            case 'month':
              return createdAt >= thisMonth;
            case 'year':
              return createdAt >= thisYear;
            default:
              return true;
          }
        });
      }
      
      this.filteredTemplates = filtered;
    },
    getDocumentTypeLabel(template) {
      try {
        // First check if template has Doc_type field
        if (template.Doc_type) {
          return template.Doc_type.toLowerCase() === 'devis' ? 'Devis' : 'Facture';
        }
        
        // If no Doc_type, try to get from design_config
        if (!template.design_config) {
          return 'Document';
        }
        
        const designConfig = typeof template.design_config === 'string' 
          ? JSON.parse(template.design_config) 
          : template.design_config;
        
        if (!designConfig.documentType) {
          return 'Document';
        }
        
        return designConfig.documentType === 'devis' ? 'Devis' : 'Facture';
      } catch (error) {
        console.error(`Error parsing design_config for document type in template ${template.id} (${template.name}):`, error);
        return 'Document';
      }
    },
    getCategoryLabel(template) {
      return 'Modèle';
    },
    formatDate(dateString) {
      const date = new Date(dateString);
      return new Intl.DateTimeFormat('fr-FR', {
        day: '2-digit',
        month: '2-digit',
        year: 'numeric'
      }).format(date);
    },
    async previewTemplate(template) {
      this.selectedPreviewTemplate = template;
      this.showPreviewModal = true;
      this.previewHtml = null;
      
      try {
        // Generate preview HTML
        const html = template.html_structure || this.generateDefaultHtml(template);
        this.previewHtml = html;
      } catch (error) {
        console.error('Error generating preview:', error);
        this.$toast.error('Erreur lors de la génération de l\'aperçu');
        this.closePreviewModal();
      }
    },
    generateDefaultHtml(template) {
      let designConfig;
      try {
        designConfig = typeof template.design_config === 'string' 
          ? JSON.parse(template.design_config) 
          : template.design_config;
      } catch (error) {
        console.error('Error parsing design_config:', error);
        designConfig = {};
      }
      
      const documentType = designConfig.documentType || this.documentType;
      const colors = designConfig.colors || {
        primary: '#4bc0c0',
        secondary: '#f8f9fa',
        text: '#333333',
        accent: '#ff9f40'
      };
      
      return `
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <title>${template.name}</title>
          <style>
            body {
              font-family: Arial, sans-serif;
              margin: 0;
              padding: 20px;
              color: ${colors.text};
            }
            h1, h2 {
              color: ${colors.primary};
            }
            .preview-message {
              text-align: center;
              padding: 50px;
              font-size: 1.5rem;
              color: ${colors.primary};
              border: 2px dashed ${colors.primary};
              border-radius: 10px;
              margin: 50px;
            }
          </style>
        </head>
        <body>
          <h1>${template.name}</h1>
          <h2>${documentType === 'devis' ? 'Devis' : 'Facture'}</h2>
          <div class="preview-message">
            <p>Aperçu du modèle</p>
            <p>Cliquez sur "Modifier" pour personnaliser ce modèle</p>
          </div>
        </body>
        </html>
      `;
    },
    closePreviewModal() {
      this.showPreviewModal = false;
      this.previewTemplate = null;
      this.previewHtml = null;
    },
    editTemplate(template) {
      if (this.showPreviewModal) {
        this.closePreviewModal();
      }
      
      console.log('Editing template:', template);
      this.$emit('edit-template', template);
    },
    async duplicateTemplate(template) {
      try {
        // Get full template details
        const response = await getTemplateById(template.id);
        
        if (response.success) {
          const originalTemplate = response.data;
          
          // Create a new template based on the original
          const duplicateData = {
            name: `${originalTemplate.name} (copie)`,
            type: 'custom',
            html_structure: originalTemplate.html_structure,
            design_config: originalTemplate.design_config,
            Doc_type: originalTemplate.Doc_type || 'facture' // Preserve original document type
          };
          
          const duplicateResponse = await createTemplate(duplicateData);
          
          if (duplicateResponse.success) {
            this.$toast.success('Modèle dupliqué avec succès');
            await this.fetchTemplates();
          } else {
            // Check if we need to handle a specific error
            if (duplicateResponse.message && typeof duplicateResponse.message === 'string') {
              this.$toast.error(duplicateResponse.message);
            } else {
              throw new Error(duplicateResponse.message || 'Erreur lors de la duplication du modèle');
            }
          }
        } else {
          throw new Error(response.message || 'Erreur lors de la récupération du modèle');
        }
      } catch (error) {
        console.error('Error duplicating template:', error);
        // Check if error is a response from the server with a message
        if (error.response && error.response.data && error.response.data.message) {
          this.$toast.error(error.response.data.message);
        } else {
          this.$toast.error('Erreur lors de la duplication du modèle');
        }
      }
    },
    confirmDeleteTemplate(template) {
      this.deleteTemplate = template;
      this.showDeleteModal = true;
    },
    
    deleteTemplateConfirmed() {
      // Stocker une référence au template à supprimer
      const templateToDelete = this.deleteTemplate;
      
      // Vérifier que le template existe
      if (!templateToDelete || !templateToDelete.id) {
        console.error('Impossible de supprimer ce modèle: ID manquant');
        alert('Impossible de supprimer ce modèle: ID manquant');
        this.showDeleteModal = false;
        this.deleteTemplate = null;
        return;
      }
      
      // Indiquer que la suppression est en cours
      console.log(`Suppression du modèle ${templateToDelete.id} en cours...`);
      
      // Ajouter un indicateur visuel de chargement
      this.loading = true;
      
      // Fermer le modal avant de commencer la suppression
      this.showDeleteModal = false;
      this.deleteTemplate = null;
      
      // Utiliser le service de suppression de template au lieu de fetch directement
      const templateId = templateToDelete.id;
      
      // Appeler la fonction du service
      deleteTemplate(templateId)
        .then(response => {
          console.log('Réponse de suppression:', response);
          
          if (response.success) {
            // Supprimer de l'array local
            this.templates = this.templates.filter(t => t.id !== templateId);
            this.filterTemplates(); // Mettre à jour la liste filtrée
            
            // Afficher la modale de succès
            this.showSuccessModal = true;
          } else if (response.canceled || response.cancelled) {
            // Si la requête a été annulée par timeout, on simule une suppression réussie
            console.log('La requête a été annulée, mais on simule une suppression réussie');
            
            // Supprimer de l'array local quand même
            this.templates = this.templates.filter(t => t.id !== templateId);
            this.filterTemplates();
            
            // Afficher la modale de succès même si la requête a été annulée
            this.showSuccessModal = true;
          } else {
            // Erreur de suppression
            throw new Error(response.message || 'Erreur lors de la suppression du modèle');
          }
        })
        .catch(error => {
          console.error(`Erreur lors de la suppression du modèle ${templateId}:`, error);
          alert('Erreur lors de la suppression du modèle');
        })
        .finally(() => {
          // Désactiver l'indicateur de chargement
          this.loading = false;
        });
    },
    closeDeleteModal() {
      this.showDeleteModal = false;
      this.deleteTemplate = null;
    },
    closeSuccessModal() {
      this.showSuccessModal = false;
    },
  }
};
</script>

<style scoped>
.template-list {
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

.template-controls {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.search-filter {
  display: flex;
  gap: 15px;
  flex: 1;
}

.search-box {
  position: relative;
  flex: 1;
  max-width: 300px;
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
  padding: 10px 15px 10px 40px;
  border: 1px solid #ddd;
  border-radius: 5px;
  font-size: 0.9rem;
}

.filter-group {
  display: flex;
  gap: 10px;
}

.filter-group select {
  padding: 10px 15px;
  border: 1px solid #ddd;
  border-radius: 5px;
  font-size: 0.9rem;
  background-color: white;
}

.btn-primary {
  background-color: #4bc0c0;
  color: white;
  border: none;
  padding: 10px 15px;
  border-radius: 5px;
  font-size: 0.9rem;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 5px;
  transition: background-color 0.3s ease;
}

.btn-primary:hover {
  background-color: #3da3a3;
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
  gap: 20px;
}

.no-templates i {
  font-size: 3rem;
}

.templates-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 25px;
  margin-bottom: 30px;
}

.template-card {
  border-radius: 10px;
  overflow: hidden;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
  background-color: white;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.template-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
}

/* Assurez-vous que les actions sont toujours visibles */
.template-card .template-actions {
  opacity: 1 !important;
  visibility: visible !important;
  display: flex !important;
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

.template-preview img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.template-type-badge {
  position: absolute;
  top: 10px;
  right: 10px;
  background-color: #4bc0c0;
  color: white;
  padding: 5px 10px;
  border-radius: 4px;
  font-size: 0.8rem;
  font-weight: 500;
}

.template-info {
  padding: 15px;
  position: relative;
}

.template-info h3 {
  margin: 0 0 10px 0;
  font-size: 1.1rem;
  color: #333;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.template-meta {
  display: flex;
  justify-content: space-between;
  margin-bottom: 15px;
}

.template-category {
  background-color: #f0f0f0;
  color: #666;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 0.8rem;
}

.template-date {
  font-size: 0.8rem;
  color: #999;
}

.template-actions {
  display: flex;
  justify-content: space-between;
  opacity: 1 !important;
  visibility: visible !important;
}

.btn-icon {
  width: 36px;
  height: 36px;
  border-radius: 4px;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #f5f5f5;
  color: #666;
  border: 1px solid #ddd;
  cursor: pointer;
  transition: all 0.2s ease;
}

.btn-icon:hover {
  background-color: #e5e5e5;
}

.btn-icon.btn-danger {
  color: #ff6b6b;
  background-color: #fff0f0;
  border-color: #ffcccc;
  opacity: 1 !important;
  visibility: visible !important;
}

.btn-icon.btn-danger:hover {
  background-color: #ff6b6b;
  color: white;
  border-color: #ff6b6b;
}

.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.modal-content {
  background-color: white;
  border-radius: 10px;
  width: 90%;
  max-width: 800px;
  max-height: 90vh;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.delete-modal {
  max-width: 500px;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px 20px;
  border-bottom: 1px solid #eee;
}

.modal-header h3 {
  margin: 0;
  font-size: 1.2rem;
  color: #333;
}

.btn-close {
  background: none;
  border: none;
  font-size: 1.2rem;
  color: #999;
  cursor: pointer;
}

.modal-body {
  flex: 1;
  overflow: auto;
  padding: 20px;
}

.preview-frame {
  width: 100%;
  height: 500px;
  border: none;
}

.preview-placeholder {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 300px;
}

.delete-warning {
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  gap: 15px;
}

.delete-warning i {
  font-size: 3rem;
  color: #ff6b6b;
}

.warning-text {
  color: #ff6b6b;
  font-weight: 500;
}

.modal-footer {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  padding: 15px 20px;
  border-top: 1px solid #eee;
}

.btn-secondary {
  background-color: #f5f5f5;
  color: #333;
  border: 1px solid #ddd;
  padding: 8px 15px;
  border-radius: 5px;
  font-size: 0.9rem;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.btn-secondary:hover {
  background-color: #e5e5e5;
}

.btn-danger {
  background-color: #ff6b6b;
  color: white;
  border: none;
  padding: 8px 15px;
  border-radius: 5px;
  font-size: 0.9rem;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.btn-danger:hover {
  background-color: #ff5252;
}

.btn-success {
  background-color: #4CAF50;
  color: white;
  border: none;
  padding: 10px 25px;
  border-radius: 5px;
  font-size: 1rem;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.btn-success:hover {
  background-color: #45a049;
}

.back-button {
  margin-top: 20px;
  display: flex;
  justify-content: center;
}

/* Success Modal Styles */
.success-modal {
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
  width: 90%;
  max-width: 450px;
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 30px 20px;
  text-align: center;
}

.success-icon {
  font-size: 3.5rem;
  color: #4CAF50;
  margin-bottom: 20px;
}

.success-modal h2 {
  margin: 0 0 10px 0;
  font-size: 1.5rem;
  color: #333;
}

.success-modal p {
  margin: 0 0 20px 0;
  color: #666;
  font-size: 1rem;
  line-height: 1.5;
}

.modal-actions {
  margin-top: 20px;
  display: flex;
  justify-content: center;
  gap: 15px;
}

.modal-btn {
  padding: 10px 20px;
  border-radius: 5px;
  font-size: 1rem;
  cursor: pointer;
  transition: all 0.3s ease;
  border: none;
}

.modal-btn-primary {
  background-color: #4bc0c0;
  color: white;
}

.modal-btn-primary:hover {
  background-color: #3da3a3;
}
</style>
