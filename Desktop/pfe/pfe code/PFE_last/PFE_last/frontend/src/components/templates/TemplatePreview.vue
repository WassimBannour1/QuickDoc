<template>
  <div class="template-preview">
    <h2 class="section-title">Aperçu et Validation du Modèle</h2>
    <p class="section-description">Vérifiez votre modèle de {{ documentType }} avant de l'enregistrer</p>
    
    <div class="preview-container">
      <div class="preview-toolbar">
        <div class="preview-info">
          <h3>{{ templateName || 'Modèle sans nom' }}</h3>
          <div class="preview-meta">
            <span class="preview-type">{{ documentType === 'devis' ? 'Devis' : 'Facture' }}</span>
            <span class="preview-category">{{ getCategoryLabel(templateCategory) }}</span>
          </div>
        </div>
        
        <div class="preview-actions">
          <button class="btn-action" @click="generatePdfPreview">
            <i class="fas fa-file-pdf"></i> Générer PDF
          </button>
          <button class="btn-action" @click="printPreview">
            <i class="fas fa-print"></i> Imprimer
          </button>
        </div>
      </div>
      
      <div class="preview-frame-container">
        <div v-if="loading" class="loading-overlay">
          <div class="spinner"></div>
          <p>Génération de l'aperçu...</p>
        </div>
        
        <iframe 
          v-if="previewUrl" 
          :src="previewUrl" 
          class="preview-frame" 
          ref="previewFrame"
        ></iframe>
        
        <div v-else class="preview-placeholder">
          <i class="fas fa-file-alt"></i>
          <p>L'aperçu sera généré ici</p>
        </div>
      </div>
    </div>
    
    <div class="validation-section">
      <h3>Validation du modèle</h3>
      
      <div class="validation-checklist">
        <div 
          v-for="(check, index) in validationChecks" 
          :key="index"
          class="validation-item"
          :class="{ 
            'valid': check.valid, 
            'invalid': !check.valid 
          }"
        >
          <div class="validation-icon">
            <i :class="check.valid ? 'fas fa-check-circle' : 'fas fa-exclamation-circle'"></i>
          </div>
          <div class="validation-content">
            <h4>{{ check.title }}</h4>
            <p>{{ check.message }}</p>
          </div>
        </div>
      </div>
      
      <div v-if="hasValidationErrors" class="validation-errors">
        <h4>Problèmes à corriger :</h4>
        <ul>
          <li v-for="(check, index) in invalidChecks" :key="index">
            {{ check.title }}: {{ check.message }}
          </li>
        </ul>
      </div>
    </div>
    
    <div class="action-buttons">
      <button class="btn-secondary" @click="$emit('go-back')">Retour</button>
      <button 
        class="btn-primary" 
        :disabled="!isTemplateValid" 
        @click="confirmTemplate"
      >
        {{ isTemplateValid ? 'Enregistrer le modèle' : 'Corriger les erreurs' }}
      </button>
    </div>
  </div>
</template>

