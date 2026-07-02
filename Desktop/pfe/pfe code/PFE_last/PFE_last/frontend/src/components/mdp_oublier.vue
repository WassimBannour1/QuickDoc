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
        <h2 class="title animate-fade-in">Mot de passe oublié</h2>
        <p class="info-text animate-fade-in">
          Entrez votre adresse e-mail et nous vous enverrons des instructions pour réinitialiser votre mot de passe.
        </p>

        <!-- Email Input -->
        <div class="input-container animate-slide-up">
          <label class="label">Email</label>
          <div class="email-input" :class="{ 'input-focus': isInputFocused }">
            <input
              v-model="email"
              type="email"
              class="input"
              placeholder="Entrez votre email"
              @input="clearMessages"
              @focus="isInputFocused = true"
              @blur="isInputFocused = false"
            />
            <span class="email-icon">
              <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path>
                <polyline points="22,6 12,13 2,6"></polyline>
              </svg>
            </span>
          </div>
        </div>
        <p v-if="errorMessage" class="error-message animate-shake">{{ errorMessage }}</p>

        <!-- Submit Button -->
        <button
          class="submit-btn animate-slide-up"
          @click="sendResetEmail"
          :disabled="isLoading"
          :class="{ 'loading': isLoading }"
        >
          <span class="btn-text">{{ isLoading ? 'Envoi en cours...' : 'Réinitialiser le mot de passe' }}</span>
          <span v-if="isLoading" class="loading-spinner"></span>
        </button>

        <!-- Success/Error Messages -->
        <p v-if="successMessage" class="success-message animate-bounce">{{ successMessage }}</p>
        <p v-if="backendErrorMessage" class="backend-error-message animate-shake">{{ backendErrorMessage }}</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import axios from 'axios';
import { useRouter } from 'vue-router';
import { useMainStore } from '@/stores';

const store = useMainStore();
const email = ref('');
const router = useRouter();
const isLoading = ref(false);
const errorMessage = ref('');
const successMessage = ref('');
const backendErrorMessage = ref('');
const isInputFocused = ref(false);

// Clear messages when user starts typing
const clearMessages = () => {
  errorMessage.value = '';
  backendErrorMessage.value = '';
  successMessage.value = '';
};

// Send reset email
const sendResetEmail = async () => {
  try {
    // Reset messages
    errorMessage.value = '';
    backendErrorMessage.value = '';
    successMessage.value = '';

    if (!email.value) {
      errorMessage.value = 'Veuillez entrer une adresse e-mail.';
      return;
    }

    const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    if (!emailRegex.test(email.value)) {
      errorMessage.value = 'Adresse e-mail invalide.';
      return;
    }

    isLoading.value = true;
    
    // Log the API URL and email being sent
    console.log('API URL:', import.meta.env.VITE_API_URL);
    console.log('Sending email:', email.value);

    // In sendResetEmail function
    const response = await axios.post(`${import.meta.env.VITE_API_URL}/forgot-password`, {
      email: email.value.toLowerCase()
    });

    console.log('Server response:', response.data);

    if (response.data.success) {
      store.setEmail(email.value);
      successMessage.value = response.data.message;
      setTimeout(() => {
        router.push('/verification-code');
      }, 1500);
    } else {
      backendErrorMessage.value = response.data.message;
    }
  } catch (error) {
    console.error('Error details:', {
      message: error.message,
      response: error.response?.data,
      status: error.response?.status
    });
    backendErrorMessage.value = error.response?.data?.message || 'Une erreur est survenue';
  } finally {
    isLoading.value = false;
  }
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
  font-size: 24px;
  font-weight: bold;
  margin-bottom: 15px;
  color: #002446;
}

.info-text {
  font-size: 14px;
  margin-bottom: 20px;
  color: #666;
}

/* Input Styling */
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
  width: 100%;
  border: none;
  outline: none;
  font-size: 15px;
  color: #333;
}

.email-icon {
  margin-left: 10px;
  color: #999;
  transition: color 0.3s ease;
}

.email-input.input-focus .email-icon {
  color: #002446;
}

/* Button */
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

/* Message Styles */
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

/* Animations */
@keyframes spin {
  to { transform: rotate(360deg); }
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
</style>