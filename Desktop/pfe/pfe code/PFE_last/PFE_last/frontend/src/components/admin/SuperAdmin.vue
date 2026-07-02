<template>
  <div class="dashboard-container" :class="{ 'sidebar-collapsed': !sidebarExpanded }">
    <!-- Sidebar -->
    <div 
      class="sidebar" 
      @mouseenter="expandSidebar" 
      @mouseleave="collapseSidebar" 
      :class="{ 'collapsed': !sidebarExpanded }"
    >
      <!-- Bouton de bascule de la barre latérale -->
      <div class="sidebar-toggle-button" @click="sidebarExpanded ? collapseSidebar() : expandSidebar()">
        <i :class="sidebarExpanded ? 'fas fa-chevron-left' : 'fas fa-chevron-right'"></i>
        <span class="toggle-tooltip">{{ sidebarExpanded ? 'Réduire' : 'Étendre' }}</span>
      </div>
      
      <div class="logo-container">
          <img src="@/assets/logo.jpg" alt="QuikDoc Logo" class="logo">
          <h1 class="site-name">QuikDoc</h1>
        </div>
        
        <div class="sidebar-menu">
        <!-- Gestion des Utilisateurs -->
          <div 
            class="menu-item" 
            @click="activeTab = 'users'" 
            :class="{ 'active': activeTab === 'users' }"
            style="--i: 1"
          >
            <span class="menu-icon"><i class="fas fa-users"></i></span>
            <span class="menu-title">Gestion des Utilisateurs</span>
          </div>

        <!-- Statistiques -->
          <div 
            class="menu-item" 
            @click="activeTab = 'stats'" 
            :class="{ 'active': activeTab === 'stats' }"
            style="--i: 2"
          >
            <span class="menu-icon"><i class="fas fa-chart-bar"></i></span>
            <span class="menu-title">Statistiques</span>
          </div>

          <!-- Template Management -->
          <div 
            class="menu-item" 
          @click="toggleTemplateMenu" 
          :class="{ 'active': isTemplateActive }"
            style="--i: 3"
          >
            <span class="menu-icon"><i class="fas fa-file-alt"></i></span>
          <span class="menu-title">Gestion Templates</span>
          <span class="dropdown-icon" :class="{ 'rotated': showTemplateMenu }">
            <i class="fas fa-chevron-down"></i>
          </span>
        </div>
        
        <div class="submenu" v-show="showTemplateMenu">
          <div class="submenu-item" @click="activeTab = 'create-template'" :class="{ 'active': activeTab === 'create-template' }" style="--i: 0">
            <span class="submenu-icon"><i class="fas fa-plus-circle"></i></span>
            <span class="submenu-title">Créer Template</span>
          </div>
          <div class="submenu-item" @click="activeTab = 'predefined-templates'" :class="{ 'active': activeTab === 'predefined-templates' }" style="--i: 1">
            <span class="submenu-icon"><i class="fas fa-clipboard-list"></i></span>
            <span class="submenu-title">Templates Prédéfinis</span>
          </div>
          </div>

          <!-- Database Backup -->
          <div 
            class="menu-item" 
            @click="activeTab = 'backup'" 
            :class="{ 'active': activeTab === 'backup' }"
            style="--i: 4"
          >
            <span class="menu-icon"><i class="fas fa-database"></i></span>
            <span class="menu-title">Backup</span>
        </div>
      </div>
      
      <!-- User Profile Section in Sidebar (Bottom) -->
      <div class="sidebar-user-section" @mouseleave="showUserSidebarMenu = false">
        <div class="sidebar-user-container" @click="toggleUserSidebarMenu">
          <div class="sidebar-user-avatar">
            <div class="avatar-letter">S</div>
          </div>
          <div class="sidebar-user-info">
            <p class="sidebar-user-name">Super Admin</p>
            <p class="sidebar-user-email">admin@quikdoc.com</p>
          </div>
          <span class="dropdown-icon" :class="{ 'rotated': showUserSidebarMenu }">
            <i class="fas fa-chevron-down"></i>
          </span>
        </div>
        
        <!-- User Sidebar Menu Options -->
        <div class="sidebar-user-menu" v-if="showUserSidebarMenu">
          <div class="sidebar-menu-option" @click="activeTab = 'profile'; showUserSidebarMenu = false">
            <i class="fas fa-user"></i>
            <span>Mon Profil</span>
          </div>
          <div class="sidebar-menu-option sidebar-logout" @click="navigateToHome">
            <i class="fas fa-sign-out-alt"></i>
            <span>Déconnexion</span>
          </div>
        </div>
      </div>
    </div>

    <!-- Main Content -->
    <div class="main-content">
      <!-- Dashboard Content -->
      <main class="dashboard">
        <!-- Users Management Tab -->
        <UserManagement v-if="activeTab === 'users'" />

        <!-- Statistics Tab -->
        <Statistics v-if="activeTab === 'stats'" />

        <!-- Create Template Tab -->
        <div v-if="activeTab === 'create-template'" class="tab-content">
          <TemplateManagementView ref="templateManagementView" />
        </div>

        <!-- Predefined Templates List Tab -->
        <div v-if="activeTab === 'predefined-templates'" class="tab-content">
          <div class="section-header">
            <h2>Templates Prédéfinis</h2>
          </div>
          <TemplateList 
            documentType="facture" 
            templateType="predefined"
            ref="predefinedTemplateList"
            @edit-template="handleEditTemplate"
          />
        </div>

        <!-- Database Backup Tab -->
        <DatabaseBackup v-if="activeTab === 'backup'" />

        <!-- Profile Tab -->
        <ProfileComponent v-if="activeTab === 'profile'" @close="handleProfileClose" />
      </main>
    </div>
  </div>
