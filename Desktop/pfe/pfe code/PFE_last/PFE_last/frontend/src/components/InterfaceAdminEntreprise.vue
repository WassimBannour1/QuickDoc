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
        
        <div class="logo-container" @click="navigateTo('accueil')" style="cursor: pointer;">
          <img src="@/assets/logo.jpg" alt="QuikDoc Logo" class="logo">
          <h1 class="site-name">QuikDoc</h1>
        </div>
        
        <div class="sidebar-menu">
          <!-- Dashboard Home -->
          <div 
            class="menu-item" 
            @click="navigateTo('accueil')" 
            :class="{ 'active': isActive('accueil') }"
            style="--i: 0"
          >
            <span class="menu-icon"><i class="fas fa-home"></i></span>
            <span class="menu-title">Accueil</span>
          </div>
  
          <!-- Template Management -->
          <div 
            class="menu-item" 
            @click="toggleTemplateMenu" 
            :class="{ 'active': isTemplateActive }"
            style="--i: 1"
          >
            <span class="menu-icon"><i class="fas fa-file-alt"></i></span>
            <span class="menu-title">Gestion Templates</span>
            <span class="dropdown-icon" :class="{ 'rotated': showTemplateMenu }">
              <i class="fas fa-chevron-down"></i>
            </span>
          </div>
          
          <div class="submenu" v-show="showTemplateMenu">
            <div class="submenu-item" @click="navigateTo('create-template')" style="--i: 0">
              <span class="submenu-icon"><i class="fas fa-plus-circle"></i></span>
              <span class="submenu-title">Créer Template</span>
            </div>
            <div class="submenu-item" @click="navigateTo('predefined-templates')" style="--i: 1">
              <span class="submenu-icon"><i class="fas fa-clipboard-list"></i></span>
              <span class="submenu-title">Templates Prédéfinis</span>
            </div>
            <div class="submenu-item" @click="navigateTo('custom-templates')" style="--i: 2">
              <span class="submenu-icon"><i class="fas fa-palette"></i></span>
              <span class="submenu-title">Templates Personnalisés</span>
            </div>
          </div>
  
          <!-- Client Management -->
          <div class="menu-item" @click="toggleClientMenu" :class="{ 'active': isClientActive }" style="--i: 2">
            <span class="menu-icon"><i class="fas fa-users"></i></span>
            <span class="menu-title">Gestion Clients</span>
            <span class="dropdown-icon" :class="{ 'rotated': showClientMenu }">
              <i class="fas fa-chevron-down"></i>
            </span>
          </div>
  
          <div class="submenu" v-show="showClientMenu">
            <div class="submenu-item" @click="navigateTo('create-client')" style="--i: 0">
              <span class="submenu-icon"><i class="fas fa-user-plus"></i></span>
              <span class="submenu-title">Nouveau Client</span>
            </div>
            <div class="submenu-item" @click="navigateTo('client-list')" style="--i: 1">
              <span class="submenu-icon"><i class="fas fa-list-ul"></i></span>
              <span class="submenu-title">Liste Clients</span>
            </div>
            <!-- Removed direct navigation to edit-client as it requires an ID parameter -->
            <!-- This functionality is handled through the client list view -->


          </div>
  
          <!-- Product Management -->
          <div class="menu-item" @click="toggleProductMenu" :class="{ 'active': isProductActive }" style="--i: 3">
            <span class="menu-icon"><i class="fas fa-boxes"></i></span>
            <span class="menu-title">Gestion Produits</span>
            <span class="dropdown-icon" :class="{ 'rotated': showProductMenu }">
              <i class="fas fa-chevron-down"></i>
            </span>
          </div>
  
          <!-- Product Management Submenu -->
          <div class="submenu" v-show="showProductMenu">
            <div class="submenu-item" @click="navigateTo('categories')" style="--i: 0">
              <span class="submenu-icon"><i class="fas fa-tags"></i></span>
              <span class="submenu-title">Catégories</span>
            </div>
            <div class="submenu-item" @click="navigateTo('product-create')" style="--i: 1">
              <span class="submenu-icon"><i class="fas fa-plus"></i></span>
              <span class="submenu-title">Nouveau Produit</span>
            </div>
            <div class="submenu-item" @click="navigateTo('product-list')" style="--i: 2">
              <span class="submenu-icon"><i class="fas fa-list"></i></span>
              <span class="submenu-title">Liste Produits</span>
            </div>
            <div class="submenu-item" @click="navigateTo('stock')" style="--i: 3">
              <span class="submenu-icon"><i class="fas fa-warehouse"></i></span>
              <span class="submenu-title">Gestion Stock</span>
            </div>
          </div>
  
          <!-- OCR & IA Menu a été supprimé -->

          <!-- Document Creation Menu -->
          <div class="menu-item" @click="navigateTo('document-creation')" :class="{ 'active': currentView === 'document-creation' }" style="--i: 5">
            <span class="menu-icon"><i class="fas fa-file-contract"></i></span>
            <span class="menu-title">Création Document</span>
          </div>
          
          <!-- Document Management Module (Simplified) -->
          <div class="menu-item" @click="toggleDocManagementMenu" :class="{ 'active': isDocManagementActive }" style="--i: 6">
            <span class="menu-icon"><i class="fas fa-folder"></i></span>
            <span class="menu-title">Gestion des Documents</span>
            <span class="dropdown-icon" :class="{ 'rotated': showDocManagementMenu }">
              <i class="fas fa-chevron-down"></i>
            </span>
          </div>

          <div class="submenu" v-show="showDocManagementMenu">
            <div class="submenu-item" @click="navigateTo('factures-management')" style="--i: 0">
              <span class="submenu-icon"><i class="fas fa-file-invoice-dollar"></i></span>
              <span class="submenu-title">Factures</span>
            </div>
            <div class="submenu-item" @click="navigateTo('devis-management')" style="--i: 1">
              <span class="submenu-icon"><i class="fas fa-file-contract"></i></span>
              <span class="submenu-title">Devis</span>
            </div>
          </div>
        </div> <!-- Close sidebar-menu -->
        
        <!-- User Profile Section -->
        <div class="sidebar-user-section" @mouseleave="showUserMenu = false">
          <div class="sidebar-user-container" @click="toggleUserMenu">
            <div class="sidebar-user-avatar">
              <div class="avatar-letter" style="animation: profilePhotoAppear 0.8s cubic-bezier(0.215, 0.61, 0.355, 1) forwards;">
                {{ userName.charAt(0).toUpperCase() }}
              </div>
            </div>
            <div class="sidebar-user-info">
              <p class="sidebar-user-name">{{ userName }}</p>
              <p class="sidebar-user-role">Admin Entreprise</p>
            </div>
            <span class="dropdown-icon" :class="{ 'rotated': showUserMenu }">
              <i class="fas fa-chevron-down"></i>
            </span>
          </div>
          
          <!-- User Menu Options -->
          <div class="sidebar-user-menu" v-show="showUserMenu">
            <div class="sidebar-menu-option" @click="showProfileContent = true; showUserMenu = false">
              <i class="fas fa-user"></i>
              <span>Mon Profil</span>
            </div>
            <div class="sidebar-menu-option sidebar-logout" @click="handleLogout">
              <i class="fas fa-sign-out-alt"></i>
              <span>Déconnexion</span>
            </div>
          </div>
        </div>
      </div> <!-- Close sidebar -->
  
      <!-- Main Content -->
      <div class="main-content">
        <!-- Dashboard Content -->
        <div class="dashboard-content">
          <!-- Profile Content (shown when user clicks on Mon Profil) -->
          <ProfileComponent v-if="showProfileContent" @close="showProfileContent = false" />
          
          <!-- Document Creation Flow Component -->
          <DocumentCreationFlow 
            v-if="currentView === 'document-creation'"
          />
          
          <!-- Document Management Component (Unified) -->
          <DocumentManagement 
            v-else-if="currentView === 'factures-management' || currentView === 'devis-management'" 
            :initial-tab="currentView === 'factures-management' ? 'factures' : 'devis'"
          />
          
          <!-- Client Management Component (Unified) -->
          <ClientManagement 
            v-else-if="currentView === 'create-client' || currentView === 'client-list'" 
            :initial-view="currentView === 'create-client' ? 'create' : 'list'"
          />
          
          <!-- Product Management Components -->
          <div v-else-if="currentView === 'categories' || currentView === 'product-list' || currentView === 'product-create' || currentView === 'stock' || $route.path.includes('product-')" class="full-page-content">
            <router-view :key="$route.fullPath" />
          </div>
          
          <!-- OCR & IA Component -->
          <OcrIaComponent v-else-if="currentView === 'ocr-ia'" />
          
          <!-- Template Management Components -->
          <div v-else-if="$route.name === 'create-template' || $route.path.includes('create-template')" class="full-page-content">
            <router-view :key="$route.fullPath" />
          </div>
          
          <div v-else-if="$route.name === 'edit-template' || $route.path.includes('edit-template')" class="full-page-content">
            <router-view :key="$route.fullPath" />
          </div>
          
          <div v-else-if="$route.name === 'predefined-templates' || $route.path.includes('predefined-templates')" class="full-page-content">
            <router-view :key="$route.fullPath" />
          </div>
          
          <div v-else-if="$route.name === 'custom-templates' || $route.path.includes('custom-templates')" class="full-page-content">
            <router-view :key="$route.fullPath" />
          </div>
          
          <!-- Client Edition Component (Full Page) -->
          <div v-else-if="$route.name === 'edit-client'" class="full-page-content">
            <router-view :key="$route.fullPath" />
          </div>
          
          <!-- Regular Dashboard Content (shown when profile is not displayed and no specific view is selected) -->
          <div v-else class="dashboard-scrollable-content">
            <div class="welcome-section">
              <div class="welcome-card">
                <h2>Bienvenue, {{ userName }} !</h2>
                <p class="welcome-subtitle">Gérez vos documents et paiements en toute simplicité.</p>
              </div>
            </div>
            
            <div class="dashboard-stats">
              <WidgetTransition name="widget" appear :style="{ '--delay': 0 }">
                <div class="stat-card">
                  <i class="fas fa-file-invoice-dollar stat-icon"></i>
                  <div class="stat-info">
                    <h3>Factures</h3>
                    <p class="stat-number">{{ stats.factures || 0 }}</p>
                  </div>
                </div>
              </WidgetTransition>
              
              <WidgetTransition name="widget" appear :style="{ '--delay': 1 }">
                <div class="stat-card">
                  <i class="fas fa-file-contract stat-icon"></i>
                  <div class="stat-info">
                    <h3>Devis</h3>
                    <p class="stat-number">{{ stats.devis || 0 }}</p>
                  </div>
                </div>
              </WidgetTransition>
              
              <WidgetTransition name="widget" appear :style="{ '--delay': 2 }">
                <div class="stat-card">
                  <i class="fas fa-users stat-icon"></i>
                  <div class="stat-info">
                    <h3>Clients</h3>
                    <p class="stat-number">{{ stats.clients || 0 }}</p>
                  </div>
                </div>
              </WidgetTransition>

              <WidgetTransition name="widget" appear :style="{ '--delay': 3 }">
                <div class="stat-card">
                  <i class="fas fa-money-bill-wave stat-icon"></i>
                  <div class="stat-info">
                    <h3>Montant Total</h3>
                    <p class="stat-number">{{ formatCurrency(stats.montantTotal) }}</p>
                  </div>
                </div>
              </WidgetTransition>
              
              <WidgetTransition name="widget" appear :style="{ '--delay': 4 }">
                <div class="stat-card">
                  <i class="fas fa-boxes stat-icon"></i>
                  <div class="stat-info">
                    <h3>Produits</h3>
                    <p class="stat-number">{{ stats.products || 0 }}</p>
                  </div>
                </div>
              </WidgetTransition>
            </div>
            
            <!-- Revenue Chart Section -->
            <div class="chart-container">
              <!-- Revenue Chart Section -->
              <div class="chart-section">
                <div class="chart-header">
                  <h3 class="chart-title">Évolution des revenus</h3>
                  <div class="chart-controls">
                    <select v-model="timeRange" @change="fetchIncomeChartData" class="time-range-select">
                      <option value="week">7 derniers jours</option>
                      <option value="month">30 derniers jours</option>
                      <option value="quarter">3 derniers mois</option>
                      <option value="year">Année</option>
                    </select>
                  </div>
                </div>
                <!-- Added fixed dimensions and debug border to ensure chart visibility -->
                <div style="height: 300px; min-height: 300px; border: 1px solid #4bc0c0; position: relative; margin: 20px 0;">
                  <canvas id="revenueChart" ref="revenueChartRef"></canvas>
                </div>
              </div>
              
              <!-- Document Distribution Chart Section -->
              <div class="chart-section">
                <div class="chart-header">
                  <h3 class="chart-title">Distribution des documents</h3>
                </div>
                <div class="chart-row">
                  <div class="half-chart">
                    <canvas id="documentDistributionChart" ref="docDistributionChartRef"></canvas>
                  </div>
                  <div class="chart-stats">
                    <div class="stat-item" v-for="(item, index) in docDistribution.stats" :key="index">
                      <div class="stat-label" :style="{ color: docDistribution.colors[index] }">
                        <span class="stat-dot" :style="{ backgroundColor: docDistribution.colors[index] }"></span>
                        {{ item.label }}
                      </div>
                      <div class="stat-values">
                        <div class="stat-value">{{ item.count }} documents</div>
                        <div class="stat-value">{{ formatCurrency(item.amount) }}</div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            
            <!-- Product Statistics Section -->
            <div class="chart-container">
              <div class="chart-section">
                <div class="chart-header">
                  <h3 class="chart-title">Statistiques des produits</h3>
                </div>
                <div class="product-stats-container">
                  <div class="product-stats-summary">
                    <div class="product-stat-item">
                      <div class="product-stat-icon">
                        <i class="fas fa-boxes"></i>
                      </div>
                      <div class="product-stat-details">
                        <h4>Valeur totale de l'inventaire</h4>
                        <p class="product-stat-value">{{ formatCurrency(productStats.totalValue) }}</p>
                      </div>
                    </div>
                    <div class="product-stat-item">
                      <div class="product-stat-icon">
                        <i class="fas fa-tags"></i>
                      </div>
                      <div class="product-stat-details">
                        <h4>Nombre de produits</h4>
                        <p class="product-stat-value">{{ productStats.totalProducts || 0 }}</p>
                      </div>
                    </div>
                  </div>
                  
                  <!-- Low Stock Products -->
                  <div class="low-stock-products">
                    <h4 class="low-stock-title">Produits à faible stock</h4>
                    <div class="low-stock-list">
                      <div class="low-stock-item" v-for="product in productStats.lowStockProducts" :key="product.id">
                        <div class="low-stock-name">{{ product.name }}</div>
                        <div class="low-stock-quantity" :class="{ 'critical': product.stock_quantity <= 2 }">
                          {{ product.stock_quantity }} en stock
                        </div>
                        <div class="low-stock-price">{{ formatCurrency(product.unit_price) }}</div>
                      </div>
                      <div class="empty-list-message" v-if="!productStats.lowStockProducts || productStats.lowStockProducts.length === 0">
                        <i class="fas fa-info-circle"></i>
                        <span>Aucun produit à faible stock</span>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            
            <!-- Recent Transactions Section -->
            <div class="transactions-section">
              <h3 class="section-title">Transactions récentes</h3>
              <div class="transactions-list">
                <div class="transaction-item" v-for="doc in recentDocs" :key="doc.id">
                  <div class="transaction-icon" :class="doc.type_document === 'facture' ? 'invoice-icon' : 'quote-icon'">
                    <i :class="doc.type_document === 'facture' ? 'fas fa-file-invoice-dollar' : 'fas fa-file-contract'"></i>
                  </div>
                  <div class="transaction-details">
                    <div class="transaction-title">
                      {{ doc.type_document === 'facture' ? 'Facture' : 'Devis' }} #{{ doc.serie_number }}
                    </div>
                    <div class="transaction-subtitle">{{ doc.name }} {{ doc.last_name }}</div>
                  </div>
                  <div class="transaction-amount">
                    {{ formatCurrency(doc.montant_ttc) }}
                  </div>
                  <div class="transaction-date">
                    {{ formatDate(doc.created_at) }}
                  </div>
                </div>
                <div class="empty-list-message" v-if="!recentDocs || recentDocs.length === 0">
                  <i class="fas fa-info-circle"></i>
                  <span>Aucune transaction récente</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
  </div>
