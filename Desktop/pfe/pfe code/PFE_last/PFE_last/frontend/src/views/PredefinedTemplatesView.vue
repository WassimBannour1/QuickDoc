<template>
  <div class="predefined-templates-view">
    <div v-if="loading" class="loading-container">
      <div class="spinner"></div>
      <p>Chargement des modèles prédéfinis...</p>
    </div>
    <div v-else-if="error" class="error-container">
      <div class="error-icon"><i class="fas fa-exclamation-circle"></i></div>
      <h3>Une erreur est survenue</h3>
      <p>{{ errorMessage }}</p>
      <button class="btn-primary" @click="retry">Réessayer</button>
      <button class="btn-secondary" @click="goBack">Retour</button>
    </div>
    <PredefinedTemplates 
      v-else
      documentType="facture" 
      @template-selected="handleTemplateSelected"
      @go-back="goBack"
    />
  </div>
</template>

<script>
import PredefinedTemplates from '@/components/templates/PredefinedTemplates.vue';
import { getPredefinedTemplates } from '@/services/templateService';

export default {
  name: 'PredefinedTemplatesView',
  components: {
    PredefinedTemplates
  },
  data() {
    return {
      loading: true,
      error: false,
      errorMessage: ''
    };
  },
  created() {
    // Utiliser un timeout pour éviter le blocage infini
    this.checkTemplateService()
      .then(() => {
        this.loading = false;
      })
      .catch(error => {
        console.error('Error checking template service:', error);
        this.error = true;
        this.errorMessage = 'Impossible de charger les modèles prédéfinis. Veuillez réessayer plus tard.';
        this.loading = false;
      });
    
    // Ajouter un timeout de sécurité pour éviter le chargement infini
    setTimeout(() => {
      if (this.loading) {
        this.loading = false;
        this.error = true;
        this.errorMessage = 'Le chargement prend plus de temps que prévu. Veuillez réessayer.';
      }
    }, 10000); // 10 secondes maximum de chargement
  },
  methods: {
    async checkTemplateService() {
      try {
        console.log('Checking template service availability...');
        const response = await getPredefinedTemplates();
        console.log('Template service response:', response);
        
        // La fonction getPredefinedTemplates retourne maintenant toujours un objet avec success
        if (!response.success) {
          console.error('API response indicates failure:', response.message);
          throw new Error(response.message || 'API response indicates failure');
        }
        
        // Vérifier si des templates ont été retournés
        if (!response.data || response.data.length === 0) {
          console.log('No templates found, but API is working');
        } else {
          console.log(`Found ${response.data.length} templates`);
        }
        
        return true;
      } catch (error) {
        console.error('Template service check failed:', error);
        throw error;
      }
    },
    async retry() {
      this.loading = true;
      this.error = false;
      this.errorMessage = '';
      
      try {
        await this.checkTemplateService();
        this.loading = false;
      } catch (error) {
        this.error = true;
        this.errorMessage = 'Impossible de charger les modèles prédéfinis. Veuillez réessayer plus tard.';
        this.loading = false;
      }
    },
    handleTemplateSelected(template) {
      console.log('Template selected:', template);
      // Vous pouvez ajouter ici la logique pour gérer la sélection du template
    },
    goBack() {
      this.$router.push('/admin-entreprise');
    }
  }
};
</script>

<style scoped>
.predefined-templates-view {
  min-height: 100vh;
  background-color: #f5f5f5;
  display: flex;
  justify-content: center;
  align-items: center;
}

.loading-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 2rem;
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  width: 100%;
  max-width: 500px;
}

.spinner {
  width: 50px;
  height: 50px;
  border: 5px solid #f3f3f3;
  border-top: 5px solid #4bc0c0;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin-bottom: 1rem;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.error-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 2rem;
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  width: 100%;
  max-width: 500px;
  text-align: center;
}

.error-icon {
  font-size: 3rem;
  color: #ff6b6b;
  margin-bottom: 1rem;
}

.error-container h3 {
  margin-bottom: 0.5rem;
  color: #333;
}

.error-container p {
  margin-bottom: 1.5rem;
  color: #666;
}

.btn-primary {
  background-color: #4bc0c0;
  color: white;
  border: none;
  padding: 10px 20px;
  border-radius: 5px;
  cursor: pointer;
  font-size: 1rem;
  margin-right: 10px;
}

.btn-secondary {
  background-color: #f5f5f5;
  color: #333;
  border: 1px solid #ddd;
  padding: 10px 20px;
  border-radius: 5px;
  cursor: pointer;
  font-size: 1rem;
}

.btn-primary:hover {
  background-color: #3da3a3;
}

.btn-secondary:hover {
  background-color: #e9e9e9;
}
</style>
