<template>
  <div class="manual-fill-container">
    <h1 class="page-title">Remplissage Manuel - {{ documentTypeLabel }}</h1>
    
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
        <div class="form-group">
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
        <div class="form-group">
          <label for="siretEntreprise">SIRET <span class="required">*</span></label>
          <input type="text" id="siretEntreprise" v-model="formData.entreprise.siret" placeholder="Numéro SIRET">
          <span v-if="showErrors && !formData.entreprise.siret" class="error-text">Le SIRET est requis</span>
        </div>
        <div class="form-group">
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
        <div class="form-group" :class="{ 'has-error': showErrors && !formData.client.email }">
          <label for="emailClient">Email <span class="required">*</span></label>
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
          <span v-if="showErrors && !formData.client.email" class="error-text">L'email du client est requis</span>
        </div>
        <div class="form-group" :class="{ 'has-error': showErrors && !formData.client.nom }">
          <label for="nomClient">Nom Client <span class="required">*</span></label>
          <input type="text" id="nomClient" v-model="formData.client.nom" placeholder="Nom du client">
          <span v-if="showErrors && !formData.client.nom" class="error-text">Le nom du client est requis</span>
        </div>
        <div class="form-group" :class="{ 'has-error': showErrors && !formData.client.adresse }">
          <label for="adresseClient">Adresse <span class="required">*</span></label>
          <input type="text" id="adresseClient" v-model="formData.client.adresse" placeholder="Adresse complète">
          <span v-if="showErrors && !formData.client.adresse" class="error-text">L'adresse du client est requise</span>
        </div>
        <div class="form-group">
          <label for="telephoneClient">Téléphone <span class="required">*</span></label>
          <input type="tel" id="telephoneClient" v-model="formData.client.telephone" placeholder="Numéro de téléphone">
          <span v-if="showErrors && !formData.client.telephone" class="error-text">Le téléphone du client est requis</span>
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
            <div class="form-group" :class="{ 'has-error': showErrors && produit.prixUnitaire <= 0 }">
              <label :for="'prixUnitaire' + index">Prix Unitaire (HT) <span class="required">*</span></label>
              <input type="number" :id="'prixUnitaire' + index" v-model="produit.prixUnitaire" placeholder="Prix unitaire HT" step="0.01" min="0" @input="calculateTotalHT(index)">
              <span v-if="showErrors && produit.prixUnitaire <= 0" class="error-text">Le prix unitaire doit être supérieur à 0</span>
            </div>
            <div class="form-group" :class="{ 'has-error': showErrors && produit.quantite <= 0 }">
              <label :for="'quantiteProduit' + index">Quantité <span class="required">*</span></label>
              <input type="number" :id="'quantiteProduit' + index" v-model="produit.quantite" placeholder="Quantité" min="1" @input="calculateTotalHT(index)">
              <span v-if="showErrors && produit.quantite <= 0" class="error-text">La quantité doit être supérieure à 0</span>
            </div>
            <div class="form-group">
              <label :for="'totalHT' + index">Total HT <span class="required">*</span></label>
              <input type="number" :id="'totalHT' + index" v-model="produit.totalHT" placeholder="Total HT" step="0.01" min="0" readonly>
            </div>
            <div class="form-group" :class="{ 'has-error': showErrors && produit.tvaPercentage < 0 }">
              <label :for="'tvaPercentage' + index">TVA (%) <span class="required">*</span></label>
              <input type="number" :id="'tvaPercentage' + index" v-model="produit.tvaPercentage" placeholder="Taux de TVA" step="0.1" min="0">
              <span v-if="showErrors && produit.tvaPercentage < 0" class="error-text">Le taux de TVA ne peut pas être négatif</span>
            </div>
            <div class="form-group" :class="{ 'has-error': showErrors && !produit.reference }">
              <label :for="'refProduit' + index">Référence <span class="required">*</span></label>
              <input type="text" :id="'refProduit' + index" v-model="produit.reference" placeholder="Référence du produit">
              <span v-if="showErrors && !produit.reference" class="error-text">La référence du produit est requise</span>
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
        <div class="form-group" :class="{ 'has-error': showErrors && formData.calculs.totalRemise < 0 }">
          <label for="totalRemise">Total Remise <span class="required">*</span></label>
          <input type="number" id="totalRemise" v-model="formData.calculs.totalRemise" placeholder="Total remise" step="0.01" min="0" @input="calculateTotals">
          <span v-if="showErrors && formData.calculs.totalRemise < 0" class="error-text">La remise ne peut pas être négative</span>
        </div>
        <div class="form-group">
          <label for="totalNetHT">Total Net HT <span class="required">*</span></label>
          <input type="number" id="totalNetHT" v-model="formData.calculs.totalNetHT" placeholder="Total net HT" step="0.01" min="0" readonly>
        </div>
        <div class="form-group" :class="{ 'has-error': showErrors && formData.calculs.totalTVA < 0 }">
          <label for="totalTVA">Total TVA <span class="required">*</span></label>
          <input type="number" id="totalTVA" v-model="formData.calculs.totalTVA" placeholder="Total TVA" step="0.01" min="0" @input="calculateTotals">
          <span v-if="showErrors && formData.calculs.totalTVA < 0" class="error-text">La TVA ne peut pas être négative</span>
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
      <div class="form-group full-width">
        <label for="detailsBancaires">Informations Bancaires <span class="required">*</span></label>
        <textarea id="detailsBancaires" v-model="formData.detailsBancaires.informations" placeholder="Détails bancaires pour le paiement" rows="4"></textarea>
        <span v-if="showErrors && !formData.detailsBancaires.informations" class="error-text">Les informations bancaires sont requises</span>
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
      <button type="button" class="save-button" @click="saveDocument">
        <i class="fas fa-save"></i> Enregistrer
      </button>
      <button type="button" class="continue-button" @click="continueToNextStep">
        Archiver document <i class="fas fa-arrow-right"></i>
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, defineProps, defineEmits, onMounted, watch } from 'vue';
import { useMainStore } from '../../stores';
import api from '../../services/api';
import NotificationModal from '../common/NotificationModal.vue';

