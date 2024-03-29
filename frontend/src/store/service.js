import { defineStore } from "pinia";
import axios from "axios";

export const useServiceStore = defineStore("service", {
    state: () => ({
        services: [],
        service: {},
        loading: false,
        error: null,
    }),
    getters: {
        getServices: (state) => state.services,
        getService: (state) => state.service,
        getLoading: (state) => state.loading,
        getError: (state) => state.error,
    },
    actions: {
        async getAllServices() {
            this.loading = true;
            axios.get("services")
            .then((response) => {
                this.services = response.data.data;
            })
            .catch((error) => {
                console.log(error);
                this.error = error;
            });
            this.loading = false;
        },
        async getService(id) {
            this.loading = true;
            axios.get(`services/${id}`)
            .then((response) => {
                this.service = response.data.data;
            })
            .catch((error) => {
                console.log(error);
                this.error = error;
            });
            this.loading = false;
        },
        async addService(name, description) {
            this.loading = true;
            axios.post("services", {
                name,
                description,
            })
            .then((response) => {
                this.services.push(response.data.data);
                
            })
            .catch((error) => {
                console.log(error);
                this.error = error;
            });
            this.loading = false;
        },
        async updateService(id, service) {
            this.loading = true;
            axios.put(`services/${id}`, service)
            .then((response) => {
                this.services = this.services.map((service) => {
                    if (service.id === id) {
                        return response.data.data;
                    }
                    return service;
                });
            })
            .catch((error) => {
                console.log(error);
                this.error = error;
            });
            this.loading = false;
        },
        async deleteService(id) {
            this.loading = true;
            axios.delete(`services/${id}`)
            .then((response) => {
                console.log(response.data.data);
                this.services = this.services.filter((service) => service.ID !== id);
            })
            .catch((error) => {
                console.log(error);
                this.error = error;
            })
            this.loading = false;
        },
    },
});

    