import axios from 'axios';


const API_URL = 'http://localhost:5000/api/templates';

// Helper function for delay/timeout in async operations
const delay = (ms) => new Promise(resolve => setTimeout(resolve, ms));

// Get all templates
export const getAllTemplates = async () => {
  try {
    const token = localStorage.getItem('token');
    const response = await axios.get(API_URL, {
      headers: {
        Authorization: `Bearer ${token}`
      }
    });
    return response.data;
  } catch (error) {
    console.error('Error fetching templates:', error);
    throw error;
  }
};

// Get predefined templates
export const getPredefinedTemplates = async () => {
  try {
    console.log('Fetching predefined templates...');
    const token = localStorage.getItem('token');
    
    // Ajouter un timeout pour éviter que la requête reste bloquée indéfiniment
    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), 8000); // 8 secondes de timeout
    
    const response = await axios.get(`${API_URL}/predefined`, {
      headers: {
        Authorization: `Bearer ${token}`
      },
      signal: controller.signal
    });
    
    clearTimeout(timeoutId); // Annuler le timeout si la requête réussit
    
    console.log('Predefined templates fetched successfully:', response.data);
    
    // Si l'API renvoie un objet sans la propriété success, ajouter cette propriété
    if (response.data && !response.data.hasOwnProperty('success')) {
      return {
        success: true,
        data: Array.isArray(response.data) ? response.data : []
      };
    }
    
    return response.data;
  } catch (error) {
    console.error('Error fetching predefined templates:', error);
    // Retourner un objet avec success: false plutôt que de lancer une exception
    return {
      success: false,
      message: error.message || 'Erreur lors du chargement des modèles prédéfinis',
      error: error
    };
  }
};

// Get custom templates
export const getCustomTemplates = async (docType = null) => {
  try {
    console.log(`Fetching custom templates with docType: ${docType}...`);
    const token = localStorage.getItem('token');
    
    // Ajouter un timeout pour éviter que la requête reste bloquée indéfiniment
    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), 8000); // 8 secondes de timeout
    
    // Ensure consistent case for docType parameter (lowercase)
    const normalizedDocType = docType ? docType.toLowerCase() : null;
    
    // Remove docType filter to show all templates regardless of type
    const url = `${API_URL}/custom`;
    
    console.log(`Requesting URL: ${url}`);
    
    const response = await axios.get(url, {
      headers: {
        Authorization: `Bearer ${token}`
      },
      signal: controller.signal
    });
    
    clearTimeout(timeoutId); // Annuler le timeout si la requête réussit
    
    console.log('Custom templates fetched successfully:', response.data);
    
    // Si l'API renvoie un objet sans la propriété success, ajouter cette propriété
    if (response.data && !response.data.hasOwnProperty('success')) {
      // Filtrer les templates qui ont isdeleted = 1
      const allTemplates = Array.isArray(response.data) ? response.data : [];
      const activeTemplates = allTemplates.filter(template => template.isdeleted !== 1);
      
      console.log(`Filtrage des templates supprimés: ${allTemplates.length} templates au total, ${activeTemplates.length} templates actifs`);
      
      return {
        success: true,
        data: activeTemplates
      };
    }
    
    // Si l'API renvoie déjà un objet avec success, filtrer les templates supprimés
    if (response.data && response.data.success && Array.isArray(response.data.data)) {
      const filteredData = response.data.data.filter(template => template.isdeleted !== 1);
      return {
        ...response.data,
        data: filteredData
      };
    }
    
    return response.data;
  } catch (error) {
    console.error('Error fetching custom templates:', error);
    // Retourner un objet avec success: false plutôt que de lancer une exception
    return {
      success: false,
      message: error.message || 'Erreur lors du chargement des modèles personnalisés',
      error: error
    };
  }
};

