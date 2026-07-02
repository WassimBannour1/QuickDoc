<template>
  <div class="product-management">
    <!-- Header with title and action button -->
    <div class="product-header">
      <h2 class="animated-title">Gestion des Produits</h2>
      <div class="header-actions">
        <button v-if="activeView === 'categories'" class="btn btn-primary" @click="showCategoryModal = true">
          <i class="fas fa-plus"></i> Nouvelle Catégorie
        </button>
        <button v-if="activeView !== 'list' && activeView !== 'categories'" class="btn btn-secondary" @click="activeView = 'list'">
          <i class="fas fa-arrow-left"></i> Retour à la liste
        </button>
      </div>
    </div>

    <!-- Category Management View -->
    <CategoryManagement 
      v-if="activeView === 'categories'" 
      @category-created="handleCategoryCreated" 
      :show-modal="showCategoryModal"
      @close-modal="showCategoryModal = false"
    />

    <!-- Product List View -->
    <ProductList 
      v-if="activeView === 'list'" 
      @edit-product="handleEditProduct" 
      @create-product="activeView = 'create'"
      :managedByParent="true"
    />

    <!-- Product Create View -->
    <ProductCreate v-if="activeView === 'create'" @product-created="handleProductCreated" @cancel="activeView = 'list'" />
    
    <!-- Product Edit View -->
    <ProductEditForm v-if="activeView === 'edit'" :id="productToEdit?.id" @product-updated="handleProductUpdated" />
    
    <!-- Stock Management View -->
    <StockManagement v-if="activeView === 'stock'" />
  </div>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue';
import { useRoute } from 'vue-router';

// Import components
import ProductList from '@/components/product/ProductList.vue';
import ProductCreate from '@/components/product/ProductCreate.vue';
import ProductEditForm from '@/components/product/ProductEditForm.vue';
import CategoryManagement from '@/components/product/CategoryManagement.vue';
import StockManagement from '@/components/product/StockManagement.vue';

// Props to control which view to show initially
const props = defineProps({
  initialView: {
    type: String,
    default: 'list',
    validator: (value) => ['list', 'create', 'edit', 'categories', 'stock'].includes(value)
  }
});

// State
const activeView = ref(props.initialView);
const productToEdit = ref(null);
const showCategoryModal = ref(false);
const route = useRoute();

// Watch for changes in the initialView prop
watch(() => props.initialView, (newView) => {
  activeView.value = newView;
});

// Handle product edit action
const handleEditProduct = (product) => {
  productToEdit.value = product;
  activeView.value = 'edit';
};

// Handle product created action
const handleProductCreated = () => {
  productToEdit.value = null;
  activeView.value = 'list';
};

// Handle product updated action
const handleProductUpdated = () => {
  productToEdit.value = null;
  activeView.value = 'list';
};

// Handle category created action
const handleCategoryCreated = () => {
  showCategoryModal.value = false;
};

// Initialize component based on route
onMounted(() => {
  // Map initialView values to component views
  const viewMapping = {
    'product-list': 'list',
    'product-create': 'create',
    'categories': 'categories',
    'stock': 'stock',
    'scraping': 'scraping'
  };
  
  // Check if we're on a specific route that should show a specific view
  if (route.name === 'product-create') {
    activeView.value = 'create';
  } else if (route.name === 'edit-product' && route.params.id) {
    // If we're on the edit route, set the product ID and switch to edit view
    productToEdit.value = { id: route.params.id };
    activeView.value = 'edit';
  } else if (props.initialView) {
    // Map the initialView prop to the correct internal view name
    activeView.value = viewMapping[props.initialView] || props.initialView;
    console.log(`Setting activeView to ${activeView.value} from initialView ${props.initialView}`);
  }
});
</script>

<style scoped>
.product-management {
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.product-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
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

.header-actions {
  display: flex;
  gap: 10px;
}

.btn {
  padding: 10px 20px;
  border: none;
  border-radius: 5px;
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
</style>