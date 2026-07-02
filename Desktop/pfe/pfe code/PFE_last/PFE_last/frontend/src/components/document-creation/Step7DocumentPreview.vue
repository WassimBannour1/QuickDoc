<template>
  <div class="document-preview-container">
    <h2 class="page-title">{{ documentTypeLabel }} - Aperçu Final</h2>
    
    <div class="preview-actions">
      <button class="action-button back-button" @click="goBack">
        <i class="fas fa-arrow-left"></i> Retour
      </button>
      <button class="action-button pdf-button" @click="exportToPdf">
        <i class="fas fa-file-pdf"></i> Archiver document
      </button>
    </div>
    
    <!-- Affichage du document avec le template sélectionné -->
    <div v-if="loading" class="loading-container">
      <div class="spinner"></div>
      <p>Chargement du template...</p>
    </div>
    
    <div v-else-if="error" class="error-container">
      <i class="fas fa-exclamation-circle"></i>
      <p>{{ errorMessage }}</p>
      <button class="action-button" @click="loadTemplate">Réessayer</button>
    </div>
    
    <div v-else>
      <!-- Container unique pour le template (personnalisé ou par défaut) -->
      <div class="template-container" ref="documentPreview">
        <!-- Rendu du template personnalisé si disponible -->
        <div v-if="templateLoaded" v-html="renderedTemplate"></div>
        
        <!-- Rendu par défaut si aucun template n'est disponible -->
        <div v-else>
        <!-- En-tête du document -->
        <div class="document-header">
          <div class="company-info">
            <h3>{{ documentData.entreprise.nom }}</h3>
            <p>{{ documentData.entreprise.adresse }}</p>
            <p>Email: {{ documentData.entreprise.email }}</p>
            <p>Tél: {{ documentData.entreprise.telephone }}</p>
            <p>SIRET: {{ documentData.entreprise.siret }}</p>
          </div>
          
          <div class="document-info">
            <h2>{{ documentTypeLabel.toUpperCase() }}</h2>
            <p>N° {{ documentData.document.numeroSerie }}</p>
            <p>Date: {{ formatDate(documentData.document.date) }}</p>
          </div>
        </div>
        
        <!-- Informations client -->
        <div class="client-info">
          <h4>Client</h4>
          <p><strong>{{ documentData.client.nom }}</strong></p>
          <p>{{ documentData.client.adresse }}</p>
          <p>Email: {{ documentData.client.email }}</p>
          <p>Tél: {{ documentData.client.telephone }}</p>
        </div>
        
        <!-- Tableau des produits -->
        <div class="products-table-container">
          <table class="products-table">
            <thead>
              <tr>
                <th>Référence</th>
                <th>Description</th>
                <th>Quantité</th>
                <th>Prix unitaire HT</th>
                <th>TVA (%)</th>
                <th>Total HT</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(produit, index) in documentData.produits" :key="index">
                <td>{{ produit.reference }}</td>
                <td>{{ produit.nom }}</td>
                <td>{{ produit.quantite }}</td>
                <td>{{ formatCurrency(produit.prixUnitaire) }}</td>
                <td>{{ produit.tvaPercentage }}%</td>
                <td>{{ formatCurrency(produit.totalHT) }}</td>
              </tr>
            </tbody>
          </table>
        </div>
        
        <!-- Récapitulatif des totaux -->
        <div class="totals-summary">
          <div class="total-row">
            <span>Total HT:</span>
            <span>{{ formatCurrency(documentData.calculs.totalHT) }}</span>
          </div>
          <div class="total-row">
            <span>Remise:</span>
            <span>{{ formatCurrency(documentData.calculs.totalRemise) }}</span>
          </div>
          <div class="total-row">
            <span>Total Net HT:</span>
            <span>{{ formatCurrency(documentData.calculs.totalNetHT) }}</span>
          </div>
          <div class="total-row">
            <span>TVA:</span>
            <span>{{ formatCurrency(documentData.calculs.totalTVA) }}</span>
          </div>
          <div class="total-row total-ttc">
            <span>Total TTC:</span>
            <span>{{ formatCurrency(documentData.calculs.totalTTC) }}</span>
          </div>
        </div>
        
        <!-- Informations bancaires -->
        <div class="bank-info" v-if="documentData.detailsBancaires.informations">
          <h4>Informations bancaires</h4>
          <p>{{ documentData.detailsBancaires.informations }}</p>
        </div>
        
        <!-- Avertissement / Conditions -->
        <div class="warning-info" v-if="documentData.avertissement.message">
          <h4>Conditions</h4>
          <p>{{ documentData.avertissement.message }}</p>
        </div>
      </div>
      </div>
    </div>
    
    <!-- Modale pour la génération du PDF -->
    <ModalStep7 
      :visible="showModal" 
      :isGenerating="pdfGenerating"
      :isComplete="pdfComplete"
      :hasError="pdfError"
      @close="closeModal"
      @goToStart="goToStart"
      @viewDocuments="viewDocuments"
    />
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue';
import html2pdf from 'html2pdf.js';
import { getTemplateById } from '@/services/templateService';
import ModalStep7 from './ModalStep7.vue';
import { useRouter } from 'vue-router';

