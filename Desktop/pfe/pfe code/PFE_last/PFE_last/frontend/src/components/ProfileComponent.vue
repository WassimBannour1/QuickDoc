<template>
  <div class="profile-content">
    <div class="profile-content-header">
      <h2>Mon Profil</h2>
      <button class="profile-close-btn" @click="handleClose">
        <i class="fas fa-times"></i>
      </button>
    </div>
    
    <div class="profile-form-container">
      <div class="profile-layout">
        <!-- Photo de profil -->
        <div class="profile-photo-section">
          <div class="profile-photo-container">
            <div v-if="profileData.first_name" class="profile-avatar-letter">
              {{ profileData.first_name.charAt(0).toUpperCase() }}
            </div>
            <div v-else class="profile-avatar-letter">
              <i class="fas fa-user"></i>
            </div>
          </div>
        </div>

        <!-- Informations personnelles -->
        <div class="profile-info-section">
          <div class="form-row">
            <div class="form-group">
              <label for="firstName">Prénom</label>
              <input type="text" id="firstName" v-model="profileData.first_name" class="form-control" :class="{ 'is-invalid': profileErrors.first_name }" />
              <div v-if="profileErrors.first_name" class="error-message">{{ profileErrors.first_name }}</div>
            </div>
            
            <div class="form-group">
              <label for="lastName">Nom</label>
              <input type="text" id="lastName" v-model="profileData.last_name" class="form-control" :class="{ 'is-invalid': profileErrors.last_name }" />
              <div v-if="profileErrors.last_name" class="error-message">{{ profileErrors.last_name }}</div>
            </div>
          </div>
          
          <div class="form-group">
            <label for="email">Email</label>
            <input type="email" id="email" v-model="profileData.email" class="form-control" :class="{ 'is-invalid': profileErrors.email }" />
            <div v-if="profileErrors.email" class="error-message">{{ profileErrors.email }}</div>
          </div>
          
          <!-- Password fields (always visible) -->
          <h3 class="section-title">Changer le mot de passe</h3>
          <div class="password-fields-static">
            <!-- Champ mot de passe actuel -->
            <div class="form-group">
              <label for="currentPassword">Mot de passe actuel</label>
              <div class="password-input-container">
                <input :type="showCurrentPassword ? 'text' : 'password'" id="currentPassword" v-model="profileData.current_password" class="form-control" :class="{ 'is-invalid': profileErrors.current_password }" />
                <div class="password-toggle" @click="showCurrentPassword = !showCurrentPassword">
                  <i :class="showCurrentPassword ? 'fas fa-eye-slash' : 'fas fa-eye'"></i>
                </div>
              </div>
              <div v-if="profileErrors.current_password" class="error-message">{{ profileErrors.current_password }}</div>
            </div>
            
            <div class="form-row">
              <div class="form-group">
                <label for="newPassword">Nouveau mot de passe</label>
                <div class="password-input-container">
                  <input :type="showNewPassword ? 'text' : 'password'" id="newPassword" v-model="profileData.new_password" class="form-control" :class="{ 'is-invalid': profileErrors.new_password }" />
                  <div class="password-toggle" @click="showNewPassword = !showNewPassword">
                    <i :class="showNewPassword ? 'fas fa-eye-slash' : 'fas fa-eye'"></i>
                  </div>
                </div>
                <div v-if="profileErrors.new_password" class="error-message">{{ profileErrors.new_password }}</div>
              </div>
              
              <div class="form-group">
                <label for="confirmPassword">Confirmer</label>
                <div class="password-input-container">
                  <input :type="showConfirmPassword ? 'text' : 'password'" id="confirmPassword" v-model="profileData.confirm_password" class="form-control" :class="{ 'is-invalid': profileErrors.confirm_password }" />
                  <div class="password-toggle" @click="showConfirmPassword = !showConfirmPassword">
                    <i :class="showConfirmPassword ? 'fas fa-eye-slash' : 'fas fa-eye'"></i>
                  </div>
                </div>
                <div v-if="profileErrors.confirm_password" class="error-message">{{ profileErrors.confirm_password }}</div>
              </div>
            </div>
          </div>
          
          <!-- Enterprise section for enterprise_admin role (foldable) -->
          <div v-if="isEnterpriseAdmin" class="enterprise-section">
            <div class="enterprise-header" @click="toggleEnterpriseSection">
              <h3 class="section-title">Informations de l'entreprise</h3>
              <i :class="showEnterpriseSection ? 'fas fa-chevron-up' : 'fas fa-chevron-down'"></i>
            </div>
            
            <div v-if="showEnterpriseSection" class="enterprise-fields">
            <div class="form-row">
              <div class="form-group">
                <label for="siret">SIRET (14 chiffres)</label>
                <input 
                  type="text" 
                  id="siret" 
                  v-model="enterpriseData.siret" 
                  class="form-control readonly-field" 
                  :class="{ 'is-invalid': enterpriseErrors.siret }" 
                  maxlength="14" 
                  readonly 
                />
                <div v-if="enterpriseErrors.siret" class="error-message">{{ enterpriseErrors.siret }}</div>
              </div>
              <div class="form-group">
                <label for="entrepriseName">Raison sociale</label>
                <input type="text" id="entrepriseName" v-model="enterpriseData.nom_entreprise" class="form-control" :class="{ 'is-invalid': enterpriseErrors.nom_entreprise }" />
                <div v-if="enterpriseErrors.nom_entreprise" class="error-message">{{ enterpriseErrors.nom_entreprise }}</div>
              </div>
            </div>
            
            <!-- La section Logo de l'entreprise a été supprimée -->
            
            <div class="form-group">
              <label for="emailEntreprise">Email de l'entreprise</label>
              <input type="email" id="emailEntreprise" v-model="enterpriseData.email_entreprise" class="form-control" :class="{ 'is-invalid': enterpriseErrors.email_entreprise }" />
              <div v-if="enterpriseErrors.email_entreprise" class="error-message">{{ enterpriseErrors.email_entreprise }}</div>
            </div>
            
            <div class="form-row">
              <div class="form-group">
                <label for="pays">Pays</label>
                <input type="text" id="pays" v-model="enterpriseData.pays" class="form-control" />
              </div>
              <div class="form-group">
                <label for="ville">Ville</label>
                <input type="text" id="ville" v-model="enterpriseData.ville" class="form-control" />
              </div>
            </div>
            
            <div class="form-group">
              <label for="adresse">Adresse</label>
              <textarea id="adresse" v-model="enterpriseData.adresse" class="form-control" rows="2"></textarea>
            </div>
            
            <div class="form-row">
              <div class="form-group">
                <label for="codePostal">Code postal</label>
                <input 
                  type="text" 
                  id="codePostal" 
                  v-model="enterpriseData.code_postal" 
                  @input="filterNonNumeric('code_postal')" 
                  pattern="\d*" 
                  inputmode="numeric" 
                  class="form-control" 
                  :class="{ 'is-invalid': enterpriseErrors.code_postal }" 
                />
                <div v-if="enterpriseErrors.code_postal" class="error-message">{{ enterpriseErrors.code_postal }}</div>
              </div>
              <div class="form-group">
                <label for="devise">Devise</label>
                <select id="devise" v-model="enterpriseData.devise" class="form-control">
                  <option value="TND">TND</option>
                  <option value="EUR">EUR</option>
                  <option value="USD">USD</option>
                </select>
              </div>
            </div>
            
            <div class="form-row">
              <div class="form-group">
                <label for="secteurActivite">Secteur d'activité</label>
                <input type="text" id="secteurActivite" v-model="enterpriseData.secteur_activite" class="form-control" />
              </div>
              <div class="form-group">
                <label for="telephone">Téléphone</label>
                <input 
                  type="tel" 
                  id="telephone" 
                  v-model="enterpriseData.telephone" 
                  @input="filterNonNumeric('telephone', true)" 
                  pattern="[0-9+\-\s()]*" 
                  class="form-control" 
                  :class="{ 'is-invalid': enterpriseErrors.telephone }" 
                />
                <div v-if="enterpriseErrors.telephone" class="error-message">{{ enterpriseErrors.telephone }}</div>
              </div>
            </div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Boutons d'action -->
      <div class="form-actions">
        <button type="button" class="btn btn-secondary" @click="handleCancel">Annuler</button>
        <button type="button" class="btn btn-primary" @click="saveProfileChanges" :disabled="isProfileSubmitting">
          <span v-if="isProfileSubmitting" class="spinner"></span>
          <span v-else>Enregistrer</span>
        </button>
      </div>
      
      <!-- Message de notification -->
      <div v-if="profileNotification.show" class="notification" :class="profileNotification.type">
        {{ profileNotification.message }}
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useMainStore } from '@/stores';
import api from '@/services/api';

