import api from './api';
import { useMainStore } from '@/stores';

/**
 * Service pour la gestion des données de la table 'remplissage'
 * Cette table contient les informations des factures et devis
 */
export default {
  /**
   * Récupère la liste des documents de type facture
   * @param {Object} filters - Filtres à appliquer (statut, date, client, etc.)
   * @returns {Promise} - Promesse contenant les factures
   */
  async getFactures(filters = {}) {
    try {
      // Récupérer l'utilisateur depuis le store Pinia
      const store = useMainStore();
      const user = store.user;
      
      // Si l'utilisateur est un client, ajouter son client_id aux filtres
      if (user && user.role === 'client' && user.client_id) {
        filters.client_id = user.client_id;
      }
      
      const response = await api.get('/api/factures', { 
        params: filters
      });
      return response.data;
    } catch (error) {
      console.error('Erreur lors du chargement des factures:', error);
      throw error;
    }
  },

  /**
   * Récupère la liste des documents de type devis
   * @param {Object} filters - Filtres à appliquer (statut, date, client, etc.)
   * @returns {Promise} - Promesse contenant les devis
   */
  async getDevis(filters = {}) {
    try {
      // Récupérer l'utilisateur depuis le store Pinia
      const store = useMainStore();
      const user = store.user;
      
      // Si l'utilisateur est un client, ajouter son client_id aux filtres
      if (user && user.role === 'client' && user.client_id) {
        filters.client_id = user.client_id;
      }
      
      const response = await api.get('/api/devis', { 
        params: filters
      });
      return response.data;
    } catch (error) {
      console.error('Erreur lors du chargement des devis:', error);
      throw error;
    }
  },

  /**
   * Récupère un document spécifique par son ID
   * @param {Number} id - ID du document
   * @returns {Promise} - Promesse contenant le document
   */
  async getDocumentById(id) {
    try {
      const response = await api.get(`/api/remplissage/${id}`);
      return response.data;
    } catch (error) {
      console.error(`Erreur lors du chargement du document ${id}:`, error);
      throw error;
    }
  },

  /**
   * Récupère les détails complets d'un document pour l'édition
   * @param {Number} id - ID du document
   * @returns {Promise} - Promesse contenant les détails du document pour l'édition
   */
  async getDocumentDetailsForEdit(id) {
    try {
      const response = await api.get(`/api/primerie/document/${id}/edit`, {
        headers: {
          'Authorization': `Bearer ${localStorage.getItem('token')}`
        }
      });
      return response.data;
    } catch (error) {
      console.error(`Erreur lors du chargement des détails du document ${id} pour l'édition:`, error);
      throw error;
    }
  },

  /**
   * Récupère tous les documents (factures et devis) avec filtres optionnels
   * @param {Object} filters - Filtres à appliquer
   * @returns {Promise} - Promesse contenant les documents
   */
  async getAllDocuments(filters = {}) {
    try {
      // Récupérer l'utilisateur depuis le store Pinia
      const store = useMainStore();
      const user = store.user;
      
      // Si l'utilisateur est un client, ajouter son client_id aux filtres
      if (user && user.role === 'client' && user.client_id) {
        filters.client_id = user.client_id;
      }
      
      const response = await api.get('/api/remplissage', {
        params: filters
      });
      return response.data;
    } catch (error) {
      console.error('Erreur lors du chargement des documents:', error);
      throw error;
    }
  },

  /**
   * Récupère les informations du client associé à un document
   * @param {Number} clientId - ID du client
   * @returns {Promise} - Promesse contenant les informations du client
   */
  async getClientInfo(clientId) {
    try {
      const response = await api.get(`/api/clients/${clientId}`);
      return response.data;
    } catch (error) {
      console.error(`Erreur lors du chargement des informations du client ${clientId}:`, error);
      throw error;
    }
  },

  /**
   * Récupère les informations du produit associé à un document
   * @param {Number} produitId - ID du produit
   * @returns {Promise} - Promesse contenant les informations du produit
   */
  async getProductInfo(produitId) {
    try {
      const response = await api.get(`/api/products/${produitId}`);
      return response.data;
    } catch (error) {
      console.error(`Erreur lors du chargement des informations du produit ${produitId}:`, error);
      throw error;
    }
  }
};
