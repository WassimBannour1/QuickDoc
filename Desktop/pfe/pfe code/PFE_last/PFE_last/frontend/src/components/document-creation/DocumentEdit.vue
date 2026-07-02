<template>
  <div class="modal-overlay" @click.self="goBack">
    <div class="document-edit-container">
    <h2 class="page-title">Modification de {{ documentTypeLabel }}</h2>
    
    <!-- Composant de notification modal -->
    <NotificationModal 
      :visible="notification.visible" 
      :title="notification.title" 
      :message="notification.message" 
      :type="notification.type" 
      :show-actions="notification.showActions" 
      @close="closeNotification" 
      @confirm="notification.onConfirm"
    />
    
    <!-- Affichage des erreurs de validation -->
    <div v-if="showErrors && validationErrors.length > 0" class="error-message-container">
      <div class="error-message">
        <i class="fas fa-exclamation-circle"></i>
        <p>Veuillez corriger les erreurs suivantes :</p>
        <ul>
          <li v-for="(error, index) in validationErrors" :key="index">{{ error }}</li>
        </ul>
      </div>
    </div>
    
    <!-- Section Document -->
    <div class="form-section">
      <div class="section-header">
        <i class="fas fa-file-alt"></i>
        <h3>Informations Document</h3>
      </div>
      <div class="form-grid">
        <div class="form-group" :class="{ 'has-error': showErrors && !formData.document.date }">
          <label for="dateDocument">Date <span class="required">*</span></label>
          <input type="date" id="dateDocument" v-model="formData.document.date">
          <span v-if="showErrors && !formData.document.date" class="error-text">La date est requise</span>
        </div>
        <div class="form-group" :class="{ 'has-error': showErrors && !formData.document.numeroSerie }">
          <label for="numeroSerie">Numéro de Série <span class="required">*</span></label>
          <input type="text" id="numeroSerie" v-model="formData.document.numeroSerie" placeholder="Numéro de série">
          <span v-if="showErrors && !formData.document.numeroSerie" class="error-text">Le numéro de série est requis</span>
        </div>
      </div>
    </div>
    
    <!-- Section Entreprise -->
    <div class="form-section">
      <div class="section-header">
        <i class="fas fa-building"></i>
        <h3>Informations Entreprise</h3>
      </div>
      <div class="form-grid">
        <div class="form-group" :class="{ 'has-error': showErrors && !formData.entreprise.nom }">
          <label for="nomEntreprise">Nom Entreprise <span class="required">*</span></label>
          <input type="text" id="nomEntreprise" v-model="formData.entreprise.nom" placeholder="Nom de l'entreprise">
          <span v-if="showErrors && !formData.entreprise.nom" class="error-text">Le nom de l'entreprise est requis</span>
        </div>
        <div class="form-group" :class="{ 'has-error': showErrors && !formData.entreprise.adresse }">
          <label for="adresseEntreprise">Adresse <span class="required">*</span></label>
          <input type="text" id="adresseEntreprise" v-model="formData.entreprise.adresse" placeholder="Adresse complète">
          <span v-if="showErrors && !formData.entreprise.adresse" class="error-text">L'adresse est requise</span>
        </div>
        <div class="form-group" :class="{ 'has-error': showErrors && !formData.entreprise.email }">
          <label for="emailEntreprise">Email <span class="required">*</span></label>
          <input type="email" id="emailEntreprise" v-model="formData.entreprise.email" placeholder="Email de contact">
          <span v-if="showErrors && !formData.entreprise.email" class="error-text">L'email est requis</span>
        </div>
        <div class="form-group" :class="{ 'has-error': showErrors && !formData.entreprise.siret }">
          <label for="siretEntreprise">SIRET <span class="required">*</span></label>
          <input type="text" id="siretEntreprise" v-model="formData.entreprise.siret" placeholder="Numéro SIRET">
          <span v-if="showErrors && !formData.entreprise.siret" class="error-text">Le SIRET est requis</span>
        </div>
        <div class="form-group" :class="{ 'has-error': showErrors && !formData.entreprise.telephone }">
          <label for="telephoneEntreprise">Téléphone <span class="required">*</span></label>
          <input type="tel" id="telephoneEntreprise" v-model="formData.entreprise.telephone" placeholder="Numéro de téléphone">
          <span v-if="showErrors && !formData.entreprise.telephone" class="error-text">Le téléphone est requis</span>
        </div>
      </div>
    </div>
    
    <!-- Section Client -->
    <div class="form-section">
      <div class="section-header">
        <i class="fas fa-user-tie"></i>
        <h3>Informations Client</h3>
      </div>
      <div class="form-grid">
        <div class="form-group">
          <label for="emailClient">Email</label>
          <div class="email-search-container">
            <input 
              type="email" 
              id="emailClient" 
              v-model="formData.client.email" 
              placeholder="Email de contact" 
              @input="searchClientByEmail"
              autocomplete="off"
            >
            <div v-if="searchResults.length > 0" class="search-results">
              <div 
                v-for="client in searchResults" 
                :key="client.id" 
                class="search-result-item"
                @click="selectClient(client)"
              >
                {{ client.email }} ({{ client.name }} {{ client.last_name }})
              </div>
            </div>
          </div>
        </div>
        <div class="form-group" :class="{ 'has-error': showErrors && !formData.client.nom }">
          <label for="nomClient">Nom Client <span class="required">*</span></label>
          <input type="text" id="nomClient" v-model="formData.client.nom" placeholder="Nom du client">
          <span v-if="showErrors && !formData.client.nom" class="error-text">Le nom du client est requis</span>
        </div>
        <div class="form-group" :class="{ 'has-error': showErrors && !formData.client.adresse }">
          <label for="adresseClient">Adresse <span class="required">*</span></label>
          <input type="text" id="adresseClient" v-model="formData.client.adresse" placeholder="Adresse complète">
          <span v-if="showErrors && !formData.client.adresse" class="error-text">L'adresse est requise</span>
        </div>
        <div class="form-group" :class="{ 'has-error': showErrors && !formData.client.email }">
          <label for="emailClient">Email <span class="required">*</span></label>
          <input type="email" id="emailClient" v-model="formData.client.email" placeholder="Email de contact">
          <span v-if="showErrors && !formData.client.email" class="error-text">L'email est requis</span>
        </div>
        <div class="form-group" :class="{ 'has-error': showErrors && !formData.client.telephone }">
          <label for="telephoneClient">Téléphone <span class="required">*</span></label>
          <input type="tel" id="telephoneClient" v-model="formData.client.telephone" placeholder="Numéro de téléphone">
          <span v-if="showErrors && !formData.client.telephone" class="error-text">Le téléphone est requis</span>
        </div>
      </div>
    </div>
    
    <!-- Section Produits -->
    <div class="form-section">
      <div class="section-header">
        <i class="fas fa-box-open"></i>
        <h3>Produits</h3>
      </div>
      
      <div class="products-list">
        <div v-for="(produit, index) in formData.produits" :key="index" class="product-item">
          <div class="product-header">
            <h4>Produit {{ index + 1 }}</h4>
            <button type="button" class="remove-product-btn" @click="removeProduit(index)" v-if="formData.produits.length > 1">
              <i class="fas fa-times"></i>
            </button>
          </div>
          
          <div class="form-grid">
            <div class="form-group" :class="{ 'has-error': showErrors && !produit.nom }">
              <label :for="'nomProduit' + index">Nom du Produit <span class="required">*</span></label>
              <div class="product-search-container">
                <input 
                  type="text" 
                  :id="'nomProduit' + index" 
                  v-model="produit.nom" 
                  placeholder="Nom du produit"
                  @input="searchProductByName(index)"
                  autocomplete="off"
                >
                <div v-if="productSearchResults[index] && productSearchResults[index].length > 0" class="search-results">
                  <div 
                    v-for="product in productSearchResults[index]" 
                    :key="product.id" 
                    class="search-result-item"
                    @click="selectProduct(product, index)"
                  >
                    {{ product.name }}
                  </div>
                </div>
              </div>
              <span v-if="showErrors && !produit.nom" class="error-text">Le nom du produit est requis</span>
            </div>
            <div class="form-group" :class="{ 'has-error': showErrors && (produit.prixUnitaire <= 0) }">
              <label :for="'prixUnitaire' + index">Prix Unitaire (HT) <span class="required">*</span></label>
              <input type="number" :id="'prixUnitaire' + index" v-model="produit.prixUnitaire" placeholder="Prix unitaire HT" step="0.01" min="0" @input="calculateTotalHT(index)">
              <span v-if="showErrors && (produit.prixUnitaire <= 0)" class="error-text">Le prix unitaire doit être supérieur à 0</span>
            </div>
            <div class="form-group" :class="{ 'has-error': showErrors && (produit.quantite <= 0) }">
              <label :for="'quantiteProduit' + index">Quantité <span class="required">*</span></label>
              <input type="number" :id="'quantiteProduit' + index" v-model="produit.quantite" placeholder="Quantité" min="1" @input="calculateTotalHT(index)">
              <span v-if="showErrors && (produit.quantite <= 0)" class="error-text">La quantité doit être supérieure à 0</span>
            </div>
            <div class="form-group">
              <label :for="'totalHT' + index">Total HT</label>
              <input type="number" :id="'totalHT' + index" v-model="produit.totalHT" placeholder="Total HT" step="0.01" min="0" readonly>
            </div>
            <div class="form-group" :class="{ 'has-error': showErrors && (produit.tvaPercentage < 0) }">
              <label :for="'tvaPercentage' + index">TVA (%) <span class="required">*</span></label>
              <input type="number" :id="'tvaPercentage' + index" v-model="produit.tvaPercentage" placeholder="Taux de TVA" step="0.1" min="0">
              <span v-if="showErrors && (produit.tvaPercentage < 0)" class="error-text">Le taux de TVA ne peut pas être négatif</span>
            </div>
            <div class="form-group" :class="{ 'has-error': showErrors && !produit.reference }">
              <label :for="'refProduit' + index">Référence <span class="required">*</span></label>
              <input type="text" :id="'refProduit' + index" v-model="produit.reference" placeholder="Référence du produit">
              <span v-if="showErrors && !produit.reference" class="error-text">La référence est requise</span>
            </div>
          </div>
        </div>
      </div>
      
      <button type="button" class="add-product-btn" @click="addProduit">
        <i class="fas fa-plus"></i> Ajouter un produit
      </button>
    </div>
    
    <!-- Section Calculs -->
    <div class="form-section">
      <div class="section-header">
        <i class="fas fa-calculator"></i>
        <h3>Calculs</h3>
      </div>
      <div class="form-grid">
        <div class="form-group">
          <label for="totalHT">Total HT <span class="required">*</span></label>
          <input type="number" id="totalHT" v-model="formData.calculs.totalHT" placeholder="Total HT" step="0.01" min="0" readonly>
        </div>
        <div class="form-group">
          <label for="totalRemise">Total Remise <span class="required">*</span></label>
          <input type="number" id="totalRemise" v-model="formData.calculs.totalRemise" placeholder="Total remise" step="0.01" min="0" @input="calculateTotals">
        </div>
        <div class="form-group">
          <label for="totalNetHT">Total Net HT <span class="required">*</span></label>
          <input type="number" id="totalNetHT" v-model="formData.calculs.totalNetHT" placeholder="Total net HT" step="0.01" min="0" readonly>
        </div>
        <div class="form-group">
          <label for="totalTVA">Total TVA <span class="required">*</span></label>
          <input type="number" id="totalTVA" v-model="formData.calculs.totalTVA" placeholder="Total TVA" step="0.01" min="0" @input="calculateTotals">
        </div>
        <div class="form-group">
          <label for="totalTTC">Total TTC <span class="required">*</span></label>
          <input type="number" id="totalTTC" v-model="formData.calculs.totalTTC" placeholder="Total TTC" step="0.01" min="0" readonly>
        </div>
      </div>
    </div>
    
    <!-- Section Détails Bancaires -->
    <div class="form-section">
      <div class="section-header">
        <i class="fas fa-university"></i>
        <h3>Détails Bancaires</h3>
      </div>
      <div class="form-group full-width" :class="{ 'has-error': showErrors && !formData.detailsBancaires.informations }">
        <label for="detailsBancaires">Informations Bancaires <span class="required">*</span></label>
        <textarea id="detailsBancaires" v-model="formData.detailsBancaires.informations" placeholder="Détails bancaires pour le paiement" rows="4"></textarea>
        <span v-if="showErrors && !formData.detailsBancaires.informations" class="error-text">Les détails bancaires sont requis</span>
      </div>
    </div>
    
    <!-- Section Avertissement -->
    <div class="form-section">
      <div class="section-header">
        <i class="fas fa-exclamation-triangle"></i>
        <h3>Avertissement</h3>
      </div>
      <div class="form-group full-width" :class="{ 'has-error': showErrors && !formData.avertissement.message }">
        <label for="avertissement">Message d'Avertissement <span class="required">*</span></label>
        <textarea id="avertissement" v-model="formData.avertissement.message" placeholder="Message d'avertissement ou conditions" rows="4"></textarea>
        <span v-if="showErrors && !formData.avertissement.message" class="error-text">Le message d'avertissement est requis</span>
      </div>
    </div>
    
    <!-- Boutons d'action -->
    <div class="action-buttons">
      <button type="button" class="back-button" @click="goBack">
        <i class="fas fa-arrow-left"></i> Retour
      </button>
      <button type="button" class="archive-button" @click="archiveDocument">
        <i class="fas fa-archive"></i> Archiver
      </button>
      <button type="button" class="save-button" @click="updateDocument">
        <i class="fas fa-save"></i> Mettre à jour
      </button>
    </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, defineProps, defineEmits, onMounted, watch } from 'vue';