const store = useMainStore();
const emit = defineEmits(['close']);

// Profile data
const profileData = ref({
  first_name: '',
  last_name: '',
  email: '',
  photoUrl: '',
  localPhotoPath: '', // Ajout du chemin local de l'image
  current_password: '', // Ajout du champ pour le mot de passe actuel
  new_password: '',
  confirm_password: ''
});

// Enterprise data (for enterprise_admin role)
const enterpriseData = ref({
  siret: '',
  nom_entreprise: '',
  email_entreprise: '',
  logo_path: '',
  pays: '',
  ville: '',
  adresse: '',
  code_postal: '',
  devise: 'TND', // Default currency
  secteur_activite: '',
  telephone: ''
});

const profileErrors = ref({
  first_name: '',
  last_name: '',
  email: '',
  current_password: '', // Ajout de la validation pour le mot de passe actuel
  new_password: '',
  confirm_password: ''
});

const enterpriseErrors = ref({
  siret: '',
  nom_entreprise: '',
  email_entreprise: ''
});

const isProfileSubmitting = ref(false);
const profileNotification = ref({ show: false, message: '', type: 'success' });

// Password section and visibility toggles
const showPasswordSection = ref(false);
// Ajout de la variable pour afficher/masquer le mot de passe actuel
const showCurrentPassword = ref(false);
const showNewPassword = ref(false);
const showConfirmPassword = ref(false);

const togglePasswordSection = () => {
  showPasswordSection.value = !showPasswordSection.value;
};

// UI states
const showEnterpriseSection = ref(true); // Enterprise section initially expanded

// Toggle enterprise section
const toggleEnterpriseSection = () => {
  showEnterpriseSection.value = !showEnterpriseSection.value;
};

// Initialize profile data from store
onMounted(() => {
  if (store.user) {
    profileData.value.first_name = store.user.first_name || '';
    profileData.value.last_name = store.user.last_name || '';
    profileData.value.email = store.user.email || '';
    profileData.value.photoUrl = store.user.photo_url || '';
    profileData.value.localPhotoPath = store.user.photo_path || '';
    
    // Check if user is enterprise admin and load enterprise data if needed
    if (store.user.role === 'enterprise_admin') {
      isEnterpriseAdmin.value = true;
      
      // If enterprise data exists in the store, load it
      if (store.user.enterprise) {
        const enterprise = store.user.enterprise;
        enterpriseData.value.siret = enterprise.siret || '';
        enterpriseData.value.nom_entreprise = enterprise.nom_entreprise || '';
        enterpriseData.value.email_entreprise = enterprise.email_entreprise || '';
        // logo_path a été supprimé
        enterpriseData.value.pays = enterprise.pays || '';
        enterpriseData.value.ville = enterprise.ville || '';
        enterpriseData.value.adresse = enterprise.adresse || '';
        enterpriseData.value.code_postal = enterprise.code_postal || '';
        enterpriseData.value.devise = enterprise.devise || 'TND';
        enterpriseData.value.secteur_activite = enterprise.secteur_activite || '';
        enterpriseData.value.telephone = enterprise.telephone || '';
      }
    }
    
    console.log('Données du profil chargées:', profileData.value);
    console.log('Données de l\'entreprise chargées:', enterpriseData.value);
  }
});

// Profile photo upload
const fileInput = ref(null);

const triggerFileInput = () => {
  fileInput.value.click();
};

