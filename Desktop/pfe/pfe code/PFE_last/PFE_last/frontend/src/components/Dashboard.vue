/* Enhanced Animation Keyframes */
@keyframes fadeIn {
  0% { opacity: 0; }
  100% { opacity: 1; }
}

@keyframes fadeInUp {
  0% { opacity: 0; transform: translateY(20px); }
  100% { opacity: 1; transform: translateY(0); }
}

@keyframes fadeInLeft {
  0% { opacity: 0; transform: translateX(-20px); }
  100% { opacity: 1; transform: translateX(0); }
}

@keyframes pulse {
  0% { transform: scale(1); }
  50% { transform: scale(1.05); }
  100% { transform: scale(1); }
}

@keyframes shimmer {
  0% { background-position: -100% 0; }
  100% { background-position: 200% 0; }
}

@keyframes floatIcon {
  0% { transform: translateY(0); }
  50% { transform: translateY(-5px); }
  100% { transform: translateY(0); }
}.menu-item {
  border-radius: 10px;
  transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
  position: relative;
  overflow: hidden;
  animation: fadeInLeft 0.5s forwards;
  animation-delay: calc(var(--i, 0) * 0.1s);
  opacity: 0;
}

.menu-item::before {
  content: '';
  position: absolute;
  left: 0;
  top: 0;
  width: 4px;
  height: 0;
  background: linear-gradient(180deg, #4a6cf7, #4a6cf7);
  opacity: 0;
  transition: all 0.3s ease;
  border-radius: 0 4px 4px 0;
}

.menu-item:hover::before {
  opacity: 1;
  height: 100%;
}

.menu-item:hover {
  background: rgba(255, 255, 255, 0.1);
  transform: translateX(5px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.menu-icon {
  background: rgba(255, 255, 255, 0.1);
  border-radius: 8px;
  transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
}

.menu-item:hover .menu-icon {
  background: #4a6cf7;
  transform: rotate(-10deg);
  animation: floatIcon 2s infinite;
}
<template>
  <div class="dashboard-container">
    <!-- Sidebar -->
    <div class="sidebar" @mouseenter="expandSidebar" @mouseleave="collapseSidebar" :class="{ 'collapsed': !sidebarExpanded }">
      <!-- Bouton de bascule de la barre latérale -->
      <div class="sidebar-toggle-button" @click="sidebarExpanded ? collapseSidebar() : expandSidebar()">
        <i :class="sidebarExpanded ? 'fas fa-chevron-left' : 'fas fa-chevron-right'"></i>
        <span class="toggle-tooltip">{{ sidebarExpanded ? 'Réduire' : 'Étendre' }}</span>
      </div>
      <div class="logo-container" @click="navigateTo('accueil')" style="cursor: pointer;">
        <img src="@/assets/logo.jpg" alt="QuikDoc Logo" class="logo">
        <h1 class="site-name">QuikDoc</h1>
      </div>
      
      <div class="sidebar-menu">
        <div class="menu-item" @click="navigateTo('accueil')" :class="{ 'active': isActive('accueil') }">
          <span class="menu-icon">
            <i class="fas fa-home"></i>
          </span>
          <span class="menu-title">Accueil</span>
        </div>

        <div class="menu-item" @click="toggleDocumentsMenu" :class="{ 'active': isActive('factures') || isActive('devis') }">
          <span class="menu-icon">
            <i class="fas fa-file-alt"></i>
          </span>
          <span class="menu-title">Documents</span>
          <span class="dropdown-icon" :class="{ 'rotated': showDocumentsMenu }">
            <i class="fas fa-chevron-down"></i>
          </span>
        </div>
        
        <div class="submenu" v-show="showDocumentsMenu">
          <div class="submenu-item" @click="navigateTo('factures')" :class="{ 'active': isActive('factures') }">
            <span class="submenu-icon">
              <i class="fas fa-file-invoice"></i>
            </span>
            <span class="submenu-title">Factures</span>
          </div>
          <div class="submenu-item" @click="navigateTo('devis')" :class="{ 'active': isActive('devis') }">
            <span class="submenu-icon">
              <i class="fas fa-file-contract"></i>
            </span>
            <span class="submenu-title">Devis</span>
          </div>
        </div>
        
        <div class="menu-item" @click="navigateTo('paiements')" :class="{ 'active': isActive('paiements') }">
          <span class="menu-icon">
            <i class="fas fa-credit-card"></i>
          </span>
          <span class="menu-title">Paiement</span>
        </div>
      </div>
      
      <!-- User Profile Section in Sidebar (Bottom) -->
      <div class="sidebar-user-section" @mouseleave="showUserSidebarMenu = false">
        <div class="sidebar-user-container" @click="toggleUserSidebarMenu">
          <div class="sidebar-user-avatar">
            <div v-if="store.user && store.user.first_name" class="avatar-letter">
              {{ store.user.first_name.charAt(0).toUpperCase() }}
            </div>
            <img v-else src="https://via.placeholder.com/150" alt="User Avatar" class="sidebar-avatar-img">
          </div>
          <div class="sidebar-user-info">
            <p class="sidebar-user-name">{{ userName }}</p>
            <p class="sidebar-user-email">{{ userEmail }}</p>
          </div>
          <span class="dropdown-icon" :class="{ 'rotated': showUserSidebarMenu }">
            <i class="fas fa-chevron-down"></i>
          </span>
        </div>
        
        <!-- User Sidebar Menu Options -->
        <div class="sidebar-user-menu" v-show="showUserSidebarMenu">
          <div class="sidebar-menu-option" @click="showProfileContent = true; showUserSidebarMenu = false">
            <i class="fas fa-user"></i>
            <span>Mon Profil</span>
          </div>
          <div class="sidebar-menu-option sidebar-logout" @click="handleLogout">
            <i class="fas fa-sign-out-alt"></i>
            <span>Déconnecter</span>
          </div>
        </div>
      </div>
      

    </div>
    
    <!-- Main Content -->
    <div class="main-content">
      <!-- Top Navigation Bar -->
      <div class="top-navbar">
        <div class="page-title">
          <h2>Tableau de bord</h2>
        </div>
        
        <div class="navbar-actions">
          <!-- Notifications -->
          <div class="notification-container">
            <div class="notification-icon" @click="toggleNotifications">
              <i class="fas fa-bell"></i>
              <span v-if="unreadNotificationCount > 0" class="notification-badge">{{ unreadNotificationCount }}</span>
            </div>
            
            <!-- Notification Dropdown -->
            <FadeTransition name="fade-scale">
              <div class="notification-dropdown" v-show="showNotifications">
                <div class="notification-header">
                  <h3>Notifications</h3>
                  <div class="notification-actions">
                    <button v-if="notifications.length > 0" @click="markAllAsRead" class="notification-action-btn">
                      <i class="fas fa-check-double"></i>
                      <span class="action-tooltip">Tout marquer comme lu</span>
                    </button>
                    <button v-if="notifications.length > 0" @click="clearAllNotifications" class="notification-action-btn">
                      <i class="fas fa-trash-alt"></i>
                      <span class="action-tooltip">Effacer tout</span>
                    </button>
                  </div>
                </div>
                <div class="notification-list" v-if="notifications.length > 0">
                  <ListTransition name="stagger">
                    <div v-for="(notification, index) in notifications" 
                         :key="index" 
                         class="notification-item" 
                         :class="{ 'unread': !notification.read }" 
                         :style="{ '--i': index }">
                      <div class="notification-content">
                        <div class="notification-icon-indicator" v-if="!notification.read"></div>
                        <div class="notification-text-container">
                          <p class="notification-text">{{ notification.message }}</p>
                          <p class="notification-time">{{ notification.time }}</p>
                        </div>
                      </div>
                      <div class="notification-actions-container">
                        <button @click.stop="markAsRead(index)" class="notification-item-btn" v-if="!notification.read">
                          <i class="fas fa-check"></i>
                        </button>
                        <button @click.stop="removeNotification(index)" class="notification-item-btn delete">
                          <i class="fas fa-times"></i>
                        </button>
                      </div>
                    </div>
                  </ListTransition>
                </div>
                <div v-else class="empty-notifications">
                  <i class="fas fa-bell-slash empty-icon"></i>
                  <p>Aucune notification</p>
                </div>
              </div>
            </FadeTransition>
          </div>
          
          <!-- Removed User Profile from top navbar -->
        </div>
      </div>
      
      <!-- Dashboard Content -->
      <div class="dashboard-content">
        <!-- Profile Content (shown when user clicks on Mon Profil) -->
        <ProfileComponent v-if="showProfileContent" @close="showProfileContent = false" />
        
        <!-- Factures View (shown when user clicks on Factures) -->
        <FacturesView v-else-if="currentView === 'factures'" />
        
        <!-- Devis View (shown when user clicks on Devis) -->
        <DevisView v-else-if="currentView === 'devis'" />
        
        <!-- Regular Dashboard Content (shown when profile is not displayed and no specific view is selected) -->
        <div v-else>
          <div class="welcome-message">
            <h2>Bienvenue, {{ userName }}!</h2>
            <p>Gérez vos documents et paiements en toute simplicité.</p>
          </div>
          
          <!-- Dashboard Widgets will go here -->
          <div class="dashboard-widgets">
            <WidgetTransition name="widget" appear :style="{ '--delay': 0 }">
              <div class="widget">
                <div class="widget-header">
                  <h3></h3>
                </div>
                <div class="widget-content">
                  <div class="guide-content">
                    <i class="fas fa-lightbulb guide-icon"></i>
                    <div>
                      <p class="guide-title">Consultez vos factures</p>
                      <p class="guide-text">Accédez à toutes vos factures en un seul endroit. Vous pouvez consulter l'historique de vos factures, vérifier leur statut et télécharger les documents pour vos archives personnelles.</p>

                    </div>
                  </div>
                </div>
              </div>
            </WidgetTransition>
            
            <WidgetTransition name="widget" appear :style="{ '--delay': 1 }">
              <div class="widget">
                <div class="widget-header">
                  <h3></h3>
                </div>
                <div class="widget-content">
                  <div class="guide-content">
                    <i class="fas fa-file-signature guide-icon"></i>
                    <div>
                      <p class="guide-title">Consultez vos devis</p>
                      <p class="guide-text">Retrouvez tous les devis qui vous ont été proposés. Vous pouvez examiner les détails, accepter ou refuser les offres, et suivre l'évolution de vos projets en cours.</p>

                    </div>
                  </div>
                </div>
              </div>
            </WidgetTransition>
            
            <WidgetTransition name="widget" appear :style="{ '--delay': 2 }">
              <div class="widget">
                <div class="widget-header">
                  <h3></h3>
                </div>
                <div class="widget-content">
                  <div class="guide-content">
                    <i class="fas fa-money-check-alt guide-icon"></i>
                    <div>
                      <p class="guide-title">Payez vos factures</p>
                      <p class="guide-text">Effectuez vos paiements en toute sécurité. Vous pouvez régler vos factures en ligne, consulter votre historique de paiements et recevoir des confirmations instantanées pour chaque transaction.</p>

                    </div>
                  </div>
                </div>
              </div>
            </WidgetTransition>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { useMainStore } from '@/stores';
import { TransitionGroup } from 'vue';
import api from '@/services/api';
import ProfileComponent from './ProfileComponent.vue';
import FacturesView from './FacturesView.vue';
import DevisView from './DevisView.vue';

// Composants de transition personnalisés
const ListTransition = TransitionGroup;
const WidgetTransition = TransitionGroup;

// FontAwesome Icons
const fontAwesomeLink = document.createElement('link');
fontAwesomeLink.rel = 'stylesheet';
fontAwesomeLink.href = 'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css';
document.head.appendChild(fontAwesomeLink);

const router = useRouter();
const store = useMainStore();

// User data
const userName = computed(() => {
  return store.user ? `${store.user.first_name} ${store.user.last_name}` : 'Utilisateur';
});

const userEmail = computed(() => {
  return store.user ? store.user.email : '';
});

const userProfilePhoto = computed(() => {
  // Vérifier si l'utilisateur a une photo de profil
  if (!store.user) return null;
  
  // Utiliser photo_url s'il existe
  if (store.user.photo_url) {
    // Vérifier si le chemin commence déjà par http ou est un chemin absolu
    if (store.user.photo_url.startsWith('http') || store.user.photo_url.startsWith('data:')) {
      return store.user.photo_url;
    } else {
      // Ajouter le préfixe du serveur si nécessaire
      return `http://localhost:5000${store.user.photo_url}`;
    }
  }
  
  // Utiliser photo_path comme fallback si photo_url n'existe pas
  if (store.user.photo_path) {
    // Vérifier si le chemin commence déjà par http ou est un chemin absolu
    if (store.user.photo_path.startsWith('http') || store.user.photo_path.startsWith('data:')) {
      return store.user.photo_path;
    } else {
      // Ajouter le préfixe du serveur si nécessaire
      return `http://localhost:5000${store.user.photo_path}`;
    }
  }
  
  return null;
});

// Sidebar state
const sidebarExpanded = ref(true);

const collapseSidebar = () => {
  sidebarExpanded.value = false;
};

const expandSidebar = () => {
  sidebarExpanded.value = true;
};

// User sidebar menu
const showUserSidebarMenu = ref(false);

const toggleUserSidebarMenu = () => {
  showUserSidebarMenu.value = !showUserSidebarMenu.value;
};

// Profile content state
const showProfileContent = ref(false);

// Notifications
const showNotifications = ref(false);
const notifications = ref([
  { message: 'Nouvelle facture créée', time: 'Il y a 2 heures', read: false },
  { message: 'Paiement reçu', time: 'Il y a 1 jour', read: false },
  { message: 'Bienvenue sur QuikDoc', time: 'Il y a 3 jours', read: true }
]);

// Computed property for unread notifications count
const unreadNotificationCount = computed(() => {
  return notifications.value.filter(notification => !notification.read).length;
});

const toggleNotifications = () => {
  showNotifications.value = !showNotifications.value;
  if (showUserMenu.value) showUserMenu.value = false;
};

// Mark a specific notification as read
const markAsRead = (index) => {
  if (index >= 0 && index < notifications.value.length) {
    notifications.value[index].read = true;
  }
};

// Mark all notifications as read
const markAllAsRead = () => {
  notifications.value.forEach(notification => {
    notification.read = true;
  });
};

// Remove a specific notification
const removeNotification = (index) => {
  if (index >= 0 && index < notifications.value.length) {
    notifications.value.splice(index, 1);
  }
};

// Clear all notifications
const clearAllNotifications = () => {
  notifications.value = [];
};

// User menu
const showUserMenu = ref(false);

const toggleUserMenu = () => {
  showUserMenu.value = !showUserMenu.value;
  if (showNotifications.value) showNotifications.value = false;
};

// Documents menu
const showDocumentsMenu = ref(false);

const toggleDocumentsMenu = () => {
  showDocumentsMenu.value = !showDocumentsMenu.value;
};

// Navigation and view management
const currentView = ref('');

const navigateTo = (route) => {
  console.log(`Navigating to ${route}`);
  if (route === 'factures' || route === 'devis' || route === 'paiements') {
    // Set the current view for internal navigation
    currentView.value = route;
    showProfileContent.value = false; // Hide profile if it was showing
  } else if (route === 'accueil') {
    // Reset to dashboard home content
    currentView.value = '';
    showProfileContent.value = false;
  } else {
    // External navigation
    router.push(`/${route}`);
  }
};

// Function to check if a route is active
const isActive = (route) => {
  if (route === 'accueil') {
    // Check if we're on the dashboard home page (no specific view selected)
    return currentView.value === '' && !showProfileContent.value;
  }
  return currentView.value === route;
};

// Logout
const handleLogout = () => {
  store.logout();
  router.push('/accueil');
};

// Initialize event listeners
onMounted(() => {
  document.addEventListener('click', (event) => {
    const notificationContainer = document.querySelector('.notification-container');
    const userProfile = document.querySelector('.user-profile');
    
    if (notificationContainer && !notificationContainer.contains(event.target)) {
      showNotifications.value = false;
    }
    
    if (userProfile && !userProfile.contains(event.target)) {
      showUserMenu.value = false;
    }
  });
  
  // Écouter l'événement personnalisé pour la navigation
  window.addEventListener('navigate-dashboard', (event) => {
    if (event.detail && event.detail.view) {
      currentView.value = event.detail.view;
      console.log(`Vue définie sur ${event.detail.view} via événement personnalisé`);
    }
  });
});

// Close dropdowns when clicking outside
onMounted(() => {
  document.addEventListener('click', (event) => {
    const notificationContainer = document.querySelector('.notification-container');
    const userProfile = document.querySelector('.user-profile');
    
    if (notificationContainer && !notificationContainer.contains(event.target)) {
      showNotifications.value = false;
    }
    
    if (userProfile && !userProfile.contains(event.target)) {
      showUserMenu.value = false;
    }
  });
});
</script>

<style scoped>
/* Main Layout */
.dashboard-container {
  display: flex;
  min-height: 100vh;
  background-color: #f5f5f5;
}

/* Guide Content Styles */
.guide-content {
  display: flex;
  align-items: flex-start;
  padding: 15px;
  background-color: #f8f9fa;
  border-radius: 8px;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
  transition: all 0.3s ease;
}

.guide-content:hover {
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
  transform: translateY(-2px);
}

.guide-icon {
  font-size: 2rem;
  color: #4a6cf7;
  margin-right: 15px;
  padding: 10px;
  background-color: rgba(74, 108, 247, 0.1);
  border-radius: 50%;
  width: 50px;
  height: 50px;
  display: flex;
  align-items: center;
  justify-content: center;
  animation: pulse 2s infinite;
}

.guide-title {
  font-size: 1.1rem;
  font-weight: 600;
  color: #333;
  margin-bottom: 8px;
}

.guide-text {
  font-size: 0.9rem;
  color: #666;
  line-height: 1.5;
  margin-bottom: 15px;
}

.guide-button {
  background-color: #4a6cf7;
  color: white;
  border: none;
  padding: 8px 15px;
  border-radius: 5px;
  font-size: 0.9rem;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  width: fit-content;
}

.guide-button i {
  margin-right: 5px;
  transition: transform 0.3s ease;
}

.guide-button:hover {
  background-color: #3a5bd9;
  transform: translateX(3px);
}

.guide-button:hover i {
  transform: translateX(3px);
}

/* Avatar Letter Styling */
.avatar-letter {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #4a6cf7;
  color: white;
  font-size: 1.2rem;
  font-weight: bold;
  border-radius: 50%;
}

/* Sidebar Styles */
.sidebar {
  width: 260px;
  background: linear-gradient(135deg, #002446 0%, #003a6c 100%);
  color: white;
  display: flex;
  flex-direction: column;
  transition: all 0.4s cubic-bezier(0.25, 0.8, 0.25, 1);
  position: relative;
  overflow: hidden;
  z-index: 20;
  box-shadow: 5px 0 15px rgba(0, 0, 0, 0.1), inset 0 0 0 1px rgba(255, 255, 255, 0.05);
  border-right: 1px solid rgba(255, 255, 255, 0.05);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
}

/* Sidebar User Section Styles */
.sidebar-user-section {
  margin-top: auto;
  padding: 15px;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  background-color: rgba(0, 0, 0, 0.2);
}

.sidebar-user-container {
  display: flex;
  align-items: center;
  padding: 10px;
  cursor: pointer;
  border-radius: 8px;
  transition: background-color 0.3s ease;
}

.sidebar-user-container:hover {
  background-color: rgba(255, 255, 255, 0.1);
}

.sidebar-user-avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  overflow: hidden;
  margin-right: 10px;
  border: 2px solid rgba(255, 255, 255, 0.5);
}

.sidebar-avatar-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.sidebar-user-info {
  flex: 1;
  overflow: hidden;
}

.sidebar-user-name {
  margin: 0;
  font-weight: 600;
  font-size: 0.9rem;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.sidebar-user-email {
  margin: 0;
  font-size: 0.75rem;
  color: rgba(255, 255, 255, 0.7);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.sidebar-user-menu {
  margin-top: 5px;
  background-color: rgba(0, 0, 0, 0.3);
  border-radius: 8px;
  overflow: hidden;
  animation: slideDown 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
  transform-origin: top center;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2), inset 0 0 0 1px rgba(255, 255, 255, 0.05);
}

.sidebar-menu-option {
  padding: 10px 15px;
  display: flex;
  align-items: center;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.sidebar-menu-option:hover {
  background-color: rgba(255, 255, 255, 0.1);
  transform: translateX(5px);
  transition: background-color 0.3s ease, transform 0.2s ease;
}

.sidebar-menu-option i {
  margin-right: 10px;
  width: 20px;
  text-align: center;
}

.sidebar-menu-option.sidebar-logout {
  color: #ff6b6b;
}

.sidebar-menu-option.sidebar-logout:hover {
  background-color: rgba(255, 107, 107, 0.2);
}

.logo-container {
  display: flex;
  align-items: center;
  padding: 20px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  transition: all 0.3s ease;
}

.sidebar.collapsed .logo-container {
  justify-content: center;
  padding: 20px 10px;
}

/* Ensure logo is always visible even when sidebar is collapsed */
.sidebar.collapsed .site-name {
  display: none;
}

.logo {
  width: 40px;
  height: 40px;
  border-radius: 8px;
  object-fit: cover;
}

.site-name {
  margin-left: 10px;
  font-size: 1.5rem;
  font-weight: 600;
  transition: opacity 0.3s ease, visibility 0.3s ease;
  white-space: nowrap;
  background: linear-gradient(45deg, #fff, #cce5ff);
  background-clip: text;
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}

.sidebar-menu {
  padding: 20px 0;
}

.menu-section {
  margin-bottom: 15px;
}

.menu-section-title {
  padding: 12px 20px;
  display: flex;
  align-items: center;
  color: #cce5ff;
  font-weight: 600;
  font-size: 1.1rem;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  margin-bottom: 10px;
  background-color: rgba(0, 0, 0, 0.2);
  border-radius: 4px;
}

.menu-section-items {
  padding-left: 20px;
  display: flex;
  flex-direction: column;
  margin-top: 5px;
}

.menu-item {
  padding: 12px 20px;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
  display: flex;
  align-items: center;
  margin: 6px 0;
  border-radius: 8px;
  position: relative;
  overflow: hidden;
  backdrop-filter: blur(5px);
  -webkit-backdrop-filter: blur(5px);
}

.menu-section-items .menu-item {
  font-size: 0.95rem;
  padding: 10px 15px;
  margin: 4px 0;
  border-left: 2px solid transparent;
}

.menu-item::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 4px;
  height: 100%;
  background: linear-gradient(to bottom, #4facfe 0%, #00f2fe 100%);
  opacity: 0;
  transition: opacity 0.3s ease, width 0.3s ease;
}

.menu-item::after {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.1) 0%, rgba(255, 255, 255, 0.05) 100%);
  opacity: 0;
  transition: opacity 0.3s ease;
  z-index: -1;
}

.menu-item:hover {
  background-color: rgba(255, 255, 255, 0.15);
  transform: translateX(5px);
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2), 0 0 0 1px rgba(255, 255, 255, 0.05);
  letter-spacing: 0.5px;
}

.menu-item:hover::before {
  opacity: 1;
  width: 6px;
}

.menu-item:hover::after {
  opacity: 1;
}

.menu-item:active {
  transform: translateX(3px) scale(0.98);
  transition: all 0.1s ease;
}

/* Active menu item styles */
.menu-item.active {
  background-color: rgba(255, 255, 255, 0.2);
  transform: translateX(5px);
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2), 0 0 0 1px rgba(255, 255, 255, 0.1);
}

.menu-item.active::before {
  opacity: 1;
  width: 6px;
  background: linear-gradient(to bottom, #4facfe 0%, #00f2fe 100%);
}

.menu-item.active::after {
  opacity: 1;
}

.menu-icon, .submenu-icon {
  margin-right: 10px;
  width: 20px;
  text-align: center;
  transition: all 0.3s ease;
}

.sidebar.collapsed .menu-icon {
  margin-right: 0;
  width: 100%;
  font-size: 1.2rem;
}

.dropdown-icon {
  margin-left: auto;
  transition: transform 0.3s ease;
  display: inline-block;
}

.dropdown-icon.rotated {
  transform: rotate(180deg);
}

.submenu {
  margin-top: 5px;
  padding-left: 20px;
  animation: slideDown 0.3s ease-out;
  max-width: 100%;
  overflow: hidden;
  position: relative;
  width: 100%;
}

.submenu-item {
  padding: 10px 15px;
  display: flex;
  align-items: center;
  cursor: pointer;
  transition: background-color 0.3s ease;
  border-radius: 4px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  width: calc(100% - 15px);
  margin-right: 15px;
}

.submenu-item:hover {
  background-color: rgba(255, 255, 255, 0.2);
  transform: translateX(5px);
  transition: background-color 0.3s ease, transform 0.2s ease;
  border-left: 2px solid #cce5ff;
}

/* Active submenu item styles */
.submenu-item.active {
  background-color: rgba(79, 172, 254, 0.15);
  transform: translateX(5px);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15), 0 0 0 1px rgba(255, 255, 255, 0.1);
}

/* Main Content Styles */
.main-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow-x: hidden;
}

/* Top Navbar Styles */
.top-navbar {
  height: 70px;
  background: linear-gradient(to right, rgba(255, 255, 255, 0.95), rgba(248, 249, 250, 0.95));
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 35px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08), 0 1px 3px rgba(0, 0, 0, 0.03);
  z-index: 100;
  position: fixed;
  top: 0;
  width: calc(100% - 260px);
  right: 0;
  transition: width 0.4s cubic-bezier(0.25, 0.8, 0.25, 1), transform 0.3s ease, box-shadow 0.3s ease;
  border-bottom: 1px solid rgba(0, 0, 0, 0.05);
  animation: fadeInDown 0.5s cubic-bezier(0.25, 0.8, 0.25, 1);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
}

