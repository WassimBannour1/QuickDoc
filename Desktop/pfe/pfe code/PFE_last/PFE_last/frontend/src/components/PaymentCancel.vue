<template>
  <div class="cancel-container">
    <div class="cancel-card">
      <div class="cancel-icon">
        <svg xmlns="http://www.w3.org/2000/svg" width="80" height="80" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <circle cx="12" cy="12" r="10"></circle>
          <line x1="12" y1="8" x2="12" y2="12"></line>
          <line x1="12" y1="16" x2="12.01" y2="16"></line>
        </svg>
      </div>
      <h1 class="cancel-title">Paiement annulé</h1>
      <p class="cancel-message">
        Votre paiement a été annulé. Aucun montant n'a été débité de votre compte.
        <br>
        Si vous avez des questions ou besoin d'aide, n'hésitez pas à nous contacter.
      </p>
      <div class="buttons">
        <button @click="retryPayment" class="primary-btn">Réessayer le paiement</button>
        <button @click="goToDashboard" class="secondary-btn">Retour au tableau de bord</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router';

const router = useRouter();

const retryPayment = () => {
  router.push('/payment');
};

const goToDashboard = () => {
  router.push('/tableau-de-bord');
};
</script>

<style scoped>
.cancel-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background: linear-gradient(135deg, #f5f7fa 0%, #e4e8eb 100%);
  padding: 20px;
}

.cancel-card {
  background: white;
  border-radius: 12px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
  padding: 40px;
  max-width: 600px;
  width: 100%;
  text-align: center;
  animation: fadeIn 0.6s ease-out;
}

.cancel-icon {
  color: #FF9800;
  margin-bottom: 20px;
  animation: scaleIn 0.5s ease-out 0.3s both;
}

.cancel-title {
  color: #333;
  font-size: 28px;
  margin-bottom: 15px;
}

.cancel-message {
  color: #666;
  font-size: 16px;
  line-height: 1.6;
  margin-bottom: 30px;
}

.buttons {
  display: flex;
  gap: 15px;
  justify-content: center;
}

.primary-btn, .secondary-btn {
  padding: 12px 24px;
  border-radius: 6px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
}

.primary-btn {
  background-color: #4CAF50;
  color: white;
  border: none;
}

.primary-btn:hover {
  background-color: #43A047;
  transform: translateY(-2px);
}

.secondary-btn {
  background-color: transparent;
  color: #666;
  border: 1px solid #ccc;
}

.secondary-btn:hover {
  background-color: rgba(0, 0, 0, 0.05);
  transform: translateY(-2px);
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(20px); }
  to { opacity: 1; transform: translateY(0); }
}

@keyframes scaleIn {
  from { transform: scale(0); }
  to { transform: scale(1); }
}

@media (max-width: 600px) {
  .cancel-card {
    padding: 30px 20px;
  }
  
  .buttons {
    flex-direction: column;
  }
}
</style> 