import { defineStore } from "pinia";
import axios from "axios";

export const useAppletStore = defineStore("applet", {
    state: () => ({
        applets: [],
        applet: {},
        loading: false,
        error: null,
    }),
    getters: {
        getApplets: (state) => state.applets,
        getApplet: (state) => state.applet,
        getLoading: (state) => state.loading,
        getError: (state) => state.error,
    },
    actions: {
        async getMyApplets(user_id) {
            this.loading = true;
            axios.get(`applets/${user_id}`)
            .then((response) => {
                this.applets = response.data.data;
            })
            .catch((error) => {
                console.log(error);
                this.error = error;
            })
            this.loading = false;
        },
        async getApplet(id) {
            this.loading = true;
            axios.get(`applet/${id}`)
            .then((response) => {
                console.log("getAppletID =>", response.data.data);
                this.applet = response.data.data;
            })
            .catch((error) => {
                console.log(error);
                this.error = error;
            })
            this.loading = false;
        },
        async createApplet(applet, user_id) {
            this.loading = true;
            
            axios.post(`applet/${user_id}`, {
                user_id : user_id,
                name : applet.name,
                action : applet.action,
                reactions : applet.reactions,
            })
            .then(() => {
                this.applets.push(applet);
                this.$router.push({ name: "myapplets" });
            })
            .catch((error) => {
                console.log(error);
                this.error = error;
            })
            this.loading = false;
        },
        async toggleApplet(id) {
            this.loading = true;
            axios.put(`applet/toggle/${id}`)
            .then((response) => {
                console.log("toggleApplet =>", response.data.data);
                this.applet = response.data.data;
            })
            .catch((error) => {
                console.log(error);
                this.error = error;
            })
            this.loading = false;
        },
        async updateApplet(id, applet) {
            this.loading = true;
            axios.patch(`applet/${id}`, applet)
            .then((response) => {
                this.applets = this.applets.map((applet) => {
                    if (applet.id === id) {
                        return response.data.data;
                    }
                    return applet;
                });
            })
            .catch((error) => {
                console.log(error);
                this.error = error;
            })
            this.loading = false;
        },
        async deleteApplet(id) {
            this.loading = true;
            axios.delete(`applets/${id}`)
            .then(() => {
                this.applets = this.applets.filter((applet) => applet.id !== id);
            })
            .catch((error) => {
                console.log(error);
                this.error = error;
            })
            this.loading = false;
        },
    }
});