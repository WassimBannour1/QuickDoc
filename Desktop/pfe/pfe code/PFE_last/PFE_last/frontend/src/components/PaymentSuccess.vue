<template>
  <div class="success-container">
    <div class="success-card">
      <div class="success-icon">
        <svg xmlns="http://www.w3.org/2000/svg" width="80" height="80" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
          <polyline points="22 4 12 14.01 9 11.01"></polyline>
        </svg>
      </div>
      <h1 class="success-title">Paiement réussi!</h1>
      <p class="success-message">Votre paiement a été traité avec succès. Merci pour votre confiance.</p>
      <div class="transaction-details" v-if="sessionDetails">
        <h2>Détails de la transaction</h2>
        <div class="detail-row">
          <span>Montant:</span>
          <span>{{ formatAmount(sessionDetails.amount_total) }}</span>
        </div>
        <div class="detail-row">
          <span>Date:</span>
          <span>{{ formatDate(sessionDetails.created) }}</span>
        </div>
        <div class="detail-row reference-row">
          <span>Référence:</span>
          <span class="reference-value" :title="sessionDetails.id">{{ truncateReference(sessionDetails.id) }}</span>
        </div>
      </div>
      <div class="buttons">
        <button @click="goToFactures" class="primary-btn">Consulter mes factures</button>
        <button @click="downloadReceipt" class="secondary-btn" v-if="sessionDetails">Télécharger le reçu</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import axios from 'axios';

const router = useRouter();
const sessionDetails = ref(null);
const loading = ref(true);
const error = ref(null);

onMounted(async () => {
  try {
    // Get session ID from URL query parameter
    const urlParams = new URLSearchParams(window.location.search);
    const sessionId = urlParams.get('session_id');
    
    if (sessionId) {
      // Verify payment with backend
      const response = await axios.get(`http://localhost:5000/api/payment/verify/${sessionId}`, {
        headers: {
          'Authorization': `Bearer ${localStorage.getItem('auth_token')}`
        }
      });
      
      if (response.data.success && response.data.paid) {
        sessionDetails.value = response.data.session;
      } else {
        error.value = 'Le paiement n\'a pas été confirmé.';
      }
    } else {
      error.value = 'Impossible de vérifier le paiement: Session ID manquant.';
    }
  } catch (err) {
    console.error('Erreur lors de la vérification du paiement:', err);
    error.value = 'Une erreur est survenue lors de la vérification du paiement.';
  } finally {
    loading.value = false;
  }
});

const goToFactures = () => {
  // Rediriger vers la page de gestion des factures
  router.push('/tableau-de-bord');
  // Après la redirection, définir la vue sur 'factures'
  setTimeout(() => {
    // Utiliser un événement personnalisé pour communiquer avec le Dashboard
    window.dispatchEvent(new CustomEvent('navigate-dashboard', { 
      detail: { view: 'factures' } 
    }));
  }, 100);
};

