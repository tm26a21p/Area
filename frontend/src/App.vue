<template>
  <div id="app">
    <KeepAlive include="CreateAppletView">
      <NavBar />
    </KeepAlive>
    <router-view />
  </div>
</template>

<script>
import NavBar from './components/NavBar.vue'
export default {
  name: 'App',
  components: {
    NavBar
  }
}
</script>
<style>

@font-face {
  font-family: "Tommy";
  src: local("Tommy"),   url(./assets/fonts/tommy/tommy_medium.otf) format("truetype");
}

#app {
  font-family: "Tommy", Helvetica, Arial, sans-serif;
  letter-spacing: 1px;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #2c3e50;
}

#app h1 {
  font-size: 4em;
  text-align: center;
}
.vm--modal {
  height: auto !important;
}
</style>
