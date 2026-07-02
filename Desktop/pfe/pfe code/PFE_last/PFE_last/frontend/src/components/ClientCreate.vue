<template>
    <div class="client-create-container">
      <div class="page-header">
        <h1>Créer un nouveau client</h1>
        <p>Remplissez le formulaire ci-dessous pour ajouter un nouveau client</p>
      </div>
      
      <!-- Error Alert -->
      <div v-if="generalError" class="error-alert">
        <i class="fas fa-exclamation-circle"></i>
        {{ generalError }}
      </div>
  
      <div class="form-container">
        <form @submit.prevent="createClient" class="client-form">
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
          
          <div class="form-actions">
            <button type="submit" class="btn btn-primary" :disabled="isSubmitting">
              <span v-if="isSubmitting">
                <i class="fas fa-spinner fa-spin"></i> Création en cours...
              </span>
              <span v-else>Créer le client</span>
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
          <h2>Client crée avec succès!</h2>
          <p>Le client a été ajouté à votre liste de clients.</p>
          <div class="modal-actions">
            <button class="btn btn-secondary" @click="closeModal">Fermer</button>
            <button class="btn btn-primary" @click="createAnother">Créer un autre client</button>
          </div>
        </div>
      </div>
    </div>
  </template>
  
  <script>
  import { ref, reactive } from 'vue';
  import { useRouter } from 'vue-router';
  import api from '@/services/api';
  
  export default {
    name: 'ClientCreate',
    setup() {
      const router = useRouter();
      
      // Client data
      const client = reactive({
        name: '',
        last_name: '',
        email: '',
        phone: '',
        address: '',
        cin: ''
      });
      
      // Form state
      const errors = reactive({});
      const isSubmitting = ref(false);
      const showSuccessModal = ref(false);
      const generalError = ref('');
      
      // Validation functions
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
            if (!errors.email && client.email) {
              checkUniqueness('email', client.email);
            }
            break;
          case 'phone':
            errors.phone = phoneRegex.test(client.phone || '') ? '' : 'Veuillez entrer un numéro de téléphone valide';
            break;
          case 'address':
            errors.address = client.address?.trim() ? '' : 'L\'adresse est requise';
            break;
          case 'cin':
            errors.cin = client.cin?.trim() ? '' : 'Le numéro d\'identification est requis';
            if (!errors.cin && client.cin) {
              checkUniqueness('cin', client.cin);
            }
            break;
          default:
            break;
        }
      };

      const checkUniqueness = async (field, value) => {
        if (!value) return;
        
        try {
          const response = await api.get(`/api/clients/check-unique?field=${field}&value=${encodeURIComponent(value)}`);
          if (response.data && !response.data.unique) {
            if (field === 'email') {
              errors.email = 'Cette adresse email est déjà utilisée';
            } else if (field === 'cin') {
              errors.cin = 'Ce numéro d\'identification est déjà utilisé';
            }
          }
        } catch (error) {
          console.error(`Erreur lors de la vérification de l'unicité du champ ${field}:`, error);
        }
      };
      
      const validateForm = () => {
        validateField('name');
        validateField('last_name');
        validateField('email');
        validateField('phone');
        validateField('address');
        validateField('cin');
        
        // Check if there are any errors
        return !Object.values(errors).some(error => error !== '');
      };
      
      // Form submission
      const createClient = async () => {
        console.log('Début de la création du client');
        
        // Clear previous errors
        Object.keys(errors).forEach(key => {
          errors[key] = '';
        });
        generalError.value = ''; // Clear general error
        
        // Validate form
        if (!validateForm()) {
          console.error('Échec de la validation du formulaire');
          return;
        }
        
        console.log('Validation du formulaire réussie');
        isSubmitting.value = true;
        
        try {
          // Get the user ID from localStorage or store
          const userId = localStorage.getItem('user_id');
          console.log('ID utilisateur récupéré:', userId);
          
          // Add user_id to client data
          const clientData = {
            ...client,
            user_id: userId
          };
          
          console.log('Données complètes du client à envoyer:', JSON.stringify(clientData));
          console.log('Vérification du CIN:', clientData.cin);
          
          // Send request to API with full URL
          console.log('Envoi de la requête à l\'API...');
          const response = await api.post('/api/clients', clientData);
          
          console.log('Réponse de l\'API:', response.status, response.statusText);
          console.log('Client créé avec succès:', response.data);
          
          // Show success modal
          showSuccessModal.value = true;
        } catch (error) {
          console.error('Erreur lors de la création du client:', error);
          console.error('Type d\'erreur:', error.name);
          console.error('Message d\'erreur:', error.message);
          
          // Log request details if available
          if (error.config) {
            console.error('URL de la requête:', error.config.url);
            console.error('Méthode de la requête:', error.config.method);
            console.error('En-têtes de la requête:', JSON.stringify(error.config.headers));
            console.error('Données envoyées:', error.config.data);
          }
          
          // Handle specific errors
          if (error.response) {
            console.error('Statut de la réponse:', error.response.status);
            console.error('Données de la réponse:', error.response.data);
            
            if (error.response.status === 409) {
              // Conflict - email or CIN already exists
              if (error.response.data.field === 'email') {
                errors.email = 'Cette adresse email est déjà utilisée';
                console.error('Conflit: Email déjà utilisé');
              } else if (error.response.data.field === 'cin') {
                errors.cin = 'Ce numéro d\'identification est déjà utilisé';
                console.error('Conflit: CIN déjà utilisé');
              }
            } else if (error.response.status === 404) {
              // Handle 404 error specifically for client creation
              if (error.response.data.field === 'email') {
                errors.email = error.response.data.message || 'Email non valide pour un client';
                console.error('Erreur 404:', error.response.data.message);
              }
              generalError.value = error.response.data.message || 'Une erreur est survenue lors de la création du client.';
            } else {
              // Other API errors
              console.error('Erreur API non gérée:', error.response.status, error.response.data);
              generalError.value = 'Une erreur est survenue lors de la création du client. Veuillez réessayer.';
            }
          } else if (error.request) {
            // The request was made but no response was received
            console.error('Aucune réponse reçue du serveur');
            console.error('Détails de la requête:', error.request);
            generalError.value = 'Aucune réponse du serveur. Veuillez vérifier votre connexion internet et réessayer.';
          } else {
            // Network or other errors
            console.error('Erreur de configuration de la requête');
            generalError.value = 'Une erreur de connexion est survenue. Veuillez vérifier votre connexion internet et réessayer.';
          }
        } finally {
          console.log('Fin du processus de création du client');
          isSubmitting.value = false;
        }
      };
      
      // Navigation functions
      const goBack = () => {
        router.go(-1);
      };
      
      const goToClientList = () => {
        router.push('/admin-entreprise/client-list');
      };
      
      const createAnother = () => {
        // Reset form
        Object.keys(client).forEach(key => {
          if (key === 'client_type') {
            client[key] = 'individual';
          } else if (key === 'status') {
            client[key] = 'active';
          } else {
            client[key] = '';
          }
        });
        
        // Clear errors
        Object.keys(errors).forEach(key => {
          errors[key] = '';
        });
        
        // Hide modal
        showSuccessModal.value = false;
      };
      
      const closeModal = () => {
        // Hide the modal without navigating away
        showSuccessModal.value = false;
        
        // Reset all form fields
        Object.keys(client).forEach(key => {
          client[key] = '';
        });
        
        // Clear any errors
        Object.keys(errors).forEach(key => {
          errors[key] = '';
        });
      };
      
      return {
        client,
        errors,
        isSubmitting,
        showSuccessModal,
        generalError,
        validateField,
        createClient,
        goBack,
        goToClientList,
        createAnother,
        closeModal
      };
    }
  }
  </script>
  
  <style scoped>
  .client-create-container {
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