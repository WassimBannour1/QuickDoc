<template>
  <div class="tab-content">
    <div class="section-header">
      <h2>Gestion des Utilisateurs</h2>
      <div class="search-container">
        <input 
          type="text" 
          v-model="searchQuery" 
          placeholder="Rechercher un utilisateur..." 
          class="search-input"
          @input="searchUsers"
        />
        <button class="search-btn">
          <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="11" cy="11" r="8"></circle>
            <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
          </svg>
        </button>
      </div>
    </div>

    <!-- Filters -->
    <div class="filters">
      <select v-model="statusFilter" class="filter-select" @change="filterUsers">
        <option value="all">Tous les statuts</option>
        <option value="active">Actifs</option>
        <option value="inactive">Inactifs</option>
      </select>
    </div>

    <!-- Users Table -->
    <div class="table-container">
      <table class="users-table">
        <thead>
          <tr>
            <th>ID</th>
            <th>Nom</th>
            <th>Email</th>
            <th>Date d'inscription</th>
            <th>Statut</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(user, index) in displayedUsers" :key="user.id" :class="{ 'inactive-row': !user.isActive }" style="animation-delay: calc(0.05s * var(--i, index))" class="animated-row">
            <td>{{ user.id }}</td>
            <td>{{ user.name }}</td>
            <td>{{ user.email }}</td>
            <td>{{ formatDate(user.createdAt) }}</td>
            <td>
              <span class="status-badge" :class="user.isActive ? 'active' : 'inactive'">
                {{ user.isActive ? 'Actif' : 'Inactif' }}
              </span>
            </td>
            <td>
              <button 
                class="action-btn" 
                :class="user.isActive ? 'deactivate' : 'activate'"
                @click="toggleUserStatus(user)"
              >
                {{ user.isActive ? 'Désactiver' : 'Activer' }}
              </button>
            </td>
          </tr>
          <tr v-if="displayedUsers.length === 0">
            <td colspan="6" class="no-data">Aucun utilisateur trouvé</td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Pagination -->
    <div class="pagination">
      <button 
        class="page-btn" 
        :disabled="currentPage === 1" 
        @click="currentPage--"
      >
        Précédent
      </button>
      <span class="page-info">Page {{ currentPage }} sur {{ totalPages }}</span>
      <button 
        class="page-btn" 
        :disabled="currentPage === totalPages" 
        @click="currentPage++"
      >
        Suivant
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import axios from 'axios';

// State variables
const users = ref([]);
const searchQuery = ref('');
const statusFilter = ref('all');
const currentPage = ref(1);
const itemsPerPage = 10;

// Computed properties
const filteredUsers = computed(() => {
  let result = [...users.value];
  
  // Apply search filter
  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase();
    result = result.filter(user => 
      user.name.toLowerCase().includes(query) || 
      user.email.toLowerCase().includes(query)
    );
  }
  
  // Apply status filter
  if (statusFilter.value !== 'all') {
    const isActive = statusFilter.value === 'active';
    result = result.filter(user => user.isActive === isActive);
  }
  
  return result;
});

const displayedUsers = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage;
  const end = start + itemsPerPage;
  return filteredUsers.value.slice(start, end);
});

const totalPages = computed(() => {
  return Math.ceil(filteredUsers.value.length / itemsPerPage) || 1;
});

// Methods
const fetchUsers = async () => {
  try {
    // Vérifier si le token existe
    const token = localStorage.getItem('auth_token');
    if (!token) {
      console.error('Aucun token d\'authentification trouvé');
      alert('Vous devez être connecté pour accéder à cette fonctionnalité');
      return;
    }

    // Get real users from API
    const response = await axios.get('http://localhost:5000/api/admin/users', {
      headers: { 'Authorization': `Bearer ${token}` }
    });
    
    if (response.data.success) {
      // Map API response to match component's expected format
      users.value = response.data.users.map(user => ({
        id: user.id,
        name: `${user.first_name} ${user.last_name}`,
        email: user.email,
        createdAt: user.created_at,
        isActive: user.isActive === 1,
        is_verified: user.is_verified === 1
      }));
      console.log('Users retrieved successfully:', users.value);
    }
  } catch (error) {
    console.error('Error fetching users:', error);
    
    // Gestion spécifique de l'erreur 403
    if (error.response && error.response.status === 403) {
      alert('Accès refusé. Vous n\'avez pas les droits d\'administrateur nécessaires.');
    } else {
      alert('Erreur lors de la récupération des utilisateurs. Veuillez réessayer.');
    }
  }
};

const toggleUserStatus = async (user) => {
  try {
    // Call the admin API to toggle user status
    const response = await axios.put(`http://localhost:5000/api/admin/users/${user.id}/toggle-status`, {}, {
      headers: { 'Authorization': `Bearer ${localStorage.getItem('auth_token')}` }
    });
    
    if (response.data.success) {
      // Update local state with the new status
      user.isActive = response.data.status;
    }
  } catch (error) {
    console.error('Error toggling user status:', error);
  }
};

