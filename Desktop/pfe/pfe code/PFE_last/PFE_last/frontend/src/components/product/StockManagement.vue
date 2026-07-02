<template>
  <div class="stock-management">
    <div class="stock-header">
      <p class="subtitle">Suivez et gérez les niveaux de stock de vos produits</p>
    </div>

    <!-- Filtres et recherche -->
    <div class="stock-filters">
      <div class="search-box">
        <i class="fas fa-search"></i>
        <input 
          type="text" 
          v-model="searchQuery" 
          placeholder="Rechercher un produit..."
          @input="applyFilters"
        />
        <button v-if="searchQuery" class="clear-search" @click="clearSearch">
          <i class="fas fa-times"></i>
        </button>
      </div>

      <div class="filter-section">
        <div class="filter-group">
          <label>Catégorie</label>
          <select v-model="filters.category_id" @change="applyFilters">
            <option value="">Toutes les catégories</option>
            <option v-for="category in categories" :key="category.id" :value="category.id">
              {{ category.name }}
            </option>
          </select>
        </div>
        
        <div class="filter-group">
          <label>État du stock</label>
          <select v-model="filters.stock_status" @change="applyFilters">
            <option value="">Tous les états</option>
            <option value="out">Rupture de stock</option>
            <option value="low">Stock faible</option>
            <option value="normal">Stock normal</option>
          </select>
        </div>
      </div>
    </div>

    <!-- Tableau des stocks -->
    <div class="stock-table-container">
      <div v-if="loading" class="loading-indicator">
        <i class="fas fa-spinner fa-spin"></i> Chargement des produits...
      </div>
      
      <div v-else-if="products.length === 0" class="empty-state">
        <i class="fas fa-box-open"></i>
        <p>Aucun produit trouvé</p>
      </div>
      
      <table v-else class="stock-table">
        <thead>
          <tr>
            <th @click="sortBy('name')">Produit
              <i class="fas" :class="getSortIconClass('name')"></i>
            </th>
            <th @click="sortBy('category_name')">Catégorie
              <i class="fas" :class="getSortIconClass('category_name')"></i>
            </th>
            <th @click="sortBy('stock_quantity')">Quantité en stock
              <i class="fas" :class="getSortIconClass('stock_quantity')"></i>
            </th>
            <th>Statut</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="product in products" :key="product.id">
            <td>{{ product.name }}</td>
            <td>
              {{ product.category_name || 'Non catégorisé' }}
              <span v-if="product.subcategory_name"> > {{ product.subcategory_name }}</span>
            </td>
            <td>
              <span :class="getStockClass(product.stock_quantity)">
                {{ product.stock_quantity }} {{ product.unit || 'unité(s)' }}
              </span>
            </td>
            <td>
              <span class="stock-status" :class="getStockStatusClass(product.stock_quantity)">
                {{ getStockStatusText(product.stock_quantity) }}
              </span>
            </td>
            <td>
              <div class="stock-actions">
                <button class="btn btn-sm btn-primary" @click="showAdjustStockModal(product)">
                  <i class="fas fa-edit"></i> Ajuster
                </button>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Modal d'ajustement de stock -->
    <div v-if="showAdjustModal" class="modal-overlay" @click.self="closeAdjustModal">
      <div class="modal-content adjust-stock-modal">
        <div class="modal-header">
          <h3>Ajuster le stock</h3>
          <button class="close-btn" @click="closeAdjustModal">
            <i class="fas fa-times"></i>
          </button>
        </div>
        
        <div class="modal-body">
          <div v-if="selectedProduct" class="product-info">
            <h4>{{ selectedProduct.name }}</h4>
            <p>Stock actuel: <span :class="getStockClass(selectedProduct.stock_quantity)">{{ selectedProduct.stock_quantity }} {{ selectedProduct.unit || 'unité(s)' }}</span></p>
          </div>
          
          <div class="form-group">
            <label>Type d'ajustement</label>
            <div class="adjustment-type">
              <button 
                :class="['adjustment-btn', adjustmentType === 'add' ? 'active' : '']"
                @click="adjustmentType = 'add'"
              >
                <i class="fas fa-plus-circle"></i> Ajouter
              </button>
              <button 
                :class="['adjustment-btn', adjustmentType === 'remove' ? 'active' : '']"
                @click="adjustmentType = 'remove'"
              >
                <i class="fas fa-minus-circle"></i> Retirer
              </button>
            </div>
          </div>
          
          <div class="form-group">
            <label for="adjustmentQuantity">Quantité à {{ adjustmentType === 'add' ? 'ajouter' : 'retirer' }}</label>
            <input 
              type="number" 
              id="adjustmentQuantity" 
              v-model.number="adjustmentQuantity" 
              min="1"
              step="1"
            />
          </div>
          
          <div class="form-group">
            <label for="adjustmentReason">Raison de l'ajustement</label>
            <select id="adjustmentReason" v-model="adjustmentReason" class="form-control">
              <option value="">Sélectionnez une raison</option>
              <option v-if="adjustmentType === 'add'" value="purchase">Achat/Réapprovisionnement</option>
              <option v-if="adjustmentType === 'add'" value="return">Retour client</option>
              <option v-if="adjustmentType === 'add'" value="inventory">Correction d'inventaire</option>
              <option v-if="adjustmentType === 'remove'" value="sale">Vente</option>
              <option v-if="adjustmentType === 'remove'" value="damage">Produit endommagé</option>
              <option v-if="adjustmentType === 'remove'" value="loss">Perte/Vol</option>
              <option v-if="adjustmentType === 'remove'" value="expiry">Expiration</option>
              <option value="other">Autre</option>
            </select>
          </div>
          
          <div v-if="adjustmentReason === 'other'" class="form-group">
            <label for="adjustmentNote">Note</label>
            <textarea id="adjustmentNote" v-model="adjustmentNote" rows="2" class="form-control"></textarea>
          </div>
        </div>
        
        <div class="modal-footer">
          <button class="btn btn-secondary" @click="closeAdjustModal">
            Annuler
          </button>
          <button class="btn btn-primary" @click="saveStockAdjustment" :disabled="!canSaveAdjustment || adjustmentSubmitting">
            <span v-if="adjustmentSubmitting">
              <i class="fas fa-spinner fa-spin"></i> Enregistrement...
            </span>
            <span v-else>
              <i class="fas fa-save"></i> Enregistrer
            </span>
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue';
import api from '@/services/api';

