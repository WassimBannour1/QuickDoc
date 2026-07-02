<template>
  <div class="appearance-customizer">
    <h2 class="section-title">Personnalisation de l'Apparence</h2>
    <p class="section-description">Personnalisez l'apparence de votre modèle de {{ documentType }}</p>
    
    <div class="customizer-container">
      <div class="customizer-sidebar">
        <div class="sidebar-section">
          <h3>Couleurs</h3>
          <div class="color-options">
            <div class="color-picker">
              <label>Couleur principale</label>
              <div class="color-input-wrapper">
                <input 
                  type="color" 
                  v-model="designConfig.colors.primary" 
                  @input="updatePreview"
                >
                <span>{{ designConfig.colors.primary }}</span>
              </div>
            </div>
            
            <div class="color-picker">
              <label>Couleur secondaire</label>
              <div class="color-input-wrapper">
                <input 
                  type="color" 
                  v-model="designConfig.colors.secondary" 
                  @input="updatePreview"
                >
                <span>{{ designConfig.colors.secondary }}</span>
              </div>
            </div>
            
            <div class="color-picker">
              <label>Couleur du texte</label>
              <div class="color-input-wrapper">
                <input 
                  type="color" 
                  v-model="designConfig.colors.text" 
                  @input="updatePreview"
                >
                <span>{{ designConfig.colors.text }}</span>
              </div>
            </div>
            
            <div class="color-picker">
              <label>Couleur d'accentuation</label>
              <div class="color-input-wrapper">
                <input 
                  type="color" 
                  v-model="designConfig.colors.accent" 
                  @input="updatePreview"
                >
                <span>{{ designConfig.colors.accent }}</span>
              </div>
            </div>
          </div>
          
          <div class="color-themes">
            <h4>Thèmes prédéfinis</h4>
            <div class="theme-options">
              <div 
                class="theme-option" 
                v-for="(theme, index) in colorThemes" 
                :key="index"
                @click="applyColorTheme(theme)"
              >
                <div class="theme-preview">
                  <div class="color-preview" :style="{ backgroundColor: theme.primary }"></div>
                  <div class="color-preview" :style="{ backgroundColor: theme.secondary }"></div>
                  <div class="color-preview" :style="{ backgroundColor: theme.text }"></div>
                  <div class="color-preview" :style="{ backgroundColor: theme.accent }"></div>
                </div>
                <span>{{ theme.name }}</span>
              </div>
            </div>
          </div>
        </div>
        
        <div class="sidebar-section">
          <h3>Logo</h3>
          <div class="logo-uploader">
            <div v-if="!designConfig.logo.src" class="upload-prompt">
              <label for="logo-upload" class="upload-button">
                <i class="fas fa-cloud-upload-alt"></i>
                Télécharger un logo
              </label>
              <input 
                type="file" 
                id="logo-upload" 
                @change="handleLogoUpload" 
                accept="image/*"
                style="display: none"
              >
            </div>
            
            <div v-else class="logo-preview">
              <img :src="designConfig.logo.src" alt="Logo">
              <div class="logo-controls">
                <div class="logo-size-control">
                  <label>Taille</label>
                  <div class="range-slider">
                    <input 
                      type="range" 
                      min="50" 
                      max="300" 
                      v-model.number="designConfig.logo.size" 
                      @input="updatePreview"
                    >
                    <span>{{ designConfig.logo.size }}px</span>
                  </div>
                </div>
                
                <button class="btn-danger-sm" @click="removeLogo">
                  <i class="fas fa-trash"></i> Supprimer
                </button>
              </div>
            </div>
          </div>
        </div>
        
        <div class="sidebar-section">
          <h3>Typographie</h3>
          <div class="typography-options">
            <div class="form-group">
              <label>Police principale</label>
              <select v-model="designConfig.typography.fontFamily" @change="updatePreview">
                <option value="Arial, sans-serif">Arial</option>
                <option value="'Times New Roman', serif">Times New Roman</option>
                <option value="'Courier New', monospace">Courier New</option>
                <option value="Georgia, serif">Georgia</option>
                <option value="Verdana, sans-serif">Verdana</option>
                <option value="'Trebuchet MS', sans-serif">Trebuchet MS</option>
                <option value="'Segoe UI', sans-serif">Segoe UI</option>
                <option value="'Open Sans', sans-serif">Open Sans</option>
                <option value="'Roboto', sans-serif">Roboto</option>
                <option value="'Montserrat', sans-serif">Montserrat</option>
              </select>
            </div>
            
            <div class="form-group">
              <label>Taille du titre</label>
              <div class="range-slider">
                <input 
                  type="range" 
                  min="16" 
                  max="48" 
                  v-model.number="designConfig.typography.titleSize" 
                  @input="updatePreview"
                >
                <span>{{ designConfig.typography.titleSize }}px</span>
              </div>
            </div>
            
            <div class="form-group">
              <label>Taille du texte</label>
              <div class="range-slider">
                <input 
                  type="range" 
                  min="10" 
                  max="24" 
                  v-model.number="designConfig.typography.textSize" 
                  @input="updatePreview"
                >
                <span>{{ designConfig.typography.textSize }}px</span>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <div class="preview-container">
        <div class="preview-header">
          <h3>Aperçu</h3>
          <div class="preview-controls">
            <button class="btn-secondary-sm" @click="resetDesign">
              <i class="fas fa-undo"></i> Réinitialiser
            </button>
          </div>
        </div>
        
        <div class="document-preview" :style="previewStyles" :class="[selectedThemeName && normalizeThemeClass(selectedThemeName)]">
          <div class="preview-header-section">
            <div 
              v-if="designConfig.logo.src" 
              class="preview-logo" 
              :style="{ 
                maxWidth: `${designConfig.logo.size}px`,
                maxHeight: `${designConfig.logo.size}px`
              }"
            >
              <img :src="designConfig.logo.src" alt="Logo">
            </div>
            
            <div class="preview-title">
              <h1>{{ documentType === 'devis' ? 'DEVIS' : 'FACTURE' }}</h1>
              <div class="preview-document-info">
                <p>N° {{ documentType === 'devis' ? 'D-2025-001' : 'F-2025-001' }}</p>
                <p>Date: 07/05/2025</p>
              </div>
            </div>
          </div>
          
          <div class="preview-client-section">
            <div class="preview-company-info">
              <h2>VOTRE ENTREPRISE</h2>
              <p>123 Rue de l'Entreprise</p>
              <p>75000 Paris</p>
              <p>contact@entreprise.com</p>
              <p>01 23 45 67 89</p>
            </div>
            
            <div class="preview-client-info">
              <h2>CLIENT</h2>
              <p>Nom du Client</p>
              <p>456 Avenue du Client</p>
              <p>75000 Paris</p>
              <p>client@example.com</p>
            </div>
          </div>
          
          <div class="preview-content">
            <table class="preview-table">
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
            
            <div class="preview-totals">
              <div class="total-row">
                <span>Total HT:</span>
                <span>575,00 €</span>
              </div>
              <div class="total-row">
                <span>TVA (20%):</span>
                <span>115,00 €</span>
              </div>
              <div class="total-row total-ttc">
                <span>Total TTC:</span>
                <span>690,00 €</span>
              </div>
            </div>
          </div>
          
          <div class="preview-footer">
            <p>Merci pour votre confiance !</p>
            <p>Conditions de paiement: 30 jours</p>
          </div>
        </div>
      </div>
    </div>
    
    <div class="action-buttons">
      <button class="btn-secondary" @click="$emit('go-back')">Retour</button>
      <button 
        class="btn-primary" 
        @click="saveAppearance"
      >
        Continuer
      </button>
    </div>
  </div>
