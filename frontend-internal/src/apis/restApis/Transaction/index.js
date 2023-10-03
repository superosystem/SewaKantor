import axiosInstance from "configs/AxiosInstance";

const APITransaction = {
    async getAllTransaction() {
        try {
            const response = await axiosInstance.get("/admin/transactions");
            return response;
        } catch (error) {
            console.log(error);
        }
    },
    async updateTransaction(data) {
        try {
            const id = data.id;
            const response = await axiosInstance.put(`admin/transactions/details/${id}`, data);
            return response;
        } catch (error) {
            console.log(error);
        }
    },

    async deleteTransaction(id) {
        try {
            const response = await axiosInstance.delete(`admin/transactions/details/${id}`);
            return response;
        } catch (error) {
            console.log(error);
        }
    },
};

export default APITransaction;