import { createRouter, createWebHashHistory } from 'vue-router'
import home from '@/components/home.vue'
import overview from '@/components/overview.vue'
import balance from '@/components/balance.vue'

const routes = [
  {
    path: '/',
    name: 'homePage',
    component: home
  },
  {
    path: '/overview',
    name: 'overviewPage',
    component: overview
  },
  {
    path: '/addToBalance',
    name: 'addToBalancePage',
    component: balance
  }
]

const router = createRouter({
  history: createWebHashHistory(),
  routes
})

export default router
