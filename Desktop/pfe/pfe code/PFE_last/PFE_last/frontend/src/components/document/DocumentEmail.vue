<template>
  <div class="document-email-container">
    <div class="email-header">
      <h2>Envoi de documents par email</h2>
      <p class="email-description">Envoyez vos documents directement par email à vos clients</p>
    </div>

    <div class="email-tools">
      <div class="search-bar">
        <i class="fas fa-search search-icon"></i>
        <input 
          type="text" 
          v-model="searchQuery" 
          placeholder="Rechercher un document..." 
          @input="handleSearch"
          class="search-input"
        />
        <button v-if="searchQuery" @click="clearSearch" class="clear-search">
          <i class="fas fa-times"></i>
        </button>
      </div>
    </div>

    <div class="documents-list">
      <div v-if="loading" class="loading-container">
        <div class="loading-spinner"></div>
        <p>Chargement des documents...</p>
      </div>

      <div v-else-if="filteredDocuments.length === 0" class="no-documents">
        <i class="fas fa-envelope no-documents-icon"></i>
        <p>Aucun document trouvé</p>
        <p class="no-documents-hint">Essayez de modifier vos critères de recherche</p>
      </div>

      <div v-else class="documents-grid">
        <div 
          v-for="document in filteredDocuments" 
          :key="document.id" 
          class="document-card"
        >
          <div class="document-icon" :class="`document-type-${document.type}`">
            <i :class="getDocumentIcon(document.type)"></i>
          </div>
          <div class="document-info">
            <h3 class="document-title">{{ document.name }}</h3>
            <p class="document-type">{{ getDocumentTypeName(document.type) }}</p>
            <p class="document-date">{{ formatDate(document.date) }}</p>
            <p class="document-client">{{ document.client.name }}</p>
            <div class="document-status" :class="`status-${document.status}`">
              {{ getStatusName(document.status) }}
            </div>
          </div>
          <div class="document-actions">
            <button @click="previewDocument(document)" class="action-button preview-button" title="Aperçu">
              <i class="fas fa-eye"></i>
            </button>
            <button @click="emailDocument(document)" class="action-button email-button" title="Envoyer par email">
              <i class="fas fa-envelope"></i>
            </button>
          </div>
        </div>
      </div>

      <div v-if="filteredDocuments.length > 0" class="pagination">
        <button 
          @click="prevPage" 
          :disabled="currentPage === 1"
          class="pagination-button"
        >
          <i class="fas fa-chevron-left"></i>
        </button>
        <span class="pagination-info">Page {{ currentPage }} sur {{ totalPages }}</span>
        <button 
          @click="nextPage" 
          :disabled="currentPage === totalPages"
          class="pagination-button"
        >
          <i class="fas fa-chevron-right"></i>
        </button>
      </div>
    </div>

    <!-- Modal d'envoi par email -->
    <div v-if="showEmailModal" class="email-modal-overlay" @click="closeEmailModal">
      <div class="email-modal" @click.stop>
        <div class="modal-header">
          <h3>Envoyer par email</h3>
          <button @click="closeEmailModal" class="close-modal">
            <i class="fas fa-times"></i>
          </button>
        </div>
        <div class="modal-body">
          <div class="selected-document">
            <div class="document-icon-small" :class="`document-type-${selectedDocument?.type}`">
              <i :class="getDocumentIcon(selectedDocument?.type)"></i>
            </div>
            <div class="selected-document-info">
              <h4>{{ selectedDocument?.name }}</h4>
              <p>{{ getDocumentTypeName(selectedDocument?.type) }}</p>
            </div>
          </div>

          <div class="form-group">
            <label>Destinataire</label>
            <input 
              type="email" 
              v-model="emailForm.to" 
              placeholder="Adresse email du destinataire" 
              class="form-input"
            />
          </div>
          <div class="form-group">
            <label>Objet</label>
            <input 
              type="text" 
              v-model="emailForm.subject" 
              placeholder="Objet de l'email" 
              class="form-input"
            />
          </div>
          <div class="form-group">
            <label>Message</label>
            <textarea 
              v-model="emailForm.message" 
              placeholder="Votre message" 
              rows="5"
              class="form-textarea"
            ></textarea>
          </div>
          <div class="form-group checkbox-group">
            <input type="checkbox" id="sendCopy" v-model="emailForm.sendCopy" />
            <label for="sendCopy">M'envoyer une copie</label>
          </div>
          <div class="form-group checkbox-group">
            <input type="checkbox" id="includeAttachment" v-model="emailForm.includeAttachment" checked disabled />
            <label for="includeAttachment">Inclure le document en pièce jointe</label>
          </div>          
          <!-- Message de succès d'envoi -->
          <div v-if="emailSent" class="email-success-message">
            <i class="fas fa-check-circle"></i>
            <span>Email envoyé avec succès !</span>
          </div>
        </div>
        <div class="modal-footer">
          <button @click="closeEmailModal" class="cancel-button">
            Annuler
          </button>
          <button @click="sendEmail" class="send-button" :disabled="isSending || !isFormValid">
            <i class="fas fa-paper-plane"></i> 
            {{ isSending ? 'Envoi en cours...' : 'Envoyer' }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue';
import { useRouter } from 'vue-router';
import documentService from '@/services/documentService';
import emailService from '@/services/emailService';
import notificationService from '@/services/notificationService';

// Router
const router = useRouter();

// State
const searchQuery = ref('');
const loading = ref(true);
const documents = ref([]);
const currentPage = ref(1);
const itemsPerPage = 12;
const showEmailModal = ref(false);
const selectedDocument = ref(null);
const isSending = ref(false);
const emailSent = ref(false);

// Email form
const emailForm = ref({
  to: '',
  subject: '',
  message: '',
  sendCopy: false,
  includeAttachment: true
});

// Fetch documents
onMounted(async () => {
  try {
    loading.value = true;
    const response = await documentService.getDocuments();
    documents.value = response.data.documents;
    loading.value = false;
  } catch (error) {
    console.error('Erreur lors du chargement des documents:', error);
    loading.value = false;
  }
});

// Computed properties
const filteredDocuments = computed(() => {
  if (!searchQuery.value) {
    return paginatedDocuments.value;
  }
  
  const query = searchQuery.value.toLowerCase();
  const filtered = documents.value.filter(doc => 
    doc.name.toLowerCase().includes(query) ||
    doc.client.name.toLowerCase().includes(query) ||
    getDocumentTypeName(doc.type).toLowerCase().includes(query)
  );
  
  return filtered.slice(
    (currentPage.value - 1) * itemsPerPage,
    currentPage.value * itemsPerPage
  );
});

const paginatedDocuments = computed(() => {
  return documents.value.slice(
    (currentPage.value - 1) * itemsPerPage,
    currentPage.value * itemsPerPage
  );
});

const totalPages = computed(() => {
  return Math.ceil(documents.value.length / itemsPerPage);
});

const isFormValid = computed(() => {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return (
    emailForm.value.to && 
    emailRegex.test(emailForm.value.to) && 
    emailForm.value.subject && 
    emailForm.value.message
  );
});

// Methods
const handleSearch = () => {
  currentPage.value = 1;
};

const clearSearch = () => {
  searchQuery.value = '';
};

const prevPage = () => {
  if (currentPage.value > 1) {
    currentPage.value--;
  }
};

const nextPage = () => {
  if (currentPage.value < totalPages.value) {
    currentPage.value++;
  }
};

const previewDocument = (document) => {
  router.push({
    path: '/admin-entreprise/document-preview',
    query: { id: document.id }
  });
};

const emailDocument = (document) => {
  selectedDocument.value = document;
  
  // Pré-remplir le formulaire d'email
  emailForm.value.subject = `${getDocumentTypeName(document.type)} - ${document.name}`;
  emailForm.value.message = `Bonjour,\n\nVeuillez trouver ci-joint ${getDocumentTypeName(document.type).toLowerCase()} ${document.name}.\n\nCordialement,\nL'équipe QuikDoc`;
  
  // Si le document est associé à un client, pré-remplir l'adresse email
  if (document.client && document.client.email) {
    emailForm.value.to = document.client.email;
  } else {
    emailForm.value.to = '';
  }
  
  showEmailModal.value = true;
};

const closeEmailModal = () => {
  showEmailModal.value = false;
  // Réinitialiser l'état du message de succès
  emailSent.value = false;
};

const sendEmail = async () => {
  try {
    isSending.value = true;
    
    // Préparation des données pour l'envoi via le service d'email unifié
    const emailData = {
      documentId: selectedDocument.value.id,
      documentType: selectedDocument.value.type || 'facture',
      to: emailForm.value.to,
      subject: emailForm.value.subject,
      message: emailForm.value.message,
      attachPdf: emailForm.value.includeAttachment !== undefined ? emailForm.value.includeAttachment : true,
      sendCopy: emailForm.value.sendCopy || false
    };
    
    console.log('Envoi de document par email:', emailData);
    
    // Utiliser le service d'email unifié qui utilise le même service que les emails de vérification et mot de passe
    const response = await emailService.sendDocumentEmail(emailData);
    
    // Afficher la notification améliorée
    if (response.notification) {
      // Si le backend a fourni une notification structurée, l'utiliser
      notificationService.show(response.notification);
    } else {
      // Sinon, créer une notification par défaut
      notificationService.show({
        type: 'success',
        title: 'Email envoyé !',
        message: response.message || 'Document envoyé par email avec succès',
        icon: 'paper-plane',
        color: '#1e3a8a', // Couleur de la barre latérale (bleu foncé)
        duration: 5000,
        position: 'top-right'
      });
    }
    
    // Activer le message de succès dans la modal
    emailSent.value = true;
    
    // Attendre quelques secondes avant de fermer la modal
    setTimeout(() => {
      showEmailModal.value = false;
      isSending.value = false;
      // Réinitialiser le message après la fermeture
      setTimeout(() => {
        emailSent.value = false;
      }, 300);
    }, 2000);
    
    // Ajouter un événement à l'historique du document
    if (selectedDocument.value.history) {
      selectedDocument.value.history.push({
        type: 'sent',
        date: new Date().toISOString(),
        user: 'Utilisateur actuel',
        comment: `Envoyé par email à ${emailForm.value.to}`
      });
    }
  } catch (error) {
    console.error('Erreur lors de l\'envoi de l\'email:', error);
    notificationService.error('Erreur lors de l\'envoi de l\'email: ' + (error.response?.data?.message || error.message), {
      title: 'Échec de l\'envoi',
      icon: 'exclamation-circle',
      duration: 7000
    });
    isSending.value = false;
  }
};

// Utility methods
const formatDate = (dateString) => {
  const options = { year: 'numeric', month: 'long', day: 'numeric' };
  return new Date(dateString).toLocaleDateString('fr-FR', options);
};

const getDocumentIcon = (type) => {
  const icons = {
    'facture': 'fas fa-file-invoice-dollar',
    'devis': 'fas fa-file-contract',
    'bon_livraison': 'fas fa-truck',
    'contrat': 'fas fa-file-signature'
  };
  
  return icons[type] || 'fas fa-file-alt';
};

const getDocumentTypeName = (type) => {
  const types = {
    'facture': 'Facture',
    'devis': 'Devis',
    'bon_livraison': 'Bon de livraison',
    'contrat': 'Contrat'
  };
  
  return types[type] || 'Document';
};

const getStatusName = (status) => {
  const statuses = {
    'draft': 'Brouillon',
    'sent': 'Envoyé',
    'paid': 'Payé',
    'overdue': 'En retard'
  };
  
  return statuses[status] || 'Inconnu';
};
</script>

<style scoped>
.document-email-container {
  padding: 20px;
  height: 100%;
  display: flex;
  flex-direction: column;
  animation: fadeIn 0.5s ease-out forwards;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(20px); }
  to { opacity: 1; transform: translateY(0); }
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(20px); }
  to { opacity: 1; transform: translateY(0); }
}

