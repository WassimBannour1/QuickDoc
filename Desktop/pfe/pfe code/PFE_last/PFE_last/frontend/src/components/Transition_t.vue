<template>
    <transition name="page-transition" mode="out-in">
      <slot></slot>
    </transition>
  </template>
  
  <script setup>
  // No additional script needed for this component
  </script>
  
  <style scoped>
  .page-transition-enter-active,
  .page-transition-leave-active {
    transition: opacity 0.5s ease, transform 0.5s ease;
  }
  
  .page-transition-enter-from,
  .page-transition-leave-to {
    opacity: 0;
    transform: translateY(20px);
  }
  
  .page-transition-enter-to,
  .page-transition-leave-from {
    opacity: 1;
    transform: translateY(0);
  }
  </style>