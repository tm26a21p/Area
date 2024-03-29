<template>
  <div id="home">
    <div class="jumbotron">
      <p class="lead">Every thing works better together</p>
      <hr class="my-4">
      <p class="lead-2">Quickly and easily automate your favorite apps and devices.</p>
      <p class="lead">
        <router-link class="btn btn-primary btn-lg mt-5" to="/register">Get started</router-link>
      </p>
    </div>
  </div>
</template>

<script>
// @ is an alias to /src

export default {
  name: 'HomeView',
  components: {

  },
  data () {
    return {

    }
  },
  setup() {

  },
  mounted() {
  },
}
</script>

<style scoped>
.jumbotron {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  text-align: center;
}
.lead {
  max-width: 800px;
  font-size: 4.5em;
}

.lead-2 {
  max-width: 1200px;
  font-size: 2em;
}

h2 {
  font-weight: bolder;
  margin-left: 20px;
}

.btn-lg {
  font-size: 2rem;
  padding: 1rem 2rem;
  border-radius: 50px;
}
</style>