</template>
  <script setup>
import { ref, computed, onMounted, reactive, nextTick } from 'vue';
import { useRouter } from 'vue-router';
import { useMainStore } from '@/stores';
import DocumentCreationFlow from './document-creation/DocumentCreationFlow.vue';
import axios from 'axios';
import Chart from 'chart.js/auto';
import { TransitionGroup } from 'vue';
import ProfileComponent from './ProfileComponent.vue';

// Import du composant unifié de gestion de documents
import DocumentManagement from './document/DocumentManagement.vue';

// Import du composant unifié de gestion des clients
import ClientManagement from './client/ClientManagement.vue';

// Import des composants indépendants de gestion des produits
import CategoryManagementPage from './product/CategoryManagementPage.vue';
import ProductListPage from './product/ProductListPage.vue';
import ProductCreatePage from './product/ProductCreatePage.vue';
import StockManagementPage from './product/StockManagementPage.vue';

// Import du nouveau composant OCR & IA
import OcrIaComponent from './ocr/OcrIaComponent.vue';

// Composants de transition personnalisés
const FadeTransition = TransitionGroup;
const WidgetTransition = TransitionGroup;
const ListTransition = TransitionGroup;

// FontAwesome Icons - Assurez-vous que FontAwesome est chargé
const fontAwesomeLink = document.createElement('link');
fontAwesomeLink.rel = 'stylesheet';
fontAwesomeLink.href = 'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css';
document.head.appendChild(fontAwesomeLink);

