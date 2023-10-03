import axios from "axios";
import Cookies from "js-cookie";
import { Navigate } from "react-router-dom";
import Auth from "utils/auth";
import CONST from "utils/constant";

const config = {
  baseURL: CONST.BASE_URL,
};
const axiosInstance = axios.create(config);

axiosInstance.interceptors.request.use(
  (config) => {
    config.headers["Authorization"] = `Bearer ${Auth.getAccessToken()}`;
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

axiosInstance.interceptors.response.use(
  (res) => {
    return res;
  },
  async (err) => {
    const originalConfig = err.config;

    if (err.response) {
      // Access Token was expired
      if (err.response.status === 401 && !originalConfig._retry) {
        originalConfig._retry = true;
        try {
          Auth.signOut();
          const rs = await refreshToken();
          Auth.storeUserInfoToCookie(rs.data);
          axiosInstance.defaults.headers.common["token"] =
            Auth.getAccessToken();
          return axiosInstance(originalConfig);
        } catch (_error) {
          if (_error.response && _error.response.data) {
            return Promise.reject(_error.response.data);
          }
          return Promise.reject(_error);
        }
      }

      if (err.response.status === 403 && err.response.data) {
        return Promise.reject(err.response.data);
      }
    }

    return Promise.reject(err);
  }
);

export default axiosInstance;

function refreshToken() {
  return axiosInstance.post("/refresh", {
    headers: {
      Authorization: `Bearer ${Auth.getRefreshToken()}`,
    },
  });
}
