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
          <h2 class="title animate-fade-in">Entrez le code de sécurité</h2>
          <p class="info-text animate-fade-in">
            Merci de vérifier dans vos e-mails que vous avez reçu un message avec votre code.
          </p>
  
          <div class="code-input-container animate-slide-up">
            <label class="label">Code :</label>
            <div class="code-input" :class="{ 'input-focus': isInputFocused }">
              <input
                v-model="code"
                type="text"
                class="input"
                placeholder="Entrez le code"
                @focus="isInputFocused = true"
                @blur="isInputFocused = false"
              />
              <span class="code-icon">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                  <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                </svg>
              </span>
            </div>
          </div>
  
          <p class="email-info animate-fade-in">
            Nous avons envoyé votre code à : <strong>{{ email }}</strong>
          </p>
  
          <!-- Submit Button -->
          <button
            class="submit-btn animate-slide-up"
            @click="validateCode"
            :disabled="isLoading"
            :class="{ 'loading': isLoading }"
          >
            <span class="btn-text">{{ isLoading ? 'Vérification...' : 'Continuer' }}</span>
            <span v-if="isLoading" class="loading-spinner"></span>
          </button>
  
          <!-- Messages -->
          <p v-if="errorMessage" class="error-message animate-shake">{{ errorMessage }}</p>
          <p v-if="successMessage" class="success-message animate-bounce">{{ successMessage }}</p>
  
          <!-- Resend Code Option -->
          <p class="resend-code animate-fade-in" @click="resendCode">Code non reçu ?</p>
        </div>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref, watch, onMounted } from 'vue';
  import axios from 'axios';
  import { useRouter } from 'vue-router';
  import { useMainStore } from '@/stores';
  
  const store = useMainStore();
  const router = useRouter();
  const email = ref(store.email);
  
  // Add this watch to handle email updates
  watch(() => store.email, (newEmail) => {
    email.value = newEmail;
  });
  
  // Add this mounted hook to check if email exists
  onMounted(() => {
    if (!store.email) {
      router.push('/forgot-password');
    }
  });
  const code = ref('');
  const isLoading = ref(false);
  const errorMessage = ref('');
  const successMessage = ref('');
  const isInputFocused = ref(false);
  
  // Validate the reset code
  const validateCode = async () => {
    errorMessage.value = '';
    successMessage.value = '';
    
    try {
      // Add detailed logging
      console.log('Starting code validation...');
      console.log('Email:', email.value);
      console.log('Code:', code.value);
      console.log('API URL:', `${import.meta.env.VITE_API_URL}/verify-reset-code`);

      const response = await axios.post(`${import.meta.env.VITE_API_URL}/verify-reset-code`, {
        email: email.value.toLowerCase(), // Ensure email is lowercase
        code: code.value.toUpperCase()    // Ensure code is uppercase
      });

      console.log('Server response:', response.data);

      if (response.data.success) {
        successMessage.value = response.data.message;
        store.setCode(code.value);
        
        setTimeout(() => {
          // Generate a temporary token for the URL parameter
          const tempToken = Date.now().toString();
          router.push(`/nouveau-mot-de-passe/${tempToken}`);
        }, 1000);
      } else {
        errorMessage.value = response.data.message || 'Échec de la vérification';
      }
    } catch (error) {
      console.error('Full error object:', error);
      console.error('Response data:', error.response?.data);
      console.error('Status code:', error.response?.status);
      
      if (error.response?.status === 404) {
        errorMessage.value = 'Code non trouvé ou expiré';
      } else if (error.response?.data?.message) {
        errorMessage.value = error.response.data.message;
      } else if (error.code === 'ECONNREFUSED') {
        errorMessage.value = 'Impossible de se connecter au serveur';
      } else {
        errorMessage.value = 'Une erreur est survenue lors de la validation du code';
      }
    } finally {
      isLoading.value = false;
    }
};
  
  // Resend verification code
  const resendCode = async () => {
    errorMessage.value = '';
    successMessage.value = '';
    isLoading.value = true;
    
    try {
      const response = await axios.post(`${import.meta.env.VITE_API_URL}/resend-code`, {
        email: email.value
      });
      
      successMessage.value = response.data.message;
    } catch (error) {
      errorMessage.value = error.response?.data?.error || 'Une erreur est survenue lors de l\'envoi du code.';
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
  
  /* Code Input */
  .code-input-container {
    margin-bottom: 20px;
  }
  
  .label {
    display: block;
    margin-bottom: 8px;
    color: #002446;
    font-weight: 500;
  }
  
  .code-input {
    display: flex;
    align-items: center;
    border: 2px solid #e1e1e1;
    border-radius: 8px;
    padding: 12px;
    background: white;
    transition: all 0.3s ease;
  }
  
  .code-input.input-focus {
    border-color: #002446;
    box-shadow: 0 0 0 2px rgba(0, 36, 70, 0.1);
  }
  
  .input {
    width: 100%;
    border: none;
    outline: none;
    font-size: 15px;
    color: #333;
    letter-spacing: 1px;
  }
  
  .code-icon {
    margin-left: 10px;
    color: #999;
    transition: color 0.3s ease;
  }
  
  .code-input.input-focus .code-icon {
    color: #002446;
  }
  
  .email-info {
    font-size: 14px;
    color: #666;
    margin-bottom: 20px;
    padding: 8px;
    background: rgba(0, 36, 70, 0.05);
    border-radius: 4px;
    text-align: center;
  }
  
  .email-info strong {
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
  .error-message {
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
  
  .resend-code {
    color: #002446;
    font-size: 14px;
    margin-top: 15px;
    text-align: center;
    cursor: pointer;
    transition: color 0.3s ease;
    text-decoration: underline;
  }
  
  .resend-code:hover {
    color: #001A33;
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
    }
    
    .submit-btn {
      padding: 10px;
      font-size: 14px;
    }
    
    .email-info {
      font-size: 13px;
    }
    
    .resend-code {
      margin-top: 10px;
    }
  }
  </style>