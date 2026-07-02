<template>
  <div class="container">
    <div class="box">
      <!-- Left Section -->
      <div class="left-section">
        <div class="logo-container">
          <img src="../assets/logo.jpg" alt="Logo" class="logo" />
          <h1 class="site-name">QuikDoc</h1>
        </div>
        <p class="description">
          Gérez votre entreprise en un seul endroit!<br />
          Prenez le contrôle de votre facturation et de vos flux financiers avec une simplicité sans précédent.
        </p>
      </div>

      <!-- Right Section -->
      <div class="right-section">
        <h2 class="title animate-fade-in">{{ showVerification ? 'Vérification Email' : 'Créer un compte' }}</h2>
        <p class="info-text animate-fade-in">
          {{ showVerification ? 'Veuillez entrer le code de vérification envoyé à votre email.' : 'Remplissez les informations pour créer votre compte.' }}
        </p>

        <!-- Registration Form -->
        <div v-if="!showVerification">
          <div class="input-container animate-slide-up" v-for="(field, index) in formFields.filter(f => !f.condition || f.condition())" :key="index">
            <label class="label">{{ field.label }}</label>
            <div class="email-input" :class="{ 'input-focus': focusedField === field.name }">
              <input
                v-if="field.type !== 'select'"
                :type="field.type === 'password' ? (showPassword ? 'text' : 'password') : field.type"
                :placeholder="field.placeholder"
                v-model="formData[field.name]"
                class="input"
                @focus="focusedField = field.name"
                @blur="focusedField = null"
                @input="clearMessages"
              />
              <select
                v-else
                v-model="formData[field.name]"
                class="input"
                @focus="focusedField = field.name"
                @blur="focusedField = null"
              >
                <option v-for="option in field.options" :key="option.value" :value="option.value">
                  {{ option.label }}
                </option>
              </select>
              <span class="input-icon" @click="field.name === 'password' && togglePassword()" style="cursor: pointer">
                <svg v-if="field.name === 'password' && !showPassword" xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path>
                  <line x1="1" y1="1" x2="23" y2="23"></line>
                </svg>
                <svg v-else-if="field.name === 'password' && showPassword" xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                  <circle cx="12" cy="12" r="3"></circle>
                </svg>
                <span v-else v-html="field.icon"></span>
              </span>
            </div>
          </div>

          <button
            class="submit-btn animate-slide-up"
            @click="handleSignup"
            :disabled="isLoading"
            :class="{ 'loading': isLoading }"
          >
            <span class="btn-text">{{ isLoading ? 'Inscription en cours...' : "S'inscrire" }}</span>
            <span v-if="isLoading" class="loading-spinner"></span>
          </button>
        </div>

        <!-- Verification Form -->
        <div v-else class="animate-fade-in">
          <div class="input-container animate-slide-up">
            <label class="label">Code de vérification</label>
            <div class="email-input" :class="{ 'input-focus': focusedField === 'verificationCode' }">
              <input
                v-model="verificationCode"
                type="text"
                placeholder="Enter verification code"
                maxlength="6"
                class="input"
                @focus="focusedField = 'verificationCode'"
                @blur="focusedField = null"
                @input="clearMessages"
              />
              <span class="input-icon">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                  <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                </svg>
              </span>
            </div>
          </div>

          <button
            class="submit-btn animate-slide-up"
            @click="handleVerification"
            :disabled="isLoading"
            :class="{ 'loading': isLoading }"
          >
            <span class="btn-text">{{ isLoading ? 'Vérification...' : 'Vérifier' }}</span>
            <span v-if="isLoading" class="loading-spinner"></span>
          </button>
        </div>

        <!-- Messages -->
        <p v-if="errorMessage" class="error-message animate-shake">{{ errorMessage }}</p>
        <p v-if="successMessage" class="success-message animate-bounce">{{ successMessage }}</p>
        <p v-if="backendErrorMessage" class="backend-error-message animate-shake">{{ backendErrorMessage }}</p>
        <p v-if="pendingAdminApproval" class="info-message animate-fade-in">
          Votre demande de compte administrateur est en attente d'approbation. Vous serez notifié par email une fois approuvé.
        </p>

        <div v-if="!showVerification" class="signin-link animate-fade-in">
          Vous avez déjà un compte? 
          <router-link to="/signin" class="link">Se connecter</router-link>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, computed } from 'vue';