const store = useMainStore();

const props = defineProps({
  documentType: {
    type: String,
    required: true,
    validator: value => ['devis', 'facture'].includes(value)
  },
  templateId: {
    type: Number,
    required: true
  }
});

const emit = defineEmits(['back', 'continue', 'save']);

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
    id: null, // Ajout de l'ID de l'entreprise
    nom: '',
    adresse: '',
    email: '',
    siret: '',
    telephone: ''
  },
  client: {
    id: null, // Ajout de l'ID du client
    nom: '',
    adresse: '',
    telephone: '',
    email: ''
  },
  produits: [
    {
      id: null, // Ajout de l'ID du produit
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
    date: new Date().toISOString().split('T')[0], // Date du jour au format YYYY-MM-DD
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

// Fonction pour récupérer les informations de l'entreprise de l'utilisateur connecté
const fetchEnterpriseData = async () => {
  try {
    // Si l'utilisateur est déjà dans le store et qu'il est un admin d'entreprise
    if (store.user && store.user.role === 'enterprise_admin') {
      // Si les informations d'entreprise sont déjà dans le store
      if (store.user.enterprise) {
        fillEnterpriseData(store.user.enterprise);
      } else {
        // Sinon, récupérer les informations d'entreprise depuis l'API
        const response = await api.get(`/api/users/profile/${store.user.id}`);
        if (response.data && response.data.user && response.data.user.enterprise) {
          fillEnterpriseData(response.data.user.enterprise);
        }
      }
    }
  } catch (error) {
    console.error('Erreur lors de la récupération des informations d\'entreprise:', error);
  }
};

// Fonction pour remplir les champs d'entreprise avec les données récupérées
const fillEnterpriseData = (enterprise) => {
  formData.value.entreprise.id = enterprise.id || null; // Stocker l'ID de l'entreprise
  formData.value.entreprise.nom = enterprise.nom_entreprise || '';
  // Assembler l'adresse à partir des champs pays, ville et adresse
  const adresseParts = [];
  if (enterprise.adresse) adresseParts.push(enterprise.adresse);
  if (enterprise.ville) adresseParts.push(enterprise.ville);
  if (enterprise.pays) adresseParts.push(enterprise.pays);
  formData.value.entreprise.adresse = adresseParts.join(', ');
  
  formData.value.entreprise.email = enterprise.email_entreprise || '';
  formData.value.entreprise.siret = enterprise.siret || '';
  formData.value.entreprise.telephone = enterprise.telephone || '';
};

// Fonction pour rechercher un client par email
const searchClientByEmail = async () => {
  try {
    const email = formData.value.client.email.trim();
    
    // Si l'email est vide, ne pas effectuer de recherche
    // Réduit le minimum à 1 caractère pour permettre la recherche dès le début de la saisie
    if (!email) {
      searchResults.value = [];
      return;
    }
    
    // Rechercher les clients par email
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
  // Remplir les champs du formulaire avec les données du client sélectionné
  formData.value.client.id = client.id || null; // Stocker l'ID du client
  formData.value.client.email = client.email || '';
  formData.value.client.nom = `${client.name || ''} ${client.last_name || ''}`.trim();
  formData.value.client.adresse = client.address || '';
  formData.value.client.telephone = client.phone || '';
  
  // Vider les résultats de recherche
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
  
  // Initialiser les résultats de recherche pour ce nouveau produit
  productSearchResults.value[newIndex] = [];
};

// Fonction pour supprimer un produit
const removeProduit = (index) => {
  formData.value.produits.splice(index, 1);
  
  // Réorganiser les résultats de recherche après suppression
  const newProductSearchResults = {};
  formData.value.produits.forEach((_, i) => {
    if (productSearchResults.value[i + (i >= index ? 1 : 0)]) {
      newProductSearchResults[i] = productSearchResults.value[i + (i >= index ? 1 : 0)];
    } else {
      newProductSearchResults[i] = [];
    }
  });
  productSearchResults.value = newProductSearchResults;
};

// Fonction pour revenir à l'étape précédente
const goBack = () => {
  emit('back');
};

// Fonction pour enregistrer le document
const saveDocument = () => {
  if (validateForm()) {
    // Ajouter le callback de notification aux données
    const dataWithCallback = {
      ...formData.value,
      notificationCallback: (type, title, message) => {
        showNotification(title, message, type);
      }
    };
    emit('save', dataWithCallback);
  } else {
    // Afficher une notification d'erreur pour les erreurs de validation
    showNotification(
      'Erreur de validation', 
      'Veuillez corriger les erreurs dans le formulaire avant de continuer.', 
      'error'
    );
    
    // Faire défiler jusqu'au premier message d'erreur
    setTimeout(() => {
      const firstErrorElement = document.querySelector('.has-error');
      if (firstErrorElement) {
        firstErrorElement.scrollIntoView({ behavior: 'smooth', block: 'center' });
      }
    }, 100);
  }
};

// Fonction pour continuer à l'étape suivante
const continueToNextStep = () => {
  if (validateForm()) {
    // Ajouter le callback de notification aux données
    const dataWithCallback = {
      ...formData.value,
      notificationCallback: (type, title, message) => {
        showNotification(title, message, type);
      }
    };
    emit('continue', dataWithCallback);
  } else {
    // Afficher une notification d'erreur pour les erreurs de validation
    showNotification(
      'Erreur de validation', 
      'Veuillez corriger les erreurs dans le formulaire avant de continuer.', 
      'error'
    );
    
    // Faire défiler jusqu'au premier message d'erreur
    setTimeout(() => {
      const firstErrorElement = document.querySelector('.has-error');
      if (firstErrorElement) {
        firstErrorElement.scrollIntoView({ behavior: 'smooth', block: 'center' });
      }
    }, 100);
  }
};

// Remplir automatiquement les champs d'entreprise au chargement du composant
onMounted(() => {
  fetchEnterpriseData();
  
  // Initialiser les résultats de recherche pour le produit par défaut
  productSearchResults.value[0] = [];
  
  // Calculer les totaux initiaux
  calculateTotals();
});

// Fonction pour rechercher un produit par nom
const searchProductByName = async (index) => {
  try {
    const name = formData.value.produits[index].nom.trim();
    
    // Si le nom est vide, ne pas effectuer de recherche
    if (!name) {
      productSearchResults.value[index] = [];
      return;
    }
    
    // Rechercher les produits par nom
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
  
  // Remplir les champs du formulaire avec les données du produit sélectionné
  formData.value.produits[index].id = product.id || null; // Stocker l'ID du produit
  formData.value.produits[index].nom = product.name || '';
  formData.value.produits[index].prixUnitaire = product.unit_price || 0;
  
  // Conserver la référence actuelle au lieu de la remplacer par celle du produit
  // formData.value.produits[index].reference = product.reference || '';
  
  // Calculer le total HT
  calculateTotalHT(index);
  
  // Vider les résultats de recherche
  productSearchResults.value[index] = [];
};

// Fonction pour calculer le total HT d'un produit
const calculateTotalHT = (index) => {
  const produit = formData.value.produits[index];
  produit.totalHT = produit.quantite * produit.prixUnitaire;
  
  // Recalculer les totaux après modification d'un produit
  calculateTotals();
};

// Fonction pour calculer tous les totaux
const calculateTotals = () => {
  // Calculer le Total HT (somme des Total HT de chaque produit)
  formData.value.calculs.totalHT = formData.value.produits.reduce(
    (sum, produit) => sum + (produit.totalHT || 0), 0
  );
  
  // Calculer le Total Net HT (Total HT - Total Remise)
  formData.value.calculs.totalNetHT = formData.value.calculs.totalHT - (formData.value.calculs.totalRemise || 0);
  
  // Calculer le Total TTC (Total Net HT + Total TVA)
  formData.value.calculs.totalTTC = formData.value.calculs.totalNetHT + (formData.value.calculs.totalTVA || 0);
};

// Surveiller les changements sur Total Remise et Total TVA pour recalculer les totaux
watch(() => formData.value.calculs.totalRemise, () => {
  calculateTotals();
});

watch(() => formData.value.calculs.totalTVA, () => {
  calculateTotals();
});
</script>

<style scoped>
.manual-fill-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 2rem;
  background-color: #f9fafc;
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
  background: none;
  border: none;
  color: #dc3545;
  cursor: pointer;
  font-size: 1.1rem;
  padding: 0.25rem;
  transition: color 0.3s;
}

.remove-product-btn:hover {
  color: #bd2130;
}

.add-product-btn {
  background-color: #f8f9fa;
  border: 1px dashed #ccc;
  border-radius: 6px;
  color: #002446;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  padding: 0.75rem;
  width: 100%;
  font-weight: 500;
  transition: all 0.3s;
}

.add-product-btn:hover {
  background-color: #e9ecef;
  border-color: #002446;
}

.action-buttons {
  display: flex;
  justify-content: space-between;
  margin-top: 2rem;
}

.back-button, .save-button, .continue-button {
  padding: 0.75rem 1.5rem;
  border-radius: 6px;
  font-weight: 600;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  transition: all 0.3s;
}

.back-button {
  background-color: #f8f9fa;
  border: 1px solid #ddd;
  color: #555;
}

.back-button:hover {
  background-color: #e9ecef;
}

.save-button {
  background-color: #28a745;
  border: none;
  color: white;
}

.save-button:hover {
  background-color: #218838;
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.continue-button {
  background: linear-gradient(135deg, #002446, #003a6c);
  border: none;
  color: white;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.continue-button:hover {
  background: linear-gradient(135deg, #003a6c, #004d8f);
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.email-search-container,
.product-search-container {
  position: relative;
}

.search-results {
  position: absolute;
  top: 100%;
  left: 0;
  right: 0;
  background-color: white;
  border: 1px solid #ddd;
  border-radius: 0 0 6px 6px;
  max-height: 200px;
  overflow-y: auto;
  z-index: 10;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.search-result-item {
  padding: 0.75rem;
  cursor: pointer;
  transition: background-color 0.3s;
}

.search-result-item:hover {
  background-color: #f5f5f5;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}
</style>