const handleFileChange = (event) => {
  const file = event.target.files[0];
  if (file) {
    // Capturer le chemin local du fichier
    profileData.value.localPhotoPath = file.path || file.webkitRelativePath || file.name;
    console.log('Chemin local de l\'image:', profileData.value.localPhotoPath);
    
    // Conserver également l'affichage de l'image dans l'interface
    const reader = new FileReader();
    reader.onload = (e) => {
      profileData.value.photoUrl = e.target.result;
    };
    reader.readAsDataURL(file);
  }
};

// Profile form actions
const validateProfileForm = () => {
  // Réinitialiser les erreurs
  Object.keys(profileErrors.value).forEach(key => {
    profileErrors.value[key] = '';
  });
  
  // Réinitialiser les erreurs d'entreprise
  Object.keys(enterpriseErrors.value).forEach(key => {
    enterpriseErrors.value[key] = '';
  });
  
  let isValid = true;
  
  // Valider le prénom
  if (!profileData.value.first_name) {
    profileErrors.value.first_name = 'Le prénom est requis';
    isValid = false;
  }
  
  // Valider le nom
  if (!profileData.value.last_name) {
    profileErrors.value.last_name = 'Le nom est requis';
    isValid = false;
  }
  
  // Valider l'email
  if (!profileData.value.email) {
    profileErrors.value.email = 'L\'email est requis';
    isValid = false;
  } else if (!/^\S+@\S+\.\S+$/.test(profileData.value.email)) {
    profileErrors.value.email = 'Format d\'email invalide';
    isValid = false;
  }
  
  // Valider les champs d'entreprise pour les admins d'entreprise
  if (isEnterpriseAdmin.value) {
    // Valider le SIRET (requis et unique selon le schéma de la table)
    if (!enterpriseData.value.siret) {
      enterpriseErrors.value.siret = 'Le SIRET est requis';
      isValid = false;
    } else if (!/^\d{14}$/.test(enterpriseData.value.siret)) {
      enterpriseErrors.value.siret = 'Le SIRET doit contenir exactement 14 chiffres';
      isValid = false;
    }
    
    // Valider la raison sociale (requise selon le schéma)
    if (!enterpriseData.value.nom_entreprise) {
      enterpriseErrors.value.nom_entreprise = 'La raison sociale est requise';
      isValid = false;
    }
    
    // Valider l'email de l'entreprise (optionnel mais format valide si fourni)
    if (enterpriseData.value.email_entreprise && !/^\S+@\S+\.\S+$/.test(enterpriseData.value.email_entreprise)) {
      enterpriseErrors.value.email_entreprise = 'Format d\'email invalide';
      isValid = false;
    }
    
    // Valider le code postal (chiffres uniquement, 4 ou 5 chiffres)
    if (enterpriseData.value.code_postal) {
      // Filtrer une dernière fois pour garantir qu'il n'y a que des chiffres
      enterpriseData.value.code_postal = enterpriseData.value.code_postal.replace(/[^0-9]/g, '');
      
      if (!/^\d{4,5}$/.test(enterpriseData.value.code_postal)) {
        enterpriseErrors.value.code_postal = 'Le code postal doit contenir 4 ou 5 chiffres';
        isValid = false;
      }
    }
    
    // Valider le numéro de téléphone (format international valide)
    if (enterpriseData.value.telephone) {
      // Nettoyer le numéro de téléphone pour permettre la validation
      const cleanPhone = enterpriseData.value.telephone.replace(/[\s()-]/g, '');
      
      // Vérifier le format après nettoyage (+xxx ou xxx avec au moins 8 chiffres au total)
      if (!/^\+?\d{8,15}$/.test(cleanPhone)) {
        enterpriseErrors.value.telephone = 'Format de téléphone invalide (minimum 8 chiffres)';
        isValid = false;
      }
    }
    
    // Valider la devise (utiliser la valeur par défaut 'TND' si non fournie)
    if (!enterpriseData.value.devise) {
      enterpriseData.value.devise = 'TND';
    }
  }
  
  // Password validation only if user is trying to change password
  if (profileData.value.new_password || profileData.value.confirm_password) {
    // Vérifier que le mot de passe actuel est fourni
    if (!profileData.value.current_password) {
      profileErrors.value.current_password = 'Le mot de passe actuel est requis';
      isValid = false;
    }
    
    if (profileData.value.new_password && profileData.value.new_password.length < 8) {
      profileErrors.value.new_password = 'Le mot de passe doit contenir au moins 8 caractères';
      isValid = false;
    }
    
    if (profileData.value.new_password !== profileData.value.confirm_password) {
      profileErrors.value.confirm_password = 'Les mots de passe ne correspondent pas';
      isValid = false;
    }
  }
  
  return isValid;
};

