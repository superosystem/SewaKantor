import { SewaKantor } from "assets";
import React, { useEffect, useState } from "react";
import { NavLink, useLocation } from "react-router-dom";
import { HashLink, NavHashLink } from "react-router-hash-link";
import "./styles.css";

const Navbar = () => {
  const { hash } = useLocation();
  const isActive = (iHash) => hash === iHash;

  const [toggle, setToggle] = useState(false);
  const [navbar, setNavbar] = useState(true);

  const changeBackground = () => {
    if (window.scrollY > 0) {
      setNavbar(false);
    } else {
      setNavbar(true);
    }
  };

  window.addEventListener("scroll", changeBackground);

  const HANDLETOGGLE = () => {
    setToggle(!toggle);
  };

  useEffect(() => {
    setNavbar(true);
  }, []);

  return (
    <nav
      className={`${
        navbar
          ? "bg-white transition ease-in-out duration-300"
          : "transition ease-in-out duration-300 bg-bgPrimary text-white border-b border-b-slate-700 bg-opacity-90 backdrop-blur-md"
      } active px-2 sm:px-4 py-2.5 fixed w-full z-20 top-0 left-0`}
    >
      <div className="container flex flex-wrap items-center justify-between mx-auto">
        <HashLink smooth="true" to={`/login`} className="flex items-center">
          <img
            src={SewaKantor}
            className="h-6 mr-3 sm:h-12"
            alt="Flowbite Logo"
          />
          <span className="self-center text-2xl font-bold whitespace-nowrap">
            SEWA KANTOR
          </span>
        </HashLink>
        <button
          onClick={HANDLETOGGLE}
          data-collapse-toggle="navbar-default"
          type="button"
          className={` ${
            navbar ? "hover:bg-gray-200" : "hover:bg-gray-600"
          } inline-flex items-center p-2 ml-3 text-sm text-gray-200 rounded-lg md:hidden focus:outline-none focus:ring-2 focus:ring-gray-600`}
          aria-controls="navbar-default"
          aria-expanded="false"
        >
          <span className="sr-only">Open main menu</span>
          <svg
            className="w-6 h-6"
            aria-hidden="true"
            fill="currentColor"
            viewBox="0 0 20 20"
            xmlns="http://www.w3.org/2000/svg"
          >
            <path
              color={navbar ? "black" : "white"}
              fillRule="evenodd"
              d="M3 5a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1zM3 10a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1zM3 15a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1z"
              clipRule="evenodd"
            />
          </svg>
        </button>
        <div
          className={`${toggle ? "block" : "hidden"} w-full md:block md:w-auto`}
          id="navbar-default"
        >
          <ul className="flex flex-col p-4 mt-4 md:flex-row md:space-x-8 md:mt-0 md:text-sm md:font-medium items-center">
            <li className="flex justify-center items-center">
              <HashLink
                onClick={HANDLETOGGLE}
                smooth="true"
                to="/#"
                className="block py-2 pl-3 pr-4 md:hover:bg-transparent md:border-0 hover:text-blue-700 md:p-0"
              >
                Home
              </HashLink>
            </li>
            <li>
              <NavHashLink
                onClick={HANDLETOGGLE}
                smooth="true"
                to="/#features"
                style={
                  isActive("#features")
                    ? {
                        color: "#1d4ed8",
                        fontWeight: "bold",
                        transition:
                          "box-shadow 0.2s ease 0s, color 0.2s ease 0",
                      }
                    : {}
                }
                className="block py-2 pl-3 pr-4 md:hover:bg-transparent md:border-0 hover:text-blue-700 md:p-0"
              >
                Features
              </NavHashLink>
            </li>
            <li>
              <NavHashLink
                onClick={HANDLETOGGLE}
                smooth="true"
                to="/#testimonials"
                style={
                  isActive("#testimonials")
                    ? {
                        color: "#1d4ed8",
                        fontWeight: "bold",
                        transition:
                          "box-shadow 0.2s ease 0s, color 0.2s ease 0",
                      }
                    : {}
                }
                className="block py-2 pl-3 pr-4 md:hover:bg-transparent md:border-0 hover:text-blue-700 md:p-0"
              >
                Testimonials
              </NavHashLink>
            </li>
            <li>
              <NavHashLink
                onClick={HANDLETOGGLE}
                smooth="true"
                to="/#tips"
                style={
                  isActive("#tips")
                    ? {
                        color: "#1d4ed8",
                        fontWeight: "bold",
                        transition:
                          "box-shadow 0.2s ease 0s, color 0.2s ease 0",
                      }
                    : {}
                }
                className="block py-2 pl-3 pr-4  md:hover:bg-transparent md:border-0 hover:text-blue-700 md:p-0"
              >
                Step
              </NavHashLink>
            </li>
            <li>
              <NavHashLink
                onClick={HANDLETOGGLE}
                smooth="true"
                to="/#contact"
                style={
                  isActive("#contact")
                    ? {
                        color: "#1d4ed8",
                        fontWeight: "bold",
                        transition:
                          "box-shadow 0.2s ease 0s, color 0.2s ease 0",
                      }
                    : {}
                }
                className="block py-2 pl-3 pr-4  md:hover:bg-transparent md:border-0 hover:text-blue-700 md:p-0"
              >
                About us
              </NavHashLink>
            </li>
            <li>
              <HashLink smooth="true" to="/#hero">
                <button
                  type="button"
                  className="text-white bg-secondary hover:bg-blue-700 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center mr-3 md:mr-0"
                >
                  Get Now
                </button>
              </HashLink>
            </li>
          </ul>
        </div>
      </div>
    </nav>
  );
};

export default Navbar;
