<template>
  <div class="product-create-container">
    <div class="form-header">
      <h3>Nouveau Produit</h3>
      <p class="subtitle">Ajoutez un nouveau produit à votre catalogue</p>
    </div>
    
    <form @submit.prevent="saveProduct" class="product-form">
      <div class="form-grid">
        <!-- Basic Information Section -->
        <div class="form-section">
          <h4 class="section-title">Informations de base</h4>
          
          <div class="form-group">
            <label for="productName">Nom du produit <span class="required">*</span></label>
            <input 
              type="text" 
              id="productName" 
              v-model="productForm.name" 
              :class="{ 'error': formErrors.name }"
              @blur="validateField('name')"
            />
            <span v-if="formErrors.name" class="error-message">{{ formErrors.name }}</span>
          </div>
          
          <div class="form-group">
            <label for="productDescription">Description</label>
            <textarea 
              id="productDescription" 
              v-model="productForm.description" 
              rows="4"
            ></textarea>
          </div>
        </div>
        
        <!-- Pricing and Stock Section -->
        <div class="form-section">
          <h4 class="section-title">Prix et Stock</h4>
          
          <div class="form-group">
            <label for="productPrice">Prix unitaire <span class="required">*</span></label>
            <div class="input-with-icon">
              <input 
                type="number" 
                id="productPrice" 
                v-model="productForm.unit_price" 
                step="0.01" 
                min="0"
                :class="{ 'error': formErrors.unit_price }"
                @blur="validateField('unit_price')"
              />
              <span class="input-icon">€</span>
            </div>
            <span v-if="formErrors.unit_price" class="error-message">{{ formErrors.unit_price }}</span>
          </div>
          
          <div class="form-group">
            <label for="productUnit">Unité de mesure</label>
            <select id="productUnit" v-model="productForm.unit">
              <option value="">Sélectionnez une unité</option>
              <option value="pièce">Pièce</option>
              <option value="kg">Kilogramme (kg)</option>
              <option value="g">Gramme (g)</option>
              <option value="l">Litre (L)</option>
              <option value="ml">Millilitre (mL)</option>
              <option value="m">Mètre (m)</option>
              <option value="cm">Centimètre (cm)</option>
              <option value="m²">Mètre carré (m²)</option>
              <option value="lot">Lot</option>
              <option value="pack">Pack</option>
              <option value="carton">Carton</option>
              <option value="palette">Palette</option>
            </select>
          </div>
          
          <div class="form-group">
            <label for="productStock">Quantité en stock</label>
            <input 
              type="number" 
              id="productStock" 
              v-model="productForm.stock_quantity" 
              min="0"
              step="1"
            />
          </div>
        </div>
        
        <!-- Categorization Section -->
        <div class="form-section">
          <h4 class="section-title">Catégorisation</h4>
          
          <div class="form-group">
            <label for="productCategory">Catégorie</label>
            <select 
              id="productCategory" 
              v-model="selectedCategoryId"
              @change="handleCategoryChange"
            >
              <option value="">Aucune catégorie</option>
              <option v-for="category in categories" :key="category.id" :value="category.id">
                {{ category.name }}
              </option>
            </select>
          </div>
          
          <div class="form-group">
            <label for="productSubcategory">Sous-catégorie</label>
            <select 
              id="productSubcategory" 
              v-model="productForm.subcategory_id"
              :disabled="!selectedCategoryId || filteredSubcategories.length === 0"
            >
              <option value="">Aucune sous-catégorie</option>
              <option v-for="subcategory in filteredSubcategories" :key="subcategory.id" :value="subcategory.id">
                {{ subcategory.name }}
              </option>
            </select>
            <div v-if="selectedCategoryId && filteredSubcategories.length === 0" class="helper-text">
              <i class="fas fa-info-circle"></i>
              Aucune sous-catégorie disponible pour cette catégorie.
              <router-link to="/admin-entreprise/categories" class="helper-link">Gérer les sous-catégories</router-link>
            </div>
          </div>
        </div>
      </div>
      
      <div class="form-actions">
        
        <button type="submit" class="btn btn-primary" :disabled="formSubmitting">
          <span v-if="formSubmitting">
            <i class="fas fa-spinner fa-spin"></i> Enregistrement...
          </span>
          <span v-else>
            <i class="fas fa-save"></i> Enregistrer
          </span>
        </button>
      </div>
    </form>
    
    <!-- Success Modal -->
    <div v-if="showSuccessModal" class="modal-overlay">
      <div class="success-modal">
        <div class="success-icon">
          <i class="fas fa-check-circle"></i>
        </div>
        <h2>Produit créé avec succès!</h2>
        <p>Le produit a été ajouté à votre catalogue.</p>
        <div class="modal-actions">
          <button class="btn btn-secondary" @click="goToProductList">Voir la liste des produits</button>
          <button class="btn btn-primary" @click="createAnother">Créer un autre produit</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import api from '@/services/api';