const router = useRouter();
const store = useMainStore();

// Sidebar state
const sidebarExpanded = ref(true);

// Menu state
const currentView = ref('accueil');
const showTemplateMenu = ref(false);
const showClientMenu = ref(false);
const showProductMenu = ref(false);
const showOcrMenu = ref(false);
const showDocumentMenu = ref(false);
const showDocManagementMenu = ref(false);
const showUserMenu = ref(false);
const showProfileContent = ref(false);

// Sidebar functions
const expandSidebar = () => {
  sidebarExpanded.value = true;
};

const collapseSidebar = () => {
  sidebarExpanded.value = false;
};

// Active menu check
const isActive = (view) => {
  return currentView.value === view;
};

// Check if client management is active
const isClientActive = computed(() => {
  return ['create-client', 'client-list'].includes(currentView.value);
});

// Check if template management is active
const isTemplateActive = computed(() => {
  return ['create-template', 'predefined-templates', 'custom-templates'].includes(currentView.value);
});

// Check if product management is active
const isProductActive = computed(() => {
  return ['categories', 'product-list', 'stock', 'scraping'].includes(currentView.value);
});

// Check if document personalization is active
const isDocumentActive = computed(() => {
  return ['select-template', 'auto-fill', 'manual-fill', 'preview-validate', 'save-integrate'].includes(currentView.value);
});

// Reactive stats data
const stats = reactive({
  factures: 0,
  devis: 0,
  clients: 0,
  products: 0,
  montantTotal: 0,
  totals: {
    ht: 0,
    tva: 0,
    ttc: 0,
    remise: 0
  }
});

// Product statistics data
const productStats = reactive({
  totalProducts: 0,
  totalValue: 0,
  lowStockProducts: [],
  subcategories: {
    labels: [],
    counts: [],
    values: []
  }
});

// Recent documents and clients
const recentDocs = ref([]);
const recentClients = ref([]);

// Chart data
const chartData = reactive({
  labels: [],
  values: [],
  stats: {
    total: 0,
    average: 0,
    count: 0
  }
});

// Document distribution data
const docDistribution = reactive({
  labels: ['Factures', 'Devis'],
  counts: [0, 0],
  amounts: [0, 0],
  colors: ['#4bc0c0', '#ff9f40'],
  stats: [
    { label: 'Factures', count: 0, amount: 0 },
    { label: 'Devis', count: 0, amount: 0 }
  ]
});

// Time range for chart
const timeRange = ref('year');

// Computed properties
const userName = computed(() => {
  const user = store.user;
  return user ? `${user.first_name} ${user.last_name}` : 'Utilisateur';
});

// Menu toggle functions
const toggleTemplateMenu = () => {
  showTemplateMenu.value = !showTemplateMenu.value;
  showClientMenu.value = false;
  showProductMenu.value = false;
  showOcrMenu.value = false;
  showDocumentMenu.value = false;
  showDocManagementMenu.value = false;
};

const toggleClientMenu = () => {
  showClientMenu.value = !showClientMenu.value;
  showTemplateMenu.value = false;
  showProductMenu.value = false;
  showOcrMenu.value = false;
  showDocumentMenu.value = false;
  showDocManagementMenu.value = false;
};

const toggleProductMenu = () => {
  showProductMenu.value = !showProductMenu.value;
  showTemplateMenu.value = false;
  showClientMenu.value = false;
  showOcrMenu.value = false;
  showDocumentMenu.value = false;
  showDocManagementMenu.value = false;
};

// Fonction toggleOcrMenu n'est plus nécessaire car nous ouvrons directement le composant OcrIaComponent

// Function to fetch dashboard statistics
const fetchDashboardStats = async () => {
  try {
    const token = localStorage.getItem('token');
    console.log('Token found:', !!token);
    if (!token) {
      console.error('No authentication token found');
      return;
    }
    
    console.log('Fetching dashboard stats from:', 'http://localhost:5000/api/statistics/dashboard');
    const response = await axios.get('http://localhost:5000/api/statistics/dashboard', {
      headers: {
        Authorization: `Bearer ${token}`
      }
    });
    
    console.log('Dashboard stats response:', response.data);
    
    if (response.data.success) {
      Object.assign(stats, response.data.data);
      console.log('Updated stats:', stats);
      
      // Update recent documents and clients
      if (response.data.data.recentDocs) {
        recentDocs.value = response.data.data.recentDocs;
        console.log('Recent docs:', recentDocs.value);
      }
      
      if (response.data.data.recentClients) {
        recentClients.value = response.data.data.recentClients;
        console.log('Recent clients:', recentClients.value);
      }
    } else {
      console.error('API returned success: false');
    }
  } catch (error) {
    console.error('Error fetching dashboard statistics:', error);
    if (error.response) {
      console.error('Error response:', error.response.data);
      console.error('Status:', error.response.status);
    } else if (error.request) {
      console.error('No response received:', error.request);
    } else {
      console.error('Error setting up request:', error.message);
    }
  }
};

