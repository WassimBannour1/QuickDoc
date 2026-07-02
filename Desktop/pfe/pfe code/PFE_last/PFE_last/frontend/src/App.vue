<template>
  <div id="app">
    <FadeTransition name="page-transition" mode="out-in" appear>
      <router-view></router-view>
    </FadeTransition>
    <NotificationContainer />
  </div>
</template>

<script setup>
import FadeTransition from './components/animations/FadeTransition.vue'
import NotificationContainer from './components/ui/NotificationContainer.vue'
import { useMainStore } from './stores'
import api from './services/api'
import { onMounted } from 'vue'

const store = useMainStore()

// Fonction pour restaurer la session utilisateur au chargement de l'application
const restoreUserSession = async () => {
  // Vérifier si un token existe dans le localStorage
  const token = localStorage.getItem('token')
  if (token) {
    try {
      // Si l'utilisateur n'est pas déjà dans le store, essayer de récupérer ses informations
      if (!store.user) {
        // Faire une requête pour récupérer les informations de l'utilisateur
        const response = await api.get('/api/auth/me')
        if (response.data && response.data.user) {
          store.setUser(response.data.user)
          console.log('Session utilisateur restaurée avec succès')
        }
      }
    } catch (error) {
      console.error('Erreur lors de la restauration de la session:', error)
      // En cas d'erreur (token invalide ou expiré), supprimer le token
      localStorage.removeItem('token')
      store.logout()
    }
  }
}

// Exécuter la restauration de session au montage du composant
onMounted(() => {
  restoreUserSession()
})
</script>

<style>
#app {
  font-family: Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  width: 100%;
  min-height: 100vh;
}

* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}
</style>