const props = defineProps({
  documentType: {
    type: String,
    required: true,
    validator: value => ['devis', 'facture'].includes(value)
  },
  documentData: {
    type: Object,
    required: true
  },
  templateId: {
    type: Number,
    required: false,
    default: null
  }
});

const emit = defineEmits(['back', 'goToStep1']);
const router = useRouter();

// État pour le chargement du template
const loading = ref(false);
const error = ref(false);
const errorMessage = ref('');
const templateLoaded = ref(false);
const templateDetails = ref(null);
const renderedTemplate = ref('');
const documentPreview = ref(null);

// État pour la modale de génération PDF
const showModal = ref(false);
const pdfGenerating = ref(false);
const pdfComplete = ref(false);
const pdfError = ref(false);

// Libellé du type de document (pour l'affichage)
const documentTypeLabel = computed(() => {
  return props.documentType === 'facture' ? 'Facture' : 'Devis';
});

// Fonction pour formater les dates
const formatDate = (dateString) => {
  if (!dateString) return '';
  
  const date = new Date(dateString);
  return new Intl.DateTimeFormat('fr-FR', {
    day: '2-digit',
    month: '2-digit',
    year: 'numeric'
  }).format(date);
};

// Fonction pour formater les montants en devise
const formatCurrency = (amount) => {
  if (amount === undefined || amount === null) return '0,00 €';
  
  return new Intl.NumberFormat('fr-FR', {
    style: 'currency',
    currency: 'EUR'
  }).format(amount);
};

// Fonction pour revenir à l'étape précédente
const goBack = () => {
  emit('back');
};

// Fonctions pour la modale
const closeModal = () => {
  showModal.value = false;
  pdfGenerating.value = false;
  pdfComplete.value = false;
  pdfError.value = false;
};

const goToStart = () => {
  // Au lieu de naviguer directement, émettre un événement que le parent peut écouter
  emit('goToStep1');
};

const viewDocuments = () => {
  // Rediriger vers la liste des documents (étape 2)
  router.push({ 
    name: 'document-creation', 
    params: { 
      step: 2,
      type: props.documentType
    } 
  });
};

// Fonction pour charger les détails du template
const loadTemplate = async () => {
  if (!props.templateId) {
    templateLoaded.value = false;
    return;
  }
  
  loading.value = true;
  error.value = false;
  errorMessage.value = '';
  
  try {
    const response = await getTemplateById(props.templateId);
    if (response && response.data) {
      templateDetails.value = response.data;
      generateTemplateHtml();
      templateLoaded.value = true;
    } else {
      throw new Error('Impossible de récupérer les détails du template');
    }
  } catch (err) {
    console.error('Erreur lors du chargement du template:', err);
    error.value = true;
    errorMessage.value = 'Erreur lors du chargement du template. Veuillez réessayer.';
    templateLoaded.value = false;
  } finally {
    loading.value = false;
  }
};

