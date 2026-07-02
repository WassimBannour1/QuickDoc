/**
 * Service de notification pour gérer les notifications dans toute l'application
 */

import { ref, reactive } from 'vue';

// État global des notifications
const notifications = reactive([]);
const notificationCounter = ref(0);

export default {
  /**
   * Affiche une notification
   * @param {Object} notification - Configuration de la notification
   * @param {String} notification.type - Type de notification ('success', 'error', 'warning', 'info')
   * @param {String} notification.title - Titre de la notification
   * @param {String} notification.message - Message de la notification
   * @param {String} notification.icon - Icône FontAwesome (sans le préfixe fa-)
   * @param {String} notification.color - Couleur personnalisée (code hexadécimal)
   * @param {Number} notification.duration - Durée d'affichage en ms
   * @param {String} notification.position - Position ('top-right', 'top-left', etc.)
   * @returns {Number} - ID de la notification créée
   */
  show(notification) {
    // Valeurs par défaut
    const defaultNotification = {
      type: 'success',
      title: 'Notification',
      message: '',
      icon: 'check-circle',
      color: '#1e3a8a', // Couleur de la barre latérale (bleu foncé)
      duration: 5000,
      position: 'top-right',
      autoClose: true
    };

    // Fusionner avec les valeurs par défaut
    const notificationConfig = { ...defaultNotification, ...notification };
    
    // Définir l'icône en fonction du type si non spécifiée
    if (!notification.icon) {
      const icons = {
        success: 'check-circle',
        error: 'exclamation-circle',
        warning: 'exclamation-triangle',
        info: 'info-circle'
      };
      notificationConfig.icon = icons[notificationConfig.type] || 'bell';
    }

    // Générer un ID unique pour cette notification
    const id = ++notificationCounter.value;
    
    // Ajouter la notification à la liste
    notifications.push({
      id,
      ...notificationConfig,
      show: true
    });

    // Supprimer automatiquement après la durée spécifiée
    if (notificationConfig.autoClose && notificationConfig.duration > 0) {
      setTimeout(() => {
        this.close(id);
      }, notificationConfig.duration);
    }

    return id;
  },

  /**
   * Ferme une notification spécifique
   * @param {Number} id - ID de la notification à fermer
   */
  close(id) {
    const index = notifications.findIndex(n => n.id === id);
    if (index !== -1) {
      // Marquer comme masquée
      notifications[index].show = false;
      
      // Supprimer après l'animation
      setTimeout(() => {
        const removeIndex = notifications.findIndex(n => n.id === id);
        if (removeIndex !== -1) {
          notifications.splice(removeIndex, 1);
        }
      }, 300); // Durée de l'animation
    }
  },

  /**
   * Ferme toutes les notifications
   */
  closeAll() {
    // Copier les IDs pour éviter les problèmes lors de la suppression
    const ids = notifications.map(n => n.id);
    ids.forEach(id => this.close(id));
  },

  /**
   * Raccourcis pour les types de notifications courants
   */
  success(message, options = {}) {
    return this.show({ type: 'success', message, ...options });
  },

  error(message, options = {}) {
    return this.show({ type: 'error', message, ...options });
  },

  warning(message, options = {}) {
    return this.show({ type: 'warning', message, ...options });
  },

  info(message, options = {}) {
    return this.show({ type: 'info', message, ...options });
  },

  /**
   * Obtient la liste des notifications actives
   * @returns {Array} - Liste des notifications
   */
  getNotifications() {
    return notifications;
  }
};