// Function to fetch income chart data
const fetchIncomeChartData = async () => {
  try {
    const token = localStorage.getItem('token');
    if (!token) {
      console.error('No authentication token found');
      // Use sample data if no authentication
      useSampleData();
      return;
    }
    
    console.log('Fetching income chart data with range:', timeRange.value);
    
    try {
      const response = await axios.get(`http://localhost:5000/api/statistics/income-chart?range=${timeRange.value}`, {
        headers: {
          Authorization: `Bearer ${token}`
        }
      });
      
      console.log('Income chart API response:', response.data);
      
      if (response.data.success) {
        chartData.labels = response.data.data.labels;
        chartData.values = response.data.data.values;
        
        if (response.data.data.stats) {
          chartData.stats = response.data.data.stats;
        }
        
        // If API returned empty data, use sample data
        if (!chartData.labels.length || !chartData.values.length) {
          console.log('API returned empty data, using sample data');
          useSampleData();
        } else {
          console.log('Using API data for chart:', chartData);
          renderRevenueChart();
        }
      } else {
        console.error('API returned success: false');
        initEmptyChartData();
        renderRevenueChart();
      }
    } catch (error) {
      console.error('Error fetching income chart data:', error);
      initEmptyChartData();
      renderRevenueChart();
    }
  } catch (error) {
    console.error('Unexpected error in fetchIncomeChartData:', error);
    initEmptyChartData();
    renderRevenueChart();
  }
};

// Initialize data structures with empty values when needed
const initEmptyChartData = () => {
  // For revenue chart
  if (!chartData.labels || chartData.labels.length === 0) {
    chartData.labels = [];
    chartData.values = [];
    chartData.stats = {
      total: 0,
      average: 0,
      count: 0
    };
  }
  
  // For document distribution
  if (!docDistribution.labels || docDistribution.labels.length === 0) {
    docDistribution.labels = ['Factures', 'Devis'];
    docDistribution.counts = [0, 0];
    docDistribution.amounts = [0, 0];
    docDistribution.stats = [
      { label: 'Factures', count: 0, amount: 0 },
      { label: 'Devis', count: 0, amount: 0 }
    ];
  }
};

// Function to fetch document distribution data
const fetchDocumentDistribution = async () => {
  try {
    const token = localStorage.getItem('token');
    if (!token) return;
    
    const response = await axios.get('http://localhost:5000/api/statistics/document-distribution', {
      headers: {
        Authorization: `Bearer ${token}`
      }
    });
    
    if (response.data.success) {
      docDistribution.labels = response.data.data.labels;
      docDistribution.counts = response.data.data.counts;
      docDistribution.amounts = response.data.data.amounts;
      
      // Update stats for display
      docDistribution.stats = docDistribution.labels.map((label, index) => ({
        label,
        count: docDistribution.counts[index],
        amount: docDistribution.amounts[index]
      }));
      
      renderDocumentDistributionChart();
    }
  } catch (error) {
    console.error('Error fetching document distribution data:', error);
    initEmptyChartData(); // Initialize with empty data on error
    renderDocumentDistributionChart();
  }
};

// Function to format currency
const formatCurrency = (value) => {
  if (value === null || value === undefined) return '0.00 DT';
  return parseFloat(value).toLocaleString('fr-TN', {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2
  }) + ' DT';
};

// Format a date for display
const formatDate = (dateString) => {
  if (!dateString) return '';
  const date = new Date(dateString);
  return date.toLocaleDateString('fr-FR', {
    year: 'numeric',
    month: 'short',
    day: 'numeric'
  });
};

// Reference to the chart canvas element
const revenueChartRef = ref(null);
const docDistributionChartRef = ref(null);
let revenueChartInstance = null;
let docDistributionChartInstance = null;

// Function to render the revenue chart - completely rewritten
const renderRevenueChart = () => {
  console.log('Rendering revenue chart with data:', chartData);
  
  // Ensure we're not creating a chart if there's no data
  if (!chartData.labels.length || !chartData.values.length) {
    console.log('No data for revenue chart yet');
    return;
  }

  // Use nextTick to ensure DOM is fully updated
  nextTick(() => {
    try {
      // Get reference to canvas through Vue ref
      const canvas = document.getElementById('revenueChart');
      if (!canvas) {
        console.error('Revenue chart canvas still not found');
        return;
      }
      
      console.log('Found revenue chart canvas:', canvas);
      
      // Destroy previous chart if it exists
      if (revenueChartInstance) {
        revenueChartInstance.destroy();
        revenueChartInstance = null;
      }
      
      // Create configuration for the chart
      const chartConfig = {
        type: 'line',
        data: {
          labels: chartData.labels,
          datasets: [{
            label: 'Revenus',
            data: chartData.values,
            backgroundColor: 'rgba(75, 192, 192, 0.2)',
            borderColor: 'rgba(75, 192, 192, 1)',
            borderWidth: 2,
            tension: 0.4,
            pointBackgroundColor: 'rgba(75, 192, 192, 1)',
            pointBorderColor: '#fff',
            pointBorderWidth: 2,
            pointRadius: 5,
            pointHoverBackgroundColor: '#fff',
            pointHoverBorderColor: 'rgba(75, 192, 192, 1)',
            pointHoverBorderWidth: 2,
            pointHoverRadius: 7,
            fill: true
          }]
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          scales: {
            y: {
              beginAtZero: true,
              ticks: {
                callback: function(value) {
                  return value.toLocaleString('fr-TN') + ' DT';
                }
              }
            }
          },
          plugins: {
            legend: {
              display: false
            },
            tooltip: {
              callbacks: {
                label: function(context) {
                  let label = context.dataset.label || '';
                  if (label) {
                    label += ': ';
                  }
                  if (context.parsed.y !== null) {
                    label += context.parsed.y.toLocaleString('fr-TN') + ' DT';
                  }
                  return label;
                }
              }
            }
          }
        }
      };
      
      console.log('Creating revenue chart with config:', chartConfig);
      
      // Create the chart using Chart.js
      revenueChartInstance = new Chart(canvas.getContext('2d'), chartConfig);
      console.log('Revenue chart created successfully');
    } catch (error) {
      console.error('Error creating revenue chart:', error);
    }
  });
};

// Function to render the document distribution chart
const renderDocumentDistributionChart = () => {
  console.log('Rendering document distribution chart with data:', docDistribution);
  
  // Ensure we're not creating a chart if there's no data
  if (!docDistribution.labels.length || !docDistribution.counts.length) {
    console.log('No data for document distribution chart yet');
    return;
  }

  // Use nextTick to ensure DOM is fully updated
  nextTick(() => {
    try {
      const canvas = document.getElementById('documentDistributionChart');
      if (!canvas) {
        console.error('Document distribution chart canvas not found');
        return;
      }
      console.log('Found distribution chart canvas');
      
      // Destroy previous chart if it exists
      if (docDistributionChartInstance) {
        docDistributionChartInstance.destroy();
        docDistributionChartInstance = null;
      }
      
      // Create configuration for the chart
      const chartConfig = {
        type: 'doughnut',
        data: {
          labels: docDistribution.labels,
          datasets: [{
            data: docDistribution.counts,
            backgroundColor: docDistribution.colors,
            borderColor: 'white',
            borderWidth: 2
          }]
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          cutout: '65%',
          plugins: {
            legend: {
              display: false
            },
            tooltip: {
              callbacks: {
                label: function(context) {
                  const label = context.label || '';
                  const value = context.raw;
                  const total = context.dataset.data.reduce((a, b) => a + b, 0);
                  const percentage = Math.round((value / total) * 100);
                  return `${label}: ${value} (${percentage}%)`;
                }
              }
            }
          }
        }
      };
      
      console.log('Creating distribution chart with config:', chartConfig);
      
      // Create the chart using Chart.js
      docDistributionChartInstance = new Chart(canvas.getContext('2d'), chartConfig);
      console.log('Document distribution chart created successfully');
    } catch (error) {
      console.error('Error creating document distribution chart:', error);
    }
  });
};

const toggleDocumentMenu = () => {
  showDocumentMenu.value = !showDocumentMenu.value;
  showTemplateMenu.value = false;
  showClientMenu.value = false;
  showProductMenu.value = false;
  showOcrMenu.value = false;
  showDocManagementMenu.value = false;
};