<script>
export default {
  name: 'TemplatePreview',
  props: {
    documentType: {
      type: String,
      required: true,
      validator: value => ['devis', 'facture'].includes(value)
    },
    templateName: {
      type: String,
      default: ''
    },
    templateCategory: {
      type: String,
      default: 'simple'
    },
    templateElements: {
      type: Array,
      default: () => []
    },
    designConfig: {
      type: Object,
      default: () => ({})
    },
    htmlStructure: {
      type: String,
      default: ''
    }
  },
  data() {
    return {
      loading: false,
      previewUrl: null,
      pdfUrl: null,
      validationChecks: [
        {
          title: 'Nom du modèle',
          valid: false,
          message: 'Le modèle doit avoir un nom'
        },
        {
          title: 'Éléments requis',
          valid: false,
          message: 'Le modèle doit contenir les éléments essentiels'
        },
        {
          title: 'Structure HTML',
          valid: false,
          message: 'La structure HTML du modèle est valide'
        },
        {
          title: 'Configuration visuelle',
          valid: false,
          message: 'La configuration visuelle est complète'
        }
      ]
    };
  },
  computed: {
    isTemplateValid() {
      return this.validationChecks.every(check => check.valid);
    },
    hasValidationErrors() {
      return this.validationChecks.some(check => !check.valid);
    },
    invalidChecks() {
      return this.validationChecks.filter(check => !check.valid);
    }
  },
  watch: {
    templateName: {
      immediate: true,
      handler(newVal) {
        this.validationChecks[0].valid = newVal && newVal.trim().length > 0;
        this.validationChecks[0].message = this.validationChecks[0].valid 
          ? 'Le nom du modèle est valide' 
          : 'Le modèle doit avoir un nom';
      }
    },
    templateElements: {
      immediate: true,
      deep: true,
      handler(newVal) {
        // Check if required elements exist
        const requiredElements = ['client_name', 'date', 'document_number', 'products_table', 'total_ttc'];
        const hasRequiredElements = requiredElements.every(req => {
          return newVal.some(element => 
            element.type === 'placeholder' && element.content && element.content.includes(req)
          );
        });
        
        this.validationChecks[1].valid = hasRequiredElements;
        this.validationChecks[1].message = hasRequiredElements 
          ? 'Tous les éléments requis sont présents' 
          : 'Certains éléments essentiels sont manquants';
      }
    },
    htmlStructure: {
      immediate: true,
      handler(newVal) {
        this.validationChecks[2].valid = newVal && newVal.includes('<!DOCTYPE html>');
        this.validationChecks[2].message = this.validationChecks[2].valid 
          ? 'La structure HTML du modèle est valide' 
          : 'La structure HTML est incomplète';
      }
    },
    designConfig: {
      immediate: true,
      deep: true,
      handler(newVal) {
        const hasDesignConfig = newVal && Object.keys(newVal).length > 0;
        this.validationChecks[3].valid = hasDesignConfig;
        this.validationChecks[3].message = hasDesignConfig 
          ? 'La configuration visuelle est complète' 
          : 'La configuration visuelle est incomplète';
      }
    }
  },
  mounted() {
    this.generatePreview();
  },
  methods: {
    getCategoryLabel(category) {
      const categoryMap = {
        'simple': 'Simple',
        'professionnel': 'Professionnel',
        'créatif': 'Créatif',
        'moderne': 'Moderne'
      };
      
      return categoryMap[category] || 'Autre';
    },
    async generatePreview() {
      this.loading = true;
      
      try {
        // Generate preview HTML with sample data
        const previewHtml = this.generatePreviewHtml();
        
        // Create a blob URL for the preview
        const blob = new Blob([previewHtml], { type: 'text/html' });
        this.previewUrl = URL.createObjectURL(blob);
      } catch (error) {
        console.error('Error generating preview:', error);
        this.$toast.error('Erreur lors de la génération de l\'aperçu');
      } finally {
        this.loading = false;
      }
    },
    generatePreviewHtml() {
      // Start with the base HTML structure
      let html = this.htmlStructure;
      
      // If no HTML structure is provided, create a basic one
      if (!html) {
        html = `
          <!DOCTYPE html>
          <html>
          <head>
            <meta charset="UTF-8">
            <title>${this.templateName || 'Aperçu du modèle'}</title>
            <style>
              body {
                font-family: ${this.designConfig.typography?.fontFamily || 'Arial, sans-serif'};
                margin: 0;
                padding: 20px;
                color: ${this.designConfig.colors?.text || '#333333'};
              }
              .template-container {
                position: relative;
                width: 100%;
                min-height: 800px;
                background-color: white;
              }
              .template-element {
                position: absolute;
              }
              h1, h2, h3 {
                color: ${this.designConfig.colors?.primary || '#4bc0c0'};
              }
              table {
                width: 100%;
                border-collapse: collapse;
                margin: 20px 0;
              }
              th {
                background-color: ${this.designConfig.colors?.primary || '#4bc0c0'};
                color: white;
                text-align: left;
                padding: 10px;
              }
              td {
                padding: 10px;
                border-bottom: 1px solid #eee;
              }
              tr:nth-child(even) {
                background-color: ${this.designConfig.colors?.secondary || '#f8f9fa'};
              }
            </style>
          </head>
          <body>
            <div class="template-container">
        `;
        
        // Add elements from templateElements
        this.templateElements.forEach(element => {
          let elementHtml = `
            <div class="template-element" style="
              left: ${element.x}px;
              top: ${element.y}px;
              color: ${element.color || this.designConfig.colors?.text || '#333333'};
              font-size: ${element.fontSize || this.designConfig.typography?.textSize || '14'}px;
              text-align: ${element.textAlign || 'left'};
            ">
          `;
          
          // Replace placeholders with sample data
          let content = element.content || '';
          
          // Sample data replacements
          const sampleData = {
            '{{client_name}}': 'Entreprise ABC',
            '{{client_address}}': '123 Rue du Client, 75000 Paris',
            '{{date}}': new Date().toLocaleDateString('fr-FR'),
            '{{document_number}}': this.documentType === 'devis' ? 'D-2025-001' : 'F-2025-001',
            '{{products_table}}': `
              <table>
                <thead>
                  <tr>
                    <th>Description</th>
                    <th>Quantité</th>
                    <th>Prix unitaire</th>
                    <th>Total HT</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td>Produit 1</td>
                    <td>2</td>
                    <td>100,00 €</td>
                    <td>200,00 €</td>
                  </tr>
                  <tr>
                    <td>Produit 2</td>
                    <td>1</td>
                    <td>150,00 €</td>
                    <td>150,00 €</td>
                  </tr>
                  <tr>
                    <td>Produit 3</td>
                    <td>3</td>
                    <td>75,00 €</td>
                    <td>225,00 €</td>
                  </tr>
                </tbody>
              </table>
            `,
            '{{total_ht}}': '575,00 €',
            '{{tva}}': '115,00 € (20%)',
            '{{total_ttc}}': '690,00 €'
          };
          
          // Replace all placeholders
          Object.keys(sampleData).forEach(placeholder => {
            content = content.replace(new RegExp(placeholder, 'g'), sampleData[placeholder]);
          });
          
          if (element.type === 'icon') {
            elementHtml += `<i class="${element.icon}"></i>`;
          } else if (element.type === 'logo' && element.src) {
            elementHtml += `<img src="${element.src}" alt="Logo" style="width: ${element.width || 100}px;">`;
          } else {
            elementHtml += content;
          }
          
          elementHtml += `</div>`;
          html += elementHtml;
        });
        
        html += `
            </div>
          </body>
          </html>
        `;
      }
      
      return html;
    },
    async generatePdfPreview() {
      this.loading = true;
      
      try {
        // In a real implementation, this would call a backend API to generate a PDF
        // For now, we'll just simulate a delay and show a message
        await new Promise(resolve => setTimeout(resolve, 1500));
        
        this.$toast.info('Fonctionnalité de génération PDF à implémenter côté serveur');
      } catch (error) {
        console.error('Error generating PDF:', error);
        this.$toast.error('Erreur lors de la génération du PDF');
      } finally {
        this.loading = false;
      }
    },
    printPreview() {
      if (this.$refs.previewFrame) {
        this.$refs.previewFrame.contentWindow.print();
      } else {
        this.$toast.error('Aperçu non disponible pour l\'impression');
      }
    },
    confirmTemplate() {
      if (this.isTemplateValid) {
        this.$emit('template-validated');
      } else {
        this.$toast.error('Veuillez corriger les erreurs avant de continuer');
      }
    }
  }
};
</script>

