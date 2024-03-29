<template>
  <div class="my-applet">
    <h2 class="title">Start connecting your world</h2>
    <h5 class="m-5">Save time and money by making the internet work for you!</h5>
    <div class="applets">
      <button id="create-applet" class="btn btn-primary" @click="createApplet">Create Applet</button>
    </div>
    <hr>
    <div class="applets">
      <h4 id="total">Total of your applets : {{appletStore.getApplets.length}}</h4>
      <div class="applet" v-for="applet in appletStore.getApplets" :key="applet.ID">
        <h2>{{ applet.name }}</h2>
        <toggle-button
        :width=200
        :height=30
        :value="applet.status"
        @change="toggleApplet(applet.ID)"
        color="#4CAF50"
        />
      </div>
    </div>
  </div>
</template>

<script>
// @ is an alias to /src
import { useAppletStore } from "@/store/applet";
import { useUserStore } from "@/store/user";
export default {
  name: 'MyAppletView',
  components: {
    
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
      
    };
  },
  mounted() {
    let user = this.userStore.getUser;
    this.appletStore.getMyApplets(user.id);
    console.log("applets => ", this.appletStore.getApplets);
  },
  methods: {
    rollbackToApplet(area) {
      this.area = area;
    },
    createApplet() {
      this.$router.push({ name: "createApplet" });
    },
    editApplet(id) {
      this.$router.push({ name: "editApplet", params: { id: id } });
    },
    toggleApplet(id) {
      this.appletStore.toggleApplet(id);
    },
    deleteApplet(id) {
      this.appletStore.deleteApplet(id);
    },
  },
}
</script>

<style scoped>

.title {
  text-align: center;
  margin-top: 50px;
  font-size: 3.2rem;
}
#total {
  margin: 20px;
  font-size: 2rem;
}
.my-applet {
  margin: 25px;
  text-align: center;
}
.applets {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  margin: 20px;
}
.applet {
  border: 6px solid #555;
  width: 100%;
  max-width: 800px;
  margin: 20px;
  padding: 10px;
  border-radius: 40px;
}

#create-applet {
  font-size: 2em;
  margin: 20px;
  padding: 15px 40px 15px 40px;
  border-radius: 40px;
}


</style>
  