// Updated state for simplified document management
const isDocManagementActive = computed(() => {
  return ['factures-management', 'devis-management'].includes(currentView.value);
});

// Add new toggle function
const toggleDocManagementMenu = () => {
  showDocManagementMenu.value = !showDocManagementMenu.value;
  showTemplateMenu.value = false;
  showClientMenu.value = false;
  showProductMenu.value = false;
  showOcrMenu.value = false;
  showDocumentMenu.value = false;
};

// Function to fetch product statistics
const fetchProductStatistics = async () => {
  try {
    const token = localStorage.getItem('token');
    if (!token) return;
    
    const response = await axios.get('http://localhost:5000/api/statistics/product-statistics', {
      headers: {
        Authorization: `Bearer ${token}`
      }
    });
    
    if (response.data.success) {
      console.log('Product statistics response:', response.data);
      // Update product statistics data
      productStats.totalProducts = response.data.data.totalProducts || 0;
      productStats.totalValue = response.data.data.totalValue || 0;
      productStats.lowStockProducts = response.data.data.lowStockProducts || [];
      
      if (response.data.data.subcategories) {
        productStats.subcategories.labels = response.data.data.subcategories.labels || [];
        productStats.subcategories.counts = response.data.data.subcategories.counts || [];
        productStats.subcategories.values = response.data.data.subcategories.values || [];
      }
    }
  } catch (error) {
    console.error('Error fetching product statistics:', error);
  }
};

// Initialize data and render charts
onMounted(() => {
  console.log('Component mounted, initializing charts...');
  // Fetch data for all charts
  fetchDashboardStats();
  fetchIncomeChartData();
  fetchDocumentDistribution();
  fetchProductStatistics();
});

// Add to currentPageTitle computed property titles object
const currentPageTitle = computed(() => {
  const titles = {
    'accueil': 'Tableau de bord',
    'create-template': 'Créer Template',
    'predefined-templates': 'Templates Prédéfinis',
    'custom-templates': 'Templates Personnalisés',
    'create-client': 'Nouveau Client',
    'client-list': 'Liste Clients',
    
    'categories': 'Catégories',
    'product-create': 'Nouveau Produit',
    'product-list': 'Liste Produits',
    'stock': 'Gestion Stock',
    'scraping': 'Scraping IA',
    'document-upload': 'Import de Documents',
    'ocr-extraction': 'Extraction OCR',
    'manual-correction': 'Correction Manuelle',
    'ocr-ia': 'OCR & Intelligence Artificielle',
    'factures-management': 'Gestion des Factures',
    'devis-management': 'Gestion des Devis',
    'select-template': 'Sélection Modèle',
    'auto-fill': 'Chargement Auto',
    'manual-fill': 'Remplissage Manuel',
    'preview-validate': 'Aperçu & Validation',
    'save-integrate': 'Enregistrement BD'
  };
  return titles[currentView.value] || 'Tableau de bord';
});

// Add new computed property for user role
const userRole = computed(() => {
  return store.user ? store.user.role : 'guest';
});

// User menu toggle function
const toggleUserMenu = () => {
  showUserMenu.value = !showUserMenu.value;
};

// Logout function
const handleLogout = () => {
  store.logout();
  router.push('/login');
};

// La gestion du type de document est maintenant gérée dans le composant DocumentCreationFlow

// Update navigation logic to handle user roles
const navigateTo = (route) => {
  // Mettre à jour la vue actuelle
  currentView.value = route;
  console.log(`Navigation: currentView mis à jour vers ${route}`);
  
  const routeMap = {
    'accueil': '/admin-entreprise',
    'create-template': '/admin-entreprise/create-template',
    'predefined-templates': '/admin-entreprise/predefined-templates',
    'custom-templates': '/admin-entreprise/custom-templates',
    'create-client': '/admin-entreprise/create-client',
    'client-list': '/admin-entreprise/client-list',
    
    'categories': '/admin-entreprise/categories',
    'product-create': '/admin-entreprise/product-create',
    'product-list': '/admin-entreprise/product-list',
    'stock': '/admin-entreprise/stock',
    'scraping': '/admin-entreprise/scraping',
    'ocr-ia': '/admin-entreprise/ocr-ia',
    'document-creation': '/admin-entreprise', // Ajout de la route document-creation
    'document-upload': '/admin-entreprise/document-upload',
    'ocr-extraction': '/admin-entreprise/ocr-extraction',
    'manual-correction': '/admin-entreprise/manual-correction',
    'select-template': '/admin-entreprise/select-template',
    'auto-fill': '/admin-entreprise/auto-fill',
    'manual-fill': '/admin-entreprise/manual-fill',
    'preview-validate': '/admin-entreprise/preview-validate',
    'save-integrate': '/admin-entreprise/save-integrate',
    'document-search': '/admin-entreprise/document-search',
    'document-filter': '/admin-entreprise/document-filter',
    'document-preview': '/admin-entreprise/document-preview',
    'document-export': '/admin-entreprise/document-export',
    'document-email': '/admin-entreprise/document-email',
    'factures-management': '/admin-entreprise/factures-management',
    'devis-management': '/admin-entreprise/devis-management',
    // Note: edit-client route requires an ID parameter and is handled directly in ClientList.vue
  };
  
  if (routeMap[route]) {
    console.log(`Navigating to mapped route: ${routeMap[route]}`);
    // Utiliser nextTick pour s'assurer que la vue est mise à jour avant la navigation
    nextTick(() => {
      router.push(routeMap[route]).catch(err => {
        console.error(`Erreur lors de la navigation vers ${routeMap[route]}:`, err);
      });
    });
  } else {
    console.log(`Navigating to route by name: ${route}`);
    try {
      nextTick(() => {
        router.push({ name: route }).catch(err => {
          console.error(`Erreur lors de la navigation par nom vers ${route}:`, err);
          router.push(`/${route}`).catch(err => {
            console.error(`Erreur lors de la navigation par chemin vers /${route}:`, err);
          });
        });
      });
    } catch (error) {
      console.error(`Erreur de navigation vers ${route}:`, error);
      nextTick(() => {
        router.push(`/${route}`).catch(err => {
          console.error(`Erreur lors de la navigation de secours vers /${route}:`, err);
        });
      });
    }
  }
};
</script>

<style scoped>
/* Enhanced Sidebar Styles */
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
  -webkit-backpack-filter: blur(10px);
}

.sidebar:hover {
  box-shadow: 8px 0 20px rgba(0, 0, 0, 0.2);
}

.sidebar.collapsed {
  width: 80px;
}

.sidebar-menu {
  padding: 20px 0;
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

.menu-item:hover {
  background-color: rgba(255, 255, 255, 0.15);
  transform: translateX(5px);
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2), 0 0 0 1px rgba(255, 255, 255, 0.05);
  letter-spacing: 0.5px;
}

.menu-item.active {
  background-color: rgba(255, 255, 255, 0.2);
  transform: translateX(5px);
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2), 0 0 0 1px rgba(255, 255, 255, 0.1);
}