// Submit form data to server
const saveProfileChanges = async () => {
  // Validate the form first
  if (!validateProfileForm()) return;
  
  isProfileSubmitting.value = true;
  
  try {
    // Prepare data for submission
    const dataToSend = {
      first_name: profileData.value.first_name,
      last_name: profileData.value.last_name,
      email: profileData.value.email
    };
    
    // Add enterprise data if user is enterprise admin
    if (isEnterpriseAdmin.value) {
      // Include owner_id in enterprise data for backend processing
      // (owner_id will be set by the backend based on the current user)
      dataToSend.enterprise = {
        siret: enterpriseData.value.siret, // Required and unique
        nom_entreprise: enterpriseData.value.nom_entreprise, // Required
        email_entreprise: enterpriseData.value.email_entreprise || null, // Optional
        logo_path: enterpriseData.value.logo_path || null, // Optional
        pays: enterpriseData.value.pays || null, // Optional
        ville: enterpriseData.value.ville || null, // Optional
        adresse: enterpriseData.value.adresse || null, // Optional
        code_postal: enterpriseData.value.code_postal || null, // Optional
        devise: enterpriseData.value.devise || 'TND', // Default to TND if not provided
        secteur_activite: enterpriseData.value.secteur_activite || null, // Optional
        telephone: enterpriseData.value.telephone || null // Optional
      };
    }
    
    // Add password only if it's being changed
    if (profileData.value.new_password) {
      dataToSend.current_password = profileData.value.current_password;
      dataToSend.new_password = profileData.value.new_password;
    }
    
    console.log('Données à envoyer:', JSON.stringify(dataToSend, null, 2));
    
    // Check if personal profile data has changed
    const hasFirstNameChanged = profileData.value.first_name !== store.user.first_name;
    const hasLastNameChanged = profileData.value.last_name !== store.user.last_name;
    const hasEmailChanged = profileData.value.email !== store.user.email;
    const hasPasswordChanged = !!profileData.value.new_password;
    
    // Check if enterprise data has changed
    let hasEnterpriseDataChanged = false;
    if (isEnterpriseAdmin.value) {
      // Check if enterprise data exists in store
      if (store.user.enterprise) {
        const enterprise = store.user.enterprise;

        // Helper function to safely compare values, handling null/undefined/empty strings
        const valueChanged = (formValue, storeValue) => {
          // Get the actual values (handle undefined)
          const actualFormValue = formValue || '';
          const actualStoreValue = storeValue || '';
          
          // For comparison, treat empty strings as null
          const normalizedFormValue = actualFormValue === '' ? null : actualFormValue;
          const normalizedStoreValue = actualStoreValue === '' ? null : actualStoreValue;
          
          // Special case: both are empty/null/undefined
          if ((normalizedFormValue === null || normalizedFormValue === '') && 
              (normalizedStoreValue === null || normalizedStoreValue === '')) {
            return false;
          }
          
          // If one is empty and the other isn't, they're different
          if ((normalizedFormValue === null || normalizedFormValue === '') || 
              (normalizedStoreValue === null || normalizedStoreValue === '')) {
            return true;
          }
          
          // Regular comparison after normalization
          return String(normalizedFormValue) !== String(normalizedStoreValue);
        };
        
        // Check each field for changes
        hasEnterpriseDataChanged = 
          valueChanged(enterpriseData.value.siret, enterprise.siret) ||
          valueChanged(enterpriseData.value.nom_entreprise, enterprise.nom_entreprise) ||
          valueChanged(enterpriseData.value.email_entreprise, enterprise.email_entreprise) ||
          valueChanged(enterpriseData.value.pays, enterprise.pays) ||
          valueChanged(enterpriseData.value.ville, enterprise.ville) ||
          valueChanged(enterpriseData.value.adresse, enterprise.adresse) ||
          valueChanged(enterpriseData.value.code_postal, enterprise.code_postal) ||
          valueChanged(enterpriseData.value.devise, enterprise.devise) ||
          valueChanged(enterpriseData.value.secteur_activite, enterprise.secteur_activite) ||
          valueChanged(enterpriseData.value.telephone, enterprise.telephone);
      } else {
        // If enterprise data doesn't exist in store but form has data, count as change
        hasEnterpriseDataChanged = !!enterpriseData.value.siret || !!enterpriseData.value.nom_entreprise;
      }
      
      console.log('Enterprise data changed:', hasEnterpriseDataChanged);
      // Log actual values for debugging
      if (store.user.enterprise) {
        console.log('Current enterprise values:', {
          form: {
            siret: enterpriseData.value.siret,
            nom_entreprise: enterpriseData.value.nom_entreprise,
          },
          store: {
            siret: store.user.enterprise.siret,
            nom_entreprise: store.user.enterprise.nom_entreprise,
          }
        });
      }
    }
    
    console.log('Changements détectés:', {
      profil: { prénom: hasFirstNameChanged, nom: hasLastNameChanged, email: hasEmailChanged },
      motDePasse: hasPasswordChanged,
      entreprise: hasEnterpriseDataChanged
    });
    
    // Debug log for all enterprise fields
    if (isEnterpriseAdmin.value) {
      console.log('Tous les champs d\'entreprise:', {
        siret: { form: enterpriseData.value.siret, store: store.user.enterprise?.siret },
        nom: { form: enterpriseData.value.nom_entreprise, store: store.user.enterprise?.nom_entreprise },
        email: { form: enterpriseData.value.email_entreprise, store: store.user.enterprise?.email_entreprise },
        pays: { form: enterpriseData.value.pays, store: store.user.enterprise?.pays },
        ville: { form: enterpriseData.value.ville, store: store.user.enterprise?.ville },
        adresse: { form: enterpriseData.value.adresse, store: store.user.enterprise?.adresse },
        codePostal: { form: enterpriseData.value.code_postal, store: store.user.enterprise?.code_postal },
        devise: { form: enterpriseData.value.devise, store: store.user.enterprise?.devise },
        secteur: { form: enterpriseData.value.secteur_activite, store: store.user.enterprise?.secteur_activite },
        telephone: { form: enterpriseData.value.telephone, store: store.user.enterprise?.telephone }
      });
    }
    
    // Logo a été supprimé de la fonctionnalité
    const hasLogoChanged = false;
    
    console.log('Logo functionality has been removed');
    
    // Check if any changes have been made
    if (!hasFirstNameChanged && !hasLastNameChanged && !hasEmailChanged && 
        !hasPasswordChanged && !hasEnterpriseDataChanged && !hasLogoChanged) {
      profileNotification.value = {
        show: true,
        message: 'Aucune modification détectée. Veuillez modifier au moins un champ.',
        type: 'error'
      };
      isProfileSubmitting.value = false;
      return;
    }
    
    // Force enterprise data to be included with changes detection
    // This ensures enterprise data is always updated correctly
    if (isEnterpriseAdmin.value) {
      // Force detection of enterprise data changes
      // This fixes issues with empty strings vs null values
      if (store.user.enterprise) {
        // We'll manually check for at least one field having a value different from stored value
        // This is a more aggressive approach but ensures changes are detected
        hasEnterpriseDataChanged = true;
        console.log('Forçage de la détection de changements pour les données d\'entreprise');
      }
    }
    
    // Ensure user ID is available
    if (!store.user || !store.user.id) {
      throw new Error('Utilisateur non connecté ou ID non disponible');
    }
    
    console.log('Données envoyées au serveur:', JSON.stringify(dataToSend, null, 2));
    
    try {
      // Need to use FormData if uploading files
      const formData = new FormData();
      
      // Add basic profile data
      formData.append('first_name', dataToSend.first_name);
      formData.append('last_name', dataToSend.last_name);
      formData.append('email', dataToSend.email);
      
      // Add password if changed
      if (dataToSend.current_password) {
        formData.append('current_password', dataToSend.current_password);
        formData.append('new_password', dataToSend.new_password);
      }
      
      // Add enterprise data
      if (isEnterpriseAdmin.value) {
        // Toujours envoyer les données d'entreprise complètes pour forcer la mise à jour
        // Créer un objet enterprise complet
        const enterpriseObj = {
          siret: enterpriseData.value.siret || '',
          nom_entreprise: enterpriseData.value.nom_entreprise || '',
          email_entreprise: enterpriseData.value.email_entreprise || '',
          pays: enterpriseData.value.pays || '',
          ville: enterpriseData.value.ville || '',
          adresse: enterpriseData.value.adresse || '',
          code_postal: enterpriseData.value.code_postal || '',
          devise: enterpriseData.value.devise || 'TND',
          secteur_activite: enterpriseData.value.secteur_activite || '',
          telephone: enterpriseData.value.telephone || ''
        };
        
        // Ajouter l'objet enterprise complet en tant que JSON
        formData.append('enterprise', JSON.stringify(enterpriseObj));
        
        // Toujours définir logo_path à NULL dans la base de données
        formData.append('remove_logo', 'true');
        
        console.log('Données d\'entreprise envoyées:', enterpriseObj);
      }
      
      // La référence à logoFile a été supprimée
      
      // Use the correct API endpoint with FormData
      const response = await api.put(`/api/users/profile/${store.user.id}`, formData, {
        headers: {
          'Content-Type': 'multipart/form-data'
        }
      });
      console.log('Réponse du serveur:', response.data);
      
      // Mettre à jour les données utilisateur dans le store
      if (response.data && response.data.user) {
        store.setUser(response.data.user);
        console.log('Données utilisateur mises à jour dans le store:', store.user);
        
        // Pour les admins d'entreprise, mettre à jour les données d'entreprise dans le composant
        if (isEnterpriseAdmin.value && response.data.user.enterprise) {
          const enterprise = response.data.user.enterprise;
          enterpriseData.value = {
            siret: enterprise.siret || '',
            nom_entreprise: enterprise.nom_entreprise || '',
            email_entreprise: enterprise.email_entreprise || '',
            // logo_path a été supprimé
            pays: enterprise.pays || '',
            ville: enterprise.ville || '',
            adresse: enterprise.adresse || '',
            code_postal: enterprise.code_postal || '',
            devise: enterprise.devise || 'TND',
            secteur_activite: enterprise.secteur_activite || '',
            telephone: enterprise.telephone || ''
          };
          
          // Les variables liées au logo ont été supprimées
        }
      }
    } catch (error) {
      console.error('Erreur lors de l\'envoi des données:', error.response ? error.response.data : error.message);
      
      // Afficher un message d'erreur à l'utilisateur
      profileNotification.value = {
        show: true,
        message: 'Erreur lors de la mise à jour du profil: ' + (error.response?.data?.message || error.message),
        type: 'error'
      };
      
      isProfileSubmitting.value = false;
      return; // Sortir de la fonction pour éviter d'afficher le message de succès
    }
    
    // Show success notification
    profileNotification.value = {
      show: true,
      message: 'Profil mis à jour avec succès',
      type: 'success'
    };
    
    // Hide notification after 3 seconds
    setTimeout(() => {
      profileNotification.value.show = false;
    }, 3000);
    
    // Reset password fields
    profileData.value.current_password = '';
    profileData.value.new_password = '';
    profileData.value.confirm_password = '';
  } catch (error) {
    console.error('Erreur lors de la mise à jour du profil:', error);
    
    // Afficher le message d'erreur général
    profileNotification.value = {
      show: true,
      message: error.response?.data?.message || 'Erreur lors de la mise à jour du profil',
      type: 'error'
    };
  } finally {
    isProfileSubmitting.value = false;
  }
};

