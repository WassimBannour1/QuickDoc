<template>
  <div class="container">
    <div class="box">
      <!-- Left Section -->
      <div class="left-section">
        <div class="logo-container">
          <img src="@/assets/logo.jpg" alt="Logo" class="logo" />
          <h1 class="site-name">QuikDoc</h1>
        </div>
        <p class="description">
          Gérez votre entreprise en un seul endroit!<br />
          Prenez le contrôle de votre facturation et de vos flux financiers avec une simplicité sans précédent.
        </p>
      </div>

      <!-- Right Section -->
      <div class="right-section">
        <h2 class="title animate-fade-in">Connexion</h2>
        <p class="info-text animate-fade-in">
          Connectez-vous pour accéder à votre compte.
        </p>

        <!-- Login Form -->
        <div class="input-container animate-slide-up">
          <label class="label">Email</label>
          <div class="email-input" :class="{ 'input-focus': focusedField === 'email' }">
            <input
              v-model="formData.email"
              type="email"
              placeholder="Entrez votre email"
              class="input"
              @focus="focusedField = 'email'"
              @blur="focusedField = null"
              @input="clearMessages"
            />
            <span class="input-icon">
              <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path>
                <polyline points="22,6 12,13 2,6"></polyline>
              </svg>
            </span>
          </div>
        </div>

        <div class="input-container animate-slide-up">
          <label class="label">Mot de passe</label>
          <div class="email-input" :class="{ 'input-focus': focusedField === 'password' }">
            <input
              v-model="formData.password"
              :type="showPassword ? 'text' : 'password'"
              placeholder="Entrez votre mot de passe"
              class="input"
              @focus="focusedField = 'password'"
              @blur="focusedField = null"
              @input="clearMessages"
            />
            <span class="input-icon" @click="togglePassword" style="cursor: pointer">
              <svg v-if="!showPassword" xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path>
                <line x1="1" y1="1" x2="23" y2="23"></line>
              </svg>
              <svg v-else xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                <circle cx="12" cy="12" r="3"></circle>
              </svg>
            </span>
          </div>
        </div>

        <div class="forgot-password animate-slide-up">
          <router-link to="/mot-de-passe-oublie" class="forgot-link">mot de passe oublié?</router-link>
        </div>

        <button
          class="submit-btn animate-slide-up"
          @click="handleLogin"
          :disabled="isLoading"
          :class="{ 'loading': isLoading }"
        >
          <span class="btn-text">{{ isLoading ? 'Connexion...' : 'Se connecter' }}</span>
          <span v-if="isLoading" class="loading-spinner"></span>
        </button>

        <div class="signup-link animate-fade-in">
          Pas encore de compte? 
          <router-link to="/inscription" class="link">S'inscrire</router-link>
        </div>

        <!-- Messages -->
        <p v-if="errorMessage" class="error-message animate-shake">{{ errorMessage }}</p>
        <p v-if="successMessage" class="success-message animate-bounce">{{ successMessage }}</p>
        <p v-if="backendErrorMessage" class="backend-error-message animate-shake">{{ backendErrorMessage }}</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue';
import { useRouter } from 'vue-router';
import { useMainStore } from '@/stores';
import axios from 'axios';

const store = useMainStore();
const router = useRouter();
const focusedField = ref(null);
const isLoading = ref(false);
const showPassword = ref(false);
const errorMessage = ref('');
const successMessage = ref('');
const backendErrorMessage = ref('');

const formData = reactive({
  email: '',
  password: ''
});

const clearMessages = () => {
  errorMessage.value = '';
  backendErrorMessage.value = '';
  successMessage.value = '';
};