import { useMainStore } from '../../stores';
import api from '../../services/api';
import remplissageService from '../../services/remplissageservice';
import NotificationModal from '../common/NotificationModal.vue';

const store = useMainStore();

const props = defineProps({
  documentId: {
    type: [Number, String],
    required: true
  },
  documentType: {
    type: String,
    required: true,
    validator: value => ['devis', 'facture'].includes(value)
  }
});

const emit = defineEmits(['back', 'updated', 'archive']);

// État pour afficher les erreurs de validation
const showErrors = ref(false);
const validationErrors = ref([]);

// État pour la notification modale
const notification = ref({
  visible: false,
  title: '',
  message: '',
  type: 'info', // 'success', 'error', 'warning', 'info'
  showActions: false,
  onConfirm: () => {}
});

// Fonction pour afficher une notification
const showNotification = (title, message, type = 'info', showActions = false, onConfirm = () => {}) => {
  notification.value = {
    visible: true,
    title,
    message,
    type,
    showActions,
    onConfirm
  };
};

// Fonction pour fermer la notification
const closeNotification = () => {
  notification.value.visible = false;
};

// Libellé du type de document (pour l'affichage)
const documentTypeLabel = computed(() => {
  return props.documentType === 'facture' ? 'Facture' : 'Devis';
});