</template>

<script>
import { ref, computed, onBeforeMount, onMounted, watch } from 'vue';
import axios from 'axios';
import { useRouter } from 'vue-router';
import { useMainStore } from '../../stores';
import UserManagement from './UserManagement.vue';
import Statistics from './Statistics.vue';
import DatabaseBackup from './DatabaseBackup.vue';
import ProfileComponent from '../ProfileComponent.vue';
import TemplateManagementView from './TemplateManagementView.vue';
import TemplateList from './TemplateList.vue';

// Import FontAwesome
const fontAwesomeLink = document.createElement('link');
fontAwesomeLink.rel = 'stylesheet';
fontAwesomeLink.href = 'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css';
document.head.appendChild(fontAwesomeLink);

// Import admin menu styles
import '@/assets/admin-menu.css';

export default {
  components: {
    UserManagement,
    Statistics,
    DatabaseBackup,
    ProfileComponent,
    TemplateManagementView,
    TemplateList
  },
  setup() {
    // Router for navigation
    const router = useRouter();

    // Admin authentication state
    const isAdmin = ref(false);
    const adminUser = ref(null);
    const loading = ref(true);
    const error = ref(null);

    // UI state
    const sidebarExpanded = ref(true);
    const showUserSidebarMenu = ref(false);
    const showTemplateMenu = ref(false);

    // State variables
    const activeTab = ref('users'); // Default to user management tab
    
    // Watch for route query changes
    watch(
      () => router.currentRoute.value.query,
      (newQuery) => {
        if (newQuery.tab) {
          activeTab.value = newQuery.tab;
          if (newQuery.tab.includes('template')) {
            showTemplateMenu.value = true;
          }
        }
      },
      { immediate: true } // This will run on component creation too
    );
    
    // Computed properties
    const isTemplateActive = computed(() => {
      return ['templates', 'create-template', 'predefined-templates'].includes(activeTab.value);
    });
    
    // Template submenu toggling
    const toggleTemplateMenu = () => {
      showTemplateMenu.value = !showTemplateMenu.value;
      
      // If opening the menu, ensure the parent tab is active
      if (showTemplateMenu.value) {
        activeTab.value = 'templates';
      }
    };

    // Sidebar functions
    function expandSidebar() {
      sidebarExpanded.value = true;
    }

    function collapseSidebar() {
      sidebarExpanded.value = false;
    }

    function toggleUserSidebarMenu() {
      showUserSidebarMenu.value = !showUserSidebarMenu.value;
    }

    // Methods
    const checkAdminAccess = async () => {
      try {
        loading.value = true;
        error.value = null;
        
        // Get token from localStorage
        const token = localStorage.getItem('auth_token');
        if (!token) {
          throw new Error('Token non trouvé. Veuillez vous connecter.');
        }
        
        // Check if user is admin
        const response = await axios.get('http://localhost:5000/api/admin/check-admin', {
          headers: { 'Authorization': `Bearer ${token}` }
        });
        
        if (response.data.success) {
          isAdmin.value = true;
          adminUser.value = response.data.user;
          return true;
        } else {
          throw new Error('Accès non autorisé');
        }
      } catch (err) {
        console.error('Admin access check error:', err);
        error.value = err.response?.data?.message || err.message || 'Erreur d\'accès administrateur';
        isAdmin.value = false;
        // Redirect to login if not admin
        router.push('/login');
        return false;
      } finally {
        loading.value = false;
      }
    };

    const navigateToHome = () => {
      // Get the store to properly clear user data
      const store = useMainStore();
      
      // Clear all authentication data
      localStorage.removeItem('auth_token');
      localStorage.removeItem('token'); // Clear both possible token names
      localStorage.removeItem('user');
      
      // Clear the Pinia store
      store.logout();
      
      // Use hard reload to ensure everything is reset
      window.location.href = 'http://localhost:5173/accueil';
    };

    // Handle profile component close event
    const handleProfileClose = (targetTab) => {
      // If a specific tab is requested (for admin users), go to that tab
      if (targetTab === 'users') {
        activeTab.value = 'users';
      } else {
        // Otherwise go back to the default tab
        activeTab.value = 'users';
      }
    };

    // Handle template editing
    const handleEditTemplate = (template) => {
      console.log('SuperAdmin: handleEditTemplate called with template:', template);
      activeTab.value = 'create-template';
      
      // Need to wait for the component to be rendered
      setTimeout(() => {
        if (document.querySelector('.template-management-view')) {
          // Get the TemplateManagementView component instance
          const templateViewRef = document.querySelector('.template-management-view').__vueParentComponent.ctx;
          
          if (templateViewRef) {
            console.log('Setting template edit mode and ID');
            templateViewRef.editMode = true;
            templateViewRef.templateId = template.id;
          } else {
            console.error('Template management view component not found');
          }
        }
      }, 200);
    };

    // Check admin access on component creation
    onBeforeMount(async () => {
      await checkAdminAccess();
    });

    return {
      // State
      isAdmin,
      adminUser,
      loading,
      error,
      sidebarExpanded,
      showUserSidebarMenu,
      activeTab,
      showTemplateMenu,
      isTemplateActive,
      
      // Methods
      expandSidebar,
      collapseSidebar,
      toggleUserSidebarMenu,
      checkAdminAccess,
      navigateToHome,
      handleProfileClose,
      toggleTemplateMenu,
      handleEditTemplate
    };
  }
};
</script>

