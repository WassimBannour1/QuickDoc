<template>
  <div class="category-management">
    <div class="category-header">
      <p class="subtitle">Organisez vos produits en catégories et sous-catégories</p>
    </div>

    <div class="category-content">
      <!-- Left panel: Category tree -->
      <div class="category-tree-panel">
        <div class="panel-header">
          <h3>Structure hiérarchique</h3>
          <button class="btn btn-sm btn-primary" @click="openCategoryModal">
            <i class="fas fa-plus"></i> Nouvelle Catégorie
          </button>
        </div>
        
        <div class="search-box">
          <i class="fas fa-search"></i>
          <input 
            type="text" 
            v-model="searchQuery" 
            placeholder="Rechercher une catégorie..."
          />
        </div>

        <!-- Category Tree -->
        <div class="category-tree">
          <div v-if="loading" class="loading-indicator">
            <i class="fas fa-spinner fa-spin"></i> Chargement des catégories...
          </div>
          
          <div v-else-if="categories.length === 0" class="empty-state">
            <i class="fas fa-folder-open"></i>
            <p>Aucune catégorie trouvée</p>
            <button class="btn btn-primary" @click="openCategoryModal">
              <i class="fas fa-plus"></i> Créer votre première catégorie
            </button>
          </div>
          
          <div v-else class="tree-container">
            <ul class="tree-root">
              <li v-for="category in filteredCategories" :key="category.id" class="tree-item">
                <!-- Category item -->
                <div 
                  class="category-item" 
                  :class="{ 'active': selectedCategory && selectedCategory.id === category.id }"
                  @click="selectCategory(category)"
                >
                  <div class="item-header">
                    <i 
                      class="fas" 
                      :class="expandedCategories.includes(category.id) ? 'fa-folder-open' : 'fa-folder'"
                      @click.stop="toggleCategory(category.id)"
                    ></i>
                    <span class="item-name">{{ category.name }}</span>
                    <span class="item-count" v-if="getSubcategoriesForCategory(category.id).length > 0">
                      ({{ getSubcategoriesForCategory(category.id).length }})
                    </span>
                  </div>
                  
                  <div class="item-actions">
                    <button class="action-btn edit-btn" @click.stop="showEditCategoryModal(category)" title="Modifier">
                      <i class="fas fa-edit"></i>
                    </button>
                    <button class="action-btn delete-btn" @click.stop="showDeleteCategoryModal(category)" title="Supprimer">
                      <i class="fas fa-trash"></i>
                    </button>
                    <button class="action-btn add-btn" @click.stop="showAddSubcategoryModal(category)" title="Ajouter une sous-catégorie">
                      <i class="fas fa-plus"></i>
                    </button>
                  </div>
                </div>
                
                <!-- Subcategories -->
                <transition name="tree-expand">
                  <ul v-if="expandedCategories.includes(category.id)" class="subcategory-list">
                    <li 
                      v-for="subcategory in getSubcategoriesForCategory(category.id)" 
                      :key="subcategory.id"
                      class="subcategory-item"
                      :class="{ 'active': selectedSubcategory && selectedSubcategory.id === subcategory.id }"
                      @click.stop="selectSubcategory(subcategory)"
                    >
                      <div class="item-header">
                        <i class="fas fa-tag"></i>
                        <span class="item-name">{{ subcategory.name }}</span>
                      </div>
                      
                      <div class="item-actions">
                        <button class="action-btn edit-btn" @click.stop="showEditSubcategoryModal(subcategory)" title="Modifier">
                          <i class="fas fa-edit"></i>
                        </button>
                        <button class="action-btn delete-btn" @click.stop="showDeleteSubcategoryModal(subcategory)" title="Supprimer">
                          <i class="fas fa-trash"></i>
                        </button>
                      </div>
                    </li>
                    
                    <!-- Empty subcategory state -->
                    <li v-if="getSubcategoriesForCategory(category.id).length === 0" class="empty-subcategory">
                      <p>Aucune sous-catégorie</p>
                      <button class="btn btn-sm btn-outline-primary" @click.stop="showAddSubcategoryModal(category)">
                        <i class="fas fa-plus"></i> Ajouter
                      </button>
                    </li>
                  </ul>
                </transition>
              </li>
            </ul>
          </div>
        </div>
      </div>

      <!-- Right panel: Selected category/subcategory details and products -->
      <div class="category-details-panel">
        <div v-if="!selectedCategory && !selectedSubcategory" class="empty-selection">
          <i class="fas fa-hand-pointer"></i>
          <h3>Sélectionnez une catégorie</h3>
          <p>Cliquez sur une catégorie ou sous-catégorie pour voir ses détails et les produits associés</p>
        </div>
        
        <div v-else-if="selectedCategory" class="category-details">
          <div class="details-header">
            <h3>
              <i class="fas fa-folder"></i>
              {{ selectedCategory.name }}
            </h3>
            <div class="header-actions">
              <button class="btn btn-sm btn-primary" @click="showAddSubcategoryModal(selectedCategory)">
                <i class="fas fa-plus"></i> Ajouter une sous-catégorie
              </button>
            </div>
          </div>
          
          <div class="details-content">
            <div class="subcategories-section">
              <h4>Sous-catégories ({{ getSubcategoriesForCategory(selectedCategory.id).length }})</h4>
              <div class="subcategories-grid">
                <div 
                  v-for="subcategory in getSubcategoriesForCategory(selectedCategory.id)" 
                  :key="subcategory.id"
                  class="subcategory-card"
                  @click="selectSubcategory(subcategory)"
                >
                  <i class="fas fa-tag"></i>
                  <span>{{ subcategory.name }}</span>
                </div>
                
                <div v-if="getSubcategoriesForCategory(selectedCategory.id).length === 0" class="empty-grid">
                  <p>Aucune sous-catégorie trouvée</p>
                </div>
              </div>
            </div>
            
            <div class="products-section">
              <h4>Produits dans cette catégorie</h4>
              <div class="products-list">
                <div 
                  v-for="product in categoryProducts" 
                  :key="product.id"
                  class="product-card"
                >
                  <i class="fas fa-box"></i>
                  <span>{{ product.name }}</span>
                  <div class="product-details">
                    <span class="product-price">{{ product.unit_price }} €</span>
                    <span class="product-stock">Stock: {{ product.stock_quantity }}</span>
                  </div>
                </div>
                
                <div v-if="categoryProducts.length === 0" class="empty-grid">
                  <p>Les produits associés à cette catégorie s'afficheront ici</p>
                </div>
              </div>
            </div>
          </div>
        </div>
        
        <div v-else-if="selectedSubcategory" class="subcategory-details">
          <div class="details-header">
            <h3>
              <i class="fas fa-tag"></i>
              {{ selectedSubcategory.name }}
              <span class="parent-category" v-if="getCategoryForSubcategory(selectedSubcategory.category_id)">
                <i class="fas fa-chevron-left"></i>
                <a href="#" @click.prevent="selectCategory(getCategoryForSubcategory(selectedSubcategory.category_id))">
                  {{ getCategoryForSubcategory(selectedSubcategory.category_id).name }}
                </a>
              </span>
            </h3>
          </div>
          
          <div class="details-content">
            <div class="products-section">
              <h4>Produits dans cette sous-catégorie</h4>
              <div class="products-list">
                <div 
                  v-for="product in subcategoryProducts" 
                  :key="product.id"
                  class="product-card"
                >
                  <i class="fas fa-box"></i>
                  <span>{{ product.name }}</span>
                  <div class="product-details">
                    <span class="product-price">{{ product.unit_price }} €</span>
                    <span class="product-stock">Stock: {{ product.stock_quantity }}</span>
                  </div>
                </div>
                
                <div v-if="subcategoryProducts.length === 0" class="empty-grid">
                  <p>Les produits associés à cette sous-catégorie s'afficheront ici</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Category Modal -->
    <div v-if="showCategoryModal" class="modal-overlay" @click.self="closeCategoryModal">
      <div class="modal-content">
        <div class="modal-header">
          <h3>{{ editingCategory ? 'Modifier la catégorie' : 'Nouvelle catégorie' }}</h3>
          <button class="close-btn" @click="closeCategoryModal">
            <i class="fas fa-times"></i>
          </button>
        </div>
        
        <div class="modal-body">
          <div class="form-group">
            <label for="categoryName">Nom de la catégorie</label>
            <input 
              type="text" 
              id="categoryName" 
              v-model="categoryForm.name" 
              class="form-control"
              placeholder="Ex: Électronique, Vêtements, etc."
              :class="{ 'is-invalid': categoryFormErrors.name }"
              @input="validateCategoryForm"
            >
            <div v-if="categoryFormErrors.name" class="invalid-feedback">
              {{ categoryFormErrors.name }}
            </div>
          </div>
          
          <!-- Section pour ajouter des sous-catégories -->
          <div class="subcategories-section" v-if="!editingCategory">
            <h4>Ajouter des sous-catégories (optionnel)</h4>
            <p class="text-muted">Vous pourrez ajouter d'autres sous-catégories plus tard.</p>
            
            <div class="subcategory-list-form">
              <div v-for="(subcategory, index) in subcategoryForms" :key="index" class="subcategory-form-item">
                <div class="form-group">
                  <div class="input-group">
                    <input 
                      type="text" 
                      v-model="subcategory.name" 
                      class="form-control"
                      placeholder="Nom de la sous-catégorie"
                      :class="{ 'is-invalid': subcategory.error }"
                    >
                    <button 
                      type="button" 
                      class="btn btn-outline-danger" 
                      @click="removeSubcategoryForm(index)"
                    >
                      <i class="fas fa-times"></i>
                    </button>
                  </div>
                  <div v-if="subcategory.error" class="invalid-feedback d-block">
                    {{ subcategory.error }}
                  </div>
                </div>
              </div>
              
              <button 
                type="button" 
                class="btn btn-outline-primary add-subcategory-btn" 
                @click="addSubcategoryForm"
              >
                <i class="fas fa-plus"></i> Ajouter une sous-catégorie
              </button>
            </div>
          </div>
        </div>
        
        <div class="modal-footer">
          <button 
            class="btn btn-secondary" 
            @click="closeCategoryModal"
            :disabled="categorySubmitting"
          >
            Annuler
          </button>
          <button 
            class="btn btn-primary" 
            @click="submitCategoryForm"
            :disabled="categorySubmitting || !isCategoryFormValid"
          >
            <i v-if="categorySubmitting" class="fas fa-spinner fa-spin"></i>
            {{ editingCategory ? 'Mettre à jour' : 'Créer' }}
          </button>
        </div>
      </div>
    </div>

    <!-- Subcategory Modal -->
    <div v-if="showSubcategoryModal" class="modal-overlay" @click.self="closeSubcategoryModal">
      <div class="modal-content">
        <div class="modal-header">
          <h3>{{ editingSubcategory ? 'Modifier la sous-catégorie' : 'Nouvelle sous-catégorie' }}</h3>
          <button class="close-btn" @click="closeSubcategoryModal">
            <i class="fas fa-times"></i>
          </button>
        </div>
        
        <div class="modal-body">
          <form @submit.prevent="saveSubcategory">
            <div class="form-group">
              <label for="parentCategory">Catégorie parente <span class="required">*</span></label>
              <select 
                id="parentCategory" 
                v-model="subcategoryForm.category_id" 
                required
                :disabled="editingSubcategory"
              >
                <option v-for="category in categories" :key="category.id" :value="category.id">
                  {{ category.name }}
                </option>
              </select>
            </div>
            
            <div class="form-group">
              <label for="subcategoryName">Nom de la sous-catégorie <span class="required">*</span></label>
              <input 
                type="text" 
                id="subcategoryName" 
                v-model="subcategoryForm.name" 
                required
                :class="{ 'error': subcategoryFormErrors.name }"
              />
              <span v-if="subcategoryFormErrors.name" class="error-message">{{ subcategoryFormErrors.name }}</span>
            </div>
            
            <div class="form-actions">
              <button type="button" class="btn btn-secondary" @click="closeSubcategoryModal">Annuler</button>
              <button type="submit" class="btn btn-primary" :disabled="subcategoryFormSubmitting">
                <span v-if="subcategoryFormSubmitting">
                  <i class="fas fa-spinner fa-spin"></i> Enregistrement...
                </span>
                <span v-else>{{ editingSubcategory ? 'Mettre à jour' : 'Créer' }}</span>
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div v-if="showDeleteModal" class="modal-overlay" @click.self="closeDeleteModal">
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
          
          <p v-if="deletingCategory" class="delete-message">
            Êtes-vous sûr de vouloir supprimer la catégorie <strong>{{ deletingCategory.name }}</strong> ?
          </p>
          <p v-else-if="deletingSubcategory" class="delete-message">
            Êtes-vous sûr de vouloir supprimer la sous-catégorie <strong>{{ deletingSubcategory.name }}</strong> ?
          </p>
          
          <div class="warning-text">
            <i class="fas fa-info-circle"></i>
            <span v-if="deletingCategory">
              Cette action supprimera également toutes les sous-catégories associées.
              Les produits associés ne seront pas supprimés mais perdront leur catégorisation.
            </span>
            <span v-else-if="deletingSubcategory">
              Les produits associés à cette sous-catégorie ne seront pas supprimés mais perdront leur catégorisation.
            </span>
          </div>
          
          <div class="modal-actions">
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
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue';
import api from '@/services/api';