// State
const products = ref([]);
const categories = ref([]);
const loading = ref(true);
const searchQuery = ref('');

// Filtres
const filters = ref({
  category_id: '',
  stock_status: ''
});

// Tri
const sortConfig = ref({
  key: 'name',
  direction: 'asc'
});

// Modal d'ajustement de stock
const showAdjustModal = ref(false);
const selectedProduct = ref(null);
const adjustmentType = ref('add');
const adjustmentQuantity = ref(1);
const adjustmentReason = ref('');
const adjustmentNote = ref('');
const adjustmentSubmitting = ref(false);

// Computed properties
const canSaveAdjustment = computed(() => {
  return (
    selectedProduct.value &&
    adjustmentQuantity.value > 0 &&
    adjustmentReason.value &&
    (adjustmentReason.value !== 'other' || adjustmentNote.value.trim() !== '')
  );
});

// Methods
const fetchProducts = async () => {
  loading.value = true;
  try {
    const response = await api.get('/api/products', {
      params: {
        ...filters.value,
        search: searchQuery.value,
        sort_by: sortConfig.value.key,
        sort_direction: sortConfig.value.direction
      }
    });
    products.value = response.data.data;
  } catch (error) {
    console.error('Error fetching products:', error);
  } finally {
    loading.value = false;
  }
};

const fetchCategories = async () => {
  try {
    const response = await api.get('/api/categories');
    categories.value = response.data.data;
  } catch (error) {
    console.error('Error fetching categories:', error);
  }
};

const applyFilters = () => {
  fetchProducts();
};

const clearSearch = () => {
  searchQuery.value = '';
  applyFilters();
};

