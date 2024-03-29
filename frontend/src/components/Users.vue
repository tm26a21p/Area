<template>
    <div id="app">
        <!-- loop through all users -->
        <div class="box">
          <div class="card" v-for="user in users" :key="user.id">
              <div class="card-body">
              <h5 class="card-title">{{ user.first_name }} {{ user.last_name.toUpperCase() }}</h5>
              <hr>
              <h6 class="card-subtitle mb-2 text-muted">{{ user.email }}</h6>
              <p class="card-text">{{ user.password }}</p>
              <p class="card-text">id : {{ user.ID }}</p>
              <p class="card-text">created at : {{ user.CreatedAt }}</p>
              <p class="card-text">updated at : {{ user.UpdatedAt }}</p>
              <button class="btn btn-danger" @click="deleteUser(user.ID)">Delete</button>
              </div>
          </div>
        </div>
    </div>
</template>

<script>
import axios from "axios";

export default {
  name: "UsersVue",
  created() {
    this.$root.$refs.UsersVue = this;
  },
  data() {
    return {
      users: null,
      componentKey: 0
    };
  },
  mounted() {
    this.getUsers();
  },
  methods: {
    getUsers: async function() {
      try {
        await axios
          .get("/users")
          .then(response => {
            this.users = response.data.data;
            console.log("we received : ", this.users);
          });
      } catch (error) {
        console.error(error);
      }
    },
    deleteUser: async function(id) {
      try {
        await axios
          .delete("/users/" + id)
          .then(response => {
            console.log("we deleted : ", response);
            this.getUsers();
          });
      } catch (error) {
        console.error(error);
      }
    },
    forceRenderer: function() {
        console.log("forceRenderer");
        this.componentKey += 1;
        this.$forceUpdate();
    }
  }
};
</script>

<style>
.box {
  margin: auto;
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
}
.card {
  width: 25rem;
  margin: 20px;
}
</style>