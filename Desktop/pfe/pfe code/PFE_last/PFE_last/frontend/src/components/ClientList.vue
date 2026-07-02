<template>
    <div class="client-list-container">
      <div class="page-header">
        <h1>Gestion des Clients</h1>
      </div>
      
      <div class="search-filter-container">
        <div class="search-box">
          <input 
            type="text" 
            v-model="searchQuery" 
            placeholder="Rechercher un client..." 
            @input="handleSearch"
          />
          <i class="fas fa-search search-icon"></i>
        </div>
        
        <div class="filters">
          
          <div class="filter-group date-filter">
            <label for="dateFilter">Date de création</label>
            <div class="date-inputs">
              <input 
                type="date" 
                id="dateFrom" 
                v-model="filters.dateFrom" 
                @change="applyFilters"
              />
              <span>à</span>
              <input 
                type="date" 
                id="dateTo" 
                v-model="filters.dateTo" 
                @change="applyFilters"
              />
            </div>
          </div>
          
          <button class="btn btn-secondary" @click="resetFilters">
            <i class="fas fa-undo"></i> Réinitialiser
          </button>
        </div>
      </div>
      
      <div class="client-table-container">
        <table class="client-table" v-if="!loading && filteredClients.length > 0">
          <thead>
            <tr>
              <th @click="sortBy('id')" :class="{ active: sortColumn === 'id' }">
                ID
                <i class="fas" :class="getSortIconClass('id')"></i>
              </th>
              <th @click="sortBy('name')" :class="{ active: sortColumn === 'name' }">
                Nom
                <i class="fas" :class="getSortIconClass('name')"></i>
              </th>
              <th @click="sortBy('email')" :class="{ active: sortColumn === 'email' }">
                Email
                <i class="fas" :class="getSortIconClass('email')"></i>
              </th>
              <th @click="sortBy('phone')" :class="{ active: sortColumn === 'phone' }">
                Téléphone
                <i class="fas" :class="getSortIconClass('phone')"></i>
              </th>

              <th @click="sortBy('created_at')" :class="{ active: sortColumn === 'created_at' }">
                Date de création
                <i class="fas" :class="getSortIconClass('created_at')"></i>
              </th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="client in paginatedClients" :key="client.id">
              <td>{{ client.id }}</td>
              <td>
                <div class="client-name">
                  {{ client.name }} {{ client.last_name }}
                  <span v-if="client.company_name" class="company-name">
                    ({{ client.company_name }})
                  </span>
                </div>
              </td>
              <td>{{ client.email }}</td>
              <td>{{ client.phone }}</td>

              <td>{{ formatDate(client.created_at) }}</td>
              <td>
                <div class="action-buttons">
                  <button class="action-btn view-btn" @click="viewClient(client)">
                    <i class="fas fa-eye"></i>
                  </button>
                  <button class="action-btn edit-btn" @click="editClient(client)">
                    <i class="fas fa-edit"></i>
                  </button>
                  <button class="action-btn delete-btn" @click="confirmDelete(client)">
                    <i class="fas fa-trash"></i>
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
        
        <div v-else-if="loading" class="loading-container">
          <div class="spinner"></div>
          <p>Chargement des clients...</p>
        </div>
        
        <div v-else class="no-results">
          <i class="fas fa-search"></i>
          <h3>Aucun client trouvé</h3>
          <p>Essayez de modifier vos critères de recherche ou d'ajouter un nouveau client.</p>
          <router-link to="/admin-entreprise/create-client" class="btn btn-primary">
            Ajouter un client
          </router-link>
        </div>
        
        <div class="pagination" v-if="totalPages > 1">
          <button 
            class="pagination-btn" 
            :disabled="currentPage === 1"
            @click="currentPage = 1"
          >
            <i class="fas fa-angle-double-left"></i>
          </button>
          <button 
            class="pagination-btn" 
            :disabled="currentPage === 1"
            @click="currentPage--"
          >
            <i class="fas fa-angle-left"></i>
          </button>
          
          <div class="page-info">
            Page {{ currentPage }} sur {{ totalPages }}
          </div>
          
          <button 
            class="pagination-btn" 
            :disabled="currentPage === totalPages"
            @click="currentPage++"
          >
            <i class="fas fa-angle-right"></i>
          </button>
          <button 
            class="pagination-btn" 
            :disabled="currentPage === totalPages"
            @click="currentPage = totalPages"
          >
            <i class="fas fa-angle-double-right"></i>
          </button>
        </div>
      </div>
      
      <!-- Client View Modal -->
      <div v-if="showViewModal" class="modal-overlay" @click="showViewModal = false">
        <div class="client-modal" @click.stop>
          <div class="modal-header">
            <h2>Détails du client</h2>
            <button class="close-btn" @click="showViewModal = false">
              <i class="fas fa-times"></i>
            </button>
          </div>
          <div class="modal-body">
            <div class="client-details">
              <div class="detail-section">
                <h3>Informations personnelles</h3>
                <div class="detail-row">
                  <div class="detail-item">
                    <span class="detail-label">Nom</span>
                    <span class="detail-value">{{ selectedClient.name }}</span>
                  </div>
                  <div class="detail-item">
                    <span class="detail-label">Prénom</span>
                    <span class="detail-value">{{ selectedClient.last_name }}</span>
                  </div>
                </div>
                <div class="detail-row" v-if="selectedClient.company_name">
                  <div class="detail-item full-width">
                    <span class="detail-label">Raison sociale</span>
                    <span class="detail-value">{{ selectedClient.company_name }}</span>
                  </div>
                </div>

              </div>
              
              <div class="detail-section">
                <h3>Coordonnées</h3>
                <div class="detail-row">
                  <div class="detail-item">
                    <span class="detail-label">Email</span>
                    <span class="detail-value">{{ selectedClient.email }}</span>
                  </div>
                  <div class="detail-item">
                    <span class="detail-label">Téléphone</span>
                    <span class="detail-value">{{ selectedClient.phone }}</span>
                  </div>
                </div>
                <div class="detail-row">
                  <div class="detail-item full-width">
                    <span class="detail-label">Adresse</span>
                    <span class="detail-value">{{ selectedClient.address }}</span>
                  </div>
                </div>
              </div>
              
              <div class="detail-section" v-if="selectedClient.notes">
                <h3>Notes</h3>
                <div class="detail-row">
                  <div class="detail-item full-width">
                    <span class="detail-value notes">{{ selectedClient.notes }}</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="modal-footer">
            <button class="btn-modal btn-modal-secondary" @click="showViewModal = false">Fermer</button>
            <button class="btn-modal btn-modal-primary" @click="editClient(selectedClient)">Modifier</button>
          </div>
        </div>
      </div>
      
      <!-- Delete Confirmation Modal -->
      <div v-if="showDeleteModal" class="modal-overlay">
        <div class="delete-modal">
          <div class="delete-icon">
            <i class="fas fa-exclamation-triangle"></i>
          </div>
          <h2>Confirmer la suppression</h2>
          <p>Êtes-vous sûr de vouloir supprimer le client <strong>{{ selectedClient.name }} {{ selectedClient.last_name }}</strong> ?</p>
          <p class="warning-text">Cette action est irréversible et supprimera toutes les données associées à ce client.</p>
          <div class="modal-footer">
            <button class="modal-btn modal-btn-cancel" @click="showDeleteModal = false">Annuler</button>
            <button class="modal-btn modal-btn-delete" @click="deleteClient">
              <span v-if="isDeleting">
                <i class="fas fa-spinner fa-spin"></i> Suppression...
              </span>
              <span v-else>Supprimer</span>
            </button>
          </div>
        </div>
      </div>
      
      <!-- Success Modal for Delete -->
      <div v-if="showSuccessModal" class="modal-overlay">
        <div class="success-modal">
          <div class="success-icon">
            <i class="fas fa-check-circle"></i>
          </div>
          <h2>Client supprimé avec succès!</h2>
          <p>Le client a été retiré de votre liste de clients.</p>
          <div class="modal-actions">
            <button class="modal-btn modal-btn-primary" @click="closeSuccessModal">Fermer</button>
          </div>
        </div>
      </div>
    </div>
  </template>
  
