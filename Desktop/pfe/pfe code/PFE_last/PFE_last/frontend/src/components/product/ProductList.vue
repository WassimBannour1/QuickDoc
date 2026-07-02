<template>
  <div class="product-list-container">
    <router-view />
    <!-- Header section with search and filters -->
    <div class="list-header">
      <div class="search-filter-container">
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
          <button class="filter-toggle" @click="showFilters = !showFilters">
            <i class="fas fa-filter"></i>
            Filtres
            <i :class="showFilters ? 'fas fa-chevron-up' : 'fas fa-chevron-down'"></i>
          </button>
          
          <div class="sort-dropdown">
            <button class="sort-toggle">
              <i class="fas fa-sort"></i>
              Trier par
              <i class="fas fa-chevron-down"></i>
            </button>
            <div class="sort-menu">
              <div class="sort-option" @click="sortBy('name', 'asc')">Nom (A-Z)</div>
              <div class="sort-option" @click="sortBy('name', 'desc')">Nom (Z-A)</div>
              <div class="sort-option" @click="sortBy('unit_price', 'asc')">Prix (croissant)</div>
              <div class="sort-option" @click="sortBy('unit_price', 'desc')">Prix (décroissant)</div>
              <div class="sort-option" @click="sortBy('stock_quantity', 'asc')">Stock (croissant)</div>
              <div class="sort-option" @click="sortBy('stock_quantity', 'desc')">Stock (décroissant)</div>
            </div>
          </div>
        </div>
      </div>
      
      
    </div>
    
    <!-- Advanced filters panel -->
    <div class="advanced-filters" v-if="showFilters">
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
        <label>Sous-catégorie</label>
        <select v-model="filters.subcategory_id" @change="applyFilters">
          <option value="">Toutes les sous-catégories</option>
          <option v-for="subcategory in filteredSubcategories" :key="subcategory.id" :value="subcategory.id">
            {{ subcategory.name }}
          </option>
        </select>
      </div>
      
      <div class="filter-group">
        <label>Prix</label>
        <div class="range-inputs">
          <input 
            type="number" 
            v-model.number="filters.price_min" 
            placeholder="Min" 
            @change="applyFilters"
          />
          <span>à</span>
          <input 
            type="number" 
            v-model.number="filters.price_max" 
            placeholder="Max" 
            @change="applyFilters"
          />
        </div>
      </div>
      
      <div class="filter-group">
        <label>Stock</label>
        <div class="range-inputs">
          <input 
            type="number" 
            v-model.number="filters.stock_min" 
            placeholder="Min" 
            @change="applyFilters"
          />
          <span>à</span>
          <input 
            type="number" 
            v-model.number="filters.stock_max" 
            placeholder="Max" 
            @change="applyFilters"
          />
        </div>
      </div>
      
      <button class="btn btn-secondary" @click="resetFilters">
        <i class="fas fa-undo"></i> Réinitialiser
      </button>
    </div>
    
    <!-- Products list -->
    <div class="products-container">
      <div v-if="loading" class="loading-indicator">
        <i class="fas fa-spinner fa-spin"></i> Chargement des produits...
      </div>
      
      <div v-else-if="products.length === 0" class="empty-state">
        <i class="fas fa-box-open"></i>
        <p>Aucun produit trouvé</p>
        <router-link to="/admin-entreprise/product-create" class="btn btn-primary">
          Créer votre premier produit
        </router-link>
      </div>
      
      <div v-else class="products-grid">
        <div 
          v-for="product in products" 
          :key="product.id" 
          class="product-card"
          :class="{ 'low-stock': product.stock_quantity < 10 }"
        >
          <div class="product-header">
            <h3 class="product-name">{{ product.name }}</h3>
            <div class="product-actions">
              <button class="action-btn" @click="editProduct(product)">
                <i class="fas fa-edit"></i>
              </button>
              <button class="action-btn" @click="showDeleteModal(product)">
                <i class="fas fa-trash"></i>
              </button>
            </div>
          </div>
          
          <div class="product-details">
            <div class="detail-row">
              <span class="detail-label">Prix:</span>
              <span class="detail-value price">{{ formatPrice(product.unit_price) }}</span>
            </div>
            
            <div class="detail-row">
              <span class="detail-label">Unité:</span>
              <span class="detail-value">{{ product.unit || 'N/A' }}</span>
            </div>
            
            <div class="detail-row">
              <span class="detail-label">Stock:</span>
              <span class="detail-value stock" :class="getStockClass(product.stock_quantity)">
                {{ product.stock_quantity }}
              </span>
            </div>
            
            <div class="detail-row" v-if="product.category_name || product.subcategory_name">
              <span class="detail-label">Catégorie:</span>
              <span class="detail-value category">
                {{ product.category_name || 'Non catégorisé' }}
                <span v-if="product.subcategory_name"> > {{ product.subcategory_name }}</span>
              </span>
            </div>
            
            <div class="detail-row description" v-if="product.description">
              <span class="detail-label">Description:</span>
              <span class="detail-value">{{ truncateDescription(product.description) }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Delete Confirmation Modal -->
    <div v-if="showDeleteConfirmation" class="modal-overlay" @click.self="closeDeleteModal">
      <div class="modal-content delete-modal">
        <div class="modal-header">
          <h3>Confirmation de suppression</h3>
          <button class="close-btn" @click="closeDeleteModal">
            <i class="fas fa-times"></i>
          </button>
        </div>
        
        <div class="modal-body">
          <div class="warning-icon">
            <i class="fas fa-exclamation-triangle"></i>
          </div>
          
          <p>
            Êtes-vous sûr de vouloir supprimer le produit <strong>{{ productToDelete?.name }}</strong> ?
          </p>
          
          <p class="warning-text">
            <i class="fas fa-info-circle"></i>
            Cette action est irréversible et supprimera définitivement ce produit.
          </p>
          
          <div class="form-actions">
            <button type="button" class="btn btn-secondary" @click="closeDeleteModal">Annuler</button>
            <button 
              type="button" 
              class="btn btn-danger" 
              :disabled="deleteSubmitting"
              @click="confirmDelete"
            >
              <span v-if="deleteSubmitting">
                <i class="fas fa-spinner fa-spin"></i> Suppression...
              </span>
              <span v-else>Supprimer</span>
            </button>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Success Modal for Delete -->    
    <div v-if="showSuccessModal" class="modal-overlay">
      <div class="success-modal">
        <div class="success-icon">
          <i class="fas fa-check-circle"></i>
        </div>
        <h2>Produit supprimé avec succès!</h2>
        <p>Le produit a été retiré de votre catalogue.</p>
        <div class="modal-actions">
          <button class="btn btn-primary" @click="closeSuccessModal">Fermer</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue';
import { useRouter } from 'vue-router';
import api from '@/services/api';

// Router
const router = useRouter();

// Props
const props = defineProps({
  managedByParent: {
    type: Boolean,
    default: false
  }
});

// Emits
const emit = defineEmits(['edit-product', 'create-product']);

// State
const loading = ref(true);
const products = ref([]);
const categories = ref([]);
const subcategories = ref([]);
const searchQuery = ref('');
const showFilters = ref(false);
const showDeleteConfirmation = ref(false);
const productToDelete = ref(null);
const deleteSubmitting = ref(false);
const showSuccessModal = ref(false);
const deletedProductName = ref('');

// Filters state
const filters = ref({
  category_id: '',
  subcategory_id: '',
  price_min: '',
  price_max: '',
  stock_min: '',
  stock_max: '',
  sort_by: 'name',
  sort_order: 'asc'
});

// Computed properties
const filteredSubcategories = computed(() => {
  if (!filters.value.category_id) return subcategories.value;
  return subcategories.value.filter(subcategory => subcategory.category_id === filters.value.category_id);
});

// Methods
const fetchProducts = async () => {
  loading.value = true;
  try {
    // Build query parameters
    const queryParams = new URLSearchParams();
    
    if (searchQuery.value) {
      queryParams.append('name', searchQuery.value);
    }
    
    if (filters.value.category_id) {
      queryParams.append('category_id', filters.value.category_id);
    }
    
    if (filters.value.subcategory_id) {
      queryParams.append('subcategory_id', filters.value.subcategory_id);
    }
    
    if (filters.value.price_min) {
      queryParams.append('price_min', filters.value.price_min);
    }
    
    if (filters.value.price_max) {
      queryParams.append('price_max', filters.value.price_max);
    }
    
    if (filters.value.stock_min) {
      queryParams.append('stock_min', filters.value.stock_min);
    }
    
    if (filters.value.stock_max) {
      queryParams.append('stock_max', filters.value.stock_max);
    }
    
    if (filters.value.sort_by) {
      queryParams.append('sort_by', filters.value.sort_by);
    }
    
    if (filters.value.sort_order) {
      queryParams.append('sort_order', filters.value.sort_order);
    }
    
    const url = `/api/products${queryParams.toString() ? `?${queryParams.toString()}` : ''}`;
    const response = await api.get(url);
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

const fetchSubcategories = async () => {
  try {
    const response = await api.get('/api/subcategories');
    subcategories.value = response.data.data;
  } catch (error) {
    console.error('Error fetching subcategories:', error);
  }
};

const applyFilters = () => {
  fetchProducts();
};

const resetFilters = () => {
  searchQuery.value = '';
  filters.value = {
    category_id: '',
    subcategory_id: '',
    price_min: '',
    price_max: '',
    stock_min: '',
    stock_max: '',
    sort_by: 'name',
    sort_order: 'asc'
  };
  fetchProducts();
};

const clearSearch = () => {
  searchQuery.value = '';
  applyFilters();
};

const sortBy = (field, order) => {
  filters.value.sort_by = field;
  filters.value.sort_order = order;
  applyFilters();
};

const editProduct = (product) => {
  router.push(`/admin-entreprise/edit-product/${product.id}`);
};

const showDeleteModal = (product) => {
  productToDelete.value = product;
  showDeleteConfirmation.value = true;
};

const closeDeleteModal = () => {
  showDeleteConfirmation.value = false;
  productToDelete.value = null;
};

const confirmDelete = async () => {
  if (!productToDelete.value) return;
  
  deleteSubmitting.value = true;
  try {
    // Save product name before deletion for success message
    deletedProductName.value = productToDelete.value.name;
    
    await api.delete(`/api/products/${productToDelete.value.id}`);
    await fetchProducts();
    
    // Close delete confirmation modal
    closeDeleteModal();
    
    // Show success modal
    showSuccessModal.value = true;
  } catch (error) {
    console.error('Error deleting product:', error);
  } finally {
    deleteSubmitting.value = false;
  }
};

const closeSuccessModal = () => {
  showSuccessModal.value = false;
};

// Utility functions
const formatPrice = (price) => {
  return new Intl.NumberFormat('fr-FR', { style: 'currency', currency: 'EUR' }).format(price);
};

const truncateDescription = (description, maxLength = 100) => {
  if (!description) return '';
  if (description.length <= maxLength) return description;
  return `${description.substring(0, maxLength)}...`;
};

const getStockClass = (quantity) => {
  if (quantity <= 0) return 'out-of-stock';
  if (quantity < 10) return 'low-stock';
  return 'in-stock';
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
    fetchSubcategories(),
    fetchProducts()
  ]);
});
</script>