.top-navbar:hover {
  box-shadow: 0 6px 25px rgba(0, 0, 0, 0.1), 0 1px 5px rgba(0, 0, 0, 0.05);
}

.top-navbar::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 0;
  width: 100%;
  height: 2px;
  background: linear-gradient(to right, #002446, transparent);
  opacity: 0.2;
  transform: scaleX(0.7);
  transform-origin: left;
  transition: transform 0.5s ease;
}

.top-navbar:hover::after {
  transform: scaleX(1);
}

.navbar-actions {
  display: flex;
  align-items: center;
}

/* Notification Styles */
.notification-container {
  position: relative;
  margin-right: 20px;
}

.notification-icon {
  position: relative;
  cursor: pointer;
  font-size: 1.2rem;
  width: 42px;
  height: 42px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
  background-color: rgba(0, 36, 70, 0.05);
  position: relative;
  overflow: hidden;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05), inset 0 0 0 1px rgba(255, 255, 255, 0.1);
}

.notification-icon:hover {
  background-color: rgba(0, 36, 70, 0.1);
  transform: scale(1.1);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15), inset 0 0 0 1px rgba(255, 255, 255, 0.2);
}

.notification-icon::after {
  content: '';
  position: absolute;
  top: 50%;
  left: 50%;
  width: 100%;
  height: 100%;
  background: rgba(255, 255, 255, 0.2);
  opacity: 0;
  border-radius: 50%;
  transform: translate(-50%, -50%) scale(0);
  transition: transform 0.5s, opacity 0.3s;
}

