<template>
  <transition name="notification-fade">
    <div v-if="show" class="notification-wrapper" :class="position">
      <div class="notification-container" :style="{ borderColor: color }">
        <div class="notification-icon" :style="{ backgroundColor: color }">
          <i :class="`fas fa-${icon}`"></i>
        </div>
        <div class="notification-content">
          <h3 class="notification-title">{{ title }}</h3>
          <p class="notification-message">{{ message }}</p>
        </div>
        <button class="notification-close" @click="close">
          <i class="fas fa-times"></i>
        </button>
      </div>
    </div>
  </transition>
</template>

<script setup>
import { ref, onMounted, onUnmounted, watch } from 'vue';

const props = defineProps({
  show: {
    type: Boolean,
    default: false
  },
  title: {
    type: String,
    default: 'Notification'
  },
  message: {
    type: String,
    default: ''
  },
  type: {
    type: String,
    default: 'success',
    validator: (value) => ['success', 'error', 'warning', 'info'].includes(value)
  },
  icon: {
    type: String,
    default: 'check-circle'
  },
  color: {
    type: String,
    default: '#1e3a8a' // Couleur de la barre latérale (bleu foncé)
  },
  duration: {
    type: Number,
    default: 5000
  },
  position: {
    type: String,
    default: 'top-right',
    validator: (value) => ['top-right', 'top-left', 'bottom-right', 'bottom-left', 'top-center', 'bottom-center'].includes(value)
  },
  autoClose: {
    type: Boolean,
    default: true
  }
});

const emit = defineEmits(['close']);

let timer = null;

const close = () => {
  emit('close');
};

const startTimer = () => {
  if (props.autoClose && props.duration > 0) {
    timer = setTimeout(() => {
      close();
    }, props.duration);
  }
};

const clearTimer = () => {
  if (timer) {
    clearTimeout(timer);
    timer = null;
  }
};

watch(() => props.show, (newValue) => {
  if (newValue) {
    clearTimer();
    startTimer();
  } else {
    clearTimer();
  }
});

onMounted(() => {
  if (props.show) {
    startTimer();
  }
});

onUnmounted(() => {
  clearTimer();
});
</script>

<style scoped>
.notification-wrapper {
  position: fixed;
  z-index: 9999;
  display: flex;
  flex-direction: column;
  gap: 10px;
  max-width: 400px;
  width: 100%;
  pointer-events: none;
}

.notification-wrapper.top-right {
  top: 20px;
  right: 20px;
}

.notification-wrapper.top-left {
  top: 20px;
  left: 20px;
}

.notification-wrapper.bottom-right {
  bottom: 20px;
  right: 20px;
}

.notification-wrapper.bottom-left {
  bottom: 20px;
  left: 20px;
}

.notification-wrapper.top-center {
  top: 20px;
  left: 50%;
  transform: translateX(-50%);
}

.notification-wrapper.bottom-center {
  bottom: 20px;
  left: 50%;
  transform: translateX(-50%);
}

.notification-container {
  display: flex;
  align-items: flex-start;
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  overflow: hidden;
  border-left: 4px solid;
  pointer-events: auto;
  width: 100%;
}

.notification-icon {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 50px;
  height: 50px;
  color: white;
  flex-shrink: 0;
}

.notification-content {
  flex: 1;
  padding: 12px;
}

.notification-title {
  margin: 0 0 5px 0;
  font-size: 16px;
  font-weight: 600;
  color: #333;
}

.notification-message {
  margin: 0;
  font-size: 14px;
  color: #666;
  line-height: 1.4;
}

.notification-close {
  background: none;
  border: none;
  color: #999;
  cursor: pointer;
  padding: 10px;
  font-size: 14px;
  transition: color 0.2s;
}

.notification-close:hover {
  color: #333;
}

/* Animation */
.notification-fade-enter-active,
.notification-fade-leave-active {
  transition: all 0.3s ease;
}

.notification-fade-enter-from {
  opacity: 0;
  transform: translateX(30px);
}

.notification-fade-leave-to {
  opacity: 0;
  transform: translateX(30px);
}
</style>