import api from './api';
import { useMainStore } from '@/stores';

/**
 * Service pour la gestion du remplissage manuel des documents
 * Ce service permet de sauvegarder les données du formulaire dans les tables remplissage et remplissage_products
 */
export default {
  /**
   * Sauvegarde les données du formulaire de remplissage manuel
   * @param {Object} formData - Données du formulaire
   * @param {String} documentType - Type de document (facture ou devis)
   * @param {Number} templateId - ID du template sélectionné
   * @returns {Promise} - Promesse contenant le document créé
   */
  async saveManualFillData(formData, documentType, templateId) {
    try {
      // Récupérer l'utilisateur depuis le store Pinia
      const store = useMainStore();
      const user = store.user;
      
      if (!user || !user.id) {
        throw new Error('Utilisateur non connecté');
      }

      // Préparer les données pour la table remplissage
      const remplissageData = {
        entreprise_id: formData.entreprise.id || user.enterprise?.id, // Utiliser l'ID de l'entreprise du formData ou du user.enterprise
        client_id: formData.client.id || null, // ID du client sélectionné, vérifier s'il existe
        template_id: templateId, // ID du template sélectionné
        owner_id: user.id, // ID de l'utilisateur actuel
        serie_number: formData.document.numeroSerie, // Numéro de série du document
        type_document: documentType, // Type de document (facture ou devis)
        montant_ht: formData.calculs.totalHT, // Montant HT
        total_remise: formData.calculs.totalRemise, // Total des remises
        montant_tva: formData.calculs.totalTVA, // Montant TVA
        taux_tva: 0, // Taux TVA (fixé à 0 comme demandé)
        montant_ttc: formData.calculs.totalTTC, // Montant TTC
        details_bancaire: formData.detailsBancaires?.informations || formData.detailsBancaires, // Détails bancaires
        date_document: formData.document.date, // Date du document
        avertissement: formData.avertissement?.message || formData.avertissement, // Message d'avertissement
        delai_paiement: null // Délai de paiement (null comme demandé)
      };

      // Envoyer les données au backend
      const response = await api.post('/api/remplissage/create', {
        remplissageData,
        products: formData.produits.map(produit => ({
          product_id: produit.id || null, // ID du produit
          quantity: produit.quantite, // Quantité
          unit_price: produit.prixUnitaire, // Prix unitaire
          unit: produit.unite || '', // Unité
          total_price: produit.totalHT, // Prix total HT
          ref: produit.reference, // Référence
          tva: produit.tva || produit.tvaPercentage || 0 // TVA
        }))
      });

      return response.data;
    } catch (error) {
      console.error('Erreur lors de la sauvegarde des données du formulaire:', error);
      throw error;
    }
  }
};