.notification-icon:active::after {
  transform: translate(-50%, -50%) scale(2.5);
  opacity: 1;
  transition: transform 0.5s, opacity 0s;
}

.notification-badge {
  position: absolute;
  top: -8px;
  right: -8px;
  background: linear-gradient(135deg, #e74c3c, #c0392b);
  color: white;
  font-size: 0.75rem;
  min-width: 20px;
  height: 20px;
  padding: 0 4px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 3px 8px rgba(0, 0, 0, 0.3);
  animation: pulse 2s infinite;
  transform-origin: center;
  border: 1px solid rgba(255, 255, 255, 0.5);
  z-index: 10000; /* Increased z-index to ensure badge is above all other elements */
  font-weight: bold;
}

@keyframes pulse {
  0% { transform: scale(1); box-shadow: 0 0 0 0 rgba(231, 76, 60, 0.4); }
  70% { transform: scale(1.1); box-shadow: 0 0 0 10px rgba(231, 76, 60, 0); }
  100% { transform: scale(1); box-shadow: 0 0 0 0 rgba(231, 76, 60, 0); }
}

.notification-dropdown {
  position: absolute;
  top: 50px;
  right: -15px;
  width: 350px;
  background-color: white;
  border-radius: 12px;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2), 0 0 0 1px rgba(0, 0, 0, 0.05);
  z-index: 9999; /* Significantly increased z-index to ensure it appears above all other elements */
  overflow: hidden;
  transform-origin: top right;
  border: 1px solid rgba(0, 36, 70, 0.08);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
}

