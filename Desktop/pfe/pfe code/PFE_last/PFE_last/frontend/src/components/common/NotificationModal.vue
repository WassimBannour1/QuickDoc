<template>
  <div v-if="visible" class="notification-modal-overlay" @click="closeOnOverlayClick && close()">
    <div class="notification-modal" :class="type" @click.stop>
      <div class="notification-header">
        <span class="notification-title">{{ title }}</span>
        <button class="close-button" @click="close">&times;</button>
      </div>
      <div class="notification-content">
        {{ message }}
      </div>
      <div class="notification-actions" v-if="showActions">
        <button class="action-button confirm-button" @click="confirm">{{ confirmText }}</button>
        <button class="action-button cancel-button" @click="close">{{ cancelText }}</button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'NotificationModal',
  props: {
    visible: {
      type: Boolean,
      default: false
    },
    title: {
      type: String,
      default: 'Notification'
    },
    message: {
      type: String,
      required: true
    },
    type: {
      type: String,
      default: 'info',
      validator: (value) => ['success', 'error', 'warning', 'info'].includes(value)
    },
    showActions: {
      type: Boolean,
      default: false
    },
    confirmText: {
      type: String,
      default: 'Confirmer'
    },
    cancelText: {
      type: String,
      default: 'Annuler'
    },
    closeOnOverlayClick: {
      type: Boolean,
      default: true
    }
  },
  methods: {
    close() {
      this.$emit('close');
    },
    confirm() {
      this.$emit('confirm');
      this.close();
    }
  }
};
</script>

<style scoped>
.notification-modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
  animation: fadeIn 0.3s ease;
}

.notification-modal {
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
  width: 90%;
  max-width: 450px;
  overflow: hidden;
  animation: slideIn 0.3s ease;
}

.notification-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px 20px;
  border-bottom: 1px solid #eaedf3;
}

.notification-title {
  font-weight: 600;
  font-size: 1.1rem;
  color: #2d3748;
}

.close-button {
  background: none;
  border: none;
  font-size: 1.5rem;
  cursor: pointer;
  color: #718096;
  transition: color 0.2s ease;
}

.close-button:hover {
  color: #2d3748;
}

.notification-content {
  padding: 20px;
  font-size: 1rem;
  line-height: 1.5;
  color: #4a5568;
}

.notification-actions {
  display: flex;
  justify-content: flex-end;
  padding: 15px 20px;
  border-top: 1px solid #eaedf3;
  gap: 10px;
}

.action-button {
  padding: 8px 16px;
  border-radius: 4px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease;
  border: none;
}

.confirm-button {
  background-color: #002446;
  color: white;
}

.confirm-button:hover {
  background-color: #003a6c;
}

.cancel-button {
  background-color: #e2e8f0;
  color: #4a5568;
}

.cancel-button:hover {
  background-color: #cbd5e0;
}

/* Types de notification */
.success .notification-header {
  background-color: #ebf7ed;
  color: #276749;
}

.error .notification-header {
  background-color: #fdf2f2;
  color: #c53030;
}

.warning .notification-header {
  background-color: #fffaf0;
  color: #c05621;
}

.info .notification-header {
  background-color: #ebf8ff;
  color: #2b6cb0;
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

@keyframes slideIn {
  from { transform: translateY(-20px); opacity: 0; }
  to { transform: translateY(0); opacity: 1; }
}

/* Responsive */
@media (max-width: 640px) {
  .notification-modal {
    width: 95%;
    max-width: none;
  }
  
  .notification-actions {
    flex-direction: column;
  }
  
  .action-button {
    width: 100%;
    margin-bottom: 8px;
  }
}
</style>