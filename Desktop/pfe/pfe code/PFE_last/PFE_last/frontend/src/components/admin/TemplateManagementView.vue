<template>
  <div class="template-management-view">
    <TemplateManager 
      :initial-edit-mode="editMode" 
      :template-id-to-edit="templateId" 
      :admin-mode="true"
    />
  </div>
</template>

<script>
import TemplateManager from '@/components/templates/TemplateManager.vue';

export default {
  name: 'TemplateManagementView',
  components: {
    TemplateManager
  },
  data() {
    return {
      editMode: false,
      templateId: null
    };
  },
  watch: {
    // Watch for changes to templateId to reinitialize the component
    templateId(newVal) {
      console.log('TemplateManagementView: templateId changed to', newVal);
      // The TemplateManager component will handle the initialization based on props
    }
  },
  created() {
    console.log('Admin TemplateManagementView created');
  }
};
</script>

<style scoped>
.template-management-view {
  min-height: 100vh;
  background-color: #f5f5f5;
}
</style> 