.menu-icon {
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

.submenu-item.active {
  background-color: rgba(79, 172, 254, 0.15);
  transform: translateX(5px);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15), 0 0 0 1px rgba(255, 255, 255, 0.1);
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

.sidebar-toggle-button:hover::after {
  opacity: 1;
}

/* Main Layout */
.dashboard-container {
  display: flex;
  min-height: 100vh;
  background-color: #f5f5f5;
  position: relative;
  overflow: hidden;
}

/* Animation Keyframes */
@keyframes fadeIn {
  from { opacity: 0; transform: translateY(-20px); filter: blur(3px); }
  to { opacity: 1; transform: translateY(0); filter: blur(0); }
}

@keyframes slideInRight {
  from { transform: translateX(30px); opacity: 0; }
  to { transform: translateX(0); opacity: 1; }
}

@keyframes slideInLeft {
  from { transform: translateX(-30px); opacity: 0; }
  to { transform: translateX(0); opacity: 1; }
}

@keyframes pulseScale {
  0% { transform: scale(1); }
  50% { transform: scale(1.05); }
  100% { transform: scale(1); }
}

@keyframes slideDown {
  from { transform: scaleY(0); opacity: 0; }
  to { transform: scaleY(1); opacity: 1; }
}

@keyframes widthPulse {
  0% { width: 0; opacity: 0; }
  50% { width: 80px; opacity: 1; }
  100% { width: 60px; opacity: 1; }
}

@keyframes titleSlideIn {
  0% { transform: translateX(-20px); opacity: 0; }
  100% { transform: translateX(0); opacity: 1; }
}

@keyframes profilePhotoAppear {
  0% { transform: scale(0.9); opacity: 0; filter: blur(5px); }
  100% { transform: scale(1); opacity: 1; filter: blur(0); }
}

@keyframes widgetAppear {
  from { opacity: 0; transform: translateY(20px); }
  to { opacity: 1; transform: translateY(0); }
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
  box-shadow: 0 3px 8px rgba(0, 0, 0, 0.2);
  transition: all 0.3s ease;
}

.sidebar-user-avatar:hover .avatar-letter {
  transform: scale(1.1);
  box-shadow: 0 5px 12px rgba(0, 0, 0, 0.3);
}
/* Sidebar Styles */
/* Sidebar Styles */
.sidebar {
  width: 260px;
  background: linear-gradient(135deg, #002446 0%, #003a6c 100%);
  color: white;
  display: flex;
  flex-direction: column;
  transition: all 0.4s cubic-bezier(0.25, 0.8, 0.25, 1);
  position: fixed;
  top: 0;
  left: 0;
  bottom: 0;
  height: 100vh;
  overflow-y: scroll;
  overflow-x: hidden;
  scrollbar-width: none; /* Firefox */
  -ms-overflow-style: none; /* IE and Edge */
  z-index: 20;
  box-shadow: 5px 0 15px rgba(0, 0, 0, 0.1), inset 0 0 0 1px rgba(255, 255, 255, 0.05);
  border-right: 1px solid rgba(255, 255, 255, 0.05);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
}

.sidebar::-webkit-scrollbar {
  display: none; /* Chrome, Safari, Edge */
}

.sidebar.collapsed {
  width: 80px;
  box-shadow: 3px 0 10px rgba(0, 0, 0, 0.1);
}

.sidebar.collapsed .site-name,
.sidebar.collapsed .menu-title,
.sidebar.collapsed .dropdown-icon,
.sidebar.collapsed .submenu,
.sidebar.collapsed .sidebar-user-info,
.sidebar.collapsed .sidebar-user-role,
.sidebar.collapsed .sidebar-user-menu {
  display: none;
}

.sidebar.collapsed .menu-icon,
.sidebar.collapsed .sidebar-user-avatar {
  margin: 0 auto;
}

.sidebar.collapsed .menu-item {
  padding: 12px;
  justify-content: center;
}

.sidebar.collapsed .sidebar-user-container {
  justify-content: center;
  padding: 10px 5px;
}

.sidebar-toggle-button {
  position: absolute;
  top: 20px;
  right: -16px;
  width: 32px;
  height: 32px;
  background: linear-gradient(135deg, #003a6c 0%, #002446 100%);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  color: white;
  box-shadow: 0 3px 8px rgba(0, 0, 0, 0.3);
  z-index: 100;
  transition: all 0.3s ease;
  overflow: hidden;
}

.sidebar-toggle-button:hover {
  transform: scale(1.1);
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.4);
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

.sidebar-toggle-button:active::after {
  transform: translate(-50%, -50%) scale(2.5);
  opacity: 1;
  transition: transform 0.5s, opacity 0s;
}

.toggle-tooltip {
  position: absolute;
  right: 45px;
  background: rgba(0, 0, 0, 0.8);
  color: white;
  padding: 5px 10px;
  border-radius: 4px;
  font-size: 0.75rem;
  opacity: 0;
  visibility: hidden;
  transition: all 0.3s ease;
  white-space: nowrap;
}

.sidebar-toggle-button:hover .toggle-tooltip {
  opacity: 1;
  visibility: visible;
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
  box-shadow: 0 3px 8px rgba(0, 0, 0, 0.3);
  z-index: 100;
  transition: all 0.3s ease;
  overflow: hidden;
}

.sidebar-toggle-button:hover {
  transform: translateY(-50%) scale(1.1);
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.4);
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

.sidebar-toggle-button:active::after {
  transform: translate(-50%, -50%) scale(2.5);
  opacity: 1;
  transition: transform 0.5s, opacity 0s;
}

.toggle-tooltip {
  position: absolute;
  right: 45px;
  background: rgba(0, 0, 0, 0.8);
  color: white;
  padding: 5px 10px;
  border-radius: 4px;
  font-size: 0.75rem;
  opacity: 0;
  visibility: hidden;
  transition: all 0.3s ease;
}

.sidebar-toggle-button:hover .toggle-tooltip {
  opacity: 1;
  visibility: visible;
}

/* Main content styles replaced by dashboard-content styles */

.fade-enter-active,
.fade-leave-active {
  transition: all 0.5s ease;
}

.fade-enter-from {
  opacity: 0;
  transform: translateY(30px);
}

.fade-leave-to {
  opacity: 0;
  transform: translateY(-30px);
}

.welcome-card {
  animation: slideIn 0.8s ease-out forwards;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(5px); filter: blur(3px); }
  to { opacity: 1; transform: translateY(0); filter: blur(0); }
}

@keyframes slideIn {
  0% {
    opacity: 0;
    transform: translateY(20px);
  }
  100% {
    opacity: 1;
    transform: translateY(0);
  }
}

.welcome-card h2 {
  animation: fadeInScale 1s ease-out forwards;
}

@keyframes fadeInScale {
  0% {
    opacity: 0;
    transform: scale(0.95);
  }
  100% {
    opacity: 1;
    transform: scale(1);
  }
}

.welcome-subtitle {
  animation: fadeIn 1s ease-out 0.3s forwards;
  opacity: 0;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.router-view-container {
  transition: all 0.3s ease;
}

.sidebar-user-section {
  margin-top: auto;
  padding: 15px;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  background-color: rgba(0, 0, 0, 0.2);
  transition: all 0.3s ease;
  position: relative;
  z-index: 30;
}

.sidebar-user-container {
  display: flex;
  align-items: center;
  padding: 10px;
  cursor: pointer;
  border-radius: var(--border-radius-md);
  transition: all var(--transition-normal);
  position: relative;
  overflow: hidden;
}

.sidebar-user-container::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.1) 0%, rgba(255, 255, 255, 0) 100%);
  opacity: 0;
  transition: opacity var(--transition-normal);
}

.sidebar-user-container:hover::before {
  opacity: 1;
}

.sidebar-user-container:hover {
  background-color: rgba(255, 255, 255, 0.1);
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
  box-shadow: 0 0 10px rgba(255, 255, 255, 0.2);
  transition: all var(--transition-normal);
}

.sidebar-user-container:hover .sidebar-user-avatar {
  transform: scale(1.1);
  box-shadow: 0 0 15px rgba(255, 255, 255, 0.3);
}

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
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
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

.sidebar-user-role {
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
  transition: background-color 0.3s ease, transform 0.2s ease;
}

.sidebar-menu-option:hover {
  background-color: rgba(255, 255, 255, 0.1);
  transform: translateX(5px);
}

.sidebar-menu-option i {
  margin-right: 10px;
  width: 20px;
  text-align: center;
}