import axios from 'axios';
import { useRouter } from 'vue-router';
import { useMainStore } from '@/stores';

const store = useMainStore();
const router = useRouter();
const focusedField = ref(null);
const isLoading = ref(false);
const showVerification = ref(false);
const verificationCode = ref('');
const errorMessage = ref('');
const successMessage = ref('');
const backendErrorMessage = ref('');
const showPassword = ref(false);
const pendingAdminApproval = ref(false);

const formData = reactive({
  first_name: '',
  last_name: '',
  email: '',
  password: '',
  role: 'client',
  raison_sociale: '',
  siret: ''
});

const passwordIcon = computed(() => showPassword.value ? 
  '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>' :
  '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path><line x1="1" y1="1" x2="23" y2="23"></line></svg>'
);

const formFields = [
  {
    name: 'first_name',
    label: 'Prénom',
    type: 'text',
    placeholder: 'Entrez votre prénom',
    icon: '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>'
  },
  {
    name: 'last_name',
    label: 'Nom',
    type: 'text',
    placeholder: 'Entrez votre nom',
    icon: '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>'
  },
  {
    name: 'email',
    label: 'Email',
    type: 'email',
    placeholder: 'Entrez votre email',
    icon: '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path><polyline points="22,6 12,13 2,6"></polyline></svg>'
  },
  {
    name: 'password',
    label: 'Mot de passe',
    type: 'password',
    placeholder: 'Entrez votre mot de passe',
    icon: passwordIcon
  },
  {
    name: 'role',
    label: 'Rôle',
    type: 'select',
    options: [
      { value: 'client', label: 'Client' },
      { value: 'enterprise_admin', label: 'Admin entreprise' }
    ],
    icon: '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>'
  },
  {
    name: 'raison_sociale',
    label: 'Raison sociale',
    type: 'text',
    placeholder: 'Entrez la raison sociale de votre entreprise',
    icon: '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path><polyline points="9 22 9 12 15 12 15 22"></polyline></svg>',
    condition: () => formData.role === 'enterprise_admin'
  },
  {
    name: 'siret',
    label: 'SIRET (14 chiffres)',
    type: 'text',
    placeholder: 'Entrez le numéro SIRET de votre entreprise',
    icon: '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 12h-4l-3 9L9 3l-3 9H2"></path></svg>',
    condition: () => formData.role === 'enterprise_admin'
  }
];

const clearMessages = () => {
  errorMessage.value = '';
  backendErrorMessage.value = '';
  successMessage.value = '';
};

const validateForm = () => {
  if (!formData.first_name || !formData.last_name || !formData.email || !formData.password) {
    errorMessage.value = 'Veuillez remplir tous les champs.';
    return false;
  }

  const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
  if (!emailRegex.test(formData.email)) {
    errorMessage.value = 'Adresse e-mail invalide.';
    return false;
  }

  if (formData.password.length < 6) {
    errorMessage.value = 'Le mot de passe doit contenir au moins 6 caractères.';
    return false;
  }

  if (formData.role === 'enterprise_admin') {
    if (!formData.raison_sociale) {
      errorMessage.value = 'Veuillez entrer la raison sociale de votre entreprise.';
      return false;
    }

    if (!formData.siret || formData.siret.length !== 14 || !/^\d+$/.test(formData.siret)) {
      errorMessage.value = 'Le numéro SIRET doit contenir exactement 14 chiffres.';
      return false;
    }
  }

  return true;
};

