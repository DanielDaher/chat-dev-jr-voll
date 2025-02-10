import { createRouter, createWebHistory } from 'vue-router';
import LoginScreen from './components/LoginScreen';
import DashboardScreen from './components/DashboardScreen';


const routes = [
  { path: '/', component: LoginScreen },
  { path: '/dashboard', component: DashboardScreen },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;