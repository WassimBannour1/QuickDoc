<template>
  <div class="client-edit-container">
    <div class="page-header">
      <h1>Modifier le client</h1>
      <p>Modifiez les informations du client</p>
    </div>

    <div v-if="loading" class="loading-container">
      <div class="spinner"></div>
      <p>Chargement des données du client...</p>
    </div>

    <div v-else-if="error" class="error-container">
      <div class="error-icon">
        <i class="fas fa-exclamation-circle"></i>
      </div>
      <h2>Erreur lors du chargement</h2>
      <p>{{ error }}</p>
      <button class="btn btn-primary" @click="goBack">Retour à la liste</button>
    </div>

    <div v-else class="form-container">
      <form @submit.prevent="updateClient" class="client-form">
        <!-- Informations personnelles -->
        <div class="form-section">
          <h2>Informations personnelles</h2>

          <div class="form-row">
            <div class="form-group">
              <label for="name">Nom <span class="required">*</span></label>
              <input 
                type="text" 
                id="name" 
                v-model="client.name" 
                required
                @input="validateField('name')"
                :class="{ 'error': errors.name }"
              />
              <span v-if="errors.name" class="error-message">{{ errors.name }}</span>
            </div>

            <div class="form-group">
              <label for="lastName">Prénom <span class="required">*</span></label>
              <input 
                type="text" 
                id="lastName" 
                v-model="client.last_name" 
                required
                @input="validateField('last_name')"
                :class="{ 'error': errors.last_name }"
              />
              <span v-if="errors.last_name" class="error-message">{{ errors.last_name }}</span>
            </div>
          </div>

          <div class="form-row">
            <div class="form-group">
              <label for="cin">N° d'identification (CIN) <span class="required">*</span></label>
              <input 
                type="text" 
                id="cin" 
                v-model="client.cin" 
                required
                @input="validateField('cin')"
                :class="{ 'error': errors.cin }"
              />
              <span v-if="errors.cin" class="error-message">{{ errors.cin }}</span>
            </div>
          </div>
        </div>

        <!-- Coordonnées -->
        <div class="form-section">
          <h2>Coordonnées</h2>

          <div class="form-row">
            <div class="form-group">
              <label for="email">Email <span class="required">*</span></label>
              <input 
                type="email" 
                id="email" 
                v-model="client.email" 
                required
                @input="validateField('email')"
                :class="{ 'error': errors.email }"
              />
              <span v-if="errors.email" class="error-message">{{ errors.email }}</span>
            </div>

            <div class="form-group">
              <label for="phone">Téléphone <span class="required">*</span></label>
              <input 
                type="tel" 
                id="phone" 
                v-model="client.phone" 
                required
                @input="validateField('phone')"
                :class="{ 'error': errors.phone }"
              />
              <span v-if="errors.phone" class="error-message">{{ errors.phone }}</span>
            </div>
          </div>

          <div class="form-group full-width">
            <label for="address">Adresse <span class="required">*</span></label>
            <textarea 
              id="address" 
              v-model="client.address" 
              rows="3" 
              required
              @input="validateField('address')"
              :class="{ 'error': errors.address }"
            ></textarea>
            <span v-if="errors.address" class="error-message">{{ errors.address }}</span>
          </div>
        </div>

        <!-- Actions -->
        <div class="form-actions">
          <button type="button" class="btn btn-secondary" @click="goBack">Annuler</button>
          <button type="submit" class="btn btn-primary" :disabled="isSubmitting">
            <span v-if="isSubmitting">
              <i class="fas fa-spinner fa-spin"></i> Mise à jour en cours...
            </span>
            <span v-else>Mettre à jour</span>
          </button>
        </div>
      </form>
    </div>

    <!-- Success Modal -->
    <div v-if="showSuccessModal" class="modal-overlay">
      <div class="success-modal">
        <div class="success-icon">
          <i class="fas fa-check-circle"></i>
        </div>
        <h2>Mise à jour réussie</h2>
        <p>Les informations du client ont été mises à jour.</p>
        <div class="modal-actions">
          <button class="btn btn-primary" @click="goToClientList">Retour à la liste</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, reactive, onMounted } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import axios from 'axios';