const searchUsers = () => {
  currentPage.value = 1; // Reset to first page when searching
};

const filterUsers = () => {
  currentPage.value = 1; // Reset to first page when filtering
};

const formatDate = (dateString) => {
  const date = new Date(dateString);
  return date.toLocaleDateString('fr-FR');
};

// Fonction pour vérifier si l'utilisateur est admin
const checkAdminAccess = async () => {
  try {
    const token = localStorage.getItem('auth_token');
    if (!token) {
      alert('Vous devez être connecté pour accéder à cette fonctionnalité');
      return false;
    }

    const response = await axios.get('http://localhost:5000/api/admin/check-admin', {
      headers: { 'Authorization': `Bearer ${token}` }
    });

    if (response.data.success) {
      return true;
    } else {
      alert('Accès refusé. Vous n\'avez pas les droits d\'administrateur nécessaires.');
      return false;
    }
  } catch (error) {
    console.error('Error checking admin access:', error);
    alert('Erreur lors de la vérification des droits administrateur.');
    return false;
  }
};

// Lifecycle hooks
onMounted(async () => {
  const hasAccess = await checkAdminAccess();
  if (hasAccess) {
    fetchUsers();
  }
});
</script>

<style scoped>
/* Section Header */
.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30px;
}

.section-header h2 {
  color: #002446;
  font-size: 24px;
  margin: 0;
}

.search-container {
  display: flex;
  align-items: center;
  max-width: 350px;
  width: 100%;
}

.search-input {
  flex: 1;
  padding: 10px 15px;
  border: 2px solid #e1e1e1;
  border-right: none;
  border-radius: 6px 0 0 6px;
  font-size: 14px;
  transition: all 0.3s;
}

.search-input:focus {
  outline: none;
  border-color: #002446;
}

.search-btn {
  background: #002446;
  color: white;
  border: none;
  padding: 12px 15px;
  border-radius: 0 6px 6px 0;
  cursor: pointer;
  transition: all 0.3s;
}

.search-btn:hover {
  background: #003a6c;
}

/* Filters */
.filters {
  margin-bottom: 20px;
}

.filter-select {
  padding: 8px 12px;
  border: 2px solid #e1e1e1;
  border-radius: 6px;
  width: 200px;
  font-size: 14px;
  color: #333;
  background-color: white;
  cursor: pointer;
  transition: all 0.3s;
}

.filter-select:focus {
  outline: none;
  border-color: #002446;
}

/* Table */
.table-container {
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
  overflow: hidden;
  margin-bottom: 20px;
}

.users-table {
  width: 100%;
  border-collapse: collapse;
}

.users-table th {
  background-color: #f8f9fa;
  color: #002446;
  text-align: left;
  padding: 15px;
  font-weight: 600;
  border-bottom: 2px solid #e1e1e1;
}

.users-table td {
  padding: 15px;
  border-bottom: 1px solid #e1e1e1;
  color: #333;
}

.users-table tbody tr {
  transition: background-color 0.3s;
}

.users-table tbody tr:hover {
  background-color: #f5f8ff;
}

.users-table tbody tr:last-child td {
  border-bottom: none;
}

.status-badge {
  display: inline-block;
  padding: 5px 10px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: 500;
}

.status-badge.active {
  background-color: #e6f7ee;
  color: #00a86b;
}

.status-badge.inactive {
  background-color: #fff1f1;
  color: #ff4d4f;
}

.action-btn {
  padding: 6px 12px;
  border: none;
  border-radius: 4px;
  font-size: 12px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s;
}

.action-btn.deactivate {
  background-color: #fff1f1;
  color: #ff4d4f;
}

.action-btn.deactivate:hover {
  background-color: #ffcccb;
}

.action-btn.activate {
  background-color: #e6f7ee;
  color: #00a86b;
}

.action-btn.activate:hover {
  background-color: #d0f0e0;
}

.no-data {
  text-align: center;
  color: #999;
  padding: 30px;
}

/* Pagination */
.pagination {
  display: flex;
  justify-content: center;
  align-items: center;
  margin-top: 30px;
}

.page-btn {
  padding: 8px 15px;
  background-color: white;
  border: 2px solid #e1e1e1;
  border-radius: 6px;
  cursor: pointer;
  transition: all 0.3s;
  color: #333;
  font-weight: 500;
}

.page-btn:hover:not(:disabled) {
  background-color: #002446;
  color: white;
  border-color: #002446;
}

.page-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.page-info {
  margin: 0 15px;
  color: #666;
}

/* Animation classes */
.animated-row {
  animation: fadeInUp 0.5s ease forwards;
  opacity: 0;
  transform: translateY(20px);
  animation-delay: calc(0.05s * var(--i, 0));
}

.inactive-row {
  background-color: #fafafa;
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* Responsive */
@media (max-width: 992px) {
  .section-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 15px;
  }

  .search-container {
    max-width: 100%;
  }
}

@media (max-width: 768px) {
  .table-container {
    overflow-x: auto;
  }
  
  .users-table {
    min-width: 800px;
  }
}
</style>
