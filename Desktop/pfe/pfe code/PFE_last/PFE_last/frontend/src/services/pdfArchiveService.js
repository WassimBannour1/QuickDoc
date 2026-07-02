import axios from 'axios';

/**
 * Service pour l'archivage des PDF dans le backend
 */
export const archivePdf = async (pdfBlob, fileName, remplissageId = null) => {
  try {
    // Créer un objet FormData pour envoyer le fichier
    const formData = new FormData();
    formData.append('pdf', pdfBlob, fileName);
    
    // Ajouter l'ID du remplissage s'il est fourni
    if (remplissageId) {
      formData.append('remplissageId', remplissageId);
    }
    
    // Obtenir le token d'authentification
    const token = localStorage.getItem('token');
    if (!token) {
      throw new Error('Vous devez être connecté pour archiver des documents');
    }
    
    // Envoyer la requête au backend
    const response = await axios.post('http://localhost:5000/api/protected/documents/archive', formData, {
      headers: {
        'Content-Type': 'multipart/form-data',
        'Authorization': `Bearer ${token}`
      }
    });
    
    return response.data;
  } catch (error) {
    console.error('Erreur lors de l\'archivage du PDF:', error);
    throw error;
  }
};