.notification-dropdown::before {
  content: '';
  position: absolute;
  top: -8px;
  right: 20px;
  width: 16px;
  height: 16px;
  background-color: white;
  transform: rotate(45deg);
  border-top: 1px solid rgba(0, 36, 70, 0.08);
  border-left: 1px solid rgba(0, 36, 70, 0.08);
  z-index: -1;
}

.notification-header {
  padding: 15px;
  border-bottom: 1px solid #eee;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.notification-header h3 {
  margin: 0;
  font-size: 1rem;
  color: #333;
  font-weight: 600;
}

.notification-actions {
  display: flex;
  gap: 8px;
}

.notification-action-btn {
  background: none;
  border: none;
  cursor: pointer;
  color: #666;
  font-size: 0.9rem;
  width: 30px;
  height: 30px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s ease;
  position: relative;
}

.notification-action-btn:hover {
  background-color: rgba(0, 36, 70, 0.05);
  color: #002446;
}

.action-tooltip {
  position: absolute;
  bottom: -30px;
  left: 50%;
  transform: translateX(-50%);
  background-color: rgba(0, 0, 0, 0.8);
  color: white;
  padding: 5px 10px;
  border-radius: 4px;
  font-size: 0.75rem;
  white-space: nowrap;
  opacity: 0;
  visibility: hidden;
  transition: opacity 0.2s ease, visibility 0.2s ease;
  z-index: 10001;
}

