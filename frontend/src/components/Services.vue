  <template>
    <div id="services" class="services">
      <div id="service-inside" class="service-inside">
        <nav id="nav-services-modal" v-if="modal">
          <button id="close-modal" v-if="modal" class="btn btn-dark" @click="$emit('close')">Close</button>
          <h1 class="mt-5">Choose a service</h1>
        </nav>
        <div class="container mt-5">
          <input id="search-bar" class="search" type="text" v-model="input" placeholder="Search services..." />
        </div>
        <div class="box mt-5">
          <div class="card" v-for="service in filteredServiceList()" :key="service.ID">
              <div class="card-body pt-4" 
              :style="{
                  background: service.color,
              }"
              >
                <div class="img-container">
                  <img class="img" :src=service.icon :alt="service.name + ' image'">
                </div>
                <h5 class="card-title mt-5">{{ service.name }}</h5>
                <ServiceAloneModalVue :showActions=showActions :showReactions=showReactions :service=service @rollbackToApplet="rollbackToApplet" />
              </div>
          </div>
          <div class="card item error" v-if="input&&!filteredServiceList().length">
            <h5>No results found!</h5>
          </div>
      </div>
    </div>
    <div class="fake-footer"
    :style="{
      'height': `calc(${resizeFakeFooter}px)`
    }">
    </div>
  </div>
</template>

  <script>
  import { useServiceStore } from "@/store/service";
  import ServiceAloneModalVue from "./ServiceAloneModal.vue";

  export default {
    name: "ServicesVue",
    components: {
      ServiceAloneModalVue,
    },
    setup() {
      const serviceStore = useServiceStore();
      return {
          serviceStore,
      };
    },
    props : {
      showActions : Boolean,
      showReactions : Boolean,
      modal: {
        type: Boolean,
        default: false,
      },
    },
    data() {
      return {
        services : [],
        name: "",
        description: "",
        input: "",
        admin: false,
      };
    },
    mounted() {
      this.serviceStore.getAllServices();
      this.services = this.serviceStore.getServices;
    },
    computed : {
      resizeFakeFooter() {
        return window.innerHeight - 20;
      }
    },
    methods: {
      rollbackToApplet(area) {
            this.$emit('rollbackToApplet', area);
            this.$emit('close', area);
        },
      hide() {
        this.$modal.hide("services-modal");
      },
      goToPage(service) {
        this.$router.push({ name: `${service.name.toLowerCase()}`, params: { service: service } });
      },
      filteredServiceList() {
        this.services = this.serviceStore.getServices;
        if (!this.input) {
          return this.services;
        }
        return this.services.filter((service) => {
          return service.name.toLowerCase().includes(this.input.toLowerCase());
        });
      },
      deleteService (id) {
        this.serviceStore.deleteService(id);
      },
      addService () {
        this.serviceStore.addService(this.name, this.description);
      },
    }
  };
  </script>

<style scoped>
.btn-inv {
  opacity: 0;
}
.img-container {
  display: flex;
  justify-content: center;
  align-items: center;
}
.img {
  width: 110px;
  height: 110px;
  object-fit: cover;
}
#nav-services-modal {
  font-size: 4em;
  text-align: center;
  margin: 20px;
}
#close-modal {
  position: absolute;
  top: 0;
  right: 0;
  margin: 20px;
}
#services {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  text-align: center;
  margin: auto;
}
#search-bar {
  font-size: larger;
  width: 50%;
  margin: 20px;
  padding: 10px;
  border-radius: 40px;
  border: 6px solid #555;
  outline: none;
}
#search-bar:focus {
  border-radius: 40px;
  width: 90%;
  transition: width 0.4s ease-in-out;
}

#search-bar::placeholder {
  color: #555;
  font-size: larger;
  margin-left: 10px;
}

.box {
  margin: auto;
  display: flex;
  justify-content: center;
  align-items: center;
  flex-wrap: wrap;
  max-width: 1400px;
  
}
.card {
  width: auto;
  margin: 25px;
  min-width: 270px;
  min-height: 240px;
  border: none;
}
.card-body:hover {
  box-shadow: 0 0 11px rgba(33,33,33,.6);
}
.card-body {
  border-radius: 15px;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  align-items: center;
}

</style>