// Fonction pour générer le HTML du template avec les données du document
const generateTemplateHtml = () => {
  if (!templateDetails.value) return;
  
  try {
    // Récupérer la configuration du design
    let designConfig = templateDetails.value.design_config;
    if (typeof designConfig === 'string') {
      designConfig = JSON.parse(designConfig);
    }
    
    // Créer le HTML de base
    let html = `
      <div style="position: relative; width: 794px; height: 1123px; margin: 0; padding: 0; box-sizing: border-box; background-color: white;">
        <meta charset="UTF-8">
        <title>${documentTypeLabel.value} ${props.documentData.document.numeroSerie}</title>
        <style>
          * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
          }
          body {
            font-family: ${designConfig.typography?.fontFamily || 'Arial, sans-serif'};
            margin: 0;
            padding: 0;
            color: ${designConfig.colors?.text || '#333333'};
          }
          .template-element {
            position: absolute;
            max-width: calc(100% - 40px);
            word-wrap: break-word;
            overflow-wrap: break-word;
          }
        </style>
    `;
    
    // Ajouter les éléments du template
    if (designConfig.elements && Array.isArray(designConfig.elements)) {
      designConfig.elements.forEach(element => {
        // Remplacer les placeholders par les données réelles
        let content = element.content || '';
        
        // Remplacer les placeholders par les données du document
        content = replacePlaceholders(content, props.documentData);
        
        // Générer le HTML pour chaque type d'élément
        if (element.type === 'table' && element.id === 'tab') {
          // Générer le tableau des produits
          html += generateProductsTable(element, props.documentData.produits);
        } else if (element.type === 'placeholder') {
          // Générer les éléments placeholder avec les données réelles
          html += `
            <div class="template-element" style="
              position: absolute;
              left: ${element.x}px;
              top: ${element.y}px;
              font-size: ${element.fontSize}px;
              color: ${element.color};
              text-align: ${element.textAlign};
              font-family: ${element.fontFamily};
              font-weight: ${element.fontWeight};
              font-style: ${element.fontStyle};
              text-decoration: ${element.textDecoration};
              background-color: ${element.backgroundColor};
              padding: 5px;
              max-width: calc(100% - ${element.x}px - 40px);
            ">
              ${content}
            </div>
          `;
        } else if (element.type === 'text') {
          // Générer les éléments texte
          html += `
            <div class="template-element" style="
              position: absolute;
              left: ${element.x}px;
              top: ${element.y}px;
              font-size: ${element.fontSize}px;
              color: ${element.color};
              text-align: ${element.textAlign};
              font-family: ${element.fontFamily};
              font-weight: ${element.fontWeight};
              font-style: ${element.fontStyle};
              text-decoration: ${element.textDecoration};
              background-color: ${element.backgroundColor};
              padding: 5px;
              max-width: calc(100% - ${element.x}px - 40px);
            ">
              ${content}
            </div>
          `;
        } else if (element.type === 'divider') {
          // Générer les séparateurs
          html += `
            <div class="template-element" style="
              position: absolute;
              left: ${element.x}px;
              top: ${element.y}px;
              width: ${Math.min(element.width, 100 - element.x)}%;
            ">
              <hr style="
                height: ${element.height}px;
                border: none;
                background-color: ${element.color};
                border-top: ${element.height}px ${element.borderStyle} ${element.color};
              ">
            </div>
          `;
        } else if (element.type === 'logo') {
          // Générer le logo
          html += `
            <div class="template-element" style="
              position: absolute;
              left: ${element.x}px;
              top: ${element.y}px;
            ">
              <img src="${element.src}" style="width: ${element.width}px; max-width: calc(100% - ${element.x}px - 40px);" alt="Logo">
            </div>
          `;
        }
      });
    }
    
    // Fermer le HTML
    html += `
    </div>
    `;
    
    renderedTemplate.value = html;
  } catch (err) {
    console.error('Erreur lors de la génération du HTML du template:', err);
    error.value = true;
    errorMessage.value = 'Erreur lors de la génération du document. Veuillez réessayer.';
    templateLoaded.value = false;
  }
};

