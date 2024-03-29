import Vue from 'vue'
import VueRouter from 'vue-router'
import HomeView from '../views/HomeView.vue'
// import RegisterView from '../views/RegisterView.vue'
import LoginView from '../views/LoginView.vue'

Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    name: 'home',
    component: HomeView
  },
    {
      path: '/register',
    name: 'register',
    // route level code-splitting
    // this generates a separate chunk (about.[hash].js) for this route
    // which is lazy-loaded when the route is visited.
    component: () => import(/* webpackChunkName: "about" */ '../views/RegisterView.vue')
  },
  {
    path: '/login',
    name: 'login',
    component: LoginView
  },
  {
    path: '/profile',
    name: 'profile',
    component: () => import(/* webpackChunkName: "about" */ '../views/ProfileView.vue')
  },
  {
    path: '/myapplets',
    name: 'myapplets',
    component: () => import(/* webpackChunkName: "about" */ '../views/MyAppletView.vue')
  },
  {
    path: '/createapplet',
    name: 'createApplet',
    component: () => import(/* webpackChunkName: "about" */ '../views/CreateAppletView.vue')
  },
  {
    path: '/editapplet',
    name: 'editApplet',
    component: () => import(/* webpackChunkName: "about" */ '../views/EditAppletView.vue')
  },
  {
    path: '/explore',
    name: 'Explore',
    component: () => import(/* webpackChunkName: "about" */ '../views/ExploreView.vue')
  },
  {
    path: '/client.apk',
    name: 'client apk',
    component: () => import(/* webpackChunkName: "about" */ '../views/AppApkView.vue')
  },

  // Services Routes =>
  /*
  * TO ADD A NEW SERVICE ROUTE, NAME MUST BE THE SAME AS THE SERVICE NAME IN LOWERCASE
  *
  * 
  *                       |
  *                       |                       
  *                       |                                 // isn't it beautiful?
  *                     \.../
  *                      \./
  *                       V
  */
  // {
  //   path: '/dateandtime',
  //   name: 'dateandtime', // like here
  //   component: () => import(/* webpackChunkName: "about" */ '../views/services/DateAndTime.vue')
  // },
  // {
  // path: '/:(.*)*',
  // name: 'NotFound', 
  // component: () => import(/* webpackChunkName: "about" */ '../views/NotFound.vue')
  // },
  // {
  //   path: '/google/calendar',
  //   name: 'googleCalendar', // like here
  //   component: () => import(/* webpackChunkName: "about" */ '../views/services/google/GoogleCalendar.vue')
  // },
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

export default router