const handleSignup = async () => {
  clearMessages();
  
  if (!validateForm()) return;

  if (formData.role === 'admin') {
    isLoading.value = true;
    try {
      const response = await axios.post(`${import.meta.env.VITE_API_URL}/request-admin`, {
        ...formData,
        status: 'pending',
        requestDate: new Date().toISOString()
      });
      if (response.data.success) {
        successMessage.value = 'Votre demande de compte administrateur a été envoyée. Veuillez attendre l\'approbation.';
        pendingAdminApproval.value = true;
      } else {
        throw new Error(response.data.message || 'Erreur lors de la demande admin.');
      }
    } catch (error) {
      console.error('Admin request error:', error);
      if (error.code === 'ECONNABORTED') {
        backendErrorMessage.value = 'Le serveur ne répond pas. Veuillez réessayer plus tard.';
      } else if (error.response) {
        backendErrorMessage.value = error.response.data.message || 'Erreur lors de la demande admin.';
      } else if (error.request) {
        backendErrorMessage.value = 'Impossible de joindre le serveur. Vérifiez votre connexion internet.';
      } else {
        backendErrorMessage.value = error.message || 'Une erreur inattendue est survenue.';
      }
    } finally {
      isLoading.value = false;
    }
    return;
  }

  isLoading.value = true;
  try {
    const apiUrl = `${import.meta.env.VITE_API_URL}`;
    console.log('API URL:', apiUrl);

    const signupData = {
      first_name: formData.first_name,
      last_name: formData.last_name,
      email: formData.email,
      password: formData.password,
      role: formData.role
    };

    if (formData.role === 'enterprise_admin') {
      signupData.raison_sociale = formData.raison_sociale;
      signupData.siret = formData.siret;
    }

    const response = await axios.post(`${apiUrl}/signup`, signupData);
    
    // Afficher un message différent selon le type de compte
    if (response.data.isExistingClient) {
      successMessage.value = 'Compte créé avec succès! Votre profil client existant a été lié à votre nouveau compte. Veuillez vérifier votre email pour activer votre compte.';
    } else {
      successMessage.value = response.data.message;
    }
    
    showVerification.value = true;
    store.setEmail(formData.email);
  } catch (error) {
    console.error('Signup error:', error.response?.data);
    if (error.response?.data?.error === 'Email already registered' || error.response?.data?.message === 'Cet email est déjà utilisé') {
      backendErrorMessage.value = 'Cet email est déjà utilisé. Veuillez utiliser un autre email ou vous connecter.';
    } else if (error.response?.status === 400 && error.response?.data?.error) {
      const errorMsg = (error.response.data.error || '').toLowerCase();
      if (errorMsg.includes('email') && (errorMsg.includes('already') || errorMsg.includes('exist') || errorMsg.includes('déjà'))) {
        backendErrorMessage.value = 'Cet email est déjà utilisé. Veuillez utiliser un autre email ou vous connecter.';
      } else {
        // Afficher le message d'erreur exact renvoyé par le backend au lieu du message générique
        backendErrorMessage.value = error.response.data.error || error.response.data.message || 'Une erreur est survenue.';
      }
    } else {
      // Afficher le message d'erreur exact renvoyé par le backend au lieu du message générique
      backendErrorMessage.value = error.response?.data?.error || error.response?.data?.message || 'Une erreur est survenue.';
    }
  } finally {
    isLoading.value = false;
  }
};