</template>

<script>
export default {
  name: 'AppearanceCustomizer',
  props: {
    documentType: {
      type: String,
      required: true,
      validator: value => ['devis', 'facture'].includes(value)
    },
    initialDesign: {
      type: Object,
      default: () => ({})
    }
  },
  data() {
    return {
      selectedThemeName: 'Classique',
      designConfig: {
        colors: {
          primary: '#4bc0c0',
          secondary: '#f8f9fa',
          text: '#333333',
          accent: '#ff9f40'
        },
        logo: {
          src: null,
          size: 150,
          file: null
        },
        typography: {
          fontFamily: 'Arial, sans-serif',
          titleSize: 24,
          textSize: 14
        }
      },
      colorThemes: [
        {
          name: 'Classique',
          primary: '#4bc0c0',
          secondary: '#f8f9fa',
          text: '#333333',
          accent: '#ff9f40'
        },
        {
          name: 'Professionnel',
          primary: '#2c3e50',
          secondary: '#ecf0f1',
          text: '#2c3e50',
          accent: '#3498db'
        },
        {
          name: 'Moderne',
          primary: '#9b59b6',
          secondary: '#f5f5f5',
          text: '#34495e',
          accent: '#1abc9c'
        },
        {
          name: 'Élégant',
          primary: '#c0392b',
          secondary: '#f9f9f9',
          text: '#2c3e50',
          accent: '#f1c40f'
        },
        {
          name: 'Minimaliste',
          primary: '#333333',
          secondary: '#ffffff',
          text: '#333333',
          accent: '#e74c3c'
        }
      ]
    };
  },
  computed: {
    previewStyles() {
      return {
        fontFamily: this.designConfig.typography.fontFamily,
        '--primary-color': this.designConfig.colors.primary,
        '--secondary-color': this.designConfig.colors.secondary,
        '--text-color': this.designConfig.colors.text,
        '--accent-color': this.designConfig.colors.accent,
        '--title-size': `${this.designConfig.typography.titleSize}px`,
        '--text-size': `${this.designConfig.typography.textSize}px`
      };
    },
    // Utilitaire pour normaliser le nom du thème en nom de classe CSS
    normalizeThemeClass(name) {
      if (!name) return '';
      return (
        name
          .toLowerCase()
          .replace(/é/g, 'e')
          .replace(/è/g, 'e')
          .replace(/à/g, 'a')
          .replace(/ /g, '-')
          + '-theme'
      );
    }
  },
  created() {
    // Initialize with provided design if available
    if (this.initialDesign && Object.keys(this.initialDesign).length > 0) {
      this.designConfig = {
        ...this.designConfig,
        ...this.initialDesign
      };
    }
  },
  methods: {
    updatePreview() {
      // This method is called when design options change
      // Vue's reactivity will handle the updates automatically
    },
    applyColorTheme(theme) {
      this.designConfig.colors = { ...theme };
      this.selectedThemeName = theme.name;
      delete this.designConfig.colors.name;
      this.updatePreview();
    },
    handleLogoUpload(event) {
      const file = event.target.files[0];
      if (!file) return;
      
      this.designConfig.logo.file = file;
      
      // Create preview
      const reader = new FileReader();
      reader.onload = e => {
        this.designConfig.logo.src = e.target.result;
        this.updatePreview();
      };
      reader.readAsDataURL(file);
    },
    removeLogo() {
      this.designConfig.logo.src = null;
      this.designConfig.logo.file = null;
      
      // Reset file input
      const fileInput = document.getElementById('logo-upload');
      if (fileInput) fileInput.value = '';
      
      this.updatePreview();
    },
    resetDesign() {
      this.designConfig = {
        colors: {
          primary: '#4bc0c0',
          secondary: '#f8f9fa',
          text: '#333333',
          accent: '#ff9f40'
        },
        logo: {
          src: null,
          size: 150,
          file: null
        },
        typography: {
          fontFamily: 'Arial, sans-serif',
          titleSize: 24,
          textSize: 14
        }
      };
      
      // Reset file input
      const fileInput = document.getElementById('logo-upload');
      if (fileInput) fileInput.value = '';
      
      this.updatePreview();
    },
    saveAppearance() {
      this.$emit('appearance-saved', this.designConfig);
    }
  }
};
</script>