<script>
import { ref, reactive, computed, onMounted, onUnmounted } from 'vue';
import { useRouter } from 'vue-router';
import axios from 'axios';

export default {
  name: 'ClientList',
  props: {
    managedByParent: {
      type: Boolean,
      default: false
    }
  },
  emits: ['edit-client', 'create-client'],
  setup(props, { emit }) {
    const router = useRouter();
    
    // State
    const clients = ref([]);
    const loading = ref(true);
    const searchQuery = ref('');
    const filters = reactive({
      dateFrom: '',
      dateTo: ''
    });
    const sortColumn = ref('id');
    const sortDirection = ref('asc');
    const currentPage = ref(1);
    const itemsPerPage = 10;
    const showViewModal = ref(false);
    const showDeleteModal = ref(false);
    const showSuccessModal = ref(false);
    const selectedClient = ref({});
    const deletedClientName = ref('');
    const isDeleting = ref(false);
    const isMounted = ref(true);
    
    // Computed properties
    const filteredClients = computed(() => {
      // Check if clients.value is an array before spreading
      if (!Array.isArray(clients.value)) {
        console.log('Warning: clients.value is not an array:', clients.value);
        return [];
      }
      
      let result = [...clients.value];
      
      // Apply search filter
      if (searchQuery.value) {
        const query = searchQuery.value.toLowerCase();
        result = result.filter(client => 
          (client.name && client.name.toLowerCase().includes(query)) || 
          (client.last_name && client.last_name.toLowerCase().includes(query)) || 
          (client.email && client.email.toLowerCase().includes(query))
        );
      }
      
      // Apply date filters
      if (filters.dateFrom) {
        const fromDate = new Date(filters.dateFrom);
        result = result.filter(client => {
          try {
            return new Date(client.created_at) >= fromDate;
          } catch (error) {
            console.error('Error parsing date:', client.created_at);
            return false;
          }
        });
      }
      
      if (filters.dateTo) {
        const toDate = new Date(filters.dateTo);
        toDate.setHours(23, 59, 59, 999); // End of the day
        result = result.filter(client => {
          try {
            return new Date(client.created_at) <= toDate;
          } catch (error) {
            console.error('Error parsing date:', client.created_at);
            return false;
          }
        });
      }
      
      // Apply sorting
      result.sort((a, b) => {
        let valueA = a[sortColumn.value];
        let valueB = b[sortColumn.value];
        
        // Handle special cases for sorting
        if (sortColumn.value === 'name') {
          valueA = (a.name || '') + ' ' + (a.last_name || '');
          valueB = (b.name || '') + ' ' + (b.last_name || '');
        }
        
        // Handle undefined or null values
        if (valueA === undefined || valueA === null) valueA = '';
        if (valueB === undefined || valueB === null) valueB = '';
        
        if (typeof valueA === 'string') {
          valueA = valueA.toLowerCase();
          valueB = valueB.toLowerCase();
        }
        
        if (valueA < valueB) return sortDirection.value === 'asc' ? -1 : 1;
        if (valueA > valueB) return sortDirection.value === 'asc' ? 1 : -1;
        return 0;
      });
      
      return result;
    });
    
    const paginatedClients = computed(() => {
      const start = (currentPage.value - 1) * itemsPerPage;
      const end = start + itemsPerPage;
      return filteredClients.value.slice(start, end);
    });
    
    const totalPages = computed(() => {
      return Math.ceil(filteredClients.value.length / itemsPerPage) || 1;
    });
    
    // Methods
    const fetchClients = async () => {
      loading.value = true;
      try {
        const userId = localStorage.getItem('user_id');
        const token = localStorage.getItem('token');
        console.log('Fetching clients with token:', token ? 'Token exists' : 'No token');
        console.log('User ID:', userId);
        
        if (!token) {
          console.error('No authentication token found');
          clients.value = [];
          loading.value = false;
          return;
        }
        
        // Utiliser l'URL relative pour l'API - cela utilise la configuration proxy de Vite/Vue CLI
        const apiUrl = '/api/clients';
        console.log('Fetching clients from:', apiUrl);
        
        const response = await axios.get(apiUrl, {
          headers: {
            'Authorization': `Bearer ${token}`,
            'Accept': 'application/json'
          },
          params: {
            user_id: userId
          },
          timeout: 10000 // 10 second timeout
        });
        
        // Check if component is still mounted before updating state
        if (!isMounted.value) return;
        
        // Check if the response is HTML (error case)
        const contentType = response.headers['content-type'] || '';
        if (contentType.includes('text/html')) {
          console.error('Received HTML response instead of JSON. API endpoint may be incorrect or server error occurred.');
          clients.value = [];
          loading.value = false;
          return;
        }
        
        // Detailed logging of the response structure
        console.log('API Response:', response.data);
        console.log('Response type:', typeof response.data);
        console.log('Is Array?', Array.isArray(response.data));
        if (typeof response.data === 'object' && response.data !== null) {
          console.log('Response keys:', Object.keys(response.data));
          
          // If data property exists, log its structure
          if (response.data.data) {
            console.log('data property type:', typeof response.data.data);
            console.log('data is Array?', Array.isArray(response.data.data));
          }
        }
        
        // More flexible response handling
        if (response.data) {
          // Case 1: { data: [...] } format
          if (response.data.data && Array.isArray(response.data.data)) {
            clients.value = response.data.data;
            console.log('Clients loaded from response.data.data:', clients.value.length);
          } 
          // Case 2: [...] format (direct array)
          else if (Array.isArray(response.data)) {
            clients.value = response.data;
            console.log('Clients loaded from direct array:', clients.value.length);
          }
          // Case 3: { clients: [...] } format
          else if (response.data.clients && Array.isArray(response.data.clients)) {
            clients.value = response.data.clients;
            console.log('Clients loaded from response.data.clients:', clients.value.length);
          }
          // Case 4: { results: [...] } format
          else if (response.data.results && Array.isArray(response.data.results)) {
            clients.value = response.data.results;
            console.log('Clients loaded from response.data.results:', clients.value.length);
          }
          // Case 5: Handle empty response but initialize as empty array
          else {
            console.error('Invalid API response format. Expected an array of clients.', response.data);
            clients.value = [];
          }
        } else {
          console.error('Empty API response');
          clients.value = [];
        }
        
        console.log('Clients after assignment:', clients.value);
      } catch (error) {
        console.error('Error fetching clients:', error);
        if (error.response) {
          console.error('Response status:', error.response.status);
          console.error('Response data:', error.response.data);
        }
        clients.value = []; // Ensure clients is always an array even on error
      } finally {
        loading.value = false;
      }
    };
    
    const handleSearch = () => {
      currentPage.value = 1; // Reset to first page when searching
    };
    
    const applyFilters = () => {
      currentPage.value = 1; // Reset to first page when filtering
    };
    
    const resetFilters = () => {
      searchQuery.value = '';
      filters.dateFrom = '';
      filters.dateTo = '';
      currentPage.value = 1;
    };
    
    const sortBy = (column) => {
      if (sortColumn.value === column) {
        // Toggle direction if clicking the same column
        sortDirection.value = sortDirection.value === 'asc' ? 'desc' : 'asc';
      } else {
        // Default to ascending for a new column
        sortColumn.value = column;
        sortDirection.value = 'asc';
      }
    };
    
    const getSortIconClass = (column) => {
      if (sortColumn.value !== column) return 'fa-sort';
      return sortDirection.value === 'asc' ? 'fa-sort-up' : 'fa-sort-down';
    };
    
    const viewClient = (client) => {
      selectedClient.value = { ...client };
      showViewModal.value = true;
    };
    
    const editClient = (client) => {
      // S'assurer que l'ID du client est bien défini
      if (!client || !client.id) {
        console.error('ID client manquant pour l\'édition');
        return;
      }
      
      console.log('Édition du client avec ID:', client.id);
      
      // Émettre l'événement pour le composant parent (ClientManagement)
      emit('edit-client', client);
      
      // Si nous sommes dans un contexte où le parent ne gère pas l'événement,
      // nous utilisons la navigation directe
      if (!props.managedByParent) {
        // Naviguer vers la page d'édition avec l'ID du client
        router.push({
          name: 'edit-client',
          params: { id: client.id },
          // Forcer le rechargement du composant même si la route ne change pas
          query: { _t: Date.now() }
        });
      }
    };
    
    const confirmDelete = (client) => {
      selectedClient.value = { ...client };
      showDeleteModal.value = true;
    };
    
    const deleteClient = async () => {
      isDeleting.value = true;
      try {
        // Save client name before deletion for success message
        deletedClientName.value = `${selectedClient.value.name} ${selectedClient.value.last_name}`;
        
        await axios.delete(`/api/clients/${selectedClient.value.id}`, {
          headers: {
            'Authorization': `Bearer ${localStorage.getItem('token')}`
          }
        });
        
        // Remove from local array
        clients.value = clients.value.filter(c => c.id !== selectedClient.value.id);
        
        // Close delete confirmation modal
        showDeleteModal.value = false;
        
        // Show success modal instead of alert
        showSuccessModal.value = true;
      } catch (error) {
        console.error('Error deleting client:', error);
        alert('Erreur lors de la suppression du client');
      } finally {
        isDeleting.value = false;
      }
    };
    
    const closeSuccessModal = () => {
      showSuccessModal.value = false;
    };
    
    const formatDate = (dateString) => {
      // Vérifier si la date est valide avant de la formater
      if (!dateString || dateString === 'null' || dateString === '0000-00-00') {
        return 'Non définie';
      }
      
      // Essayer de créer un objet Date valide
      try {
        const date = new Date(dateString);
        
        // Vérifier si la date est valide
        if (isNaN(date.getTime())) {
          return 'Date invalide';
        }
        
        const options = { year: 'numeric', month: 'short', day: 'numeric' };
        return date.toLocaleDateString('fr-FR', options);
      } catch (error) {
        console.error('Error formatting date:', error);
        return 'Date invalide';
      }
    };
    
    // Lifecycle hooks
    onMounted(() => {
      isMounted.value = true;
      fetchClients();
    });
    
    // Add onUnmounted hook to prevent updates after component is unmounted
    onUnmounted(() => {
      isMounted.value = false;
    });
    
    return {
      clients,
      loading,
      searchQuery,
      filters,
      sortColumn,
      sortDirection,
      currentPage,
      showViewModal,
      showDeleteModal,
      showSuccessModal,
      selectedClient,
      deletedClientName,
      isDeleting,
      isMounted,
      filteredClients,
      paginatedClients,
      totalPages,
      handleSearch,
      applyFilters,
      resetFilters,
      sortBy,
      getSortIconClass,
      viewClient,
      editClient,
      confirmDelete,
      deleteClient,
      closeSuccessModal,
      formatDate
    };
  }
};
</script>

