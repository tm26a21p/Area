<template>
    <div class="create-applet">
      <div class="form-group mt-2" >
        <label for="name" class="">Name your applet</label>
        <input type="text" id="name" v-model="name" class="form-control p-2 mb-4" placeholder="Enter a name...">
      </div>
      <div class="if-this-action">
          <span>If This</span>
          <services-modal v-if="actionChoice" :showActions=true :showReactions=false @rollbackToApplet="rollbackToApplet"  />
          <div v-else>
            <div class="action">
              <span class="btn btn-info p-2"> {{applet.action.name}} </span>
            </div>
          </div>
        </div>
        <div v-if="!actionChoice">
          <div v-for="reaction in appletReactions" id="rea" :key="reaction.ID" class="mt-4">
            <div class="if-this-reaction mt-5">
                <span>Then</span>
                <div v-if="reactionLength === 0">
                  <services-modal @rollbackToApplet="rollbackToApplet"  />
                </div>
                <span class="btn btn-info p-2"> {{reaction.name}} </span>
            </div>
          </div>
          <div class="if-this-reaction mt-5">
                <span>Then</span>
                <services-modal :showActions=false :showReactions=true @rollbackToApplet="rollbackToApplet" />
          </div>
        </div>
        <div v-if="!actionChoice && reactionLength > 0 && appletNameLength > 0">
          <button type="submit" class="btn btn-primary create-applet" @click="createApplet">Confirm</button>
        </div>
        <div v-else>
          <div class="btn btn-secondary create-applet-none">Confirm</div>
        </div>
    </div>
</template>
<!-- 

 -->
<script>
// @ is an alias to /src
import { useAppletStore } from "@/store/applet";
import { useUserStore } from "@/store/user";
import servicesModal from "@/components/servicesModal.vue";
export default {
  name: 'CreateAppletView',
  components: {
    servicesModal,
  },
  setup() {
    const appletStore = useAppletStore();
    const userStore = useUserStore();
    return {
        appletStore,
        userStore,
    };
  },
  data() {
    return {
      name: "",
        applet : {
            name: "",
            action: null,
            reactions: [],
        },
        showModal: false,
    };
  },
  computed: {
    actionChoice() {
      if (this.applet.action === null) {
        return true;
      }
      return false;
    },
    reactionLength() {
      return this.applet.reactions.length;
    },
    appletReactions() {
      return this.applet.reactions;
    },
    appletNameLength() {
      return this.name.length;
    },
  },
  mounted() { 
  },
  methods: {
    log() {
      console.log("actionChoice => ", this.actionChoice);
      console.log("reactionLength => ", this.reactionLength);
      console.log("appletNameLength => ", this.appletNameLength);
      console.log("name => ", this.name);
    },
    rollbackToApplet(area) {
      if (area.isAction) {
        this.applet.action = area;
      }
      else {
        this.applet.reactions.push(area);
      }
    },
    createApplet() {
      this.applet.name = this.name;
      this.appletStore.createApplet(this.applet, this.userStore.getUser.id);
    },
  },
}

</script>

<style scoped>

#name {
  font-size: large;
  border: 6px solid #555;
  border-radius: 44px;
}
.create-applet {
    display: flex;
    flex-direction: column;
    align-items: center;
    margin: 20px;
    text-align: center;
}
.if-this-action {
    display: flex;
    flex-direction: row;
    align-items: center;
    justify-content: space-around;
    font-size: 3rem;
    width: 100%;
    min-width: 280px;
    max-width: 600px;
    min-height: 170px;
    max-height: 170px;
    background-color: black;
    color: white;
    padding: 20px;
    margin: 10px;
    border-radius: 40px;
}
.if-this-reaction {
    display: flex;
    flex-direction: row;
    align-items: center;
    justify-content: space-around;
    font-size: 3rem;
    width: 100%;
    min-width: 600px;
    max-width: 600px;
    min-height: 170px;
    max-height: 170px;
    background-color: lightblue;
    color: white;
    padding: 10px;
    margin: 10px;
    border-radius: 40px;
}
.create-applet {
  font-size: 1.4em;
  padding: 5px 30px 5px 30px;
  margin-top: 20px;
  border-radius: 40px;
}
.create-applet-none {
  font-size: 1.4em;
  margin-top: 20px;
  padding: 5px 30px 5px 30px;
  border-radius: 40px;
  background-color: grey;
  pointer-events: none;
}

</style>