// Remove the duplicate verifyEmail function and update handleVerification
const handleVerification = async () => {
  if (!verificationCode.value) {
    errorMessage.value = 'Veuillez entrer le code de vérification.';
    return;
  }

  isLoading.value = true;
  clearMessages();

  console.log("Email utilisé pour la vérification:", formData.email);
  console.log("Code entré par l'utilisateur:", verificationCode.value.trim());

  try {
    const response = await axios.post(`${import.meta.env.VITE_API_URL}/verify-email`, {
      email: formData.email,
      code: verificationCode.value.trim()
    });

    console.log('Server response:', response.data);

    if (response.data.success) {
      successMessage.value = 'Email vérifié avec succès!';
      localStorage.setItem('userEmail', formData.email);
      setTimeout(() => {
        router.push('/signin');
      }, 2000);
    } else {
      backendErrorMessage.value = response.data.message || 'La vérification a échoué.';
    }
  } catch (error) {
    console.error('Full error details:', {
      error: error,
      response: error.response,
      data: error.response?.data,
      status: error.response?.status
    });
    
    if (error.response?.status === 400) {
      backendErrorMessage.value = 'Code de vérification invalide.';
    } else if (error.response?.status === 404) {
      backendErrorMessage.value = 'Email non trouvé.';
    } else if (error.response?.status === 408) {
      backendErrorMessage.value = 'Le code de vérification a expiré.';
    } else {
      backendErrorMessage.value = error.response?.data?.message || 'Erreur de vérification, veuillez réessayer.';
    }
  } finally {
    isLoading.value = false;
  }
};

const togglePassword = () => {
  showPassword.value = !showPassword.value;
};
</script>

<style scoped>
.container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background: url('@/assets/outside.jpg') no-repeat center center/cover;
  background-color: #dbd9d9;
  transition: background-color 0.3s ease;
  position: relative;
  padding: 20px 0;
}

.container::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(to bottom, rgba(255, 255, 255, 0.8), rgba(255, 255, 255, 0.6));
  z-index: 0;
}

.box {
  display: flex;
  width: 800px;
  height: auto;
  min-height: 600px;
  max-height: 90vh;
  background: white;
  border-radius: 12px;
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.664);
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  overflow: hidden;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
  z-index: 1;
}

.box:hover {
  transform: translate(-50%, -51%);
  box-shadow: 0 12px 28px rgba(0, 0, 0, 0.8);
}

.left-section {
  flex: 55%;
  background: url('@/assets/b.jpg') no-repeat center center/cover;
  color: white;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 30px;
  position: relative;
  overflow: hidden;
}

.left-section::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.3);
  transition: background 0.3s ease;
}

.left-section:hover::before {
  background: rgba(0, 0, 0, 0.2);
}

.logo-container {
  display: flex;
  align-items: center;
  gap: 10px;
  position: relative;
  z-index: 1;
}

.logo {
  width: 50px;
  transition: transform 0.3s ease;
}

.logo:hover {
  transform: scale(1.1);
}

.site-name {
  font-size: 24px;
  font-weight: bold;
  text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
}

.description {
  font-size: 16px;
  text-align: center;
  margin-top: 10px;
  position: relative;
  z-index: 1;
  text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.3);
}

.signin-link {
  text-align: center;
  margin-top: 20px;
  color: #666;
  font-size: 14px;
}

.link {
  color: #002446;
  text-decoration: none;
  font-weight: 500;
  transition: color 0.3s ease;
}

.link:hover {
  color: #003666;
  text-decoration: underline;
}

.right-section {
  flex: 45%;
  padding: 30px;
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
  background: #ffffff;
  position: relative;
  overflow-y: auto;
  max-height: 90vh;
  scrollbar-width: thin;
  scrollbar-color: transparent transparent;
}

.right-section::-webkit-scrollbar {
  width: 6px;
}

.right-section::-webkit-scrollbar-track {
  background: transparent;
}

.right-section::-webkit-scrollbar-thumb {
  background-color: transparent;
  border-radius: 20px;
  border: 2px solid transparent;
}

.right-section:hover::-webkit-scrollbar-thumb {
  background-color: rgba(0, 36, 70, 0.2);
}

.title {
  color: #002446;
  font-size: 24px;
  margin-bottom: 10px;
}

.info-text {
  color: #666;
  margin-bottom: 30px;
  font-size: 14px;
}

.input-container {
  margin-bottom: 12px;
}

.label {
  display: block;
  margin-bottom: 8px;
  color: #002446;
  font-weight: 500;
}

.email-input {
  display: flex;
  align-items: center;
  border: 2px solid #e1e1e1;
  border-radius: 8px;
  padding: 10px;
  transition: all 0.3s ease;
}