<style scoped>
.client-list-container {
  padding: 20px;
  max-width: 1200px;
  margin: 0 auto;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30px;
}

.page-header h1 {
  font-size: 24px;
  color: #333;
  margin: 0;
}

.search-filter-container {
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  padding: 20px;
  margin-bottom: 20px;
}

.search-box {
  position: relative;
  margin-bottom: 20px;
}

.search-box input {
  width: 100%;
  padding: 12px 40px 12px 15px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
}

.search-icon {
  position: absolute;
  right: 15px;
  top: 50%;
  transform: translateY(-50%);
  color: #666;
}

.filters {
  display: flex;
  flex-wrap: wrap;
  gap: 15px;
  align-items: flex-end;
}

.filter-group {
  flex: 1;
  min-width: 200px;
}

.filter-group label {
  display: block;
  margin-bottom: 8px;
  font-weight: 500;
  color: #555;
  font-size: 14px;
}

.filter-group select,
.filter-group input {
  width: 100%;
  padding: 10px 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
}

.date-filter {
  flex: 2;
}

.date-inputs {
  display: flex;
  gap: 10px;
  align-items: center;
}

.date-inputs span {
  color: #666;
}

.client-table-container {
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  padding: 20px;
  overflow-x: auto;
}

.client-table {
  width: 100%;
  border-collapse: collapse;
}