// Props
const props = defineProps({
  showModal: {
    type: Boolean,
    default: false
  }
});

// Emits
const emit = defineEmits(['category-created', 'close-modal']);

// State
const loading = ref(true);
const categories = ref([]);
const subcategories = ref([]);
const products = ref([]);
const expandedCategories = ref([]);
const selectedCategory = ref(null);
const selectedSubcategory = ref(null);
const searchQuery = ref('');

// Modal state
const showCategoryModal = ref(props.showModal);
const showSubcategoryModal = ref(false);
const showDeleteModal = ref(false);

// Form state
const editingCategory = ref(null);
const editingSubcategory = ref(null);
const deletingCategory = ref(null);
const deletingSubcategory = ref(null);

const categoryForm = ref({
  name: ''
});

const subcategoryForm = ref({
  category_id: '',
  name: ''
});

const categoryFormErrors = ref({});
const subcategoryFormErrors = ref({});
const categoryFormSubmitting = ref(false);
const subcategoryFormSubmitting = ref(false);
const deleteSubmitting = ref(false);
const categorySubmitting = ref(false);

// Sous-catégories dans le formulaire de création de catégorie
const subcategoryForms = ref([]);

// Ajouter un formulaire de sous-catégorie
const addSubcategoryForm = () => {
  subcategoryForms.value.push({ name: '', error: '' });
};

