import api from './api';
import { allDocuments, invoices, quotes } from './mockDocumentData';
import pdfService from './pdfService';

/**
 * Service pour la gestion des documents
 */
export default {
  /**
   * Récupère la liste des documents avec filtres optionnels
   * @param {Object} filters - Filtres à appliquer (type, statut, date, client, etc.)
   * @returns {Promise} - Promesse contenant les documents
   */
  async getDocuments(filters = {}) {
    try {
      // Dans une application réelle, cette requête serait envoyée au backend
      // return await api.get('/documents', { params: filters });
      
      // Pour la démo, on simule une réponse
      await new Promise(resolve => setTimeout(resolve, 500));
      
      // Utiliser nos données statiques
      let documents = [...allDocuments];
      
      // Filtrer par type (facture ou devis)
      if (filters.type === 'invoice') {
        documents = [...invoices];
      } else if (filters.type === 'quote') {
        documents = [...quotes];
      }
      
      // Appliquer les filtres
      let filteredDocuments = [...documents];
      
      if (filters.status) {
        filteredDocuments = filteredDocuments.filter(doc => doc.status === filters.status);
      }
      
      if (filters.client) {
        filteredDocuments = filteredDocuments.filter(doc => 
          doc.client.name.toLowerCase().includes(filters.client.toLowerCase())
        );
      }
      
      if (filters.dateFrom) {
        const dateFrom = new Date(filters.dateFrom);
        filteredDocuments = filteredDocuments.filter(doc => new Date(doc.date) >= dateFrom);
      }
      
      if (filters.dateTo) {
        const dateTo = new Date(filters.dateTo);
        filteredDocuments = filteredDocuments.filter(doc => new Date(doc.date) <= dateTo);
      }
      
      if (filters.search) {
        const search = filters.search.toLowerCase();
        filteredDocuments = filteredDocuments.filter(doc => 
          doc.name.toLowerCase().includes(search) ||
          doc.client.name.toLowerCase().includes(search)
        );
      }
      
      // Ajouter l'URL du PDF pour chaque document
      filteredDocuments = filteredDocuments.map(doc => ({
        ...doc,
        pdfUrl: pdfService.getStaticPdfUrl(doc)
      }))
      
      return { data: { documents: filteredDocuments } };
    } catch (error) {
      console.error('Erreur lors de la récupération des documents:', error);
      throw error;
    }
  },
  
  /**
 * Récupère un document par son ID de remplissage
 * @param {Number} id - ID de remplissage du document à récupérer
 * @returns {Promise<Object>} - Promesse résolue avec les données du document
 */
async getDocumentById(id) {
  try {
    // Requête au backend pour récupérer le document par son remplissage_id
    console.log(`Récupération du document avec remplissage_id: ${id}`);
    
    // Rechercher d'abord dans la table document pour trouver l'ID du document correspondant au remplissage_id
    const response = await api.get(`/api/protected/documents/by-remplissage/${id}`);
    
    if (!response.data || !response.data.success) {
      throw new Error(`Document avec le remplissage_id ${id} non trouvé`);
    }
    
    return response;
  } catch (error) {
    console.error(`Erreur lors de la récupération du document ${id}:`, error);
    throw error;
  }
},
  
  /**
   * Télécharge un document
   * @param {Number} id - ID du document
   * @returns {Promise} - Promesse contenant l'URL de téléchargement
   */
  async downloadDocument(id) {
    try {
      console.log(`Téléchargement du document ${id} en cours...`);
      
      // Obtenir le token d'authentification
      const token = localStorage.getItem('token');
      if (!token) {
        throw new Error('Vous devez être connecté pour télécharger des documents');
      }
      
      // Créer l'URL de téléchargement avec le token en paramètre de requête
      const downloadUrl = `${api.defaults.baseURL}/api/protected/documents/${id}/download?token=${token}`;
      console.log(`URL de téléchargement générée: ${downloadUrl}`);
      
      // Utiliser window.open pour déclencher le téléchargement direct
      // Cette méthode évite les problèmes de bloqueurs et de CORS
      window.open(downloadUrl, '_blank');
      
      return { success: true, message: 'Téléchargement initié avec succès' };
    } catch (error) {
      console.error(`Erreur lors du téléchargement du document ${id}:`, error);
      throw error;
    }
  },
  
  /**
   * Prévisualise un document
   * @param {Number} id - ID du document
   * @returns {Promise} - Promesse contenant l'URL de prévisualisation
   */
  async previewDocument(id) {
    try {
      console.log(`Prévisualisation du document ${id} en cours...`);
      
      // Obtenir le document
      const response = await this.getDocumentById(id);
      const document = response.data.document;
      
      if (!document || !document.pdfUrl) {
        throw new Error(`Document avec l'ID ${id} non trouvé ou sans PDF`);
      }
      
      // Ouvrir le PDF dans un nouvel onglet pour prévisualisation
      window.open(document.pdfUrl, '_blank');
      
      return { success: true, message: 'Prévisualisation initiée avec succès' };
    } catch (error) {
      console.error(`Erreur lors de la prévisualisation du document ${id}:`, error);
      throw error;
    }
  },
  
  /**
   * Récupère l'URL du PDF pour un document
   * @param {Object} document - Le document
   * @returns {String} - URL du PDF
   */
  getPdfUrl(document) {
    try {
      // Obtenir le token d'authentification
      const token = localStorage.getItem('token');
      if (!token) {
        console.warn('Token d\'authentification manquant pour l\'aperçu PDF');
        return '';
      }
      
      // Créer une URL pour l'aperçu qui inclut le token d'authentification
      // Utiliser l'ID du document pour construire l'URL
      if (document && document.id) {
        const baseUrl = api.defaults.baseURL || '';
        const docId = typeof document === 'object' ? document.id : document;
        const url = `${baseUrl}/api/protected/documents/${docId}/download?token=${token}`;
        console.log('PDF URL générée:', url);
        return url;
      }
      
      console.warn('Document invalide pour générer l\'URL du PDF');
      return '';
    } catch (error) {
      console.error('Erreur lors de la génération de l\'URL du PDF:', error);
      return '';
    }
  },
  
  /**
   * Récupère l'URL du PDF pour la visualisation (pas téléchargement)
   * @param {Object|Number} document - Le document ou son ID
   * @returns {String} - URL du PDF pour visualisation
   */
  getPdfViewUrl(document) {
    try {
      // Obtenir le token d'authentification
      const token = localStorage.getItem('token');
      if (!token) {
        console.warn('Token d\'authentification manquant pour l\'aperçu PDF');
        return '';
      }
      
      // Récupérer l'ID du document (que ce soit un objet ou directement un ID)
      const docId = typeof document === 'object' ? document.id : document;
      
      if (!docId) {
        console.warn('ID de document manquant pour générer l\'URL de visualisation');
        return '';
      }
      
      // Utiliser le nouvel endpoint spécifique pour la visualisation
      const baseUrl = api.defaults.baseURL || '';
      const url = `${baseUrl}/api/protected/documents/${docId}/view?token=${token}`;
      console.log('PDF View URL générée:', url);
      return url;
    } catch (error) {
      console.error('Erreur lors de la génération de l\'URL de visualisation PDF:', error);
      return '';
    }
  },
  
  /**
   * Envoie un document par email
   * @param {Number} id - ID du document
   * @param {Object} emailData - Données de l'email (destinataire, objet, message, etc.)
   * @param {String} type - Type de document ('facture' ou 'devis')
   * @returns {Promise} - Promesse contenant le statut de l'envoi
   */
  async sendDocumentByEmail(id, emailData, type = 'facture') {
    try {
      // Préparer les données à envoyer
      const dataToSend = {
        to: emailData.to,
        subject: emailData.subject,
        message: emailData.message,
        attachPdf: emailData.includeAttachment !== undefined ? emailData.includeAttachment : true
      };
      
      // Déterminer l'endpoint en fonction du type de document
      let endpoint;
      if (type === 'facture') {
        endpoint = `/api/protected/factures/${id}/email`;
      } else if (type === 'devis') {
        endpoint = `/api/protected/devis/${id}/email`;
      } else {
        // Fallback à l'endpoint facture si le type n'est pas reconnu
        endpoint = `/api/protected/factures/${id}/email`;
      }
      
      console.log(`Envoi d'email pour document (ID: ${id}, Type: ${type})`);
      console.log('Endpoint utilisé:', endpoint);
      console.log('Données envoyées:', dataToSend);
      
      // Vérifier le token d'authentification
      const token = localStorage.getItem('token');
      console.log('Token disponible:', !!token);
      
      // Envoyer la requête au backend
      const response = await api.post(endpoint, dataToSend);
      console.log('Réponse reçue:', response.data);
      return response.data;
    } catch (error) {
      console.error(`Erreur lors de l'envoi par email du document ${id}:`, error);
      if (error.response) {
        console.error('Détails de l\'erreur:', {
          status: error.response.status,
          statusText: error.response.statusText,
          data: error.response.data
        });
      } else {
        console.error('Message d\'erreur:', error.message);
      }
      throw error;
    }
  },
  
  /**
   * Envoie un email dans un format standardisé qui peut être utilisé pour différents types d'emails
   * @param {Object} emailData - Données de l'email standardisées
   * @returns {Promise} - Promesse contenant le statut de l'envoi
   */
  async sendStandardEmail(emailData) {
    try {
      // Obtenir le token d'authentification
      const token = localStorage.getItem('token');
      if (!token) {
        throw new Error('Vous devez être connecté pour envoyer des emails');
      }
      
      // Vérifier que les données requises sont présentes
      if (!emailData.recipient || !emailData.recipient.email) {
        throw new Error('Destinataire manquant pour l\'envoi d\'email');
      }
      
      if (!emailData.subject) {
        throw new Error('Sujet manquant pour l\'envoi d\'email');
      }
      
      // Déterminer l'endpoint en fonction du type d'email
      let endpoint = '/api/protected/email/send';
      
      // Si c'est un email de document, on utilise l'endpoint spécifique
      if (emailData.emailType === 'document_share' && emailData.metadata && emailData.metadata.documentId) {
        // On peut utiliser l'endpoint spécifique au type de document
        if (emailData.metadata.documentType === 'facture') {
          endpoint = `/api/protected/factures/${emailData.metadata.documentId}/email`;
        } else if (emailData.metadata.documentType === 'devis') {
          endpoint = `/api/protected/devis/${emailData.metadata.documentId}/email`;
        } else {
          // Pour les autres types, on utilise l'endpoint générique de documents
          endpoint = `/api/protected/documents/${emailData.metadata.documentId}/email`;
        }
      }
      
      // Préparer les données à envoyer au format attendu par le backend
      const dataToSend = {
        to: emailData.recipient.email,
        subject: emailData.subject,
        message: emailData.message,
        emailType: emailData.emailType
      };
      
      // Ajouter les metadonnées spécifiques si nécessaire
      if (emailData.metadata) {
        if (emailData.metadata.includeAttachment !== undefined) {
          dataToSend.attachPdf = emailData.metadata.includeAttachment;
        }
        
        if (emailData.metadata.sendCopy !== undefined) {
          dataToSend.sendCopy = emailData.metadata.sendCopy;
        }
        
        // Ajouter d'autres métadonnées si nécessaire
        dataToSend.metadata = emailData.metadata;
      }
      
      console.log('Envoi d\'email standardisé:', endpoint, dataToSend);
      
      // Envoyer la requête au backend
      const response = await api.post(endpoint, dataToSend);
      return response.data;
    } catch (error) {
      console.error(`Erreur lors de l'envoi d'email standardisé:`, error);
      throw error;
    }
  },
  
  /**
   * Génère un aperçu du document
   * @param {Number} id - ID du document
   * @param {Number} page - Numéro de la page
   * @returns {Promise} - Promesse contenant l'URL de l'aperçu
   */
  async getDocumentPreview(id, page = 1) {
    try {
      // Dans une application réelle, cette requête serait envoyée au backend
      // return await api.get(`/documents/${id}/preview`, { params: { page } });
      
      // Pour la démo, on simule une réponse
      await new Promise(resolve => setTimeout(resolve, 500));
      
      // Rechercher le document dans nos données statiques
      const document = allDocuments.find(doc => doc.id === parseInt(id));
      
      if (!document) {
        throw new Error(`Document avec l'ID ${id} non trouvé`);
      }
      
      // Obtenir l'URL du PDF pour la prévisualisation
      const pdfUrl = pdfService.getStaticPdfUrl(document);
      
      return { 
        data: { 
          previewUrl: pdfUrl,
          totalPages: 3,
          document: {
            ...document,
            pdfUrl
          }
        } 
      };
    } catch (error) {
      console.error(`Erreur lors de la génération de l'aperçu du document ${id}:`, error);
      throw error;
    }
  },
  
  /**
   * Exporte un document au format PDF
   * @param {Number} id - ID du document
   * @returns {Promise} - Promesse contenant l'URL du PDF
   */
  async exportDocumentToPdf(id) {
    try {
      // Dans une application réelle, cette requête serait envoyée au backend
      // const response = await api.get(`/documents/${id}/export/pdf`, { responseType: 'blob' });
      // const url = window.URL.createObjectURL(new Blob([response.data], { type: 'application/pdf' }));
      // return url;
      
      // Pour la démo, on simule une réponse
      await new Promise(resolve => setTimeout(resolve, 1500));
      
      // Simuler une URL de téléchargement
      return { 
        success: true, 
        message: `Document ${id} exporté en PDF avec succès` 
      };
    } catch (error) {
      console.error(`Erreur lors de l'exportation en PDF du document ${id}:`, error);
      throw error;
    }
  },
  
  /**
   * Récupère l'URL de base pour les appels d'API
   * @returns {String} - URL de base
   */
  getBaseUrl() {
    return api.defaults.baseURL || window.location.origin;
  },
  
  /**
   * Récupère l'URL pour télécharger directement un document
   * @param {Number} id - ID du document
   * @returns {String} - URL de téléchargement direct
   */
  getDirectDownloadUrl(id) {
    try {
      if (!id) {
        console.warn('ID manquant pour générer l\'URL de téléchargement direct');
        return '';
      }
      
      // Obtenir le token d'authentification
      const token = localStorage.getItem('token');
      if (!token) {
        console.warn('Token d\'authentification manquant pour le téléchargement direct');
        return '';
      }
      
      return `${api.defaults.baseURL}/api/protected/documents/${id}/download?token=${token}`;
    } catch (error) {
      console.error('Erreur lors de la génération de l\'URL de téléchargement direct:', error);
      return '';
    }
  },
  
  // Méthodes utilitaires pour la génération de données de test
  getRandomDocumentType() {
    const types = ['facture', 'devis', 'bon_livraison', 'contrat'];
    return types[Math.floor(Math.random() * types.length)];
  },
  
  getRandomStatus() {
    const statuses = ['draft', 'sent', 'paid', 'overdue'];
    return statuses[Math.floor(Math.random() * statuses.length)];
  },
  
  getRandomDate(start, end) {
    return new Date(start.getTime() + Math.random() * (end.getTime() - start.getTime()));
  }
};