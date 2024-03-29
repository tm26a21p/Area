<template>
    <div class="serviceAloneModal">
        <button class="btn btn-primary stretched-link btn-inv m-0" @click="show"
        :style="{
                  color: service.color,
                  width: 1 + 'px',
                    height: 1 + 'px',
              }"
        ></button>
    </div>
</template>

<script>
import ServiceAlone from "@/components/ServiceAlone.vue";

export default {
    name: "ServiceAloneModal",
    components: {
    },
    data() {
        return {
            
        };
    },
    props : {
        service : Object,
        showActions : Boolean,
        showReactions : Boolean,
    },
    methods: {
        show() {
            this.$modal.show(
                ServiceAlone, 
                {
                    modal: true,
                    service: this.service,
                    showActions: this.showActions,
                    showReactions: this.showReactions,
                },
                // make sure to add this option
                {
                    height: 'auto',
                    adaptive: true,
                    scrollable: true,
                },
                {
                    'before-close': (data) => {
                        if (data.params != null) {
                            this.$emit('rollbackToApplet', data.params);
                        }
                    }
                }
            );
        },
        hide() {
            this.$modal.hide("service-alone-modal");
        },

    },
    mount() {
        this.show();
    },
}
</script>

<style scoped>
.btn-inv {
    background-color: transparent;
    border: none;
    padding: 0;
    font: inherit;
    cursor: pointer;
    outline: inherit;
}
.serviceAloneModal {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    margin: 20px;
}
</style>
