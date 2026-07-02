<template>
  <div class="client-management">
    <!-- Header with title and action button -->
    <div class="client-header">
      <h2 class="animated-title">Gestion des Clients</h2>
      <div class="header-actions">
        <button v-if="activeView === 'list'" class="btn btn-primary" @click="activeView = 'create'">
          <i class="fas fa-plus"></i> Nouveau Client
        </button>
        <button v-else class="btn btn-secondary" @click="activeView = 'list'">
          <i class="fas fa-arrow-left"></i> Retour à la liste
        </button>
      </div>
    </div>

    <!-- Client List View -->
    <ClientList 
      v-if="activeView === 'list'" 
      @edit-client="handleEditClient" 
      @create-client="activeView = 'create'"
      :managedByParent="true"
    />

    <!-- Client Create View -->
    <ClientCreate v-if="activeView === 'create'" @client-created="handleClientCreated" @cancel="activeView = 'list'" />
    
    <!-- Client Edit View -->
    <ClientEditForm v-if="activeView === 'edit'" :id="clientToEdit?.id" @client-updated="handleClientUpdated" />
  </div>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue';
import { useRoute } from 'vue-router';
import ClientList from '@/components/ClientList.vue';
import ClientCreate from '@/components/ClientCreate.vue';
import ClientEditForm from '@/components/ClientEditForm.vue';

// Props to control which view to show initially
const props = defineProps({
  initialView: {
    type: String,
    default: 'list',
    validator: (value) => ['list', 'create', 'edit'].includes(value)
  }
});

// State
const activeView = ref(props.initialView);
const clientToEdit = ref(null);
const route = useRoute();

// Watch for changes in the initialView prop
watch(() => props.initialView, (newView) => {
  activeView.value = newView;
});

// Handle client edit action
const handleEditClient = (client) => {
  clientToEdit.value = client;
  activeView.value = 'edit';
};

// Handle client created action
const handleClientCreated = () => {
  clientToEdit.value = null;
  activeView.value = 'list';
};

// Handle client updated action
const handleClientUpdated = () => {
  clientToEdit.value = null;
  activeView.value = 'list';
};

// Initialize component based on route
onMounted(() => {
  // Check if we're on a specific route that should show the create view
  if (route.name === 'create-client') {
    activeView.value = 'create';
  } else if (route.name === 'edit-client' && route.params.id) {
    // If we're on the edit route, set the client ID and switch to edit view
    clientToEdit.value = { id: route.params.id };
    activeView.value = 'edit';
  }
});
</script>

<style scoped>
.client-management {
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.client-header {
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