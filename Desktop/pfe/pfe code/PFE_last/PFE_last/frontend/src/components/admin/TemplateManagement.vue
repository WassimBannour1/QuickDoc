<template>
  <div class="template-management">
    <div class="section-header">
      <h2>Gestion des Templates</h2>
      <p class="section-description">Créez et gérez les templates prédéfinis du système</p>
    </div>

    <div class="actions-container">
      <button class="btn-primary" @click="createNewTemplate">
        <i class="fas fa-plus"></i> Nouveau template prédéfini
      </button>
      <button class="btn-secondary" @click="viewTemplateList">
        <i class="fas fa-list"></i> Liste des templates prédéfinis
      </button>
    </div>

    <!-- Template List Component -->
    <div v-if="showTemplateList" class="template-list-container">
      <div v-if="loading" class="loading-container">
        <div class="spinner"></div>
        <p>Chargement des templates...</p>
      </div>
      <div v-else>
        <TemplateList 
          documentType="facture" 
          templateType="predefined"
          @template-selected="handleTemplateSelected"
          @edit-template="handleEditTemplate"
          @create-new="createNewTemplate"
        />
      </div>
    </div>

    <!-- Template Editor Component (will be implemented or imported) -->
    <div v-if="showTemplateEditor" class="template-editor-container">
      <div class="editor-header">
        <h3>{{ isEditMode ? 'Modifier le Template' : 'Nouveau Template' }}</h3>
        <button class="btn-close" @click="closeEditor">
          <i class="fas fa-times"></i>
        </button>
      </div>
      <div class="editor-content">
        <AdminTemplateEditor 
          :templateId="selectedTemplate ? selectedTemplate.id : null"
          :isEditMode="isEditMode"
          @saved="handleTemplateSaved"
          @cancel="closeEditor"
          @error="handleEditorError"
        />
      </div>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import TemplateList from '@/components/templates/TemplateList.vue';
import AdminTemplateEditor from './AdminTemplateEditor.vue';
import { getPredefinedTemplates } from '@/services/templateService';

export default {
  name: 'TemplateManagement',
  components: {
    TemplateList,
    AdminTemplateEditor
  },
  setup() {
    const router = useRouter();
    
    // State variables
    const loading = ref(false);
    const showTemplateList = ref(true);
    const showTemplateEditor = ref(false);
    const isEditMode = ref(false);
    const selectedTemplate = ref(null);
    
    // Load templates when component mounts
    onMounted(async () => {
      await checkTemplateService();
    });
    
    // Methods
    const checkTemplateService = async () => {
      try {
        loading.value = true;
        console.log('Checking predefined template service availability...');
        const response = await getPredefinedTemplates();
        console.log('Predefined template service response:', response);
        
        if (!response.success) {
          console.error('API response indicates failure:', response.message);
          throw new Error(response.message || 'API response indicates failure');
        }
        
        if (!response.data || response.data.length === 0) {
          console.log('No predefined templates found, but API is working');
        } else {
          console.log(`Found ${response.data.length} predefined templates`);
        }
        
        return true;
      } catch (error) {
        console.error('Predefined template service check failed:', error);
        throw error;
      } finally {
        loading.value = false;
      }
    };
    
    const createNewTemplate = () => {
      showTemplateList.value = false;
      showTemplateEditor.value = true;
      isEditMode.value = false;
      selectedTemplate.value = null;
    };
    
    const viewTemplateList = () => {
      showTemplateList.value = true;
      showTemplateEditor.value = false;
    };
    
    const handleTemplateSelected = (template) => {
      console.log('Template selected:', template);
      selectedTemplate.value = template;
    };
    
    const handleEditTemplate = (template) => {
      console.log('Edit template:', template);
      selectedTemplate.value = template;
      isEditMode.value = true;
      showTemplateList.value = false;
      showTemplateEditor.value = true;
    };
    
    const closeEditor = () => {
      showTemplateList.value = true;
      showTemplateEditor.value = false;
      selectedTemplate.value = null;
    };
    
    const handleTemplateSaved = (template) => {
      console.log('Template saved:', template);
      // Afficher un message de succès (vous pouvez utiliser une librairie de toast si disponible)
      alert(`Le template "${template.name}" a été enregistré avec succès.`);
      // Fermer l'éditeur et retourner à la liste
      closeEditor();
      // Rafraîchir la liste des templates
      checkTemplateService();
    };
    
    const handleEditorError = (error) => {
      console.error('Editor error:', error);
      // Afficher un message d'erreur
      alert(`Erreur: ${error}`);
    };
    
    return {
      loading,
      showTemplateList,
      showTemplateEditor,
      isEditMode,
      selectedTemplate,
      createNewTemplate,
      viewTemplateList,
      handleTemplateSelected,
      handleEditTemplate,
      closeEditor,
      handleTemplateSaved,
      handleEditorError
    };
  }
};
</script>

<style scoped>
.template-management {
  padding: 20px;
  background-color: #f5f5f5;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
}

.section-header {
  margin-bottom: 20px;
}

.section-header h2 {
  font-size: 24px;
  color: #002446;
  margin-bottom: 8px;
}

.section-description {
  color: #666;
  font-size: 14px;
}

.actions-container {
  display: flex;
  gap: 15px;
  margin-bottom: 20px;
}

.btn-primary {
  background-color: #4bc0c0;
  color: white;
  border: none;
  padding: 10px 15px;
  border-radius: 6px;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 8px;
  transition: all 0.3s ease;
}

.btn-primary:hover {
  background-color: #3da3a3;
}

.btn-secondary {
  background-color: white;
  color: #333;
  border: 1px solid #ddd;
  padding: 10px 15px;
  border-radius: 6px;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 8px;
  transition: all 0.3s ease;
}

.btn-secondary:hover {
  background-color: #f5f5f5;
}

.template-list-container, .template-editor-container {
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
  padding: 20px;
  margin-top: 20px;
}

.editor-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  padding-bottom: 15px;
  border-bottom: 1px solid #eee;
}

.editor-header h3 {
  font-size: 18px;
  color: #002446;
  margin: 0;
}

.btn-close {
  background: none;
  border: none;
  color: #999;
  cursor: pointer;
  font-size: 18px;
  transition: color 0.3s ease;
}

.btn-close:hover {
  color: #333;
}

.loading-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 40px 0;
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
</style> 