<template>
  <div class="tab-content">
    <div class="section-header">
      <h2>Statistiques</h2>
      <div class="period-filter">
        <select v-model="periodFilter" class="filter-select" @change="updateStatistics">
          <option value="day">Aujourd'hui</option>
          <option value="week">Cette semaine</option>
          <option value="month">Ce mois</option>
          <option value="year">Cette année</option>
          <option value="all">Toutes les données</option>
        </select>
      </div>
    </div>

    <!-- Stats Summary Cards -->
    <div class="stats-section">
      <h3 class="section-title">Aperçu Général</h3>
      <div class="stats-cards">
        <div class="stat-card" style="--i: 0">
          <div class="stat-icon users">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
              <circle cx="9" cy="7" r="4"></circle>
              <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
              <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
            </svg>
          </div>
          <div class="stat-info">
            <h3>Utilisateurs</h3>
            <p class="stat-value">{{ statistics.totalUsers }}</p>
            <p class="stat-change" :class="statistics.userGrowth >= 0 ? 'positive' : 'negative'">
              {{ statistics.userGrowth >= 0 ? '+' : '' }}{{ statistics.userGrowth }}% depuis la dernière période
            </p>
          </div>
        </div>

        <div class="stat-card" style="--i: 1">
          <div class="stat-icon new-users">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
              <circle cx="8.5" cy="7" r="4"></circle>
              <line x1="20" y1="8" x2="20" y2="14"></line>
              <line x1="23" y1="11" x2="17" y2="11"></line>
            </svg>
          </div>
          <div class="stat-info">
            <h3>Nouveaux utilisateurs</h3>
            <p class="stat-value">{{ statistics.newUsers }}</p>
            <p class="stat-details">ce mois-ci</p>
          </div>
        </div>

        <div class="stat-card" style="--i: 2">
          <div class="stat-icon invoices">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
              <polyline points="14 2 14 8 20 8"></polyline>
              <line x1="16" y1="13" x2="8" y2="13"></line>
              <line x1="16" y1="17" x2="8" y2="17"></line>
              <polyline points="10 9 9 9 8 9"></polyline>
            </svg>
          </div>
          <div class="stat-info">
            <h3>Factures</h3>
            <p class="stat-value">{{ statistics.totalInvoices }}</p>
            <p class="stat-change" :class="statistics.invoiceGrowth >= 0 ? 'positive' : 'negative'">
              {{ statistics.invoiceGrowth >= 0 ? '+' : '' }}{{ statistics.invoiceGrowth }}% depuis la dernière période
            </p>
          </div>
        </div>

        <div class="stat-card" style="--i: 3">
          <div class="stat-icon quotations">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
              <polyline points="14 2 14 8 20 8"></polyline>
              <line x1="16" y1="13" x2="8" y2="13"></line>
              <line x1="16" y1="17" x2="8" y2="17"></line>
            </svg>
          </div>
          <div class="stat-info">
            <h3>Devis</h3>
            <p class="stat-value">{{ statistics.totalQuotations }}</p>
            <p class="stat-change" :class="statistics.quotationGrowth >= 0 ? 'positive' : 'negative'">
              {{ statistics.quotationGrowth >= 0 ? '+' : '' }}{{ statistics.quotationGrowth }}% depuis la dernière période
            </p>
          </div>
        </div>

        <div class="stat-card" style="--i: 4">
          <div class="stat-icon inactive-users">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
              <circle cx="8.5" cy="7" r="4"></circle>
              <line x1="18" y1="8" x2="23" y2="13"></line>
              <line x1="23" y1="8" x2="18" y2="13"></line>
            </svg>
          </div>
          <div class="stat-info">
            <h3>Comptes désactivés</h3>
            <p class="stat-value">{{ statistics.deactivatedUsers || 0 }}</p>
            <p class="stat-details">non vérifiés</p>
          </div>
        </div>
        
        <div class="stat-card" style="--i: 5">
          <div class="stat-icon templates">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect>
              <line x1="3" y1="9" x2="21" y2="9"></line>
              <line x1="9" y1="21" x2="9" y2="9"></line>
            </svg>
          </div>
          <div class="stat-info">
            <h3>Templates prédéfinis</h3>
            <p class="stat-value">{{ statistics.totalPredefinedTemplates || 0 }}</p>
            <p class="stat-details">modèles système</p>
          </div>
        </div>

      </div>
    </div>
    
    <!-- User Statistics Detail -->
    <div class="stats-section">
      <h3 class="section-title">Statistiques des Utilisateurs</h3>
      <div class="detail-stats-grid">
        <div class="detail-stat-card">
          <h4>Distribution par rôle</h4>
          <div class="role-distribution">
            <div class="role-item">
              <div class="role-color" style="background-color: #4facfe;"></div>
              <div class="role-name">Admin</div>
              <div class="role-count">{{ statistics.usersByRole.admin }}</div>
            </div>
            <div class="role-item">
              <div class="role-color" style="background-color: #6a75ca;"></div>
              <div class="role-name">Admin Entreprise</div>
              <div class="role-count">{{ statistics.usersByRole.enterprise_admin }}</div>
            </div>
            <div class="role-item">
              <div class="role-color" style="background-color: #00c49f;"></div>
              <div class="role-name">Client</div>
              <div class="role-count">{{ statistics.usersByRole.client }}</div>
            </div>
          </div>
          <div class="pie-chart-container">
            <canvas ref="roleDistributionChart"></canvas>
          </div>
        </div>
        

        
        <div class="detail-stat-card">
          <h4>Utilisateurs récemment inscrits</h4>
          <div class="recent-users">
            <div v-for="user in statistics.recentUsers" :key="user.id" class="recent-user-item">
              <div class="user-avatar">
                <div class="avatar-letter">{{ user.first_name[0] }}</div>
              </div>
              <div class="user-info">
                <div class="user-name">{{ user.first_name }} {{ user.last_name }}</div>
                <div class="user-role">{{ formatRole(user.role) }}</div>
              </div>
              <div class="user-date">{{ formatDate(user.created_at) }}</div>
            </div>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Document Statistics Detail -->
    <div class="stats-section">
      <h3 class="section-title">Statistiques des Documents</h3>
      <div class="detail-stats-grid">
        <div class="detail-stat-card document-trends">
          <h4>Factures & Devis par mois</h4>
          <div class="chart-container">
            <canvas ref="documentTrendsChart"></canvas>
          </div>
        </div>
        
        <div class="detail-stat-card">
          <h4>Montants Totaux</h4>
          <div class="amount-stats">
            <div class="amount-stat-item">
              <div class="amount-label">Total HT</div>
              <div class="amount-value">{{ formatCurrency(statistics.amounts.totalHT) }}</div>
            </div>
            <div class="amount-stat-item">
              <div class="amount-label">Total Remise</div>
              <div class="amount-value">{{ formatCurrency(statistics.amounts.totalRemise) }}</div>
            </div>
            <div class="amount-stat-item">
              <div class="amount-label">Total Net HT</div>
              <div class="amount-value">{{ formatCurrency(statistics.amounts.totalNetHT) }}</div>
            </div>
            <div class="amount-stat-item">
              <div class="amount-label">Total TVA</div>
              <div class="amount-value">{{ formatCurrency(statistics.amounts.totalTVA) }}</div>
            </div>
            <div class="amount-stat-item highlight">
              <div class="amount-label">Total TTC</div>
              <div class="amount-value">{{ formatCurrency(statistics.amounts.totalTTC) }}</div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- User Registration Trends Chart -->
    <div class="stats-section">
      <h3 class="section-title">Tendances d'Inscription des Utilisateurs</h3>
      <div class="full-width-chart-container">
        <canvas ref="userRegistrationTrendsChart"></canvas>
      </div>
    </div>
    

  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue';