.email-header {
  margin-bottom: 25px;
  padding: 15px;
  background: linear-gradient(135deg, #1a237e, #283593);
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(26, 35, 126, 0.2);
  animation: slideDown 0.4s cubic-bezier(0.34, 1.56, 0.64, 1) forwards;
}

@keyframes slideDown {
  from { opacity: 0; transform: translateY(-15px); }
  to { opacity: 1; transform: translateY(0); }
}

@keyframes slideDown {
  from { opacity: 0; transform: translateY(-15px); }
  to { opacity: 1; transform: translateY(0); }
}

.email-header h2 {
  font-size: 1.5rem;
  color: #ffffff;
  margin-bottom: 8px;
  letter-spacing: 0.5px;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
}

.email-description {
  color: rgba(255, 255, 255, 0.9);
  font-size: 0.9rem;
  font-weight: 300;
}

.email-tools {
  display: flex;
  justify-content: space-between;
  margin-bottom: 20px;
  animation: fadeIn 0.6s ease-out forwards;
  animation-delay: 0.1s;
  opacity: 0;
}

.search-bar {
  position: relative;
  width: 100%;
  max-width: 500px;
  transition: all 0.3s ease;
}

.search-bar:focus-within {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(26, 35, 126, 0.15);
}

.search-icon {
  position: absolute;
  left: 12px;
  top: 50%;
  transform: translateY(-50%);
  color: #3f51b5;
  transition: all 0.3s ease;
}

.search-input {
  width: 100%;
  padding: 12px 40px 12px 38px;
  border: 2px solid #e0e0e0;
  border-radius: 8px;
  font-size: 0.95rem;
  color: #334155;
  background-color: rgba(255, 255, 255, 0.9);
  transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
}

.search-input:focus {
  outline: none;
  border-color: #3f51b5;
  box-shadow: 0 0 0 3px rgba(63, 81, 181, 0.2);
}

.clear-search {
  position: absolute;
  right: 10px;
  top: 50%;
  transform: translateY(-50%);
  background: none;
  border: none;
  color: #7986cb;
  cursor: pointer;
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  transition: all 0.2s ease;
  font-size: 0.9rem;
}

.clear-search:hover {
  background-color: rgba(63, 81, 181, 0.1);
  color: #3f51b5;
}

.documents-list {
  flex: 1;
  overflow-y: auto;
}

.loading-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 200px;
  color: #546e7a;
  animation: fadeIn 0.5s ease-out forwards;
}