// Résultats de recherche pour les clients
const searchResults = ref([]);

// Résultats de recherche pour les produits (un tableau pour chaque produit)
const productSearchResults = ref({});

// Structure des données du formulaire
const formData = ref({
  entreprise: {
    id: null,
    nom: '',
    adresse: '',
    email: '',
    siret: '',
    telephone: ''
  },
  client: {
    id: null,
    nom: '',
    adresse: '',
    telephone: '',
    email: ''
  },
  produits: [
    {
      id: null,
      reference: '1', // Référence par défaut commence à 1
      nom: '',
      quantite: 1,
      prixUnitaire: 0,
      totalHT: 0,
      tvaPercentage: 20
    }
  ],
  document: {
    type: props.documentType,
    date: new Date().toISOString().split('T')[0],
    numeroSerie: ''
  },
  calculs: {
    totalHT: 0,
    totalRemise: 0,
    totalNetHT: 0,
    totalTVA: 0,
    totalTTC: 0
  },
  detailsBancaires: {
    informations: ''
  },
  avertissement: {
    message: ''
  }
});

// Fonction pour charger les données du document à éditer
const fetchDocumentData = async () => {
  try {
    const response = await remplissageService.getDocumentDetailsForEdit(props.documentId);
    
    if (response && response.success) {
      // Remplir le formulaire avec les données du document
      const documentData = response.data;
      
      // Remplir les informations du document
      formData.value.document.date = documentData.document.date || new Date().toISOString().split('T')[0];
      formData.value.document.numeroSerie = documentData.document.numeroSerie || '';
      
      // Remplir les informations de l'entreprise
      if (documentData.entreprise) {
        formData.value.entreprise.id = documentData.entreprise.id || null;
        formData.value.entreprise.nom = documentData.entreprise.nom || '';
        formData.value.entreprise.adresse = documentData.entreprise.adresse || '';
        formData.value.entreprise.email = documentData.entreprise.email || '';
        formData.value.entreprise.siret = documentData.entreprise.siret || '';
        formData.value.entreprise.telephone = documentData.entreprise.telephone || '';
      }
      
      // Remplir les informations du client
      if (documentData.client) {
        formData.value.client.id = documentData.client.id || null;
        formData.value.client.nom = documentData.client.nom || '';
        formData.value.client.adresse = documentData.client.adresse || '';
        formData.value.client.email = documentData.client.email || '';
        formData.value.client.telephone = documentData.client.telephone || '';
      }
      
      // Remplir les produits
      if (documentData.produits && documentData.produits.length > 0) {
        formData.value.produits = documentData.produits.map((produit, index) => ({
          id: produit.id || null,
          // Utiliser l'index + 1 comme référence pour maintenir l'auto-incrémentation
          reference: (index + 1).toString(),
          nom: produit.nom || '',
          quantite: produit.quantite || 1,
          prixUnitaire: produit.prixUnitaire || 0,
          totalHT: produit.totalHT || 0,
          tvaPercentage: produit.tvaPercentage || 20
        }));
      }
      
      // Remplir les calculs
      if (documentData.calculs) {
        formData.value.calculs.totalHT = documentData.calculs.totalHT || 0;
        formData.value.calculs.totalRemise = documentData.calculs.totalRemise || 0;
        formData.value.calculs.totalNetHT = documentData.calculs.totalNetHT || 0;
        formData.value.calculs.totalTVA = documentData.calculs.totalTVA || 0;
        formData.value.calculs.totalTTC = documentData.calculs.totalTTC || 0;
      }
      
      // Remplir les détails bancaires et avertissement
      if (documentData.detailsBancaires) {
        formData.value.detailsBancaires.informations = documentData.detailsBancaires.informations || '';
      }
      
      if (documentData.avertissement) {
        formData.value.avertissement.message = documentData.avertissement.message || '';
      }
      
      // Initialiser les résultats de recherche pour chaque produit
      formData.value.produits.forEach((_, index) => {
        productSearchResults.value[index] = [];
      });
      
      // Calculer les totaux
      calculateTotals();
    }
  } catch (error) {
    console.error('Erreur lors de la récupération des données du document:', error);
  }
};

