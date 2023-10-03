import APIAuth from "apis/restApis/Auth";
import { SewaKantor, login } from "assets";
import { Button, LoadingButton } from "components/Button";
import React, { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import Swal from "sweetalert2";
import { Helmet } from "react-helmet";
import AccountCircleOutlinedIcon from '@mui/icons-material/AccountCircleOutlined';
import LockOutlinedIcon from '@mui/icons-material/LockOutlined';
import VisibilityOffOutlinedIcon from '@mui/icons-material/VisibilityOffOutlined';
import VisibilityOutlinedIcon from '@mui/icons-material/VisibilityOutlined';

const LoginPage = () => {
  const navigate = useNavigate();
  const [loading, setLoading] = useState(false);
  const [visiblePass, setVisiblePass] = useState(false);

  const handleSubmit = async (e) => {
    setLoading(!loading);
    e.preventDefault();
    const formData = new FormData(e.target);
    const email = formData.get("email");
    const password = formData.get("password");
    await APIAuth.signin({ email, password })
      .then((result) => {
        setLoading(false);
        result && navigate("/admin-dashboard/dashboard");
        Swal.fire({
          icon: "success",
          title: "Login Success",
          showConfirmButton: false,
          timer: 1500,
        });
      })
      .catch((err) => {
        setLoading(false);
        console.log(err);
        Swal.fire({
          icon: "error",
          title: "Failed",
          text: "Username or Password is Wrong",
        });
      });
  };

  const handleVisiblePass = () => {
    setVisiblePass(!visiblePass);
  }

  return (
    <>
      <Helmet>
        <title>Login Page</title>
        <meta name="description" content="Helmet application" />
      </Helmet>
      <section className="bg-gray-50 ">
        <div className="flex items-center justify-center py-8 mx-auto md:h-screen lg:py-0">
          <div className="bg-ten w-1/2 h-full flex justify-center content-center">
            <img src={login} alt="" className="w-96" />
          </div>
          <div className="w-1/2 flex justify-center content-center">
            <div className="w-full bg-white rounded-2xl custom shadow-dark md:mt-0 sm:max-w-md xl:p-0">
              <Link
                to="/"
                className="flex items-center justify-center mb-6 text-2xl font-bold text-gray-900 pt-10 xl:pt-20"
              >
                <img className="w-16 h-16 mr-2" src={SewaKantor} alt="logo" />
                SEWA KANTOR
              </Link>
              <div className="p-6 space-y-2 md:space-y-4 sm:p-8">
                <div className="flex flex-col items-start">
                  <h1 className="text-2xl font-bold leading-tight tracking-tight text-gray-900 md:text-2x">
                    Welcome Admin,
                  </h1>
                  <p className="text-base text-neutral-600">
                    Lets login to manage the app
                  </p>
                </div>
                <form onSubmit={handleSubmit} className="space-y-4 pt-4">
                  <div>
                    <div className="relative">
                      <input
                        type="text"
                        id="username"
                        name="email"
                        className="block px-2.5 pb-2.5 pt-4 w-full pl-11 text-sm text-gray-900 bg-transparent rounded-lg border-1 border-gray-300 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                        placeholder=" "
                      />
                      <label
                        htmlFor="username"
                        className="absolute text-sm text-gray-500 duration-300 transform -translate-y-4 scale-75 top-2 z-10 origin-[0] bg-white px-2 ml-10 peer-focus:px-2 peer-focus:text-blue-600 peer-focus:dark:text-blue-500 peer-placeholder-shown:scale-100 peer-placeholder-shown:-translate-y-1/2 peer-placeholder-shown:top-1/2 peer-focus:top-2 peer-focus:scale-75 peer-focus:-translate-y-4 left-0"
                      >
                        Username
                      </label>
                      <div className="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none">
                        <AccountCircleOutlinedIcon />
                      </div>
                    </div>
                  </div>
                  <div>
                    <div className="relative">
                      <input
                        type={visiblePass ? "text" : "password"}
                        id="password"
                        name="password"
                        className="block px-2.5 pb-2.5 pt-4 w-full pl-11 text-sm text-gray-900 bg-transparent rounded-lg border-1 border-gray-300 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                        placeholder=" "
                      />
                      <label
                        htmlFor="password"
                        className="absolute text-sm text-gray-500 duration-300 transform -translate-y-4 scale-75 top-2 z-10 origin-[0] bg-white px-2 ml-10 peer-focus:px-2 peer-focus:text-blue-600 peer-focus:dark:text-blue-500 peer-placeholder-shown:scale-100 peer-placeholder-shown:-translate-y-1/2 peer-placeholder-shown:top-1/2 peer-focus:top-2 peer-focus:scale-75 peer-focus:-translate-y-4 left-0"
                      >
                        Password
                      </label>
                      <div className="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none">
                        <LockOutlinedIcon />
                      </div>
                      <div onClick={handleVisiblePass} className="absolute cursor-pointer inset-y-0 right-0 flex items-center pr-3">
                        <div>{visiblePass ? <VisibilityOutlinedIcon /> : <VisibilityOffOutlinedIcon />}</div>
                      </div>
                    </div>
                  </div>
                  <div className="flex items-center justify-end">
                    <p className="font-normal text-sm text-neutral-500">
                      Forgot your password?
                      <Link
                        href="#"
                        className="text-sm font-bold pl-1 text-secondary hover:underline"
                      >
                        Reset password
                      </Link>
                    </p>
                  </div>
                  {loading ? <LoadingButton /> : <Button props={"Login"} />}
                </form>
              </div>
            </div>
          </div>
        </div>
      </section>
    </>
  );
};

export default LoginPage;
