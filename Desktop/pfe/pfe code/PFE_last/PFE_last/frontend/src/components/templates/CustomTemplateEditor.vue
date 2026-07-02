<template>
  <div class="custom-template-editor">
    <h2 class="section-title">{{ editMode ? 'Modifier' : 'Créer' }} un Modèle Personnalisé</h2>
    <p class="section-description">Personnalisez votre modèle de {{ documentType }} selon vos besoins</p>
    
    <!-- Section de personnalisation des couleurs -->
    <div class="color-customization-section">
      <h4>Personnalisation des couleurs</h4>
      <div class="color-themes">
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
      
      <div class="color-pickers">
        <div class="color-picker">
          <label>Couleur principale</label>
          <div class="color-input-wrapper">
            <input 
              type="color" 
              v-model="designConfig.colors.primary" 
              @input="updateDesignColors"
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
              @input="updateDesignColors"
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
              @input="updateDesignColors"
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
              @input="updateDesignColors"
            >
            <span>{{ designConfig.colors.accent }}</span>
          </div>
        </div>
      </div>
    </div>
    
    <div class="editor-container">
      <!-- Left Sidebar: Elements and Properties -->
      <div class="editor-sidebar">
        <!-- Elements Panel -->
        <div class="sidebar-section">
          <h3>Éléments</h3>
          <div class="elements-list">
            <div 
              v-for="(element, index) in availableElements" 
              :key="index"
              class="element-item"
              draggable="true"
              @dragstart="dragStart($event, element)"
            >
              <i :class="element.icon"></i>
              <span>{{ element.label }}</span>
            </div>
          </div>
        </div>
        
        <!-- Properties Panel -->
        <div class="sidebar-section">
          <h3>Propriétés</h3>
          <div v-if="selectedElement" class="properties-panel">
            <!-- Table Properties (for table element) -->
            <div v-if="selectedElement.type === 'table'" class="table-properties">
              <div class="property-group">
                <label>Dimensions du tableau</label>
                <div class="table-dimensions">
                  <div class="dimension-input">
                    <span>Lignes</span>
                    <input 
                      type="number" 
                      min="1"
                      max="20"
                      v-model.number="selectedElement.rows" 
                      @input="updateTableDimensions"
                    >
                  </div>
                  <div class="dimension-info">
                    <span>Colonnes: 6</span>
                    <div class="table-headers-info">
                      <small>En-têtes fixes: REF, Détails, Quantité, PU HT, Total HT, TVA</small>
                    </div>
                  </div>
                </div>
              </div>
              
              <div class="property-group">
                <label>Bordures</label>
                <div class="border-properties">
                  <div class="border-width">
                    <span>Épaisseur</span>
                    <input 
                      type="number" 
                      min="0"
                      max="10"
                      v-model.number="selectedElement.borderWidth" 
                      @input="updateSelectedElement"
                    >
                  </div>
                  <div class="border-style">
                    <span>Style</span>
                    <select v-model="selectedElement.borderStyle" @change="updateSelectedElement">
                      <option value="solid">Pleine</option>
                      <option value="dashed">Tirets</option>
                      <option value="dotted">Pointillés</option>
                      <option value="double">Double</option>
                    </select>
                  </div>
                  <div class="border-color">
                    <span>Couleur</span>
                    <input 
                      type="color" 
                      v-model="selectedElement.borderColor" 
                      @input="updateSelectedElement"
                    >
                  </div>
                </div>
              </div>
              
              <div class="property-group">
                <label>Couleurs d'arrière-plan</label>
                <div class="background-colors">
                  <div class="color-picker-container">
                    <span>En-tête</span>
                    <input 
                      type="color" 
                      v-model="selectedElement.headerBackgroundColor" 
                      @input="updateSelectedElement"
                    >
                  </div>
                  <div class="color-picker-container">
                    <span>Cellules</span>
                    <input 
                      type="color" 
                      v-model="selectedElement.cellBackgroundColor" 
                      @input="updateSelectedElement"
                    >
                  </div>
                </div>
              </div>
              
              <div class="property-group">
                <label>Espacement</label>
                <div class="range-slider">
                  <input 
                    type="range" 
                    min="2" 
                    max="20" 
                    v-model.number="selectedElement.cellPadding" 
                    @input="updateSelectedElement"
                  >
                  <span>{{ selectedElement.cellPadding }}px</span>
                </div>
              </div>
            </div>
            
            <!-- Text Content -->
            <div class="property-group" v-if="selectedElement.type !== 'logo' && selectedElement.type !== 'table' && selectedElement.type !== 'divider'">
              <label>Texte</label>
              <input 
                type="text" 
                v-model="selectedElement.content" 
                @input="updateSelectedElement"
              >
            </div>
            
            <!-- Divider Properties -->
            <div v-if="selectedElement.type === 'divider'" class="divider-properties">
              <div class="property-group">
                <label>Largeur</label>
                <div class="range-slider">
                  <input 
                    type="range" 
                    min="50" 
                    max="800" 
                    v-model.number="selectedElement.width" 
                    @input="updateSelectedElement"
                  >
                  <span>{{ selectedElement.width }}px</span>
                </div>
              </div>
              
              <div class="property-group">
                <label>Épaisseur</label>
                <div class="range-slider">
                  <input 
                    type="range" 
                    min="0.5" 
                    step="0.5"
                    max="20" 
                    v-model.number="selectedElement.height" 
                    @input="updateSelectedElement"
                  >
                  <span>{{ selectedElement.height }}px</span>
                </div>
              </div>
              
              <div class="property-group">
                <label>Style</label>
                <select v-model="selectedElement.borderStyle" @change="updateSelectedElement">
                  <option value="solid">Pleine</option>
                  <option value="dashed">Tirets</option>
                  <option value="dotted">Pointillés</option>
                  <option value="double">Double</option>
                </select>
              </div>
              
              <div class="property-group">
                <label>Couleur</label>
                <div class="color-picker-container">
                  <input 
                    type="color" 
                    v-model="selectedElement.color" 
                    @input="updateSelectedElement"
                  >
                  <span>{{ selectedElement.color }}</span>
                </div>
              </div>
            </div>
            
            <!-- Font Properties -->
            <div class="property-group">
              <label>Police</label>
              <select v-model="selectedElement.fontFamily" @change="updateSelectedElement">
                <option value="Arial, sans-serif">Arial</option>
                <option value="'Times New Roman', serif">Times New Roman</option>
                <option value="'Courier New', monospace">Courier New</option>
                <option value="Georgia, serif">Georgia</option>
                <option value="'Trebuchet MS', sans-serif">Trebuchet MS</option>
              </select>
            </div>
            
            <!-- Font Size -->
            <div class="property-group">
              <label>Taille du texte</label>
              <div class="range-slider">
                <input 
                  type="range" 
                  min="8" 
                  max="48" 
                  v-model.number="selectedElement.fontSize" 
                  @input="updateSelectedElement"
                >
                <span>{{ selectedElement.fontSize }}px</span>
              </div>
            </div>
            
            <!-- Text Color -->
            <div class="property-group">
              <label>Couleur du texte</label>
              <div class="color-picker-container">
                <input 
                  type="color" 
                  v-model="selectedElement.color" 
                  @input="updateSelectedElement"
                >
                <span>{{ selectedElement.color }}</span>
              </div>
            </div>
            
            <!-- Text Style -->
            <div class="property-group">
              <label>Style</label>
              <div class="style-buttons">
                <button 
                  :class="{ active: selectedElement.fontWeight === 'bold' }" 
                  @click="toggleFontStyle('bold')"
                  title="Gras"
                >
                  <i class="fas fa-bold"></i>
                </button>
                <button 
                  :class="{ active: selectedElement.fontStyle === 'italic' }" 
                  @click="toggleFontStyle('italic')"
                  title="Italique"
                >
                  <i class="fas fa-italic"></i>
                </button>
                <button 
                  :class="{ active: selectedElement.textDecoration === 'underline' }" 
                  @click="toggleFontStyle('underline')"
                  title="Souligné"
                >
                  <i class="fas fa-underline"></i>
                </button>
              </div>
            </div>
            
            <!-- Text Alignment -->
            <div class="property-group">
              <label>Alignement</label>
              <div class="alignment-buttons">
                <button 
                  :class="{ active: selectedElement.textAlign === 'left' }" 
                  @click="setAlignment('left')"
                  title="Aligner à gauche"
                >
                  <i class="fas fa-align-left"></i>
                </button>
                <button 
                  :class="{ active: selectedElement.textAlign === 'center' }" 
                  @click="setAlignment('center')"
                  title="Centrer"
                >
                  <i class="fas fa-align-center"></i>
                </button>
                <button 
                  :class="{ active: selectedElement.textAlign === 'right' }" 
                  @click="setAlignment('right')"
                  title="Aligner à droite"
                >
                  <i class="fas fa-align-right"></i>
                </button>
              </div>
            </div>
            
            <!-- Element Position -->
            <div class="property-group">
              <label>Position</label>
              <div class="position-inputs">
                <div class="position-input">
                  <span>X</span>
                  <input 
                    type="number" 
                    v-model.number="selectedElement.x" 
                    @input="updateSelectedElement"
                  >
                </div>
                <div class="position-input">
                  <span>Y</span>
                  <input 
                    type="number" 
                    v-model.number="selectedElement.y" 
                    @input="updateSelectedElement"
                  >
                </div>
              </div>
            </div>
            
            <!-- Element Size (for logo) -->
            <div class="property-group" v-if="selectedElement.type === 'logo'">
              <label>Taille</label>
              <div class="range-slider">
                <input 
                  type="range" 
                  min="50" 
                  max="300" 
                  v-model.number="selectedElement.width" 
                  @input="updateSelectedElement"
                >
                <span>{{ selectedElement.width }}px</span>
              </div>
            </div>
            
            <!-- Background Color (for certain elements) -->
            <div class="property-group" v-if="selectedElement.type === 'text' || selectedElement.type === 'placeholder'">
              <label>Couleur d'arrière-plan</label>
              <div class="color-picker-container">
                <input 
                  type="color" 
                  v-model="selectedElement.backgroundColor" 
                  @input="updateSelectedElement"
                >
                <span>{{ selectedElement.backgroundColor }}</span>
                <button 
                  class="transparent-btn" 
                  @click="toggleTransparentBackground"
                  :class="{ active: selectedElement.backgroundColor === 'transparent' }"
                >
                  Transparent
                </button>
              </div>
            </div>
            
            <!-- Delete Button -->
            <button class="btn-danger" @click="removeSelectedElement">
              <i class="fas fa-trash"></i> Supprimer
            </button>
          </div>
          <div v-else class="no-selection">
            <p>Sélectionnez un élément pour modifier ses propriétés</p>
            <p class="tip"><i class="fas fa-info-circle"></i> Glissez-déposez des éléments depuis la liste sur le canevas</p>
          </div>
        </div>
      </div>
      
      <!-- Canvas Area -->
      <div class="editor-canvas-container">
        <div class="canvas-toolbar">
          <div class="canvas-actions">
            <button @click="addGridLines" :class="{ 'active': showGrid }" title="Afficher/Masquer la grille">
              <i class="fas fa-border-all"></i>
            </button>
            <button @click="toggleElementIds" :class="{ 'active': showElementIds }" :title="showElementIds ? 'Cacher les IDs' : 'Afficher les IDs'">
              <i class="fas fa-id-card"></i>
            </button>
            <button @click="alignElementsHorizontally" title="Aligner horizontalement">
              <i class="fas fa-align-center"></i>
            </button>
            <button @click="alignElementsVertically" title="Aligner verticalement">
              <i class="fas fa-align-justify"></i>
            </button>
            <button @click="distributeElementsEvenly" title="Distribuer uniformément">
              <i class="fas fa-arrows-alt-h"></i>
            </button>
          </div>
          <div class="zoom-controls">
            <button @click="zoomOut" title="Zoom arrière">
              <i class="fas fa-search-minus"></i>
            </button>
            <span>{{ Math.round(zoomLevel * 100) }}%</span>
            <button @click="zoomIn" title="Zoom avant">
              <i class="fas fa-search-plus"></i>
            </button>
          </div>
        </div>
        
        <div 
          class="editor-canvas"
          :class="{ 'show-grid': showGrid }"
          :style="{ transform: `scale(${zoomLevel})` }"
          @dragover.prevent
          @drop="drop($event)"
          @click="deselectElement"
        >
          <!-- Guides d'alignement -->
          <div v-for="(position, index) in activeGuides.vertical" :key="'v-' + index" 
               class="alignment-guide vertical-guide"
               :style="{ left: position + 'px' }"></div>
          <div v-for="(position, index) in activeGuides.horizontal" :key="'h-' + index" 
               class="alignment-guide horizontal-guide"
               :style="{ top: position + 'px' }"></div>
          <div 
            v-for="(element, index) in templateElements" 
            :key="index"
            class="canvas-element"
            :class="{ 
              'selected': selectedElementIndex === index,
              'placeholder-element': element.type === 'placeholder'
            }"
            :style="{
              left: `${element.x}px`,
              top: `${element.y}px`,
              color: element.color,
              fontSize: `${element.fontSize}px`,
              fontFamily: element.fontFamily || 'Arial, sans-serif',
              textAlign: element.textAlign,
              fontWeight: element.fontWeight || 'normal',
              fontStyle: element.fontStyle || 'normal',
              textDecoration: element.textDecoration || 'none',
              backgroundColor: element.type !== 'table' ? (element.backgroundColor || 'transparent') : 'transparent',
              padding: '5px',
              borderRadius: '3px',
              width: element.type === 'table' ? `${element.width}px` : 'auto'
            }"
            :data-element-id="element.id"
            @click.stop="selectElement(index)"
          >
            <!-- Contrôles d'élément (déplacer, supprimer, redimensionner) -->
            <div class="element-controls" v-if="selectedElementIndex === index">
              <!-- Drag handle pour tous les éléments sauf les tableaux qui ont leur propre handle -->
              <div v-if="element.type !== 'table'" class="element-drag-handle" @mousedown.stop="startDrag($event, index)">
                <i class="fas fa-arrows-alt"></i>
              </div>
              <!-- Bouton de suppression -->
              <div class="element-delete-handle" @click.stop="removeElement(index)">
                <i class="fas fa-trash"></i>
              </div>
              <!-- Poignées de redimensionnement pour les éléments qui peuvent être redimensionnés -->
              <div v-if="element.type !== 'placeholder'" class="resize-handle resize-handle-se" @mousedown.stop="startResize($event, index, 'se')"></div>
              <div v-if="element.type !== 'placeholder'" class="resize-handle resize-handle-sw" @mousedown.stop="startResize($event, index, 'sw')"></div>
              <div v-if="element.type !== 'placeholder'" class="resize-handle resize-handle-ne" @mousedown.stop="startResize($event, index, 'ne')"></div>
              <div v-if="element.type !== 'placeholder'" class="resize-handle resize-handle-nw" @mousedown.stop="startResize($event, index, 'nw')"></div>
            </div>
            
            <!-- Drag handle visible même quand l'élément n'est pas sélectionné -->
            <div v-if="element.type !== 'table' && selectedElementIndex !== index" class="element-drag-handle" @mousedown.stop="startDrag($event, index)">
              <i class="fas fa-arrows-alt"></i>
            </div>
            <span class="element-id-placeholder" v-if="element.type !== 'table' && showElementIds">ID: {{element.id}}</span>
            <i v-if="element.type === 'icon'" :class="element.icon"></i>
            <img 
              v-else-if="element.type === 'logo'" 
              :src="element.src" 
              alt="Logo" 
              :style="{ width: `${element.width}px` }"
            >
            <div 
              v-else-if="element.type === 'divider'" 
              class="horizontal-divider-container"
              :style="{
                width: `${element.width}px`
              }"
            >
              <hr 
                class="horizontal-divider"
                :style="{
                  height: `${element.height}px`,
                  border: 'none',
                  backgroundColor: element.color,
                  borderTop: `${element.height}px ${element.borderStyle} ${element.color}`
                }"
              />
            </div>
            <div v-else-if="element.type === 'table'" class="table-container">
              <div class="table-drag-handle" @mousedown.stop="startDrag($event, index)">
                <i class="fas fa-arrows-alt"></i>
              </div>
              <span class="element-id-placeholder" v-if="showElementIds">ID: {{element.id}}</span>
              <table 
                :style="{
                  width: '100%',
                  borderCollapse: 'collapse',
                  borderSpacing: '0',
                  border: `${element.borderWidth}px ${element.borderStyle} ${element.borderColor}`
                }"
                :data-element-id="element.id"
                @click.stop="selectElement(index)"
              >
              <thead>
                <tr>
                  <th 
                    v-for="col in element.columns" 
                    :key="col"
                    :style="{
                      padding: `${element.cellPadding}px`,
                      backgroundColor: element.headerBackgroundColor,
                      border: `${element.borderWidth}px ${element.borderStyle} ${element.borderColor}`,
                      textAlign: element.textAlign
                    }"
                    :data-cell-id="`${element.headerIds && element.headerIds[col-1] ? element.headerIds[col-1] : `header_${col}`}`"
                  >
                    <span class="element-id-placeholder" v-if="showElementIds">ID: {{element.headerIds && element.headerIds[col-1] ? element.headerIds[col-1] : `header_${col}`}}</span>
                    <div 
                      contenteditable="false" 
                      class="editable-cell"
                      @click.stop
                      @mousedown.stop
                    >{{ element.headers && element.headers[col-1] ? element.headers[col-1] : `Entête ${col}` }}</div>
                  </th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="row in element.rows - 1" :key="row">
                  <td 
                    v-for="col in element.columns" 
                    :key="col"
                    :style="{
                      padding: `${element.cellPadding}px`,
                      backgroundColor: element.cellBackgroundColor,
                      border: `${element.borderWidth}px ${element.borderStyle} ${element.borderColor}`,
                      textAlign: element.textAlign
                    }"
                    :data-cell-id="`${element.headerIds && element.headerIds[col-1] ? element.headerIds[col-1] : `col${col}`}_row${row}`"
                  >
                    <span class="element-id-placeholder" v-if="showElementIds">ID: {{element.headerIds && element.headerIds[col-1] ? element.headerIds[col-1] : `col${col}`}}_row{{row}}</span>
                    <div 
                      contenteditable="true" 
                      class="editable-cell"
                      @click.stop
                      @mousedown.stop
                    >Cellule {{ row }},{{ col }}</div>
                  </td>
                </tr>
              </tbody>
            </table>
            <div class="table-row-buttons" v-if="showElementIds">
              <button class="table-row-button" @click.stop="removeTableRow(index)" title="Supprimer une ligne">
                <i class="fas fa-chevron-up"></i>
              </button>
              <button class="table-row-button" @click.stop="addTableRow(index)" title="Ajouter une ligne">
                <i class="fas fa-chevron-down"></i>
              </button>
            </div>
            </div>
            <div v-else contenteditable="true">{{ element.content }}</div>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Template Information Form -->
    <div class="template-info-form">
      <h3>Informations du modèle</h3>
      <div class="form-row">
        <div class="form-group">
          <label for="template-name">Nom du modèle</label>
          <input 
            type="text" 
            id="template-name" 
            v-model="templateName" 
            placeholder="Entrez un nom pour votre modèle"
          >
        </div>
        

      </div>
      

    </div>
    


    <!-- Action Buttons -->
    <div class="action-buttons">
      <button class="btn-secondary" @click="$emit('go-back')">
        <i class="fas fa-arrow-left"></i> Retour
      </button>
      <button 
        class="btn-primary" 
        :disabled="!isTemplateValid || isSaving" 
        @click="saveTemplate"
      >
        <i class="fas fa-save"></i> Enregistrer le modèle
      </button>
    </div>
    
    <!-- Success Modal -->
    <div v-if="showSuccessModal" class="modal-overlay" @click.self="closeSuccessModal">
      <div class="success-modal">
        <div class="modal-header">
          <div class="success-icon">
            <i class="fas fa-check-circle"></i>
          </div>
          <button class="close-button" @click="closeSuccessModal">
            <i class="fas fa-times"></i>
          </button>
        </div>
        <h2>{{ isEditing ? 'Modèle mis à jour avec succès!' : 'Modèle crée avec succès!' }}</h2>
        <p>{{ isEditing ? 'Les modifications ont été enregistrées.' : 'Le modèle a été ajouté à votre bibliothèque de modèles.' }}</p>
        <div class="modal-actions">
          <template v-if="adminMode">
            <button class="btn btn-primary" @click="handleAdminSuccess">OK</button>
          </template>
          <template v-else>
            <button class="btn btn-secondary" @click="goToTemplateList">Voir la liste des modèles personnalisés</button>
            <button class="btn btn-primary" @click="createAnother">{{ isEditing ? 'Modifier un autre modèle' : 'Créer un autre modèle' }}</button>
          </template>
        </div>
      </div>
    </div>
    
    <!-- Error Modal -->
    <div v-if="showErrorModal" class="modal-overlay" @click.self="closeErrorModal">
      <div class="error-modal">
        <div class="modal-header">
          <div class="error-icon">
            <i class="fas fa-exclamation-circle"></i>
          </div>
          <button class="close-button" @click="closeErrorModal">
            <i class="fas fa-times"></i>
          </button>
        </div>
        <h2>Erreur lors de l'enregistrement</h2>
        <p>{{ errorMessage }}</p>
        <div class="modal-actions">
          <button class="btn btn-outlined" @click="closeErrorModal">Fermer</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import notificationService from '@/services/notificationService';
