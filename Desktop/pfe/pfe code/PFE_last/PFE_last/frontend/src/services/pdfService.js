/**
 * Service pour la génération et la gestion des PDF
 */
export default {
  /**
   * Génère un PDF pour un document
   * @param {Object} document - Le document pour lequel générer un PDF
   * @returns {String} - URL du PDF généré (simulée)
   */
  generatePDF(document) {
    // Dans une application réelle, on utiliserait une bibliothèque comme jsPDF ou pdfmake
    // pour générer un vrai PDF côté client, ou on appellerait une API backend
    
    // Pour la démo, on simule une URL de PDF
    const pdfUrl = this.getStaticPdfUrl(document);
    console.log(`PDF généré pour le document ${document.id}: ${pdfUrl}`);
    return pdfUrl;
  },
  
  /**
   * Retourne une URL statique de PDF pour la démo
   * @param {Object} document - Le document
   * @returns {String} - URL du PDF
   */
  getStaticPdfUrl(document) {
    // Pour la démo, on utilise des PDF statiques selon le type de document
    const type = document.type === 'invoice' ? 'facture' : 'devis';
    const status = document.status;
    
    // Exemples de PDF avec des données réelles pour les factures et devis
    // Ces URLs pointent vers des PDF qui contiennent des données représentatives
    const pdfExamples = {
      invoice: {
        // Factures avec différents statuts
        draft: 'https://documentcloud.adobe.com/view-sdk-demo/PDFs/Bodea%20Brochure.pdf',
        sent: 'https://www.adobe.com/support/products/enterprise/knowledgecenter/media/c4611_sample_explain.pdf',
        paid: 'https://www.sage.com/fr-fr/blog/wp-content/uploads/sites/19/2021/07/Exemple-facture-Sage.pdf',
        overdue: 'https://www.cours-gratuit.com/templates-factures/modele-de-facture-gratuit-a-telecharger-sous-format-pdf',
        cancelled: 'https://www.manager-go.com/assets/Uploads/facture-annulee-exemple.pdf'
      },
      quote: {
        // Devis avec différents statuts
        draft: 'https://www.manager-go.com/assets/Uploads/devis-exemple-modele.pdf',
        sent: 'https://www.cours-gratuit.com/templates-devis/exemple-de-devis-gratuit-a-telecharger-sous-format-pdf',
        accepted: 'https://www.zervant.com/wp-content/uploads/2020/01/exemple-de-devis.pdf',
        rejected: 'https://www.petite-entreprise.net/images/Exemple-devis-travaux.pdf',
        expired: 'https://www.petite-entreprise.net/images/Exemple-devis-prestation-de-service.pdf'
      }
    };
    
    // Retourner l'URL correspondante ou une URL par défaut
    return pdfExamples[document.type]?.[status] || 'https://www.africau.edu/images/default/sample.pdf';
  },
  
  /**
   * Simule l'ouverture d'un PDF dans un nouvel onglet
   * @param {String} pdfUrl - URL du PDF à ouvrir
   */
  openPdfInNewTab(pdfUrl) {
    window.open(pdfUrl, '_blank');
  }
};