.notification-action-btn:hover .action-tooltip {
  opacity: 1;
  visibility: visible;
}

.notification-list {
  max-height: 350px;
  overflow-y: auto;
  padding: 5px 0;
}

.notification-item {
  padding: 12px 15px;
  border-bottom: 1px solid rgba(0, 0, 0, 0.05);
  transition: all 0.3s ease;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.notification-item:hover {
  background-color: rgba(0, 36, 70, 0.03);
}

.notification-item.unread {
  background-color: rgba(52, 152, 219, 0.05);
}

.notification-content {
  display: flex;
  align-items: center;
  flex: 1;
}

.notification-icon-indicator {
  width: 8px;
  height: 8px;
  background-color: #3498db;
  border-radius: 50%;
  margin-right: 10px;
  box-shadow: 0 0 5px rgba(52, 152, 219, 0.5);
}

.notification-text-container {
  flex: 1;
}

.notification-text {
  margin: 0 0 5px 0;
  font-size: 0.9rem;
  color: #333;
  line-height: 1.4;
}

.notification-time {
  margin: 0;
  font-size: 0.75rem;
  color: #888;
}

.notification-actions-container {
  display: flex;
  gap: 5px;
  opacity: 0;
  transition: opacity 0.2s ease;
}

.notification-item:hover .notification-actions-container {
  opacity: 1;
}

.notification-item-btn {
  background: none;
  border: none;
  cursor: pointer;
  color: #666;
  font-size: 0.8rem;
  width: 24px;
  height: 24px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s ease;
}

.notification-item-btn:hover {
  background-color: rgba(0, 36, 70, 0.1);
  color: #002446;
}

.notification-item-btn.delete:hover {
  background-color: rgba(231, 76, 60, 0.1);
  color: #e74c3c;
}

.empty-notifications {
  padding: 30px 20px;
  text-align: center;
  color: #888;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}

.empty-icon {
  font-size: 2rem;
  color: #ccc;
  margin-bottom: 10px;
}

/* Fade scale transition for notification dropdown */
.fade-scale-enter-active,
.fade-scale-leave-active {
  transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
}

.fade-scale-enter-from,
.fade-scale-leave-to {
  opacity: 0;
  transform: scale(0.95) translateY(-10px);
}

/* User Profile Styles */
.user-profile {
  position: relative;
}

.user-avatar {
  cursor: pointer;
  width: 40px;
  height: 40px;
  border-radius: 50%;
  overflow: hidden;
  transition: transform 0.3s ease;
}

.user-avatar:hover {
  transform: scale(1.1);
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
  transition: transform 0.2s ease, box-shadow 0.3s ease;
}

.avatar-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.user-menu {
  position: absolute;
  top: 45px;
  right: 0;
  width: 220px;
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
  z-index: 100;
  animation: fadeIn 0.3s ease-out;
}

.user-info {
  padding: 15px;
  border-bottom: 1px solid #eee;
}

.user-name {
  margin: 0 0 5px 0;
  font-weight: 600;
  font-size: 1rem;
}

.user-email {
  margin: 0;
  font-size: 0.8rem;
  color: #888;
}

.menu-options {
  padding: 10px 0;
}

.menu-option {
  padding: 10px 15px;
  display: flex;
  align-items: center;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.menu-option:hover {
  background-color: #f5f5f5;
  transform: translateX(5px);
  transition: background-color 0.3s ease, transform 0.2s ease;
}

.menu-option i {
  margin-right: 10px;
  width: 20px;
  text-align: center;
}

.menu-option.logout {
  color: #e74c3c;
}

.menu-option.logout:hover {
  background-color: #fee;
}

/* Dashboard Content Styles */
.dashboard-content {
  padding: 30px;
  flex: 1;
  margin-top: 70px; /* Ajout d'une marge pour éviter que le contenu soit caché derrière l'en-tête fixe */
  transition: margin-left 0.4s cubic-bezier(0.25, 0.8, 0.25, 1);
}

.welcome-message {
  margin-bottom: 40px;
  padding: 30px 35px;
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.95) 0%, rgba(240, 245, 255, 0.95) 100%);
  border-radius: 20px;
  box-shadow: 0 10px 30px rgba(0, 36, 70, 0.1), 0 1px 3px rgba(0, 0, 0, 0.05);
  border-left: 5px solid #002446;
  position: relative;
  overflow: hidden;
  animation: fadeInUp 0.7s cubic-bezier(0.25, 0.8, 0.25, 1);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  transform-style: preserve-3d;
  perspective: 1000px;
  transition: all 0.4s cubic-bezier(0.25, 0.8, 0.25, 1);
  z-index: 0; /* Lowered z-index to ensure notification dropdown appears above */
}

.welcome-message:hover {
  transform: translateY(-5px) rotateX(2deg);
  box-shadow: 0 15px 35px rgba(0, 36, 70, 0.15), 0 3px 10px rgba(0, 0, 0, 0.1);
}

.welcome-message::before {
  content: '';
  position: absolute;
  top: 0;
  right: 0;
  width: 200px;
  height: 200px;
  background: radial-gradient(circle, rgba(0, 36, 70, 0.08) 0%, rgba(255, 255, 255, 0) 70%);
  border-radius: 50%;
  z-index: 0;
  animation: floatAround 15s ease-in-out infinite alternate;
}

@keyframes floatAround {
  0% { transform: translate(0, 0); }
  25% { transform: translate(-20px, 20px); }
  50% { transform: translate(-10px, -10px); }
  75% { transform: translate(20px, -20px); }
  100% { transform: translate(10px, 10px); }
}

.welcome-message::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 0;
  width: 100%;
  height: 3px;
  background: linear-gradient(90deg, #002446, transparent);
  opacity: 0.3;
}

.welcome-message h2 {
  margin: 0 0 15px 0;
  font-size: 2.2rem;
  color: #002446;
  font-weight: 700;
  position: relative;
  z-index: 1;
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
  background: linear-gradient(135deg, #002446, #0066cc);
  background-clip: text;
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  animation: gradientShift 8s ease infinite;
  background-size: 200% 200%;
}

.welcome-message p {
  margin: 0;
  color: #4a5568;
  font-size: 1.15rem;
  position: relative;
  z-index: 1;
  max-width: 80%;
  line-height: 1.6;
  animation: fadeInUp 0.7s cubic-bezier(0.25, 0.8, 0.25, 1) 0.2s both;
}

.dashboard-widgets {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: 25px;
  margin-top: 30px;
  animation: fadeInUp 0.8s ease-out;
  animation-fill-mode: both;
}

.dashboard-widgets > * {
  animation-fill-mode: both;
  animation-duration: 0.6s;
  animation-timing-function: cubic-bezier(0.25, 0.8, 0.25, 1);
}

.dashboard-widgets > *:nth-child(1) {
  animation-name: fadeInUp;
  animation-delay: 0.1s;
}

.dashboard-widgets > *:nth-child(2) {
  animation-name: fadeInUp;
  animation-delay: 0.3s;
}

.dashboard-widgets > *:nth-child(3) {
  animation-name: fadeInUp;
  animation-delay: 0.5s;
}

.widget {
  background-color: white;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
  overflow: hidden;
  transition: all 0.4s cubic-bezier(0.25, 0.8, 0.25, 1);
  position: relative;
  border: 1px solid rgba(0, 0, 0, 0.03);
  transform-style: preserve-3d;
  perspective: 1000px;
}

.widget:hover {
  transform: translateY(-8px) rotateX(2deg);
  box-shadow: 0 15px 30px rgba(0, 0, 0, 0.15), 0 5px 15px rgba(0, 36, 70, 0.1);
  border-color: rgba(0, 36, 70, 0.1);
}

.widget::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 4px;
  background: linear-gradient(90deg, #002446, #0066cc);
  transform: scaleX(0);
  transform-origin: left;
  transition: transform 0.4s ease;
  z-index: 1;
}

.widget::after {
  content: '';
  position: absolute;
  inset: 0;
  border-radius: 12px;
  padding: 1px;
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.4), rgba(0, 36, 70, 0.1));
  -webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
  -webkit-mask-composite: xor;
  mask-composite: exclude;
  opacity: 0;
  transition: opacity 0.4s ease;
}

