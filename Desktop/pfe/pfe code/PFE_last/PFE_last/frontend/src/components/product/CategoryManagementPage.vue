<template>
  <div class="category-page">
    <div class="page-header">
      <h2 class="animated-title">Gestion des Catégories</h2>
    </div>
    
    <CategoryManagement 
      :show-modal="showCategoryModal"
      @category-created="handleCategoryCreated" 
      @close-modal="showCategoryModal = false"
      ref="categoryManagementRef"
    />
  </div>
</template>

<script setup>
import { ref } from 'vue';
import CategoryManagement from '@/components/product/CategoryManagement.vue';

// State
const showCategoryModal = ref(false);
const categoryManagementRef = ref(null);

// Handle category created action
const handleCategoryCreated = () => {
  showCategoryModal.value = false;
};

// Open category modal
const openCategoryModal = () => {
  if (categoryManagementRef.value) {
    categoryManagementRef.value.openCategoryModal();
  } else {
    showCategoryModal.value = true;
  }
};
</script>

<style scoped>
.category-page {
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.page-header {
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
  background: linear-gradient(90deg, #2196F3, #1976D2);
  border-radius: 3px;
}

.add-category-btn {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 10px 16px;
  background-color: #2196F3;
  color: white;
  border: none;
  border-radius: 4px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
}

.add-category-btn:hover {
  background-color: #1976D2;
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
}

.add-category-btn i {
  font-size: 0.9rem;
}
</style>