<style scoped>
.product-list-container {
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.list-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  gap: 15px;
}

.search-filter-container {
  display: flex;
  align-items: center;
  gap: 15px;
  flex-wrap: wrap;
  flex: 1;
}

.search-box {
  position: relative;
  display: flex;
  align-items: center;
  background-color: #f5f5f5;
  border-radius: 8px;
  padding: 0 15px;
  flex: 1;
  max-width: 400px;
  transition: all 0.3s ease;
}

.search-box:focus-within {
  background-color: #fff;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.search-box i {
  color: #7f8c8d;
  margin-right: 10px;
}

.search-box input {
  border: none;
  background: transparent;
  padding: 12px 0;
  width: 100%;
  font-size: 0.9rem;
  color: #2c3e50;
}

.search-box input:focus {
  outline: none;
}

.clear-search {
  background: none;
  border: none;
  color: #7f8c8d;
  cursor: pointer;
  padding: 0;
  margin-left: 5px;
}

.filter-section {
  display: flex;
  gap: 10px;
}

.filter-toggle, .sort-toggle {
  background-color: #f5f5f5;
  border: none;
  border-radius: 8px;
  padding: 10px 15px;
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  font-size: 0.9rem;
  color: #2c3e50;
  transition: all 0.3s ease;
}

.filter-toggle:hover, .sort-toggle:hover {
  background-color: #e0e0e0;
}