const handleLogin = async () => {
  clearMessages();
  
  if (!validateForm()) return;

  isLoading.value = true;
  try {
    // Use VITE_API_URL directly with /signin
    const url = `${import.meta.env.VITE_API_URL}/signin`;
    console.log('Login URL:', url);
    console.log(import.meta.env.VITE_API_URL);
    
    const response = await axios.post(url, 
      {
        email: formData.email,
        password: formData.password
      },
      {
        headers: {
          'Content-Type': 'application/json'
        }
      }
    );

    console.log('Full response:', response);
    console.log('Response data:', response.data);
    console.log('User data:', response.data.user);

    if (response.data && response.data.user) {
      // Store user data in the store
      store.setUser(response.data.user);
      
      // Store the token in localStorage with the correct key name for both router and components
      if (response.data.token) {
        localStorage.setItem('token', response.data.token);
        localStorage.setItem('auth_token', response.data.token); // Add this for SuperAdmin compatibility
        console.log('Token stored in localStorage as both "token" and "auth_token"');
      }
      
      successMessage.value = response.data.message || 'Connexion réussie';
      console.log('Store after setUser:', store.user);
      
      // Redirect immediately based on user role
      console.log('User role for redirection:', store.user.role);
      
      if (store.user.role === 'admin') {
        console.log('Redirecting to admin interface');
        // Force immediate redirection to admin interface
        setTimeout(() => {
          router.push('/admin');
          console.log('Navigation to admin completed');
        }, 100);
      } else if (store.user.role && (store.user.role.toLowerCase() === 'admin entreprise' || store.user.role === 'enterprise_admin')) {
        console.log('Redirecting to admin entreprise interface');
        // Force immediate redirection to admin entreprise interface
        setTimeout(() => {
          router.push('/admin-entreprise');
          console.log('Navigation to admin-entreprise completed');
        }, 100);
      } else if (store.user.role === 'client') {
        console.log('Redirecting to client dashboard');
        router.push('/tableau-de-bord');
      } else {
        // Default redirection for other roles
        console.log('Redirecting to default dashboard');
        router.push('/tableau-de-bord');
      }
    } else {
      throw new Error('Données utilisateur manquantes dans la réponse');
    }
  } catch (error) {
    console.error('Detailed login error:', {
      message: error.message,
      status: error.response?.status,
      statusText: error.response?.statusText,
      data: error.response?.data,
      error: error
    });
    
    if (error.code === 'ERR_NETWORK') {
      backendErrorMessage.value = 'Impossible de se connecter au serveur. Vérifiez que le serveur est démarré.';
    } else if (error.response?.status === 401) {
      backendErrorMessage.value = 'Email ou mot de passe incorrect';
    } else {
      backendErrorMessage.value = error.response?.data?.message || 'Erreur de connexion. Veuillez réessayer.';
    }
  } finally {
    isLoading.value = false;
  }
};

const validateForm = () => {
  if (!formData.email || !formData.password) {
    errorMessage.value = 'Veuillez remplir tous les champs.';
    return false;
  }

  const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
  if (!emailRegex.test(formData.email)) {
    errorMessage.value = 'Adresse e-mail invalide.';
    return false;
  }

  return true;
};

// Remove handleForgotPassword function since we're using router-link

const togglePassword = () => {
  showPassword.value = !showPassword.value;
};
</script>

<style scoped>
.container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
  background: url('@/assets/outside.jpg') no-repeat center center/cover;
  background-color: #dbd9d9;
  transition: background-color 0.3s ease;
  position: relative;
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
  flex: 65%;
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

.right-section {
  flex: 35%;
  padding: 30px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  background: #ffffff;
  position: relative;
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
  margin-bottom: 20px;
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
  padding: 12px;
  background: white;
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
  transition: color 0.3s ease;
}

.email-input.input-focus .input-icon {
  color: #002446;
}

.submit-btn {
  width: 100%;
  background: #002446;
  color: white;
  padding: 12px;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
  display: flex;
  justify-content: center;
  align-items: center;
  font-weight: 500;
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

.submit-btn.loading {
  padding-right: 40px;
}

.loading-spinner {
  position: absolute;
  right: 12px;
  width: 20px;
  height: 20px;
  border: 2px solid rgba(255, 255, 255, 0.3);
  border-radius: 50%;
  border-top-color: white;
  animation: spin 0.8s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
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

/* Additional SignIn specific styles */
.forgot-password {
  text-align: right;
  margin-bottom: 20px;
}

.forgot-link {
  color: #002446;
  text-decoration: none;
  font-size: 12px;
  transition: color 0.3s ease, transform 0.2s ease;
  font-weight: 500;
  letter-spacing: 0.2px;
  display: inline-block;
}

.forgot-link:hover {
  color: #003666;
  text-decoration: underline;
  transform: translateY(-1px);
}

.signup-link {
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

/* Animations */
.animate-fade-in {
  animation: fadeIn 0.5s ease-in;
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
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes shake {
  0%, 100% { transform: translateX(0); }
  25% { transform: translateX(-10px); }
  75% { transform: translateX(10px); }
}

@keyframes bounce {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-10px); }
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
  }
  
  .left-section {
    flex: none;
    padding: 20px;
    min-height: 200px;
  }
  
  .right-section {
    flex: none;
    padding: 20px;
  }
  
  .title {
    font-size: 22px;
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