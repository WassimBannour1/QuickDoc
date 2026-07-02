import { defineConfig } from 'vite';
import vue from '@vitejs/plugin-vue';

export default defineConfig({
  plugins: [vue()],
  server: {
    watch: {
      usePolling: true, // Évite les problèmes de cache en dev
    },
    host: true, // Permet d'accéder au serveur sur le réseau local
    port: 5173, // Change si nécessaire
  },
  resolve: {
    alias: {
      '@': '/src', // Assure que les imports fonctionnent correctement
    },
  },
});

