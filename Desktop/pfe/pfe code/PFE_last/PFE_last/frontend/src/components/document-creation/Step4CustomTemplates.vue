<template>
  <div class="custom-templates">
    <h2 class="section-title">Modèles Personnalisés</h2>
    <p class="section-description">Sélectionnez un de vos modèles personnalisés pour votre {{ documentType }}</p>
    
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
      <p>Aucun modèle personnalisé trouvé pour ce type de document.</p>
    </div>
    
    <div v-else class="templates-grid">
      <div 
        v-for="template in filteredTemplates" 
        :key="template.id"
        class="template-card"
        :class="{ 'selected': selectedTemplate && selectedTemplate.id === template.id }"
        @click="selectTemplate(template)"
      >
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
      <button class="btn-secondary" @click="goBack">Retour</button>
      <button 
        class="btn-primary" 
        :disabled="!selectedTemplate" 
        @click="confirmSelection"
      >
        Continuer
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { getCustomTemplates } from '@/services/templateService';

const props = defineProps({
  documentType: {
    type: String,
    required: true,
    validator: value => ['devis', 'facture'].includes(value)
  }
});

const emit = defineEmits(['back', 'template-selected']);

// État pour les templates
const templates = ref([]);
const filteredTemplates = ref([]);
const selectedTemplate = ref(null);
const searchQuery = ref('');
const loading = ref(true);
const showPreviewModal = ref(false);
const selectedPreviewTemplate = ref(null);
const previewHtml = ref(null);

// Charger les templates au montage du composant
onMounted(async () => {
  try {
    await fetchTemplates();
  } catch (error) {
    console.error('Error fetching custom templates:', error);
  } finally {
    loading.value = false;
  }
});

// Fonction pour récupérer les templates personnalisés
const fetchTemplates = async () => {
  try {
    const response = await getCustomTemplates();
    if (response.success) {
      // Filtrer les templates selon le type de document (facture ou devis)
      templates.value = response.data.filter(template => {
        // Vérifier si le template a un doc_type qui correspond au type de document sélectionné
        return template.doc_type === props.documentType;
      });
      
      filterTemplates();
    } else {
      throw new Error(response.message || 'Failed to fetch custom templates');
    }
  } catch (error) {
    console.error('Error in fetchTemplates:', error);
    throw error;
  }
};

// Fonction pour filtrer les templates selon la recherche
const filterTemplates = () => {
  let filtered = [...templates.value];
  
  // Appliquer le filtre de recherche
  if (searchQuery.value.trim()) {
    const query = searchQuery.value.toLowerCase();
    filtered = filtered.filter(template => 
      template.name.toLowerCase().includes(query)
    );
  }
  
  filteredTemplates.value = filtered;
};

// Fonction pour sélectionner un template
const selectTemplate = (template) => {
  selectedTemplate.value = template;
};

// Fonction pour prévisualiser un template
const previewTemplate = (template) => {
  selectedPreviewTemplate.value = template;
  showPreviewModal.value = true;
  
  // Générer l'aperçu HTML du template
  try {
    // Si le template a une structure HTML, l'utiliser
    if (template.html_structure) {
      previewHtml.value = template.html_structure;
    } else {
      // Sinon, créer un aperçu simple
      previewHtml.value = `
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
            <p class="preview-info">Type: Personnalisé</p>
            <p>Ceci est un aperçu du modèle ${template.name}.</p>
          </body>
        </html>
      `;
    }
  } catch (error) {
    console.error('Error generating preview:', error);
    previewHtml.value = '<p>Erreur lors de la génération de l\'aperçu</p>';
  }
};

// Fonction pour fermer la modal d'aperçu
const closePreviewModal = () => {
  showPreviewModal.value = false;
  selectedPreviewTemplate.value = null;
  previewHtml.value = null;
};

// Fonction pour obtenir le libellé de la catégorie du template
const getCategoryLabel = (template) => {
  return 'Personnalisé';
};

// Fonction pour confirmer la sélection et passer à l'étape suivante
const confirmSelection = () => {
  if (selectedTemplate.value) {
    emit('template-selected', selectedTemplate.value);
  }
};

// Fonction pour revenir à l'étape précédente
const goBack = () => {
  emit('back');
};
</script>

<style scoped>
.custom-templates {
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
}

.template-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
}

.template-card.selected {
  border-color: #002446;
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
  background-color: #002446;
  color: white;
}

.btn-icon i {
  font-size: 14px;
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
  border-top: 4px solid #002446;
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
  background: linear-gradient(135deg, #002446, #003a6c);
  color: white;
  border: none;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.btn-primary:hover {
  background: linear-gradient(135deg, #003a6c, #004d8f);
  transform: translateY(-2px);
  box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
}

.btn-primary:disabled {
  background: linear-gradient(135deg, #a0a0a0, #c0c0c0);
  cursor: not-allowed;
  opacity: 0.7;
  transform: none;
  box-shadow: none;
}

.btn-secondary {
  background-color: #f5f5f5;
  color: #333;
  border: 1px solid #ddd;
}

.btn-secondary:hover {
  background-color: #e5e5e5;
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

.modal-footer {
  padding: 15px 20px;
  border-top: 1px solid #eee;
  display: flex;
  justify-content: flex-end;
  gap: 10px;
}
</style>