/* Base Styles */
:root {
  --primary-color: #002446;
  --primary-light: #003a6c;
  --accent-color: #4facfe;
  --accent-light: #00f2fe;
  --text-light: #ffffff;
  --text-dark: #333333;
  --bg-light: #f5f5f5;
  --bg-dark: #1a1a2e;
  --shadow-sm: 0 2px 10px rgba(0, 0, 0, 0.05);
  --shadow-md: 0 5px 15px rgba(0, 0, 0, 0.1);
  --shadow-lg: 0 10px 25px rgba(0, 0, 0, 0.15);
  --transition-fast: 0.2s ease;
  --transition-normal: 0.3s ease;
  --transition-slow: 0.5s ease;
  --border-radius-sm: 4px;
  --border-radius-md: 8px;
  --border-radius-lg: 12px;
}

.sidebar-menu-option.sidebar-logout {
  color: #ff6b6b;
  transition: all var(--transition-normal);
}

.sidebar-menu-option.sidebar-logout:hover {
  background-color: rgba(255, 107, 107, 0.2);
  transform: translateX(5px);
}

.dashboard-container {
  display: flex;
  min-height: 100vh;
  background-color: var(--bg-light);
  width: 100%;
  margin: 0;
  padding: 0;
  overflow-x: hidden;
  position: absolute;
  left: 0;
  right: 0;
  transition: background-color var(--transition-slow);
}

.logo-container {
  display: flex;
  align-items: center;
  padding: 20px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  transition: all var(--transition-normal);
  gap: 15px;
  animation: fadeIn 0.8s ease-out forwards;
}

.logo {
  width: 40px;
  height: 40px;
  border-radius: var(--border-radius-md);
  animation: logoSpin 1.2s cubic-bezier(0.215, 0.61, 0.355, 1) forwards;
  box-shadow: 0 0 15px rgba(255, 255, 255, 0.2);
}

.site-name {
  margin-left: 10px;
  font-size: 1.5rem;
  font-weight: 600;
  transition: opacity var(--transition-normal), visibility var(--transition-normal);
  white-space: nowrap;
  background: linear-gradient(45deg, #fff, #cce5ff);
  background-clip: text;
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  animation: slideInRight 0.8s cubic-bezier(0.25, 0.46, 0.45, 0.94);
}

.menu-item {
  padding: 12px 20px;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
  display: flex;
  align-items: center;
  margin: 6px 0;
  border-radius: var(--border-radius-md);
  position: relative;
  overflow: hidden;
  backdrop-filter: blur(5px);
  -webkit-backdrop-filter: blur(5px);
  gap: 12px;
  animation: fadeIn 0.5s ease-out forwards;
  animation-delay: calc(var(--i, 0) * 0.05s);
  opacity: 0;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
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
  color: rgba(255, 255, 255, 0.8);
}

.menu-item:hover .menu-icon,
.menu-item.active .menu-icon,
.submenu-item:hover .submenu-icon {
  color: #4facfe;
  transform: scale(1.1);
}

.menu-title, .submenu-title {
  transition: all 0.3s ease;
  letter-spacing: 0.2px;
}

.menu-item:hover .menu-title,
.menu-item.active .menu-title,
.submenu-item:hover .submenu-title {
  color: #fff;
  letter-spacing: 0.5px;
}

.main-content {
  flex: 1;
  margin-left: 0; /* Changed from 260px to remove decalage */
  padding: 0;
  background-color: #f5f5f5;
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  transition: all 0.3s ease;
}

.sidebar.collapsed ~ .main-content {
  margin-left: 0; /* Changed from 80px to remove decalage */
}

.sidebar ~ .main-content {
  margin-left: 0; /* Changed from 260px to remove decalage */
}

.top-navbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px 25px;
  background: white;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
  position: sticky;
  top: 0;
  width: 100%;
  z-index: 10;
}

.welcome-section {
  padding: 0;
}

.welcome-card {
  margin: 0;
  border-radius: 0;
  background: linear-gradient(135deg, #002446 0%, #003a6c 100%);
  border-left: 5px solid #4facfe;
  padding: 20px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
  margin-top: 0 !important;
  padding-top: 0;
  position: relative;
}

.welcome-card::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 0;
  width: 100%;
  height: 3px;
  background: linear-gradient(90deg, #002446, transparent);
  opacity: 0.3;
}

.welcome-card h2 {
  margin: 0 0 15px 0;
  font-size: 2.2rem;
  color: #ffffff;
  font-weight: 700;
  position: relative;
  z-index: 1;
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.2);
}

.dropdown-icon {
  margin-left: auto;
  transition: transform 0.3s ease;
  color: rgba(255, 255, 255, 0.6);
}

.dropdown-icon.rotated {
  transform: rotate(180deg);
  color: #4facfe;
}

.menu-item:hover .dropdown-icon {
  color: rgba(255, 255, 255, 0.9);
}

.submenu {
  margin-top: 5px;
  padding-left: 20px;
  animation: slideDown 0.3s ease-out;
  max-width: 100%;
  overflow: hidden;
  position: relative;
  width: 100%;
  background-color: rgba(0, 0, 0, 0.1);
  border-radius: 0 0 8px 8px;
  box-shadow: inset 0 2px 5px rgba(0, 0, 0, 0.1);
  transition: all 0.3s ease-out;
}

@keyframes slideDown {
  from {
    opacity: 0;
    transform: translateY(-10px);
    max-height: 0;
  }
  to {
    opacity: 1;
    transform: translateY(0);
    max-height: 500px;
  }
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(5px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.fade-enter-active,
.fade-leave-active {
  transition: all 0.3s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
  transform: translateY(10px);
}

.slide-right-enter-active,
.slide-right-leave-active {
  transition: all 0.3s ease;
}

.slide-right-enter-from {
  opacity: 0;
  transform: translateX(-20px);
}

.slide-right-leave-to {
  opacity: 0;
  transform: translateX(20px);
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
  gap: 10px;
  animation: fadeIn 0.3s ease-out forwards;
  animation-delay: calc(var(--i, 0) * 0.05s);
  opacity: 0;
}

.submenu-item:hover {
  background-color: rgba(255, 255, 255, 0.2);
  transform: translateX(5px);
  transition: background-color 0.3s ease, transform 0.2s ease;
  border-left: 2px solid #cce5ff;
}

.submenu-item.active {
  background-color: rgba(79, 172, 254, 0.15);
  transform: translateX(5px);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15), 0 0 0 1px rgba(255, 255, 255, 0.1);
}

.dashboard-stats {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 20px;
  margin-top: 20px;
}

.stat-card {
  background: white;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
  display: flex;
  align-items: center;
  gap: 15px;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.stat-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
}

.stat-icon {
  font-size: 2rem;
  color: #002446;
  background: rgba(0, 36, 70, 0.1);
  width: 60px;
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 12px;
}

.stat-info h3 {
  margin: 0;
  font-size: 1rem;
  color: #666;
}

.stat-number {
  font-size: 1.8rem;
  font-weight: 700;
  color: #002446;
  margin: 5px 0 0 0;
}

/* Main Content Styles */
.main-content {
  flex: 1;
  padding: 0;
  overflow-y: auto;
  position: relative;
  background-color: #f5f5f5;
  transition: all 0.3s ease;
}

.top-navbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px 25px;
  background: white;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
  position: sticky;
  top: 0;
  width: 100%;
  z-index: 10;
}

.page-title-text {
  margin: 0;
  color: #002446;
  font-size: 1.5rem;
  font-weight: 600;
  animation: titleSlideIn 0.7s cubic-bezier(0.25, 0.46, 0.45, 0.94) forwards;
}

.dashboard-content {
  padding: 20px;
  animation: fadeIn 0.5s ease-out;
}

.welcome-section {
  margin-bottom: 30px;
}