// Fonction pour rechercher un client par email
const searchClientByEmail = async () => {
  try {
    const email = formData.value.client.email.trim();
    
    if (!email) {
      searchResults.value = [];
      return;
    }
    
    const response = await api.get('/api/clients/search', {
      params: { query: email }
    });
    
    if (response.data && response.data.success && Array.isArray(response.data.data)) {
      searchResults.value = response.data.data;
    } else {
      searchResults.value = [];
    }
  } catch (error) {
    console.error('Erreur lors de la recherche de clients:', error);
    searchResults.value = [];
  }
};

// Fonction pour sélectionner un client dans les résultats de recherche
const selectClient = (client) => {
  formData.value.client.id = client.id || null;
  formData.value.client.email = client.email || '';
  formData.value.client.nom = `${client.name || ''} ${client.last_name || ''}`.trim();
  formData.value.client.adresse = client.address || '';
  formData.value.client.telephone = client.phone || '';
  
  searchResults.value = [];
};

// Fonction pour ajouter un nouveau produit
const addProduit = () => {
  const newIndex = formData.value.produits.length;
  // Incrémenter automatiquement la référence pour le nouveau produit
  const newReference = (newIndex + 1).toString();
  
  formData.value.produits.push({
    reference: newReference,
    nom: '',
    quantite: 1,
    prixUnitaire: 0,
    totalHT: 0,
    tvaPercentage: 20
  });
  
  productSearchResults.value[newIndex] = [];
};