// Handle cancel button with special behavior for admin role
const handleCancel = () => {
  // For admin users, emit close event which will take them back to users management
  if (store.user && store.user.role === 'admin') {
    emit('close', 'users'); // Pass 'users' as parameter to indicate we want to go to users tab
  } else {
    // For other roles, just reset the form
    cancelProfileChanges();
  }
};

// Handle close button with special behavior for admin role
const handleClose = () => {
  // For admin users, emit close event which will take them back to users management
  if (store.user && store.user.role === 'admin') {
    emit('close', 'users'); // Pass 'users' as parameter to indicate we want to go to users tab
  } else {
    // For other roles, just close the profile component
    emit('close');
  }
};

const cancelProfileChanges = () => {
  // Reset form to initial values
  if (store.user) {
    profileData.value.first_name = store.user.first_name || '';
    profileData.value.last_name = store.user.last_name || '';
    profileData.value.email = store.user.email || '';
    profileData.value.photoUrl = store.user.photo_url || '';
    
    // Reset enterprise data if user is enterprise admin
    if (isEnterpriseAdmin.value && store.user.enterprise) {
      const enterprise = store.user.enterprise;
      enterpriseData.value.siret = enterprise.siret || '';
      enterpriseData.value.nom_entreprise = enterprise.nom_entreprise || '';
      enterpriseData.value.email_entreprise = enterprise.email_entreprise || '';
      // logo_path a été supprimé
      enterpriseData.value.pays = enterprise.pays || '';
      enterpriseData.value.ville = enterprise.ville || '';
      enterpriseData.value.adresse = enterprise.adresse || '';
      enterpriseData.value.code_postal = enterprise.code_postal || '';
      enterpriseData.value.devise = enterprise.devise || 'TND';
      enterpriseData.value.secteur_activite = enterprise.secteur_activite || '';
      enterpriseData.value.telephone = enterprise.telephone || '';
    }
  }
  
  // Reset password fields
  profileData.value.current_password = '';
  profileData.value.new_password = '';
  profileData.value.confirm_password = '';
  
  // Reset errors
  Object.keys(profileErrors.value).forEach(key => {
    profileErrors.value[key] = '';
  });
  
  // Reset enterprise errors
  Object.keys(enterpriseErrors.value).forEach(key => {
    enterpriseErrors.value[key] = '';
  });
  
  // L'erreur logo_path a été supprimée
  
  // Emit close event to parent component
  emit('close');
};

