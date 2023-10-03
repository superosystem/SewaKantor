import axiosInstance from "configs/AxiosInstance";

// Contoh misal ngambil api building

const APIBuildings = {
    async getAllBuilding() {
        try {
            const response = await axiosInstance.get("/endpointnya disini");
            console.log(response);
            return response;
        } catch (error) {
            console.log(error);
        }
    },

    async createBuildings() {
        try {
            const response = await axiosInstance.post("/endpointnya");
            console.log(response);
            return response;
        } catch (error) {
            console.log(error);
        }
    },

    async updateBuildings(data) {
        try {
            const id = data.id;
            const response = await axiosInstance.patch(`/endpoint/:${id}`, data);
            console.log(response);
            return response;
        } catch (error) {
            console.log(error);
        }
    },
    async deleteBuildings(id) {
        try {
            const response = await axiosInstance.delete(`/endpoint/:${id}`);
            console.log(response);
            return response;
        } catch (error) {
            console.log(error);
        }
    },

    //   Kalo misalkan ada yang lain tinggal tambahin disini
};

export default APIBuildings;