import axios from "axios";
import axiosInstance from "configs/AxiosInstance";

const config = {
    headers: {
        "x-hasura-admin-secret": "2T083plTMGttLOXsgGkiRGPW3DPK8ChI49T3g3xy7QbUbvIFyPgJ5o3GTXMYfZTj",
    },
};

const APIPromo = {
    async getAllPromo() {
        try {
            const response = await axios.get("https://stirred-rhino-39.hasura.app/api/rest/promo", config);
            return response;
        } catch (err) {
            console.log(err);
        }
    },

    async createPromo(data) {
        try {
            const response = await axios.post("https://stirred-rhino-39.hasura.app/api/rest/promo", data, config);
            return response;
        } catch (err) {
            console.log(err);
        }
    },

    async updatePromo(data) {
        try {
            const id = data.id;
            const response = await axios.patch(`https://stirred-rhino-39.hasura.app/api/rest/promo/${id}`, data, config);
            return response;
        } catch (err) {
            console.log(err);
        }
    },

    async deletePromo(id) {
        try {
            const response = await axios.delete(`https://stirred-rhino-39.hasura.app/api/rest/promo/${id}`, config);
            return response;
        } catch (err) {
            console.log(err);
        }
    },
};

export default APIPromo;