export default {
  name: 'ClientEditForm',
  props: {
    id: {
      type: [String, Number],
      default: null
    }
  },
  emits: ['client-updated'],
  setup(props, { emit }) {
    const router = useRouter();
    const route = useRoute();
    // Utiliser l'ID passé en prop ou celui de la route
    const clientId = props.id || route.params.id;
    
    console.log('ID client reçu dans ClientEditForm:', clientId);

    const client = reactive({
      id: null,
      name: '',
      last_name: '',
      cin: '',
      email: '',
      phone: '',
      address: '',
      client_type: 'individual',
      status: 'active',
      notes: ''
    });

    const loading = ref(true);
    const error = ref(null);
    const errors = reactive({});
    const isSubmitting = ref(false);
    const showSuccessModal = ref(false);

    const fetchClient = async () => {
      loading.value = true;
      error.value = null;
      try {
        console.log('Récupération du client avec ID:', clientId);
        const token = localStorage.getItem('token');
        
        // Vérifier que nous avons un token et un ID client
        if (!token) {
          error.value = 'Vous devez être connecté pour modifier un client';
          loading.value = false;
          return;
        }
        
        if (!clientId) {
          error.value = 'Identifiant du client manquant';
          loading.value = false;
          return;
        }
        
        // Utiliser l'URL relative avec le proxy configuré
        const response = await axios.get(`/api/clients/${clientId}`, {
          headers: { 'Authorization': `Bearer ${token}` }
        });
        
        console.log('Réponse API:', response.data);
        
        // Vérifier si nous avons reçu des données valides
        if (!response.data || typeof response.data !== 'object') {
          error.value = 'Format de réponse invalide';
          loading.value = false;
          return;
        }
        
        // Extraire les données du client selon le format de la réponse
        let clientData = response.data;
        if (response.data.data) {
          clientData = response.data.data;
        }
        
        // Mettre à jour l'objet client avec les données reçues
        Object.assign(client, clientData);
        
        // Définir des valeurs par défaut pour les champs manquants
        if (!client.client_type) client.client_type = 'individual';
        if (!client.status) client.status = 'active';
        if (!client.notes) client.notes = '';
        
        console.log('Client chargé:', client);
      } catch (err) {
        console.error('Error fetching client:', err);
        if (err.response) {
          console.error('Status:', err.response.status);
          console.error('Data:', err.response.data);
        }
        error.value = 'Impossible de charger les données du client. Veuillez réessayer plus tard.';
      } finally {
        loading.value = false;
      }
    };

    const validateField = (field) => {
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      const phoneRegex = /^[0-9+\s()-]{8,15}$/;

      switch (field) {
        case 'name':
          errors.name = client.name?.trim() ? '' : 'Le nom est requis';
          break;
        case 'last_name':
          errors.last_name = client.last_name?.trim() ? '' : 'Le prénom est requis';
          break;
        case 'email':
          errors.email = emailRegex.test(client.email || '') ? '' : 'Veuillez entrer une adresse email valide';
          break;
        case 'phone':
          errors.phone = phoneRegex.test(client.phone || '') ? '' : 'Veuillez entrer un numéro de téléphone valide';
          break;
        case 'address':
          errors.address = client.address?.trim() ? '' : 'L\'adresse est requise';
          break;
        case 'cin':
          errors.cin = client.cin?.trim() ? '' : 'Le numéro d\'identification est requis';
          break;
        default:
          break;
      }
    };
    
    const validateForm = () => {
      ['name', 'last_name', 'email', 'phone', 'address', 'cin'].forEach(validateField);
      return !Object.values(errors).some(error => error !== '');
    };

    const updateClient = async () => {
      if (!validateForm()) return;
      isSubmitting.value = true;
      try {
        console.log('Mise à jour du client:', client);
        const token = localStorage.getItem('token');
        
        if (!token) {
          error.value = 'Vous devez être connecté pour modifier un client';
          isSubmitting.value = false;
          return;
        }
        
        // Utiliser l'URL relative avec le proxy configuré
        const response = await axios.put(`/api/clients/${clientId}`, client, {
          headers: { 'Authorization': `Bearer ${token}` }
        });
        
        console.log('Réponse de mise à jour:', response.data);
        showSuccessModal.value = true;
        // Émettre l'événement client-updated
        emit('client-updated', client);
      } catch (err) {
        console.error('Erreur lors de la mise à jour du client:', err);
        if (err.response) {
          console.error('Status:', err.response.status);
          console.error('Data:', err.response.data);
          
          // Gérer les erreurs de validation du serveur
          if (err.response.status === 422 && err.response.data.errors) {
            const serverErrors = err.response.data.errors;
            Object.keys(serverErrors).forEach(field => {
              errors[field] = serverErrors[field][0];
            });
            alert('Veuillez corriger les erreurs dans le formulaire.');
          } else {
            alert('Erreur lors de la mise à jour du client: ' + (err.response.data.message || 'Erreur inconnue'));
          }
        } else {
          alert('Erreur de connexion. Veuillez vérifier votre connexion internet et réessayer.');
        }
      } finally {
        isSubmitting.value = false;
      }
    };

    const goBack = () => router.go(-1);
    const goToClientList = () => router.push('/admin-entreprise/client-list');

    onMounted(fetchClient);

    return {
      client, loading, error, errors, isSubmitting, showSuccessModal,
      validateField, updateClient, goBack, goToClientList
    };
  }
};
</script>