import axios from 'axios';
import Chart from 'chart.js/auto';

// References for chart canvases
const roleDistributionChart = ref(null);
const userRegistrationTrendsChart = ref(null);
const documentTrendsChart = ref(null);
const revenueChart = ref(null);

// Chart instances
let roleChart = null;
let userTrendsChart = null;
let docTrendsChart = null;
let revChart = null;

// State variables
const periodFilter = ref('month');
const loading = ref(false);
const error = ref(null);

// Initial statistics data structure
const statistics = ref({
  totalUsers: 0,
  newUsers: 0,
  totalInvoices: 0,
  totalQuotations: 0,
  userGrowth: 0,
  invoiceGrowth: 0,
  quotationGrowth: 0,
  deactivatedUsers: 0,
  totalPredefinedTemplates: 0,
  totalTemplates: 0,
  
  // User statistics
  usersByRole: {
    admin: 5,
    enterprise_admin: 42,
    client: 98
  },
  recentUsers: [
    { id: 17, first_name: 'Sophie', last_name: 'Martin', role: 'client', created_at: '2024-05-02T14:23:45' },
    { id: 16, first_name: 'Jean', last_name: 'Dupont', role: 'enterprise_admin', created_at: '2024-04-28T09:12:30' },
    { id: 15, first_name: 'Marie', last_name: 'Leclerc', role: 'client', created_at: '2024-04-25T16:45:22' },
    { id: 14, first_name: 'Michel', last_name: 'Bernard', role: 'client', created_at: '2024-04-20T11:38:14' },
    { id: 13, first_name: 'Thomas', last_name: 'Petit', role: 'enterprise_admin', created_at: '2024-04-15T08:55:19' }
  ],
  
  // Monthly trends data
  userRegistrationByMonth: {
    '2024-05': 28,
    '2024-04': 22,
    '2024-03': 15,
    '2024-02': 18,
    '2024-01': 12,
    '2023-12': 10,
    '2023-11': 8,
    '2023-10': 7,
    '2023-09': 6,
    '2023-08': 4,
    '2023-07': 5,
    '2023-06': 10
  },
  
  // Document statistics
  documentsByMonth: {
    '2024-05': { factures: 35, devis: 22 },
    '2024-04': { factures: 42, devis: 18 },
    '2024-03': { factures: 38, devis: 25 },
    '2024-02': { factures: 29, devis: 19 },
    '2024-01': { factures: 31, devis: 15 },
    '2023-12': { factures: 27, devis: 17 },
    '2023-11': { factures: 25, devis: 14 },
    '2023-10': { factures: 19, devis: 12 },
    '2023-09': { factures: 22, devis: 15 },
    '2023-08': { factures: 18, devis: 13 },
    '2023-07': { factures: 15, devis: 9 },
    '2023-06': { factures: 11, devis: 8 }
  },
  
  // Financial statistics
  amounts: {
    totalHT: 6850.13,
    totalRemise: 342.50,
    totalNetHT: 6507.63,
    totalTVA: 1371.03,
    totalTTC: 8223.16
  },
  
  revenueByMonth: {
    '2024-05': 1523.45,
    '2024-04': 1328.90,
    '2024-03': 1156.32,
    '2024-02': 985.75,
    '2024-01': 876.18,
    '2023-12': 793.54,
    '2023-11': 656.21,
    '2023-10': 589.67,
    '2023-09': 501.32,
    '2023-08': 428.90,
    '2023-07': 350.45,
    '2023-06': 278.98
  }
});

