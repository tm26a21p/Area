<template>
    <div class="area-alone-modal">
        <button class="stretched-link" @click="checkToken"
        :style="{
                  color: area.color,
              }"
        ></button>
    </div>
</template>

<script>

import AreaAlone from "@/components/AreaAlone.vue";
import {useUserStore } from '@/store/user';
import axios from "axios";

export default {
    name: "AreaAloneModalVue",
    components: {
        
    },
    setup() {
      const userStore = useUserStore();
      return {
          userStore,
      };
    },
    data() {
        return {
            user : this.userStore.getUser,
            token : null,
        };
    },
    props : {
        modal: Boolean,
        area : Object,
        service : Object,
        color : String,
    },
    methods: {
        show() {
            this.$modal.show(
                AreaAlone,
                {
                    modal: this.modal,
                    area: this.area,
                    color: this.color,
                },
                {
                    height: 'auto',
                    adaptive: true,
                    scrollable: true
                },
                {
                    'before-close': (data) => {
                        if (data.params != null) {
                            this.$emit('rollbackToApplet', data.params);
                        }
                    },
                }
            );
        },
        hide() {
            this.$modal.hide("area-alone-modal");
        },
        async getUserToken() {
            if (this.service.button.provider === "") {
                this.token = true;
                return;
            }
            if (this.userStore.user) {
                let id = this.userStore.getUser.id;
                let service_name = this.service.name;
                const res = await axios.get(`/tokens/` + service_name + `/` + id)
                this.token = res.data;
            }
        },
        checkToken() {
            this.getUserToken();
            if (this.token == null || this.token === false) {
                alert("You need to connect to " + this.service.name + " to use this area.");
            } else {
                this.show();
            } 
        }
    },
    mount() {
        this.show();
    },
    mounted() {
        this.getUserToken();
    },
}

</script>
