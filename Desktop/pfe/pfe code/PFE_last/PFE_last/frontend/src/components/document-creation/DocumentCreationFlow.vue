<template>
  <div class="document-creation-flow">
    <!-- Étape 1: Sélection du type de document -->
    <Step1SelectType 
      v-if="currentStep === 1" 
      @continue="goToStep2"
    />
    
    <!-- Étape 2: Liste des documents existants -->
    <Step2DocumentList 
      v-else-if="currentStep === 2" 
      :typeDocument="selectedDocumentType"
      @nextStep="goToStep3"
      @backToStep1="goToStep1"
      @goToPreview="goToPreview"
    />
    
    <!-- Étape 3: Sélection du type de template -->
    <Step3TemplateSelection 
      v-else-if="currentStep === 3" 
      :documentType="selectedDocumentType"
      @back="goBackToStep2"
      @continue="goToStep4"
    />
    
    <!-- Étape 4: Sélection du template selon le type choisi -->
    <Step4PredefinedTemplates 
      v-else-if="currentStep === 4 && selectedTemplateType === 'predefined'" 
      :documentType="selectedDocumentType"
      @back="goBackToStep3"
      @template-selected="goToStep5"
    />
    
    <Step4CustomTemplates 
      v-else-if="currentStep === 4 && selectedTemplateType === 'custom'" 
      :documentType="selectedDocumentType"
      @back="goBackToStep3"
      @template-selected="goToStep5"
    />
    
    <!-- Étape 5: Sélection de la méthode de remplissage -->
    <Step5FillMethod 
      v-else-if="currentStep === 5" 
      :documentType="selectedDocumentType"
      :templateId="selectedTemplate ? selectedTemplate.id : null"
      @back="goBackToStep4"
      @continue="goToStep6"
    />
    
    <!-- Étape 6: Remplissage manuel du document -->
    <Step5ManualFill 
      v-else-if="currentStep === 6 && selectedFillMethod === 'manual'" 
      :documentType="selectedDocumentType"
      :templateId="selectedTemplate ? selectedTemplate.id : null"
      @back="goBackToStep5"
      @continue="handleManualFillComplete"
      @save="saveManualFillData"
    />
    
    <!-- Étape 6: OCR & IA pour le remplissage automatique -->
    <OcrIaComponent 
      v-else-if="currentStep === 6 && selectedFillMethod === 'automatic' && !ocrDataReady" 
      @goToStep6OCR="handleOcrData" 
    />
    
    <!-- Étape 6: Vérification des données OCR -->
    <Step6OCR 
      v-else-if="currentStep === 6 && selectedFillMethod === 'automatic' && ocrDataReady" 
      :documentType="selectedDocumentType"
      :templateId="selectedTemplate ? selectedTemplate.id : null"
      :ocrData="ocrData"
      @back="goBackToOcr"
      @continue="handleOcrFillComplete"
    />
    
    <!-- Étape 7: Aperçu du document final -->
    <Step7DocumentPreview 
      v-else-if="currentStep === 7" 
      :documentType="selectedDocumentType"
      :documentData="manualFillData"
      :templateId="selectedTemplate ? selectedTemplate.id : null"
      @back="goBackToStep6"
      @goToStep1="goToStep1"
    />
  </div>
</template>

<script setup>
import { ref, computed } from 'vue';
import Step1SelectType from './Step1SelectType.vue';
import Step2DocumentList from './Step2DocumentList.vue';
import Step3TemplateSelection from './Step3TemplateSelection.vue';
import Step4PredefinedTemplates from './Step4PredefinedTemplates.vue';
import Step4CustomTemplates from './Step4CustomTemplates.vue';
import Step5FillMethod from './Step5FillMethod.vue';
import Step5ManualFill from './Step5ManualFill.vue';
import Step6OCR from './Step6OCR.vue';
import Step7DocumentPreview from './Step7DocumentPreview.vue';
import OcrIaComponent from '../ocr/OcrIaComponent.vue';
import manualFillService from '@/services/manualFillService';

// État pour suivre l'étape actuelle du flux
const currentStep = ref(1);

// État pour stocker le type de document sélectionné
const selectedDocumentType = ref(null);

// État pour stocker le type de template sélectionné
const selectedTemplateType = ref(null);

// État pour stocker le template sélectionné
const selectedTemplate = ref(null);

// Libellé du type de document (pour l'affichage)
const documentTypeLabel = computed(() => {
  return selectedDocumentType.value === 'facture' ? 'Facture' : 'Devis';
});

// Fonction pour passer à l'étape 2 avec le type de document sélectionné
const goToStep2 = (documentType) => {
  selectedDocumentType.value = documentType;
  currentStep.value = 2;
};

// Fonction pour passer à l'étape 3 (sélection du type de template)
const goToStep3 = (documentType) => {
  selectedDocumentType.value = documentType;
  currentStep.value = 3;
};

// Fonction pour revenir à l'étape 2
const goBackToStep2 = () => {
  currentStep.value = 2;
};

// Fonction pour passer à l'étape 4 (sélection du template selon le type choisi)
const goToStep4 = (templateType) => {
  selectedTemplateType.value = templateType;
  currentStep.value = 4;
};

// Fonction pour revenir à l'étape 3
const goBackToStep3 = () => {
  currentStep.value = 3;
};

// Fonction pour passer à l'étape 5 (création/édition de document avec le template sélectionné)
const goToStep5 = (template) => {
  selectedTemplate.value = template;
  currentStep.value = 5;
};

// Fonction pour revenir à l'étape 4
const goBackToStep4 = () => {
  currentStep.value = 4;
};

// État pour stocker la méthode de remplissage sélectionnée
const selectedFillMethod = ref(null);