.client-table th,
.client-table td {
  padding: 12px 15px;
  text-align: left;
  border-bottom: 1px solid #eee;
}

.client-table th {
  background-color: #f8f9fa;
  font-weight: 600;
  color: #333;
  cursor: pointer;
  user-select: none;
  position: relative;
}

.client-table th.active {
  color: #4a90e2;
}

.client-table th i {
  margin-left: 5px;
}

.client-table tbody tr:hover {
  background-color: #f8f9fa;
}

.client-name {
  font-weight: 500;
}

.company-name {
  font-size: 12px;
  color: #666;
  display: block;
  margin-top: 3px;
}

.badge {
  display: inline-block;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
  font-weight: 500;
}

.badge.individual {
  background-color: #e3f2fd;
  color: #1976d2;
}

.badge.company {
  background-color: #e8f5e9;
  color: #388e3c;
}

.status-badge {
  display: inline-block;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
  font-weight: 500;
}

.status-badge.active {
  background-color: #e8f5e9;
  color: #388e3c;
}

.status-badge.inactive {
  background-color: #ffebee;
  color: #d32f2f;
}

.action-buttons {
  display: flex;
  gap: 5px;
}

.action-btn {
  width: 32px;
  height: 32px;
  border-radius: 4px;
  border: none;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: background-color 0.3s;
}

