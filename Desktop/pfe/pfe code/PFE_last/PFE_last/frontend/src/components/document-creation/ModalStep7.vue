<template>
  <div class="modal-overlay" v-if="visible" @click.self="closeModal">
    <div class="modal-container">
      <div class="modal-header">
        <h3>{{ title }}</h3>
        <button class="close-button" @click="closeModal">
          <i class="fas fa-times"></i>
        </button>
      </div>
      
      <div class="modal-content">
        <div v-if="isGenerating" class="generating-content">
          <div class="spinner"></div>
          <p>Génération et archivage du PDF en cours...</p>
        </div>
        <div v-else-if="isComplete" class="complete-content">
          <div class="success-icon">
            <i class="fas fa-check-circle"></i>
          </div>
          <p>PDF généré et archivé avec succès!</p>
          <p class="sub-message">Le document a été sauvegardé sur le serveur et téléchargé sur votre appareil.</p>
        </div>
        <div v-else-if="hasError" class="error-content">
          <div class="error-icon">
            <i class="fas fa-exclamation-circle"></i>
          </div>
          <p>Erreur lors de la génération ou de l'archivage du PDF. Veuillez réessayer.</p>
        </div>
      </div>
      
      <div class="modal-actions">
        <button class="action-button back-to-start" @click="goToStart">
          <i class="fas fa-home"></i> Créer un nouveau document
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, defineProps, defineEmits } from 'vue';

const props = defineProps({
  visible: {
    type: Boolean,
    default: false
  },
  title: {
    type: String,
    default: 'Archiver Document'
  },
  isGenerating: {
    type: Boolean,
    default: false
  },
  isComplete: {
    type: Boolean,
    default: false
  },
  hasError: {
    type: Boolean,
    default: false
  }
});

const emit = defineEmits(['close', 'goToStart']);

const closeModal = () => {
  emit('close');
};

const goToStart = () => {
  emit('goToStart');
};
</script>

<style scoped>
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
}

.modal-container {
  background-color: white;
  border-radius: 10px;
  width: 500px;
  max-width: 90%;
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
  display: flex;
  flex-direction: column;
  animation: modalFadeIn 0.3s ease forwards;
}

@keyframes modalFadeIn {
  from {
    opacity: 0;
    transform: translateY(-20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1.5rem;
  border-bottom: 1px solid #eee;
}

.modal-header h3 {
  color: #002446;
  font-size: 1.5rem;
  margin: 0;
}

.close-button {
  background: none;
  border: none;
  font-size: 1.2rem;
  color: #666;
  cursor: pointer;
  transition: color 0.3s ease;
}

.close-button:hover {
  color: #002446;
}

.modal-content {
  padding: 2rem;
  text-align: center;
}

.generating-content,
.complete-content,
.error-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 1rem;
}

.sub-message {
  font-size: 0.9rem;
  color: #666;
  margin-top: 0.5rem;
}

.spinner {
  border: 4px solid rgba(0, 0, 0, 0.1);
  border-radius: 50%;
  border-top: 4px solid #002446;
  width: 40px;
  height: 40px;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.success-icon i {
  font-size: 3rem;
  color: #28a745;
}

.error-icon i {
  font-size: 3rem;
  color: #dc3545;
}

.modal-content p {
  font-size: 1.1rem;
  color: #333;
  margin: 0.5rem 0;
}

.modal-actions {
  display: flex;
  justify-content: center;
  padding: 1.5rem;
  border-top: 1px solid #eee;
}

.action-button {
  padding: 1rem 1.5rem;
  border-radius: 5px;
  font-size: 1.1rem;
  font-weight: 600;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 0.8rem;
  transition: all 0.3s ease;
  border: none;
  min-width: 250px;
  justify-content: center;
}

.back-to-start {
  background: linear-gradient(135deg, #002446, #003a6c);
  color: white;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.back-to-start:hover {
  background: linear-gradient(135deg, #003a6c, #004d8f);
  transform: translateY(-2px);
  box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
}
</style>