<style scoped>
.template-preview {
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

.preview-container {
  background-color: #f5f5f5;
  border-radius: 10px;
  overflow: hidden;
  margin-bottom: 30px;
}

.preview-toolbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px;
  background-color: #fff;
  border-bottom: 1px solid #eee;
}

.preview-info h3 {
  margin: 0 0 5px 0;
  font-size: 1.2rem;
  color: #333;
}

.preview-meta {
  display: flex;
  gap: 10px;
}

.preview-type, .preview-category {
  font-size: 0.9rem;
  padding: 3px 8px;
  border-radius: 4px;
}

.preview-type {
  background-color: #4bc0c0;
  color: white;
}

.preview-category {
  background-color: #f0f0f0;
  color: #666;
}

.preview-actions {
  display: flex;
  gap: 10px;
}

.btn-action {
  display: flex;
  align-items: center;
  gap: 5px;
  padding: 8px 12px;
  border-radius: 4px;
  background-color: #f0f0f0;
  color: #333;
  border: 1px solid #ddd;
  cursor: pointer;
  transition: all 0.2s ease;
}

.btn-action:hover {
  background-color: #e5e5e5;
}

.preview-frame-container {
  height: 600px;
  position: relative;
}

.loading-overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(255, 255, 255, 0.8);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  z-index: 10;
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

.preview-frame {
  width: 100%;
  height: 100%;
  border: none;
}

.preview-placeholder {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100%;
  color: #999;
}

.preview-placeholder i {
  font-size: 3rem;
  margin-bottom: 15px;
}

.validation-section {
  background-color: #f5f5f5;
  border-radius: 10px;
  padding: 20px;
  margin-bottom: 30px;
}

.validation-section h3 {
  margin: 0 0 20px 0;
  font-size: 1.2rem;
  color: #333;
}

.validation-checklist {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.validation-item {
  display: flex;
  gap: 15px;
  padding: 15px;
  border-radius: 5px;
  background-color: white;
}

.validation-item.valid {
  border-left: 4px solid #4bc0c0;
}

.validation-item.invalid {
  border-left: 4px solid #ff6b6b;
}

.validation-icon {
  font-size: 1.5rem;
}

.validation-item.valid .validation-icon {
  color: #4bc0c0;
}

.validation-item.invalid .validation-icon {
  color: #ff6b6b;
}

.validation-content {
  flex: 1;
}

.validation-content h4 {
  margin: 0 0 5px 0;
  font-size: 1.1rem;
  color: #333;
}

.validation-content p {
  margin: 0;
  color: #666;
}

.validation-errors {
  margin-top: 20px;
  padding: 15px;
  background-color: #fff3f3;
  border-left: 4px solid #ff6b6b;
  border-radius: 5px;
}

.validation-errors h4 {
  margin: 0 0 10px 0;
  color: #ff6b6b;
}

.validation-errors ul {
  margin: 0;
  padding-left: 20px;
}

.validation-errors li {
  color: #666;
  margin-bottom: 5px;
}

.action-buttons {
  display: flex;
  justify-content: space-between;
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
</style>