.widget:hover::before {
  transform: scaleX(1);
}

.widget:hover::after {
  opacity: 1;
}

.widget-header {
  padding: 18px 20px;
  background: linear-gradient(to right, #f8f9fa, #f1f4f9);
  border-bottom: 1px solid #eee;
  display: flex;
  align-items: center;
  justify-content: space-between;
  position: relative;
}

.widget-header::after {
  content: '';
  position: absolute;
  bottom: -1px;
  left: 0;
  width: 100%;
  height: 1px;
  background: linear-gradient(to right, #002446, transparent);
  opacity: 0.5;
}

.widget-header h3 {
  margin: 0;
  font-size: 1.15rem;
  color: #002446;
  font-weight: 600;
  display: flex;
  align-items: center;
}

.widget-header h3::before {
  content: '';
  display: inline-block;
  width: 8px;
  height: 8px;
  background-color: #002446;
  border-radius: 50%;
  margin-right: 10px;
  opacity: 0.7;
}

.widget-content {
  padding: 25px;
  min-height: 120px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #4a5568;
  font-size: 0.95rem;
  position: relative;
  overflow: hidden;
  background: linear-gradient(135deg, white 0%, #fafbfd 100%);
}

.widget-content::before {
  content: '';
  position: absolute;
  top: 0;
  right: 0;
  width: 100px;
  height: 100px;
  background: radial-gradient(circle, rgba(0, 36, 70, 0.03) 0%, rgba(255, 255, 255, 0) 70%);
  border-radius: 50%;
  z-index: 0;
}

/* Animations */
@keyframes fadeIn {
  from { opacity: 0; transform: translateY(-20px); }
  to { opacity: 1; transform: translateY(0); }
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes fadeInDown {
  from {
    opacity: 0;
    transform: translateY(-30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

@keyframes slideIn {
  from { opacity: 0; transform: translateY(-15px); }
  to { opacity: 1; transform: translateY(0); }
}

@keyframes slideDown {
  from { opacity: 0; transform: translateY(-10px) scaleY(0.95); }
  to { opacity: 1; transform: translateY(0) scaleY(1); }
}

@keyframes slideInLeft {
  from { transform: translateX(-60px); opacity: 0; }
  to { transform: translateX(0); opacity: 1; }
}

@keyframes slideInRight {
  from { transform: translateX(60px); opacity: 0; }
  to { transform: translateX(0); opacity: 1; }
}

@keyframes pulse {
  0% { transform: scale(1) translateY(-50%); }
  50% { transform: scale(1.08) translateY(-50%); }
  100% { transform: scale(1) translateY(-50%); }
}

@keyframes bounce {
  0%, 20%, 50%, 80%, 100% { transform: translateY(0); }
  40% { transform: translateY(-12px); }
  60% { transform: translateY(-6px); }
}

@keyframes shimmer {
  0% { background-position: -1000px 0; }
  100% { background-position: 1000px 0; }
}

@keyframes widthPulse {
  0% { width: 0; }
  50% { width: 90px; }
  100% { width: 70px; }
}

@keyframes gradientShift {
  0% { background-position: 0% 50%; }
  50% { background-position: 100% 50%; }
  100% { background-position: 0% 50%; }
}

@keyframes floatUp {
  0% { transform: translateY(0); }
  50% { transform: translateY(-10px); }
  100% { transform: translateY(0); }
}

@keyframes ripple {
  0% { transform: scale(0); opacity: 1; }
  100% { transform: scale(2.5); opacity: 0; }
}

.sidebar-toggle-button {
  position: absolute;
  top: 50%;
  right: -16px;
  width: 32px;
  height: 32px;
  transform: translateY(-50%);
  background: linear-gradient(135deg, #003a6c 0%, #002446 100%);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  color: white;
  box-shadow: 0 3px 8px rgba(0, 0, 0, 0.3), 0 0 0 1px rgba(255, 255, 255, 0.1);
  z-index: 1000;
  transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
  overflow: visible;
}

.sidebar-toggle-button::after {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: radial-gradient(circle, rgba(255,255,255,0.2) 0%, rgba(255,255,255,0) 70%);
  opacity: 0;
  transition: opacity 0.3s ease;
}

.sidebar-toggle-button:hover::after {
  opacity: 1;
}

.toggle-tooltip {
  position: absolute;
  right: 40px;
  background-color: rgba(0, 0, 0, 0.8);
  color: white;
  padding: 5px 10px;
  border-radius: 4px;
  font-size: 0.75rem;
  white-space: nowrap;
  opacity: 0;
  visibility: hidden;
  transition: opacity 0.2s ease, visibility 0.2s ease;
  pointer-events: none;
}

.sidebar-toggle-button:hover .toggle-tooltip {
  opacity: 1;
  visibility: visible;
}

.sidebar-toggle-button::after {
  content: '';
  position: absolute;
  top: 50%;
  left: 50%;
  width: 100%;
  height: 100%;
  background: rgba(255, 255, 255, 0.2);
  opacity: 0;
  border-radius: 50%;
  transform: translate(-50%, -50%) scale(0);
  transition: transform 0.5s, opacity 0.3s;
}

.sidebar-toggle-button:hover {
  transform: scale(1.1);
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3), inset 0 0 0 1px rgba(255, 255, 255, 0.2);
}

.sidebar-toggle-button:active::after {
  transform: translate(-50%, -50%) scale(2.5);
  opacity: 1;
  transition: transform 0.5s, opacity 0s;
}

.sidebar.collapsed .sidebar-toggle-button {
  right: -16px;
}

.sidebar:not(.collapsed) .sidebar-toggle-button {
  right: -16px;
}

.sidebar-toggle-button i {
  font-size: 14px;
  transition: transform 0.3s ease;
}

.sidebar-toggle-button:hover i {
  transform: scale(1.2);
}

/* Sidebar Hover Effect */
.sidebar.collapsed {
  width: 80px;
  transition: width 0.4s cubic-bezier(0.25, 0.8, 0.25, 1);
  box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
  transform: none !important; /* Prevent any unwanted transformation with !important */
}

/* Ajustement de la largeur de l'en-tête lorsque la barre latérale est réduite */
.sidebar.collapsed ~ .main-content .top-navbar {
  width: calc(100% - 80px);
  transition: width 0.4s cubic-bezier(0.25, 0.8, 0.25, 1);
}

.sidebar.collapsed .menu-title,
.sidebar.collapsed .submenu-title,
.sidebar.collapsed .dropdown-icon {
  opacity: 0;
  visibility: hidden;
  transition: opacity 0.2s ease, visibility 0.2s ease;
}

.sidebar:not(.collapsed) .site-name,
.sidebar:not(.collapsed) .menu-title,
.sidebar:not(.collapsed) .submenu-title {
  opacity: 1;
  visibility: visible;
  transition: opacity 0.3s ease 0.1s, visibility 0.3s ease 0.1s;
}

/* Profile Content Styles */
.profile-content {
  background-color: white;
  border-radius: 15px;
  box-shadow: 0 8px 30px rgba(0, 36, 70, 0.15);
  padding: 2.5rem;
  margin-bottom: 2rem;
  position: relative;
  overflow: hidden;
  animation: fadeIn 0.5s ease-out;
  border-top: 4px solid #002446;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.profile-content-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30px;
  border-bottom: 2px solid #002446;
  padding-bottom: 15px;
  position: relative;
  background: linear-gradient(to right, rgba(0, 36, 70, 0.05), transparent);
  padding: 15px 20px;
  border-radius: 10px 10px 0 0;
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
  animation: widthPulse 2s ease-in-out 1;
}

@keyframes widthPulse {
  0% { width: 0; }
  50% { width: 80px; }
  100% { width: 60px; }
}

.profile-content-header h2 {
  margin: 0;
  color: #2c3e50;
  font-size: 1.8rem;
}

.profile-close-btn {
  background: none;
  border: none;
  font-size: 1.25rem;
  color: #6c757d;
  cursor: pointer;
  transition: all 0.3s ease;
  width: 36px;
  height: 36px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.profile-close-btn:hover {
  color: #dc3545;
  background-color: rgba(220, 53, 69, 0.1);
  transform: rotate(90deg);
}

.profile-form-container {
  max-width: 600px;
  margin: 0 auto;
  animation: fadeInUp 0.6s ease-out;
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

@keyframes titleSlideIn {
  0% { transform: translateX(-20px); opacity: 0; }
  100% { transform: translateX(0); opacity: 1; }
}

.profile-content-header h2 {
  animation: titleSlideIn 0.5s ease-out forwards;
}

.profile-photo-section {
  display: flex;
  justify-content: center;
  margin-bottom: 40px;
  position: relative;
}

.profile-photo-container {
  position: relative;
  width: 140px;
  height: 140px;
  border-radius: 50%;
  overflow: hidden;
  box-shadow: 0 6px 15px rgba(0, 36, 70, 0.25);
  border: 4px solid #fff;
  transition: transform 0.3s ease, box-shadow 0.3s ease, border-color 0.3s ease;
  background-color: #f5f5f5;
  z-index: 1;
}

.profile-photo-container:hover {
  transform: scale(1.05);
  box-shadow: 0 10px 30px rgba(0, 36, 70, 0.35);
  border-color: #3498db;
}

.profile-photo-container::after {
  content: '';
  position: absolute;
  top: -5px;
  left: -5px;
  right: -5px;
  bottom: -5px;
  border-radius: 50%;
  background: linear-gradient(45deg, #002446, #3498db);
  z-index: -1;
  opacity: 0;
  transition: opacity 0.3s ease;
}

.profile-photo-container:hover::after {
  opacity: 0.7;
}

.profile-photo {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.5s ease;
}

.profile-photo-container:hover .profile-photo {
  transform: scale(1.08);
}

.photo-upload-overlay {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  background-color: rgba(0, 36, 70, 0.7);
  color: white;
  padding: 10px 0;
  text-align: center;
  cursor: pointer;
  transition: all 0.3s ease;
  transform: translateY(100%);
  opacity: 0;
}

.profile-photo-container:hover .photo-upload-overlay {
  transform: translateY(0);
  opacity: 1;
}

.photo-upload-overlay:hover {
  background-color: rgba(0, 0, 0, 0.8);
}

.form-group {
  margin-bottom: 1.5rem;
}

label {
  display: block;
  margin-bottom: 0.5rem;
  font-weight: 600;
  color: #0f2027;
  transition: color 0.3s ease;
}

.form-control {
  display: block;
  width: 100%;
  padding: 0.85rem 1rem;
  font-size: 1rem;
  line-height: 1.5;
  color: #495057;
  background-color: #fff;
  background-clip: padding-box;
  border: 1px solid #ced4da;
  border-radius: 10px;
  transition: all 0.3s ease;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
  position: relative;
  z-index: 1;
}

.form-control:focus {
  color: #002446;
  background-color: #fff;
  border-color: #3498db;
  outline: 0;
  box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.25);
  transform: translateY(-2px);
}

.form-control:hover {
  border-color: #3498db;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.form-control.is-invalid {
  border-color: #dc3545;
  box-shadow: 0 0 0 3px rgba(220, 53, 69, 0.1);
}

.error-message {
  color: #e74c3c;
  font-size: 0.85rem;
  margin-top: 5px;
}

.password-section {
  margin-top: 30px;
  margin-bottom: 30px;
  padding-top: 20px;
  border-top: 1px solid #eee;
}

.password-section h3 {
  margin-bottom: 20px;
  color: #2c3e50;
  font-size: 1.3rem;
}

.password-input-container {
  position: relative;
}

.password-toggle {
  position: absolute;
  right: 15px;
  top: 50%;
  transform: translateY(-50%);
  cursor: pointer;
  color: #7f8c8d;
  transition: color 0.3s ease;
}

.password-toggle:hover {
  color: #3498db;
}

.form-actions {
  display: flex;
  justify-content: flex-end;
  gap: 15px;
  margin-top: 30px;
}

.btn {
  padding: 12px 28px;
  border-radius: 10px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  border: none;
  font-size: 1rem;
  position: relative;
  overflow: hidden;
  letter-spacing: 0.5px;
  z-index: 1;
}

.btn::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 0%;
  height: 100%;
  background-color: rgba(255, 255, 255, 0.1);
  transition: width 0.3s ease;
  z-index: -1;
}

.btn:hover::before {
  width: 100%;
}

.btn-primary {
  background: linear-gradient(135deg, #3498db, #002446);
  color: white;
  box-shadow: 0 4px 10px rgba(0, 36, 70, 0.2);
}

.btn-primary:hover {
  background: linear-gradient(135deg, #2980b9, #001c37);
  transform: translateY(-3px);
  box-shadow: 0 6px 15px rgba(0, 36, 70, 0.3);
}

.btn-secondary {
  background-color: #f5f7fa;
  color: #002446;
  border: 1px solid rgba(0, 36, 70, 0.1);
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
}

.btn-secondary:hover {
  background-color: #ecf0f1;
  transform: translateY(-3px);
  box-shadow: 0 6px 12px rgba(0, 0, 0, 0.1);
  color: #3498db;
}

.btn:disabled {
  opacity: 0.7;
  cursor: not-allowed;
  transform: none !important;
  box-shadow: none !important;
}

.spinner {
  display: inline-block;
  width: 20px;
  height: 20px;
  border: 3px solid rgba(255, 255, 255, 0.3);
  border-radius: 50%;
  border-top-color: white;
  animation: spin 1s ease-in-out infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.notification {
  margin-top: 20px;
  padding: 15px;
  border-radius: 8px;
  animation: fadeIn 0.3s ease-out;
}

.notification.success {
  background-color: #d4edda;
  color: #155724;
  border: 1px solid #c3e6cb;
}

.notification.error {
  background-color: #f8d7da;
  color: #721c24;
  border: 1px solid #f5c6cb;
}

/* Responsive Styles */
@media (max-width: 768px) {
  .dashboard-container {
    flex-direction: column;
  }
  
  .sidebar {
    width: 100% !important;
    height: auto;
  }
  
  .dashboard-widgets {
    grid-template-columns: 1fr;
  }
  
  .sidebar.collapsed .site-name,
  .sidebar.collapsed .menu-title,
  .sidebar.collapsed .submenu-title {
    opacity: 1;
    visibility: visible;
  }
  
  .form-actions {
    flex-direction: column;
  }
  
  .profile-content {
    padding: 20px;
  }
}
</style>