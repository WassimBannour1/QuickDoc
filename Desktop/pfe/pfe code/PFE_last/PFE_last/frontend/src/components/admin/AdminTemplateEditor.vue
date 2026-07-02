<template>
  <div class="admin-template-editor">
    <div class="editor-header">
      <h2>{{ isEditMode ? 'Modifier un Template' : 'Créer un Template Prédéfini' }}</h2>
    </div>

    <div class="editor-content">
      <TemplateManager 
        :initial-edit-mode="isEditMode" 
        :template-id-to-edit="templateId" 
        :admin-mode="true"
      />
    </div>
  </div>
</template>

<script>
import { ref, onMounted, computed } from 'vue';
import TemplateManager from '@/components/templates/TemplateManager.vue';
import { createTemplate, updateTemplate, getTemplateById } from '@/services/templateService';

export default {
  name: 'AdminTemplateEditor',
  components: {
    TemplateManager
  },
  props: {
    templateId: {
      type: [Number, String],
      default: null
    },
    isEditMode: {
      type: Boolean,
      default: false
    }
  },
  emits: ['saved', 'cancel', 'error'],
  setup(props, { emit }) {
    // State variables
    const loading = ref(false);
    const template = ref(null);
    const templateData = ref({
      name: '',
      html_structure: '',
      design_config: {},
      preview_image: null,
      type: 'predefined', // Toujours predefined pour l'admin
      Doc_type: 'facture' // Valeur par défaut
    });
    
    // Load template if in edit mode
    onMounted(async () => {
      if (props.isEditMode && props.templateId) {
        await loadTemplate(props.templateId);
      }
    });
    
    // Methods
    const loadTemplate = async (id) => {
      try {
        loading.value = true;
        const response = await getTemplateById(id);
        
        if (response && response.data) {
          template.value = response.data;
          
          // Update templateData
          templateData.value = {
            name: template.value.name || '',
            html_structure: template.value.html_structure || '',
            design_config: template.value.design_config || {},
            type: 'predefined', // Forcer le type à predefined
            Doc_type: template.value.Doc_type || 'facture'
          };
          
          console.log('Template loaded:', templateData.value);
        } else {
          throw new Error('Failed to load template data');
        }
      } catch (error) {
        console.error('Error loading template:', error);
        emit('error', 'Erreur lors du chargement du template');
      } finally {
        loading.value = false;
      }
    };
    
    const handleSave = async (data) => {
      try {
        loading.value = true;
        
        // Ensure type is predefined - modification explicite
        const templateDataToSave = {
          ...data,
          type: 'predefined' // Force le type à predefined pour l'admin
        };
        
        console.log('Admin saving template with type:', templateDataToSave.type);
        
        let response;
        
        if (props.isEditMode && props.templateId) {
          response = await updateTemplate(props.templateId, templateDataToSave);
        } else {
          response = await createTemplate(templateDataToSave);
        }
        
        if (response && response.success) {
          console.log('Template saved successfully:', response.data);
          emit('saved', response.data);
        } else {
          throw new Error(response?.message || 'Failed to save template');
        }
      } catch (error) {
        console.error('Error saving template:', error);
        emit('error', error.message || 'Erreur lors de l\'enregistrement du template');
      } finally {
        loading.value = false;
      }
    };
    
    const handleCancel = () => {
      emit('cancel');
    };
    
    return {
      loading,
      template,
      templateData,
      handleSave,
      handleCancel
    };
  }
};
</script>

<style scoped>
.admin-template-editor {
  width: 100%;
  min-height: 80vh;
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
  overflow: hidden;
}

.editor-header {
  padding: 15px 20px;
  border-bottom: 1px solid #eee;
  background-color: #f9f9f9;
}

.editor-header h2 {
  margin: 0;
  font-size: 18px;
  color: #333;
}

.editor-content {
  padding: 0;
  min-height: 600px;
}

.loading-spinner {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 200px;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.spinner {
  border: 4px solid rgba(0, 0, 0, 0.1);
  border-radius: 50%;
  border-top: 4px solid #002446;
  width: 30px;
  height: 30px;
  animation: spin 1s linear infinite;
}
</style> 