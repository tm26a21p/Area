import Vue from 'vue'
import App from './App.vue'
import axios from 'axios'
import 'bootstrap/dist/css/bootstrap.min.css'
import 'jquery/src/jquery.js'
import 'bootstrap/dist/js/bootstrap.min.js'
import router from './router'
import { createPinia, PiniaVuePlugin } from 'pinia'
import { markRaw } from '@vue/composition-api'
import VModal from 'vue-js-modal'
import ToggleButton from 'vue-js-toggle-button'

Vue.use(ToggleButton)
Vue.use(VModal, {
  dynamicDefaults: {
    draggable: false,
    resizable: false,
    adaptive: true,
    width: '100%',
    scrollable: true,
    classes: 'modal-dialog-centered position-absolute top-0 start-0 z-index-9999',
  },
})
Vue.use(PiniaVuePlugin)
const pinia = createPinia()

pinia.use(({ store }) => {
  store.$router = markRaw(router)
});

Vue.config.productionTip = false
axios.defaults.baseURL = 'http://localhost:8080'

new Vue({
  router,
  pinia,
  render: h => h(App)
}).$mount('#app')
