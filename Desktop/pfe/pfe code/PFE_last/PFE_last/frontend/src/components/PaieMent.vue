<template>
  <div class="container">
    <div class="box">
      <!-- Left Section -->
      <div class="left-section">
        <div class="logo-container">
          <img src="@/assets/logo.jpg" alt="Logo" class="logo" />
          <h1 class="site-name">QuikDoc</h1>
        </div>
        <div class="secure-payment-info">
          <div class="secure-icon">
            <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
              <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
            </svg>
          </div>
          <h2 class="secure-heading">Paiement 100% Sécurisé</h2>
          <p class="description">
            Toutes vos données de paiement sont cryptées et protégées.<br />
            Nous utilisons les dernières technologies de sécurité.
          </p>
        </div>
      </div>

      <!-- Right Section -->
      <div class="right-section">
        <div class="payment-header">
          <h2 class="title animate-fade-in">Finaliser votre paiement</h2>
          <div class="payment-cards">
            <span class="card-icon visa"></span>
            <span class="card-icon mastercard"></span>
            <span class="card-icon amex"></span>
          </div>
        </div>

        <div class="payment-summary">
          <div class="summary-row">
            <span>Total à payer:</span>
            <span class="amount-display">{{ amount > 0 ? amount + ' €' : '0.00 €' }}</span>
          </div>
        </div>

        <!-- Payment Form -->
        <div class="input-container animate-slide-up">
          <label class="label">Montant à payer</label>
          <div class="input-field" :class="{ 'input-focus': focusedField === 'amount' }">
            <span class="currency-symbol">€</span>
            <input
              v-model="amount"
              type="number"
              placeholder="0.00"
              class="input"
              @focus="focusedField = 'amount'"
              @blur="focusedField = null"
            />
          </div>
        </div>

        <button
          @click="redirectToCheckout"
          :disabled="processing || !amount || amount <= 0"
          class="submit-btn animate-slide-up"
          :class="{ 'loading': processing }"
        >
          <span class="btn-text">{{ processing ? 'Redirection...' : 'Payer maintenant' }}</span>
          <span v-if="processing" class="loading-spinner"></span>
          <svg v-else class="btn-arrow" xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <line x1="5" y1="12" x2="19" y2="12"></line>
            <polyline points="12 5 19 12 12 19"></polyline>
          </svg>
        </button>
        
        <div class="payment-footer">
          <div class="secure-badge">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
              <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
            </svg>
            <span>Paiement sécurisé SSL</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import axios from 'axios';
import { useMainStore } from '@/stores';
import { useRoute } from 'vue-router';

const amount = ref(0);
const processing = ref(false);
const focusedField = ref(null);
const store = useMainStore();
const route = useRoute();

onMounted(() => {
  // Vérifier si un ID de facture est passé dans l'URL
  const factureId = route.query.factureId;
  if (factureId) {
    console.log('ID de facture détecté:', factureId);
    // Récupérer les détails de la facture pour pré-remplir le montant
    fetchFactureDetails(factureId);
  }
});

const fetchFactureDetails = async (factureId) => {
  try {
    const token = localStorage.getItem('token');
    if (!token) {
      console.error('Token d\'authentification non trouvé');
      return;
    }
    
    const response = await axios.get(`http://localhost:5000/api/protected/documents/by-remplissage/${factureId}`, {
      headers: {
        'Authorization': `Bearer ${token}`
      }
    });
    
    if (response.data.success && response.data.document) {
      // Pré-remplir le montant avec celui de la facture
      amount.value = response.data.document.montant_ttc || response.data.document.amount || 0;
      console.log('Montant récupéré de la facture:', amount.value);
    }
  } catch (error) {
    console.error('Erreur lors de la récupération des détails de la facture:', error);
  }
};

const redirectToCheckout = async () => {
  if (!amount.value || amount.value <= 0) {
    return;
  }
  
  try {
    processing.value = true;
    
    // Récupérer le token d'authentification
    const token = localStorage.getItem('token');
    
    // Récupérer les informations de l'utilisateur depuis le store
    const user = store.user;
    
    // Ajouter des logs pour le débogage
    console.log('Montant à payer:', amount.value);
    console.log('Token d\'authentification:', token ? 'Présent' : 'Absent');
    console.log('Informations utilisateur:', user);
    
    // Préparer les données pour la requête de paiement
    const paymentData = {
      amount: amount.value,
      // Inclure les informations de l'utilisateur si disponibles
      customerEmail: user?.email,
      customerName: user?.nom || user?.name
    };
    
    // Utiliser l'URL complète du backend
    const response = await axios.post('http://localhost:5000/api/payment/create', paymentData, {
      headers: {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json'
      }
    });

    console.log('Réponse du serveur:', response.data);

    // Si la création de la session a réussi, rediriger vers l'URL Checkout
    if (response.data.success && response.data.checkoutUrl) {
      window.location.href = response.data.checkoutUrl;
    } else {
      throw new Error('Réponse invalide du serveur');
    }
  } catch (err) {
    console.error('Erreur détaillée:', err.response ? err.response.data : err.message);
    alert('Une erreur est survenue lors de la préparation du paiement.');
  } finally {
    processing.value = false;
  }
};
</script>

