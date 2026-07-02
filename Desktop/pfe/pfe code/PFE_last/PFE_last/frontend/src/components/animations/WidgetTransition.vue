<template>
  <transition
    :name="name"
    :appear="appear"
    v-bind="$attrs"
  >
    <slot></slot>
  </transition>
</template>

<script setup>
import { defineProps } from 'vue';

const props = defineProps({
  name: {
    type: String,
    default: 'widget'
  },
  appear: {
    type: Boolean,
    default: false
  },
  delay: {
    type: Number,
    default: 0
  }
});
</script>

<style scoped>
/* Widget fade in transition */
.widget-enter-active {
  transition: all 0.5s ease;
  transition-delay: calc(var(--delay, 0) * 0.1s);
}

.widget-leave-active {
  transition: all 0.3s ease;
}

.widget-enter-from,
.widget-leave-to {
  opacity: 0;
  transform: translateY(30px);
}

/* Widget slide in from right */
.widget-right-enter-active {
  transition: all 0.5s ease;
  transition-delay: calc(var(--delay, 0) * 0.1s);
}

.widget-right-leave-active {
  transition: all 0.3s ease;
}

.widget-right-enter-from,
.widget-right-leave-to {
  opacity: 0;
  transform: translateX(30px);
}

/* Widget slide in from left */
.widget-left-enter-active {
  transition: all 0.5s ease;
  transition-delay: calc(var(--delay, 0) * 0.1s);
}

.widget-left-leave-active {
  transition: all 0.3s ease;
}

.widget-left-enter-from,
.widget-left-leave-to {
  opacity: 0;
  transform: translateX(-30px);
}

/* Widget scale transition */
.widget-scale-enter-active {
  transition: all 0.5s ease;
  transition-delay: calc(var(--delay, 0) * 0.1s);
}

.widget-scale-leave-active {
  transition: all 0.3s ease;
}

.widget-scale-enter-from,
.widget-scale-leave-to {
  opacity: 0;
  transform: scale(0.8);
}
</style>