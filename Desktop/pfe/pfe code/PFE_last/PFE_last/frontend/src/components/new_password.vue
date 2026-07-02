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
          <h2 class="title animate-fade-in">Choose a new password</h2>
          <p class="info-text animate-fade-in">Create a new password that is at least 6 characters long.</p>
  
          <div class="password-container animate-slide-up">
            <label class="label">New Password:</label>
            <div class="password-input" :class="{ 'input-focus': isInputFocused }">
              <input
                v-model="password"
                :type="showPassword ? 'text' : 'password'"
                class="input"
                placeholder="Enter your new password"
                @focus="isInputFocused = true"
                @blur="isInputFocused = false"
                @input="checkPasswordStrength"
              />
              <span class="eye-icon" @click="togglePassword">
                <img :src="showPassword ? eyeOpenIcon : eyeClosedIcon" alt="Toggle Password" class="icon-hover" />
              </span>
            </div>
            <!-- Password strength indicator -->
            <div v-if="password" class="password-strength-container">
              <div class="strength-bars">
                <div class="strength-bar" :class="{ active: passwordStrength >= 1 }"></div>
                <div class="strength-bar" :class="{ active: passwordStrength >= 2 }"></div>
                <div class="strength-bar" :class="{ active: passwordStrength >= 3 }"></div>
                <div class="strength-bar" :class="{ active: passwordStrength >= 4 }"></div>
              </div>
              <span class="strength-text" :class="strengthClass">{{ strengthText }}</span>
            </div>
          </div>
  
          <!-- Submit Button -->
          <button
            class="submit-btn animate-slide-up"
            @click="savePassword"
            :disabled="isLoading || passwordStrength < 2"
            :class="{ 'loading': isLoading }"
          >
            <span class="btn-text">{{ isLoading ? 'Saving...' : 'Save' }}</span>
            <span v-if="isLoading" class="loading-spinner"></span>
          </button>
  
          <!-- Messages -->
          <p v-if="errorMessage" class="error-message animate-shake">{{ errorMessage }}</p>
          <p v-if="successMessage" class="success-message animate-bounce">{{ successMessage }}</p>
        </div>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref } from 'vue';
  import axios from 'axios';
  import { useRouter } from 'vue-router';
  import { useMainStore } from '@/stores';
  
  // Import eye icons properly
  import eyeOpenIcon from '@/assets/eye-opened.jpg';
  import eyeClosedIcon from '@/assets/eye-closed.jpg';
  
  // Initialize store and router
  const store = useMainStore();
  const router = useRouter();
  
  // Bind data
  const password = ref('');
  const showPassword = ref(false);
  const isLoading = ref(false);
  const errorMessage = ref('');
  const successMessage = ref('');
  const isInputFocused = ref(false);
  const passwordStrength = ref(0);
  const strengthText = ref('');
  const strengthClass = ref('');
  
  // Toggle password visibility
  const togglePassword = () => {
    showPassword.value = !showPassword.value;
  };
  
  // Check password strength
  const checkPasswordStrength = () => {
    const pwd = password.value;
    
    // Reset strength if password is empty
    if (!pwd) {
      passwordStrength.value = 0;
      strengthText.value = '';
      strengthClass.value = '';
      return;
    }
    
    let score = 0;
    
    // Length check
    if (pwd.length >= 8) score += 1;
    if (pwd.length >= 12) score += 1;
    
    // Complexity checks
    if (/[A-Z]/.test(pwd)) score += 1; // Has uppercase
    if (/[0-9]/.test(pwd)) score += 1; // Has number
    if (/[^A-Za-z0-9]/.test(pwd)) score += 1; // Has special char
    
    // Set final score (max 4)
    passwordStrength.value = Math.min(4, score);
    
    // Set text and class based on score
    if (score === 0) {
      strengthText.value = 'Too weak';
      strengthClass.value = 'weak';
    } else if (score === 1) {
      strengthText.value = 'Weak';
      strengthClass.value = 'weak';
    } else if (score === 2) {
      strengthText.value = 'Fair';
      strengthClass.value = 'fair';
    } else if (score === 3) {
      strengthText.value = 'Good';
      strengthClass.value = 'good';
    } else {
      strengthText.value = 'Strong';
      strengthClass.value = 'strong';
    }
  };
  
  // Save password and call backend API
  const savePassword = async () => {
    // Reset messages
    errorMessage.value = '';
    successMessage.value = '';
  
    // Validate password length and format
    if (!password.value || password.value.length < 6) {
      errorMessage.value = 'Your password must be at least 6 characters long.';
      return;
    }
    
    // Additional password strength validation
    if (passwordStrength.value < 2) {
      errorMessage.value = 'Please choose a stronger password with a combination of uppercase letters, numbers, or special characters.';
      return;
    }
    
    if (password.value.length > 100) {
      errorMessage.value = 'Your password is too long. Maximum length is 100 characters.';
      return;
    }
    
    // Trim password to prevent accidental whitespace
    password.value = password.value.trim();
  
    isLoading.value = true;
  
    try {
      // Get email and code from store
      const email = store.email;
      const code = store.resetCode;
  
      // Call backend API to reset password
      const response = await axios.post(`${import.meta.env.VITE_API_URL}/reset-password`, {
        email,
        code,
        newPassword: password.value
      });
  
      // Show success message
      successMessage.value = response.data.message;
  
      // Clear password field
      password.value = '';
      
      // Clear stored data
      store.$reset(); // Reset the store state to its initial values
  
      // Redirect to login page after 2 seconds
      setTimeout(() => {
        router.push('/');
      }, 2000);
    } catch (error) {
      errorMessage.value = error.response?.data?.error || 'An error occurred while resetting your password.';
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
  
  /* Password Input */
  .password-container {
    margin-bottom: 20px;
  }
  
  .label {
    display: block;
    margin-bottom: 8px;
    color: #002446;
    font-weight: 500;
  }
  
  .password-input {
    display: flex;
    align-items: center;
    border: 2px solid #e1e1e1;
    border-radius: 8px;
    padding: 12px;
    background: white;
    transition: all 0.3s ease;
  }
  
  .password-input.input-focus {
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
  
  .eye-icon {
    margin-left: 10px;
    cursor: pointer;
    transition: opacity 0.3s ease;
  }
  
  .eye-icon:hover {
    opacity: 0.8;
  }
  
  .icon-hover {
    width: 20px;
    height: 20px;
    object-fit: contain;
  }
  
  /* Password Strength Indicator */
  .password-strength-container {
    margin-top: 10px;
  }
  
  .strength-bars {
    display: flex;
    gap: 5px;
    margin-bottom: 5px;
  }
  
  .strength-bar {
    height: 4px;
    flex: 1;
    background-color: #e1e1e1;
    border-radius: 2px;
    transition: background-color 0.3s ease;
  }
  
  .strength-bar.active {
    background-color: currentColor;
  }
  
  .strength-text {
    font-size: 12px;
    font-weight: 500;
  }
  
  .weak {
    color: #dc3545;
  }
  
  .fair {
    color: #ffc107;
  }
  
  .good {
    color: #17a2b8;
  }
  
  .strong {
    color: #28a745;
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
    margin-top: 10px;
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
    
    .strength-bars {
      gap: 3px;
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
    
    .password-strength-container {
      flex-direction: column;
    }
    
    .submit-btn {
      padding: 10px;
      font-size: 14px;
    }
  }
  /* Password strength indicator styles */
  .password-strength-container {
    margin-top: 8px;
    width: 100%;
  }
  
  .strength-bars {
    display: flex;
    gap: 5px;
    margin-bottom: 4px;
  }
  
  .strength-bar {
    height: 4px;
    flex: 1;
    background-color: #e0e0e0;
    border-radius: 2px;
    transition: background-color 0.3s ease;
  }
  
  .strength-bar.active {
    background-color: var(--strength-color, #ff4d4f);
  }
  
  .strength-text {
    font-size: 12px;
    transition: color 0.3s ease;
  }
  
  .weak {
    --strength-color: #ff4d4f;
    color: #ff4d4f;
  }
  
  .fair {
    --strength-color: #faad14;
    color: #faad14;
  }
  
  .good {
    --strength-color: #52c41a;
    color: #52c41a;
  }
  
  .strong {
    --strength-color: #1890ff;
    color: #1890ff;
  }
  </style>