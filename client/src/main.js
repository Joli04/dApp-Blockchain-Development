import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import './assets/tailwind.css'

/* import the fontawesome core */
import { library } from '@fortawesome/fontawesome-svg-core'

/* import font awesome icon component */
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'

/* import specific icons */
import { faXmark, faPenToSquare, faCheck } from '@fortawesome/free-solid-svg-icons'

import { faEthereum } from '@fortawesome/free-brands-svg-icons'

/* add icons to the library */
library.add(faXmark, faPenToSquare, faCheck, faEthereum)

createApp(App)
  .component('font-awesome-icon', FontAwesomeIcon).use(router)
  .mount('#app')

// createApp(App).use(router).mount('#app')