<style scoped>
/* Les styles restent identiques à votre code original */
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
  flex: 50%;
  background: linear-gradient(135deg, #002446 0%, #004c99 100%);
  color: white;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 40px 30px;
  position: relative;
}

.logo-container {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 40px;
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
  text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.3);
}

.secure-payment-info {
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
}

.secure-icon {
  margin-bottom: 15px;
}

.secure-heading {
  font-size: 22px;
  margin-bottom: 15px;
  font-weight: 600;
}

.description {
  font-size: 15px;
  line-height: 1.5;
  opacity: 0.9;
}

.right-section {
  flex: 50%;
  padding: 40px 30px;
  display: flex;
  flex-direction: column;
  background: #ffffff;
}

.payment-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.title {
  color: #002446;
  font-size: 22px;
  margin: 0;
}

.payment-cards {
  display: flex;
  gap: 8px;
}

.card-icon {
  width: 40px;
  height: 25px;
  background-color: #f0f0f0;
  border-radius: 4px;
  opacity: 0.7;
  transition: opacity 0.3s ease;
}

.card-icon:hover {
  opacity: 1;
}

.payment-summary {
  background-color: #f8f9fa;
  border-radius: 8px;
  padding: 15px;
  margin-bottom: 25px;
}

.summary-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 16px;
}

.amount-display {
  font-weight: 600;
  color: #002446;
  font-size: 18px;
}

.input-container {
  margin-bottom: 20px;
}

.label {
  display: block;
  margin-bottom: 8px;
  color: #002446;
  font-weight: 500;
  font-size: 14px;
}

.input-field {
  display: flex;
  align-items: center;
  border: 2px solid #e1e1e1;
  border-radius: 8px;
  padding: 12px 15px;
  background: white;
  transition: all 0.3s ease;
}

.input-field.input-focus {
  border-color: #002446;
  box-shadow: 0 0 0 2px rgba(0, 36, 70, 0.1);
}

.currency-symbol {
  color: #666;
  margin-right: 8px;
  font-weight: 500;
}

.input {
  flex: 1;
  border: none;
  outline: none;
  font-size: 16px;
  color: #333;
  background: transparent;
}

.submit-btn {
  width: 100%;
  background: #002446;
  color: white;
  padding: 14px;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s ease;
  position: relative;
  display: flex;
  justify-content: center;
  align-items: center;
  font-weight: 500;
  font-size: 16px;
  margin-top: 10px;
}

.submit-btn:hover:not(:disabled) {
  background: #001A33;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 36, 70, 0.2);
}

.submit-btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
  background: #6c757d;
}

.btn-arrow {
  margin-left: 10px;
}

.loading-spinner {
  margin-left: 10px;
  width: 20px;
  height: 20px;
  border: 2px solid rgba(255, 255, 255, 0.3);
  border-radius: 50%;
  border-top-color: white;
  animation: spin 0.8s linear infinite;
}

.payment-footer {
  margin-top: 20px;
  display: flex;
  justify-content: center;
}

.secure-badge {
  display: flex;
  align-items: center;
  gap: 8px;
  color: #6c757d;
  font-size: 14px;
}

/* Animations */
.animate-fade-in {
  animation: fadeIn 0.5s ease-in;
}

.animate-slide-up {
  animation: slideUp 0.5s ease-out;
}

@keyframes spin {
  to { transform: rotate(360deg); }
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
    padding: 30px 20px;
  }
  
  .right-section {
    padding: 30px 20px;
  }
  
  .payment-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 15px;
  }
  
  .payment-cards {
    align-self: center;
  }
}

@media (max-width: 480px) {
  .box {
    width: 95%;
  }
  
  .secure-heading {
    font-size: 20px;
  }
  
  .description {
    font-size: 14px;
  }
  
  .submit-btn {
    padding: 12px;
  }
}
</style>