.loading-spinner {
  width: 50px;
  height: 50px;
  border: 3px solid rgba(26, 35, 126, 0.1);
  border-top: 3px solid #1a237e;
  border-right: 3px solid #1a237e;
  border-radius: 50%;
  animation: spin 1.2s cubic-bezier(0.5, 0.1, 0.5, 0.9) infinite;
  margin-bottom: 20px;
  box-shadow: 0 0 10px rgba(26, 35, 126, 0.1);
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.no-documents {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 200px;
  color: #546e7a;
  text-align: center;
  animation: fadeIn 0.5s ease-out forwards;
}

.no-documents-icon {
  font-size: 3.5rem;
  color: #3f51b5;
  margin-bottom: 20px;
  opacity: 0.7;
  animation: pulse 2s infinite;
}

@keyframes pulse {
  0% { transform: scale(1); opacity: 0.7; }
  50% { transform: scale(1.1); opacity: 0.9; }
  100% { transform: scale(1); opacity: 0.7; }
}

.no-documents-hint {
  font-size: 0.95rem;
  color: #7986cb;
  margin-top: 8px;
  font-style: italic;
}

.documents-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 20px;
  animation: fadeIn 0.7s ease-out forwards;
  animation-delay: 0.2s;
  opacity: 0;
}

.document-card {
  background-color: white;
  border-radius: 10px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  padding: 18px;
  transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
  position: relative;
  border-left: 4px solid #1a237e;
  overflow: hidden;
}