// Fonction pour générer le tableau des produits
const generateProductsTable = (tableElement, produits) => {
  if (!tableElement || !produits || !produits.length) return '';
  
  let tableHtml = `
    <div class="template-element" style="
      position: absolute;
      left: ${tableElement.x}px;
      top: ${tableElement.y}px;
      width: ${tableElement.width}px;
    ">
      <table style="
        width: 100%;
        border-collapse: collapse;
        border-spacing: 0;
        border: ${tableElement.borderWidth}px ${tableElement.borderStyle} ${tableElement.borderColor};
      ">
        <thead>
          <tr>
  `;
  
  // En-têtes du tableau
  const headers = tableElement.headers || ['REF', 'Détails', 'Quantité', 'PU HT', 'Total HT', 'TVA'];
  headers.forEach(header => {
    tableHtml += `
      <th style="
        padding: ${tableElement.cellPadding}px;
        background-color: ${tableElement.headerBackgroundColor};
        border: ${tableElement.borderWidth}px ${tableElement.borderStyle} ${tableElement.borderColor};
        text-align: ${tableElement.textAlign};
        color: ${tableElement.color};
        font-family: ${tableElement.fontFamily};
        font-size: ${tableElement.fontSize}px;
      ">${header}</th>
    `;
  });
  
  tableHtml += `
          </tr>
        </thead>
        <tbody>
  `;
  
  // Lignes de produits
  produits.forEach((produit, index) => {
    tableHtml += `
      <tr>
        <td style="
          padding: ${tableElement.cellPadding}px;
          background-color: ${tableElement.cellBackgroundColor};
          border: ${tableElement.borderWidth}px ${tableElement.borderStyle} ${tableElement.borderColor};
          text-align: ${tableElement.textAlign};
          color: ${tableElement.color};
          font-family: ${tableElement.fontFamily};
          font-size: ${tableElement.fontSize}px;
        ">${produit.reference}</td>
        <td style="
          padding: ${tableElement.cellPadding}px;
          background-color: ${tableElement.cellBackgroundColor};
          border: ${tableElement.borderWidth}px ${tableElement.borderStyle} ${tableElement.borderColor};
          text-align: ${tableElement.textAlign};
          color: ${tableElement.color};
          font-family: ${tableElement.fontFamily};
          font-size: ${tableElement.fontSize}px;
        ">${produit.nom}</td>
        <td style="
          padding: ${tableElement.cellPadding}px;
          background-color: ${tableElement.cellBackgroundColor};
          border: ${tableElement.borderWidth}px ${tableElement.borderStyle} ${tableElement.borderColor};
          text-align: ${tableElement.textAlign};
          color: ${tableElement.color};
          font-family: ${tableElement.fontFamily};
          font-size: ${tableElement.fontSize}px;
        ">${produit.quantite}</td>
        <td style="
          padding: ${tableElement.cellPadding}px;
          background-color: ${tableElement.cellBackgroundColor};
          border: ${tableElement.borderWidth}px ${tableElement.borderStyle} ${tableElement.borderColor};
          text-align: ${tableElement.textAlign};
          color: ${tableElement.color};
          font-family: ${tableElement.fontFamily};
          font-size: ${tableElement.fontSize}px;
        ">${formatCurrency(produit.prixUnitaire)}</td>
        <td style="
          padding: ${tableElement.cellPadding}px;
          background-color: ${tableElement.cellBackgroundColor};
          border: ${tableElement.borderWidth}px ${tableElement.borderStyle} ${tableElement.borderColor};
          text-align: ${tableElement.textAlign};
          color: ${tableElement.color};
          font-family: ${tableElement.fontFamily};
          font-size: ${tableElement.fontSize}px;
        ">${formatCurrency(produit.totalHT)}</td>
        <td style="
          padding: ${tableElement.cellPadding}px;
          background-color: ${tableElement.cellBackgroundColor};
          border: ${tableElement.borderWidth}px ${tableElement.borderStyle} ${tableElement.borderColor};
          text-align: ${tableElement.textAlign};
          color: ${tableElement.color};
          font-family: ${tableElement.fontFamily};
          font-size: ${tableElement.fontSize}px;
        ">${produit.tvaPercentage}%</td>
      </tr>
    `;
  });
  
  tableHtml += `
        </tbody>
      </table>
    </div>
  `;
  
  return tableHtml;
};

// Fonction pour remplacer les placeholders par les données réelles
const replacePlaceholders = (content, data) => {
  if (!content) return '';
  
  // Remplacer les placeholders de l'entreprise
  content = content.replace(/{{company_name}}/g, data.entreprise.nom || '');
  content = content.replace(/{{company_address}}/g, data.entreprise.adresse || '');
  content = content.replace(/{{company_phone}}/g, data.entreprise.telephone || '');
  content = content.replace(/{{company_email}}/g, data.entreprise.email || '');
  content = content.replace(/{{company_siret}}/g, data.entreprise.siret || '');
  
  // Remplacer les placeholders du client
  content = content.replace(/{{client_name}}/g, data.client.nom || '');
  content = content.replace(/{{client_fullname}}/g, data.client.nom || ''); // Ajout pour compatibilité
  content = content.replace(/{{client_address}}/g, data.client.adresse || '');
  content = content.replace(/{{client_phone}}/g, data.client.telephone || '');
  content = content.replace(/{{client_email}}/g, data.client.email || '');
  
  // Remplacer les placeholders du document
  content = content.replace(/{{document_number}}/g, data.document.numeroSerie || '');
  content = content.replace(/{{document_date}}/g, formatDate(data.document.date) || '');
  
  // Remplacer les placeholders des totaux
  content = content.replace(/{{total_ht}}/g, formatCurrency(data.calculs.totalHT) || '');
  content = content.replace(/{{total_net_ht}}/g, formatCurrency(data.calculs.totalNetHT) || '');
  content = content.replace(/{{total_discount}}/g, formatCurrency(data.calculs.totalRemise) || '');
  content = content.replace(/{{tva}}/g, formatCurrency(data.calculs.totalTVA) || '');
  content = content.replace(/{{total_ttc}}/g, formatCurrency(data.calculs.totalTTC) || '');
  
  // Remplacer les placeholders des informations bancaires et avertissement
  // Pour les informations bancaires
  if (data.detailsBancaires && data.detailsBancaires.informations) {
    content = content.replace(/{{bank_info}}/g, data.detailsBancaires.informations);
  } else {
    // Si pas d'informations bancaires, laisser le placeholder vide
    content = content.replace(/{{bank_info}}/g, '');
  }
  
  // Pour les avertissements
  if (data.avertissement && data.avertissement.message) {
    content = content.replace(/{{warning}}/g, data.avertissement.message);
    content = content.replace(/{{avertissement}}/g, data.avertissement.message);
  } else {
    // Si pas d'avertissement, laisser les placeholders vides
    content = content.replace(/{{warning}}/g, '');
    content = content.replace(/{{avertissement}}/g, '');
  }
  
  return content;
};

