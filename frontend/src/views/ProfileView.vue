<template>
    <div class="profile">
      <h1 class="mb-5">Profile</h1>
      <div class="">
        <img :src=user.avatar alt="">
      </div>
      <div class="mt-5">
        <h2>{{ user.username }}</h2>
        <h3>{{ user.email }}</h3>
      </div>
    </div>
  </template>
  
  <script>
  // @ is an alias to /src
import {useUserStore } from '@/store/user'
  
export default {
  name: 'ProfileView',
  setup() {
    const userStore = useUserStore()
    return {
      userStore,
    }
  },
  data() {
    return {
      user: this.userStore.getUser,
    }
  },
  components: {
    
  }
}
</script>

<style scoped>
.profile {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  width: 100%;
  height: 100%;
}
</style>