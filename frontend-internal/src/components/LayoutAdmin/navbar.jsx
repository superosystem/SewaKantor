import React, { useEffect, useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import { twitter } from "assets";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import {
  faCaretDown,
  faRightFromBracket,
} from "@fortawesome/free-solid-svg-icons";
import Auth from "utils/auth";
import Swal from "sweetalert2";
import { useLocation } from "react-router-dom";
const NavbarAdmin = () => {
  const [toggle, setToggle] = useState(false);
  const navigate = useNavigate();
  const HANDLETOGGLE = () => {
    setToggle(!toggle);
  };

  let location = useLocation();
  const data = location.pathname.substring(17);
  const capitalize = data.charAt(0).toUpperCase() + data.slice(1);

  const handleLogout = () => {
    const swalWithBootstrapButtons = Swal.mixin({
      customClass: {
        confirmButton:
          "focus:outline-none text-white bg-fifth hover:bg-red-600 font-medium rounded-lg text-sm px-5 py-2.5 mr-2 mb-2",
        cancelButton:
          "py-2.5 px-5 mr-2 mb-2 text-sm font-medium text-gray-900 focus:outline-none bg-white rounded-lg border border-gray-200 hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-4 focus:ring-gray-200",
      },
      buttonsStyling: false,
    });
    swalWithBootstrapButtons
      .fire({
        title: "Logout?",
        text: "You will Directed to Login Page",
        showCancelButton: true,
        confirmButtonText: "Yes, Logout",
        cancelButtonText: "No, cancel",
        reverseButtons: true,
      })
      .then((result) => {
        if (result.isConfirmed) {
          try {
            Auth.signOut(navigate);
            Swal.fire(
              {
                icon: "success",
                title: "Logout!",
                text: "Logout Success",
                showConfirmButton: false,
                timer: 1200
              }
            );
          } catch (error) {
            return Swal.fire({
              icon: "error",
              title: "Oops...",
              text: "Logout is Failed, Your Connection is Interupted ",
            });
          }
        }
      });
  };
  useEffect(() => {
    setToggle(false);
  }, []);
  return (
    <div className="">
      <div className="bg-bgPrimary text-white flex justify-center">
        <div className="container">
          <nav className="flex justify-between my-4">
            <Link className="my-auto font-normal">
              Dashboard <span className="text-[#808080]">/ {capitalize}</span>
            </Link>
            <div className="flex flex-col">
              <button
                id="dropdownDividerButton"
                onClick={HANDLETOGGLE}
                data-dropdown-toggle="dropdownDivider"
                className="flex content-center bg-sky-800 rounded-full px-4 py-2 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium"
              >
                <img
                  src={twitter}
                  onClick={HANDLETOGGLE}
                  alt=""
                  className="w-12 border-4 rounded-full border-sky-700 my-auto"
                />
                <p className="my-auto px-4 font-bold">Admin Slot</p>
                <FontAwesomeIcon
                  className="my-auto pr-4"
                  onClick={HANDLETOGGLE}
                  icon={faCaretDown}
                />
              </button>
              <div
                id="dropdownDivider"
                className={`${toggle ? "visible absolute" : "hidden"}`}
              >
                <div className="my-auto text-slate-900 py-2">
                  <button
                    onClick={handleLogout}
                    className="inline-block relative -right-6 top-20 z-10 w-44 h-auto bg-white rounded-2xl divide-y divide-gray-100 shadow dark:bg-gray-700 dark:divide-gray-600 py-2 px-4 text-lg my-auto text-gray-700 hover:bg-red-700  hover:text-white dark:hover:bg-red-700 dark:text-gray-200 dark:hover:text-white font-bold"
                  >
                    <FontAwesomeIcon
                      className="my-auto pr-4"
                      icon={faRightFromBracket}
                    />
                    Logout
                  </button>
                </div>
              </div>
            </div>
          </nav>
        </div>
      </div>
    </div>
  );
};

export default NavbarAdmin;