.document-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: linear-gradient(135deg, rgba(26, 35, 126, 0.05) 0%, rgba(255, 255, 255, 0) 50%);
  z-index: 0;
}

.document-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 8px 20px rgba(26, 35, 126, 0.2);
}

.document-icon {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 15px;
  font-size: 1.2rem;
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
  position: relative;
  z-index: 1;
  transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
}

.document-card:hover .document-icon {
  transform: scale(1.1) rotate(-5deg);
}

.document-type-facture {
  background: linear-gradient(135deg, #1a237e, #283593);
  color: white;
}

.document-type-devis {
  background: linear-gradient(135deg, #1a237e, #3949ab);
  color: white;
}

.document-type-bon_livraison {
  background: linear-gradient(135deg, #1a237e, #303f9f);
  color: white;
}

.document-type-contrat {
  background: linear-gradient(135deg, #1a237e, #283593);
  color: white;
}

.document-info {
  margin-bottom: 15px;
  position: relative;
  z-index: 1;
}

.document-title {
  font-size: 1.15rem;
  font-weight: 600;
  color: #1a237e;
  margin: 0 0 8px 0;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  transition: all 0.3s ease;
  position: relative;
  display: inline-block;
}

.document-title::after {
  content: '';
  position: absolute;
  bottom: -2px;
  left: 0;
  width: 0;
  height: 2px;
  background-color: #3f51b5;
  transition: width 0.3s ease;
}

.document-card:hover .document-title::after {
  width: 100%;
}

.document-type,
.document-date,
.document-client {
  font-size: 0.9rem;
  color: #546e7a;
  margin: 5px 0;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
}

.document-type::before,
.document-date::before,
.document-client::before {
  content: '';
  display: inline-block;
  width: 6px;
  height: 6px;
  background-color: #3f51b5;
  border-radius: 50%;
  margin-right: 8px;
  opacity: 0.7;
}

.document-status {
  display: inline-block;
  padding: 4px 10px;
  border-radius: 20px;
  font-size: 0.8rem;
  font-weight: 500;
  margin-top: 8px;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
  transition: all 0.3s ease;
}

.status-draft {
  background: linear-gradient(135deg, #455a64, #607d8b);
  color: white;
}

.status-sent {
  background: linear-gradient(135deg, #1a237e, #283593);
  color: white;
}

.status-paid {
  background: linear-gradient(135deg, #1b5e20, #2e7d32);
  color: white;
}

.status-overdue {
  background: linear-gradient(135deg, #b71c1c, #c62828);
  color: white;
}

.document-actions {
  display: flex;
  gap: 8px;
  position: absolute;
  top: 15px;
  right: 15px;
  z-index: 2;
}

.action-button {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  border: none;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
  box-shadow: 0 3px 8px rgba(0, 0, 0, 0.12);
  position: relative;
  overflow: hidden;
  font-size: 0.9rem;
}

.action-button::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: radial-gradient(circle, rgba(255,255,255,0.3) 0%, rgba(255,255,255,0) 70%);
  opacity: 0;
  transition: opacity 0.3s ease;
}

.action-button:hover::before {
  opacity: 1;
}

.preview-button {
  background: linear-gradient(135deg, #1a237e, #283593);
  color: white;
}

.email-button {
  background: linear-gradient(135deg, #1a237e, #3949ab);
  color: white;
}

.action-button:hover {
  transform: translateY(-5px) scale(1.1);
  box-shadow: 0 5px 15px rgba(26, 35, 126, 0.3);
}

.pagination {
  display: flex;
  justify-content: center;
  align-items: center;
  margin-top: 25px;
  padding: 10px 0;
  animation: fadeIn 0.8s ease-out forwards;
  animation-delay: 0.3s;
  opacity: 0;
}

.pagination-button {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #1a237e, #283593);
  border: none;
  color: white;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
  box-shadow: 0 3px 8px rgba(26, 35, 126, 0.2);
}

.pagination-button:hover:not(:disabled) {
  transform: translateY(-3px);
  box-shadow: 0 5px 15px rgba(26, 35, 126, 0.3);
}

.pagination-button:disabled {
  background: linear-gradient(135deg, #9fa8da, #c5cae9);
  opacity: 0.7;
  cursor: not-allowed;
  box-shadow: none;
}

.pagination-info {
  margin: 0 15px;
  font-size: 0.95rem;
  color: #1a237e;
  font-weight: 500;
}

/* Modal Styles */
.email-modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(26, 35, 126, 0.6);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  backdrop-filter: blur(5px);
  -webkit-backdrop-filter: blur(5px);
  animation: fadeIn 0.3s ease-out forwards;
}

.email-modal {
  background-color: white;
  border-radius: 12px;
  width: 500px;
  max-width: 90%;
  max-height: 90vh;
  overflow-y: auto;
  box-shadow: 0 10px 30px rgba(26, 35, 126, 0.3);
  animation: modalSlideUp 0.4s cubic-bezier(0.34, 1.56, 0.64, 1) forwards;
  border-top: 5px solid #1a237e;
}

@keyframes modalSlideUp {
  from { opacity: 0; transform: translateY(30px); }
  to { opacity: 1; transform: translateY(0); }
}

@keyframes modalSuccess {
  0% { transform: scale(1); }
  50% { transform: scale(1.05); }
  100% { transform: scale(1); }
}

@keyframes modalShake {
  0% { transform: translateX(0); }
  25% { transform: translateX(-5px); }
  50% { transform: translateX(5px); }
  75% { transform: translateX(-5px); }
  100% { transform: translateX(0); }
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 18px 25px;
  background: linear-gradient(135deg, #1a237e, #283593);
  color: white;
  border-radius: 7px 7px 0 0;
}

.modal-header h3 {
  margin: 0;
  font-size: 1.2rem;
  color: white;
  font-weight: 500;
  letter-spacing: 0.5px;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
}

.close-modal {
  background: rgba(255, 255, 255, 0.2);
  border: none;
  font-size: 1.2rem;
  color: white;
  cursor: pointer;
  width: 30px;
  height: 30px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s ease;
}

.close-modal:hover {
  background: rgba(255, 255, 255, 0.3);
  transform: rotate(90deg);
}

.modal-body {
  padding: 25px;
  background-color: #f8f9fa;
}

.selected-document {
  display: flex;
  align-items: center;
  gap: 15px;
  padding: 15px;
  background-color: white;
  border-radius: 8px;
  margin-bottom: 25px;
  box-shadow: 0 4px 12px rgba(26, 35, 126, 0.1);
  border-left: 4px solid #1a237e;
  transition: all 0.3s ease;
  animation: pulseHighlight 2s infinite;
}

@keyframes pulseHighlight {
  0% { box-shadow: 0 4px 12px rgba(26, 35, 126, 0.1); }
  50% { box-shadow: 0 4px 15px rgba(26, 35, 126, 0.2); }
  100% { box-shadow: 0 4px 12px rgba(26, 35, 126, 0.1); }
}

.document-icon-small {
  width: 42px;
  height: 42px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1rem;
  background: linear-gradient(135deg, #1a237e, #283593);
  color: white;
  box-shadow: 0 3px 8px rgba(26, 35, 126, 0.2);
}

.selected-document-info h4 {
  margin: 0 0 5px 0;
  font-size: 1.05rem;
  color: #1a237e;
  font-weight: 600;
}

.selected-document-info p {
  margin: 0;
  font-size: 0.9rem;
  color: #546e7a;
}

.form-group {
  margin-bottom: 15px;
}

.form-group label {
  display: block;
  margin-bottom: 5px;
  font-size: 0.9rem;
  color: #475569;
  font-weight: 500;
}

.form-input,
.form-textarea {
  width: 100%;
  padding: 10px;
  border: 1px solid #e2e8f0;
  border-radius: 6px;
  font-size: 0.9rem;
  color: #334155;
  background-color: #f8fafc;
  transition: all 0.2s ease;
}

.form-input:focus,
.form-textarea:focus {
  border-color: #3b82f6;
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.2);
  outline: none;
}

/* Style pour le message de succès d'envoi d'email */
.email-success-message {
  display: flex;
  align-items: center;
  margin-top: 15px;
  padding: 10px 15px;
  background-color: rgba(22, 163, 74, 0.1);
  border-left: 4px solid #16a34a;
  border-radius: 4px;
  color: #166534;
  animation: fadeIn 0.5s ease-out forwards;
}

.email-success-message i {
  font-size: 1.2rem;
  margin-right: 10px;
  color: #16a34a;
}

.email-success-message span {
  font-weight: 500;
}

.checkbox-group {
  display: flex;
  align-items: center;
  gap: 10px;
}

.checkbox-group input {
  width: auto;
}

.checkbox-group label {
  margin: 0;
  display: inline;
}

.modal-footer {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  padding: 15px 20px;
  border-top: 1px solid #e2e8f0;
}

.cancel-button,
.send-button {
  padding: 10px 20px;
  border-radius: 8px;
  font-size: 0.95rem;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
  display: flex;
  align-items: center;
  justify-content: center;
  min-width: 120px;
}

.cancel-button {
  background-color: #f5f5f5;
  color: #546e7a;
  border: 2px solid #e0e0e0;
  position: relative;
  overflow: hidden;
}

.cancel-button::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: linear-gradient(135deg, rgba(0,0,0,0.05) 0%, rgba(0,0,0,0) 100%);
  opacity: 0;
  transition: opacity 0.3s ease;
}

.cancel-button:hover {
  transform: translateY(-3px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  border-color: #d0d0d0;
}

.cancel-button:hover::before {
  opacity: 1;
}

.send-button {
  background: linear-gradient(135deg, #1a237e, #283593);
  color: white;
  border: none;
  box-shadow: 0 4px 12px rgba(26, 35, 126, 0.2);
  position: relative;
  overflow: hidden;
}

.send-button i {
  margin-right: 8px;
  transition: all 0.3s ease;
}

.send-button:hover:not(:disabled) {
  transform: translateY(-3px);
  box-shadow: 0 6px 15px rgba(26, 35, 126, 0.3);
}

.send-button:hover:not(:disabled) i {
  transform: translateX(3px);
}

.send-button:disabled {
  background: linear-gradient(135deg, #9fa8da, #c5cae9);
  cursor: not-allowed;
  box-shadow: none;
}
</style>