const downloadReceipt = () => {
  if (!sessionDetails.value) return;
  
  // Create a printable receipt in a new window
  const printWindow = window.open('', '_blank');
  
  // Generate receipt HTML content
  const receiptHTML = `
    <!DOCTYPE html>
    <html>
    <head>
      <title>QuikDoc - Reçu de paiement</title>
      <style>
        body {
          font-family: Arial, sans-serif;
          margin: 0;
          padding: 20px;
          color: #333;
        }
        .receipt {
          max-width: 800px;
          margin: 0 auto;
          border: 1px solid #ddd;
          padding: 30px;
          box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .header {
          text-align: center;
          margin-bottom: 30px;
          border-bottom: 2px solid #4CAF50;
          padding-bottom: 20px;
        }
        .logo {
          font-size: 24px;
          font-weight: bold;
          color: #4CAF50;
        }
        .title {
          font-size: 22px;
          margin: 15px 0;
          color: #4CAF50;
        }
        .details {
          margin-bottom: 30px;
        }
        .details-row {
          display: flex;
          justify-content: space-between;
          padding: 8px 0;
          border-bottom: 1px solid #eee;
        }
        .details-row:last-child {
          border-bottom: none;
        }
        .table {
          width: 100%;
          border-collapse: collapse;
          margin: 20px 0;
        }
        .table th {
          background-color: #4CAF50;
          color: white;
          text-align: left;
          padding: 10px;
        }
        .table td {
          padding: 10px;
          border-bottom: 1px solid #ddd;
        }
        .table tr:last-child td {
          font-weight: bold;
        }
        .footer {
          text-align: center;
          margin-top: 30px;
          font-size: 14px;
          color: #666;
        }
        @media print {
          .no-print {
            display: none;
          }
          body {
            padding: 0;
          }
          .receipt {
            box-shadow: none;
            border: none;
          }
        }
      </style>
    </head>
    <body>
      <div class="receipt">
        <div class="header">
          <div class="logo">QuikDoc</div>
          <div class="title">Reçu de paiement</div>
        </div>
        
        <div class="details">
          <div class="details-row">
            <span>Date:</span>
            <span>${formatDate(sessionDetails.value.created)}</span>
          </div>
          <div class="details-row">
            <span>Référence:</span>
            <span>${sessionDetails.value.id}</span>
          </div>
        </div>
        
        <table class="table">
          <thead>
            <tr>
              <th>Description</th>
              <th>Montant</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>Services QuikDoc</td>
              <td>${formatAmount(sessionDetails.value.amount_total)}</td>
            </tr>
            <tr>
              <td>Total</td>
              <td>${formatAmount(sessionDetails.value.amount_total)}</td>
            </tr>
          </tbody>
        </table>
        
        <div class="footer">
          <p>Merci pour votre confiance.</p>
          <p>Pour toute question, contactez notre service client.</p>
        </div>
        
        <div class="no-print" style="text-align: center; margin-top: 30px;">
          <button onclick="window.print();" style="padding: 10px 20px; background: #4CAF50; color: white; border: none; border-radius: 4px; cursor: pointer;">Imprimer le reçu</button>
        </div>
      </div>
    </body>
    </html>
  `;
  
  // Write the HTML content to the new window
  printWindow.document.write(receiptHTML);
  printWindow.document.close();
  
  // Trigger print after the content is loaded
  printWindow.onload = function() {
    setTimeout(() => {
      printWindow.focus();
      // You can automatically trigger print with:
      // printWindow.print();
    }, 300);
  };
};

const formatAmount = (amountInCents) => {
  return `${(amountInCents / 100).toFixed(2)} €`;
};

const formatDate = (timestamp) => {
  return new Date(timestamp * 1000).toLocaleDateString('fr-FR', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  });
};

const truncateReference = (reference) => {
  if (!reference) return '';
  if (reference.length <= 20) return reference;
  return reference.substring(0, 10) + '...' + reference.substring(reference.length - 10);
};
</script>

<style scoped>
.success-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background: linear-gradient(135deg, #f5f7fa 0%, #e4e8eb 100%);
  padding: 20px;
}

.success-card {
  background: white;
  border-radius: 12px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
  padding: 40px;
  max-width: 600px;
  width: 100%;
  text-align: center;
  animation: fadeIn 0.6s ease-out;
}

.success-icon {
  color: #4CAF50;
  margin-bottom: 20px;
  animation: scaleIn 0.5s ease-out 0.3s both;
}

.success-title {
  color: #333;
  font-size: 28px;
  margin-bottom: 15px;
}

.success-message {
  color: #666;
  font-size: 16px;
  line-height: 1.6;
  margin-bottom: 30px;
}

.transaction-details {
  background-color: #f9f9f9;
  border-radius: 8px;
  padding: 20px;
  margin-bottom: 30px;
  text-align: left;
}

.transaction-details h2 {
  font-size: 18px;
  margin-bottom: 15px;
  color: #333;
}

.detail-row {
  display: flex;
  justify-content: space-between;
  padding: 8px 0;
  border-bottom: 1px solid #eee;
}

.detail-row:last-child {
  border-bottom: none;
}

.reference-row {
  align-items: center;
}

.reference-value {
  font-size: 12px;
  max-width: 60%;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  cursor: pointer;
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
  color: #4CAF50;
  border: 1px solid #4CAF50;
}

.secondary-btn:hover {
  background-color: rgba(76, 175, 80, 0.1);
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
  .success-card {
    padding: 30px 20px;
  }
  
  .buttons {
    flex-direction: column;
  }
}
</style> 