<template>
  <div class="notifications-wrapper">
    <Notification
      v-for="notification in notifications"
      :key="notification.id"
      :show="notification.show"
      :title="notification.title"
      :message="notification.message"
      :type="notification.type"
      :icon="notification.icon"
      :color="notification.color"
      :duration="notification.duration"
      :position="notification.position"
      :auto-close="notification.autoClose"
      @close="closeNotification(notification.id)"
    />
  </div>
</template>

<script setup>
import { onMounted, onUnmounted } from 'vue';
import Notification from './Notification.vue';
import notificationService from '@/services/notificationService';

// Récupérer les notifications depuis le service
const notifications = notificationService.getNotifications();

// Méthode pour fermer une notification
const closeNotification = (id) => {
  notificationService.close(id);
};

// Exposer le service de notification globalement pour un accès facile
onMounted(() => {
  window.$notification = notificationService;
});

onUnmounted(() => {
  delete window.$notification;
});
</script>

<style scoped>
.notifications-wrapper {
  position: fixed;
  z-index: 9999;
  pointer-events: none;
  width: 100%;
  height: 100%;
  top: 0;
  left: 0;
  overflow: hidden;
}
</style>