// Get template by ID
export const getTemplateById = async (id) => {
  try {
    console.log(`Fetching template with ID ${id}...`);
    const token = localStorage.getItem('token');
    
    // Ajouter un timeout pour éviter que la requête reste bloquée indéfiniment
    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), 8000); // 8 secondes de timeout
    
    const response = await axios.get(`${API_URL}/${id}`, {
      headers: {
        Authorization: `Bearer ${token}`
      },
      signal: controller.signal
    });
    
    clearTimeout(timeoutId); // Annuler le timeout si la requête réussit
    
    console.log('Template fetched successfully:', response.data);
    
    // Si l'API renvoie un objet sans la propriété success, ajouter cette propriété
    if (response.data && !response.data.hasOwnProperty('success')) {
      return {
        success: true,
        data: response.data
      };
    }
    
    return response.data;
  } catch (error) {
    console.error(`Error fetching template with ID ${id}:`, error);
    
    // Gérer les différents types d'erreurs
    if (error.name === 'AbortError') {
      return {
        success: false,
        message: 'La requête a pris trop de temps à s\'exécuter. Veuillez réessayer.'
      };
    } else if (error.response) {
      // Erreur HTTP avec réponse du serveur
      return {
        success: false,
        message: error.response.data.message || `Erreur lors de la récupération du modèle (${error.response.status})`,
        status: error.response.status
      };
    } else if (error.request) {
      // Erreur réseau (pas de réponse du serveur)
      return {
        success: false,
        message: 'Impossible de se connecter au serveur. Veuillez vérifier votre connexion.'
      };
    } else {
      // Autre type d'erreur
      return {
        success: false,
        message: error.message || 'Erreur lors de la récupération du modèle'
      };
    }
  }
};

// Create new template
export const createTemplate = async (templateData) => {
  try {
    console.log('Creating new template:', templateData);
    const token = localStorage.getItem('token');
    
    // Ajouter un timeout de 8 secondes comme demandé
    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), 8000); // 8 secondes de timeout
    
    // Create FormData for file upload
    const formData = new FormData();
    
    // Vérifier explicitement le type et s'assurer qu'il est transmis correctement
    console.log('Frontend - Creating template with type:', templateData.type);
    
    // Add all template data to FormData
    Object.keys(templateData).forEach(key => {
      if (key === 'design_config' && typeof templateData[key] === 'object') {
        formData.append(key, JSON.stringify(templateData[key]));
      } else if (key === 'preview_image' && templateData[key] instanceof File) {
        formData.append('preview_image', templateData[key]);
      } else {
        formData.append(key, templateData[key]);
      }
    });
    
    try {
      const response = await axios.post(API_URL, formData, {
        headers: {
          Authorization: `Bearer ${token}`,
          'Content-Type': 'multipart/form-data'
        },
        signal: controller.signal
      });
      
      clearTimeout(timeoutId); // Annuler le timeout si la requête réussit
      
      console.log('Template created successfully:', response.data);
      
      // Si l'API renvoie un objet sans la propriété success, ajouter cette propriété
      if (response.data && !response.data.hasOwnProperty('success')) {
        return {
          success: true,
          message: 'Modèle créé avec succès',
          data: response.data
        };
      }
      
      return response.data;
    } catch (axiosError) {
      clearTimeout(timeoutId);
      
      console.error('Error creating template:', axiosError);
      
      // Handle HTTP error responses
      if (axiosError.response) {
        console.error('Server responded with an error:', axiosError.response.data);
        return {
          success: false,
          message: axiosError.response.data.message || 'Erreur lors de la création du template',
          error: axiosError.response.data
        };
      }
      
      // Handle network errors
      if (axiosError.request) {
        console.error('No response received from server');
        return {
          success: false,
          message: 'Aucune réponse du serveur. Veuillez vérifier votre connexion.',
          error: 'network_error'
        };
      }
      
      // Handle timeout errors
      if (axiosError.name === 'AbortError' || axiosError.code === 'ECONNABORTED') {
        console.error('Request timed out');
        return {
          success: false,
          message: 'La requête a pris trop de temps. Veuillez réessayer.',
          error: 'timeout'
        };
      }
      
      // Handle other errors
      return {
        success: false,
        message: axiosError.message || 'Une erreur inconnue est survenue',
        error: axiosError
      };
    }
  } catch (error) {
    console.error('Unexpected error in createTemplate service:', error);
    return {
      success: false,
      message: 'Une erreur inattendue est survenue',
      error: error
    };
  }
};

