import api from './api';

/**
 * Service pour l'authentification et la gestion des utilisateurs
 */
export default {
  /**
   * Authentifie un utilisateur
   * @param {Object} credentials - Identifiants de connexion (email, mot de passe)
   * @returns {Promise} - Promesse contenant les informations de l'utilisateur et le token
   */
  async login(credentials) {
    try {
      const response = await api.post('/api/auth/login', credentials);
      const { token, user } = response.data;
      
      // Stocker le token dans le localStorage
      localStorage.setItem('token', token);
      
      return { data: { token, user } };
    } catch (error) {
      console.error('Erreur lors de la connexion:', error);
      throw error;
    }
  },
  
  /**
   * Déconnecte l'utilisateur actuel
   * @returns {Promise} - Promesse contenant le statut de la déconnexion
   */
  async logout() {
    try {
      // Dans une application réelle, on pourrait envoyer une requête au serveur
      // pour invalider le token
      localStorage.removeItem('token');
      return { success: true, message: 'Déconnexion réussie' };
    } catch (error) {
      console.error('Erreur lors de la déconnexion:', error);
      throw error;
    }
  },
  
  /**
   * Enregistre un nouvel utilisateur
   * @param {Object} userData - Données d'utilisateur (nom, email, mot de passe)
   * @returns {Promise} - Promesse contenant le statut de l'enregistrement
   */
  async register(userData) {
    try {
      const response = await api.post('/api/auth/register', userData);
      return response.data;
    } catch (error) {
      console.error('Erreur lors de l\'enregistrement:', error);
      throw error;
    }
  },
  
  /**
   * Envoie un email de vérification à l'utilisateur
   * @param {Object} userData - Données de l'utilisateur (email)
   * @returns {Promise} - Promesse contenant le statut de l'envoi
   */
  async sendVerificationEmail(userData) {
    try {
      // Utilisation du format standardisé d'email
      const standardEmailData = {
        emailType: 'account_verification',
        recipient: {
          email: userData.email,
          name: userData.name || ''
        },
        subject: 'Vérification de votre compte QuikDoc',
        message: 'Veuillez cliquer sur le lien ci-dessous pour vérifier votre compte.',
        metadata: {
          userId: userData.id,
          verificationToken: userData.verificationToken || ''
        }
      };
      
      // Endpoint dédié pour l'email de vérification
      const endpoint = '/api/auth/send-verification';
      
      // Préparer les données à envoyer au format attendu par le backend
      const dataToSend = {
        to: standardEmailData.recipient.email,
        subject: standardEmailData.subject,
        message: standardEmailData.message,
        emailType: standardEmailData.emailType,
        metadata: standardEmailData.metadata
      };
      
      console.log('Envoi d\'email de vérification:', dataToSend);
      const response = await api.post(endpoint, dataToSend);
      return response.data;
    } catch (error) {
      console.error('Erreur lors de l\'envoi de l\'email de vérification:', error);
      throw error;
    }
  },
  
  /**
   * Envoie un email de réinitialisation de mot de passe
   * @param {Object} userData - Données de l'utilisateur (email)
   * @returns {Promise} - Promesse contenant le statut de l'envoi
   */
  async sendPasswordResetEmail(userData) {
    try {
      // Utilisation du format standardisé d'email
      const standardEmailData = {
        emailType: 'password_reset',
        recipient: {
          email: userData.email,
          name: userData.name || ''
        },
        subject: 'Réinitialisation de votre mot de passe QuikDoc',
        message: 'Veuillez cliquer sur le lien ci-dessous pour réinitialiser votre mot de passe.',
        metadata: {
          userId: userData.id,
          resetToken: userData.resetToken || ''
        }
      };
      
      // Endpoint dédié pour l'email de réinitialisation
      const endpoint = '/api/auth/reset-password-request';
      
      // Préparer les données à envoyer au format attendu par le backend
      const dataToSend = {
        to: standardEmailData.recipient.email,
        subject: standardEmailData.subject,
        message: standardEmailData.message,
        emailType: standardEmailData.emailType,
        metadata: standardEmailData.metadata
      };
      
      console.log('Envoi d\'email de réinitialisation de mot de passe:', dataToSend);
      const response = await api.post(endpoint, dataToSend);
      return response.data;
    } catch (error) {
      console.error('Erreur lors de l\'envoi de l\'email de réinitialisation de mot de passe:', error);
      throw error;
    }
  },
  
  /**
   * Vérifie si un utilisateur est authentifié
   * @returns {Boolean} - Vrai si l'utilisateur est authentifié
   */
  isAuthenticated() {
    return !!localStorage.getItem('token');
  },
  
  /**
   * Récupère le token d'authentification
   * @returns {String} - Token d'authentification
   */
  getToken() {
    return localStorage.getItem('token');
  },
  
  /**
   * Récupère les informations de l'utilisateur actuel
   * @returns {Promise} - Promesse contenant les informations de l'utilisateur
   */
  async getCurrentUser() {
    try {
      const token = this.getToken();
      if (!token) {
        throw new Error('Utilisateur non authentifié');
      }
      
      const response = await api.get('/api/auth/me');
      return response.data;
    } catch (error) {
      console.error('Erreur lors de la récupération des informations utilisateur:', error);
      throw error;
    }
  },
  
  /**
   * Met à jour le mot de passe de l'utilisateur
   * @param {Object} passwordData - Données de mot de passe (ancien, nouveau, confirmation)
   * @returns {Promise} - Promesse contenant le statut de la mise à jour
   */
  async updatePassword(passwordData) {
    try {
      const response = await api.post('/api/auth/update-password', passwordData);
      return response.data;
    } catch (error) {
      console.error('Erreur lors de la mise à jour du mot de passe:', error);
      throw error;
    }
  },
  
  /**
   * Réinitialise le mot de passe avec un token
   * @param {Object} resetData - Données de réinitialisation (token, nouveau mot de passe)
   * @returns {Promise} - Promesse contenant le statut de la réinitialisation
   */
  async resetPassword(resetData) {
    try {
      const response = await api.post('/api/auth/reset-password', resetData);
      return response.data;
    } catch (error) {
      console.error('Erreur lors de la réinitialisation du mot de passe:', error);
      throw error;
    }
  },
  
  /**
   * Vérifie un compte utilisateur avec un token
   * @param {Object} verificationData - Données de vérification (token)
   * @returns {Promise} - Promesse contenant le statut de la vérification
   */
  async verifyAccount(verificationData) {
    try {
      const response = await api.post('/api/auth/verify-account', verificationData);
      return response.data;
    } catch (error) {
      console.error('Erreur lors de la vérification du compte:', error);
      throw error;
    }
  }
};