import { createTemplate, updateTemplate } from '@/services/templateService';

export default {
  name: 'CustomTemplateEditor',
  props: {
    documentType: {
      type: String,
      required: true,
      validator: value => ['devis', 'facture'].includes(value)
    },
    editMode: {
      type: Boolean,
      default: false
    },
    templateToEdit: {
      type: Object,
      default: null
    },
    adminMode: {
      type: Boolean,
      default: false
    }
  },
  emits: ['template-created', 'go-back'],
  created() {
    console.log('CustomTemplateEditor created with props:', {
      documentType: this.documentType,
      editMode: this.editMode,
      templateToEdit: this.templateToEdit
    });
    
    // Initialize from template if in edit mode
    if (this.editMode && this.templateToEdit) {
      console.log('Initializing from template in created hook:', this.templateToEdit);
      this.isEditing = true;
      this.initializeFromTemplate(this.templateToEdit);
    }
  },
  
  mounted() {
    console.log('CustomTemplateEditor mounted with props:', {
      documentType: this.documentType,
      editMode: this.editMode,
      templateToEdit: this.templateToEdit
    });
    
    // Double-check initialization in mounted hook
    if (this.editMode && this.templateToEdit && this.templateElements.length === 0) {
      console.log('Re-initializing from template in mounted hook:', this.templateToEdit);
      this.isEditing = true;
      this.initializeFromTemplate(this.templateToEdit);
    }
  },
  
  data() {
    return {
      showSuccessModal: false,
      showErrorModal: false,
      isSaving: false,
      isEditing: false,
      templateName: '',
      // Configuration du design (couleurs, etc.)
      designConfig: {
        colors: {
          primary: '#4bc0c0',
          secondary: '#f8f9fa',
          text: '#333333',
          accent: '#ff9f40'
        }
      },
      // Thèmes de couleurs prédéfinis
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
      ],
      templateElements: [],
      selectedElementIndex: null,
      selectedTableCell: null,
      isDragging: false,
      isResizing: false,
      resizeCorner: null,
      dragStartX: 0,
      dragStartY: 0,
      elementStartX: 0,
      elementStartY: 0,
      elementStartWidth: 0,
      elementStartHeight: 0,
      showGrid: false,
      showElementIds: true,
      // Guides d'alignement
      showAlignmentGuides: true,
      alignmentThreshold: 10, // Distance en pixels pour activer l'alignement
      activeGuides: {
        horizontal: [],
        vertical: []
      },
      zoomLevel: 1,
      elementIdCounter: 1,
      availableElements: [
        // Éléments de base
        { 
          type: 'text', 
          label: 'Texte', 
          icon: 'fas fa-font',
          content: 'Texte personnalisé',
          fontSize: 16,
          color: '#000000',
          textAlign: 'left',
          fontFamily: 'Arial, sans-serif',
          fontWeight: 'normal',
          fontStyle: 'normal',
          textDecoration: 'none',
          backgroundColor: 'transparent',
          x: 50,
          y: 50,
          id: 'text'
        },
        { 
          type: 'divider', 
          label: 'Ligne Horizontale', 
          icon: 'fas fa-grip-lines',
          width: 796,
          height: 2.5,
          color: '#000000',
          borderStyle: 'solid',
          x: 50,
          y: 50,
          id: 'divider'
        },
        { 
          type: 'text', 
          label: 'Avertissement', 
          icon: 'fas fa-exclamation-triangle',
          content: '{{warning}}',
          fontSize: 16,
          color: '#cc0000',
          textAlign: 'left',
          fontFamily: 'Arial, sans-serif',
          fontWeight: 'normal',
          fontStyle: 'normal',
          textDecoration: 'none',
          backgroundColor: '#fff8f8',
          x: 50,
          y: 400,
          id: 'warning'
        },
        { 
          type: 'text', 
          label: 'Informations Bancaires', 
          icon: 'fas fa-university',
          content: '{{bank_info}}',
          fontSize: 16,
          color: '#000000',
          textAlign: 'left',
          fontFamily: 'Arial, sans-serif',
          fontWeight: 'normal',
          fontStyle: 'normal',
          textDecoration: 'none',
          backgroundColor: '#f8f8ff',
          x: 50,
          y: 450,
          id: 'bank_info'
        },
        { 
          type: 'table', 
          label: 'Tableau', 
          icon: 'fas fa-table',
          content: 'Tableau produits',
          rows: 4, // 1 ligne d'en-tête + 3 lignes de données
          columns: 6,
          cellPadding: 8,
          borderWidth: 1,
          borderColor: '#000000',
          borderStyle: 'solid',
          headerBackgroundColor: '#f0f0f0',
          cellBackgroundColor: '#ffffff',
          fontSize: 14,
          color: '#000000',
          textAlign: 'left',
          fontFamily: 'Arial, sans-serif',
          fontWeight: 'normal',
          fontStyle: 'normal',
          textDecoration: 'none',
          x: 50,
          y: 50,
          width: 700,
          height: 200,
          id: 'tab',
          headers: ['REF', 'Détails', 'Quantité', 'PU HT', 'Total HT', 'TVA'],
          headerIds: ['tab_ref', 'tab_details', 'tab_quantite', 'tab_pu_ht', 'tab_total_ht', 'tab_tva']
        },
        { 
          type: 'logo', 
          label: 'Logo', 
          icon: 'fas fa-image',
          src: '/src/assets/logo.jpg',
          width: 100,
          x: 50,
          y: 20,
          id: 'logo'
        },
        
        // Informations Entreprise
        { 
          type: 'placeholder', 
          label: 'Nom Entreprise', 
          icon: 'fas fa-building',
          content: '{{company_name}}',
          fontSize: 16,
          color: '#000000',
          textAlign: 'left',
          fontFamily: 'Arial, sans-serif',
          fontWeight: 'normal',
          fontStyle: 'normal',
          textDecoration: 'none',
          backgroundColor: 'transparent',
          x: 400,
          y: 10,
          id: 'company_name'
        },
        { 
          type: 'placeholder', 
          label: 'Adresse Entreprise', 
          icon: 'fas fa-building',
          content: '{{company_address}}',
          fontSize: 16,
          color: '#000000',
          textAlign: 'left',
          fontFamily: 'Arial, sans-serif',
          fontWeight: 'normal',
          fontStyle: 'normal',
          textDecoration: 'none',
          backgroundColor: 'transparent',
          x: 400,
          y: 20,
          id: 'company_address'
        },
        { 
          type: 'placeholder', 
          label: 'SIRET', 
          icon: 'fas fa-id-card',
          content: '{{company_siret}}',
          fontSize: 16,
          color: '#000000',
          textAlign: 'left',
          fontFamily: 'Arial, sans-serif',
          fontWeight: 'normal',
          fontStyle: 'normal',
          textDecoration: 'none',
          backgroundColor: 'transparent',
          x: 400,
          y: 40,
          id: 'company_siret'
        },
        { 
          type: 'placeholder', 
          label: 'Téléphone Entreprise', 
          icon: 'fas fa-phone',
          content: '{{company_phone}}',
          fontSize: 16,
          color: '#000000',
          textAlign: 'left',
          fontFamily: 'Arial, sans-serif',
          fontWeight: 'normal',
          fontStyle: 'normal',
          textDecoration: 'none',
          backgroundColor: 'transparent',
          x: 400,
          y: 60,
          id: 'company_phone'
        },
        { 
          type: 'placeholder', 
          label: 'Email Entreprise', 
          icon: 'fas fa-envelope',
          content: '{{company_email}}',
          fontSize: 16,
          color: '#000000',
          textAlign: 'left',
          fontFamily: 'Arial, sans-serif',
          fontWeight: 'normal',
          fontStyle: 'normal',
          textDecoration: 'none',
          backgroundColor: 'transparent',
          x: 400,
          y: 80,
          id: 'company_email'
        },
        
        // Informations Client
        { 
          type: 'placeholder', 
          label: 'Nom Complet Client', 
          icon: 'fas fa-user',
          content: '{{client_fullname}}',
          fontSize: 16,
          color: '#000000',
          textAlign: 'left',
          fontFamily: 'Arial, sans-serif',
          fontWeight: 'normal',
          fontStyle: 'normal',
          textDecoration: 'none',
          backgroundColor: 'transparent',
          x: 50,
          y: 120,
          id: 'client_fullname'
        },
        { 
          type: 'placeholder', 
          label: 'Adresse Client', 
          icon: 'fas fa-map-marker-alt',
          content: '{{client_address}}',
          fontSize: 16,
          color: '#000000',
          textAlign: 'left',
          fontFamily: 'Arial, sans-serif',
          fontWeight: 'normal',
          fontStyle: 'normal',
          textDecoration: 'none',
          backgroundColor: 'transparent',
          x: 50,
          y: 150,
          id: 'client_address'
        },
        { 
          type: 'placeholder', 
          label: 'Téléphone Client', 
          icon: 'fas fa-phone',
          content: '{{client_phone}}',
          fontSize: 16,
          color: '#000000',
          textAlign: 'left',
          fontFamily: 'Arial, sans-serif',
          fontWeight: 'normal',
          fontStyle: 'normal',
          textDecoration: 'none',
          backgroundColor: 'transparent',
          x: 50,
          y: 140,
          id: 'client_phone'
        },
        { 
          type: 'placeholder', 
          label: 'Email Client', 
          icon: 'fas fa-envelope',
          content: '{{client_email}}',
          fontSize: 16,
          color: '#000000',
          textAlign: 'left',
          fontFamily: 'Arial, sans-serif',
          fontWeight: 'normal',
          fontStyle: 'normal',
          textDecoration: 'none',
          backgroundColor: 'transparent',
          x: 50,
          y: 160,
          id: 'client_email'
        },
        
        // Informations Document
        { 
          type: 'placeholder', 
          label: 'Numéro', 
          icon: 'fas fa-hashtag',
          content: '{{document_number}}',
          fontSize: 16,
          color: '#000000',
          textAlign: 'right',
          fontFamily: 'Arial, sans-serif',
          fontWeight: 'normal',
          fontStyle: 'normal',
          textDecoration: 'none',
          backgroundColor: 'transparent',
          x: 400,
          y: 100,
          id: 'document_number'
        },
        { 
          type: 'placeholder', 
          label: 'Date', 
          icon: 'fas fa-calendar-alt',
          content: '{{date}}',
          fontSize: 16,
          color: '#000000',
          textAlign: 'right',
          fontFamily: 'Arial, sans-serif',
          fontWeight: 'normal',
          fontStyle: 'normal',
          textDecoration: 'none',
          backgroundColor: 'transparent',
          x: 400,
          y: 50,
          id: 'date'
        },
        { 
          type: 'placeholder', 
          label: 'Date Document', 
          icon: 'fas fa-calendar-day',
          content: '{{document_date}}',
          fontSize: 16,
          color: '#000000',
          textAlign: 'right',
          fontFamily: 'Arial, sans-serif',
          fontWeight: 'normal',
          fontStyle: 'normal',
          textDecoration: 'none',
          backgroundColor: 'transparent',
          x: 400,
          y: 80,
          id: 'document_date'
        },
        
        // Totaux et Montants
        { 
          type: 'placeholder', 
          label: 'Total HT', 
          icon: 'fas fa-calculator',
          content: '{{total_ht}}',
          fontSize: 16,
          color: '#000000',
          textAlign: 'right',
          fontFamily: 'Arial, sans-serif',
          fontWeight: 'normal',
          fontStyle: 'normal',
          textDecoration: 'none',
          backgroundColor: 'transparent',
          x: 400,
          y: 300,
          id: 'total_ht'
        },
        { 
          type: 'placeholder', 
          label: 'Total Net HT', 
          icon: 'fas fa-calculator',
          content: '{{total_net_ht}}',
          fontSize: 16,
          color: '#000000',
          textAlign: 'right',
          fontFamily: 'Arial, sans-serif',
          fontWeight: 'normal',
          fontStyle: 'normal',
          textDecoration: 'none',
          backgroundColor: 'transparent',
          x: 400,
          y: 320,
          id: 'total_net_ht'
        },
        { 
          type: 'placeholder', 
          label: 'Total Remise', 
          icon: 'fas fa-tags',
          content: '{{total_discount}}',
          fontSize: 16,
          color: '#000000',
          textAlign: 'right',
          fontFamily: 'Arial, sans-serif',
          fontWeight: 'normal',
          fontStyle: 'normal',
          textDecoration: 'none',
          backgroundColor: 'transparent',
          x: 400,
          y: 340,
          id: 'total_discount'
        },
        { 
          type: 'placeholder', 
          label: 'TVA', 
          icon: 'fas fa-percentage',
          content: '{{tva}}',
          fontSize: 16,
          color: '#000000',
          textAlign: 'right',
          fontFamily: 'Arial, sans-serif',
          fontWeight: 'normal',
          fontStyle: 'normal',
          textDecoration: 'none',
          backgroundColor: 'transparent',
          x: 400,
          y: 350,
          id: 'tva'
        },
        { 
          type: 'placeholder', 
          label: 'Total TTC', 
          icon: 'fas fa-euro-sign',
          content: '{{total_ttc}}',
          fontSize: 16,
          color: '#000000',
          textAlign: 'right',
          fontFamily: 'Arial, sans-serif',
          fontWeight: 'normal',
          fontStyle: 'normal',
          textDecoration: 'none',
          backgroundColor: 'transparent',
          x: 400,
          y: 400,
          id: 'total_ttc'
        }
      ]
    };
  },
  computed: {
    selectedElement() {
      return this.selectedElementIndex !== null ? this.templateElements[this.selectedElementIndex] : null;
    },
    isTemplateValid() {
      return this.templateName.trim() !== '' && this.templateElements.length > 0;
    }
  },
  mounted() {
    // Ajouter les écouteurs d'événements pour le drag and drop et le redimensionnement
    document.addEventListener('mousemove', this.onDrag);
    document.addEventListener('mousemove', this.onResize);
    document.addEventListener('mouseup', this.stopDrag);
    document.addEventListener('mouseup', this.stopResize);
    
    // Vérifier si nous sommes en mode édition avec un template à modifier
    if (this.editMode && this.templateToEdit) {
      console.log('Mode édition activé, initialisation avec le template:', this.templateToEdit);
      this.initializeFromTemplate(this.templateToEdit);
    } else {
      // Initialiser l'éditeur avec un élément par défaut
      this.addElement(this.availableElements[0]);
    }
    
    // Initialiser les couleurs du design
    this.updateDesignColors();
  },
  beforeUnmount() {
    document.removeEventListener('mousemove', this.onDrag);
    document.removeEventListener('mousemove', this.onResize);
    document.removeEventListener('mouseup', this.stopDrag);
    document.removeEventListener('mouseup', this.stopResize);
  },
  methods: {
    // Vérifier l'alignement avec d'autres éléments
    checkAlignment(x, y, currentElement) {
      // Résultat par défaut
      let result = { x, y };
      
      // Obtenir les dimensions et positions de l'élément courant
      const currentLeft = x;
      const currentRight = x + (currentElement.width || 100); // Largeur par défaut si non définie
      const currentTop = y;
      const currentBottom = y + (currentElement.height || 30); // Hauteur par défaut si non définie
      const currentCenterX = currentLeft + (currentElement.width || 100) / 2;
      const currentCenterY = currentTop + (currentElement.height || 30) / 2;
      
      // Tableaux pour stocker les positions d'alignement potentielles
      const horizontalAlignments = [];
      const verticalAlignments = [];
      
      // Vérifier l'alignement avec chaque autre élément
      this.templateElements.forEach((element, index) => {
        // Ignorer l'élément actuellement déplacé
        if (index === this.selectedElementIndex) return;
        
        // Obtenir les dimensions et positions de l'élément cible
        const targetLeft = element.x;
        const targetRight = element.x + (element.width || 100);
        const targetTop = element.y;
        const targetBottom = element.y + (element.height || 30);
        const targetCenterX = targetLeft + (element.width || 100) / 2;
        const targetCenterY = targetTop + (element.height || 30) / 2;
        
        // Vérifier les alignements horizontaux
        // Alignement gauche à gauche
        if (Math.abs(currentLeft - targetLeft) < this.alignmentThreshold) {
          horizontalAlignments.push({ position: targetLeft, distance: Math.abs(currentLeft - targetLeft) });
        }
        // Alignement droite à droite
        if (Math.abs(currentRight - targetRight) < this.alignmentThreshold) {
          horizontalAlignments.push({ position: targetRight - (currentElement.width || 100), distance: Math.abs(currentRight - targetRight) });
        }
        // Alignement centre à centre horizontal
        if (Math.abs(currentCenterX - targetCenterX) < this.alignmentThreshold) {
          horizontalAlignments.push({ position: targetCenterX - (currentElement.width || 100) / 2, distance: Math.abs(currentCenterX - targetCenterX) });
        }
        // Alignement gauche à droite
        if (Math.abs(currentLeft - targetRight) < this.alignmentThreshold) {
          horizontalAlignments.push({ position: targetRight, distance: Math.abs(currentLeft - targetRight) });
        }
        // Alignement droite à gauche
        if (Math.abs(currentRight - targetLeft) < this.alignmentThreshold) {
          horizontalAlignments.push({ position: targetLeft - (currentElement.width || 100), distance: Math.abs(currentRight - targetLeft) });
        }
        
        // Vérifier les alignements verticaux
        // Alignement haut à haut
        if (Math.abs(currentTop - targetTop) < this.alignmentThreshold) {
          verticalAlignments.push({ position: targetTop, distance: Math.abs(currentTop - targetTop) });
        }
        // Alignement bas à bas
        if (Math.abs(currentBottom - targetBottom) < this.alignmentThreshold) {
          verticalAlignments.push({ position: targetBottom - (currentElement.height || 30), distance: Math.abs(currentBottom - targetBottom) });
        }
        // Alignement centre à centre vertical
        if (Math.abs(currentCenterY - targetCenterY) < this.alignmentThreshold) {
          verticalAlignments.push({ position: targetCenterY - (currentElement.height || 30) / 2, distance: Math.abs(currentCenterY - targetCenterY) });
        }
        // Alignement haut à bas
        if (Math.abs(currentTop - targetBottom) < this.alignmentThreshold) {
          verticalAlignments.push({ position: targetBottom, distance: Math.abs(currentTop - targetBottom) });
        }
        // Alignement bas à haut
        if (Math.abs(currentBottom - targetTop) < this.alignmentThreshold) {
          verticalAlignments.push({ position: targetTop - (currentElement.height || 30), distance: Math.abs(currentBottom - targetTop) });
        }
      });
      
      // Trouver l'alignement horizontal le plus proche
      if (horizontalAlignments.length > 0) {
        horizontalAlignments.sort((a, b) => a.distance - b.distance);
        result.x = horizontalAlignments[0].position;
        this.activeGuides.vertical = [horizontalAlignments[0].position];
      }
      
      // Trouver l'alignement vertical le plus proche
      if (verticalAlignments.length > 0) {
        verticalAlignments.sort((a, b) => a.distance - b.distance);
        result.y = verticalAlignments[0].position;
        this.activeGuides.horizontal = [verticalAlignments[0].position];
      }
      
      return result;
    },
    
    // Initialiser l'éditeur avec les données d'un template existant
    initializeFromTemplate(template) {
      console.log('CustomTemplateEditor: Initialisation de l\'éditeur avec le template:', template);
      console.log('CustomTemplateEditor: Template ID:', template.id);
      console.log('CustomTemplateEditor: Template design_config:', template.design_config);
      
      // Définir le nom du template et autres propriétés
      this.templateName = template.name || '';
      this.templateDescription = template.description || '';
      this.templateCategory = template.category || 'standard';
      

      
      // Charger les éléments du template
      try {
        let designConfig = template.design_config;
        
        // Si design_config est une chaîne, la parser en objet
        if (typeof designConfig === 'string') {
          console.log('CustomTemplateEditor: Parsing design_config string:', designConfig);
          designConfig = JSON.parse(designConfig);
        }
        
        console.log('CustomTemplateEditor: Parsed design_config:', designConfig);
        
        // Initialiser les couleurs et autres propriétés de design
        if (designConfig && designConfig.colors) {
          // Stocker les couleurs originales du thème avant de les mettre à jour
          const originalColors = { ...this.designConfig.colors };
          
          // Remplacer complètement les couleurs par défaut par celles du template
          this.designConfig.colors = {
            ...designConfig.colors  // Utiliser uniquement les couleurs du template
          };
          
          // S'assurer que toutes les propriétés de couleur nécessaires sont présentes
          if (!this.designConfig.colors.primary) this.designConfig.colors.primary = originalColors.primary;
          if (!this.designConfig.colors.secondary) this.designConfig.colors.secondary = originalColors.secondary;
          if (!this.designConfig.colors.text) this.designConfig.colors.text = originalColors.text;
          if (!this.designConfig.colors.accent) this.designConfig.colors.accent = originalColors.accent;
          
          console.log('CustomTemplateEditor: Couleurs originales:', originalColors);
          console.log('CustomTemplateEditor: Couleurs du template:', designConfig.colors);
          console.log('CustomTemplateEditor: Couleurs mises à jour:', this.designConfig.colors);
        } else {
          console.warn('CustomTemplateEditor: Aucune couleur trouvée dans le template, utilisation des couleurs par défaut');
        }
        
        // Initialiser les éléments du template
        if (designConfig && designConfig.elements && Array.isArray(designConfig.elements)) {
          console.log('CustomTemplateEditor: Found elements in design_config:', designConfig.elements);
          
          // Réinitialiser les éléments existants
          this.templateElements = [];
          
          // Ajouter chaque élément du template
          designConfig.elements.forEach(element => {
            const newElement = {
              ...element,
              // Assurer que chaque élément a un ID unique
              id: element.id || this.generateUniqueId()
            };
            console.log('CustomTemplateEditor: Adding element to template:', newElement);
            this.templateElements.push(newElement);
          });
          
          console.log('CustomTemplateEditor: Éléments du template chargés:', this.templateElements);
          console.log('CustomTemplateEditor: Number of elements loaded:', this.templateElements.length);
          
          // Ne pas forcer l'application des couleurs du thème pour préserver les couleurs originales
          this.$nextTick(() => {
            console.log('CustomTemplateEditor: Préservation des couleurs originales des éléments chargés');
            // Ne pas appeler updateDesignColors() pour conserver les couleurs personnalisées
          });
        } else {
          console.warn('CustomTemplateEditor: Aucun élément trouvé dans le template ou format invalide');
          if (!designConfig) console.warn('CustomTemplateEditor: designConfig is null or undefined');
          else if (!designConfig.elements) console.warn('CustomTemplateEditor: designConfig.elements is null or undefined');
          else if (!Array.isArray(designConfig.elements)) console.warn('CustomTemplateEditor: designConfig.elements is not an array');
          
          // Ajouter un élément par défaut si aucun n'est trouvé
          console.log('CustomTemplateEditor: Adding default element');
          this.addElement(this.availableElements[0]);
        }
        
        // Mettre à jour les couleurs du design
        this.updateDesignColors();
      } catch (error) {
        console.error('CustomTemplateEditor: Erreur lors du chargement des éléments du template:', error);
        // Ajouter un élément par défaut en cas d'erreur
        console.log('CustomTemplateEditor: Adding default element due to error');
        this.addElement(this.availableElements[0]);
      }
    },
    
    // Drag and Drop Functionality
    dragStart(event, element) {
      // Clone the element to avoid modifying the original
      const clonedElement = JSON.parse(JSON.stringify(element));
      event.dataTransfer.setData('text/plain', JSON.stringify(clonedElement));
      event.dataTransfer.effectAllowed = 'copy';
      
      // Create a custom drag image
      const dragIcon = document.createElement('div');
      dragIcon.className = 'drag-preview';
      dragIcon.innerHTML = `<i class="${element.icon}"></i> ${element.label}`;
      document.body.appendChild(dragIcon);
      event.dataTransfer.setDragImage(dragIcon, 20, 20);
      
      // Remove the drag preview element after a short delay
      setTimeout(() => {
        document.body.removeChild(dragIcon);
      }, 100);
    },
    
    // Add a new element to the template
    addElement(elementTemplate, x = 100, y = 100) {
      try {
        // Clone the element template to avoid modifying the original
        const element = JSON.parse(JSON.stringify(elementTemplate));
        
        // Set position
        element.x = x;
        element.y = y;
        
        // Liste des éléments à usage unique avec ID fixe
        const uniqueElements = ['Email Entreprise', 'Nom Complet Client'];
        
        // Liste des éléments qui peuvent être utilisés plusieurs fois
        const multiUseElements = ['Texte', 'Ligne Horizontale'];
        
        // Vérifier si l'élément peut être utilisé plusieurs fois
        if (!multiUseElements.includes(element.label)) {
          // Vérifier si un élément avec le même label existe déjà sur le canevas
          const elementExists = this.templateElements.some(el => el.label === element.label);
          if (elementExists) {
            // Log warning but don't show error when initializing
            console.warn(`Un élément "${element.label}" existe déjà dans le modèle.`);
            return false;
          }
        }
        
        // Generate a unique ID for the element
        const baseId = element.id || element.type;
        if (multiUseElements.includes(element.label)) {
          // Pour les éléments à usage multiple, générer un ID unique
          element.id = `${baseId}_${this.elementIdCounter++}`;
        } else if (uniqueElements.includes(element.label)) {
          // Pour les éléments à usage unique, utiliser un ID fixe
          element.id = baseId;
        } else {
          // Pour les autres éléments, garder l'ID d'origine
          element.id = baseId;
        }
        
        // Add the element to the template
        this.templateElements.push(element);
        this.selectedElementIndex = this.templateElements.length - 1;
        return true;
      } catch (error) {
        console.error('Error adding element:', error);
        return false;
      }
    },
    
    drop(event) {
      const data = event.dataTransfer.getData('text/plain');
      try {
        const element = JSON.parse(data);
        
        // Calculate position relative to canvas
        const canvasRect = event.currentTarget.getBoundingClientRect();
        const x = (event.clientX - canvasRect.left) / this.zoomLevel;
        const y = (event.clientY - canvasRect.top) / this.zoomLevel;
        
        // Use the addElement method to add the element
        const added = this.addElement(element, x, y);
        
        // Liste des éléments qui peuvent être utilisés plusieurs fois
        const multiUseElements = ['Texte', 'Ligne Horizontale'];
        
        // Show error message if element couldn't be added (only during drag and drop)
        if (!added && !multiUseElements.includes(element.label)) {
          notificationService.error(`Vous ne pouvez ajouter qu'un seul élément "${element.label}" au modèle.`);
        }
      } catch (error) {
        console.error('Error dropping element:', error);
      }
    },
    
    // Handle cell content update
    updateCellContent(event, cellId) {
      // Cette fonction peut être utilisée pour sauvegarder le contenu modifié
      console.log('Cell content updated:', cellId, event.target.textContent);
    },
    
    
    // Element Selection and Manipulation
    selectElement(index) {
      this.selectedElementIndex = index;
    },
    
    deselectElement() {
      this.selectedElementIndex = null;
    },
    
    updateSelectedElement() {
      // This method is called when properties are changed
      // Vue's reactivity will handle the updates automatically
    },
    
    setAlignment(alignment) {
      if (this.selectedElement) {
        this.selectedElement.textAlign = alignment;
      }
    },
    
    toggleFontStyle(style) {
      if (!this.selectedElement) return;
      
      if (style === 'bold') {
        this.selectedElement.fontWeight = this.selectedElement.fontWeight === 'bold' ? 'normal' : 'bold';
      } else if (style === 'italic') {
        this.selectedElement.fontStyle = this.selectedElement.fontStyle === 'italic' ? 'normal' : 'italic';
      } else if (style === 'underline') {
        this.selectedElement.textDecoration = this.selectedElement.textDecoration === 'underline' ? 'none' : 'underline';
      }
    },
    
    toggleTransparentBackground() {
      if (!this.selectedElement) return;
      
      this.selectedElement.backgroundColor = this.selectedElement.backgroundColor === 'transparent' ? 
        '#ffffff' : 'transparent';
    },
    
    removeSelectedElement() {
      if (this.selectedElementIndex !== null) {
        this.templateElements.splice(this.selectedElementIndex, 1);
        this.selectedElementIndex = null;
      }
    },
    
    // Supprimer un élément spécifique par son index
    removeElement(index) {
      this.templateElements.splice(index, 1);
      this.selectedElementIndex = null;
    },
    
    // Table Dimensions Update
    updateTableDimensions() {
      if (!this.selectedElement || this.selectedElement.type !== 'table') return;
      
      // Ensure minimum values
      if (this.selectedElement.rows < 1) this.selectedElement.rows = 1;
      
      // Fixer le nombre de colonnes à 6 pour le tableau de produits
      this.selectedElement.columns = 6;
      
      // Fixer les en-têtes du tableau
      this.selectedElement.headers = ['REF', 'Détails', 'Quantité', 'PU HT', 'Total HT', 'TVA'];
      this.selectedElement.headerIds = ['tab_ref', 'tab_details', 'tab_quantite', 'tab_pu_ht', 'tab_total_ht', 'tab_tva'];
      
      // Ensure maximum values
      if (this.selectedElement.rows > 20) this.selectedElement.rows = 20;
      
      // Update the element
      this.updateSelectedElement();
    },
    
    // Ajouter une ligne au tableau
    addTableRow(elementIndex) {
      const element = this.templateElements[elementIndex];
      if (element && element.type === 'table') {
        // Vérifier que le nombre maximum de lignes n'est pas atteint
        if (element.rows < 20) {
          element.rows++;
        } else {
          notificationService.warning('Nombre maximum de lignes atteint (20).');
        }
      }
    },
    
    // Supprimer une ligne du tableau
    removeTableRow(elementIndex) {
      const element = this.templateElements[elementIndex];
      if (element && element.type === 'table') {
        // Vérifier qu'il reste au moins 2 lignes (1 ligne d'en-tête + 1 ligne de données)
        if (element.rows > 2) {
          element.rows--;
        } else {
          notificationService.warning('Le tableau doit contenir au moins une ligne de données.');
        }
      }
    },
    
    // Element Dragging
    startDrag(event, index) {
      if (event.button !== 0) return; // Only left mouse button
      
      this.isDragging = true;
      this.selectedElementIndex = index;
      
      this.dragStartX = event.clientX;
      this.dragStartY = event.clientY;
      
      const element = this.templateElements[index];
      this.elementStartX = element.x;
      this.elementStartY = element.y;
      
      event.preventDefault();
    },
    
    onDrag(event) {
      if (!this.isDragging || this.selectedElementIndex === null) return;
      
      const dx = (event.clientX - this.dragStartX) / this.zoomLevel;
      const dy = (event.clientY - this.dragStartY) / this.zoomLevel;
      
      const element = this.templateElements[this.selectedElementIndex];
      let newX = this.elementStartX + dx;
      let newY = this.elementStartY + dy;
      
      // Snap to grid if grid is enabled
      if (this.showGrid) {
        newX = Math.round(newX / 10) * 10;
        newY = Math.round(newY / 10) * 10;
      }
      
      // Réinitialiser les guides actifs
      this.activeGuides = {
        horizontal: [],
        vertical: []
      };
      
      // Appliquer les guides d'alignement si activés
      if (this.showAlignmentGuides) {
        const alignmentResult = this.checkAlignment(newX, newY, element);
        newX = alignmentResult.x;
        newY = alignmentResult.y;
      }
      
      element.x = newX;
      element.y = newY;
    },
    
    stopDrag() {
      this.isDragging = false;
      
      // Effacer les guides d'alignement
      this.activeGuides = {
        horizontal: [],
        vertical: []
      };
    },
    
    // Méthodes de redimensionnement
    startResize(event, index, corner) {
      if (event.button !== 0) return; // Only left mouse button
      
      this.isResizing = true;
      this.selectedElementIndex = index;
      this.resizeCorner = corner;
      
      this.dragStartX = event.clientX;
      this.dragStartY = event.clientY;
      
      const element = this.templateElements[index];
      
      // Sauvegarder les dimensions et positions initiales
      this.elementStartX = element.x;
      this.elementStartY = element.y;
      this.elementStartWidth = element.width || 100; // Valeur par défaut si non définie
      this.elementStartHeight = element.height || 100; // Valeur par défaut si non définie
      
      event.preventDefault();
    },
    
    onResize(event) {
      if (!this.isResizing || this.selectedElementIndex === null) return;
      
      const dx = (event.clientX - this.dragStartX) / this.zoomLevel;
      const dy = (event.clientY - this.dragStartY) / this.zoomLevel;
      
      const element = this.templateElements[this.selectedElementIndex];
      
      // Initialiser les dimensions si elles n'existent pas
      if (!element.width) element.width = 100;
      if (!element.height) element.height = 100;
      
      // Appliquer le redimensionnement en fonction du coin utilisé
      switch (this.resizeCorner) {
        case 'se': // Sud-Est (bas-droite)
          element.width = Math.max(20, this.elementStartWidth + dx);
          element.height = Math.max(20, this.elementStartHeight + dy);
          break;
        case 'sw': // Sud-Ouest (bas-gauche)
          element.width = Math.max(20, this.elementStartWidth - dx);
          element.x = this.elementStartX + dx;
          element.height = Math.max(20, this.elementStartHeight + dy);
          break;
        case 'ne': // Nord-Est (haut-droite)
          element.width = Math.max(20, this.elementStartWidth + dx);
          element.height = Math.max(20, this.elementStartHeight - dy);
          element.y = this.elementStartY + dy;
          break;
        case 'nw': // Nord-Ouest (haut-gauche)
          element.width = Math.max(20, this.elementStartWidth - dx);
          element.x = this.elementStartX + dx;
          element.height = Math.max(20, this.elementStartHeight - dy);
          element.y = this.elementStartY + dy;
          break;
      }
      
      // Snap to grid if grid is enabled
      if (this.showGrid) {
        element.width = Math.round(element.width / 10) * 10;
        element.height = Math.round(element.height / 10) * 10;
        element.x = Math.round(element.x / 10) * 10;
        element.y = Math.round(element.y / 10) * 10;
      }
    },
    
    stopResize() {
      this.isResizing = false;
      this.resizeCorner = null;
    },
    
    // Canvas Tools
    addGridLines() {
      this.showGrid = !this.showGrid;
    },
    
    toggleElementIds() {
      this.showElementIds = !this.showElementIds;
    },
    

    
    
    zoomIn() {
      if (this.zoomLevel < 2) {
        this.zoomLevel += 0.1;
      }
    },
    
    zoomOut() {
      if (this.zoomLevel > 0.5) {
        this.zoomLevel -= 0.1;
      }
    },
    
    alignElementsHorizontally() {
      if (this.templateElements.length < 2) return;
      
      // If an element is selected, align others to it
      if (this.selectedElementIndex !== null) {
        const referenceY = this.templateElements[this.selectedElementIndex].y;
        this.templateElements.forEach(element => {
          element.y = referenceY;
        });
      }
    },
    
    alignElementsVertically() {
      if (this.templateElements.length < 2) return;
      
      // If an element is selected, align others to it
      if (this.selectedElementIndex !== null) {
        const referenceX = this.templateElements[this.selectedElementIndex].x;
        this.templateElements.forEach(element => {
          element.x = referenceX;
        });
      }
    },
    
    distributeElementsEvenly() {
      if (this.templateElements.length < 3) return;
      
      // Sort elements by x position
      const sortedElements = [...this.templateElements].sort((a, b) => a.x - b.x);
      
      // Get leftmost and rightmost elements
      const leftmost = sortedElements[0].x;
      const rightmost = sortedElements[sortedElements.length - 1].x;
      
      // Calculate spacing
      const totalSpace = rightmost - leftmost;
      const spacing = totalSpace / (sortedElements.length - 1);
      
      // Distribute elements
      sortedElements.forEach((element, index) => {
        if (index > 0 && index < sortedElements.length - 1) {
          const originalIndex = this.templateElements.findIndex(e => e === element);
          this.templateElements[originalIndex].x = leftmost + (spacing * index);
        }
      });
    },
    

    
    // Template Saving
    async saveTemplate() {
      if (!this.isTemplateValid) {
        notificationService.error('Le modèle n\'est pas valide. Veuillez vérifier les informations.', {
          title: 'Validation échouée',
          duration: 5000
        });
        return;
      }
      
      this.isSaving = true;
      
      try {
        // Determine template type based on admin mode
        const templateType = this.adminMode === true ? 'predefined' : 'custom';
        
        const templateData = {
          name: this.templateName,
          type: templateType, // Use the determined type
          html_structure: this.generateTemplateHTML(),
          design_config: {
            colors: this.designConfig.colors,
            elements: this.templateElements,
            documentType: this.documentType || 'facture'
          },
          Doc_type: this.documentType || 'facture'
        };
        
        console.log('Saving template with data:', templateData);
        console.log('Admin mode:', this.adminMode, 'Template type:', templateData.type);
        
        let response;
        
        if (this.isEditing && this.templateId) {
          // Update existing template
          console.log('Updating template with ID:', this.templateId);
          response = await updateTemplate(this.templateId, templateData);
        } else {
          // Create new template
          console.log('Creating new template');
          response = await createTemplate(templateData);
        }
        
        console.log('Template save response:', response);
        
        this.isSaving = false;
        
        // Vérification claire du succès de la réponse
        if (response && response.success === true) {
          // Succès confirmé, afficher le modal de succès
          console.log('Template saved successfully');
          this.showSuccessModal = true;
        } else if (response && response.success === false) {
          // Si la réponse indique un échec
          console.error('Erreur lors de la création/mise à jour du template:', response.message);
          
          // Ignorer l'erreur de nom existant lors de la mise à jour
          if (this.isEditing && response.message && response.message.includes('existe déjà')) {
            console.log('Ignorer l\'erreur de nom existant lors de la mise à jour');
            this.showSuccessModal = true;
            return;
          }
          
          // Afficher une notification d'erreur pour tous les types d'erreurs
          notificationService.error(response.message || `Erreur lors de ${this.isEditing ? 'la mise à jour' : 'l\'enregistrement'} du modèle`, {
            title: 'Erreur',
            duration: 5000
          });
        }
      } catch (error) {
        console.error('Erreur lors de l\'enregistrement:', error);
        this.isSaving = false;
        
        // Ignorer l'erreur de nom existant lors de la mise à jour
        if (this.isEditing && error.response && error.response.data && 
            error.response.data.message && error.response.data.message.includes('existe déjà')) {
          console.log('Ignorer l\'erreur de nom existant lors de la mise à jour (catch global)');
          this.showSuccessModal = true;
          return;
        }
        
        // Vérifier si l'erreur est due à un nom de template dupliqué
        if (error.response && error.response.data && error.response.data.message) {
          notificationService.error(error.response.data.message, {
            title: 'Erreur',
            duration: 5000
          });
          return;
        }
        
        // Si l'erreur est due à un timeout ou une annulation
        if (error.name === 'CanceledError' || error.message === 'canceled') {
          console.log('La requête a été annulée, vérification si le template a été créé...');
          
          try {
            // Attendre un peu pour laisser le temps au backend de terminer le traitement
            await new Promise(resolve => setTimeout(resolve, 2000));
            
            // Récupérer les templates personnalisés pour vérifier si notre template a été créé
            const token = localStorage.getItem('token');
            const templatesResponse = await axios.get('http://localhost:5000/api/templates/custom', {
              headers: { Authorization: `Bearer ${token}` }
            });
            
            const templates = templatesResponse.data.data || [];
            const possibleMatch = templates.find(t => t.name === templateData.name);
            
            if (possibleMatch) {
              // Le template semble avoir été créé malgré l'erreur
              console.log('Template found despite error, showing success modal');
              this.showSuccessModal = true;
              return;
            }
          } catch (checkError) {
            console.error('Error checking if template was created:', checkError);
          }
          
          notificationService.error('La requête a pris trop de temps. Le modèle a peut-être été créé, veuillez vérifier la liste des modèles.', {
            title: 'Erreur de délai',
            duration: 8000
          });
        } else {
          notificationService.error('Une erreur est survenue lors de l\'enregistrement du modèle.', {
            title: 'Erreur',
            duration: 5000
          });
        }
      }
    },
    

    
    // Navigation vers la liste des modèles
    goToTemplateList() {
      // Masquer la modale
      this.showSuccessModal = false;
      
      // Stocker les données du template créé dans le localStorage pour pouvoir les récupérer plus tard si nécessaire
      if (this.templateName) {
        // Déterminer le type en fonction du mode (admin ou utilisateur)
        const templateType = this.adminMode === true ? 'predefined' : 'custom';
        
        localStorage.setItem('lastCreatedTemplate', JSON.stringify({
          name: this.templateName,
          id: this.templateId,
          type: templateType, // Utiliser le type déterminé par le mode
          design_config: this.designConfig
        }));
      }
      
      // Émettre l'événement go-back pour que le parent sache qu'on veut retourner à la liste
      this.$emit('go-back');
      
      // Rediriger vers la liste des templates personnalisés si nécessaire
      // Note: avec l'événement go-back, le parent devrait gérer la navigation
      if (!this.adminMode) {
        this.$router.push('/admin-entreprise/custom-templates');
      }
    },
    
    // Créer un autre modèle
    createAnother() {
      // Stocker temporairement les données du template créé avant de réinitialiser
      // Déterminer le type en fonction du mode (admin ou utilisateur)
      const templateType = this.adminMode === true ? 'predefined' : 'custom';
      
      const createdTemplate = {
        name: this.templateName,
        id: this.templateId,
        type: templateType, // Utiliser le type déterminé par le mode
        design_config: this.designConfig,
        html_structure: this.htmlStructure
      };
      
      // Si nous sommes en mode admin, rediriger vers la liste des templates prédéfinis
      if (this.adminMode) {
        this.showSuccessModal = false;
        this.$router.push({ 
          path: '/admin',
          query: { tab: 'predefined-templates' }
        });
        return;
      }
      
      // Sinon, continuer avec le comportement normal pour admin entreprise
      this.templateName = '';
      this.templateDescription = '';
      this.templateElements = [];
      this.selectedElementIndex = null;
      this.previewFile = null;
      this.previewUrl = null;
      
      // Masquer la modale
      this.showSuccessModal = false;
      
      // Si nous étions en mode édition, passer en mode création
      this.isEditing = false;
    },
    
    // Appliquer un thème de couleurs prédéfini
    applyColorTheme(theme) {
      console.log('Applying theme:', theme.name);
      // Copy theme values to designConfig.colors
      this.designConfig.colors = {
        primary: theme.primary,
        secondary: theme.secondary,
        text: theme.text,
        accent: theme.accent
      };
      
      // Force Vue reactivity by assigning a new object
      this.designConfig = { ...this.designConfig };
      
      // Mettre à jour les éléments du template avec les nouvelles couleurs
      this.updateDesignColors();
    },
    
    // Mettre à jour les couleurs des éléments du template
    updateDesignColors() {
      console.log('Mise à jour des couleurs avec le thème actuel:', this.designConfig.colors);
      
      // Mettre à jour les couleurs des éléments existants
      this.templateElements.forEach(element => {
        // Appliquer les couleurs selon le type d'élément
        if (element.type === 'text' || element.type === 'placeholder') {
          element.color = this.designConfig.colors.text;
          console.log(`Élément texte/placeholder ${element.id}: couleur définie à ${element.color}`);
        } else if (element.type === 'divider') {
          element.color = this.designConfig.colors.primary;
          console.log(`Élément séparateur ${element.id}: couleur définie à ${element.color}`);
        } else if (element.type === 'table') {
          element.headerBackgroundColor = this.designConfig.colors.primary;
          element.borderColor = this.designConfig.colors.accent;
          console.log(`Élément tableau ${element.id}: couleurs d'en-tête et bordure définies`);
        }
        
        // Appliquer la couleur de fond par défaut si nécessaire
        if (!element.transparentBackground && element.backgroundColor !== 'transparent') {
          // Préserver les arrières-plans transparents ou explicitement configurés comme tels
          if (element.backgroundColor !== 'transparent') {
            element.backgroundColor = this.designConfig.colors.secondary;
            console.log(`Élément ${element.id}: couleur de fond définie à ${element.backgroundColor}`);
          }
        }
      });
      
      // Force Vue reactivity by creating a new array
      this.forceTemplateUpdate();
    },
    
    generateTemplateHTML() {
      // Generate a basic HTML structure based on the elements
      let html = `
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <title>${this.templateName}</title>
          <style>
            body {
              font-family: Arial, sans-serif;
              margin: 0;
              padding: 20px;
            }
            .template-element {
              position: absolute;
            }
          </style>
        </head>
        <body>
          <div class="template-container">
      `;
      
      // Add each element
      this.templateElements.forEach(element => {
        let elementHtml = `<div class="template-element" style="
          position: absolute;
          left: ${element.x}px;
          top: ${element.y}px;
          color: ${element.color};
          font-size: ${element.fontSize}px;
          font-family: ${element.fontFamily};
          text-align: ${element.textAlign};
          font-weight: ${element.fontWeight};
          font-style: ${element.fontStyle};
          text-decoration: ${element.textDecoration};
          background-color: ${element.backgroundColor};
          padding: 5px;
        " data-element-id="${element.id}">`;
        
        if (element.type === 'logo') {
          elementHtml += `<img src="${element.src}" alt="Logo" style="width: ${element.width}px;">`;
        } else if (element.type === 'icon') {
          elementHtml += `<i class="${element.icon}"></i>`;
        } else if (element.type === 'table') {
          // Pour l'export, on ne montre pas les contrôles de collapse
          elementHtml += `<table style="width: 100%; border-collapse: collapse; border-spacing: 0; border: ${element.borderWidth}px ${element.borderStyle} ${element.borderColor};" data-element-id="${element.id}">
            <thead>
              <tr>
                ${Array(element.columns).fill().map((_, col) => {
                  // Utiliser les en-têtes personnalisés s'ils existent
                  const headerText = element.headers && element.headers[col] ? element.headers[col] : `Entête ${col+1}`;
                  const headerId = element.headerIds && element.headerIds[col] ? element.headerIds[col] : `header_${col+1}`;
                  return `
                  <th style="padding: ${element.cellPadding}px; background-color: ${element.headerBackgroundColor}; border: ${element.borderWidth}px ${element.borderStyle} ${element.borderColor}; text-align: ${element.textAlign};" data-cell-id="${headerId}">
                    ${headerText}
                  </th>
                `}).join('')}
              </tr>
            </thead>
            <tbody>
              ${Array(element.rows-1).fill().map((_, row) => `
                <tr>
                  ${Array(element.columns).fill().map((_, col) => {
                    // Utiliser les en-têtes personnalisés pour les IDs des cellules
                    const headerText = element.headers && element.headers[col] ? element.headers[col] : `col${col+1}`;
                    return `
                    <td style="padding: ${element.cellPadding}px; background-color: ${element.cellBackgroundColor}; border: ${element.borderWidth}px ${element.borderStyle} ${element.borderColor}; text-align: ${element.textAlign};" data-cell-id="${element.headerIds && element.headerIds[col] ? element.headerIds[col] : `header_${col+1}`}_row${row+1}">
                      ${col === 0 ? 'REF123' : col === 1 ? 'Produit exemple' : col === 2 ? '1' : col === 3 ? '100.00 €' : col === 4 ? '100.00 €' : '20%'}
                    </td>
                  `}).join('')}
                </tr>
              `).join('')}
            </tbody>
          </table>`;
        } else {
          elementHtml += element.content;
        }
        
        elementHtml += '</div>';
        html += elementHtml;
      });
      
      // Close the HTML structure
      html += `
          </div>
        </body>
        </html>
      `;
      
      return html;
    },
    forceTemplateUpdate() {
      // Force reactivity update on template elements
      this.templateElements = [...this.templateElements];
    },
    closeSuccessModal() {
      console.log('Fermeture de la modale de succès');
      this.showSuccessModal = false;
    },
    handleAdminSuccess() {
      this.closeSuccessModal();
      // Redirect to admin page and show predefined templates
      this.$router.push({ 
        path: '/admin',
        query: { tab: 'predefined-templates' }  // Pass the desired tab as a query parameter
      });
    },
    closeErrorModal() {
      console.log('Fermeture de la modale d\'erreur');
      this.showErrorModal = false;
    }
  }
};
</script>