const sortBy = (key) => {
  if (sortConfig.value.key === key) {
    // Toggle direction if same key
    sortConfig.value.direction = sortConfig.value.direction === 'asc' ? 'desc' : 'asc';
  } else {
    // Set new key and default to ascending
    sortConfig.value.key = key;
    sortConfig.value.direction = 'asc';
  }
  applyFilters();
};

const getSortIconClass = (key) => {
  if (sortConfig.value.key !== key) return 'fa-sort';
  return sortConfig.value.direction === 'asc' ? 'fa-sort-up' : 'fa-sort-down';
};

const getStockClass = (quantity) => {
  if (quantity <= 0) return 'out-of-stock';
  if (quantity < 10) return 'low-stock';
  return 'in-stock';
};

const getStockStatusClass = (quantity) => {
  if (quantity <= 0) return 'status-danger';
  if (quantity < 10) return 'status-warning';
  return 'status-success';
};

const getStockStatusText = (quantity) => {
  if (quantity <= 0) return 'Rupture de stock';
  if (quantity < 10) return 'Stock faible';
  return 'En stock';
};

const showAdjustStockModal = (product) => {
  selectedProduct.value = product;
  adjustmentType.value = 'add';
  adjustmentQuantity.value = 1;
  adjustmentReason.value = '';
  adjustmentNote.value = '';
  showAdjustModal.value = true;
};

const closeAdjustModal = () => {
  showAdjustModal.value = false;
  selectedProduct.value = null;
};

const saveStockAdjustment = async () => {
  if (!canSaveAdjustment.value) return;
  
  adjustmentSubmitting.value = true;
  try {
    const finalQuantity = adjustmentType.value === 'add' 
      ? adjustmentQuantity.value 
      : -adjustmentQuantity.value;
    
    // Afficher les données envoyées pour le débogage
    console.log('Envoi des données:', {
      quantity: finalQuantity,
      reason: adjustmentReason.value,
      note: adjustmentReason.value === 'other' ? adjustmentNote.value : ''
    });
    
    await api.post(`/api/products/${selectedProduct.value.id}/stock-adjustment`, {
      quantity: finalQuantity,
      reason: adjustmentReason.value,
      note: adjustmentReason.value === 'other' ? adjustmentNote.value : ''
    });
    
    // Refresh product list
    await fetchProducts();
    closeAdjustModal();
    
    // Afficher un message de succès
    alert('Stock ajusté avec succès');
  } catch (error) {
    console.error('Error adjusting stock:', error);
    // Afficher un message d'erreur
    alert('Erreur lors de l\'ajustement du stock: ' + (error.response?.data?.message || error.message));
  } finally {
    adjustmentSubmitting.value = false;
  }
};

// Watch for changes in search query with debounce
let searchTimeout;
watch(searchQuery, () => {
  clearTimeout(searchTimeout);
  searchTimeout = setTimeout(() => {
    applyFilters();
  }, 300);
});

// Initialize component
onMounted(async () => {
  await Promise.all([
    fetchCategories(),
    fetchProducts()
  ]);
});
</script>

