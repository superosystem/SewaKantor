import axiosInstance from "configs/AxiosInstance";

const APIReview = {
    async getAllReview() {
        try {
            const response = await axiosInstance.get("/admin/review");
            return response;
        } catch (err) {
            console.log(err);
        }
    },

    async deleteReview(id) {
        try {
            const response = await axiosInstance.delete(`/admin/review/details/${id}`);
            return response;
        } catch (err) {
            console.log(err);
        }
    },
};

export default APIReview;