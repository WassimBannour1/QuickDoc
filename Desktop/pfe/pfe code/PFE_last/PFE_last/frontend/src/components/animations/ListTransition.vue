<template>
  <transition-group
    :name="name"
    :tag="tag"
    :appear="appear"
    v-bind="$attrs"
  >
    <slot></slot>
  </transition-group>
</template>

<script setup>
import { defineProps } from 'vue';

const props = defineProps({
  name: {
    type: String,
    default: 'list'
  },
  tag: {
    type: String,
    default: 'div'
  },
  appear: {
    type: Boolean,
    default: false
  }
});
</script>

<style scoped>
/* List fade transition */
.list-enter-active,
.list-leave-active {
  transition: all 0.3s ease;
}

.list-enter-from,
.list-leave-to {
  opacity: 0;
  transform: translateY(30px);
}

/* Staggered list transition */
.stagger-enter-active {
  transition: all 0.3s ease;
  transition-delay: calc(0.05s * var(--i));
}

.stagger-leave-active {
  transition: all 0.3s ease;
}

.stagger-enter-from,
.stagger-leave-to {
  opacity: 0;
  transform: translateY(30px);
}

/* Slide list transition */
.slide-list-enter-active,
.slide-list-leave-active {
  transition: all 0.3s ease;
}

.slide-list-enter-from {
  opacity: 0;
  transform: translateX(30px);
}

.slide-list-leave-to {
  opacity: 0;
  transform: translateX(-30px);
}

/* Fade scale list transition */
.fade-scale-list-enter-active,
.fade-scale-list-leave-active {
  transition: all 0.3s ease;
}

.fade-scale-list-enter-from,
.fade-scale-list-leave-to {
  opacity: 0;
  transform: scale(0.9);
}
</style>