// Fonction pour passer à l'étape 6 (remplissage du document)
const goToStep6 = (fillMethod) => {
  selectedFillMethod.value = fillMethod;
  currentStep.value = 6;
};

// Fonction pour revenir à l'étape 5
const goBackToStep5 = () => {
  currentStep.value = 5;
};

// État pour stocker les données du remplissage manuel
const manualFillData = ref(null);

// État pour stocker les données OCR
const ocrData = ref(null);
const ocrDataReady = ref(false);

// Fonction pour gérer la sauvegarde des données du remplissage manuel
const saveManualFillData = async (data) => {
  try {
    manualFillData.value = data;
    console.log('Données sauvegardées:', data);
    
    // Appeler le service pour sauvegarder les données
    const result = await manualFillService.saveManualFillData(
      data,
      selectedDocumentType.value,
      selectedTemplate.value ? selectedTemplate.value.id : null
    );
    
    // Mettre à jour manualFillData avec la réponse du backend qui contient l'ID du remplissage
    if (result && result.data) {
      // Fusionner les données existantes avec les données de la réponse
      manualFillData.value = {
        ...data,
        id: result.data.remplissage.id,
        remplissage: result.data.remplissage
      };
      console.log('Données mises à jour avec ID de remplissage:', manualFillData.value);
    }
    
    // Émettre un événement de succès que Step5ManualFill pourra intercepter
    const successMessage = `${selectedDocumentType.value === 'facture' ? 'Facture' : 'Devis'} enregistré avec succès!`;
    if (data.notificationCallback) {
      data.notificationCallback('success', 'Succès', successMessage);
    }
    
    return result;
  } catch (error) {
    console.error('Erreur lors de la sauvegarde des données:', error);
    // Émettre un événement d'erreur que Step5ManualFill pourra intercepter
    const errorMessage = `Erreur lors de la sauvegarde: ${error.message}`;
    if (data.notificationCallback) {
      data.notificationCallback('error', 'Erreur', errorMessage);
    }
  }
};

// Fonction pour gérer la fin du remplissage manuel et passer à l'étape suivante
const handleManualFillComplete = async (data) => {
  try {
    manualFillData.value = data;
    console.log('Données complètes du remplissage manuel:', data);
    
    // Sauvegarder les données avant de passer à l'étape suivante
    const result = await manualFillService.saveManualFillData(
      data,
      selectedDocumentType.value,
      selectedTemplate.value ? selectedTemplate.value.id : null
    );
    
    // Mettre à jour manualFillData avec la réponse du backend qui contient l'ID du remplissage
    if (result && result.data) {
      // Fusionner les données existantes avec les données de la réponse
      manualFillData.value = {
        ...data,
        id: result.data.remplissage.id,
        remplissage: result.data.remplissage
      };
      console.log('Données mises à jour avec ID de remplissage:', manualFillData.value);
    }
    
    // Passer à l'étape d'aperçu du document
    currentStep.value = 7;
  } catch (error) {
    console.error('Erreur lors de la sauvegarde des données:', error);
    // Utiliser le callback de notification si disponible
    if (data.notificationCallback) {
      data.notificationCallback('error', 'Erreur', `Erreur lors de la sauvegarde: ${error.message}`);
    }
  }
};

// Fonction pour revenir à l'étape 6 depuis l'étape 7
const goBackToStep6 = () => {
  currentStep.value = 6;
};

// Fonction pour gérer les données OCR reçues de OcrIaComponent
const handleOcrData = (data) => {
  ocrData.value = data;
  ocrDataReady.value = true;
  console.log('Données OCR reçues:', data);
};

// Fonction pour revenir à l'étape OCR depuis l'étape de vérification OCR
const goBackToOcr = () => {
  ocrDataReady.value = false;
};

// Fonction pour gérer la fin du remplissage OCR et passer à l'étape suivante
const handleOcrFillComplete = (data) => {
  // Mettre à jour les données locales sans sauvegarder dans la base de données
  manualFillData.value = data;
  console.log('Données complètes du remplissage OCR:', data);
  
  // Passer directement à l'étape d'aperçu du document
  currentStep.value = 7;
};

// Fonction pour aller directement à l'étape 7 (aperçu) depuis l'étape 2
const goToPreview = (documentData) => {
  // Mettre à jour les données du document pour l'aperçu
  manualFillData.value = documentData;
  console.log('Données du document pour aperçu:', documentData);
  
  // Passer directement à l'étape d'aperçu du document
  currentStep.value = 7;
};

// Fonction pour revenir à l'étape 1 (réinitialiser le flux)
const goToStep1 = () => {
  // Réinitialiser l'étape à 1
  currentStep.value = 1;
  // Réinitialiser les autres états si nécessaire
  selectedDocumentType.value = null;
  selectedTemplateType.value = null;
  selectedTemplate.value = null;
  selectedFillMethod.value = null;
  manualFillData.value = null;
};
</script>

<style scoped>
.document-creation-flow {
  width: 100%;
  min-height: 100vh;
  background-color: #f9fafc;
}

.placeholder-step {
  padding: 2rem;
  text-align: center;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  min-height: 60vh;
  background-color: #f9fafc;
  border-radius: 10px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
  margin: 2rem;
}

.placeholder-step h2 {
  color: #002446;
  font-size: 1.8rem;
  font-weight: 600;
  margin-bottom: 1rem;
}

.placeholder-step p {
  color: #666;
  font-size: 1.1rem;
  margin-bottom: 2rem;
}

.back-button {
  background: linear-gradient(135deg, #002446, #003a6c);
  color: white;
  border: none;
  border-radius: 25px;
  padding: 0.8rem 1.5rem;
  font-size: 1rem;
  font-weight: 500;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  transition: all 0.3s ease;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.back-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
}
</style>