.view-btn {
  background-color: #e3f2fd;
  color: #1976d2;
}

.view-btn:hover {
  background-color: #bbdefb;
}

.edit-btn {
  background-color: #fff8e1;
  color: #ffa000;
}

.edit-btn:hover {
  background-color: #ffecb3;
}

.delete-btn {
  background-color: #ffebee;
  color: #d32f2f;
}

.delete-btn:hover {
  background-color: #ffcdd2;
}

.loading-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 50px 0;
}

.spinner {
  border: 4px solid rgba(0, 0, 0, 0.1);
  border-radius: 50%;
  border-top: 4px solid #4a90e2;
  width: 40px;
  height: 40px;
  animation: spin 1s linear infinite;
  margin-bottom: 20px;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.no-results {
  text-align: center;
  padding: 50px 0;
}

.no-results i {
  font-size: 48px;
  color: #ccc;
  margin-bottom: 20px;
}

.no-results h3 {
  font-size: 20px;
  color: #333;
  margin-bottom: 10px;
}

.no-results p {
  color: #666;
  margin-bottom: 20px;
}

.pagination {
  display: flex;
  justify-content: center;
  align-items: center;
  margin-top: 20px;
  gap: 10px;
}

.pagination-btn {
  width: 36px;
  height: 36px;
  border-radius: 4px;
  border: 1px solid #ddd;
  background-color: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.3s;
}

.pagination-btn:hover:not(:disabled) {
  background-color: #f5f5f5;
}

.pagination-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.page-info {
  font-size: 14px;
  color: #666;
}

/* Modal styles */
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
}