const isEnterpriseAdmin = ref(false);

// Les fonctions liées au logo d'entreprise ont été supprimées

// Function to filter out non-numeric characters from input fields
const filterNonNumeric = (field, allowSpecialChars = false) => {
  if (!enterpriseData.value[field]) return;
  
  if (allowSpecialChars) {
    // For telephone: allow numbers, +, -, (), and spaces
    enterpriseData.value[field] = enterpriseData.value[field].replace(/[^0-9+\-\s()]/g, '');
  } else {
    // For code postal: allow only numbers
    enterpriseData.value[field] = enterpriseData.value[field].replace(/[^0-9]/g, '');
  }
};

</script>

<style scoped>
/* Profile Content Styles */
.profile-content {
  background-color: white;
  border-radius: 15px;
  box-shadow: 0 10px 30px rgba(0, 36, 70, 0.15);
  padding: 20px;
  margin-bottom: 20px;
  animation: fadeIn 0.6s cubic-bezier(0.215, 0.61, 0.355, 1);
  border-top: 4px solid #002446;
  position: relative;
  overflow: hidden;
}

/* Section titles */
.section-title {
  margin: 1.5rem 0 1rem;
  font-size: 1.1rem;
  font-weight: 600;
  color: #002446;
  position: relative;
  padding-bottom: 0.5rem;
}

.section-title::after {
  content: '';
  position: absolute;
  left: 0;
  bottom: 0;
  width: 50px;
  height: 3px;
  background: linear-gradient(90deg, #0056b3, #007bff);
  border-radius: 3px;
}

/* Password fields styling */
.password-fields-static {
  margin: 10px 0 20px;
  padding: 15px;
  background-color: rgba(0, 36, 70, 0.02);
  border-radius: 8px;
  border: 1px solid rgba(0, 36, 70, 0.08);
}

/* Enterprise section styling */
.enterprise-section {
  margin: 20px 0;
  border-radius: 8px;
  overflow: hidden;
  border: 1px solid rgba(0, 36, 70, 0.1);
}

.enterprise-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 15px;
  background: linear-gradient(90deg, rgba(0, 86, 179, 0.8), rgba(0, 123, 255, 0.7));
  cursor: pointer;
  transition: background 0.2s ease;
}

.enterprise-header:hover {
  background: linear-gradient(90deg, rgba(0, 86, 179, 0.9), rgba(0, 123, 255, 0.8));
}

.enterprise-header h3 {
  margin: 0;
  font-size: 1.1rem;
  font-weight: 600;
  color: white;
}

.enterprise-header i {
  color: white;
}

.enterprise-fields {
  padding: 15px;
  animation: slideDown 0.3s ease-out forwards;
  background-color: rgba(0, 36, 70, 0.02);
}

/* Avatar Letter Styling */
.profile-avatar-letter {
  width: 120px;
  height: 120px;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #4a6cf7;
  color: white;
  font-size: 3rem;
  font-weight: bold;
  border-radius: 50%;
}

.profile-content::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: linear-gradient(135deg, rgba(0, 36, 70, 0.03) 0%, rgba(255, 255, 255, 0) 50%);
  pointer-events: none;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(-20px); filter: blur(3px); }
  to { opacity: 1; transform: translateY(0); filter: blur(0); }
}

.profile-content-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
  background: linear-gradient(to right, rgba(0, 36, 70, 0.08), transparent);
  padding: 12px 15px;
  border-radius: 10px;
  position: relative;
  overflow: hidden;
}

.profile-content-header::after {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 4px;
  height: 100%;
  background: linear-gradient(to bottom, #002446, #3498db);
  border-radius: 0 2px 2px 0;
}

.profile-content-header h2 {
  margin: 0;
  color: #002446;
  font-size: 1.8rem;
  font-weight: 700;
  position: relative;
  padding-bottom: 0.5rem;
  letter-spacing: 0.5px;
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
  animation: titleSlideIn 0.7s cubic-bezier(0.25, 0.46, 0.45, 0.94) forwards;
}

@keyframes titleSlideIn {
  0% { transform: translateX(-20px); opacity: 0; }
  100% { transform: translateX(0); opacity: 1; }
}

.profile-content-header h2::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 0;
  width: 60px;
  height: 3px;
  background: linear-gradient(90deg, #002446, #3498db);
  border-radius: 3px;
  transition: width 0.3s ease;
  animation: widthPulse 2s cubic-bezier(0.215, 0.61, 0.355, 1) 1;
}

@keyframes widthPulse {
  0% { width: 0; opacity: 0; }
  50% { width: 80px; opacity: 1; }
  100% { width: 60px; opacity: 1; }
}

.profile-close-btn {
  background: none;
  border: 2px solid transparent;
  font-size: 1.25rem;
  color: #6c757d;
  cursor: pointer;
  transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
  width: 40px;
  height: 40px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  overflow: hidden;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
}

.profile-close-btn::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: radial-gradient(circle, rgba(220, 53, 69, 0.1) 0%, rgba(220, 53, 69, 0) 70%);
  transform: scale(0);
  transition: transform 0.4s ease;
}

.profile-close-btn:hover {
  color: #dc3545;
  border-color: rgba(220, 53, 69, 0.3);
  transform: rotate(90deg);
  box-shadow: 0 4px 8px rgba(220, 53, 69, 0.15);
}

.profile-close-btn:hover::before {
  transform: scale(2);
}

.profile-form-container {
  max-width: 600px;
  margin: 0 auto;
  animation: fadeInUp 0.8s cubic-bezier(0.215, 0.61, 0.355, 1);
  padding: 10px;
  position: relative;
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(20px);
    filter: blur(2px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
    filter: blur(0);
  }
}

/* Layout Styles */
.profile-layout {
  display: flex;
  flex-wrap: wrap;
  gap: 15px;
  margin-bottom: 15px;
}

.profile-info-section {
  flex: 1;
  min-width: 250px;
}

.form-row {
  display: flex;
  gap: 15px;
  margin-bottom: 15px;
}

.form-row .form-group {
  flex: 1;
  margin-bottom: 15px;
}