// Fonction pour exporter le document en PDF
const exportToPdf = () => {
  const element = templateLoaded.value ? documentPreview.value : document.querySelector('.template-container');
  const fileName = `${documentTypeLabel.value}_${props.documentData.document.numeroSerie}.pdf`;
  const opt = {
    margin: 0,
    filename: fileName,
    image: { type: 'jpeg', quality: 0.98 },
    html2canvas: { 
      scale: 2,
      useCORS: true,
      letterRendering: true,
      allowTaint: true,
      scrollX: 0,
      scrollY: 0
    },
    jsPDF: { 
      unit: 'mm', 
      format: 'a4', 
      orientation: 'portrait',
      precision: 16
    },
    // Ne pas déclencher le téléchargement automatique car nous allons envoyer le PDF au serveur
    autoPrint: false
  };
  
  // Afficher la modale avec l'état de génération
  showModal.value = true;
  pdfGenerating.value = true;
  pdfComplete.value = false;
  pdfError.value = false;
  
  // Importer le service d'archivage PDF
  import('@/services/pdfArchiveService').then(({ archivePdf }) => {
    // Génération du PDF
    html2pdf().set(opt).from(element).outputPdf('blob').then(async (pdfBlob) => {
      try {
        // Récupérer l'ID du remplissage s'il est disponible dans les données du document
        const remplissageId = props.documentData?.remplissage?.id || props.documentData?.id || null;
        console.log('Remplissage ID pour archivage:', remplissageId);
        
        // Archiver le PDF sur le serveur avec l'ID du remplissage
        await archivePdf(pdfBlob, fileName, remplissageId);
        
        // Télécharger également le PDF pour l'utilisateur
        const url = URL.createObjectURL(pdfBlob);
        const link = document.createElement('a');
        link.href = url;
        link.download = fileName;
        link.click();
        URL.revokeObjectURL(url);
        
        // Mise à jour de l'état de la modale pour indiquer que la génération est terminée
        pdfGenerating.value = false;
        pdfComplete.value = true;
      } catch (error) {
        console.error('Erreur lors de l\'archivage du PDF:', error);
        pdfGenerating.value = false;
        pdfError.value = true;
      }
    }).catch(error => {
      console.error('Erreur lors de la génération du PDF:', error);
      pdfGenerating.value = false;
      pdfError.value = true;
    });
  }).catch(error => {
    console.error('Erreur lors du chargement du service d\'archivage:', error);
    pdfGenerating.value = false;
    pdfError.value = true;
  });
};

// Charger le template au montage du composant
onMounted(() => {
  loadTemplate();
});

// Surveiller les changements de templateId
watch(() => props.templateId, (newVal) => {
  if (newVal) {
    loadTemplate();
  }
});
</script>

<style scoped>
.document-preview-container {
  margin: 0 auto;
  padding: 2rem;
  background-color: transparent;
}

