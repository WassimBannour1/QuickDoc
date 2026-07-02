<template>
  <div class="template-management-view">
    <div v-if="adminMode" class="back-button-container">
      <button class="back-button" @click="goBackToAdmin">
        <i class="fas fa-arrow-left"></i> Retour à l'administration
      </button>
    </div>
    
    <TemplateManager 
      :initial-edit-mode="editMode" 
      :template-id-to-edit="templateId" 
      :admin-mode="adminMode"
    />
  </div>
</template>

<script>
import TemplateManager from '@/components/templates/TemplateManager.vue';
import { getTemplateById } from '@/services/templateService';
import { useRouter } from 'vue-router';

export default {
  name: 'TemplateManagementView',
  components: {
    TemplateManager
  },
  props: {
    initialEditMode: {
      type: Boolean,
      default: false
    },
    templateIdToEdit: {
      type: Number,
      default: null
    },
    adminMode: {
      type: Boolean,
      default: false
    }
  },
  setup() {
    const router = useRouter();
    
    const goBackToAdmin = () => {
      router.push('/admin');
    };
    
    return { goBackToAdmin };
  },
  data() {
    return {
      editMode: false,
      templateId: null
    };
  },
  created() {
    // Initialize from props if provided
    if (this.initialEditMode) {
      this.editMode = true;
    }
    
    if (this.templateIdToEdit) {
      this.templateId = this.templateIdToEdit;
    }
    
    // Check if we're in edit mode from route name or path
    if (!this.editMode) {
      this.editMode = this.$route.name === 'edit-template' || 
                      this.$route.name === 'admin-edit-template' || 
                      this.$route.path.includes('edit-template');
    }
    
    // Get template ID from route params if not already set
    if (!this.templateId && this.$route.params.id) {
      this.templateId = parseInt(this.$route.params.id);
      console.log('TemplateManagementView: Edit mode activated with template ID:', this.templateId);
    }
    // Fallback to query params if no ID in route params
    else if (!this.templateId && this.$route.query.templateId) {
      this.templateId = parseInt(this.$route.query.templateId);
      console.log('TemplateManagementView: Edit mode activated with template ID from query:', this.templateId);
    }
    
    if (this.editMode) {
      console.log('TemplateManagementView: Edit mode is active, will skip to step 3');
    }
    
    console.log('TemplateManagementView: Admin mode:', this.adminMode);
    console.log('TemplateManagementView: Template ID to edit:', this.templateId);
  },
  
  mounted() {
    // Double-check that we have the template ID and are in edit mode
    console.log('TemplateManagementView mounted: templateId =', this.templateId, 'editMode =', this.editMode);
    
    // Force a refresh of the template data if needed
    if (this.templateId && this.editMode) {
      // Add a small delay to ensure the child component is mounted
      setTimeout(() => {
        console.log('TemplateManagementView: Forcing refresh of template data');
        // The TemplateManager component will handle the initialization
      }, 100);
    }
  }
};
</script>

<style scoped>
.template-management-view {
  min-height: 100vh;
  background-color: #f5f5f5;
}

.back-button-container {
  padding: 15px;
  background-color: #fff;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.back-button {
  display: inline-flex;
  align-items: center;
  padding: 8px 16px;
  background-color: #002446;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
  transition: background-color 0.3s;
}

.back-button:hover {
  background-color: #003a6c;
}

.back-button i {
  margin-right: 8px;
}
</style>