/* Profile Photo Styles */
.profile-photo-section {
  display: flex;
  justify-content: center;
  margin-bottom: 15px;
  position: relative;
}

.profile-photo-section::after {
  content: '';
  position: absolute;
  bottom: -10px;
  left: 50%;
  transform: translateX(-50%);
  width: 80px;
  height: 1px;
  background: linear-gradient(90deg, transparent, rgba(0, 36, 70, 0.2), transparent);
  border-radius: 2px;
}

.profile-photo-container {
  position: relative;
  width: 120px;
  height: 120px;
  border-radius: 50%;
  overflow: hidden;
  box-shadow: 0 5px 15px rgba(0, 36, 70, 0.15);
  border: 3px solid white;
  transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
  animation: profilePhotoAppear 0.8s cubic-bezier(0.215, 0.61, 0.355, 1) forwards;
}

@keyframes profilePhotoAppear {
  0% { transform: scale(0.9); opacity: 0; filter: blur(5px); }
  100% { transform: scale(1); opacity: 1; filter: blur(0); }
}

.profile-photo-container::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: radial-gradient(circle at 30% 30%, rgba(255, 255, 255, 0.3) 0%, rgba(255, 255, 255, 0) 70%);
  z-index: 2;
  pointer-events: none;
}

.profile-photo-container:hover {
  box-shadow: 0 8px 20px rgba(0, 36, 70, 0.2);
  transform: scale(1.03) translateY(-3px);
  border-color: rgba(255, 255, 255, 0.9);
}

.profile-photo {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.5s ease;
}

.profile-photo-container:hover .profile-photo {
  transform: scale(1.1);
}

.photo-upload-overlay {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  background: linear-gradient(to top, rgba(0, 36, 70, 0.8), rgba(0, 36, 70, 0.6), transparent);
  color: white;
  padding: 25px 0 12px;
  text-align: center;
  cursor: pointer;
  transition: all 0.4s cubic-bezier(0.215, 0.61, 0.355, 1);
  transform: translateY(100%);
  z-index: 3;
}

.photo-upload-overlay i {
  font-size: 1.2rem;
  text-shadow: 0 1px 3px rgba(0, 0, 0, 0.3);
  transition: transform 0.3s ease;
}

.profile-photo-container:hover .photo-upload-overlay {
  transform: translateY(0);
}

.profile-photo-container:hover .photo-upload-overlay i {
  transform: scale(1.2);
  animation: pulseIcon 1.5s infinite alternate;
}

@keyframes pulseIcon {
  0% { transform: scale(1); }
  100% { transform: scale(1.3); }
}

/* Form Styles */
.form-group {
  margin-bottom: 15px;
  position: relative;
  transition: transform 0.2s ease;
}

.form-group:hover {
  transform: translateX(2px);
}

label {
  display: block;
  margin-bottom: 5px;
  font-weight: 600;
  color: #002446;
  position: relative;
  transition: all 0.2s ease;
  font-size: 0.9rem;
  letter-spacing: 0.3px;
  padding-left: 5px;
}

label::before {
  content: '';
  position: absolute;
  left: 0;
  top: 50%;
  transform: translateY(-50%);
  width: 2px;
  height: 0;
  background: linear-gradient(to bottom, #002446, #3498db);
  transition: height 0.2s ease;
  border-radius: 2px;
}

.form-group:hover label::before {
  height: 70%;
}

.form-control {
  width: 100%;
  padding: 10px 12px;
  border: 1px solid #d1d9e6;
  border-radius: 6px;
  font-size: 0.95rem;
  transition: all 0.3s cubic-bezier(0.215, 0.61, 0.355, 1);
  background-color: #f8f9fa;
  box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.03);
}

.form-control:hover {
  background-color: #fff;
  border-color: #b8c2cc;
}

.form-control:focus {
  border-color: #3498db;
  outline: 0;
  box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.15);
  background-color: #fff;
  transform: translateY(-2px);
}

.form-control.is-invalid {
  border-color: #dc3545;
  background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' fill='none' stroke='%23dc3545' viewBox='0 0 12 12'%3e%3ccircle cx='6' cy='6' r='4.5'/%3e%3cpath stroke-linejoin='round' d='M5.8 3.6h.4L6 6.5z'/%3e%3ccircle cx='6' cy='8.2' r='.6' fill='%23dc3545' stroke='none'/%3e%3c/svg%3e");
  background-repeat: no-repeat;
  background-position: right calc(0.375em + 0.1875rem) center;
  background-size: calc(0.75em + 0.375rem) calc(0.75em + 0.375rem);
  box-shadow: 0 0 0 3px rgba(220, 53, 69, 0.1);
  animation: invalidShake 0.4s ease-in-out;
}

@keyframes invalidShake {
  0%, 100% { transform: translateX(0); }
  25% { transform: translateX(-5px); }
  75% { transform: translateX(5px); }
}

.error-message {
  color: #dc3545;
  font-size: 0.875rem;
  margin-top: 8px;
  padding-left: 5px;
  display: flex;
  align-items: center;
  animation: errorFadeIn 0.3s ease-in-out;
}

.error-message::before {
  content: '⚠️';
  margin-right: 5px;
  font-size: 0.8rem;
}

@keyframes errorFadeIn {
  from { opacity: 0; transform: translateY(-5px); }
  to { opacity: 1; transform: translateY(0); }
}

/* Password Section Styles */
.password-section {
  margin-top: 20px;
  padding-top: 15px;
  position: relative;
  animation: sectionFadeIn 0.6s ease-out forwards;
  border: 1px solid #e9ecef;
  border-radius: 10px;
  overflow: hidden;
}

@keyframes sectionFadeIn {
  from { opacity: 0; transform: translateY(15px); }
  to { opacity: 1; transform: translateY(0); }
}

.password-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 15px;
  background: linear-gradient(to right, rgba(0, 36, 70, 0.05), transparent);
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.password-header:hover {
  background-color: rgba(0, 36, 70, 0.08);
}

.password-header h3 {
  margin: 0;
  color: #002446;
  font-size: 1.1rem;
  font-weight: 600;
}

.password-header i {
  color: #6c757d;
  transition: transform 0.3s ease;
}

