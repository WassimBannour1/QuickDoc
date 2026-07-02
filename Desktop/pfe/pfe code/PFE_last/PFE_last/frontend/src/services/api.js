import axios from 'axios';
import { useMainStore } from '@/stores';

const api = axios.create({
    baseURL: 'http://localhost:5000', // L'URL de ton backend
});

// Intercepteur pour ajouter le token d'authentification à chaque requête
api.interceptors.request.use(config => {
    const token = localStorage.getItem('token');
    if (token) {
        config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
}, error => {
    return Promise.reject(error);
});

// Intercepteur pour gérer les erreurs de réponse
api.interceptors.response.use(
    response => {
        // Si la réponse contient des données utilisateur, mettre à jour le store
        if (response.data && response.data.user) {
            const store = useMainStore();
            store.setUser(response.data.user);
        }
        return response;
    },
    error => {
        if (error.response && error.response.status === 401) {
            // Rediriger vers la page de connexion si le token est expiré ou invalide
            console.log('Session expirée, redirection vers la page de connexion');
            localStorage.removeItem('token');
            const store = useMainStore();
            store.logout(); // Utiliser la méthode logout du store pour nettoyer les données
            window.location.href = '/connexion';
        }
        return Promise.reject(error);
    }
);

export default api;