// Helper Methods
const formatCurrency = (value) => {
  return new Intl.NumberFormat('fr-FR', { style: 'currency', currency: 'EUR' }).format(value);
};

const formatDate = (dateString) => {
  const date = new Date(dateString);
  return new Intl.DateTimeFormat('fr-FR', { day: 'numeric', month: 'short', year: 'numeric' }).format(date);
};

const formatRole = (role) => {
  const roles = {
    'admin': 'Administrateur',
    'enterprise_admin': 'Admin Entreprise',
    'client': 'Client'
  };
  return roles[role] || role;
};

const calculatePercentage = (part, total) => {
  if (!total || total === 0) return 0;
  return Math.round((part / total) * 100 * 10) / 10; // Round to 1 decimal place
};

const formatMonthYear = (dateString) => {
  const [year, month] = dateString.split('-');
  const date = new Date(parseInt(year), parseInt(month) - 1, 1);
  return new Intl.DateTimeFormat('fr-FR', { month: 'short', year: 'numeric' }).format(date);
};

// Data methods
const fetchStatistics = async () => {
  try {
    loading.value = true;
    error.value = null;
    
    // Get auth token
    const token = localStorage.getItem('auth_token') || sessionStorage.getItem('auth_token');
    const headers = { 'Authorization': `Bearer ${token}` };
    
    // Fetch both user and document statistics in parallel
    const [userStatsResponse, documentStatsResponse] = await Promise.all([
      // User statistics
      axios.get(`http://localhost:5000/api/admin-statistics/users?period=${periodFilter.value}`, { headers }),
      // Document statistics
      axios.get(`http://localhost:5000/api/document-statistics?period=${periodFilter.value}`, { headers })
    ]);
    
    // Process user statistics
    if (userStatsResponse.data.success) {
      const userData = userStatsResponse.data.data;
      
      console.log('Full API response data:', userStatsResponse.data.data);
      console.log('Template stats:', userData.totalPredefinedTemplates, userData.totalTemplates);
      console.log('Deactivated users:', userData.deactivatedUsers);
      
      // Update all statistics at once
      statistics.value = {
        ...statistics.value,
        // User stats
        totalUsers: userData.totalUsers || 0,
        newUsers: userData.newUsers || 0,
        userGrowth: userData.userGrowth || 0,
        deactivatedUsers: userData.deactivatedUsers || 0,
        usersByRole: userData.usersByRole || { admin: 0, enterprise_admin: 0, client: 0 },
        recentUsers: userData.recentUsers || [],
        // Template stats
        totalPredefinedTemplates: userData.totalPredefinedTemplates || 0,
        totalTemplates: userData.totalTemplates || 0
      };
      
      // Log stats after updating
      console.log('Frontend statistics after update:', {
        deactivatedUsers: statistics.value.deactivatedUsers,
        totalPredefinedTemplates: statistics.value.totalPredefinedTemplates
      });
      
      // Convert registration trends data to the format needed for charts
      if (userData.registrationTrends) {
        const registrationByMonth = {};
        userData.registrationTrends.forEach(trend => {
          registrationByMonth[trend.month] = trend.count;
        });
        statistics.value.userRegistrationByMonth = registrationByMonth;
      }
    }
    
    // Process document statistics
    if (documentStatsResponse.data.success) {
      const docData = documentStatsResponse.data.data;
      
      // Update document-related statistics
      statistics.value = {
        ...statistics.value,
        totalInvoices: docData.totalInvoices || 0,
        totalQuotations: docData.totalQuotations || 0,
        invoiceGrowth: docData.invoiceGrowth || 0,
        quotationGrowth: docData.quotationGrowth || 0,
        totalRevenue: docData.totalRevenue || 0,
        revenueGrowth: docData.revenueGrowth || 0,
        documentsByMonth: docData.documentsByMonth || {},
        revenueByMonth: docData.revenueByMonth || {},
        amounts: docData.amounts || {
          totalHT: 0,
          totalRemise: 0,
          totalNetHT: 0,
          totalTVA: 0,
          totalTTC: 0
        }
      };
    }
    
    // Update all charts with the new data
    renderCharts();
  } catch (err) {
    console.error('Error fetching statistics:', err);
    error.value = 'Erreur lors du chargement des statistiques. Veuillez réessayer.';
  } finally {
    loading.value = false;
  }
};

