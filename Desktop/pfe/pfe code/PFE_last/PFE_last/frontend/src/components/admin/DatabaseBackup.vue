<template>
  <div class="tab-content">
    <div class="section-header">
      <h2>Sauvegarde de la Base de Données</h2>
    </div>

    <div class="backup-container">
      <div class="backup-card">
        <div class="backup-icon">
          <i class="fas fa-database"></i>
        </div>
        <div class="backup-content">
          <h3>Sauvegarde Manuelle</h3>
          <p>Téléchargez une sauvegarde complète de la base de données</p>
          <button 
            class="backup-button" 
            @click="backupDatabase" 
            :disabled="loading"
          >
            <i class="fas fa-download"></i>
            {{ loading ? 'Téléchargement en cours...' : 'Créer une nouvelle sauvegarde' }}
          </button>
        </div>
      </div>
      
      <div class="backup-info">
        <h4>Informations sur la sauvegarde</h4>
        <ul>
          <li><i class="fas fa-info-circle"></i> La sauvegarde contient toutes les tables de la base de données</li>
          <li><i class="fas fa-info-circle"></i> Le fichier sera au format SQL</li>
          <li><i class="fas fa-info-circle"></i> Cette opération peut prendre quelques instants selon la taille de la base de données</li>
        </ul>
      </div>
      
      <!-- Liste des sauvegardes disponibles -->
      <div class="backup-history" v-if="backups.length > 0">
        <h3>Sauvegardes disponibles</h3>
        <div class="backup-list">
          <div v-for="backup in backups" :key="backup.filename" class="backup-item">
            <div class="backup-item-info">
              <div class="backup-name">
                <i class="fas fa-file-code"></i>
                {{ backup.filename }}
              </div>
              <div class="backup-meta">
                <span class="backup-date">{{ formatDate(backup.created) }}</span>
                <span class="backup-size">{{ formatSize(backup.size) }}</span>
              </div>
            </div>
            <button @click="downloadBackup(backup.filename)" class="backup-download-btn">
              <i class="fas fa-download"></i>
            </button>
          </div>
        </div>
      </div>
      <div v-else-if="!loading && !backupsLoading" class="no-backups">
        <p>Aucune sauvegarde disponible</p>
      </div>
      <div v-else-if="backupsLoading" class="loading-backups">
        <p>Chargement des sauvegardes...</p>
      </div>
    </div>
    
    <div v-if="error" class="backup-error">
      <i class="fas fa-exclamation-triangle"></i> {{ error }}
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import axios from 'axios';

// State variables
const loading = ref(false);
const error = ref(null);
const backups = ref([]);
const backupsLoading = ref(true);

// Load backup history on component mount
onMounted(async () => {
  await fetchBackups();
});

/**
 * Fetch available backups from the server
 */
const fetchBackups = async () => {
  backupsLoading.value = true;
  try {
    const response = await axios.get('/api/admin-backup/list', {
      headers: {
        'Authorization': `Bearer ${localStorage.getItem('token')}`
      }
    });
    
    if (response.data.success) {
      backups.value = response.data.data;
    } else {
      console.error('Failed to fetch backups list');
    }
  } catch (err) {
    console.error('Error fetching backups list:', err);
  } finally {
    backupsLoading.value = false;
  }
};

/**
 * Format date to a readable string
 */
const formatDate = (dateString) => {
  const date = new Date(dateString);
  return date.toLocaleDateString('fr-FR', { 
    day: '2-digit', 
    month: '2-digit', 
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit' 
  });
};

/**
 * Format file size to a readable string
 */
const formatSize = (bytes) => {
  if (bytes < 1024) return bytes + ' B';
  else if (bytes < 1048576) return (bytes / 1024).toFixed(1) + ' KB';
  else return (bytes / 1048576).toFixed(1) + ' MB';
};

/**
 * Creates a new database backup and downloads the SQL file
 */
const backupDatabase = async () => {
  loading.value = true;
  error.value = null;
  
  try {
    // Make API call to trigger the backup
    const response = await axios.get('/api/admin-backup/backup-database', {
      responseType: 'blob', // Important: to handle binary data
      headers: {
        'Authorization': `Bearer ${localStorage.getItem('token')}`
      }
    });
    
    // Create a download link
    const url = window.URL.createObjectURL(new Blob([response.data]));
    const link = document.createElement('a');
    link.href = url;
    
    // Get current date for filename
    const date = new Date();
    const formattedDate = date.toISOString().split('T')[0];
    
    // Set download filename
    link.setAttribute('download', `quikdoc_backup_${formattedDate}.sql`);
    document.body.appendChild(link);
    
    // Trigger download and clean up
    link.click();
    window.URL.revokeObjectURL(url);
    document.body.removeChild(link);
    
    // Refresh the backups list after creating a new one
    await fetchBackups();
    
  } catch (err) {
    console.error('Error downloading backup:', err);
    error.value = 'Une erreur s\'est produite lors de la sauvegarde. Veuillez réessayer.';
  } finally {
    loading.value = false;
  }
};

