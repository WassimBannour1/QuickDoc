<template>
  <div class="fill-method-selector">
    <div class="selection-header">
      <h2>Méthode de remplissage</h2>
      <p>Choisissez comment vous souhaitez remplir votre {{ documentTypeLabel }}</p>
    </div>
    <div class="method-selection-container">
      <div 
        class="fill-method-card" 
        @click="selectFillMethod('manual')"
        :class="{ 'selected': selectedMethod === 'manual' }"
        style="--i: 0"
      >
        <div class="card-content">
          <div class="card-icon">
            <i class="fas fa-edit"></i>
          </div>
          <h3>Remplissage Manuel</h3>
          <p>Saisissez les informations manuellement</p>
        </div>
      </div>

      <div 
        class="fill-method-card" 
        @click="selectFillMethod('automatic')"
        :class="{ 'selected': selectedMethod === 'automatic' }"
        style="--i: 1"
      >
        <div class="card-content">
          <div class="card-icon">
            <i class="fas fa-magic"></i>
          </div>
          <h3>Remplissage Automatique</h3>
          <p>Utilisez l'OCR et l'IA pour extraire les données</p>
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
        @click="continueToNextStep"
        :disabled="!selectedMethod"
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
    required: true,
    validator: value => ['devis', 'facture'].includes(value)
  },
  templateId: {
    type: Number,
    required: true
  }
});

const emit = defineEmits(['back', 'continue']);

const selectedMethod = ref(null);

// Libellé du type de document (pour l'affichage)
const documentTypeLabel = computed(() => {
  return props.documentType === 'facture' ? 'Facture' : 'Devis';
});

const selectFillMethod = (method) => {
  selectedMethod.value = method;
};

const goBack = () => {
  emit('back');
};

const continueToNextStep = () => {
  if (selectedMethod.value) {
    emit('continue', selectedMethod.value);
  }
};
</script>

<style scoped>
.fill-method-selector {
  padding: 2rem;
  min-height: 80vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background-color: #f9fafc;
}

.selection-header {
  text-align: center;
  margin-bottom: 3rem;
  animation: fadeIn 0.5s ease forwards;
}

.selection-header h2 {
  color: #002446;
  font-size: 2.2rem;
  margin-bottom: 0.5rem;
  font-weight: 700;
}

.selection-header p {
  color: #666;
  font-size: 1.1rem;
  margin-bottom: 1rem;
}

.method-selection-container {
  display: flex;
  gap: 2rem;
  justify-content: center;
  margin-bottom: 3rem;
  width: 100%;
  max-width: 900px;
}

.fill-method-card {
  flex: 1;
  min-width: 300px;
  height: 250px;
  background: white;
  border-radius: 15px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  transition: all 0.3s ease;
  cursor: pointer;
  animation: fadeInUp 0.5s ease forwards;
  animation-delay: calc(var(--i) * 0.2s);
  border: 2px solid transparent;
}

.fill-method-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
}

.fill-method-card.selected {
  transform: scale(1.05);
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
  border: 3px solid #002446;
  background-color: #f0f7ff;
}

.card-content {
  padding: 2rem;
  text-align: center;
  height: 100%;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
}

.card-icon {
  font-size: 3rem;
  color: #002446;
  margin-bottom: 1.5rem;
  background-color: #e6f0ff;
  width: 80px;
  height: 80px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s ease;
}

.fill-method-card.selected .card-icon {
  background-color: #002446;
  color: white;
}

.card-content h3 {
  font-size: 1.5rem;
  color: #333;
  margin-bottom: 0.8rem;
  font-weight: 600;
}

.card-content p {
  color: #666;
  font-size: 1rem;
  line-height: 1.5;
}

.action-buttons {
  display: flex;
  justify-content: space-between;
  width: 100%;
  max-width: 900px;
  margin-top: 1rem;
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

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes fadeIn {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}

@media (max-width: 768px) {
  .method-selection-container {
    flex-direction: column;
    align-items: center;
  }
  
  .fill-method-card {
    width: 100%;
    max-width: 350px;
  }
  
  .action-buttons {
    flex-direction: column;
    gap: 1rem;
    align-items: center;
  }
  
  .back-button, .continue-button {
    width: 100%;
    justify-content: center;
  }
}
</style>