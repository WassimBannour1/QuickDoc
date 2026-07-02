<template>
  <!-- Ajoutez ce bouton dans votre interface -->
  <button @click="handleLogout" class="logout-btn">
    <span>Se déconnecter</span>
  </button>
</template>

<script setup>
import { useRouter } from 'vue-router';
import { useMainStore } from '@/stores';

const router = useRouter();
const store = useMainStore();

const handleLogout = () => {
  store.logout();
  router.push('/connexion');
};
</script>

<style scoped>
.logout-btn {
  padding: 10px 20px;
  background-color: #dc3545;
  color: white;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  transition: background-color 0.3s;
}

.logout-btn:hover {
  background-color: #c82333;
}
</style>