// Update template
export const updateTemplate = async (id, templateData) => {
  try {
    console.log('Updating template with ID:', id);
    const token = localStorage.getItem('token');
    
    // Ajouter un timeout pour éviter que la requête reste bloquée indéfiniment
    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), 8000); // 8 secondes de timeout
    
    // Create FormData for file upload
    const formData = new FormData();
    
    // Add all template data to FormData
    Object.keys(templateData).forEach(key => {
      if (key === 'design_config' && typeof templateData[key] === 'object') {
        formData.append(key, JSON.stringify(templateData[key]));
      } else if (key === 'preview_image' && templateData[key] instanceof File) {
        formData.append('preview_image', templateData[key]);
      } else {
        formData.append(key, templateData[key]);
      }
    });
    
    try {
      const response = await axios.put(`${API_URL}/${id}`, formData, {
        headers: {
          Authorization: `Bearer ${token}`,
          'Content-Type': 'multipart/form-data'
        },
        signal: controller.signal
      });
      
      clearTimeout(timeoutId); // Annuler le timeout si la requête réussit
      
      console.log('Template updated successfully:', response.data);
      
      // Si l'API renvoie un objet sans la propriété success, ajouter cette propriété
      if (response.data && !response.data.hasOwnProperty('success')) {
        return {
          success: true,
          message: 'Modèle mis à jour avec succès',
          data: response.data
        };
      }
      
      return response.data;
    } catch (axiosError) {
      clearTimeout(timeoutId);
      
      console.error('Error updating template:', axiosError);
      
      // Handle HTTP error responses
      if (axiosError.response) {
        console.error('Server responded with an error:', axiosError.response.data);
        return {
          success: false,
          message: axiosError.response.data.message || 'Erreur lors de la mise à jour du template',
          error: axiosError.response.data
        };
      }
      
      // Handle network errors
      if (axiosError.request) {
        console.error('No response received from server');
        return {
          success: false,
          message: 'Aucune réponse du serveur. Veuillez vérifier votre connexion.',
          error: 'network_error'
        };
      }
      
      // Handle timeout errors
      if (axiosError.name === 'AbortError' || axiosError.name === 'CanceledError' || axiosError.code === 'ECONNABORTED') {
        console.error('Request timed out');
        return {
          success: false,
          message: 'La requête a pris trop de temps. Veuillez réessayer.',
          error: 'timeout'
        };
      }
      
      // Handle other errors
      return {
        success: false,
        message: axiosError.message || 'Une erreur inconnue est survenue',
        error: axiosError
      };
    }
  } catch (error) {
    console.error(`Unexpected error in updateTemplate for ID ${id}:`, error);
    return {
      success: false,
      message: 'Une erreur inattendue est survenue',
      error: error
    };
  }
};

// Suppression logique du template (mise à jour du champ isdeleted à 1)
export const deleteTemplate = async (id) => {
  try {
    console.log('Marquage du template comme supprimé (ID:', id, ')');
    const token = localStorage.getItem('token');
    
    // Ajouter un timeout pour éviter que la requête reste bloquée indéfiniment
    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), 8000); // 8 secondes de timeout
    
    // Utiliser l'endpoint DELETE existant (qui a été modifié pour faire une suppression logique)
    const response = await axios.delete(`${API_URL}/${id}`, {
      headers: {
        Authorization: `Bearer ${token}`
      },
      signal: controller.signal
    });
    
    clearTimeout(timeoutId); // Annuler le timeout si la requête réussit
    
    console.log('Template marqué comme supprimé avec succès:', response.data);
    
    // Si l'API renvoie un objet sans la propriété success, ajouter cette propriété
    if (response.data && !response.data.hasOwnProperty('success')) {
      return {
        success: true,
        message: 'Modèle supprimé avec succès'
      };
    }
    
    return response.data;
  } catch (error) {
    console.error('Error marking template as deleted:', error);
    // Vérifier si l'erreur est due à un timeout
    if (error.name === 'AbortError') {
      return {
        success: false,
        canceled: true,
        message: 'La requête a pris trop de temps et a été annulée'
      };
    }
    // Retourner un objet avec success: false plutôt que de lancer une exception
    return {
      success: false,
      message: error.message || 'Erreur lors de la suppression du modèle',
      error: error
    };
  }
};