const updateStatistics = () => {
  fetchStatistics();
};

const exportStatistics = () => {
  // In a real application, this would generate a PDF or CSV export
  const periodNames = {
    'day': "aujourd'hui",
    'week': 'cette semaine',
    'month': 'ce mois',
    'year': 'cette année',
    'all': 'toutes les données'
  };
  
  alert(`Exportation des statistiques pour ${periodNames[periodFilter.value]} en cours...`);
};

// Chart rendering functions
const renderCharts = () => {
  renderRoleDistributionChart();
  renderUserRegistrationTrendsChart();
  renderDocumentTrendsChart();
};

const renderRoleDistributionChart = () => {
  if (roleChart) {
    roleChart.destroy();
  }
  
  const ctx = roleDistributionChart.value.getContext('2d');
  const data = {
    labels: Object.keys(statistics.value.usersByRole).map(role => formatRole(role)),
    datasets: [{
      data: Object.values(statistics.value.usersByRole),
      backgroundColor: ['#4facfe', '#6a75ca', '#00c49f'],
      borderColor: '#ffffff',
      borderWidth: 2,
      hoverOffset: 15
    }]
  };
  
  roleChart = new Chart(ctx, {
    type: 'pie',
    data: data,
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: {
          position: 'right',
          labels: {
            color: '#495057',
            font: {
              size: 13
            }
          }
        }
      }
    }
  });
};

