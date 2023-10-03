import axiosInstance from "configs/AxiosInstance";

const APIFacility = {
    async getAllFacility() {
        try {
            const response = await axiosInstance.get("/admin/facilities/all");
            return response.data;
        } catch (err) {
            console.log(err);
        }
    },
};

export default APIFacility;