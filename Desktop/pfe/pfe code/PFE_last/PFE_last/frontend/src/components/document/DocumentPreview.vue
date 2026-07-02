<template>
  <div class="document-preview-container">
    <div v-if="loading" class="loading-container">
      <div class="loading-spinner"></div>
      <p>Chargement du document...</p>
    </div>

    <div v-else-if="!document" class="document-not-found">
      <i class="fas fa-exclamation-triangle not-found-icon"></i>
      <h2>Document introuvable</h2>
      <p>Le document demandé n'existe pas ou a été supprimé.</p>
      <button @click="goBack" class="back-button">
        <i class="fas fa-arrow-left"></i> Retour à la liste
      </button>
    </div>

    <div v-else class="document-container">
      <div class="document-header">
        <div class="header-left">
          <button @click="goBack" class="back-button">
            <i class="fas fa-arrow-left"></i> Retour
          </button>
          <h2 class="document-title">{{ document.name }}</h2>
        </div>
        <div class="document-actions">
          <button @click="downloadDocument" class="action-button download-button">
            <i class="fas fa-download"></i> Télécharger
          </button>
          <button @click="emailDocument" class="action-button email-button">
            <i class="fas fa-envelope"></i> Envoyer par email
          </button>
          <button @click="printDocument" class="action-button print-button">
            <i class="fas fa-print"></i> Imprimer
          </button>
        </div>
      </div>

      <div class="document-content">
        <div class="document-sidebar">
          <div class="document-info-card">
            <h3 class="info-card-title">Informations</h3>
            <div class="info-item">
              <span class="info-label">Type</span>
              <span class="info-value document-type" :class="`type-${document.type}`">
                <i :class="getDocumentIcon(document.type)"></i>
                {{ getDocumentTypeName(document.type) }}
              </span>
            </div>
            <div class="info-item">
              <span class="info-label">Date</span>
              <span class="info-value">{{ formatDate(document.date) }}</span>
            </div>
            <div class="info-item">
              <span class="info-label">Client</span>
              <span class="info-value">{{ document.client.name }}</span>
            </div>
            <div class="info-item">
              <span class="info-label">Statut</span>
              <span class="info-value status-badge" :class="`status-${document.status}`">
                {{ getStatusName(document.status) }}
              </span>
            </div>
            <div class="info-item" v-if="document.amount !== undefined">
              <span class="info-label">Montant</span>
              <span class="info-value amount">{{ formatAmount(document.amount) }}</span>
            </div>
          </div>

          <div class="document-history-card">
            <h3 class="info-card-title">Historique</h3>
            <div class="history-timeline">
              <div v-for="(event, index) in document.history" :key="index" class="history-item">
                <div class="history-icon" :class="getHistoryIconClass(event.type)">
                  <i :class="getHistoryIcon(event.type)"></i>
                </div>
                <div class="history-content">
                  <div class="history-title">{{ getHistoryTitle(event) }}</div>
                  <div class="history-date">{{ formatDateTime(event.date) }}</div>
                  <div v-if="event.comment" class="history-comment">{{ event.comment }}</div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div class="document-preview">
          <div class="preview-toolbar">
            <div class="zoom-controls">
              <button @click="zoomOut" class="zoom-button" :disabled="zoomLevel <= 0.5">
                <i class="fas fa-search-minus"></i>
              </button>
              <span class="zoom-level">{{ Math.round(zoomLevel * 100) }}%</span>
              <button @click="zoomIn" class="zoom-button" :disabled="zoomLevel >= 2">
                <i class="fas fa-search-plus"></i>
              </button>
            </div>
            <div class="page-controls">
              <button @click="prevPage" class="page-button" :disabled="currentPage <= 1">
                <i class="fas fa-chevron-left"></i>
              </button>
              <span class="page-info">{{ currentPage }} / {{ totalPages }}</span>
              <button @click="nextPage" class="page-button" :disabled="currentPage >= totalPages">
                <i class="fas fa-chevron-right"></i>
              </button>
            </div>
          </div>

          <div class="preview-content" :style="{ transform: `scale(${zoomLevel})` }">
            <!-- PDF Direct Viewer using object tag with enhanced security -->
            <div class="pdf-preview">
              <embed 
                :src="getPdfViewUrl()" 
                type="application/pdf"
                class="pdf-iframe" 
                width="100%" 
                height="100%"
                pluginspage="http://www.adobe.com/products/acrobat/readstep2.html"
              />
            </div>
          </div>
        </div>
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
          <div class="form-group">
            <label>Destinataire</label>
            <input type="email" v-model="emailForm.to" placeholder="Adresse email du destinataire" />
          </div>
          <div class="form-group">
            <label>Objet</label>
            <input type="text" v-model="emailForm.subject" placeholder="Objet de l'email" />
          </div>
          <div class="form-group">
            <label>Message</label>
            <textarea v-model="emailForm.message" placeholder="Votre message" rows="5"></textarea>
          </div>
          <div class="form-group checkbox-group">
            <input type="checkbox" id="sendCopy" v-model="emailForm.sendCopy" />
            <label for="sendCopy">M'envoyer une copie</label>
          </div>
          <!-- Notification gérée par le service de notification -->
        </div>
        <div class="modal-footer">
          <button @click="closeEmailModal" class="cancel-button">
            Annuler
          </button>
          <button @click="sendEmail" class="send-button" :disabled="isSending">
            <i class="fas fa-paper-plane"></i> 
            {{ isSending ? 'Envoi en cours...' : 'Envoyer' }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import documentService from '@/services/documentService';
import notificationService from '@/services/notificationService';

// Router and route
const route = useRoute();
const router = useRouter();

// State
const loading = ref(true);
const document = ref(null);
const zoomLevel = ref(1);
const currentPage = ref(1);
const totalPages = ref(1);
const showEmailModal = ref(false);
const isSending = ref(false);

// Email form
const emailForm = ref({
  to: '',
  subject: '',
  message: '',
  sendCopy: false
});

// État pour le message de succès d'envoi d'email
const emailSent = ref(false);

// Fetch document data
onMounted(async () => {
  try {
    const documentId = route.query.id;
    if (!documentId) {
      loading.value = false;
      return;
    }

    // Récupérer les données du document via le service
    const response = await documentService.getDocumentById(documentId);
    document.value = response.data.document;
    
    // Récupérer l'aperçu du document
    const previewResponse = await documentService.getDocumentPreview(documentId, 1);
    totalPages.value = previewResponse.data.totalPages;
    previewUrl.value = previewResponse.data.previewUrl;
    
    // Pre-fill email form
    emailForm.value.subject = `${getDocumentTypeName(document.value.type)} - ${document.value.name}`;
    emailForm.value.message = `Bonjour,\n\nVeuillez trouver ci-joint ${getDocumentTypeName(document.value.type).toLowerCase()} ${document.value.name}.\n\nCordialement,\nL'équipe QuikDoc`;
    
    loading.value = false;
  } catch (error) {
    console.error('Erreur lors du chargement du document:', error);
    loading.value = false;
  }
});

// Ces fonctions ne sont plus nécessaires car nous utilisons le service documentService

// Navigation methods
const goBack = () => {
  router.back();
};

// Document action methods
const downloadDocument = async () => {
  try {
    const response = await documentService.downloadDocument(document.value.id);
    // Afficher une notification élégante avec le système de notification moderne
    notificationService.show({
      type: 'success',
      title: 'Téléchargement réussi',
      message: response.message || 'Document téléchargé avec succès',
      icon: 'download',
      color: '#16a34a', // Couleur verte pour le succès
      duration: 5000,
      position: 'top-center'
    });
  } catch (error) {
    console.error('Erreur lors du téléchargement:', error);
    notificationService.show({
      type: 'error',
      title: 'Échec du téléchargement',
      message: 'Erreur lors du téléchargement du document',
      icon: 'exclamation-circle',
      color: '#ef4444',
      duration: 5000,
      position: 'top-center'
    });
  }
};

const emailDocument = () => {
  showEmailModal.value = true;
};

const printDocument = () => {
  // Ouvrir la boîte de dialogue d'impression du navigateur
  window.print();
};

const exportToPdf = async () => {
  try {
    const response = await documentService.exportDocumentToPdf(document.value.id);
    // Afficher une notification élégante avec le système de notification moderne
    notificationService.show({
      type: 'success',
      title: 'Exportation réussie',
      message: response.message || 'Document exporté avec succès',
      icon: 'file-export',
      color: '#16a34a', // Couleur verte pour le succès
      duration: 5000,
      position: 'top-center'
    });
  } catch (error) {
    console.error('Erreur lors de l\'exportation en PDF:', error);
    notificationService.show({
      type: 'error',
      title: 'Échec de l\'exportation',
      message: 'Erreur lors de l\'exportation en PDF',
      icon: 'exclamation-circle',
      color: '#ef4444',
      duration: 5000,
      position: 'top-center'
    });
  }
};

// Email modal methods
const closeEmailModal = () => {
  showEmailModal.value = false;
  // Réinitialiser l'état du message de succès
  emailSent.value = false;
};

const sendEmail = async () => {
  try {
    isSending.value = true;
    
    // Appel au service pour envoyer l'email
    const response = await documentService.sendDocumentByEmail(document.value.id, emailForm.value);
    
    // Afficher une notification moderne de succès
    notificationService.show({
      type: 'success',
      title: 'Email envoyé',
      message: `Document envoyé avec succès à ${emailForm.value.to}`,
      icon: 'paper-plane',
      color: '#16a34a', // Couleur verte pour le succès
      duration: 5000,
      position: 'top-center'
    });
    
    // Activer le message de succès dans la modal
    emailSent.value = true;
    
    // Ajouter un événement à l'historique du document
    if (document.value.history) {
      document.value.history.push({
        type: 'sent',
        date: new Date().toISOString(),
        user: 'Utilisateur actuel',
        comment: `Envoyé par email à ${emailForm.value.to}`
      });
    }
    
    // Attendre quelques secondes avant de fermer la modal
    setTimeout(() => {
      showEmailModal.value = false;
      isSending.value = false;
      // Réinitialiser le message après la fermeture
      setTimeout(() => {
        emailSent.value = false;
      }, 300);
    }, 2000);
  } catch (error) {
    console.error('Erreur lors de l\'envoi de l\'email:', error);
    notificationService.show({
      type: 'error',
      title: 'Échec de l\'envoi',
      message: 'Erreur lors de l\'envoi de l\'email',
      icon: 'exclamation-circle',
      color: '#ef4444',
      duration: 5000,
      position: 'top-center'
    });
    isSending.value = false;
  }
};

// Preview control methods
const zoomIn = () => {
  if (zoomLevel.value < 2) {
    zoomLevel.value += 0.1;
  }
};

const zoomOut = () => {
  if (zoomLevel.value > 0.5) {
    zoomLevel.value -= 0.1;
  }
};

const nextPage = async () => {
  if (currentPage.value < totalPages.value) {
    currentPage.value++;
    await updatePreviewUrl();
  }
};

const prevPage = async () => {
  if (currentPage.value > 1) {
    currentPage.value--;
    await updatePreviewUrl();
  }
};

// Utility methods
const formatDate = (dateString) => {
  const options = { year: 'numeric', month: 'long', day: 'numeric' };
  return new Date(dateString).toLocaleDateString('fr-FR', options);
};

const formatDateTime = (dateTimeString) => {
  const options = { year: 'numeric', month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit' };
  return new Date(dateTimeString).toLocaleDateString('fr-FR', options);
};

const formatAmount = (amount) => {
  return new Intl.NumberFormat('fr-FR', { style: 'currency', currency: 'EUR' }).format(amount);
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

const getHistoryIcon = (type) => {
  const icons = {
    'created': 'fas fa-plus-circle',
    'modified': 'fas fa-edit',
    'sent': 'fas fa-paper-plane',
    'viewed': 'fas fa-eye',
    'paid': 'fas fa-check-circle'
  };
  
  return icons[type] || 'fas fa-history';
};

const getHistoryIconClass = (type) => {
  return `history-icon-${type}`;
};

const getHistoryTitle = (event) => {
  const titles = {
    'created': `Créé par ${event.user}`,
    'modified': `Modifié par ${event.user}`,
    'sent': `Envoyé par ${event.user}`,
    'viewed': `Consulté par ${event.user}`,
    'paid': `Payé par ${event.user}`
  };
  
  return titles[event.type] || event.type;
};

// URL de l'aperçu du document
const previewUrl = ref('');

// Mettre à jour l'URL de l'aperçu lorsque la page change
const updatePreviewUrl = async () => {
  try {
    const response = await documentService.getDocumentPreview(document.value.id, currentPage.value);
    previewUrl.value = response.data.previewUrl;
  } catch (error) {
    console.error('Erreur lors de la récupération de l\'aperçu:', error);
  }
};

// Observer les changements de page pour mettre à jour l'aperçu
const getPdfViewUrl = () => {
  if (!document.value || !document.value.id) {
    return '';
  }
  
  // Utiliser le service documentService pour générer l'URL avec authentification
  const token = localStorage.getItem('token');
  // Ajouter un timestamp pour éviter les problèmes de cache
  const timestamp = new Date().getTime();
  
  // Utiliser l'endpoint view au lieu de download pour un affichage en ligne
  return `${import.meta.env.VITE_API_URL || ''}/api/protected/documents/${document.value.id}/view?token=${token}&t=${timestamp}`;
};
</script>

<style scoped>
.document-preview-container {
  height: 100%;
  background-color: #f9fafb;
  border-radius: 8px;
  overflow: hidden;
  display: flex;
  flex-direction: column;
}

.loading-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100%;
  padding: 40px;
  color: #64748b;
}

.loading-spinner {
  width: 40px;
  height: 40px;
  border: 3px solid #e2e8f0;
  border-top: 3px solid #3b82f6;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin-bottom: 15px;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.document-not-found {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100%;
  padding: 40px;
  text-align: center;
}

.not-found-icon {
  font-size: 3rem;
  color: #f59e0b;
  margin-bottom: 20px;
}

.document-container {
  display: flex;
  flex-direction: column;
  height: 100%;
}

.document-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px 20px;
  background-color: white;
  border-bottom: 1px solid #e2e8f0;
}

.header-left {
  display: flex;
  align-items: center;
  gap: 15px;
}

.back-button {
  display: flex;
  align-items: center;
  gap: 8px;
  background-color: #f1f5f9;
  border: 1px solid #e2e8f0;
  border-radius: 6px;
  padding: 8px 12px;
  font-size: 0.9rem;
  color: #334155;
  cursor: pointer;
  transition: all 0.2s ease;
}

.back-button:hover {
  background-color: #e2e8f0;
}

.document-title {
  font-size: 1.3rem;
  color: #1e293b;
  margin: 0;
}

.document-actions {
  display: flex;
  gap: 10px;
}

.action-button {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 12px;
  border-radius: 6px;
  font-size: 0.9rem;
  cursor: pointer;
  transition: all 0.2s ease;
}

.download-button {
  background-color: #e0f2fe;
  border: 1px solid #bae6fd;
  color: #0369a1;
}

.download-button:hover {
  background-color: #bae6fd;
}

.email-button {
  background-color: #f0fdf4;
  border: 1px solid #dcfce7;
  color: #166534;
}

.email-button:hover {
  background-color: #dcfce7;
}

.print-button {
  background-color: #f1f5f9;
  border: 1px solid #e2e8f0;
  color: #334155;
}

.print-button:hover {
  background-color: #e2e8f0;
}

.document-content {
  display: flex;
  flex: 1;
  overflow: hidden;
}

.document-sidebar {
  width: 300px;
  background-color: white;
  border-right: 1px solid #e2e8f0;
  padding: 20px;
  overflow-y: auto;
}

.document-info-card,
.document-history-card {
  background-color: #f8fafc;
  border-radius: 8px;
  padding: 15px;
  margin-bottom: 20px;
}

.info-card-title {
  font-size: 1rem;
  color: #334155;
  margin-top: 0;
  margin-bottom: 15px;
  padding-bottom: 10px;
  border-bottom: 1px solid #e2e8f0;
}

.info-item {
  display: flex;
  justify-content: space-between;
  margin-bottom: 10px;
}

.info-item:last-child {
  margin-bottom: 0;
}

.info-label {
  font-size: 0.9rem;
  color: #64748b;
}

.info-value {
  font-size: 0.9rem;
  color: #334155;
  font-weight: 500;
}

.document-type {
  display: flex;
  align-items: center;
  gap: 5px;
}

.type-facture {
  color: #0369a1;
}

.type-devis {
  color: #7c3aed;
}

.type-bon_livraison {
  color: #f59e0b;
}

.type-contrat {
  color: #10b981;
}

.status-badge {
  display: inline-block;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 0.8rem;
  font-weight: 500;
}

.status-draft {
  background-color: #f1f5f9;
  color: #475569;
}

.status-sent {
  background-color: #e0f2fe;
  color: #0369a1;
}

.status-paid {
  background-color: #dcfce7;
  color: #166534;
}

.status-overdue {
  background-color: #fee2e2;
  color: #b91c1c;
}

.amount {
  font-weight: 600;
  color: #1e293b;
}

.history-timeline {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.history-item {
  display: flex;
  gap: 10px;
}

.history-icon {
  width: 30px;
  height: 30px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.history-icon-created {
  background-color: #dcfce7;
  color: #166534;
}

.history-icon-modified {
  background-color: #e0f2fe;
  color: #0369a1;
}

.history-icon-sent {
  background-color: #f0fdf4;
  color: #166534;
}

.history-icon-viewed {
  background-color: #f1f5f9;
  color: #334155;
}

.history-icon-paid {
  background-color: #dcfce7;
  color: #166534;
}

.history-content {
  flex: 1;
}

.history-title {
  font-size: 0.9rem;
  color: #334155;
  font-weight: 500;
}

.history-date {
  font-size: 0.8rem;
  color: #64748b;
  margin-top: 2px;
}

.history-comment {
  font-size: 0.85rem;
  color: #475569;
  margin-top: 5px;
  padding: 5px 10px;
  background-color: #f8fafc;
  border-left: 3px solid #e2e8f0;
  border-radius: 0 4px 4px 0;
}

.document-preview {
  flex: 1;
  display: flex;
  flex-direction: column;
  background-color: #f1f5f9;
  overflow: hidden;
}

.preview-toolbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 20px;
  background-color: white;
  border-bottom: 1px solid #e2e8f0;
}

.zoom-controls,
.page-controls {
  display: flex;
  align-items: center;
  gap: 10px;
}

.zoom-button,
.page-button {
  width: 30px;
  height: 30px;
  border-radius: 4px;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #f1f5f9;
  border: 1px solid #e2e8f0;
  color: #334155;
  cursor: pointer;
  transition: all 0.2s ease;
}

.zoom-button:hover:not(:disabled),
.page-button:hover:not(:disabled) {
  background-color: #e2e8f0;
}

.zoom-button:disabled,
.page-button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.zoom-level,
.page-info {
  font-size: 0.9rem;
  color: #64748b;
}

.preview-content {
  flex: 1;
  overflow: auto;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 20px;
  transform-origin: center center;
}

.pdf-preview {
  background-color: white;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  max-width: 100%;
  height: 800px;
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.pdf-iframe {
  border: none;
  width: 100%;
  height: 100%;
  min-height: 700px;
}

/* Email Modal Styles */
.email-modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.email-modal {
  background-color: white;
  border-radius: 8px;
  width: 500px;
  max-width: 90%;
  max-height: 90vh;
  overflow-y: auto;
  box-shadow: 0 10px 15px rgba(0, 0, 0, 0.1);
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px 20px;
  border-bottom: 1px solid #e2e8f0;
}

.modal-header h3 {
  margin: 0;
  font-size: 1.2rem;
  color: #1e293b;
}

.close-modal {
  background: none;
  border: none;
  color: #64748b;
  font-size: 1.2rem;
  cursor: pointer;
}

.modal-body {
  padding: 20px;
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

.form-group input,
.form-group textarea {
  width: 100%;
  padding: 10px;
  border: 1px solid #e2e8f0;
  border-radius: 6px;
  font-size: 0.9rem;
  color: #334155;
  background-color: #f8fafc;
  transition: all 0.2s ease;
}

.form-group input:focus,
.form-group textarea:focus {
  border-color: #3b82f6;
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.2);
  outline: none;
}

.checkbox-group {
  display: flex;
  align-items: center;
  gap: 10px;
}

.checkbox-group input {
  width: auto;
}

.email-success-message {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-top: 15px;
  padding: 10px 15px;
  background-color: #dcfce7;
  border-left: 3px solid #16a34a;
  border-radius: 4px;
  color: #166534;
  font-size: 0.9rem;
  animation: fadeIn 0.3s ease-in-out;
}

.email-success-message i {
  color: #16a34a;
  font-size: 1.1rem;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(-10px); }
  to { opacity: 1; transform: translateY(0); }
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
  padding: 8px 16px;
  border-radius: 6px;
  font-size: 0.9rem;
  font-weight: 500;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 8px;
  transition: all 0.2s ease;
}

.cancel-button {
  background-color: #f1f5f9;
  border: 1px solid #e2e8f0;
  color: #64748b;
}

.cancel-button:hover {
  background-color: #e2e8f0;
}

.send-button {
  background-color: #10b981;
  border: 1px solid #059669;
  color: white;
}

.send-button:hover:not(:disabled) {
  background-color: #059669;
}

.send-button:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

@media print {
  .document-header,
  .document-sidebar,
  .preview-toolbar {
    display: none;
  }
  
  .document-preview {
    width: 100%;
    height: 100%;
  }
  
  .preview-content {
    transform: none !important;
  }
  
  .document-content {
    flex-direction: column;
  }
  
  .pdf-preview {
    box-shadow: none;
  }
}
</style>