const renderUserRegistrationTrendsChart = () => {
  if (userTrendsChart) {
    userTrendsChart.destroy();
  }
  
  const ctx = userRegistrationTrendsChart.value.getContext('2d');
  const monthLabels = Object.keys(statistics.value.userRegistrationByMonth).map(dateStr => formatMonthYear(dateStr));
  const userData = Object.values(statistics.value.userRegistrationByMonth);
  
  userTrendsChart = new Chart(ctx, {
    type: 'line',
    data: {
      labels: monthLabels.reverse(),
      datasets: [{
        label: 'Nouveaux utilisateurs',
        data: userData.reverse(),
        backgroundColor: 'rgba(79, 172, 254, 0.2)',
        borderColor: '#4facfe',
        borderWidth: 2,
        tension: 0.4,
        fill: true,
        pointRadius: 4,
        pointHoverRadius: 6
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      scales: {
        y: {
          beginAtZero: true,
          grid: {
            color: 'rgba(200, 200, 200, 0.2)'
          },
          ticks: {
            precision: 0
          }
        },
        x: {
          grid: {
            display: false
          }
        }
      },
      plugins: {
        legend: {
          display: true,
          position: 'top'
        },
        tooltip: {
          mode: 'index',
          intersect: false
        }
      }
    }
  });
};

const renderDocumentTrendsChart = () => {
  if (docTrendsChart) {
    docTrendsChart.destroy();
  }
  
  const ctx = documentTrendsChart.value.getContext('2d');
  const sortedMonths = Object.keys(statistics.value.documentsByMonth).sort().reverse();
  const formattedMonths = sortedMonths.map(dateStr => formatMonthYear(dateStr));
  
  const invoiceData = sortedMonths.map(month => statistics.value.documentsByMonth[month].factures);
  const quotationData = sortedMonths.map(month => statistics.value.documentsByMonth[month].devis);
  
  docTrendsChart = new Chart(ctx, {
    type: 'bar',
    data: {
      labels: formattedMonths,
      datasets: [
        {
          label: 'Factures',
          data: invoiceData,
          backgroundColor: 'rgba(79, 172, 254, 0.7)',
          borderColor: '#4facfe',
          borderWidth: 1
        },
        {
          label: 'Devis',
          data: quotationData,
          backgroundColor: 'rgba(106, 117, 202, 0.7)',
          borderColor: '#6a75ca',
          borderWidth: 1
        }
      ]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      scales: {
        y: {
          beginAtZero: true,
          grid: {
            color: 'rgba(200, 200, 200, 0.2)'
          },
          ticks: {
            precision: 0
          }
        },
        x: {
          grid: {
            display: false
          }
        }
      },
      plugins: {
        legend: {
          display: true,
          position: 'top'
        },
        tooltip: {
          mode: 'index',
          intersect: false
        }
      }
    }
  });
};

const renderRevenueChart = () => {
  if (revChart) {
    revChart.destroy();
  }
  
  const ctx = revenueChart.value.getContext('2d');
  const sortedMonths = Object.keys(statistics.value.revenueByMonth).sort().reverse();
  const formattedMonths = sortedMonths.map(dateStr => formatMonthYear(dateStr));
  const revenueData = sortedMonths.map(month => statistics.value.revenueByMonth[month]);
  
  revChart = new Chart(ctx, {
    type: 'bar',
    data: {
      labels: formattedMonths,
      datasets: [{
        label: 'Chiffre d\'affaires',
        data: revenueData,
        backgroundColor: 'rgba(0, 196, 159, 0.7)',
        borderColor: '#00c49f',
        borderWidth: 1
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      scales: {
        y: {
          beginAtZero: true,
          grid: {
            color: 'rgba(200, 200, 200, 0.2)'
          },
          ticks: {
            callback: function(value) {
              return value.toLocaleString('fr-FR', {style: 'currency', currency: 'EUR', minimumFractionDigits: 0, maximumFractionDigits: 0});
            }
          }
        },
        x: {
          grid: {
            display: false
          }
        }
      },
      plugins: {
        legend: {
          display: true,
          position: 'top'
        },
        tooltip: {
          mode: 'index',
          intersect: false,
          callbacks: {
            label: function(context) {
              let label = context.dataset.label || '';
              if (label) {
                label += ': ';
              }
              label += new Intl.NumberFormat('fr-FR', { style: 'currency', currency: 'EUR' }).format(context.parsed.y);
              return label;
            }
          }
        }
      }
    }
  });
};

// Lifecycle hooks
onMounted(() => {
  // Add Chart.js script dynamically if not already loaded
  if (!window.Chart) {
    const script = document.createElement('script');
    script.src = 'https://cdn.jsdelivr.net/npm/chart.js';
    script.onload = () => {
      fetchStatistics();
    };
    document.head.appendChild(script);
  } else {
    fetchStatistics();
  }
});
</script>

<style scoped>
/* Section header and general layout */
.tab-content {
  padding: 15px 5px;
}

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

.period-filter {
  display: flex;
  gap: 15px;
  align-items: center;
}

.filter-select {
  padding: 8px 12px;
  border: 2px solid #e1e1e1;
  border-radius: 6px;
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

.export-btn {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 15px;
  background-color: #002446;
  color: white;
  border: none;
  border-radius: 6px;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s;
}

.export-btn:hover {
  background-color: #003a6c;
}

/* Section Title */
.section-title {
  font-size: 18px;
  font-weight: 600;
  color: #002446;
  margin: 40px 0 20px 0;
  padding-bottom: 10px;
  border-bottom: 2px solid rgba(0, 36, 70, 0.1);
}

/* Stats Sections */
.stats-section {
  margin-bottom: 40px;
  animation: fadeInUp 0.6s ease forwards;
}

/* Stats Cards */
.stats-cards {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
  gap: 20px;
  margin-bottom: 20px;
}

.stat-card {
  background-color: white;
  border-radius: 12px;
  padding: 20px;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
  display: flex;
  align-items: center;
  gap: 15px;
  animation: fadeIn 0.5s ease forwards;
  animation-delay: calc(var(--i) * 0.1s);
  opacity: 0;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.stat-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
}

.stat-icon {
  width: 48px;
  height: 48px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
}

.stat-icon.users {
  background-color: #4facfe;
}

.stat-icon.new-users {
  background-color: #6a75ca;
}

.stat-icon.invoices {
  background-color: #7367f0;
}

.stat-icon.quotations {
  background-color: #ff8f00;
}

.stat-icon.inactive-users {
  background-color: #e57373;
}

.stat-icon.templates {
  background-color: #9575cd;
}

.stat-icon.revenue {
  background-color: #00c49f;
}

.stat-info {
  flex-grow: 1;
}

.stat-info h3 {
  margin: 0 0 5px 0;
  color: #495057;
  font-size: 15px;
  font-weight: 600;
}

.stat-value {
  margin: 0;
  color: #002446;
  font-size: 24px;
  font-weight: 700;
}

.stat-change {
  margin: 5px 0 0 0;
  font-size: 12px;
}

.stat-details {
  margin: 5px 0 0 0;
  font-size: 12px;
  color: #6c757d;
}

.stat-change.positive {
  color: #00c49f;
}

.stat-change.negative {
  color: #ff5252;
}

/* Detailed Stats Cards */
.detail-stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(450px, 1fr));
  gap: 20px;
}

.detail-stat-card {
  background: white;
  border-radius: 12px;
  padding: 20px;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
  animation: fadeIn 0.5s ease forwards;
  height: 100%;
  min-height: 350px;
}

.detail-stat-card h4 {
  margin: 0 0 20px 0;
  color: #002446;
  font-size: 16px;
  font-weight: 600;
  text-align: center;
}

/* Role Distribution */
.role-distribution {
  margin-bottom: 20px;
}

.role-item {
  display: flex;
  align-items: center;
  margin-bottom: 10px;
  padding: 8px;
  border-radius: 8px;
  transition: background-color 0.2s ease;
}

.role-item:hover {
  background-color: rgba(0, 0, 0, 0.03);
}

.role-color {
  width: 12px;
  height: 12px;
  border-radius: 50%;
  margin-right: 10px;
}

.role-name {
  flex-grow: 1;
  font-size: 14px;
}

.role-count {
  font-weight: 600;
  color: #002446;
}

.pie-chart-container {
  height: 230px;
  position: relative;
}

/* Inactive Account Statistics */
.inactive-stats {
  margin-top: 20px;
  padding: 15px;
  border-radius: 8px;
  background-color: rgba(229, 115, 115, 0.05);
  border-left: 3px solid #e57373;
}

.inactive-stat-item {
  display: flex;
  justify-content: space-between;
  margin-bottom: 10px;
}

.inactive-stat-item:last-child {
  margin-bottom: 0;
}

.inactive-label {
  font-weight: 500;
  color: #555;
}

.inactive-value {
  font-weight: 600;
  color: #e57373;
}

.role-item.inactive:hover {
  background-color: rgba(229, 115, 115, 0.1);
}

/* Recent Users List */
.recent-users {
  overflow-y: auto;
  height: calc(100% - 50px);
  padding-right: 5px;
}

.recent-users::-webkit-scrollbar {
  width: 5px;
}

.recent-users::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 5px;
}

.recent-users::-webkit-scrollbar-thumb {
  background: #ccc;
  border-radius: 5px;
}

.recent-user-item {
  display: flex;
  align-items: center;
  padding: 10px;
  border-radius: 8px;
  margin-bottom: 10px;
  transition: background-color 0.2s ease;
}

.recent-user-item:hover {
  background-color: rgba(0, 0, 0, 0.03);
}

.user-avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  margin-right: 12px;
  overflow: hidden;
  background-color: #4facfe;
  display: flex;
  align-items: center;
  justify-content: center;
}

.avatar-letter {
  color: white;
  font-weight: 600;
  font-size: 16px;
}

.user-info {
  flex-grow: 1;
}

.user-name {
  font-weight: 600;
  margin-bottom: 4px;
  color: #333;
}

.user-role {
  font-size: 12px;
  color: #6c757d;
}

.user-date {
  font-size: 12px;
  color: #6c757d;
}

/* Document Trends Chart */
.document-trends {
  height: auto;
}

.chart-container {
  height: 280px;
  position: relative;
}

.full-width-chart-container {
  height: 300px;
  position: relative;
  margin-top: 20px;
  background: white;
  border-radius: 12px;
  padding: 20px;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
}

/* Amount Statistics */
.amount-stats {
  display: flex;
  flex-direction: column;
  gap: 15px;
  margin-top: 30px;
}

.amount-stat-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 15px;
  background-color: rgba(0, 0, 0, 0.02);
  border-radius: 8px;
  transition: all 0.2s ease;
}

.amount-stat-item:hover {
  background-color: rgba(0, 0, 0, 0.04);
}

.amount-stat-item.highlight {
  background-color: rgba(0, 196, 159, 0.1);
  border-left: 4px solid #00c49f;
}

.amount-label {
  font-weight: 500;
  color: #495057;
}

.amount-value {
  font-weight: 600;
  color: #002446;
}

/* Animations */
@keyframes fadeIn {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}

@keyframes fadeInUp {
  from { opacity: 0; transform: translateY(20px); }
  to { opacity: 1; transform: translateY(0); }
}

@keyframes barGrow {
  from { opacity: 0; transform: scaleY(0); }
  to { opacity: 1; transform: scaleY(1); }
}

/* Responsive adjustments */
@media (max-width: 900px) {
  .detail-stats-grid {
    grid-template-columns: 1fr;
  }
  
  .detail-stat-card {
    min-height: auto;
  }
}

@media (max-width: 700px) {
  .stats-cards {
    grid-template-columns: 1fr;
  }
  
  .section-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 15px;
  }
  
  .period-filter {
    width: 100%;
    justify-content: space-between;
  }
}

@media (max-width: 768px) {
  .stats-cards {
    grid-template-columns: 1fr;
  }
}
</style>
