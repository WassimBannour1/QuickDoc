import { createRouter, createWebHistory } from 'vue-router'
import SignUp from '../components/SignUp.vue'
import { useMainStore } from '../stores'
import PaieMent from '../components/PaieMent.vue'
const router = createRouter({
  history: createWebHistory(),
  routes: [
    {
      path: '/',
      redirect: '/accueil'
    },

    {
      path: '/accueil', 
      name: 'Home',
      component: () => import('@/components/Home_H.vue')
    },
    {
      path: '/inscription',
      name: 'SignUp',
      component: SignUp
    },
    {
      path: '/connexion',
      name: 'SignIn',
      component: () => import('../components/SignIn.vue')
    },
    {
      path: '/mot-de-passe-oublie',
      name: 'ForgotPassword',
      component: () => import('../components/mdp_oublier.vue')
    },
    {
      path: '/nouveau-mot-de-passe/:token',
      name: 'ResetPassword',
      component: () => import('../components/new_password.vue')
    },
    {
      path: '/verification-code',
      name: 'VerifyResetCode',
      component: () => import('../components/validate_code.vue')
    },
    {
      path: '/tableau-de-bord',
      name: 'Dashboard',
      component: () => import('@/components/Dashboard.vue'),
      meta: { requiresAuth: true, role: 'client' }
    },
    {
      path: '/payment',
      name: 'Payment',
      component: PaieMent,
      meta: { requiresAuth: true }
    },
    {
      path: '/payment-success',
      name: 'PaymentSuccess',
      component: () => import('@/components/PaymentSuccess.vue')
    },
    {
      path: '/payment-cancel',
      name: 'PaymentCancel',
      component: () => import('@/components/PaymentCancel.vue')
    },
    {
      path: '/admin',
      name: 'admin',
      component: () => import('@/components/admin/SuperAdmin.vue'),
      meta: { requiresAuth: true, role: 'admin' }
    },
    {
      path: '/admin/edit-template/:id',
      name: 'admin-edit-template',
      component: () => import('@/views/TemplateManagementView.vue'),
      props: route => ({ 
        initialEditMode: true, 
        templateIdToEdit: parseInt(route.params.id),
        adminMode: true
      }),
      meta: { requiresAuth: true, role: 'admin' }
    },
    {
      path: '/admin-entreprise',
      name: 'admin-entreprise',
      component: () => import('@/components/InterfaceAdminEntreprise.vue'),
      meta: { requiresAuth: true, roles: ['admin entreprise', 'enterprise_admin'] },
      // Ajouter des routes enfants pour gérer les différentes vues dans l'interface admin
      children: [
        {
          path: '',
          name: 'accueil',
          component: () => import('@/components/InterfaceAdminEntreprise.vue')
        },
        {
          path: 'create-template',
          name: 'create-template',
          component: () => import('@/views/TemplateManagementView.vue'),
          meta: { standalone: true }
        },
        {
          path: 'edit-template/:id',
          name: 'edit-template',
          component: () => import('@/views/TemplateManagementView.vue'),
          props: route => ({ 
            initialEditMode: true, 
            templateIdToEdit: parseInt(route.params.id) 
          }),
          meta: { standalone: true }
        },
        {
          path: 'predefined-templates',
          name: 'predefined-templates',
          component: () => import('@/views/PredefinedTemplatesView.vue'),
          meta: { standalone: true }
        },
        {
          path: 'custom-templates',
          name: 'custom-templates',
          component: () => import('@/views/CustomTemplatesView.vue'),
          meta: { standalone: true }
        },
        {
          path: 'create-client',
          name: 'create-client',
          component: () => import('@/components/InterfaceAdminEntreprise.vue')
        },
        {
          path: 'client-list',
          name: 'client-list',
          component: () => import('@/components/InterfaceAdminEntreprise.vue')
        },
        {
          path: 'edit-client/:id',
          name: 'edit-client',
          component: () => import('@/components/ClientEditForm.vue'),
          props: true,
          meta: { standalone: true }
        },
        {
          path: 'import-export',
          name: 'import-export',
          component: () => import('@/components/InterfaceAdminEntreprise.vue')
        },
        {
          path: 'categories',
          name: 'categories',
          component: () => import('@/components/product/CategoryManagementPage.vue')
        },
        {
          path: 'product-list',
          name: 'product-list',
          component: () => import('@/components/product/ProductListPage.vue')
        },
        {
          path: 'product-create',
          name: 'product-create',
          component: () => import('@/components/product/ProductCreatePage.vue')
        },
        {
          path: 'stock',
          name: 'stock',
          component: () => import('@/components/product/StockManagementPage.vue')
        },
        {
          path: 'scraping',
          name: 'scraping',
          component: () => import('@/components/InterfaceAdminEntreprise.vue')
        },
        {
          path: 'edit-product/:id',
          name: 'edit-product',
          component: () => import('@/components/product/ProductEditForm.vue'),
          props: true,
          meta: { standalone: true }
        },
        /* Removing duplicate product-create route */
        {
          path: 'document-upload',
          name: 'document-upload',
          component: () => import('@/components/InterfaceAdminEntreprise.vue')
        },
        {
          path: 'ocr-extraction',
          name: 'ocr-extraction',
          component: () => import('@/components/InterfaceAdminEntreprise.vue')
        },
        {
          path: 'manual-correction',
          name: 'manual-correction',
          component: () => import('@/components/InterfaceAdminEntreprise.vue')
        },
        {
          path: 'ocr-ia',
          name: 'ocr-ia',
          component: () => import('@/components/InterfaceAdminEntreprise.vue')
        },
        {
          path: 'select-template',
          name: 'select-template',
          component: () => import('@/components/InterfaceAdminEntreprise.vue')
        },
        {
          path: 'auto-fill',
          name: 'auto-fill',
          component: () => import('@/components/InterfaceAdminEntreprise.vue')
        },
        {
          path: 'manual-fill',
          name: 'manual-fill',
          component: () => import('@/components/InterfaceAdminEntreprise.vue')
        },
        {
          path: 'preview-validate',
          name: 'preview-validate',
          component: () => import('@/components/InterfaceAdminEntreprise.vue')
        },
        {
          path: 'save-integrate',
          name: 'save-integrate',
          component: () => import('@/components/InterfaceAdminEntreprise.vue')
        },
        {
          path: 'document-search',
          name: 'document-search',
          component: () => import('@/components/document/DocumentSearch.vue')
        },
        {
          path: 'document-filter',
          name: 'document-filter',
          component: () => import('@/components/document/DocumentFilter.vue')
        },
        {
          path: 'document-preview',
          name: 'document-preview',
          component: () => import('@/components/document/DocumentPreview.vue')
        },
        {
          path: 'document-export',
          name: 'document-export',
          component: () => import('@/components/document/DocumentExport.vue')
        },
        {
          path: 'document-email',
          name: 'document-email',
          component: () => import('@/components/document/DocumentEmail.vue')
        },
        {
          path: 'factures-management',
          name: 'factures-management',
          component: () => import('@/components/InterfaceAdminEntreprise.vue')
        },
        {
          path: 'devis-management',
          name: 'devis-management',
          component: () => import('@/components/InterfaceAdminEntreprise.vue')
        }
      ]
    },
    // Profile functionality is now directly integrated into Dashboard
    // No separate profile route needed
    {
      path: '/:pathMatch(.*)*',
      redirect: '/connexion'
    }
  ]
})

