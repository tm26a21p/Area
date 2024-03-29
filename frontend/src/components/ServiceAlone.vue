<template>
    <div class="serviceAlone"
      style="{
        margin: '0' + 'px',
      }"
    >
      <div class="serviceAloneBox"
        :style="{ background: service.color }">
        <button id="close-modal" v-if="modal" class="btn btn-dark" @click="$emit('close')">Close</button>
        <div class="img-container mt-5">
          <img class="img" :src=service.icon alt="Service image">
        </div>
        <h1 class="m-5 title">{{service.name}}</h1>
        <p class="m-2 p-2 desc">{{service.description}}</p>
        <div v-if=isProvider>
          <button class="btn btn-primary connectButton m-5" @click="requestCode()">Connect to {{service.name}}</button>
        </div>
      </div>
        <hr>
        <AreaComponent :service=service :showActions=showActions :showReactions=showReactions @rollbackToApplet="rollbackToApplet" />
        <div class="fake-footer"
          :style="{
            'height': `calc(${fakeFooterResize}px)`
          }">
        </div>
    </div>
</template>

<script class="googleScript" src="https://accounts.google.com/gsi/client" async defer></script>

<script>
import { useServiceStore } from "@/store/service";
import AreaComponent from "./Area.vue";
import {useUserStore } from '@/store/user';
import axios from "axios";

export default {
    name: "ServiceAloneVue",
    components: {
        AreaComponent,
    },
    props : {
        modal : Boolean,
        service : Object,
        showActions : Boolean,
        showReactions : Boolean,
    },
    setup() {
      const serviceStore = useServiceStore();
      const userStore = useUserStore();
      return {
          serviceStore,
          userStore,
      };
    },
    data() {
      return {
        client: null,
        serviceData: {},
        user: this.userStore.user || null,
        isProvider: false,
        
      };
    },
    mounted() {
      var script = document.querySelector('.googleScript');
      script.addEventListener('load', this.initClient);
      this.initClient(this.callback, this.errorCallback);
      if (this.user && this.service.button.provider !== "") {
        this.isProvider = true;
      }
      this.removeMargin();
    },
    computed : {
      fakeFooterResize() {
        if (this.showReactions) {
          return window.innerHeight - 100 - 100;
        } else {
          return window.innerHeight - 100;
        }
      },
    },
    methods: {
      // remove margin from .serviceAlone
      removeMargin() {
        document.querySelector('.serviceAlone').style.margin = '0';
      },
      rollbackToApplet(area) {
        this.$emit('rollbackToApplet', area);
        this.$emit('close', area);
      },
      requestCode() {
        this.client.requestCode();
      },
      async callback(response) {
        let user_id = this.userStore.user.id;
        axios.post(`/connect/${user_id}`, {
          code: response.code,
          scope: response.scope,
          redirect_uri: 'postmessage',
          service_name: this.service.name, 
        })
      },
      error_callback(error) {
        console.log(error);
      },
      initClient(callback, error_callback) {
          let conf = this.service.button;
          if (conf.provider === "") {
            return;
          }
          let scopes;
          // if conf.scope contains | then it's a list of scopes and we need to split it
          if (conf.scopes.includes("|")) {
            scopes = conf.scopes.split("|");
          } else {
            scopes = conf.scopes;
          }
          this.client = google.accounts.oauth2.initCodeClient({
          client_id: conf.client_id,
          scope: scopes,
          ux_mode: 'popup',
          callback: callback,
          error_callback: error_callback,
          redirect_uri: 'postmessage',
        });
      },
  },
}
</script>

<style scoped>
.serviceAlone {
  position: relative;
  top: 0;
  left: 0;
  /* dont put margin */
  margin: 0;
}
.serviceAloneBox {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  width: 100%;
  height: 100%;
  margin-bottom: 20px;
}
.title {
  font-size: 2.5rem;
  font-weight: 700;
}
.desc {
  text-align: center;
  width: 70%;
}
.img-container {
  display: flex;
  justify-content: center;
  align-items: center;
}
.img {
  width: 20%;
}
#close-modal {
    position: absolute;
    top: 0;
    right: 0;
    margin: 20px;
}
.serviceAlone {
    width: 100%;
    height: 100%;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    margin: 20px;
}
.connectButton
{
  font-size: 2em;
  margin: 20px;
  padding: 15px 40px 15px 40px;
  border-radius: 40px;
}
</style>