.sort-dropdown {
  position: relative;
}

.sort-menu {
  position: absolute;
  top: 100%;
  right: 0;
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
  z-index: 10;
  min-width: 200px;
  margin-top: 5px;
  display: none;
}

.sort-dropdown:hover .sort-menu {
  display: block;
}

.sort-option {
  padding: 10px 15px;
  cursor: pointer;
  transition: background-color 0.2s;
}

.sort-option:hover {
  background-color: #f5f5f5;
}

.action-buttons {
  display: flex;
  gap: 10px;
}

.btn {
  padding: 10px 20px;
  border: none;
  border-radius: 8px;
  font-weight: 600;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 8px;
  transition: all 0.3s ease;
}

.btn-primary {
  background-color: #3498db;
  color: white;
}

.btn-primary:hover {
  background-color: #2980b9;
}

.btn-secondary {
  background-color: #f5f5f5;
  color: #555;
}

.btn-secondary:hover {
  background-color: #e0e0e0;
}

.btn-danger {
  background-color: #e74c3c;
  color: white;
}

.btn-danger:hover {
  background-color: #c0392b;
}

/* Advanced filters panel */
.advanced-filters {
  display: flex;
  flex-wrap: wrap;
  gap: 20px;
  padding: 20px;
  background-color: #f8f9fa;
  border-radius: 8px;
  margin-bottom: 10px;
  align-items: flex-end;
}