// Router
const router = useRouter();

// Emits
const emit = defineEmits(['product-created', 'show-category-management']);

// State
const categories = ref([]);
const subcategories = ref([]);
const selectedCategoryId = ref('');
const formSubmitting = ref(false);
const showSuccessModal = ref(false);

// Form state
const productForm = ref({
  name: '',
  description: '',
  unit_price: '',
  unit: '',
  stock_quantity: 0,
  subcategory_id: ''
});

const formErrors = ref({
  name: '',
  unit_price: ''
});

// Computed properties
const filteredSubcategories = computed(() => {
  if (!selectedCategoryId.value) return [];
  return subcategories.value.filter(subcategory => subcategory.category_id === selectedCategoryId.value);
});

// Methods
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
    const response = await api.get('/api/categories/subcategories');
    subcategories.value = response.data.data;
  } catch (error) {
    console.error('Error fetching subcategories:', error);
  }
};

const handleCategoryChange = () => {
  // Reset subcategory selection when category changes
  productForm.value.subcategory_id = '';
};

const validateField = (field) => {
  formErrors.value[field] = '';
  
  if (field === 'name' && !productForm.value.name.trim()) {
    formErrors.value.name = 'Le nom du produit est requis';
    return false;
  }
  
  if (field === 'unit_price') {
    if (!productForm.value.unit_price) {
      formErrors.value.unit_price = 'Le prix unitaire est requis';
      return false;
    }
    
    if (isNaN(productForm.value.unit_price) || parseFloat(productForm.value.unit_price) <= 0) {
      formErrors.value.unit_price = 'Le prix doit être un nombre positif';
      return false;
    }
  }
  
  return true;
};

const validateForm = () => {
  let isValid = true;
  
  // Validate required fields
  if (!validateField('name')) isValid = false;
  if (!validateField('unit_price')) isValid = false;
  
  return isValid;
};

const saveProduct = async () => {
  // Validate form
  if (!validateForm()) return;
  
  formSubmitting.value = true;
  
  try {
    // Convert numeric fields
    const formData = {
      ...productForm.value,
      unit_price: parseFloat(productForm.value.unit_price),
      stock_quantity: parseInt(productForm.value.stock_quantity) || 0
    };
    
    // If subcategory_id is empty string, set it to null
    if (formData.subcategory_id === '') {
      formData.subcategory_id = null;
    }
    
    // Create product
    const response = await api.post('/api/products', formData);
    
    // Show success modal instead of redirecting
    showSuccessModal.value = true;
    
    // Emit event that product was created
    emit('product-created', response.data.data);
  } catch (error) {
    console.error('Error creating product:', error);
    
    if (error.response && error.response.data) {
      // Handle validation errors from the server
      if (error.response.status === 409 && error.response.data.field === 'name') {
        formErrors.value.name = error.response.data.message || 'Ce nom de produit existe déjà';
      } else if (error.response.data.field === 'unit_price') {
        formErrors.value.unit_price = error.response.data.message || 'Prix invalide';
      } else {
        // Show general error
        alert(error.response.data.message || 'Une erreur est survenue lors de la création du produit');
      }
    } else {
      alert('Une erreur est survenue lors de la création du produit');
    }
  } finally {
    formSubmitting.value = false;
  }
};

const showCategoryManagement = () => {
  emit('show-category-management');
};

const goToProductList = () => {
  router.push('/admin-entreprise/product-list');
};

const createAnother = () => {
  // Reset form
  productForm.value = {
    name: '',
    description: '',
    unit_price: '',
    unit: '',
    stock_quantity: 0,
    subcategory_id: ''
  };
  selectedCategoryId.value = '';
  formErrors.value = {
    name: '',
    unit_price: ''
  };
  
  // Hide modal
  showSuccessModal.value = false;
};