/**
 * Downloads an existing backup file by filename
 * @param {string} filename - The name of the backup file to download
 */
const downloadBackup = async (filename) => {
  try {
    // Make API call to download the specific backup
    const response = await axios.get(`/api/admin-backup/download/${filename}`, {
      responseType: 'blob', // Important: to handle binary data
      headers: {
        'Authorization': `Bearer ${localStorage.getItem('token')}`
      }
    });
    
    // Create a download link
    const url = window.URL.createObjectURL(new Blob([response.data]));
    const link = document.createElement('a');
    link.href = url;
    
    // Set download filename
    link.setAttribute('download', filename);
    document.body.appendChild(link);
    
    // Trigger download and clean up
    link.click();
    window.URL.revokeObjectURL(url);
    document.body.removeChild(link);
    
  } catch (err) {
    console.error(`Error downloading backup ${filename}:`, err);
    error.value = `Une erreur s'est produite lors du téléchargement de ${filename}. Veuillez réessayer.`;
  }
};
</script>

<style scoped>
.backup-container {
  display: flex;
  flex-direction: column;
  gap: 2rem;
  margin-top: 1.5rem;
}

.backup-card {
  display: flex;
  background: linear-gradient(145deg, #ffffff, #f0f4f8);
  border-radius: 12px;
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
  padding: 2rem;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.backup-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 12px 20px rgba(0, 0, 0, 0.15);
}

.backup-icon {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 80px;
  height: 80px;
  background: linear-gradient(135deg, #4a6cf7, #2c3e50);
  border-radius: 50%;
  margin-right: 2rem;
  color: white;
  font-size: 2rem;
}

.backup-content {
  flex: 1;
}

.backup-content h3 {
  font-size: 1.5rem;
  margin-bottom: 0.5rem;
  color: #2c3e50;
}

.backup-content p {
  color: #64748b;
  margin-bottom: 1.5rem;
}

.backup-button {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  background: linear-gradient(135deg, #4a6cf7, #2c3e50);
  color: white;
  border: none;
  padding: 0.75rem 1.5rem;
  border-radius: 6px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
}

.backup-button:hover {
  background: linear-gradient(135deg, #3a5de6, #1e2a3a);
  transform: translateY(-2px);
}

.backup-button:disabled {
  background: #cbd5e1;
  cursor: not-allowed;
  transform: none;
}

/* Backup info styles */
.backup-info {
  background-color: rgba(74, 108, 247, 0.05);
  border-left: 4px solid #4a6cf7;
  border-radius: 6px;
  padding: 1.5rem;
}

.backup-info h4 {
  font-size: 1.2rem;
  color: #2c3e50;
  margin-bottom: 1rem;
}

.backup-info ul {
  list-style: none;
  padding: 0;
  margin: 0;
}

.backup-info li {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin-bottom: 0.75rem;
  color: #64748b;
}

.backup-info li i {
  color: #4a6cf7;
}

/* Backup history list styles */
.backup-history {
  margin-top: 1rem;
}

.backup-history h3 {
  font-size: 1.3rem;
  color: #2c3e50;
  margin-bottom: 1rem;
  padding-bottom: 0.5rem;
  border-bottom: 1px solid #e2e8f0;
}

.backup-list {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
  max-height: 400px;
  overflow-y: auto;
}

.backup-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  background-color: white;
  border-radius: 8px;
  padding: 1rem;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
  transition: all 0.2s ease;
}

.backup-item:hover {
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  transform: translateY(-2px);
}

.backup-item-info {
  display: flex;
  flex-direction: column;
  gap: 0.3rem;
}

.backup-name {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-weight: 500;
  color: #2c3e50;
}

.backup-name i {
  color: #4a6cf7;
}

.backup-meta {
  display: flex;
  gap: 1rem;
  font-size: 0.85rem;
  color: #64748b;
}

.backup-download-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 36px;
  width: 36px;
  border-radius: 50%;
  background-color: #f8fafc;
  color: #4a6cf7;
  transition: all 0.2s ease;
  text-decoration: none;
}

.backup-download-btn:hover {
  background-color: #4a6cf7;
  color: white;
}

.no-backups, .loading-backups {
  text-align: center;
  padding: 2rem;
  color: #64748b;
  font-style: italic;
  background-color: #f8fafc;
  border-radius: 8px;
}

/* Error message styles */
.backup-error {
  margin-top: 1.5rem;
  background-color: rgba(239, 68, 68, 0.1);
  color: #ef4444;
  padding: 1rem;
  border-radius: 6px;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}
</style>