// Supprimer un formulaire de sous-catégorie
const removeSubcategoryForm = (index) => {
  subcategoryForms.value.splice(index, 1);
};

// Valider les formulaires de sous-catégories
const validateSubcategoryForms = () => {
  let isValid = true;
  
  // Réinitialiser les erreurs
  subcategoryForms.value.forEach(subcategory => {
    subcategory.error = '';
  });
  
  // Vérifier les noms vides
  subcategoryForms.value.forEach(subcategory => {
    if (subcategory.name.trim() === '') {
      subcategory.error = 'Le nom de la sous-catégorie est requis';
      isValid = false;
    }
  });
  
  // Vérifier les doublons
  const names = subcategoryForms.value.map(s => s.name.trim().toLowerCase());
  const duplicates = names.filter((name, index) => names.indexOf(name) !== index);
  
  if (duplicates.length > 0) {
    subcategoryForms.value.forEach((subcategory, index) => {
      if (duplicates.includes(subcategory.name.trim().toLowerCase())) {
        subcategory.error = 'Nom de sous-catégorie en double';
        isValid = false;
      }
    });
  }
  
  return isValid;
};

// Add the missing validateCategoryForm function
const validateCategoryForm = () => {
  categoryFormErrors.value = {};
  
  // Validate category name
  if (!categoryForm.value.name.trim()) {
    categoryFormErrors.value.name = 'Le nom de la catégorie est requis';
    return false;
  }
  
  return true;
};