.welcome-card {
  background: linear-gradient(135deg, #002446 0%, #003a6c 100%);
  color: white;
  border-radius: 12px;
  padding: 25px;
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
  position: relative;
  overflow: hidden;
  animation: slideInRight 0.7s cubic-bezier(0.25, 0.46, 0.45, 0.94);
}

.welcome-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: radial-gradient(circle at top right, rgba(255, 255, 255, 0.2) 0%, rgba(255, 255, 255, 0) 70%);
  pointer-events: none;
}

.welcome-card h2 {
  margin-top: 0;
  font-size: 1.8rem;
  font-weight: 700;
  margin-bottom: 10px;
}

.welcome-subtitle {
  margin: 0;
  font-size: 1.1rem;
  opacity: 0.9;
  color: #ffffff;
}

/* Widget Transitions */
.widget-enter-active {
  transition: all 0.5s cubic-bezier(0.25, 0.46, 0.45, 0.94);
  transition-delay: calc(var(--delay) * 0.1s);
}

.widget-enter-from {
  opacity: 0;
  transform: translateY(30px);
}

.widget-leave-active {
  transition: all 0.3s ease;
}

.widget-leave-to {
  opacity: 0;
  transform: translateY(30px);
}

/* Responsive Adjustments */
@media (max-width: 768px) {
  .dashboard-stats {
    grid-template-columns: 1fr;
  }
  
  .sidebar.collapsed {
    width: 0;
    padding: 0;
  }
  
  .sidebar-toggle-button {
    right: -15px;
  }
}
.chart-container {
  display: flex;
  flex-wrap: wrap;
  gap: 1.5rem;
  margin-top: 1.5rem;
}

.chart-section {
  flex: 1;
  min-width: 300px;
  background: #fff;
  border-radius: 10px;
  box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
  padding: 1.5rem;
  animation: fadeInScale 0.6s cubic-bezier(0.215, 0.61, 0.355, 1) forwards;
  animation-delay: calc(var(--delay, 0) * 0.1s + 0.2s);
  opacity: 0;
  transform: scale(0.95);
}

.chart-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1rem;
}

.chart-title {
  font-size: 1.25rem;
  font-weight: 600;
  color: #333;
  margin: 0;
}

.chart-controls {
  display: flex;
  align-items: center;
}

.time-range-select {
  padding: 0.5rem;
  border: 1px solid #ddd;
  border-radius: 5px;
  background-color: #f8f9fa;
  font-size: 0.9rem;
  cursor: pointer;
  outline: none;
  transition: all 0.3s ease;
}

.time-range-select:hover {
  border-color: #4bc0c0;
}

#revenueChart {
  width: 100%;
  height: 250px;
  margin-top: 1rem;
}

.chart-row {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.half-chart {
  flex: 1;
  min-width: 200px;
  height: 220px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.chart-stats {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.stat-item {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
  padding: 0.5rem;
  border-radius: 8px;
  background-color: #f8f9fa;
}

.stat-label {
  display: flex;
  align-items: center;
  font-weight: 600;
  font-size: 1rem;
}

.stat-dot {
  display: inline-block;
  width: 12px;
  height: 12px;
  border-radius: 50%;
  margin-right: 8px;
}

.stat-values {
  display: flex;
  justify-content: space-between;
}

.stat-value {
  font-size: 0.9rem;
  color: #666;
}

/* Transactions Section Styles */
.transactions-section {
  margin-top: 1.5rem;
  background: #fff;
  border-radius: 10px;
  box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
  padding: 1.5rem;
  animation: fadeInScale 0.6s cubic-bezier(0.215, 0.61, 0.355, 1) forwards;
  animation-delay: 0.4s;
  opacity: 0;
  transform: scale(0.95);
}

.section-title {
  font-size: 1.25rem;
  font-weight: 600;
  margin-bottom: 1rem;
  color: #333;
}

.transactions-list {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.transaction-item {
  display: flex;
  align-items: center;
  padding: 0.75rem;
  border-radius: 8px;
  background-color: #f8f9fa;
  transition: all 0.3s ease;
}

.transaction-item:hover {
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
}

.transaction-icon {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 1rem;
  color: white;
}

.invoice-icon {
  background-color: #4bc0c0;
}

.quote-icon {
  background-color: #ff9f40;
}

.transaction-details {
  flex: 1;
}

.transaction-title {
  font-weight: 600;
  margin-bottom: 0.25rem;
}

.transaction-subtitle {
  font-size: 0.9rem;
  color: #666;
}

.transaction-amount {
  font-weight: 600;
  color: #4bc0c0;
  margin-right: 1rem;
  white-space: nowrap;
}

.transaction-date {
  font-size: 0.9rem;
  color: #999;
  white-space: nowrap;
}

.empty-list-message {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 2rem;
  color: #999;
  font-style: italic;
  gap: 0.5rem;
}

/* Product Statistics Styles */
.product-stats-container {
  display: flex;
  flex-direction: column;
  gap: 20px;
  padding: 15px;
  background-color: #fff;
  border-radius: 10px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
}

.product-stats-summary {
  display: flex;
  gap: 20px;
  flex-wrap: wrap;
}

.product-stat-item {
  flex: 1;
  min-width: 200px;
  display: flex;
  align-items: center;
  padding: 15px;
  background-color: #f8f9fa;
  border-radius: 8px;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.product-stat-item:hover {
  transform: translateY(-5px);
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
}

.product-stat-icon {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 50px;
  height: 50px;
  background-color: #4bc0c0;
  color: white;
  border-radius: 10px;
  margin-right: 15px;
  font-size: 1.5rem;
}

.product-stat-details h4 {
  margin: 0 0 5px 0;
  font-size: 0.9rem;
  color: #6c757d;
}

.product-stat-value {
  margin: 0;
  font-size: 1.5rem;
  font-weight: 600;
  color: #343a40;
}

.low-stock-products {
  background-color: #f8f9fa;
  border-radius: 8px;
  padding: 15px;
}

.low-stock-title {
  margin: 0 0 15px 0;
  font-size: 1.1rem;
  color: #343a40;
  display: flex;
  align-items: center;
}

.low-stock-title::before {
  content: '⚠️';
  margin-right: 8px;
}

.low-stock-list {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.low-stock-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 15px;
  background-color: white;
  border-radius: 6px;
  border-left: 4px solid #4bc0c0;
  transition: transform 0.2s ease;
}

.low-stock-item:hover {
  transform: translateX(5px);
}

.low-stock-name {
  font-weight: 500;
  flex: 2;
}

.low-stock-quantity {
  padding: 4px 8px;
  background-color: #ffd166;
  color: #343a40;
  border-radius: 4px;
  font-size: 0.85rem;
  font-weight: 500;
  flex: 1;
  text-align: center;
}

.low-stock-quantity.critical {
  background-color: #ef476f;
  color: white;
}

.low-stock-price {
  font-weight: 500;
  color: #495057;
  flex: 1;
  text-align: right;
}

/* Fixed Sidebar with Scrollable Content */
.dashboard-container {
  display: flex;
  min-height: 100vh;
  position: relative;
  background-image: linear-gradient(to right, #002446, #003a6c 260px, #f5f5f5 260px);
  transition: background-image 0.3s ease;
}

.dashboard-container.sidebar-collapsed {
  background-image: linear-gradient(to right, #002446, #003a6c 80px, #f5f5f5 80px);
}

.sidebar {
  position: fixed;
  height: 100vh;
  overflow-y: auto;
  overflow-x: hidden;
  z-index: 100;
}

.dashboard-content {
  flex: 1;
  padding: 20px 30px;
  margin-left: 260px; /* Match sidebar width */
  width: calc(100% - 260px);
  transition: margin-left 0.3s ease, width 0.3s ease;
  background-color: #f5f5f5;
  min-height: 100vh;
}

.dashboard-container.sidebar-collapsed .dashboard-content {
  margin-left: 80px; /* Match collapsed sidebar width */
  width: calc(100% - 80px);
}
</style>