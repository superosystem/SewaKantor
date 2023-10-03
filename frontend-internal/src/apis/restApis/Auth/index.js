import axiosInstance from "configs/AxiosInstance";
import Auth from "utils/auth";

const APIAuth = {
  async signin(payload) {
    try {
      const { email, password } = payload;
      const response = await axiosInstance.post("/login", { email, password });
      Auth.storeUserInfoToCookie(response.data);
      return response.data;
    } catch (error) {
      const { message } = error.response.data;
      throw new Error(message);
    }
  },
};

export default APIAuth;