<style scoped>
/* Guides d'alignement */
.alignment-guide {
  position: absolute;
  pointer-events: none;
  z-index: 1000;
}

.horizontal-guide {
  width: 100%;
  height: 1px;
  background-color: #2196F3;
  border-top: 1px dashed #2196F3;
}

.vertical-guide {
  height: 100%;
  width: 1px;
  background-color: #2196F3;
  border-left: 1px dashed #2196F3;
}

/* Style pour la ligne horizontale */
.horizontal-divider-container {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0;
  margin: 0;
}

.horizontal-divider {
  display: block;
  width: 100%;
  margin: 0;
  padding: 0;
}
.custom-template-editor {
  padding: 20px;
  max-width: 1200px;
  margin: 0 auto;
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

.editor-container {
  display: flex;
  gap: 20px;
  margin-bottom: 30px;
  height: auto;
  min-height: 600px;
}

.editor-sidebar {
  width: 300px;
  background-color: #f5f5f5;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  overflow-y: auto;
  display: flex;
  flex-direction: column;
}

.sidebar-section {
  padding: 15px;
  border-bottom: 1px solid #ddd;
}

.sidebar-section h3 {
  margin-top: 0;
  margin-bottom: 15px;
  font-size: 1.2rem;
  color: #333;
}

.elements-list {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 10px;
}

.element-item {
  background-color: #fff;
  padding: 10px;
  border-radius: 5px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
  cursor: grab;
  display: flex;
  flex-direction: column;
  align-items: center;
  transition: transform 0.2s;
}

.element-item:hover {
  transform: translateY(-2px);
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
}

.element-item i {
  font-size: 1.5rem;
  margin-bottom: 5px;
  color: #4bc0c0;
}

.properties-panel {
  padding: 10px;
}

.property-group {
  margin-bottom: 15px;
}

.property-group label {
  display: block;
  margin-bottom: 5px;
  font-weight: 500;
  color: #555;
}

.property-group input[type="text"],
.property-group input[type="number"],
.property-group select {
  width: 100%;
  padding: 8px;
  border: 1px solid #ddd;
  border-radius: 4px;
}

.range-slider {
  display: flex;
  align-items: center;
}

.range-slider input {
  flex: 1;
  margin-right: 10px;
}

.color-picker-container {
  display: flex;
  align-items: center;
  gap: 10px;
}

.color-picker-container input[type="color"] {
  width: 40px;
  height: 30px;
  padding: 0;
  border: none;
}

.style-buttons,
.alignment-buttons {
  display: flex;
  gap: 5px;
}

.style-buttons button,
.alignment-buttons button {
  width: 36px;
  height: 36px;
  border: 1px solid #ddd;
  background-color: #fff;
  border-radius: 4px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
}

.style-buttons button.active,
.alignment-buttons button.active {
  background-color: #4bc0c0;
  color: white;
  border-color: #4bc0c0;
}

.position-inputs {
  display: flex;
  gap: 10px;
}

.position-input {
  flex: 1;
  display: flex;
  align-items: center;
}

.position-input span {
  margin-right: 5px;
  font-weight: 500;
}

.table-properties {
  margin-bottom: 15px;
}

.table-dimensions {
  display: flex;
  gap: 10px;
  margin-bottom: 10px;
}

.dimension-input {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.dimension-input span {
  margin-bottom: 5px;
  font-size: 0.9rem;
}

.border-properties {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 10px;
  margin-bottom: 10px;
}

.border-width, .border-style, .border-color {
  display: flex;
  flex-direction: column;
}

.border-width span, .border-style span, .border-color span {
  margin-bottom: 5px;
  font-size: 0.9rem;
}

.background-colors {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 10px;
}

.transparent-btn {
  background-color: transparent;
  border: 1px solid #ddd;
  padding: 5px 10px;
  border-radius: 4px;
  cursor: pointer;
}

.transparent-btn.active {
  background-color: #f0f0f0;
  border-color: #aaa;
}

.btn-danger {
  background-color: #ff6b6b;
  color: white;
  border: none;
  padding: 8px 15px;
  border-radius: 4px;
  cursor: pointer;
  width: 100%;
  margin-top: 10px;
}

.no-selection {
  padding: 20px;
  text-align: center;
  color: #888;
}

.tip {
  font-size: 0.9rem;
  margin-top: 10px;
}

.editor-canvas-container {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  overflow: auto;
  padding-bottom: 2rem;
}

.canvas-toolbar {
  background-color: #f5f5f5;
  padding: 10px;
  border-radius: 8px 8px 0 0;
  display: flex;
  justify-content: space-between;
  align-items: center;
  width: 794px; /* Match A4 width */
  box-sizing: border-box;
}

.canvas-actions,
.zoom-controls {
  display: flex;
  gap: 10px;
  align-items: center;
}

.canvas-toolbar button {
  width: 36px;
  height: 36px;
  border: 1px solid #ddd;
  background-color: #fff;
  border-radius: 4px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
}

.canvas-toolbar button.active {
  background-color: #4bc0c0;
  color: white;
  border-color: #4bc0c0;
}

/* 
  Editor Canvas - Dimensions A4 fixes
  - Largeur: 210mm ≈ 794px à 96 DPI
  - Hauteur: 297mm ≈ 1123px à 96 DPI
  Ces dimensions fixes garantissent que ce que l'utilisateur conçoit dans l'éditeur
  est exactement ce qui sera affiché dans la prévisualisation et imprimé sur une page A4 réelle
  (WYSIWYG - What You See Is What You Get).
*/
.editor-canvas {
  width: 794px; /* A4 width at 96 DPI */
  height: 1123px; /* A4 height at 96 DPI */
  background-color: white;
  border: 1px solid #ddd;
  border-radius: 0 0 8px 8px;
  position: relative;
  overflow: hidden; /* Prevent content from overflowing */
  transform-origin: top left;
  margin: 0 auto;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
  box-sizing: border-box;
  padding: 30px; /* Add padding similar to template-container */
}

.editor-canvas.show-grid {
  background-image: linear-gradient(#ddd 1px, transparent 1px),
                    linear-gradient(90deg, #ddd 1px, transparent 1px);
  background-size: 10px 10px;
}

.canvas-element {
  position: absolute;
  cursor: move;
  user-select: none;
  min-width: 20px;
  min-height: 20px;
}

.canvas-element.selected {
  border: 1px dashed #4bc0c0;
  outline: 1px solid rgba(75, 192, 192, 0.5);
}

.element-id-placeholder {
  display: block;
  font-size: 10px;
  color: #4bc0c0;
  background-color: rgba(75, 192, 192, 0.1);
  padding: 2px 4px;
  border-radius: 2px;
  margin-bottom: 2px;
  font-family: monospace;
  pointer-events: none;
}

.table-container {
  position: relative;
  width: 100%;
}

.table-drag-handle, .element-drag-handle {
  position: absolute;
  top: -15px;
  left: 50%;
  transform: translateX(-50%);
  background-color: #4bc0c0;
  color: white;
  width: 24px;
  height: 24px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: move;
  z-index: 20;
  box-shadow: 0 2px 4px rgba(0,0,0,0.2);
}

.table-drag-handle:hover, .element-drag-handle:hover {
  background-color: #3da3a3;
}

.element-drag-handle {
  opacity: 0;
  transition: opacity 0.2s ease;
}

.canvas-element:hover .element-drag-handle {
  opacity: 1;
}

/* Styles pour les contrôles d'élément */
.element-controls {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: 10;
}

.element-delete-handle {
  position: absolute;
  top: -15px;
  right: -10px;
  background-color: #ff6b6b;
  color: white;
  width: 24px;
  height: 24px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  z-index: 20;
  box-shadow: 0 2px 4px rgba(0,0,0,0.2);
}

.element-delete-handle:hover {
  background-color: #e74c3c;
}

/* Styles pour les poignées de redimensionnement */
.resize-handle {
  position: absolute;
  width: 8px;
  height: 8px;
  background-color: #fff;
  border: 1px solid #4bc0c0;
  z-index: 20;
}

.resize-handle-se {
  bottom: -4px;
  right: -4px;
  cursor: se-resize;
}

.resize-handle-sw {
  bottom: -4px;
  left: -4px;
  cursor: sw-resize;
}

.resize-handle-ne {
  top: -4px;
  right: -4px;
  cursor: ne-resize;
}

.resize-handle-nw {
  top: -4px;
  left: -4px;
  cursor: nw-resize;
}

.editable-cell {
  min-height: 20px;
  padding: 2px;
  outline: none;
  cursor: text;
  position: relative;
  z-index: 10;
}

.editable-cell:focus {
  background-color: rgba(75, 192, 192, 0.05);
  box-shadow: 0 0 0 2px rgba(75, 192, 192, 0.2) inset;
}

/* Ajout d'une priorité plus élevée pour s'assurer que les événements ne sont pas capturés par le parent */
.canvas-element .editable-cell {
  pointer-events: auto !important;
}

.placeholder-element {
  background-color: rgba(75, 192, 192, 0.1);
  border-radius: 3px;
}

.template-info-form {
  background-color: #f5f5f5;
  padding: 20px;
  border-radius: 8px;
  margin-bottom: 30px;
}

.template-info-form h3 {
  margin-top: 0;
  margin-bottom: 20px;
  font-size: 1.2rem;
  color: #333;
}

.form-row {
  display: flex;
  gap: 20px;
  margin-bottom: 20px;
}

.form-group {
  flex: 1;
  margin-bottom: 15px;
}

.form-group label {
  display: block;
  margin-bottom: 5px;
  font-weight: 500;
  color: #555;
}

.form-group input,
.form-group select {
  width: 100%;
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 4px;
}

.file-upload {
  border: 2px dashed #ddd;
  padding: 20px;
  text-align: center;
  border-radius: 4px;
  background-color: #f9f9f9;
}

.upload-button {
  display: inline-flex;
  align-items: center;
  gap: 10px;
  background-color: #4bc0c0;
  color: white;
  padding: 10px 20px;
  border-radius: 4px;
  cursor: pointer;
  transition: background-color 0.3s;
}

.upload-button:hover {
  background-color: #3da3a3;
}

.file-preview {
  margin-top: 15px;
  position: relative;
  display: inline-block;
}

.file-preview img {
  max-width: 200px;
  max-height: 150px;
  border-radius: 4px;
  border: 1px solid #ddd;
}

.remove-preview {
  position: absolute;
  top: -10px;
  right: -10px;
  background-color: #ff6b6b;
  color: white;
  border: none;
  width: 24px;
  height: 24px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
}

.action-buttons {
  display: flex;
  justify-content: space-between;
  margin-top: 30px;
}

.btn-secondary {
  background-color: #f0f0f0;
  color: #333;
  border: 1px solid #ddd;
  padding: 10px 20px;
  border-radius: 4px;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 5px;
}

.btn-primary {
  background-color: #4bc0c0;
  color: white;
  border: none;
  padding: 10px 20px;
  border-radius: 4px;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 5px;
}

.btn-primary:disabled {
  background-color: #cccccc;
  cursor: not-allowed;
}

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
  animation: overlayFadeIn 0.3s ease;
}

.success-modal {
  background-color: white;
  border-radius: 12px;
  box-shadow: 0 4px 24px rgba(0, 0, 0, 0.2);
  padding: 30px;
  text-align: center;
  max-width: 500px;
  width: 90%;
  position: relative;
  animation: modalSlideIn 0.4s ease-out;
  transform-origin: center;
  opacity: 1;
  will-change: transform, opacity;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  position: relative;
}

.close-button {
  position: absolute;
  top: -20px;
  right: -20px;
  width: 36px;
  height: 36px;
  border-radius: 50%;
  background-color: #f1f1f1;
  border: none;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.2s ease;
  box-shadow: 0 2px 5px rgba(0,0,0,0.15);
  z-index: 2;
}

.close-button:hover {
  background-color: #e0e0e0;
  transform: scale(1.05);
}

.close-button:active {
  transform: scale(0.95);
}

.success-icon {
  font-size: 70px;
  color: #4caf50;
  margin: 0 auto 20px;
}

.success-modal h2 {
  font-size: 24px;
  margin-bottom: 15px;
  color: #333;
}

.success-modal p {
  font-size: 16px;
  color: #666;
  margin-bottom: 25px;
}

.modal-actions {
  display: flex;
  justify-content: center;
  flex-wrap: wrap;
  gap: 12px;
  margin-top: 10px;
}

.modal-actions button {
  padding: 10px 20px;
  border-radius: 6px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s ease;
  min-width: 140px;
  font-size: 14px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.modal-actions .btn-secondary {
  background-color: #f1f1f1;
  color: #333;
  border: 1px solid #ddd;
}

.modal-actions .btn-primary {
  background-color: #4caf50;
  color: white;
  border: 1px solid #4caf50;
}

.modal-actions .btn-outlined {
  background-color: white;
  color: #666;
  border: 1px solid #ddd;
}

.modal-actions .btn-secondary:hover {
  background-color: #e5e5e5;
  transform: translateY(-1px);
}

.modal-actions .btn-primary:hover {
  background-color: #3d9c40;
  transform: translateY(-1px);
}

.modal-actions .btn-outlined:hover {
  background-color: #f9f9f9;
  border-color: #ccc;
  transform: translateY(-1px);
}

.modal-actions button:active {
  transform: translateY(1px);
}

@keyframes overlayFadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

@keyframes modalSlideIn {
  0% { opacity: 0; transform: translateY(-40px) scale(0.95); }
  100% { opacity: 1; transform: translateY(0) scale(1); }
}

/* Styles pour l'aperçu de glisser-déposer */
.drag-preview {
  background-color: #4bc0c0;
  color: white;
  padding: 5px 10px;
  border-radius: 4px;
  position: fixed;
  z-index: 9999;
  pointer-events: none;
  display: flex;
  align-items: center;
  gap: 5px;
}

.error-modal {
  background-color: white;
  border-radius: 10px;
  box-shadow: 0 5px 20px rgba(0, 0, 0, 0.2);
  padding: 30px;
  width: 90%;
  max-width: 500px;
  text-align: center;
  animation: modal-appear 0.3s ease-out forwards;
}

.error-icon {
  font-size: 3rem;
  margin-bottom: 20px;
}

.error-icon i {
  color: #e74c3c;
}

.error-modal h2 {
  font-size: 1.8rem;
  margin-bottom: 15px;
  color: #e74c3c;
}

.error-modal p {
  color: #666;
  margin-bottom: 25px;
  font-size: 1.1rem;
  line-height: 1.5;
}

.modal-actions {
  display: flex;
  gap: 15px;
  justify-content: center;
}

.modal-actions .btn {
  padding: 12px 25px;
  border-radius: 5px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease;
  font-size: 1rem;
  border: none;
}

.modal-actions .btn-primary {
  background-color: #e74c3c;
  color: white;
}

.modal-actions .btn-secondary {
  background-color: #f1f1f1;
  color: #333;
  border: 1px solid #ddd;
}

.modal-actions .btn-secondary:hover {
  background-color: #e5e5e5;
}

@keyframes modal-appear {
  from {
    opacity: 0;
    transform: translateY(-30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* Styles pour la section de personnalisation des couleurs */
.color-customization-section {
  margin: 20px 0;
  padding: 15px;
  background-color: #fff;
  border-radius: 6px;
  border: 1px solid #e0e0e0;
}

.color-customization-section h4 {
  margin-top: 0;
  margin-bottom: 15px;
  font-size: 16px;
  color: #333;
}

.color-themes {
  margin-bottom: 20px;
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
  cursor: pointer;
  padding: 8px;
  border-radius: 4px;
  transition: background-color 0.2s;
}

.theme-option:hover {
  background-color: #f0f0f0;
}

.theme-preview {
  display: flex;
  margin-bottom: 5px;
}

.color-preview {
  width: 20px;
  height: 20px;
  border-radius: 3px;
  margin-right: 2px;
  border: 1px solid #ddd;
}

.theme-option span {
  font-size: 12px;
  color: #555;
}

.color-pickers {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  gap: 15px;
}

.color-picker {
  display: flex;
  flex-direction: column;
}

.color-picker label {
  font-size: 14px;
  margin-bottom: 5px;
  color: #555;
}

.color-input-wrapper {
  display: flex;
  align-items: center;
}

.color-input-wrapper input[type="color"] {
  width: 40px;
  height: 30px;
  border: 1px solid #ddd;
  border-radius: 4px;
  padding: 0;
  margin-right: 10px;
}

.color-input-wrapper span {
  font-size: 12px;
  color: #666;
  font-family: monospace;
}
</style>
