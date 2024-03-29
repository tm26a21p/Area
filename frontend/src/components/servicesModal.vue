<template>
    <div class="servicesModal">
        <modal id="services-modal" name="services-modal">
            <button class="btn btn-dark" @click="hide">Close</button>
        </modal>
        <button class="btn btn-primary add" @click="show">Add</button>
    </div>
</template>

<script>
import Services from "@/components/Services.vue";

export default {
    name: "servicesModal",
    components: {
    },
    data() {
        return {
            
        };
    },
    props : {
        showActions : Boolean,
        showReactions : Boolean,
    },
    methods: {
        show() {
            this.$modal.show(
                Services, 
                {
                    modal: true,
                    showActions: this.showActions,
                    showReactions: this.showReactions,
                },
                // make sure to add this option
                {
                    display: 'flex',
                    justifyContent: 'center',
                    alignItems: 'center',
                    height: 'auto',
                    adaptive: true,
                    scrollable: true
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
            this.$modal.hide("services-modal");
        }
    },
    mount() {
        this.show();
    },
}
</script>

<style scoped>

.serviceModal {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    margin: 20px;
}
.add {
    font-size: 1.5rem;
    padding: 20px 40px 20px 40px;
    margin-bottom: 10px;
    border-radius: 40px;
}

</style>
