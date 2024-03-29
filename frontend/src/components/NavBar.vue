<template>
    <!-- create a simple navbar with login and register -->
    <nav class="navbar navbar-dark bg-dark">
        <div class="brand-box">
            <a class="navbar-brand" href="/">
                <img id="brand" src="@/assets/img/area_logo_removebg.png" width="40" height="40" class="d-inline-block align-top" alt="">
                <span class="m-2">AREA</span>
            </a>
        </div>

        <!-- if user is connected, display profile and deconnexion else display login and register -->
        <div class="links">
            <router-link v-if="!connected" class="btn btn-link" to="/">Home</router-link>
            <router-link class="btn btn-link" to="/explore">Explore</router-link>
            <router-link v-if="!connected" class="btn btn-link" to="/login">Login</router-link>
            <router-link v-if="!connected" class="btn btn-link" to="/register">Register</router-link>
            <router-link v-if="connected" id="" class="btn btn-link" to="/myapplets">My applets</router-link>
            <router-link v-if="connected" class="btn btn-link" to="/profile">Profile</router-link>
            <a v-if="connected" class="btn btn-link" @click="logout">Logout</a>
        </div>
    </nav>
</template>
<!-- <script src="https://accounts.google.com/gsi/client" async defer></script> -->

<script>
import {useUserStore } from '@/store/user'
export default {
    name: "NavBar",
    setup() {
        const userStore = useUserStore()
        return {
            userStore,
        }
    },
    data() {
        return {
        }
    },

    computed: {
        connected() {
            return this.userStore.isLoggedIn;
        }
    },
    mouted() {

    },
    methods: {
        logout() {
            this.userStore.logout();
            // if router is not at home, redirect to home
            if (this.$route.path != "/") {
                this.$router.push("/");
            }
        }
    },
}
</script>

<style scoped>

.navbar-brand {
    margin-left: 16px;
}
#logout-link {
    cursor: pointer;
}
.navbar {
    display: flex;
    justify-content: flex-between;
    position: relative;
    top: 0;
    width: 100%;
    height: 100px;
    margin-bottom: 64px;
}

.btn-link {
    font-size: 1.1em;
    text-decoration: none;
    border: 1px solid #fff;
    border-radius: 25px;
    padding: 10px 20px 10px 20px;
    margin-right: 26px;
}

nav a {
  font-weight: bold;
  color: #ffffff;
}

nav a.router-link-exact-active {
  color: #396ac5;
  border: none;
}


/* make the navbar responsive */
@media (max-width: 768px) {
    .navbar {
        flex-direction: column;
        height: auto;
    }
    .brand-box {
        margin-bottom: 16px;
    }
    .links {
        display: flex;
        flex-direction: column;
        align-items: center;
    }
    .btn-link {
        margin-right: 0;
        margin-bottom: 16px;
    }
}

</style>