.password-fields {
  padding: 15px;
  animation: slideDown 0.3s ease-out forwards;
  background-color: rgba(0, 36, 70, 0.02);
}

@keyframes slideDown {
  from { opacity: 0; transform: translateY(-10px); }
  to { opacity: 1; transform: translateY(0); }
}

.password-input-container {
  position: relative;
  transition: all 0.3s ease;
}

.password-input-container:focus-within {
  transform: translateY(-3px);
}

.password-toggle {
  position: absolute;
  right: 15px;
  top: 50%;
  transform: translateY(-50%);
  cursor: pointer;
  color: #6c757d;
  transition: all 0.3s ease;
  width: 30px;
  height: 30px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  background-color: rgba(0, 0, 0, 0.02);
}

.password-toggle:hover {
  color: #002446;
  background-color: rgba(0, 0, 0, 0.05);
  transform: translateY(-50%) scale(1.1);
}

.password-toggle i {
  transition: transform 0.3s ease;
}

.password-toggle:hover i {
  transform: scale(1.1);
}

/* Form Actions Styles */
.form-actions {
  display: flex;
  justify-content: flex-end;
  gap: 15px;
  margin-top: 20px;
  position: relative;
  padding-top: 15px;
}

.form-actions::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 1px;
  background: linear-gradient(90deg, transparent, rgba(0, 36, 70, 0.1), transparent);
}

.btn {
  padding: 8px 16px;
  border: none;
  border-radius: 6px;
  font-size: 0.9rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
  display: inline-flex;
  align-items: center;
  justify-content: center;
  position: relative;
  overflow: hidden;
  letter-spacing: 0.3px;
  min-width: 100px;
}

.btn::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: linear-gradient(120deg, rgba(255, 255, 255, 0) 30%, rgba(255, 255, 255, 0.4) 50%, rgba(255, 255, 255, 0) 70%);
  transform: translateX(-100%);
  transition: transform 0.6s ease;
}

.btn:hover::before {
  transform: translateX(100%);
}

.btn-primary {
  background: linear-gradient(135deg, #002446, #0069d9);
  color: white;
  box-shadow: 0 4px 15px rgba(0, 105, 217, 0.2);
}

.btn-primary:hover {
  background: linear-gradient(135deg, #003366, #0080ff);
  transform: translateY(-3px);
  box-shadow: 0 8px 20px rgba(0, 105, 217, 0.3);
}

.btn-primary:active {
  transform: translateY(-1px);
  box-shadow: 0 4px 10px rgba(0, 105, 217, 0.2);
}

.btn-primary:disabled {
  background: linear-gradient(135deg, #6c757d, #495057);
  cursor: not-allowed;
  transform: none;
  box-shadow: 0 4px 10px rgba(108, 117, 125, 0.2);
  opacity: 0.8;
}

.btn-secondary {
  background: linear-gradient(135deg, #6c757d, #495057);
  color: white;
  box-shadow: 0 4px 15px rgba(108, 117, 125, 0.2);
}

.btn-secondary:hover {
  background: linear-gradient(135deg, #5a6268, #343a40);
  transform: translateY(-3px);
  box-shadow: 0 8px 20px rgba(108, 117, 125, 0.3);
}

.btn-secondary:active {
  transform: translateY(-1px);
  box-shadow: 0 4px 10px rgba(108, 117, 125, 0.2);
}

/* Style for readonly fields */
.readonly-field {
  background-color: #f8f9fa;
  cursor: not-allowed;
  opacity: 0.8;
  border-color: #dee2e6;
  color: #6c757d;
}

/* Logo upload styles */
.logo-upload-container {
  display: flex;
  justify-content: center;
  margin: 10px 0;
}

.enterprise-logo-preview {
  position: relative;
  width: 150px;
  height: 150px;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 4px 12px rgba(0, 36, 70, 0.1);
  transition: all 0.3s ease;
}

.enterprise-logo-preview:hover {
  transform: translateY(-3px);
  box-shadow: 0 8px 20px rgba(0, 36, 70, 0.15);
}

/* Les styles CSS liés au logo d'entreprise ont été supprimés */

.hidden-input {
  display: none;
}

/* Spinner for loading state */
.spinner {
  display: inline-block;
  width: 22px;
  height: 22px;
  border: 3px solid rgba(255, 255, 255, 0.2);
  border-radius: 50%;
  border-top-color: white;
  animation: spin 1s cubic-bezier(0.5, 0.1, 0.5, 0.9) infinite;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

/* Notification Styles */
.notification {
  padding: 12px 15px;
  border-radius: 8px;
  margin-top: 15px;
  animation: notificationSlideIn 0.4s cubic-bezier(0.215, 0.61, 0.355, 1);
  position: relative;
  overflow: hidden;
  box-shadow: 0 3px 10px rgba(0, 0, 0, 0.05);
  display: flex;
  align-items: center;
  font-size: 0.9rem;
}

.notification::before {
  content: '';
  position: absolute;
  left: 0;
  top: 0;
  bottom: 0;
  width: 3px;
  border-radius: 3px 0 0 3px;
}

@keyframes notificationSlideIn {
  0% { opacity: 0; transform: translateY(-15px); }
  100% { opacity: 1; transform: translateY(0); }
}

.notification.success {
  background-color: rgba(212, 237, 218, 0.7);
  color: #155724;
  border: 1px solid rgba(195, 230, 203, 0.5);
  backdrop-filter: blur(5px);
}

.notification.success::before {
  background: linear-gradient(to bottom, #155724, #28a745);
}

.notification.error {
  background-color: rgba(248, 215, 218, 0.7);
  color: #721c24;
  border: 1px solid rgba(245, 198, 203, 0.5);
  backdrop-filter: blur(5px);
}

.notification.error::before {
  background: linear-gradient(to bottom, #721c24, #dc3545);
}

.notification::after {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: linear-gradient(120deg, rgba(255, 255, 255, 0) 30%, rgba(255, 255, 255, 0.4) 50%, rgba(255, 255, 255, 0) 70%);
  transform: translateX(-100%);
  animation: notificationShine 3s ease-in-out infinite;
}

@keyframes notificationShine {
  0% { transform: translateX(-100%); }
  20%, 100% { transform: translateX(100%); }
}
</style>