<template>
  <div class="stock-management-page">
    <div class="page-header">
      <h2 class="animated-title">Gestion des Stocks</h2>
    </div>
    
    <StockManagement />
  </div>
</template>

<script setup>
import StockManagement from '@/components/product/StockManagement.vue';
</script>

<style scoped>
.stock-management-page {
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
  background: linear-gradient(90deg, #3498db, #2980b9);
  border-radius: 3px;
}
</style>