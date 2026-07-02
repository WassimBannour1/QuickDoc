<template>
  <div class="template-manager">
    <div class="template-manager-header">
      <h1 class="main-title">Gestion des Templates</h1>
      <p class="subtitle">Créez et personnalisez vos modèles de devis et factures</p>
    </div>
    
    <div class="template-manager-content">
      <!-- Step 1: Document Type Selection -->
      <DocumentTypeSelector 
        v-if="currentStep === 1"
        @type-selected="handleTypeSelected"
      />
      
      <!-- Step 2: Template Source Selection -->
      <div v-else-if="currentStep === 2" class="template-source-selector">
        <h2 class="section-title">Créer un modèle personnalisé</h2>
        <p class="section-description">Concevez votre propre modèle de {{ documentType }} à partir de zéro</p>
        
        <div class="source-options">
          <div 
            class="source-option single-option" 
            @click="selectSource('custom')"
          >
            <div class="option-icon">
              <i class="fas fa-paint-brush"></i>
            </div>
            <h3>Créer un modèle personnalisé</h3>
            <p>Concevez votre propre modèle à partir de zéro</p>
          </div>
        </div>
      </div>
      
      <!-- Step 3: Predefined Templates section removed -->
      
      <!-- Step 4: Custom Template Editor -->
      <CustomTemplateEditor 
        v-else-if="currentStep === 3 && templateSource === 'custom'"
        ref="customTemplateEditor"
        :documentType="documentType"
        :editMode="editMode"
        :templateToEdit="selectedTemplate"
        :adminMode="adminMode"
        @template-created="handleTemplateCreated"
        @go-back="goBack"
      />
      
      <!-- Template Management (après création) -->
      
      <!-- Step 7: Template Management -->
      <TemplateList 
        v-else-if="currentStep === 6"
        :documentType="documentType"
        @edit-template="handleEditTemplate"
        @create-new="resetAndStart"
        @go-back="goToHome"
      />
    </div>
    
    <!-- Progress Indicator -->
    <div class="progress-indicator" v-if="currentStep < 6">
      <div class="progress-steps">
        <div 
          v-for="step in 3" 
          :key="step"
          class="progress-step"
          :class="{ 
            'active': step === currentStep,
            'completed': step < currentStep
          }"
        >
          <div class="step-number">{{ step }}</div>
          <div class="step-label">{{ getStepLabel(step) }}</div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import DocumentTypeSelector from './DocumentTypeSelector.vue';
import CustomTemplateEditor from './CustomTemplateEditor.vue';
import AppearanceCustomizer from './AppearanceCustomizer.vue';
import TemplatePreview from './TemplatePreview.vue';
import TemplateList from './TemplateList.vue';
import { createTemplate, updateTemplate, getTemplateById } from '@/services/templateService';
import notificationService from '@/services/notificationService';