<style scoped>
.stock-management {
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.stock-header {
  margin-bottom: 20px;
}

.animated-title {
  font-size: 1.8rem;
  color: #2c3e50;
  position: relative;
  margin: 0;
  padding-bottom: 8px;
}

.animated-title::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 0;
  width: 60px;
  height: 3px;
  background: linear-gradient(90deg, #3498db, #2980b9);
  border-radius: 3px;
}

.subtitle {
  color: #7f8c8d;
  margin-top: 5px;
}

.stock-filters {
  display: flex;
  flex-wrap: wrap;
  gap: 15px;
  margin-bottom: 20px;
  align-items: center;
}

.search-box {
  position: relative;
  flex: 1;
  min-width: 250px;
}

.search-box input {
  width: 100%;
  padding: 10px 15px 10px 40px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
}

.search-box i {
  position: absolute;
  left: 15px;
  top: 50%;
  transform: translateY(-50%);
  color: #7f8c8d;
}

.clear-search {
  position: absolute;
  right: 10px;
  top: 50%;
  transform: translateY(-50%);
  background: none;
  border: none;
  color: #7f8c8d;
  cursor: pointer;
}

.filter-section {
  display: flex;
  gap: 15px;
  flex-wrap: wrap;
}

.filter-group {
  display: flex;
  flex-direction: column;
  gap: 5px;
}

.filter-group label {
  font-size: 12px;
  color: #7f8c8d;
}

.filter-group select {
  padding: 8px 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  min-width: 180px;
}

.stock-table-container {
  flex: 1;
  overflow: auto;
  background: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
}

.stock-table {
  width: 100%;
  border-collapse: collapse;
}

.stock-table th {
  background: #f8f9fa;
  padding: 12px 15px;
  text-align: left;
  font-weight: 600;
  color: #2c3e50;
  border-bottom: 2px solid #e9ecef;
  cursor: pointer;
  user-select: none;
}

.stock-table th:hover {
  background: #edf2f7;
}

.stock-table td {
  padding: 12px 15px;
  border-bottom: 1px solid #e9ecef;
}

.stock-table tbody tr:hover {
  background-color: #f8f9fa;
}

.out-of-stock {
  color: #e74c3c;
  font-weight: 600;
}

.low-stock {
  color: #f39c12;
  font-weight: 600;
}

.in-stock {
  color: #27ae60;
}

.stock-status {
  display: inline-block;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
  font-weight: 600;
}

.status-danger {
  background-color: #ffebee;
  color: #e74c3c;
}

.status-warning {
  background-color: #fff8e1;
  color: #f39c12;
}

.status-success {
  background-color: #e8f5e9;
  color: #27ae60;
}

.stock-actions {
  display: flex;
  gap: 8px;
}

.btn-sm {
  padding: 5px 10px;
  font-size: 12px;
}

.loading-indicator {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 200px;
  color: #7f8c8d;
}

.empty-state {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  height: 200px;
  color: #7f8c8d;
}

.empty-state i {
  font-size: 48px;
  margin-bottom: 15px;
  color: #bdc3c7;
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

.modal-content {
  background: white;
  border-radius: 8px;
  width: 100%;
  max-width: 500px;
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
  overflow: hidden;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px 20px;
  border-bottom: 1px solid #e9ecef;
}

.modal-header h3 {
  margin: 0;
  color: #2c3e50;
}

.close-btn {
  background: none;
  border: none;
  font-size: 18px;
  cursor: pointer;
  color: #7f8c8d;
}

.modal-body {
  padding: 20px;
}

.modal-footer {
  padding: 15px 20px;
  border-top: 1px solid #e9ecef;
  display: flex;
  justify-content: flex-end;
  gap: 10px;
}

.product-info {
  margin-bottom: 20px;
  padding-bottom: 15px;
  border-bottom: 1px solid #e9ecef;
}

.product-info h4 {
  margin: 0 0 10px 0;
  color: #2c3e50;
}

.adjustment-type {
  display: flex;
  gap: 10px;
  margin-top: 5px;
}

.adjustment-btn {
  flex: 1;
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 4px;
  background: #f8f9fa;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
}

.adjustment-btn.active {
  background: #e8f5e9;
  border-color: #27ae60;
  color: #27ae60;
}

.adjustment-btn:hover {
  background: #edf2f7;
}

.form-group {
  margin-bottom: 15px;
}

.form-group label {
  display: block;
  margin-bottom: 5px;
  color: #2c3e50;
  font-weight: 500;
}

.form-group input,
.form-group select,
.form-group textarea {
  width: 100%;
  padding: 8px 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
}

.form-control {
  padding: 8px 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
}

.btn {
  padding: 8px 16px;
  border-radius: 4px;
  font-weight: 500;
  cursor: pointer;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  transition: all 0.2s;
}

.btn-primary {
  background: #3498db;
  color: white;
  border: none;
}

.btn-primary:hover {
  background: #2980b9;
}

.btn-primary:disabled {
  background: #95a5a6;
  cursor: not-allowed;
}

.btn-secondary {
  background: #ecf0f1;
  color: #2c3e50;
  border: 1px solid #ddd;
}

.btn-secondary:hover {
  background: #dfe6e9;
}
</style>