.client-modal {
  background-color: white;
  border-radius: 12px;
  width: 90%;
  max-width: 700px;
  max-height: 85vh;
  overflow-y: auto;
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.2);
  animation: modalFadeIn 0.3s ease-out;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 25px 30px;
  border-bottom: 1px solid #eee;
  background-color: #f9f9f9;
}

.modal-header h2 {
  font-size: 22px;
  color: #333;
  margin: 0;
  font-weight: 600;
}

.close-btn {
  background: none;
  border: none;
  font-size: 22px;
  cursor: pointer;
  color: #666;
  transition: color 0.2s ease;
}

.close-btn:hover {
  color: #333;
}

.modal-body {
  padding: 30px;
}

.modal-footer {
  padding: 20px 30px;
  border-top: 1px solid #eee;
  display: flex;
  justify-content: flex-end;
  gap: 15px;
  background-color: #f9f9f9;
}

.client-details {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.detail-section {
  border: 1px solid #eee;
  border-radius: 10px;
  padding: 20px;
  background-color: #fcfcfc;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.detail-section h3 {
  font-size: 18px;
  color: #333;
  margin-top: 0;
  margin-bottom: 20px;
  padding-bottom: 12px;
  border-bottom: 1px solid #eee;
  font-weight: 600;
}

.detail-row {
  display: flex;
  flex-wrap: wrap;
  gap: 20px;
  margin-bottom: 15px;
}

.detail-item {
  flex: 1;
  min-width: 200px;
}

.full-width {
  width: 100%;
}

.detail-label {
  display: block;
  font-size: 13px;
  color: #2196F3;
  margin-bottom: 5px;
  font-weight: 500;
}

.detail-value {
  font-size: 14px;
  color: #333;
}

.notes {
  white-space: pre-line;
}

.delete-modal {
  background-color: white;
  border-radius: 8px;
  padding: 25px;
  width: 90%;
  max-width: 500px;
  text-align: center;
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
}

.delete-icon {
  font-size: 48px;
  color: #f44336;
  margin-bottom: 20px;
}

.delete-modal h2 {
  font-size: 24px;
  margin-bottom: 15px;
  color: #333;
}

.delete-modal p {
  color: #666;
  margin-bottom: 10px;
}

.warning-text {
  color: #d32f2f;
  font-size: 14px;
  margin-bottom: 25px;
}

/* Success Modal Styles */
.success-modal {
  background-color: white;
  border-radius: 8px;
  padding: 30px;
  width: 90%;
  max-width: 500px;
  text-align: center;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
}

.success-icon {
  font-size: 60px;
  color: #4caf50;
  margin-bottom: 20px;
}

.success-modal h2 {
  font-size: 24px;
  margin-bottom: 15px;
  color: #333;
}

.success-modal p {
  color: #666;
  margin-bottom: 25px;
}

.modal-actions {
  display: flex;
  justify-content: center;
  gap: 15px;
}

.modal-footer {
  display: flex;
  justify-content: center;
  gap: 15px;
  margin-top: 20px;
}

.modal-btn {
  padding: 10px 20px;
  border-radius: 4px;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  border: none;
  min-width: 100px;
}

.modal-btn-cancel {
  background-color: #f5f5f5;
  color: #333;
}

.modal-btn-delete {
  background-color: #f44336;
  color: white;
}

.modal-btn-cancel:hover {
  background-color: #e0e0e0;
}

.modal-btn-delete:hover {
  background-color: #d32f2f;
}

.modal-btn-primary {
  background-color: #4CAF50;
  color: white;
  padding: 10px 30px;
  font-size: 16px;
  min-width: 120px;
}

.modal-btn-primary:hover {
  background-color: #45a049;
}

/* Nouveaux styles pour les boutons de la modale de détails */
.btn-modal {
  padding: 10px 25px;
  border-radius: 5px;
  font-size: 15px;
  font-weight: 500;
  cursor: pointer;
  border: none;
  transition: all 0.3s ease;
  min-width: 120px;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
}

.btn-modal-secondary {
  background-color: #f5f5f5;
  color: #333;
  border: 1px solid #ddd;
}

.btn-modal-secondary:hover {
  background-color: #e0e0e0;
}

.btn-modal-primary {
  background-color: #2196F3;
  color: white;
}

.btn-modal-primary:hover {
  background-color: #0b7dda;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
}

.btn-danger {
  background-color: #f44336;
  color: white;
}

.delete-btn-large {
  padding: 12px 30px;
  font-size: 16px;
  min-width: 140px;
  margin: 5px;
}

.btn-danger:hover {
  opacity: 0.9;
}

@keyframes modalFadeIn {
  from {
    opacity: 0;
    transform: translateY(-20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@media (max-width: 768px) {
  .filters {
    flex-direction: column;
    gap: 10px;
  }
  
  .filter-group {
    width: 100%;
  }
  
  .date-inputs {
    flex-direction: column;
    align-items: flex-start;
  }
  
  .action-buttons {
    flex-direction: column;
    gap: 5px;
  }
  
  .detail-row {
    flex-direction: column;
    gap: 10px;
  }
  
  .modal-actions {
    flex-direction: column;
    gap: 10px;
  }
}
</style>