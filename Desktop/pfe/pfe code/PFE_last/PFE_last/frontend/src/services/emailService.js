import api from './api';

/**
 * Service unifié pour l'envoi d'emails
 * Utilisé pour les emails de documents, vérification de compte et réinitialisation de mot de passe
 */
export default {
  /**
   * Envoie un email avec document en pièce jointe (facture ou devis)
   * @param {Object} data - Données de l'email
   * @param {String} data.documentId - ID du document
   * @param {String} data.documentType - Type de document ('facture' ou 'devis')
   * @param {String} data.to - Adresse email du destinataire
   * @param {String} data.subject - Objet de l'email
   * @param {String} data.message - Corps du message
   * @param {Boolean} data.attachPdf - Joindre le PDF en pièce jointe
   * @param {String} data.filePath - Chemin du fichier PDF à joindre (depuis la table document)
   * @param {String} data.pdfUrl - URL du PDF (fallback si filePath n'est pas disponible)
   * @returns {Promise} - Promesse contenant le statut de l'envoi
   */
  async sendDocumentEmail(data) {
    try {
      // Vérifier les données obligatoires
      if (!data.documentId || !data.documentType || !data.to) {
        throw new Error('Informations manquantes pour l\'envoi d\'email');
      }

      // Déterminer l'endpoint en fonction du type de document
      let endpoint;
      if (data.documentType === 'facture') {
        endpoint = `/api/protected/factures/${data.documentId}/email`;
      } else if (data.documentType === 'devis') {
        endpoint = `/api/protected/devis/${data.documentId}/email`;
      } else {
        endpoint = `/api/protected/documents/${data.documentId}/email`;
      }

      // Préparer les données à envoyer
      const dataToSend = {
        to: data.to,
        subject: data.subject || `${data.documentType.charAt(0).toUpperCase() + data.documentType.slice(1)} #${data.documentId}`,
        message: data.message || `Veuillez trouver ci-joint votre ${data.documentType}.`,
        attachPdf: data.attachPdf !== undefined ? data.attachPdf : true,
        sendCopy: data.sendCopy || false
      };
      
      // Ajouter le chemin du fichier PDF s'il est disponible
      if (data.filePath) {
        dataToSend.filePath = data.filePath;
        console.log('Chemin du fichier PDF à joindre:', data.filePath);
      } else if (data.pdfUrl) {
        dataToSend.pdfUrl = data.pdfUrl;
        console.log('URL du PDF à joindre (fallback):', data.pdfUrl);
      }

      console.log(`Envoi d'email pour ${data.documentType} #${data.documentId}`, dataToSend);
      console.log('Endpoint utilisé:', endpoint);

      // Vérifier le token d'authentification
      const token = localStorage.getItem('token');
      console.log('Token disponible:', !!token);

      // Envoyer la requête
      const response = await api.post(endpoint, dataToSend);
      return response.data;
    } catch (error) {
      console.error('Erreur lors de l\'envoi de l\'email:', error);
      console.error('Message d\'erreur:', error.message);
      if (error.response) {
        console.error('Réponse du serveur:', error.response.status, error.response.data);
      }
      throw error;
    }
  },

  /**
   * Récupère le transporteur d'email configuré sur le backend (pour information)
   * @returns {Object} - Informations sur le transporteur d'email
   */
  getEmailInfo() {
    return {
      fromEmail: 'quikdoc8@gmail.com',
      emailService: 'Gmail',
      description: 'Ce service utilise le même compte email pour toutes les communications: vérification de compte, réinitialisation de mot de passe et envoi de documents.'
    };
  }
};