// Initialize component
onMounted(async () => {
  await Promise.all([
    fetchCategories(),
    fetchSubcategories()
  ]);
});
</script>

<style scoped>
.product-create-container {
  width: 100%;
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
}

.form-header {
  margin-bottom: 30px;
}

.form-header h3 {
  font-size: 1.5rem;
  color: #2c3e50;
  margin: 0 0 5px 0;
}

.subtitle {
  color: #7f8c8d;
  margin: 0;
}

.product-form {
  display: flex;
  flex-direction: column;
  gap: 20px;
  background-color: #fff;
  border-radius: 10px;
  box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
  padding: 40px;
  border: 1px solid #f0f0f0;
}

.form-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 30px;
}

.form-section {
  display: flex;
  flex-direction: column;
  gap: 15px;
  position: relative;
  margin-bottom: 15px;
}

.section-title {
  font-size: 1.1rem;
  color: #333;
  margin: 0 0 15px 0;
  padding-bottom: 12px;
  border-bottom: 1px solid #eee;
  font-weight: 600;
  position: relative;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.section-title::after {
  content: '';
  position: absolute;
  bottom: -1px;
  left: 0;
  width: 80px;
  height: 3px;
  background-color: #2196F3;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 5px;
}

.form-group label {
  font-size: 13px;
  color: #424242;
  font-weight: 600;
  position: relative;
  padding-left: 5px;
  margin-bottom: 5px;
}

.form-group label::before {
  content: '';
  position: absolute;
  left: 0;
  top: 2px;
  height: 14px;
  width: 2px;
  background-color: #2196F3;
}

.required {
  color: #e74c3c;
}

input, select, textarea {
  padding: 6px 12px;
  border: 1px solid #e0e0e0;
  border-radius: 4px;
  font-size: 13px;
  color: #333;
  transition: all 0.3s ease;
  background-color: #f9f9f9;
  box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.05);
  height: 32px;
}

textarea {
  height: auto;
  min-height: 80px;
  padding: 10px 12px;
}

input:focus, select:focus, textarea:focus {
  outline: none;
  border-color: #2196F3;
  background-color: #fff;
  box-shadow: 0 0 0 3px rgba(33, 150, 243, 0.1);
}

input.error, select.error, textarea.error {
  border-color: #e74c3c;
}

.error-message {
  color: #e74c3c;
  font-size: 0.8rem;
  margin-top: 5px;
}

.input-with-icon {
  position: relative;
}

.input-with-icon input {
  padding-right: 30px;
}

.input-icon {
  position: absolute;
  right: 12px;
  top: 50%;
  transform: translateY(-50%);
  color: #7f8c8d;
}

.helper-text {
  margin-top: 8px;
  font-size: 0.85rem;
  color: #7f8c8d;
  display: flex;
  align-items: center;
  gap: 5px;
}

.helper-text i {
  color: #3498db;
}

.helper-link {
  color: #3498db;
  text-decoration: none;
  font-weight: 500;
  margin-left: 5px;
  transition: color 0.2s ease;
}

.helper-link:hover {
  color: #2980b9;
  text-decoration: underline;
}

.helper-text a {
  color: #3498db;
  text-decoration: none;
}

.helper-text a:hover {
  text-decoration: underline;
}

.form-actions {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  margin-top: 10px;
}

.btn {
  padding: 6px 18px;
  border: none;
  border-radius: 3px;
  font-weight: 500;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 8px;
  transition: all 0.3s ease;
  font-size: 12px;
  letter-spacing: 0.5px;
  text-transform: uppercase;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
  height: 32px;
}

.btn-primary {
  background-color: #2196F3;
  color: white;
}

.btn-primary:hover {
  background-color: #0b7dda;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
}

.btn-secondary {
  background-color: #f5f5f5;
  color: #333;
  border: 1px solid #ddd;
}

.btn-secondary:hover {
  background-color: #e0e0e0;
  border-color: #ccc;
}

.btn:disabled {
  opacity: 0.7;
  cursor: not-allowed;
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

/* Responsive adjustments */
@media (max-width: 768px) {
  .form-grid {
    grid-template-columns: 1fr;
  }
  
  .form-actions {
    flex-direction: column-reverse;
  }
  
  .btn {
    width: 100%;
    justify-content: center;
  }
  
  .modal-actions {
    flex-direction: column;
    gap: 10px;
  }
}
</style>