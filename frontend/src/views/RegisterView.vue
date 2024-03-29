<template>
  <div class="container">
      <h1>Register</h1>
      <hr>
      <form @submit.prevent="register">
      <div class="form-group">
          <label class="label" for="first_name">First name</label>
          <input type="text" class="form-control" id="first_name" v-model="first_name" placeholder="Enter your first name">
      </div>
      <div class="form-group">
          <label class="label" for="last_name">Last name</label>
          <input type="text" class="form-control" id="last_name" v-model="last_name" placeholder="Enter your last name">
      </div>
      <div class="form-group">
          <label class="label" for="email">Email address</label>
          <input type="email" class="form-control" id="email" v-model="email" placeholder="Enter email">
      </div>
      <div class="form-group">
          <label class="label" for="password">Password</label>
          <input type="password" class="form-control" id="password" v-model="password" placeholder="Password">
      </div>
      <div class="post-submit-1">
        <button type="submit" class="btn btn-primary mt-4 login-button">Register</button>
        <p class="mt-3 pt-1">or</p>
        <button class="btn btn-dark mt-4 login-button" @click="goToLogin">Login</button>
        </div>
        <div class="post-submit-2">
          <p class="mt-4">But you can also...</p>
          <div id="g_id_onload"
              data-client_id="425480709650-p65s65mki3ot2hojl7c49vtflnktg8g9.apps.googleusercontent.com"
              data-context="signin"
              data-ux_mode="popup"
              data-login_uri="http://localhost:8080/google/login"
              data-nonce=""
              data-auto_prompt="false">
          </div>

          <div class="g_id_signin"
              data-type="standard"
              data-shape="pill"
              data-theme="filled_black"
              data-text="continue_with"
              data-size="larger"
              data-logo_alignment="left">
          </div>
        </div>
    </form>

  </div>
</template>

<script>
  import {useUserStore } from '@/store/user'

export default {
  name: "RegisterVue",
  setup() {
    const userStore = useUserStore()
    return {
      userStore,
    }
  },
  data() {
      return {
          first_name: "",
          last_name: "",
          email: "",
          password: "",
      };
  },
  mounted() {
    let googleScriptImport = document.createElement('script')
    googleScriptImport.setAttribute('src', 'https://accounts.google.com/gsi/client')
    document.head.appendChild(googleScriptImport)
  },
  methods: {
    goToLogin() {
      this.$router.push('/login')
    },
      register() {
        this.userStore.register(this.first_name, this.last_name, this.email, this.password)
      }
  }
}

</script>

<style scoped>
.container {
  margin: auto;
  width: 100%;
  max-width: 500px;
}
.label {
  margin-top: 20px;
  float: left;
}
.login-button {
  font-size: 1.4rem;
  padding: 10px;
  width: 120px;
  border-radius: 20px;
  margin: 20px;
}
.post-submit-1 {
  display: flex;
  flex-direction: row;
  justify-content: center;
  align-items: center;
}
.post-submit-2 {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  margin-top: 20px;
}

</style>
