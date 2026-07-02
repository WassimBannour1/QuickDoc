<template>
  <div class="document-type-selector">
    <div class="selection-header">
      <h2>Choisissez le type de document</h2>
      <p>Sélectionnez le type de document que vous souhaitez créer</p>
    </div>
    <div class="type-selection-container">
      <div 
        class="document-type-card" 
        @click="selectDocumentType('facture')"
        :class="{ 'selected': selectedType === 'facture' }"
        style="--i: 0"
      >
        <div class="card-content">
          <div class="card-icon">
            <i class="fas fa-file-invoice-dollar"></i>
          </div>
          <h3>Facture</h3>
          <p>Document de paiement officiel</p>
        </div>
      </div>

      <div 
        class="document-type-card" 
        @click="selectDocumentType('devis')"
        :class="{ 'selected': selectedType === 'devis' }"
        style="--i: 1"
      >
        <div class="card-content">
          <div class="card-icon">
            <i class="fas fa-file-contract"></i>
          </div>
          <h3>Devis</h3>
          <p>Offre commerciale prévisionnelle</p>
        </div>
      </div>
    </div>
    <div class="continue-section" v-if="selectedType">
      <button 
        class="continue-button" 
        @click="continueToNextStep"
        :disabled="!selectedType"
      >
        <i class="fas fa-arrow-right"></i>
        Continuer
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';

const router = useRouter();
const selectedType = ref(null);

const emit = defineEmits(['typeSelected']);

const selectDocumentType = (type) => {
  selectedType.value = type;
  emit('typeSelected', type);
};

const continueToNextStep = () => {
  if (selectedType.value) {
    // Emit an event to notify parent component about the continuation
    emit('continue', selectedType.value);
  }
};
</script>

<style scoped>
.document-type-selector {
  padding: 2rem;
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}

.selection-header {
  text-align: center;
  margin-bottom: 2rem;
  animation: fadeIn 0.5s ease forwards;
}

.selection-header h2 {
  color: #002446;
  font-size: 2rem;
  margin-bottom: 0.5rem;
  font-weight: 600;
}

.selection-header p {
  color: #666;
  font-size: 1.1rem;
  margin-bottom: 1rem;
}

.type-selection-container {
  display: flex;
  gap: 2rem;
  justify-content: center;
  margin-bottom: 2rem;
}

.continue-section {
  display: flex;
  justify-content: center;
  width: 100%;
}

.continue-button {
  background: linear-gradient(135deg, #002446, #003a6c);
  color: white;
  border: none;
  border-radius: 25px;
  padding: 1rem 2rem;
  font-size: 1.1rem;
  font-weight: 600;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  transition: all 0.3s ease;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.continue-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
  background: linear-gradient(135deg, #002446, #003a6c);
}

.continue-button:disabled {
  opacity: 0.7;
  cursor: not-allowed;
  background: #cccccc;
}

.document-type-card {
  flex: 1;
  min-width: 300px;
  height: 250px;
  background: white;
  border-radius: 15px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  transition: all 0.3s ease;
  cursor: pointer;
  animation: fadeInUp 0.5s ease forwards;
  animation-delay: calc(var(--i) * 0.2s);
}

.document-type-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 12px rgba(0, 0, 0, 0.15);
}

.document-type-card.selected {
  transform: scale(1.05);
  box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
  border: 3px solid #002446;
  background-color: #f0f8ff;
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
  margin-bottom: 1rem;
}

.card-content h3 {
  font-size: 1.5rem;
  color: #333;
  margin-bottom: 0.5rem;
}

.card-content p {
  color: #666;
  font-size: 1rem;
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
</style>