// Navigation guard to check authentication for protected routes
router.beforeEach((to, from, next) => {
  console.log('Navigation to:', to.path)
  
  // Check if the route requires authentication
  if (to.matched.some(record => record.meta.requiresAuth)) {
    // Check if user is authenticated - check both token names
    const token = localStorage.getItem('token') || localStorage.getItem('auth_token')
    if (!token) {
      console.log('Authentication required, redirecting to login')
      next({
        path: '/connexion',
        query: { redirect: to.fullPath }
      })
      return
    }
    
    // Get user data from store if available
    const store = useMainStore()
    if (!store.user) {
      console.log('User data required, redirecting to login')
      next({
        path: '/connexion',
        query: { redirect: to.fullPath }
      })
      return
    }
    
    // Check if the route requires specific roles
    if (to.meta.role && store.user.role !== to.meta.role) {
      console.log(`Role ${to.meta.role} required, user has role ${store.user.role}`)
      // Redirect to appropriate dashboard based on user role
      if (store.user.role === 'admin entreprise' || store.user.role === 'enterprise_admin') {
        next({ path: '/admin-entreprise' })
      } else if (store.user.role === 'client') {
        next({ path: '/tableau-de-bord' })
      } else {
        // Default fallback for unsupported roles
        next({ path: '/connexion' })
      }
      return
    }
    
    // Check if the route requires one of multiple roles
    if (to.meta.roles && Array.isArray(to.meta.roles) && !to.meta.roles.includes(store.user.role)) {
      console.log(`One of roles [${to.meta.roles.join(', ')}] required, user has role ${store.user.role}`)
      // Redirect to appropriate dashboard based on user role
      if (store.user.role === 'admin entreprise' || store.user.role === 'enterprise_admin') {
        next({ path: '/admin-entreprise' })
      } else if (store.user.role === 'client') {
        next({ path: '/tableau-de-bord' })
      } else {
        // Default fallback for unsupported roles
        next({ path: '/connexion' })
      }
      return
    }
  }
  
  // Redirect based on user role
  const store = useMainStore()
  if (store.user && to.path === '/tableau-de-bord') {
    if (store.user.role === 'admin') {
      console.log('Admin detected, redirecting to admin interface')
      next({ path: '/admin' })
      return
    } else if (store.user.role === 'admin entreprise' || store.user.role === 'enterprise_admin') {
      console.log('Admin entreprise detected, redirecting to admin interface')
      next({ path: '/admin-entreprise' })
      return
    } else if (store.user.role !== 'client' && store.user.role !== 'admin entreprise' && store.user.role !== 'enterprise_admin' && store.user.role !== 'admin') {
      // Handle other roles if needed
      console.log('Unsupported role, redirecting to login')
      next({ path: '/connexion' })
      return
    }
  }
  
  // Redirection automatique depuis la page de connexion si l'utilisateur est déjà connecté
  if (store.user && (to.path === '/connexion' || to.path === '/inscription')) {
    console.log('User already logged in, redirecting based on role')
    if (store.user.role === 'admin') {
      next({ path: '/admin' })
    } else if (store.user.role === 'admin entreprise' || store.user.role === 'enterprise_admin') {
      next({ path: '/admin-entreprise' })
    } else if (store.user.role === 'client') {
      next({ path: '/tableau-de-bord' })
    } else {
      next({ path: '/connexion' })
    }
    return
  }
  
  next()
})

export default router