<style scoped>
.dashboard-container {
  display: flex;
  min-height: 100vh;
  background-color: #f5f7fa;
  position: relative;
  overflow: hidden;
}

.sidebar {
  width: 260px;
  background: linear-gradient(to bottom, #002446, #004080);
  color: white;
  height: 100vh;
  position: fixed;
  top: 0;
  left: 0;
  display: flex;
  flex-direction: column;
  box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
  transition: all 0.3s ease;
  z-index: 1000;
  overflow-y: auto;
  overflow-x: hidden;
}

.sidebar.collapsed {
  width: 70px;
}

.sidebar-toggle-button {
  position: absolute;
  top: 20px;
  right: 10px;
  width: 30px;
  height: 30px;
  background-color: rgba(255, 255, 255, 0.1);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.3s ease;
  z-index: 2;
}

.sidebar-toggle-button:hover {
  background-color: rgba(255, 255, 255, 0.2);
}

.toggle-tooltip {
  position: absolute;
  right: 40px;
  background-color: rgba(0, 0, 0, 0.7);
  color: white;
  padding: 5px 10px;
  border-radius: 4px;
  font-size: 12px;
  opacity: 0;
  pointer-events: none;
  transition: opacity 0.3s ease;
  white-space: nowrap;
}

.sidebar-toggle-button:hover .toggle-tooltip {
  opacity: 1;
}

.logo-container {
  display: flex;
  align-items: center;
  padding: 20px;
  margin-bottom: 20px;
}

.logo {
  width: 40px;
  height: 40px;
  margin-right: 15px;
  transition: all 0.3s ease;
}

.site-name {
  font-size: 1.5rem;
  font-weight: bold;
  color: white;
  transition: all 0.3s ease;
}

.sidebar.collapsed .site-name {
    display: none;
  }
  
.sidebar.collapsed .logo {
  margin-right: 0;
}

/* User section styles */
.sidebar-user-section {
  margin-top: auto;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  padding: 15px;
  position: relative;
}

.sidebar-user-container {
  display: flex;
  align-items: center;
  cursor: pointer;
  padding: 5px;
  border-radius: 5px;
  transition: background-color 0.3s ease;
}

.sidebar-user-container:hover {
  background-color: rgba(255, 255, 255, 0.1);
}

.sidebar-user-avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  background-color: #4bc0c0;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 10px;
  transition: all 0.3s ease;
}

