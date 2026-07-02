<template>
  <div class="document-type-selector">
    <h2 class="section-title">Sélection du Type de Document</h2>
    <p class="section-description">Veuillez choisir le type de document que vous souhaitez créer :</p>
    
    <div class="document-type-options">
      <div 
        class="document-type-card" 
        :class="{ 'selected': selectedType === 'devis' }"
        @click="selectType('devis')"
      >
        <div class="icon-container">
          <i class="fas fa-file-invoice"></i>
        </div>
        <h3>Devis</h3>
        <p>Créer un modèle pour vos devis clients</p>
      </div>
      
      <div 
        class="document-type-card" 
        :class="{ 'selected': selectedType === 'facture' }"
        @click="selectType('facture')"
      >
        <div class="icon-container">
          <i class="fas fa-file-invoice-dollar"></i>
        </div>
        <h3>Facture</h3>
        <p>Créer un modèle pour vos factures clients</p>
      </div>
    </div>
    
    <div class="action-buttons">
      <button 
        class="btn-primary" 
        :disabled="!selectedType" 
        @click="confirmSelection"
      >
        Continuer
      </button>
    </div>
  </div>
</template>

<script>
export default {
  name: 'DocumentTypeSelector',
  data() {
    return {
      selectedType: null
    };
  },
  methods: {
    selectType(type) {
      this.selectedType = type;
    },
    confirmSelection() {
      if (this.selectedType) {
        this.$emit('type-selected', this.selectedType);
      }
    }
  }
};
</script>

<style scoped>
.document-type-selector {
  max-width: 800px;
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

.document-type-options {
  display: flex;
  justify-content: center;
  gap: 30px;
  margin-bottom: 30px;
}

.document-type-card {
  width: 250px;
  padding: 25px;
  border-radius: 10px;
  background-color: #fff;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
  text-align: center;
  cursor: pointer;
  transition: all 0.3s ease;
  border: 2px solid transparent;
}

.document-type-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
}

.document-type-card.selected {
  border-color: #4bc0c0;
  background-color: #f0ffff;
}

.icon-container {
  margin-bottom: 15px;
}

.icon-container i {
  font-size: 3rem;
  color: #4bc0c0;
}

.document-type-card h3 {
  font-size: 1.5rem;
  margin-bottom: 10px;
  color: #333;
}

.document-type-card p {
  color: #666;
  font-size: 0.9rem;
}

.action-buttons {
  display: flex;
  justify-content: center;
}

.btn-primary {
  background-color: #4bc0c0;
  color: white;
  border: none;
  padding: 10px 25px;
  border-radius: 5px;
  font-size: 1rem;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.btn-primary:hover {
  background-color: #3da3a3;
}

.btn-primary:disabled {
  background-color: #cccccc;
  cursor: not-allowed;
}
</style>