// Fonction pour supprimer un produit
const removeProduit = (index) => {
  formData.value.produits.splice(index, 1);
  
  const newProductSearchResults = {};
  formData.value.produits.forEach((_, i) => {
    if (productSearchResults.value[i + (i >= index ? 1 : 0)]) {
      newProductSearchResults[i] = productSearchResults.value[i + (i >= index ? 1 : 0)];
    } else {
      newProductSearchResults[i] = [];
    }
  });
  productSearchResults.value = newProductSearchResults;
  
  // Recalculer les totaux après suppression
  calculateTotals();
};

// Fonction pour revenir à la liste des documents
const goBack = () => {
  emit('back');
};

// Fonction pour archiver le document et passer à l'aperçu
const archiveDocument = () => {
  // Préparer les données du document pour l'aperçu
  const documentData = {
    id: props.documentId,
    document: {
      type: props.documentType,
      date: formData.value.document.date,
      numeroSerie: formData.value.document.numeroSerie
    },
    entreprise: formData.value.entreprise,
    client: formData.value.client,
    produits: formData.value.produits,
    calculs: formData.value.calculs,
    detailsBancaires: {
      informations: formData.value.detailsBancaires.informations
    },
    avertissement: {
      message: formData.value.avertissement.message
    },
    // Ajouter un callback de notification pour gérer les messages
    notificationCallback: (type, title, message) => {
      showNotification(title, message, type);
    }
  };
  
  // Émettre l'événement d'archivage avec les données du document
  emit('archive', documentData);
};

