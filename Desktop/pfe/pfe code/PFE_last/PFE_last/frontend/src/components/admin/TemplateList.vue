<template>
  <div class="admin-template-list">
    <BaseTemplateList 
      :documentType="documentType" 
      :templateType="templateType"
      @template-selected="handleTemplateSelected"
      @edit-template="handleEditTemplate"
      @create-new="handleCreateNew"
      @go-back="handleGoBack"
    />
  </div>
</template>

<script>
import BaseTemplateList from '@/components/templates/TemplateList.vue';
import { useRouter } from 'vue-router';

export default {
  name: 'AdminTemplateList',
  components: {
    BaseTemplateList
  },
  props: {
    documentType: {
      type: String,
      default: 'facture'
    },
    templateType: {
      type: String,
      default: 'predefined'
    }
  },
  setup() {
    const router = useRouter();
    
    return { router };
  },
  methods: {
    handleTemplateSelected(template) {
      this.$emit('template-selected', template);
    },
    handleEditTemplate(template) {
      // Use Vue Router to navigate to the template editor
      console.log('Edit template in admin:', template);
      this.router.push(`/admin/edit-template/${template.id}`);
    },
    handleCreateNew() {
      // Redirect to template creation
      this.$parent.$parent.activeTab = 'create-template';
    },
    handleGoBack() {
      // For admin, stay on the same page
      this.$parent.$parent.activeTab = 'templates';
    }
  }
};
</script>

<style scoped>
.admin-template-list {
  width: 100%;
}
</style> 