.email-input.input-focus {
  border-color: #002446;
  box-shadow: 0 0 0 2px rgba(0, 36, 70, 0.1);
}

.input {
  flex: 1;
  border: none;
  outline: none;
  font-size: 15px;
  color: #333;
  background: transparent;
}

.input-icon {
  color: #999;
  margin-left: 10px;
}

.submit-btn {
  width: 100%;
  padding: 12px;
  background: #002446;
  color: white;
  border: none;
  border-radius: 8px;
  font-size: 16px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s ease;
  margin-top: 5px;
}

.submit-btn:hover:not(:disabled) {
  background: #001A33;
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(0, 36, 70, 0.2);
}

.submit-btn:disabled {
  opacity: 0.7;
  cursor: not-allowed;
}

.error-message, .backend-error-message {
  color: #dc3545;
  font-size: 14px;
  margin-top: 12px;
  padding: 8px;
  background: rgba(220, 53, 69, 0.1);
  border-radius: 4px;
  text-align: center;
}

.success-message {
  color: #28a745;
  font-size: 14px;
  margin-top: 12px;
  padding: 8px;
  background: rgba(40, 167, 69, 0.1);
  border-radius: 4px;
  text-align: center;
}

.loading-spinner {
  display: inline-block;
  width: 20px;
  height: 20px;
  border: 2px solid rgba(255, 255, 255, 0.3);
  border-radius: 50%;
  border-top-color: white;
  animation: spin 0.8s linear infinite;
  margin-left: 10px;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

/* Animations */
@keyframes shake {
  0%, 100% { transform: translateX(0); }
  25% { transform: translateX(-5px); }
  75% { transform: translateX(5px); }
}

@keyframes bounce {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-5px); }
}

.animate-fade-in {
  animation: fadeIn 0.5s ease-out;
}

.animate-slide-up {
  animation: slideUp 0.5s ease-out;
}

.animate-shake {
  animation: shake 0.5s ease-in-out;
}

.animate-bounce {
  animation: bounce 0.5s ease-in-out;
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

@keyframes slideUp {
  from { transform: translateY(20px); opacity: 0; }
  to { transform: translateY(0); opacity: 1; }
}

/* Responsive Design */
@media (max-width: 900px) {
  .box {
    width: 90%;
    max-width: 800px;
  }
}

@media (max-width: 768px) {
  .box {
    flex-direction: column;
    height: auto;
    max-height: 90vh;
    overflow-y: auto;
    width: 95%;
    margin: 20px 0;
  }
  
  .left-section {
    flex: none;
    padding: 20px;
    min-height: 180px;
  }
  
  .right-section {
    flex: none;
    padding: 20px;
    overflow-y: auto;
    max-height: 70vh;
  }
  
  .title {
    font-size: 22px;
  }
  
  .input-container {
    margin-bottom: 12px;
  }
  
  .email-input {
    padding: 8px;
  }
}

@media (max-width: 480px) {
  .box {
    width: 95%;
  }
  
  .left-section {
    min-height: 150px;
  }
  
  .description {
    font-size: 14px;
    margin-top: 8px;
    line-height: 1.4;
  }
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

@keyframes slideUp {
  from { transform: translateY(20px); opacity: 0; }
  to { transform: translateY(0); opacity: 1; }
}

@keyframes shake {
  0%, 100% { transform: translateX(0); }
  25% { transform: translateX(-5px); }
  75% { transform: translateX(5px); }
}

.animate-fade-in {
  animation: fadeIn 0.5s ease-out;
}

.animate-slide-up {
  animation: slideUp 0.5s ease-out;
}

.animate-shake {
  animation: shake 0.5s ease-in-out;
}

@media (max-width: 768px) {
  .box {
    width: 95%;
    flex-direction: column;
  }
  
  .left-section {
    padding: 30px;
  }
  
  .right-section {
    padding: 30px;
  }
}
</style>