// Fonction pour valider le formulaire
const validateForm = () => {
  showErrors.value = true;
  validationErrors.value = [];
  
  // Validation des champs obligatoires
  if (!formData.value.document.date) {
    validationErrors.value.push('La date du document est requise');
  }
  
  if (!formData.value.document.numeroSerie) {
    validationErrors.value.push('Le numéro de série est requis');
  }
  
  if (!formData.value.entreprise.nom) {
    validationErrors.value.push('Le nom de l\'entreprise est requis');
  }
  
  if (!formData.value.entreprise.adresse) {
    validationErrors.value.push('L\'adresse de l\'entreprise est requise');
  }
  
  if (!formData.value.entreprise.email) {
    validationErrors.value.push('L\'email de l\'entreprise est requis');
  }
  
  if (!formData.value.entreprise.siret) {
    validationErrors.value.push('Le SIRET est requis');
  }
  
  if (!formData.value.entreprise.telephone) {
    validationErrors.value.push('Le téléphone de l\'entreprise est requis');
  }
  
  if (!formData.value.client.nom) {
    validationErrors.value.push('Le nom du client est requis');
  }
  
  if (!formData.value.client.adresse) {
    validationErrors.value.push('L\'adresse du client est requise');
  }
  
  if (!formData.value.client.email) {
    validationErrors.value.push('L\'email du client est requis');
  }
  
  if (!formData.value.client.telephone) {
    validationErrors.value.push('Le téléphone du client est requis');
  }
  
  // Validation des produits
  formData.value.produits.forEach((produit, index) => {
    if (!produit.nom) {
      validationErrors.value.push(`Le nom du produit ${index + 1} est requis`);
    }
    
    if (produit.prixUnitaire <= 0) {
      validationErrors.value.push(`Le prix unitaire du produit ${index + 1} doit être supérieur à 0`);
    }
    
    if (produit.quantite <= 0) {
      validationErrors.value.push(`La quantité du produit ${index + 1} doit être supérieure à 0`);
    }
    
    if (!produit.reference) {
      validationErrors.value.push(`La référence du produit ${index + 1} est requise`);
    }
    
    if (produit.tvaPercentage < 0) {
      validationErrors.value.push(`Le taux de TVA du produit ${index + 1} ne peut pas être négatif`);
    }
  });
  
  // Validation des calculs
  if (formData.value.calculs.totalRemise < 0) {
    validationErrors.value.push('La remise ne peut pas être négative');
  }
  
  if (formData.value.calculs.totalTVA < 0) {
    validationErrors.value.push('La TVA ne peut pas être négative');
  }
  
  // Validation des détails bancaires
  if (!formData.value.detailsBancaires.informations) {
    validationErrors.value.push('Les informations bancaires sont requises');
  }
  
  // Validation du message d'avertissement
  if (!formData.value.avertissement.message) {
    validationErrors.value.push('Le message d\'avertissement est requis');
  }
  
  return validationErrors.value.length === 0;
};

// Fonction pour mettre à jour le document
const updateDocument = async () => {
  // Valider le formulaire avant de soumettre
  if (!validateForm()) {
    showNotification('Erreur', 'Veuillez corriger les erreurs dans le formulaire.', 'error');
    return;
  }
  
  try {
    // Préparer les données à envoyer
    const documentData = {
      id: props.documentId,
      type: props.documentType,
      date: formData.value.document.date,
      serie_number: formData.value.document.numeroSerie,
      entreprise: {
        id: formData.value.entreprise.id,
        nom: formData.value.entreprise.nom,
        adresse: formData.value.entreprise.adresse,
        email: formData.value.entreprise.email,
        siret: formData.value.entreprise.siret,
        telephone: formData.value.entreprise.telephone
      },
      client: {
        id: formData.value.client.id,
        nom: formData.value.client.nom,
        adresse: formData.value.client.adresse,
        email: formData.value.client.email,
        telephone: formData.value.client.telephone
      },
      produits: formData.value.produits.map(produit => ({
        id: produit.id,
        reference: produit.reference,
        nom: produit.nom,
        quantite: produit.quantite,
        prix_unitaire: produit.prixUnitaire,
        total_ht: produit.totalHT,
        tva_percentage: produit.tvaPercentage
      })),
      calculs: {
        total_ht: formData.value.calculs.totalHT,
        total_remise: formData.value.calculs.totalRemise,
        total_net_ht: formData.value.calculs.totalNetHT,
        total_tva: formData.value.calculs.totalTVA,
        total_ttc: formData.value.calculs.totalTTC
      },
      details_bancaires: formData.value.detailsBancaires.informations,
      avertissement: formData.value.avertissement.message
    };
    
    // Envoyer les données au serveur
    const response = await api.put(`/api/primerie/document/${props.documentId}`, documentData, {
      headers: {
        'Authorization': `Bearer ${localStorage.getItem('token')}`
      }
    });
    
    if (response.data && response.data.success) {
      // Afficher une notification de succès
      showNotification('Succès', 'Le document a été mis à jour avec succès.', 'success');
      // Émettre un événement pour indiquer que le document a été mis à jour
      emit('updated', response.data.data);
    }
  } catch (error) {
    console.error('Erreur lors de la mise à jour du document:', error);
    showNotification('Erreur', 'Une erreur est survenue lors de la mise à jour du document.', 'error');
  }
};