/* 
  Template Container - Dimensions A4 fixes
  - Largeur: 210mm ≈ 794px à 96 DPI
  - Hauteur: 297mm ≈ 1123px à 96 DPI
  Ces dimensions fixes garantissent que ce que l'utilisateur voit est exactement 
  ce qui sera imprimé sur une page A4 réelle (WYSIWYG - What You See Is What You Get).
*/
.template-container {
  width: 794px; /* A4 width at 96 DPI */
  height: 1123px; /* A4 height at 96 DPI */
  margin: 0 auto;
  background-color: white;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
  position: relative;
  overflow: hidden; /* Prevent content from overflowing */
  box-sizing: border-box;
  border: 1px solid #ddd;
  padding: 0; /* Removed padding to prevent shifting */
  margin-bottom: 2rem;
}

.page-title {
  color: #002446;
  font-size: 2rem;
  font-weight: 700;
  margin-bottom: 2rem;
  text-align: center;
}

.preview-actions {
  display: flex;
  justify-content: space-between;
  margin-bottom: 2rem;
}

.action-button {
  padding: 0.8rem 1.5rem;
  border-radius: 5px;
  font-size: 1rem;
  font-weight: 500;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  transition: all 0.3s ease;
  border: none;
}

.back-button {
  background-color: #f5f5f5;
  color: #333;
  border: 1px solid #ddd;
}

.back-button:hover {
  background-color: #e5e5e5;
}

.pdf-button {
  background: linear-gradient(135deg, #002446, #003a6c);
  color: white;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.pdf-button:hover {
  background: linear-gradient(135deg, #003a6c, #004d8f);
  transform: translateY(-2px);
  box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
}

/* Les styles pour .template-container sont maintenant définis plus haut */

.document-header {
  display: flex;
  justify-content: space-between;
  margin-bottom: 3rem;
  padding-bottom: 1.5rem;
  border-bottom: 1px solid #eee;
}

.company-info h3 {
  font-size: 1.5rem;
  color: #002446;
  margin-bottom: 0.5rem;
}

.company-info p {
  margin: 0.2rem 0;
  color: #555;
}

.document-info {
  text-align: right;
}

.document-info h2 {
  font-size: 1.8rem;
  color: #002446;
  margin-bottom: 0.5rem;
}

.document-info p {
  margin: 0.2rem 0;
  color: #555;
}

.client-info {
  background-color: #f9fafc;
  padding: 1.5rem;
  border-radius: 8px;
  margin-bottom: 2rem;
}

.client-info h4 {
  font-size: 1.2rem;
  color: #002446;
  margin-bottom: 0.8rem;
}

.client-info p {
  margin: 0.3rem 0;
  color: #555;
}

.products-table-container {
  margin-bottom: 2rem;
  overflow-x: auto;
}

.products-table {
  width: 100%;
  border-collapse: collapse;
  margin-bottom: 1.5rem;
}

.products-table th {
  background-color: #f5f5f5;
  padding: 1rem;
  text-align: left;
  font-weight: 600;
  color: #333;
  border-bottom: 2px solid #ddd;
}

.products-table td {
  padding: 1rem;
  border-bottom: 1px solid #eee;
  color: #555;
}

.totals-summary {
  margin-left: auto;
  width: 300px;
  margin-bottom: 2rem;
}

.total-row {
  display: flex;
  justify-content: space-between;
  padding: 0.7rem 0;
  border-bottom: 1px solid #eee;
}

.total-row.total-ttc {
  font-weight: 700;
  font-size: 1.2rem;
  color: #002446;
  border-bottom: 2px solid #002446;
  padding: 1rem 0;
}

.bank-info, .warning-info {
  margin-top: 2rem;
  padding: 1.5rem;
  border-radius: 8px;
  background-color: #f9fafc;
}

.bank-info h4, .warning-info h4 {
  font-size: 1.2rem;
  color: #002446;
  margin-bottom: 0.8rem;
}

.warning-info {
  background-color: #fff8e1;
  border-left: 4px solid #ffc107;
}

.loading-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 3rem;
  background-color: white;
  border-radius: 10px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
}

.spinner {
  border: 4px solid rgba(0, 0, 0, 0.1);
  border-radius: 50%;
  border-top: 4px solid #002446;
  width: 40px;
  height: 40px;
  animation: spin 1s linear infinite;
  margin-bottom: 1rem;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.error-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 3rem;
  background-color: white;
  border-radius: 10px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
  color: #e74c3c;
}

.error-container i {
  font-size: 3rem;
  margin-bottom: 1rem;
}

.error-container p {
  margin-bottom: 1.5rem;
  text-align: center;
}

@media print {
  .preview-actions {
    display: none;
  }
  
  .document-preview {
    box-shadow: none;
    padding: 0;
  }
  
  .page-title {
    display: none;
  }
}
</style>