<style scoped>
:deep(.classique-theme) {
  background: #f8f9fa;
  color: #333333;
}
:deep(.professionnel-theme) {
  background: #ecf0f1;
  color: #2c3e50;
}
:deep(.moderne-theme) {
  background: #f5f5f5;
  color: #34495e;
}
:deep(.elegant-theme) {
  background: #f9f9f9;
  color: #2c3e50;
}
:deep(.minimaliste-theme) {
  background: #ffffff;
  color: #333333;
}
</style>


<style scoped>
.appearance-customizer {
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

.customizer-container {
  display: flex;
  gap: 20px;
  margin-bottom: 30px;
}

.customizer-sidebar {
  width: 350px;
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.sidebar-section {
  background-color: #f5f5f5;
  border-radius: 10px;
  padding: 15px;
}

.sidebar-section h3 {
  margin: 0 0 15px 0;
  font-size: 1.1rem;
  color: #333;
  border-bottom: 1px solid #ddd;
  padding-bottom: 10px;
}

.sidebar-section h4 {
  margin: 15px 0 10px 0;
  font-size: 1rem;
  color: #666;
}

.color-options {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.color-picker {
  display: flex;
  flex-direction: column;
  gap: 5px;
}

.color-picker label {
  font-size: 0.9rem;
  color: #666;
}

.color-input-wrapper {
  display: flex;
  align-items: center;
  gap: 10px;
}

.color-input-wrapper input[type="color"] {
  width: 40px;
  height: 40px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.color-input-wrapper span {
  font-size: 0.9rem;
  color: #666;
  font-family: monospace;
}

.color-themes {
  margin-top: 20px;
}

.theme-options {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.theme-option {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 5px;
  cursor: pointer;
}

.theme-preview {
  display: flex;
  border-radius: 4px;
  overflow: hidden;
  width: 60px;
  height: 20px;
}

.color-preview {
  flex: 1;
  height: 100%;
}

.theme-option span {
  font-size: 0.8rem;
  color: #666;
}

.logo-uploader {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.upload-prompt {
  display: flex;
  justify-content: center;
  padding: 20px;
}

.upload-button {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 10px;
  padding: 15px;
  background-color: #f9f9f9;
  border: 2px dashed #ddd;
  border-radius: 5px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.upload-button:hover {
  background-color: #f0f0f0;
  border-color: #ccc;
}

.upload-button i {
  font-size: 2rem;
  color: #4bc0c0;
}

.logo-preview {
  display: flex;
  flex-direction: column;
  gap: 10px;
  align-items: center;
}

.logo-preview img {
  max-width: 100%;
  max-height: 150px;
  object-fit: contain;
  border-radius: 5px;
}

.logo-controls {
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.logo-size-control {
  display: flex;
  flex-direction: column;
  gap: 5px;
}

.logo-size-control label {
  font-size: 0.9rem;
  color: #666;
}

.range-slider {
  display: flex;
  align-items: center;
  gap: 10px;
}

.range-slider input {
  flex: 1;
}

.range-slider span {
  font-size: 0.9rem;
  color: #666;
  width: 50px;
}

.btn-danger-sm {
  background-color: #ff6b6b;
  color: white;
  border: none;
  padding: 8px 12px;
  border-radius: 4px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 5px;
  font-size: 0.9rem;
}

.btn-danger-sm:hover {
  background-color: #ff5252;
}

.typography-options {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 5px;
}

.form-group label {
  font-size: 0.9rem;
  color: #666;
}

.form-group select {
  padding: 8px;
  border: 1px solid #ddd;
  border-radius: 4px;
  background-color: white;
}

.preview-container {
  flex: 1;
  background-color: #f5f5f5;
  border-radius: 10px;
  padding: 15px;
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.preview-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.preview-header h3 {
  margin: 0;
  font-size: 1.1rem;
  color: #333;
}

.btn-secondary-sm {
  background-color: #f0f0f0;
  color: #333;
  border: 1px solid #ddd;
  padding: 8px 12px;
  border-radius: 4px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 5px;
  font-size: 0.9rem;
}

.btn-secondary-sm:hover {
  background-color: #e5e5e5;
}

.document-preview {
  flex: 1;
  background-color: white;
  border-radius: 5px;
  padding: 30px;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
  overflow-y: auto;
  display: flex;
  flex-direction: column;
  gap: 30px;
  
  /* CSS Variables for dynamic styling */
  --primary-color: #4bc0c0;
  --secondary-color: #f8f9fa;
  --text-color: #333333;
  --accent-color: #ff9f40;
  --title-size: 24px;
  --text-size: 14px;
}

.preview-header-section {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  border-bottom: 2px solid var(--primary-color);
  padding-bottom: 20px;
}

.preview-logo {
  max-width: 150px;
  max-height: 150px;
}

.preview-logo img {
  max-width: 100%;
  max-height: 100%;
  object-fit: contain;
}

.preview-title {
  text-align: right;
}

.preview-title h1 {
  color: var(--primary-color);
  font-size: var(--title-size);
  margin: 0 0 10px 0;
}

.preview-document-info {
  color: var(--text-color);
  font-size: var(--text-size);
}

.preview-document-info p {
  margin: 5px 0;
}

.preview-client-section {
  display: flex;
  justify-content: space-between;
  gap: 50px;
}

.preview-company-info, .preview-client-info {
  flex: 1;
}

.preview-company-info h2, .preview-client-info h2 {
  color: var(--primary-color);
  font-size: calc(var(--title-size) * 0.8);
  margin: 0 0 10px 0;
  border-bottom: 1px solid var(--primary-color);
  padding-bottom: 5px;
}

.preview-company-info p, .preview-client-info p {
  color: var(--text-color);
  font-size: var(--text-size);
  margin: 5px 0;
}

.preview-content {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.preview-table {
  width: 100%;
  border-collapse: collapse;
}

.preview-table th {
  background-color: var(--primary-color);
  color: white;
  text-align: left;
  padding: 10px;
  font-size: var(--text-size);
}

.preview-table td {
  padding: 10px;
  border-bottom: 1px solid #eee;
  color: var(--text-color);
  font-size: var(--text-size);
}

.preview-table tr:nth-child(even) {
  background-color: var(--secondary-color);
}

.preview-totals {
  align-self: flex-end;
  width: 250px;
}

.total-row {
  display: flex;
  justify-content: space-between;
  padding: 5px 0;
  font-size: var(--text-size);
  color: var(--text-color);
}

.total-ttc {
  font-weight: bold;
  color: var(--primary-color);
  border-top: 1px solid var(--primary-color);
  padding-top: 10px;
  margin-top: 5px;
  font-size: calc(var(--text-size) * 1.2);
}

.preview-footer {
  margin-top: auto;
  text-align: center;
  color: var(--text-color);
  font-size: var(--text-size);
  border-top: 1px solid #eee;
  padding-top: 20px;
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

.btn-secondary {
  background-color: #f5f5f5;
  color: #333;
  border: 1px solid #ddd;
}

.btn-secondary:hover {
  background-color: #e5e5e5;
}
</style>