// Fonction pour rechercher un produit par nom
const searchProductByName = async (index) => {
  try {
    const name = formData.value.produits[index].nom.trim();
    
    if (!name) {
      productSearchResults.value[index] = [];
      return;
    }
    
    const response = await api.get('/api/products/search', {
      params: { term: name }
    });
    
    if (response.data && response.data.success && Array.isArray(response.data.data)) {
      productSearchResults.value[index] = response.data.data;
    } else {
      productSearchResults.value[index] = [];
    }
  } catch (error) {
    console.error('Erreur lors de la recherche de produits:', error);
    productSearchResults.value[index] = [];
  }
};

// Fonction pour sélectionner un produit dans les résultats de recherche
const selectProduct = (product, index) => {
  // Sauvegarder la référence actuelle
  const currentReference = formData.value.produits[index].reference;
  
  formData.value.produits[index].id = product.id || null;
  formData.value.produits[index].nom = product.name || '';
  formData.value.produits[index].prixUnitaire = product.unit_price || 0;
  // Conserver la référence actuelle au lieu de la remplacer par celle du produit
  // formData.value.produits[index].reference = product.reference || '';
  
  calculateTotalHT(index);
  
  productSearchResults.value[index] = [];
};

// Fonction pour calculer le total HT d'un produit
const calculateTotalHT = (index) => {
  const produit = formData.value.produits[index];
  produit.totalHT = produit.quantite * produit.prixUnitaire;
  
  calculateTotals();
};

// Fonction pour calculer tous les totaux
const calculateTotals = () => {
  formData.value.calculs.totalHT = formData.value.produits.reduce(
    (sum, produit) => sum + (produit.totalHT || 0), 0
  );
  
  formData.value.calculs.totalNetHT = formData.value.calculs.totalHT - (formData.value.calculs.totalRemise || 0);
  
  formData.value.calculs.totalTTC = formData.value.calculs.totalNetHT + (formData.value.calculs.totalTVA || 0);
};

// Surveiller les changements sur Total Remise et Total TVA pour recalculer les totaux
watch(() => formData.value.calculs.totalRemise, () => {
  calculateTotals();
});

watch(() => formData.value.calculs.totalTVA, () => {
  calculateTotals();
});

// Charger les données du document au montage du composant
onMounted(() => {
  fetchDocumentData();
});
</script>

<style scoped>
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
  overflow-y: auto;
  padding: 2rem 0;
}

.document-edit-container {
  max-width: 1200px;
  width: 90%;
  margin: 0 auto;
  padding: 2rem;
  background-color: #f9fafc;
  border-radius: 10px;
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
  max-height: 90vh;
  overflow-y: auto;
  animation: modalFadeIn 0.3s ease-out;
}

.page-title {
  color: #002446;
  font-size: 2rem;
  font-weight: 700;
  margin-bottom: 2rem;
  text-align: center;
}

.form-section {
  background-color: white;
  border-radius: 10px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
  padding: 1.5rem;
  margin-bottom: 2rem;
  animation: fadeIn 0.5s ease-out;
}

.section-header {
  display: flex;
  align-items: center;
  margin-bottom: 1.5rem;
  padding-bottom: 0.75rem;
  border-bottom: 1px solid #e0e0e0;
}

.section-header i {
  font-size: 1.5rem;
  color: #002446;
  margin-right: 0.75rem;
}

.section-header h3 {
  font-size: 1.3rem;
  color: #333;
  font-weight: 600;
  margin: 0;
}

.form-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
  gap: 1.5rem;
}

.form-group {
  margin-bottom: 1rem;
}

