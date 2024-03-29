<template>
    <div class="area">
      <div v-if="!showActions && this.areaStore.getReactions.length <= 0">
        <p class="alert alert-dark">There is no reactions available in this service.</p>
      </div>
      <div v-if="!showReactions && this.areaStore.getActions.length <= 0">
        <p class="alert alert-dark">There is no actions available in this service.</p>
      </div>
      <div v-if="showActions" class="actions">
        <h2 v-if="this.areaStore.getActions.length > 0">Actions</h2>
        <div class="box">
          <div class="card m-4" v-for="action in this.areaStore.getActions" :key="action.ID"
            :style="{
              background: service.color,
            }"
          >
                <div class="card-body">
                  <h4 class="card-title">{{ action.name }}</h4>
                  <p class="card-text">{{ action.description }}</p>
                </div>
              <div v-if="user">
                <AreaAloneModalVue :service=service :modal=true :area=action :color=service.color class="m-4" @rollbackToApplet="rollbackToApplet" />
              </div>
          </div>
        </div>
     </div>
     <div v-if="showReactions" class="reactions">
        <h2 v-if="this.areaStore.getReactions.length > 0">Reactions</h2>
        <div class="box">
          <div class="card m-4" v-for="reaction in this.areaStore.getReactions" :key="reaction.ID"
          :style="{
              background: service.color,
            }"
          >
            <div class="card-body">
              <h4 class="card-title">{{ reaction.name }}</h4>
              <p class="card-text">{{ reaction.description }}</p>
            </div>
            <div v-if="user">
              <AreaAloneModalVue :service=service :modal=true :area=reaction :color=service.color class="m-4" @rollbackToApplet="rollbackToApplet" />
            </div>
          </div>
        </div>
      </div>
  </div> 
  </template>

<script>
import { useAreaStore } from "@/store/area";
import { useUserStore } from "@/store/user";
import AreaAloneModalVue from "@/components/AreaAloneModal.vue";

export default {
  name: "AreaComponent",
  components: {
    AreaAloneModalVue,
  },
  setup() {
    const areaStore = useAreaStore();
    const userStore = useUserStore();
    return {
        areaStore,
        userStore,
    };
  },
  props : {
    service : Object,
    showActions : Boolean,
    showReactions : Boolean,
  },
  data() {
    return {
      user: this.userStore.getUser,
    };
  },
  mounted() {
    this.areaStore.getActionsByServiceID(this.service.ID);
    this.areaStore.getReactionsByServiceID(this.service.ID);
  },
  methods: {
    rollbackToApplet(area) {
      this.$emit('rollbackToApplet', area);
    },
    deleteTemplateArea(id, isAction) {
      this.areaStore.deleteTemplateArea(id, isAction);
    },
    addAction() {
      this.areaStore.addTemplateArea(this.actionName, this.actionDescription, true, this.actionConfig, this.service.ID);
    },
    addReaction() {
      this.areaStore.addTemplateArea(this.reactionName, this.reactionDescription, false, this.reactionConfig, this.service.ID);
    },
  },
};
</script>

<style scoped>

.area {
  text-align: center;
}
.box {
  display: flex;
  flex-direction: row;
  flex-wrap: wrap;
  justify-content: center;
  align-items: center;
  margin: auto;
}
.card {
  width: 300px;
  height: 250px;
  margin: 25px;
  border-radius: 15px;
}
/* on hover display shadow */
.card:hover {
  box-shadow: 0 0 11px rgba(33,33,33,.6);
}
.card-body {
  display: flex;
  flex-direction: column;
  justify-content: space-around;
  height: 100%;
}

.card-footer {
  display: flex;
  justify-content: space-around;
}
</style>