// Watch for changes in the showModal prop
watch(() => props.showModal, (newValue) => {
  showCategoryModal.value = newValue;
});

// Computed properties
const filteredCategories = computed(() => {
  if (!searchQuery.value) return categories.value;
  
  return categories.value.filter(category => 
    category.name.toLowerCase().includes(searchQuery.value.toLowerCase())
  );
});

const categoryProducts = computed(() => {
  if (!selectedCategory.value) return [];
  
  return products.value.filter(product => {
    // Find all subcategories for this category
    const categorySubcategories = subcategories.value.filter(
      subcategory => subcategory.category_id === selectedCategory.value.id
    );
    
    // Get all subcategory IDs
    const subcategoryIds = categorySubcategories.map(subcategory => subcategory.id);
    
    // Return products that belong to any of these subcategories
    return subcategoryIds.includes(product.subcategory_id);
  });
});

const subcategoryProducts = computed(() => {
  if (!selectedSubcategory.value) return [];
  
  return products.value.filter(product => 
    product.subcategory_id === selectedSubcategory.value.id
  );
});

const isCategoryFormValid = computed(() => {
  return categoryForm.value.name.trim() !== '';
});

// Methods
const fetchCategories = async () => {
  loading.value = true;
  try {
    const response = await api.get('/api/categories');
    categories.value = response.data.data;
  } catch (error) {
    console.error('Error fetching categories:', error);
  } finally {
    loading.value = false;
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

const fetchProducts = async () => {
  try {
    const response = await api.get('/api/products');
    products.value = response.data.data;
  } catch (error) {
    console.error('Error fetching products:', error);
  }
};

const getSubcategoriesForCategory = (categoryId) => {
  return subcategories.value.filter(subcategory => subcategory.category_id === categoryId);
};

const getCategoryForSubcategory = (categoryId) => {
  return categories.value.find(category => category.id === categoryId);
};

const toggleCategory = (categoryId) => {
  const index = expandedCategories.value.indexOf(categoryId);
  if (index === -1) {
    expandedCategories.value.push(categoryId);
  } else {
    expandedCategories.value.splice(index, 1);
  }
};

const selectCategory = (category) => {
  selectedCategory.value = category;
  selectedSubcategory.value = null;
  
  // Expand the category if it's not already expanded
  if (!expandedCategories.value.includes(category.id)) {
    expandedCategories.value.push(category.id);
  }
};

const selectSubcategory = (subcategory) => {
  selectedSubcategory.value = subcategory;
  selectedCategory.value = null;
};

// Category Modal Methods
const openCategoryModal = () => {
  categoryForm.value = { name: '' };
  categoryFormErrors.value = { name: '' };
  editingCategory.value = null;
  subcategoryForms.value = []; // Réinitialiser les sous-catégories
  showCategoryModal.value = true;
};

const closeCategoryModal = () => {
  showCategoryModal.value = false;
  categoryForm.value = { name: '' };
  categoryFormErrors.value = { name: '' };
  editingCategory.value = null;
  subcategoryForms.value = [];
  emit('close-modal');
};

const showEditCategoryModal = (category) => {
  editingCategory.value = category;
  categoryForm.value = {
    name: category.name
  };
  categoryFormErrors.value = {};
  showCategoryModal.value = true;
};

const saveCategory = async () => {
  categoryFormErrors.value = {};
  
  // Validate form
  if (!categoryForm.value.name.trim()) {
    categoryFormErrors.value.name = 'Le nom de la catégorie est requis';
    return;
  }
  
  categoryFormSubmitting.value = true;
  
  try {
    if (editingCategory.value) {
      // Update existing category
      await api.put(`/api/categories/${editingCategory.value.id}`, categoryForm.value);
    } else {
      // Create new category
      await api.post('/api/categories', categoryForm.value);
    }
    
    // Refresh categories
    await fetchCategories();
    
    // Close modal
    closeCategoryModal();
    
    // Emit event
    emit('category-created');
  } catch (error) {
    console.error('Error saving category:', error);
    
    if (error.response && error.response.data) {
      if (error.response.status === 409) {
        categoryFormErrors.value.name = 'Ce nom de catégorie existe déjà';
      } else {
        categoryFormErrors.value.name = error.response.data.message || 'Une erreur est survenue';
      }
    } else {
      categoryFormErrors.value.name = 'Une erreur est survenue lors de la sauvegarde';
    }
  } finally {
    categoryFormSubmitting.value = false;
  }
};

// Submit category form
const submitCategoryForm = async () => {
  if (!validateCategoryForm()) {
    return;
  }
  
  // Si on crée une nouvelle catégorie et qu'il y a des sous-catégories, on les valide
  if (!editingCategory.value && subcategoryForms.value.length > 0) {
    if (!validateSubcategoryForms()) {
      return;
    }
  }
  
  try {
    categorySubmitting.value = true;
    
    if (editingCategory.value) {
      // Update existing category
      await api.put(`/api/categories/${editingCategory.value.id}`, {
        name: categoryForm.value.name
      });
      
      // Refresh categories
      await fetchCategories();
    } else {
      // Create new category
      const response = await api.post('/api/categories', {
        name: categoryForm.value.name
      });
      
      // Get the new category ID
      const newCategoryId = response.data.id;
      
      // Create subcategories if any
      if (subcategoryForms.value.length > 0) {
        for (const subcategory of subcategoryForms.value) {
          if (subcategory.name.trim() !== '') {
            await api.post('/api/categories/subcategories', {
              name: subcategory.name,
              category_id: newCategoryId
            });
          }
        }
      }
      
      // Refresh categories and subcategories
      await fetchCategories();
      await fetchSubcategories();
    }
    
    // Close modal
    closeCategoryModal();
  } catch (error) {
    console.error('Error saving category:', error);
  } finally {
    categorySubmitting.value = false;
  }
};

// Subcategory Modal Methods
const showAddSubcategoryModal = (category) => {
  editingSubcategory.value = null;
  subcategoryForm.value = {
    category_id: category.id,
    name: ''
  };
  subcategoryFormErrors.value = {};
  showSubcategoryModal.value = true;
};

const showEditSubcategoryModal = (subcategory) => {
  editingSubcategory.value = subcategory;
  subcategoryForm.value = {
    category_id: subcategory.category_id,
    name: subcategory.name
  };
  subcategoryFormErrors.value = {};
  showSubcategoryModal.value = true;
};

const closeSubcategoryModal = () => {
  showSubcategoryModal.value = false;
  editingSubcategory.value = null;
  subcategoryForm.value = { category_id: '', name: '' };
  subcategoryFormErrors.value = {};
};

const saveSubcategory = async () => {
  subcategoryFormErrors.value = {};
  
  // Validate form
  if (!subcategoryForm.value.name.trim()) {
    subcategoryFormErrors.value.name = 'Le nom de la sous-catégorie est requis';
    return;
  }
  
  if (!subcategoryForm.value.category_id) {
    subcategoryFormErrors.value.category_id = 'La catégorie parente est requise';
    return;
  }
  
  subcategoryFormSubmitting.value = true;
  
  try {
    if (editingSubcategory.value) {
      // Update existing subcategory
      await api.put(`/api/categories/subcategories/${editingSubcategory.value.id}`, subcategoryForm.value);
    } else {
      // Create new subcategory
      await api.post('/api/categories/subcategories', subcategoryForm.value);
    }
    
    // Refresh subcategories
    await fetchSubcategories();
    
    // Close modal
    closeSubcategoryModal();
  } catch (error) {
    console.error('Error saving subcategory:', error);
    
    if (error.response && error.response.data) {
      if (error.response.status === 409) {
        subcategoryFormErrors.value.name = 'Ce nom de sous-catégorie existe déjà dans cette catégorie';
      } else {
        subcategoryFormErrors.value.name = error.response.data.message || 'Une erreur est survenue';
      }
    } else {
      subcategoryFormErrors.value.name = 'Une erreur est survenue lors de la sauvegarde';
    }
  } finally {
    subcategoryFormSubmitting.value = false;
  }
};

// Delete Modal Methods
const showDeleteCategoryModal = (category) => {
  deletingCategory.value = category;
  deletingSubcategory.value = null;
  showDeleteModal.value = true;
};

const showDeleteSubcategoryModal = (subcategory) => {
  deletingSubcategory.value = subcategory;
  deletingCategory.value = null;
  showDeleteModal.value = true;
};

const closeDeleteModal = () => {
  showDeleteModal.value = false;
  deletingCategory.value = null;
  deletingSubcategory.value = null;
};

const confirmDelete = async () => {
  deleteSubmitting.value = true;
  
  try {
    if (deletingCategory.value) {
      // Delete category
      await api.delete(`/api/categories/${deletingCategory.value.id}`);
      
      // If the deleted category was selected, clear the selection
      if (selectedCategory.value && selectedCategory.value.id === deletingCategory.value.id) {
        selectedCategory.value = null;
      }
      
      // Remove from expanded categories
      const index = expandedCategories.value.indexOf(deletingCategory.value.id);
      if (index !== -1) {
        expandedCategories.value.splice(index, 1);
      }
      
      // Refresh categories and subcategories
      await fetchCategories();
      await fetchSubcategories();
    } else if (deletingSubcategory.value) {
      // Delete subcategory
      await api.delete(`/api/categories/subcategories/${deletingSubcategory.value.id}`);
      
      // If the deleted subcategory was selected, clear the selection
      if (selectedSubcategory.value && selectedSubcategory.value.id === deletingSubcategory.value.id) {
        selectedSubcategory.value = null;
      }
      
      // Refresh subcategories
      await fetchSubcategories();
    }
    
    // Close modal
    closeDeleteModal();
  } catch (error) {
    console.error('Error deleting:', error);
  } finally {
    deleteSubmitting.value = false;
  }
};

// Initialize component
onMounted(async () => {
  await fetchCategories();
  await fetchSubcategories();
  await fetchProducts();
});
</script>

<style scoped>
.category-management {
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.category-header {
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
  background: linear-gradient(90deg, #003a6c, #002446);
  border-radius: 3px;
}

.subtitle {
  color: #7f8c8d;
  margin-top: 5px;
}

.category-content {
  display: flex;
  gap: 20px;
  height: calc(100% - 80px);
}

/* Tree Panel */
.category-tree-panel {
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
  padding: 20px;
  display: flex;
  flex-direction: column;
  gap: 15px;
  flex: 1;
  max-width: 350px;
  height: 100%;
  overflow: hidden;
}

.category-details-panel {
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
  padding: 20px;
  display: flex;
  flex-direction: column;
  flex: 2;
  height: 100%;
  overflow: hidden;
}

.panel-header {
  padding: 15px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  border-bottom: 1px solid #e0e0e0;
  background-color: #f8f9fa;
  border-radius: 8px 8px 0 0;
}

.panel-header h3 {
  margin: 0;
  font-size: 1.1rem;
  color: #003a6c;
  font-weight: 600;
}

.search-box {
  padding: 10px 15px;
  border-bottom: 1px solid #e0e0e0;
  display: flex;
  align-items: center;
  gap: 10px;
  background-color: #f8f9fa;
}

.search-box i {
  color: #7f8c8d;
}

.search-box input {
  flex: 1;
  border: none;
  background: transparent;
  padding: 5px;
  font-size: 0.9rem;
  color: #2c3e50;
}

.search-box input:focus {
  outline: none;
}

.category-tree {
  flex: 1;
  overflow-y: auto;
  padding: 10px 0;
}

.tree-container {
  max-height: 100%;
  overflow-y: auto;
}

.loading-indicator, .empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 30px;
  color: #7f8c8d;
  text-align: center;
  gap: 15px;
}

.loading-indicator i, .empty-state i {
  font-size: 2rem;
  margin-bottom: 10px;
  color: #bdc3c7;
}

.tree-root {
  list-style: none;
  padding: 0;
  margin: 0;
}

.tree-item {
  margin: 0;
  padding: 0;
}

.category-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 15px;
  cursor: pointer;
  transition: all 0.2s ease;
  border-left: 3px solid transparent;
  margin-bottom: 2px;
  border-radius: 0 4px 4px 0;
}

.category-item:hover {
  background-color: #f0f7ff;
}

.category-item.active {
  background-color: #e3f2fd;
  border-left-color: #003a6c;
}

.item-header {
  display: flex;
  align-items: center;
  gap: 10px;
  flex: 1;
}

.item-header i {
  color: #003a6c;
  width: 20px;
  text-align: center;
}

.item-name {
  font-weight: 500;
  color: #333;
}

.item-count {
  font-size: 0.8rem;
  color: #7f8c8d;
  margin-left: 5px;
}

.item-actions {
  display: flex;
  gap: 5px;
  opacity: 0;
  transition: opacity 0.2s ease;
}

.category-item:hover .item-actions {
  opacity: 1;
}

.action-btn {
  background: none;
  border: none;
  width: 28px;
  height: 28px;
  border-radius: 4px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.2s ease;
  color: #7f8c8d;
}

.action-btn:hover {
  background-color: rgba(0, 0, 0, 0.05);
}

.edit-btn:hover {
  color: #003a6c;
}

.delete-btn:hover {
  color: #e74c3c;
}

.add-btn:hover {
  color: #27ae60;
}

.subcategory-list {
  list-style: none;
  padding-left: 20px;
  margin: 0;
}

.subcategory-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 8px 15px;
  cursor: pointer;
  transition: all 0.2s ease;
  border-left: 3px solid transparent;
  margin-bottom: 2px;
  border-radius: 0 4px 4px 0;
}

.subcategory-item:hover {
  background-color: #f0f7ff;
}

.subcategory-item.active {
  background-color: #e3f2fd;
  border-left-color: #003a6c;
}

.subcategory-item .item-header i {
  color: #27ae60;
}

.subcategory-item:hover .item-actions {
  opacity: 1;
}

.empty-subcategory {
  padding: 10px 15px;
  color: #95a5a6;
  font-style: italic;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

/* Tree animations */
.tree-expand-enter-active, .tree-expand-leave-active {
  transition: all 0.3s ease;
  max-height: 1000px;
  overflow: hidden;
}

.tree-expand-enter-from, .tree-expand-leave-to {
  max-height: 0;
  opacity: 0;
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
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.modal-content {
  background-color: white;
  border-radius: 8px;
  width: 100%;
  max-width: 500px;
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
  overflow: hidden;
}

.modal-header {
  padding: 15px 20px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  border-bottom: 1px solid #e0e0e0;
  background-color: #f8f9fa;
}

.modal-header h3 {
  margin: 0;
  color: #003a6c;
  font-size: 1.2rem;
}

.close-btn {
  background: none;
  border: none;
  font-size: 1.2rem;
  cursor: pointer;
  color: #7f8c8d;
  transition: color 0.2s ease;
}

.close-btn:hover {
  color: #e74c3c;
}

.modal-body {
  padding: 20px;
}

.modal-footer {
  padding: 15px 20px;
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  border-top: 1px solid #e0e0e0;
  background-color: #f8f9fa;
}

.form-group {
  margin-bottom: 15px;
}

.form-group label {
  display: block;
  margin-bottom: 5px;
  font-weight: 500;
  color: #2c3e50;
}

.form-control {
  width: 100%;
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 0.9rem;
  transition: border-color 0.2s ease;
}

.form-control:focus {
  outline: none;
  border-color: #003a6c;
  box-shadow: 0 0 0 2px rgba(0, 58, 108, 0.1);
}

.form-control.is-invalid {
  border-color: #e74c3c;
}

.invalid-feedback {
  color: #e74c3c;
  font-size: 0.8rem;
  margin-top: 5px;
}

.btn {
  padding: 8px 16px;
  border-radius: 4px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease;
  border: none;
  font-size: 0.9rem;
  display: inline-flex;
  align-items: center;
  gap: 5px;
}

.btn-primary {
  background-color: #2196F3;
  color: white;
}

.btn-primary:hover {
  background-color: #1976D2;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
}

.btn-secondary {
  background-color: #e0e0e0;
  color: #333;
  border: none;
}

.btn-secondary:hover {
  background-color: #d0d0d0;
}

.btn-outline-primary {
  background-color: transparent;
  border: 1px solid #2196F3;
  color: #2196F3;
}

.btn-outline-primary:hover {
  background-color: rgba(33, 150, 243, 0.1);
}

.btn-outline-danger {
  background-color: transparent;
  border: 1px solid #e74c3c;
  color: #e74c3c;
}

.btn-outline-danger:hover {
  background-color: #fef5f5;
}

.btn-danger {
  background-color: #e74c3c;
  color: white;
  border: none;
}

.btn-danger:hover {
  background-color: #c0392b;
}

/* Empty selection state */
.empty-selection {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100%;
  color: #95a5a6;
  text-align: center;
  padding: 20px;
}

.empty-selection i {
  font-size: 3rem;
  margin-bottom: 20px;
  color: #bdc3c7;
}

.empty-selection h3 {
  margin-bottom: 10px;
  color: #7f8c8d;
}

/* Details panels */
.details-header {
  padding: 15px;
  border-bottom: 1px solid #e0e0e0;
  background-color: #f8f9fa;
  border-radius: 8px 8px 0 0;
}

.details-header h3 {
  margin: 0;
  display: flex;
  align-items: center;
  gap: 10px;
  color: #003a6c;
}

.details-header h3 i {
  color: #003a6c;
}

.header-actions {
  display: flex;
  gap: 10px;
  margin-top: 10px;
}

.details-content {
  padding: 15px;
  flex: 1;
  overflow-y: auto;
}

.subcategories-section, .products-section {
  margin-bottom: 20px;
}

.subcategories-section h4, .products-section h4 {
  font-size: 1rem;
  color: #2c3e50;
  margin-bottom: 10px;
  display: flex;
  align-items: center;
  gap: 10px;
}

.subcategories-grid, .products-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  gap: 15px;
}

.subcategory-card, .product-card {
  background-color: #f8f9fa;
  border-radius: 6px;
  padding: 15px;
  display: flex;
  flex-direction: column;
  gap: 10px;
  transition: all 0.2s ease;
  cursor: pointer;
  border: 1px solid #e0e0e0;
}

.subcategory-card:hover, .product-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 3px 10px rgba(0, 0, 0, 0.05);
  border-color: #003a6c;
}

.subcategory-card.active, .product-card.active {
  background-color: #e3f2fd;
  border-color: #003a6c;
}

.card-header {
  display: flex;
  align-items: center;
  gap: 10px;
}

.card-header i {
  color: #27ae60;
}

.card-title {
  font-weight: 500;
  color: #2c3e50;
  margin: 0;
}

.card-actions {
  display: flex;
  gap: 5px;
  margin-top: 5px;
}

.empty-grid {
  grid-column: 1 / -1;
  padding: 20px;
  text-align: center;
  color: #95a5a6;
  background-color: #f8f9fa;
  border-radius: 6px;
  border: 1px dashed #e0e0e0;
}

/* Delete confirmation modal */
.delete-modal {
  max-width: 450px;
  animation: modalFadeIn 0.3s ease;
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

.delete-message {
  text-align: center;
  font-size: 1.1rem;
  margin: 15px 0;
  color: #333;
}

.warning-icon {
  text-align: center;
  font-size: 3rem;
  color: #ff6b6b;
  margin: 10px 0;
}

.warning-text {
  background-color: #fff8e1;
  padding: 15px;
  border-radius: 8px;
  color: #e67e22;
  margin: 15px 0;
  font-size: 0.95rem;
  line-height: 1.5;
  display: flex;
  align-items: flex-start;
  gap: 10px;
}

.warning-text i {
  font-size: 1.2rem;
  color: #f39c12;
  margin-top: 2px;
}

.modal-actions {
  display: flex;
  justify-content: center;
  gap: 15px;
  margin-top: 25px;
}

.modal-actions .btn {
  min-width: 120px;
  padding: 10px 20px;
  font-weight: 500;
  border-radius: 5px;
  font-size: 0.95rem;
  transition: all 0.2s ease;
}

.modal-actions .btn-secondary {
  background-color: #f5f5f5;
  color: #333;
  border: 1px solid #ddd;
}

.modal-actions .btn-danger {
  background-color: #ff6b6b;
  color: white;
  border: none;
}

.modal-actions .btn-secondary:hover {
  background-color: #e0e0e0;
}

.modal-actions .btn-danger:hover {
  background-color: #e74c3c;
}

/* Responsive styles */
@media (max-width: 768px) {
  .category-content {
    flex-direction: column;
  }
  
  .category-tree-panel, .category-details-panel {
    max-width: none;
    width: 100%;
    height: auto;
    max-height: 50vh;
  }
}

/* Styles pour la section des sous-catégories dans le modal */
.subcategories-section {
  margin-top: 20px;
  border-top: 1px solid #e0e0e0;
  padding-top: 20px;
}

.subcategories-section h4 {
  font-size: 1rem;
  margin-bottom: 5px;
  color: #003a6c;
}

.text-muted {
  color: #7f8c8d;
  font-size: 0.85rem;
  margin-bottom: 15px;
}

.subcategory-list-form {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.subcategory-form-item {
  margin-bottom: 5px;
}

.input-group {
  display: flex;
  gap: 5px;
}

.input-group .form-control {
  flex: 1;
}

.input-group .btn {
  padding: 8px 12px;
}

.add-subcategory-btn {
  margin-top: 10px;
  align-self: flex-start;
}

.d-block {
  display: block;
}

.product-card {
  background-color: #f8f9fa;
  padding: 15px;
  border-radius: 6px;
  display: flex;
  flex-direction: column;
  gap: 8px;
  transition: all 0.2s ease;
  cursor: pointer;
  border: 1px solid #e0e0e0;
}

.product-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 3px 10px rgba(0, 0, 0, 0.05);
  border-color: #003a6c;
}

.product-details {
  display: flex;
  justify-content: space-between;
  font-size: 0.85rem;
  margin-top: 5px;
}

.product-price {
  font-weight: 600;
  color: #27ae60;
}

.product-stock {
  color: #7f8c8d;
}
</style>