.form-group.full-width {
  grid-column: 1 / -1;
}

label {
  display: block;
  margin-bottom: 0.5rem;
  font-weight: 500;
  color: #555;
}

input, select, textarea {
  width: 100%;
  padding: 0.75rem;
  border: 1px solid #ddd;
  border-radius: 6px;
  font-size: 1rem;
  transition: border-color 0.3s;
}

input:focus, select:focus, textarea:focus {
  border-color: #002446;
  outline: none;
  box-shadow: 0 0 0 2px rgba(0, 36, 70, 0.2);
}

.products-list {
  margin-bottom: 1.5rem;
}

.product-item {
  background-color: #f8f9fa;
  border-radius: 8px;
  padding: 1.25rem;
  margin-bottom: 1.5rem;
  border: 1px solid #e9ecef;
}

.product-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1rem;
}

.product-header h4 {
  margin: 0;
  color: #002446;
  font-weight: 600;
}

.remove-product-btn {
  background-color: #f8d7da;
  color: #721c24;
  border: none;
  border-radius: 50%;
  width: 30px;
  height: 30px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.3s;
}

.remove-product-btn:hover {
  background-color: #f5c6cb;
  transform: scale(1.1);
}

.add-product-btn {
  background-color: #e6f7ff;
  color: #0070f3;
  border: 1px dashed #0070f3;
  border-radius: 6px;
  padding: 0.75rem 1.5rem;
  font-size: 1rem;
  font-weight: 500;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  width: 100%;
  transition: all 0.3s;
}

.add-product-btn:hover {
  background-color: #cceeff;
}

.action-buttons {
  display: flex;
  justify-content: space-between;
  margin-top: 2rem;
  padding: 1rem 0;
  gap: 1rem;
}

.back-button, .save-button, .archive-button {
  padding: 0.8rem 1.5rem;
  border-radius: 25px;
  font-size: 1rem;
  font-weight: 500;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  transition: all 0.3s;
  border: none;
}

.back-button {
  background-color: #e0e0e0;
  color: #333;
}

.back-button:hover {
  background-color: #d0d0d0;
}

.archive-button {
  background-color: #ed8936;
  color: white;
}

.archive-button:hover {
  background-color: #dd6b20;
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.save-button {
  background-color: #4caf50;
  color: white;
}

.save-button:hover {
  background-color: #43a047;
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}

@keyframes modalFadeIn {
  from { opacity: 0; transform: scale(0.95); }
  to { opacity: 1; transform: scale(1); }
}

.form-group.has-error input,
.form-group.has-error textarea {
  border-color: #dc3545;
  background-color: #fff8f8;
}

.error-text {
  color: #dc3545;
  font-size: 0.85rem;
  margin-top: 0.25rem;
  display: block;
}

.required {
  color: #dc3545;
  margin-left: 2px;
}

.error-message-container {
  margin-bottom: 1.5rem;
}

.error-message {
  background-color: #fff8f8;
  border: 1px solid #dc3545;
  border-radius: 6px;
  padding: 1rem;
  color: #dc3545;
  display: flex;
  flex-direction: column;
  align-items: flex-start;
}

.error-message i {
  font-size: 1.5rem;
  margin-bottom: 0.5rem;
}

.error-message p {
  font-weight: 600;
  margin: 0 0 0.5rem 0;
}

.error-message ul {
  margin: 0;
  padding-left: 1.5rem;
}

.error-message li {
  margin-bottom: 0.25rem;
}

@media (max-width: 768px) {
  .form-grid {
    grid-template-columns: 1fr;
  }
  
  .action-buttons {
    flex-direction: column;
    gap: 1rem;
  }
  
  .back-button, .save-button {
    width: 100%;
    justify-content: center;
  }
}

.email-search-container {
  position: relative;
}

.product-search-container {
  position: relative;
}

.product-search-container .search-results {
  position: absolute;
  top: 100%;
  left: 0;
  right: 0;
  max-height: 200px;
  overflow-y: auto;
  background-color: white;
  border: 1px solid #ddd;
  border-radius: 0 0 6px 6px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  z-index: 10;
  margin-top: 2px;
}

.search-result-item {
  padding: 10px 15px;
  cursor: pointer;
  transition: all 0.2s ease;
  border-bottom: 1px solid #f0f0f0;
  font-size: 0.9rem;
}

.search-result-item:last-child {
  border-bottom: none;
}

.search-result-item:hover {
  background-color: #f0f7ff;
  color: #0070f3;
  transform: translateX(3px);
}
</style>