.avatar-letter {
  font-size: 20px;
  font-weight: bold;
  color: white;
}

.sidebar-user-info {
  flex: 1;
  overflow: hidden;
  transition: all 0.3s ease;
}

.sidebar-user-name {
  font-weight: 500;
  margin: 0;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.sidebar-user-email, .sidebar-user-role {
  font-size: 0.8rem;
  margin: 0;
  color: rgba(255, 255, 255, 0.7);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.sidebar.collapsed .sidebar-user-info {
  display: none;
}

.dropdown-icon {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.7);
  transition: transform 0.3s ease;
}

.dropdown-icon.rotated {
  transform: rotate(180deg);
}

.sidebar.collapsed .dropdown-icon {
  display: none;
}

.sidebar-user-menu {
  margin-top: 10px;
  background-color: rgba(0, 0, 0, 0.2);
  border-radius: 5px;
  overflow: hidden;
}

.sidebar-menu-option {
  padding: 10px;
  display: flex;
  align-items: center;
  transition: background-color 0.3s ease;
  cursor: pointer;
}

.sidebar-menu-option:hover {
  background-color: rgba(255, 255, 255, 0.1);
}

.sidebar-menu-option i {
  margin-right: 10px;
  width: 20px;
  text-align: center;
}

.sidebar-logout {
  color: #ff6b6b;
}

/* Main content styles */
.main-content {
  flex: 1;
  margin-left: 260px;
  transition: margin-left 0.3s ease;
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}

.dashboard-container.sidebar-collapsed .main-content {
  margin-left: 70px;
}

.dashboard {
  flex: 1;
  padding: 20px;
  overflow-y: auto;
}

.tab-content {
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
  padding: 20px;
  margin-bottom: 20px;
}

/* Animation keyframes */
@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

@keyframes slideInRight {
  from { transform: translateX(20px); opacity: 0; }
  to { transform: translateX(0); opacity: 1; }
}

@keyframes fadeInUp {
  from { transform: translateY(20px); opacity: 0; }
  to { transform: translateY(0); opacity: 1; }
}

@keyframes bounceIn {
  0% { transform: scale(0.8); opacity: 0; }
  70% { transform: scale(1.05); opacity: 1; }
  100% { transform: scale(1); opacity: 1; }
}

@keyframes profilePhotoAppear {
  0% { transform: scale(0) rotate(180deg); opacity: 0; }
  60% { transform: scale(1.2) rotate(-20deg); opacity: 1; }
  100% { transform: scale(1) rotate(0deg); opacity: 1; }
}
</style>