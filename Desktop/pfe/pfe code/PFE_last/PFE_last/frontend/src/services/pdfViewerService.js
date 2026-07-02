/**
 * Service pour la gestion de la visualisation des PDF
 */
export default {
  /**
   * Génère une URL pour visualiser un PDF avec le viewer intégré
   * @param {String} pdfUrl - URL du PDF à visualiser
   * @returns {String} - URL complète pour la visualisation
   */
  getViewerUrl(pdfUrl) {
    if (!pdfUrl) return '';
    
    // Utiliser Google PDF Viewer comme solution de repli
    return `https://docs.google.com/viewer?url=${encodeURIComponent(pdfUrl)}&embedded=true`;
  },
  
  /**
   * Génère une URL pour visualiser un PDF directement
   * @param {String} pdfUrl - URL du PDF à visualiser
   * @returns {String} - URL du PDF directement
   */
  getPdfJsViewerUrl(pdfUrl) {
    if (!pdfUrl) return '';
    
    // Retourner directement l'URL du PDF au lieu d'utiliser PDF.js hébergé sur mozilla.github.io
    // Cela évite les problèmes de CORS
    return pdfUrl;
  },
  
  /**
   * Détermine la meilleure méthode de visualisation en fonction du navigateur et de l'URL
   * @param {String} pdfUrl - URL du PDF à visualiser
   * @returns {String} - URL optimisée pour la visualisation
   */
  getOptimalViewerUrl(pdfUrl) {
    if (!pdfUrl) return '';
    
    // Vérifier si l'URL est déjà une URL de visualisation
    if (pdfUrl.includes('docs.google.com/viewer')) {
      return pdfUrl;
    }
    
    // Utiliser l'URL directe du PDF pour éviter les problèmes de CORS
    return this.getPdfJsViewerUrl(pdfUrl);
  }
};