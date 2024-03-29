import { defineStore } from "pinia";
import axios from "axios";
import Cookies from 'js-cookie'

let getUserCookie = function () {
  if (Cookies.get('user')) {
    return JSON.parse(Cookies.get('user'))
  }
}

export const useUserStore = defineStore("user", {
  state: () => ({
    user: sessionStorage.getItem("user") || getUserCookie() || null,
  }),

    getters: {
        isLoggedIn: (state) => !!state.user,
        getUser: (state) => state.user,
        getUserId: (state) => {
            if (state.user !== null && state.user !== undefined && typeof(state.user.id) !== "number") {
                return JSON.parse(state.user).id;
            }
        },
    },

    actions: {
    async fetchUser() {
        this.user = sessionStorage.getItem("user") || getUserCookie || null;
    },
    async register(first_name, last_name, email, password) {
        await axios
        .post("/register", {
            first_name,
            last_name,
            email,
            password,
        })
        .then((response) => {
            console.log("register response : ", response.data);
            this.$router.push({ name: "login" });

        })
        .catch((error) => {
            console.log(error);
        });
    },
    async login(email, password) {
        await axios
        .post("/login", {
            email,
            password,
        })
        .then((response) => {
            console.log(":response.data.user login => ", response.data.user);
            this.user = response.data.user;
            sessionStorage.setItem("user", JSON.stringify(response.data.user));
            this.$router.push({ name: "home" });
        })
        .catch((error) => {
            console.log(error);
        });
    },
    async logout() {
        await axios
        .post("/logout")
        .then(() => {
            this.user = null;
            sessionStorage.removeItem("user");
            // delete the user cookie
            Cookies.remove('user');
        })
        .catch((error) => {
            this.user = null;
            sessionStorage.removeItem("user");
            // delete the user cookie
            Cookies.remove('user');
            console.log(error);
        });
    }
  },
});