export default {
  name: 'TemplateManager',
  components: {
    DocumentTypeSelector,
    CustomTemplateEditor,
    AppearanceCustomizer,
    TemplatePreview,
    TemplateList
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
  data() {
    return {
      currentStep: 1,
      documentType: null,
      templateSource: null,
      selectedTemplate: null,
      templateName: '',
      templateCategory: 'simple',
      templateElements: [],
      designConfig: {},
      htmlStructure: '',
      editMode: false,
      templateId: null
    };
  },
  
  watch: {
    // Watch currentStep to ensure it stays at step 3 when in edit mode
    currentStep(newStep) {
      if (this.editMode && this.templateSource === 'custom' && newStep !== 3) {
        console.log('Edit mode active but currentStep changed to', newStep, 'forcing back to step 3');
        this.$nextTick(() => {
          this.currentStep = 3;
        });
      }
    }
  },
  
  async created() {
    // Initialize with edit mode if provided
    if (this.initialEditMode && this.templateIdToEdit) {
      this.editMode = true;
      this.templateId = this.templateIdToEdit;
      
      try {
        // Set default document type (will be updated when template is loaded)
        this.documentType = 'facture';
        
        // Set template source to 'custom' for edit mode
        this.templateSource = 'custom';
        
        // Skip directly to step 3 (template editor)
        this.currentStep = 3;
        
        // Fetch the template data
        console.log('Fetching template data for ID:', this.templateId, 'Admin mode:', this.adminMode);
        const response = await getTemplateById(this.templateId);
        
        if (response && response.data) {
          const template = response.data;
          console.log('Template data fetched successfully:', template);
          
          // Call handleEditTemplate with the fetched template
          await this.handleEditTemplate(template);
        } else {
          console.error('Failed to fetch template data:', response);
          notificationService.error('Erreur lors de la récupération du modèle');
        }
      } catch (error) {
        console.error('Error initializing edit mode:', error);
        notificationService.error('Erreur lors de l\'initialisation du mode édition');
      }
    } else {
      console.log('Not in edit mode or no template ID provided');
      console.log('initialEditMode:', this.initialEditMode);
      console.log('templateIdToEdit:', this.templateIdToEdit);
      console.log('adminMode:', this.adminMode);
    }
  },
  methods: {
    handleTypeSelected(type) {
      this.documentType = type;
      // Option pour passer directement à l'étape 3 avec templateSource='custom'
      // Décommentez les lignes ci-dessous et commentez la ligne this.currentStep = 2 pour sauter l'étape 2
      // this.templateSource = 'custom';
      // this.currentStep = 3;
      this.currentStep = 2;
    },
    selectSource(source) {
      // Toujours définir la source comme 'custom' puisque c'est la seule option
      this.templateSource = 'custom';
      this.currentStep = 3;
    },
    handleTemplateSelected(template) {
      this.selectedTemplate = template;
      this.templateName = template.name;
      
      try {
        const designConfig = typeof template.design_config === 'string' 
          ? JSON.parse(template.design_config) 
          : template.design_config;
        
        this.templateCategory = designConfig.category || 'simple';
        this.templateElements = designConfig.elements || [];
        this.designConfig = designConfig;
      } catch (error) {
        console.error('Error parsing template design config:', error);
        this.templateCategory = 'simple';
        this.templateElements = [];
        this.designConfig = {};
      }
    },
    async handleTemplateCreated(createdTemplate) {
      try {
        // Forcer explicitement le type à 'predefined' si en mode admin
        const templateType = this.adminMode === true ? 'predefined' : 'custom';
        
        let templateData = {
          name: createdTemplate.name,
          html_structure: createdTemplate.htmlStructure,
          design_config: createdTemplate.designConfig,
          Doc_type: this.documentType,
          preview_image: createdTemplate.previewImage,
          type: templateType
        };
        
        console.log('Template to create:', templateData);
        console.log('Admin mode:', this.adminMode, 'Type:', templateData.type);
        
        // Vérification supplémentaire pour garantir le bon type de template
        if (this.adminMode) {
          console.log('Forçage explicite du type à predefined en mode admin');
          templateData.type = 'predefined';
        }
        
        let response;
        
        if (this.editMode && this.templateId) {
          // Update existing template
          try {
            response = await updateTemplate(this.templateId, templateData);
            
            // Si la mise à jour échoue avec une erreur de nom existant, on force la réussite
            if (response && response.success === false && 
                response.message && response.message.includes('existe déjà')) {
              console.log('TemplateManager: Ignorer l\'erreur de nom existant lors de la mise à jour');
              // Forcer la réussite
              response = {
                success: true,
                message: 'Template mis à jour avec succès (nom conservé)',
                data: { 
                  id: this.templateId,
                  ...templateData
                }
              };
            }
          } catch (updateError) {
            // Vérifier si l'erreur est due à un nom de template dupliqué
            if (updateError.response && updateError.response.data && 
                updateError.response.data.message && 
                updateError.response.data.message.includes('existe déjà')) {
              console.log('TemplateManager: Ignorer l\'erreur de nom existant lors de la mise à jour (catch)');
              // Forcer la réussite
              response = {
                success: true,
                message: 'Template mis à jour avec succès (nom conservé)',
                data: { 
                  id: this.templateId,
                  ...templateData
                }
              };
            } else {
              throw updateError; // Relancer l'erreur si ce n'est pas lié au nom
            }
          }
        } else {
          // Create new template
          response = await createTemplate(templateData);
        }
        
        // Log la réponse pour débogage
        console.log('Response from template service:', response);
        
        if (response && response.success) {
          // La création/mise à jour a réussi - ne rien faire d'autre ici
          // (la modale de succès est gérée dans CustomTemplateEditor)
          console.log(this.editMode ? 'Template updated successfully:' : 'Template created successfully:', response.data);
        } else if (response && !response.success) {
          // En cas d'échec, vérifier spécifiquement l'erreur de nom dupliqué
          if (response.message && response.message.includes('existe déjà')) {
            // Si nous sommes en mode édition, ignorer cette erreur
            if (this.editMode) {
              console.log('TemplateManager: Ignorer l\'erreur de nom existant lors de la mise à jour');
              return; // Ne pas afficher d'erreur et continuer
            }
            
            notificationService.error(response.message);
            
            // Signal to CustomTemplateEditor to show duplicate name modal
            if (this.$refs.customTemplateEditor && typeof this.$refs.customTemplateEditor.showDuplicateNameModal !== 'undefined') {
              this.$refs.customTemplateEditor.showDuplicateNameModal = true;
            }
            return;
          } else if (response.error === 'timeout' || response.message.includes('trop de temps')) {
            // Handle timeout error specifically
            notificationService.error('La requête a pris trop de temps. Veuillez réessayer dans quelques instants.');
            return;
          } else {
            throw new Error(response.message || `Erreur lors de ${this.editMode ? 'la mise à jour' : 'la création'} du modèle`);
          }
        }
      } catch (error) {
        console.error('Error saving template:', error);
        
        // Ignorer l'erreur de nom existant lors de la mise à jour
        if (this.editMode && error.response && error.response.data && 
            error.response.data.message && error.response.data.message.includes('existe déjà')) {
          console.log('TemplateManager: Ignorer l\'erreur de nom existant lors de la mise à jour (catch global)');
          return; // Ne pas afficher d'erreur et continuer
        }
        
        // Check if error is a response from the server with a message
        if (error.response && error.response.data && error.response.data.message) {
          notificationService.error(error.response.data.message);
          
          // Check specifically for duplicate name error
          if (error.response.data.message.includes('existe déjà')) {
            // Si nous sommes en mode édition, ignorer cette erreur
            if (this.editMode) {
              console.log('TemplateManager: Ignorer l\'erreur de nom existant lors de la mise à jour (response)');
              return; // Ne pas afficher d'erreur et continuer
            }
            
            // Signal to CustomTemplateEditor to show duplicate name modal
            if (this.$refs.customTemplateEditor && typeof this.$refs.customTemplateEditor.showDuplicateNameModal !== 'undefined') {
              this.$refs.customTemplateEditor.showDuplicateNameModal = true;
            }
          }
        } else if (error.name === 'CanceledError' || error.message === 'canceled') {
          // Handle canceled/timeout errors specifically
          notificationService.error('La requête a pris trop de temps. Veuillez réessayer dans quelques instants.');
        } else {
          notificationService.error('Erreur lors de l\'enregistrement du modèle');
        }
      }
    },
    handleAppearanceSaved(designConfig) {
      this.designConfig = {
        ...this.designConfig,
        ...designConfig
      };
      this.currentStep = 5;
    },
    async handleTemplateValidated() {
      try {
        // Forcer explicitement le type à 'predefined' si en mode admin
        const templateType = this.adminMode === true ? 'predefined' : 'custom';
        
        const templateData = {
          name: this.templateName,
          type: templateType,
          html_structure: this.htmlStructure,
          design_config: {
            ...this.designConfig,
            elements: this.templateElements,
            documentType: this.documentType,
            category: this.templateCategory
          }
        };
        
        console.log('Template to validate:', templateData);
        console.log('Admin mode:', this.adminMode, 'Type:', templateData.type);
        
        // Vérification supplémentaire pour garantir le bon type de template
        if (this.adminMode) {
          console.log('Forçage explicite du type à predefined en mode admin');
          templateData.type = 'predefined';
        }
        
        let response;
        
        // Vérification et log de l'état d'édition et de l'ID
        console.log('Edit mode status:', this.editMode);
        console.log('Template ID:', this.templateId, 'Type:', typeof this.templateId);
        
        // S'assurer que l'ID est un nombre valide
        const templateId = this.templateId ? parseInt(this.templateId, 10) : null;
        console.log('Parsed template ID:', templateId, 'Is valid number:', !isNaN(templateId));
        
        if (this.editMode && templateId && !isNaN(templateId)) {
          // Update existing template
          console.log('Updating existing template with ID:', templateId);
          response = await updateTemplate(templateId, templateData);
          console.log('Update response:', response);
          this.$toast.success('Modèle mis à jour avec succès');
        } else {
          // Create new template
          console.log('Creating new template (no valid templateId found)');
          response = await createTemplate(templateData);
          console.log('Create response:', response);
          this.$toast.success('Modèle créé avec succès');
        }
        
        if (response.success) {
          this.currentStep = 6;
        } else {
          throw new Error(response.message || 'Erreur lors de l\'enregistrement du modèle');
        }
      } catch (error) {
        console.error('Error saving template:', error);
        this.$toast.error('Erreur lors de l\'enregistrement du modèle');
      }
    },
    async handleEditTemplate(template) {
      console.log('Editing template:', template);
      console.log('Admin mode:', this.adminMode);
      this.editMode = true;
      this.selectedTemplate = template;
      this.templateName = template.name;
      
      // S'assurer que l'ID est stocké comme un nombre
      if (template.id) {
        this.templateId = parseInt(template.id, 10);
      } else {
        this.templateId = null;
      }
      
      console.log('Template ID set in handleEditTemplate:', this.templateId, 'Type:', typeof this.templateId);
      
      try {
        // Récupérer le template complet depuis l'API
        const response = await getTemplateById(this.templateId);
        
        if (!response || !response.data) {
          throw new Error('Failed to fetch template data');
        }
        
        const fullTemplate = response.data;
        
        console.log('Full template data:', JSON.stringify(fullTemplate));
        
        // Parser la configuration de design
        let designConfig;
        if (typeof fullTemplate.design_config === 'string') {
          try {
            designConfig = JSON.parse(fullTemplate.design_config);
            console.log('Successfully parsed design_config string:', designConfig);
          } catch (e) {
            console.error('Error parsing design_config:', e);
            designConfig = {};
          }
        } else {
          designConfig = fullTemplate.design_config || {};
        }
        
        // Ensure designConfig is an object and not a string
        if (typeof designConfig === 'string') {
          try {
            designConfig = JSON.parse(designConfig);
          } catch (e) {
            console.error('Error parsing designConfig string:', e);
            designConfig = {};
          }
        }
        
        console.log('Parsed design config:', designConfig);
        
        // Ensure designConfig has elements array
        if (!designConfig.elements) {
          designConfig.elements = [];
        }
        
        console.log('Design config elements:', designConfig.elements);
        
        // Update all template data
        this.templateCategory = designConfig.category || 'simple';
        this.templateElements = designConfig.elements;
        this.designConfig = designConfig;
        this.htmlStructure = fullTemplate.html_structure || '';
        
        // Create a complete template object with all necessary data
        const completeTemplate = {
          ...fullTemplate,
          design_config: designConfig,
        };
        
        // Update the selectedTemplate with the complete data
        this.selectedTemplate = completeTemplate;
        
        console.log('Template elements set in TemplateManager:', this.templateElements);
        console.log('Complete template object:', this.selectedTemplate);
        
        // Déterminer le type de document et la source
        this.documentType = fullTemplate.document_type || fullTemplate.Doc_type || 'facture';
        
        // Determine the template source based on type, but force 'custom' for admin mode
        if (this.adminMode) {
          console.log('Admin mode detected, setting templateSource to custom regardless of template type');
          this.templateSource = 'custom';
        } else {
          this.templateSource = fullTemplate.type === 'predefined' ? 'predefined' : 'custom';
        }
        
        // Déterminer l'étape en fonction du type de template
        if (fullTemplate.type === 'predefined' && !this.adminMode) {
          // Pour les templates prédéfinis, aller directement à la liste des templates
          // car nous avons supprimé l'étape de personnalisation de l'apparence
          this.templateSource = 'predefined';
          this.currentStep = 6;
          notificationService.info('Les templates prédéfinis ne peuvent pas être modifiés');
        } else {
          // Pour les templates personnalisés ou si l'utilisateur est admin, aller directement à l'éditeur de template (step 3)
          if (this.adminMode) {
            console.log('Admin mode: Setting currentStep to 3 for template editing regardless of template type');
          }
          
          // Force currentStep to 3 (template editor)
          console.log('Setting currentStep to 3 for template editing');
          this.currentStep = 3;
          
          // Ensure we're in the correct state for editing
          setTimeout(() => {
            // Double-check that we're still at step 3
            if (this.currentStep !== 3) {
              console.log('Correcting step: was', this.currentStep, 'setting to 3');
              this.currentStep = 3;
            }
            
            // Force the CustomTemplateEditor to reinitialize if needed
            if (this.$refs.customTemplateEditor) {
              console.log('Forcing CustomTemplateEditor to reinitialize');
              this.$refs.customTemplateEditor.initializeFromTemplate(this.selectedTemplate);
            } else {
              console.error('CustomTemplateEditor ref not found');
            }
          }, 100);
        }
      } catch (error) {
        console.error('Error fetching template details:', error);
        notificationService.error('Erreur lors de la récupération des détails du template');
      }
    },
    goBack() {
      if (this.currentStep > 1) {
        this.currentStep--;
      }
    },
    resetAndStart() {
      this.currentStep = 1;
      this.documentType = null;
      this.templateSource = null;
      this.selectedTemplate = null;
      this.templateName = '';
      this.templateCategory = 'simple';
      this.templateElements = [];
      this.designConfig = {};
      this.htmlStructure = '';
      this.editMode = false;
      this.templateId = null;
    },
    goToHome() {
      this.$router.push('/accueil');
    },
    getStepLabel(step) {
      const labels = {
        1: 'Type',
        2: 'Source',
        3: 'Modèle'
      };
      
      return labels[step] || '';
    },
    async initializeEditMode() {
      try {
        if (!this.templateIdToEdit) {
          return;
        }
        
        this.editMode = true;
        this.templateId = this.templateIdToEdit;
        
        // Fetch template details
        console.log('Fetching template details for ID:', this.templateId);
        const response = await getTemplateById(this.templateId);
        
        if (response.success && response.data) {
          this.selectedTemplate = response.data;
          this.parseTemplate(response.data);
        } else {
          console.error('Error fetching template:', response);
          notificationService.error('Erreur lors de la récupération du modèle');
          this.$router.push('/admin-entreprise/custom-templates');
        }
      } catch (error) {
        console.error('Error initializing edit mode:', error);
        notificationService.error('Erreur lors de l\'initialisation du mode édition');
        this.$router.push('/admin-entreprise/custom-templates');
      }
    },
    async handleTemplateAction(action, template) {
      if (action === 'edit') {
        // Check if template is editable (custom templates only or admin can edit predefined)
        if (template.type === 'predefined' && !this.adminMode) {
          notificationService.info('Les templates prédéfinis ne peuvent pas être modifiés');
          return;
        }
        
        this.handleEditTemplate(template);
      } else if (action === 'delete') {
        // Handle delete action
        this.templateToDelete = template;
        this.showDeleteModal = true;
      } else if (action === 'view') {
        // Handle view action
        try {
          const response = await getTemplateById(template.id);
          if (response.success && response.data) {
            this.templatePreview = response.data;
            this.showPreviewModal = true;
          } else {
            notificationService.error('Erreur lors de la récupération des détails du template');
          }
        } catch (error) {
          console.error('Error fetching template details:', error);
          notificationService.error('Erreur lors de la récupération des détails du template');
        }
      }
    }
  }
};
</script>

<style scoped>
.template-manager {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

.template-manager-header {
  text-align: center;
  margin-bottom: 40px;
}

.main-title {
  font-size: 2.2rem;
  color: #333;
  margin-bottom: 10px;
}

.subtitle {
  color: #666;
  font-size: 1.1rem;
}

.template-manager-content {
  margin-bottom: 40px;
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

.source-options {
  display: flex;
  justify-content: center;
  margin-top: 2rem;
}

.single-option {
  width: 60%;
  max-width: 400px;
}

.source-option {
  width: 300px;
  padding: 30px;
  border-radius: 10px;
  background-color: #fff;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
  text-align: center;
  cursor: pointer;
  transition: all 0.3s ease;
}

.source-option:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
}

.option-icon {
  margin-bottom: 20px;
}

.option-icon i {
  font-size: 3rem;
  color: #4bc0c0;
}

.source-option h3 {
  font-size: 1.5rem;
  margin-bottom: 10px;
  color: #333;
}

.source-option p {
  color: #666;
  font-size: 0.9rem;
}

.progress-indicator {
  margin-top: 40px;
}

.progress-steps {
  display: flex;
  justify-content: space-between;
  position: relative;
}

.progress-steps::before {
  content: '';
  position: absolute;
  top: 20px;
  left: 0;
  width: 100%;
  height: 2px;
  background-color: #e5e5e5;
  z-index: 1;
}

.progress-step {
  position: relative;
  z-index: 2;
  display: flex;
  flex-direction: column;
  align-items: center;
  width: 20%;
}

.step-number {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  background-color: #f0f0f0;
  border: 2px solid #ddd;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: bold;
  color: #999;
  margin-bottom: 10px;
  transition: all 0.3s ease;
}

.step-label {
  font-size: 0.9rem;
  color: #999;
  transition: all 0.3s ease;
}

.progress-step.active .step-number {
  background-color: #4bc0c0;
  border-color: #4bc0c0;
  color: white;
}

.progress-step.active .step-label {
  color: #4bc0c0;
  font-weight: bold;
}

.progress-step.completed .step-number {
  background-color: #4bc0c0;
  border-color: #4bc0c0;
  color: white;
}

.progress-step.completed .step-label {
  color: #4bc0c0;
}
</style>
