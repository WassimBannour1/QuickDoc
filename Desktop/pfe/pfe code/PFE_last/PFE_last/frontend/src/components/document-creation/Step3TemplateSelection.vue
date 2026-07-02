<template>
  <div class="template-selection-container">
    <div class="template-selection-header">
      <h1>Sélection du Template</h1>
      <p>Choisissez le type de template que vous souhaitez utiliser pour votre {{ documentTypeLabel }}</p>
    </div>

    <div class="template-cards-container">
      <!-- Carte pour Templates Prédéfinis -->
      <div 
        class="template-card" 
        :class="{ 'selected': selectedTemplateType === 'predefined' }"
        @click="selectTemplateType('predefined')"
      >
        <div class="template-icon">
          <i class="fas fa-file-alt"></i>
        </div>
        <div class="template-info">
          <h2>Templates Prédéfinis</h2>
          <p>Utilisez un modèle prêt à l'emploi pour créer rapidement votre document</p>
        </div>
      </div>

      <!-- Carte pour Templates Personnalisés -->
      <div 
        class="template-card" 
        :class="{ 'selected': selectedTemplateType === 'custom' }"
        @click="selectTemplateType('custom')"
      >
        <div class="template-icon">
          <i class="fas fa-pencil-ruler"></i>
        </div>
        <div class="template-info">
          <h2>Templates Personnalisés</h2>
          <p>Utilisez vos propres modèles personnalisés pour créer votre document</p>
        </div>
      </div>
    </div>

    <div class="action-buttons">
      <button class="back-button" @click="goBack">
        <i class="fas fa-arrow-left"></i>
        Retour
      </button>
      <button 
        class="continue-button" 
        :disabled="!selectedTemplateType" 
        @click="continueToNextStep"
      >
        Continuer
        <i class="fas fa-arrow-right"></i>
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, defineProps, defineEmits } from 'vue';

const props = defineProps({
  documentType: {
    type: String,
    required: true
  }
});

const emit = defineEmits(['back', 'continue']);

// État pour stocker le type de template sélectionné
const selectedTemplateType = ref(null);

// Libellé du type de document (pour l'affichage)
const documentTypeLabel = computed(() => {
  return props.documentType === 'facture' ? 'Facture' : 'Devis';
});

// Fonction pour sélectionner un type de template
const selectTemplateType = (type) => {
  selectedTemplateType.value = type;
};

// Fonction pour revenir à l'étape précédente
const goBack = () => {
  emit('back');
};

// Fonction pour continuer vers l'étape suivante
const continueToNextStep = () => {
  if (selectedTemplateType.value) {
    emit('continue', selectedTemplateType.value);
  }
};
</script>

<style scoped>
.template-selection-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 2rem;
  background-color: #f9fafc;
  min-height: 80vh;
  display: flex;
  flex-direction: column;
}

.template-selection-header {
  text-align: center;
  margin-bottom: 3rem;
}

.template-selection-header h1 {
  color: #002446;
  font-size: 2.2rem;
  font-weight: 700;
  margin-bottom: 0.5rem;
}

.template-selection-header p {
  color: #666;
  font-size: 1.1rem;
}

.template-cards-container {
  display: flex;
  justify-content: center;
  gap: 2rem;
  margin-bottom: 3rem;
}

.template-card {
  background-color: white;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
  padding: 2rem;
  width: 350px;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  border: 2px solid transparent;
}

.template-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
}

.template-card.selected {
  border-color: #002446;
  background-color: #f0f7ff;
  transform: translateY(-5px);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
}

.template-icon {
  font-size: 3rem;
  color: #002446;
  margin-bottom: 1.5rem;
  background-color: #e6f0ff;
  width: 100px;
  height: 100px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s ease;
}

.template-card.selected .template-icon {
  background-color: #002446;
  color: white;
}

.template-info h2 {
  color: #002446;
  font-size: 1.5rem;
  font-weight: 600;
  margin-bottom: 0.8rem;
}

.template-info p {
  color: #666;
  font-size: 1rem;
  line-height: 1.5;
}

.action-buttons {
  display: flex;
  justify-content: space-between;
  margin-top: auto;
  padding-top: 2rem;
}

.back-button, .continue-button {
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
}

.back-button {
  background-color: #e0e0e0;
  color: #333;
}

.back-button:hover {
  background-color: #d0d0d0;
}

.continue-button {
  background: linear-gradient(135deg, #002446, #003a6c);
  color: white;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.continue-button:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
}

.continue-button:disabled {
  background: linear-gradient(135deg, #a0a0a0, #c0c0c0);
  cursor: not-allowed;
  opacity: 0.7;
}

@media (max-width: 768px) {
  .template-cards-container {
    flex-direction: column;
    align-items: center;
  }
  
  .template-card {
    width: 100%;
    max-width: 350px;
  }
}
</style>