<style scoped>
.client-edit-container {
  padding: 20px;
  max-width: 1200px;
  margin: 0 auto;
}

.page-header {
  margin-bottom: 30px;
}

.page-header h1 {
  font-size: 24px;
  color: #333;
  margin-bottom: 10px;
}

.page-header p {
  color: #666;
  font-size: 16px;
}

.loading-container, .error-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 50px 0;
  text-align: center;
}

.spinner {
  border: 4px solid rgba(0, 0, 0, 0.1);
  border-radius: 50%;
  border-top: 4px solid #4a90e2;
  width: 40px;
  height: 40px;
  animation: spin 1s linear infinite;
  margin-bottom: 20px;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.error-icon {
  font-size: 48px;
  color: #f44336;
  margin-bottom: 20px;
}

.error-container h2 {
  font-size: 24px;
  color: #333;
  margin-bottom: 10px;
}

.error-container p {
  color: #666;
  margin-bottom: 20px;
}

.form-container {
  background-color: #fff;
  border-radius: 10px;
  box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
  padding: 40px;
  border: 1px solid #f0f0f0;
}

.form-section {
  margin-bottom: 20px;
  padding-bottom: 15px;
  border-bottom: 1px solid #eee;
  position: relative;
}

.form-section h2 {
  font-size: 18px;
  color: #333;
  margin-bottom: 25px;
  font-weight: 600;
  padding-bottom: 12px;
  border-bottom: 1px solid #eee;
  position: relative;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.form-section h2::after {
  content: '';
  position: absolute;
  bottom: -1px;
  left: 0;
  width: 80px;
  height: 3px;
  background-color: #2196F3;
}

.form-row {
  display: flex;
  gap: 20px;
  margin-bottom: 15px;
}

.form-group {
  flex: 1;
  margin-bottom: 15px;
}

.full-width {
  width: 100%;
}

label {
  display: block;
  margin-bottom: 10px;
  font-weight: 600;
  color: #424242;
  font-size: 13px;
  position: relative;
  padding-left: 5px;
}

label::before {
  content: '';
  position: absolute;
  left: 0;
  top: 2px;
  height: 14px;
  width: 2px;
  background-color: #2196F3;
}

.required {
  color: #e53935;
}

input, select, textarea {
  width: 100%;
  padding: 6px 12px;
  border: 1px solid #e0e0e0;
  border-radius: 4px;
  font-size: 13px;
  color: #333;
  transition: all 0.3s ease;
  background-color: #f9f9f9;
  box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.05);
  height: 32px;
}

input:focus, select:focus, textarea:focus {
  border-color: #2196F3;
  outline: none;
  background-color: #fff;
  box-shadow: 0 0 0 3px rgba(33, 150, 243, 0.1);
}

input.error, select.error, textarea.error {
  border-color: #e53935;
}

.error-message {
  color: #e53935;
  font-size: 12px;
  margin-top: 5px;
  display: block;
}

.form-actions {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  margin-top: 10px;
}

.btn {
  padding: 6px 18px;
  border-radius: 3px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s ease;
  border: none;
  font-size: 12px;
  letter-spacing: 0.5px;
  text-transform: uppercase;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
  height: 32px;
}

.btn-primary {
  background-color: #2196F3;
  color: white;
}

.btn-primary:hover {
  background-color: #0b7dda;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
}

.btn-secondary {
  background-color: #f5f5f5;
  color: #333;
  border: 1px solid #ddd;
}

.btn-secondary:hover {
  background-color: #e0e0e0;
  border-color: #ccc;
}

.btn:disabled {
  opacity: 0.7;
  cursor: not-allowed;
}

/* Modal styles */
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

.success-modal {
  background-color: white;
  border-radius: 8px;
  padding: 30px;
  width: 90%;
  max-width: 500px;
  text-align: center;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
}

.success-icon {
  font-size: 60px;
  color: #4caf50;
  margin-bottom: 20px;
}

.success-modal h2 {
  font-size: 24px;
  margin-bottom: 15px;
  color: #333;
}

.success-modal p {
  color: #666;
  margin-bottom: 25px;
}

.modal-actions {
  display: flex;
  justify-content: center;
  gap: 15px;
}

@media (max-width: 768px) {
  .form-row {
    flex-direction: column;
    gap: 0;
  }
  
  .form-container {
    padding: 20px;
  }
  
  .modal-actions {
    flex-direction: column;
    gap: 10px;
  }
}
</style>