.filter-group {
  display: flex;
  flex-direction: column;
  gap: 5px;
  min-width: 200px;
}

.filter-group label {
  font-size: 0.9rem;
  color: #555;
  font-weight: 600;
}

.filter-group select, .filter-group input {
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 5px;
  font-size: 0.9rem;
}

.range-inputs {
  display: flex;
  align-items: center;
  gap: 10px;
}

.range-inputs input {
  width: 80px;
}

.range-inputs span {
  color: #7f8c8d;
}

/* Products grid */
.products-container {
  flex: 1;
  overflow-y: auto;
}

.loading-indicator, .empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 50px;
  color: #7f8c8d;
  text-align: center;
  gap: 15px;
}

.loading-indicator i, .empty-state i {
  font-size: 3rem;
  margin-bottom: 10px;
  color: #bdc3c7;
}

.products-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 20px;
  padding: 10px 0;
}

.product-card {
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
  overflow: hidden;
  transition: all 0.3s ease;
  display: flex;
  flex-direction: column;
  border-left: 3px solid #3498db;
}

.product-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
}

.product-card.low-stock {
  border-left-color: #e74c3c;
}

.product-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px;
  border-bottom: 1px solid #f1f1f1;
}

.product-name {
  margin: 0;
  font-size: 1.1rem;
  color: #2c3e50;
  font-weight: 600;
}

.product-actions {
  display: flex;
  gap: 5px;
}

.action-btn {
  background: none;
  border: none;
  color: #7f8c8d;
  cursor: pointer;
  padding: 5px;
  border-radius: 5px;
  transition: all 0.2s;
}

.action-btn:hover {
  background-color: #f5f5f5;
  color: #2c3e50;
}

.product-details {
  padding: 15px;
  display: flex;
  flex-direction: column;
  gap: 10px;
  flex: 1;
}

.detail-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.detail-label {
  color: #7f8c8d;
  font-size: 0.9rem;
}

.detail-value {
  font-weight: 600;
  color: #2c3e50;
}

.detail-value.price {
  color: #3498db;
  font-size: 1.1rem;
}

.detail-value.stock {
  padding: 3px 8px;
  border-radius: 10px;
  font-size: 0.8rem;
}

.detail-value.stock.in-stock {
  background-color: #e6f7ee;
  color: #27ae60;
}

.detail-value.stock.low-stock {
  background-color: #ffeaa7;
  color: #d35400;
}

.detail-value.stock.out-of-stock {
  background-color: #ffebee;
  color: #e74c3c;
}

.detail-value.category {
  font-size: 0.85rem;
  color: #7f8c8d;
  font-style: italic;
}

.detail-row.description {
  flex-direction: column;
  align-items: flex-start;
  gap: 5px;
}

.detail-row.description .detail-value {
  font-weight: normal;
  font-size: 0.9rem;
  color: #555;
  line-height: 1.4;
}

/* Delete Modal */
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
  background-color: white;
  border-radius: 8px;
  width: 90%;
  max-width: 500px;
  max-height: 90vh;
  overflow-y: auto;
  box-shadow: 0 5px 20px rgba(0, 0, 0, 0.2);
}

.modal-header {
  padding: 15px 20px;
  border-bottom: 1px solid #eee;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.modal-header h3 {
  margin: 0;
  color: #2c3e50;
}

.close-btn {
  background: none;
  border: none;
  font-size: 1.2rem;
  cursor: pointer;
  color: #7f8c8d;
}

.modal-body {
  padding: 20px;
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.warning-icon {
  display: flex;
  justify-content: center;
  font-size: 3rem;
  color: #e74c3c;
}

.warning-text {
  background-color: #fff8e1;
  padding: 10px 15px;
  border-radius: 5px;
  color: #d35400;
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: 0.9rem;
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

.form-actions {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  margin-top: 10px;
}

/* Responsive adjustments */
@media (max-width: 768px) {
  .list-header {
    flex-direction: column;
    align-items: stretch;
  }
  
  .search-filter-container {
    flex-direction: column;
    align-items: stretch;
  }
  
  .search-box {
    max-width: none;
  }
  
  .filter-section {
    justify-content: space-between;
  }
  
  .advanced-filters {
    flex-direction: column;
    align-items: stretch;
  }
  
  .filter-group {
    min-width: 0;
  }
  
  .products-grid {
    grid-template-columns: 1fr;
  }
}
</style>