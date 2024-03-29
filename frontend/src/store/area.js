import { defineStore } from "pinia";
import axios from "axios";

export const useAreaStore = defineStore("area", {
    state: () => ({
        areas: [],
        actions: [],
        reactions: [],
        loading: false,
        error: null,

    }),
    getters: {
        getAreas: (state) => state.areas,
        getActions: (state) => state.actions,
        getReactions: (state) => state.reactions,
    },
    actions: {
        async getAllAreas() {
            this.loading = true;
            axios.get("/areas")
            .then((response) => {
                this.areas = response.data.data;
            })
            .catch((error) => {
                console.log(error);
                this.error = error;
            });
            this.loading = false;
        },
        async getActionsByServiceID(serviceID) {
            this.loading = true;
            axios.get(`actions/${serviceID}`)
            .then((response) => {
                this.actions = response.data.data;
            })
            .catch((error) => {
                console.log(error);
                this.error = error;
            })
            this.loading = false;
        },
        async getReactionsByServiceID(serviceID) {
            this.loading = true;
            axios.get(`reactions/${serviceID}`)
            .then((response) => {
                // console.log(response.data.data);
                this.reactions = response.data.data;
            })
            .catch((error) => {
                console.log(error);
                this.error = error;
            })
            this.loading = false;
        },
        async addTemplateArea(name, description, IsAction, Config, service_id) {
            this.loading = true;
            axios.post("/area", {
                name,
                description,
                IsAction,
                Config,
                service_id
            })
            .then((response) => {
                if (IsAction) {
                    this.actions.push(response.data.data);
                }
                else {
                    this.reactions.push(response.data.data);
                }
            })
            .catch((error) => {
                console.log(error.response);
                this.error = error;
            })
            this.loading = false;
        },
        async updateTemplateArea(id, name, description, IsAction, Config, ServiceID) {
            this.loading = true;
            axios.patch(`areas/${id}`, {
                name,
                description,
                IsAction,
                Config,
                ServiceID
            })
            .then((response) => {
                this.areas = this.areas.map((area) => {
                    if (area.id === id) {
                        return response.data.data;
                    }
                    return area;
                });
            })
            .catch((error) => {
                console.log(error);
                this.error = error;
            })
            this.loading = false;
        },
        async deleteTemplateArea(id, IsAction) {
            this.loading = true;
            axios.delete(`area/${id}`)
            .then(() => {
                if (IsAction) {
                    this.actions = this.actions.filter((action) => action.ID !== id);
                }
                else {
                    this.reactions = this.reactions.filter((reaction) => reaction.ID !== id);
                }
            })
            .catch((error) => {
                console.log(error);
                this.error = error;
            })
            this.loading = false;
        }

    },
});

    