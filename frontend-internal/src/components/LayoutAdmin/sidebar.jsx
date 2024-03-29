import React, { useState } from "react";
import { logo_black } from "assets";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import {
  faChevronLeft,
  faChevronRight,
  faSearch,
} from "@fortawesome/free-solid-svg-icons";
import { NavLink } from "react-router-dom";
import GridViewIcon from "@mui/icons-material/GridView";
import ManageAccountsOutlinedIcon from "@mui/icons-material/ManageAccountsOutlined";

let activeClassName =
  "bg-secondary text-white rounded-tr-full rounded-br-full mr-12";

let notActive = "my-auto text-lg";

const SidebarAdmin = ({ HANDLETOGGLE, toggle }) => {
  return (
    <div className={`bg-slate-900`}>
      <div className={`bg-white min-h-screen rounded-tr-[75px]`}>
        <div
          className={`${toggle ? "w-80 duration-200" : "w-48 ease-in-out"
            } ease-in-out duration-300 py-12`}
        >
          <div className="flex w-auto pl-16 mr-8">
            <img
              src={logo_black}
              className="h-20 hover:animate-bounce-slow"
              alt=""
            />
            <h4
              className={`${toggle ? "visible" : "invisible"
                } w-full my-auto font-bold text-xl ml-3`}
            >
              SEWA KANTOR
            </h4>
          </div>
          <div className="py-12 px-16">
            <div>
              <label className="flex">
                <FontAwesomeIcon
                  onClick={HANDLETOGGLE}
                  className="my-auto text-gray-500 pl-1 h-5"
                  icon={faSearch}
                />
                <input
                  className={`${toggle ? "visible" : "invisible"
                    } placeholder:text-slate-400 block w-full py-2 pl-12 pr-3 shadow-sm border-0 sm:text-lg focus:outline-none focus:ring-0`}
                  placeholder="Search "
                  type="text"
                  name="search"
                />
              </label>
            </div>
            <div className="absolute -right-4">
              <button
                onClick={HANDLETOGGLE}
                className="px-4 py-2 bg-secondary w-auto rounded-full"
              >
                <FontAwesomeIcon
                  className="my-auto mx-auto bg-secondary text-white h-4"
                  icon={toggle ? faChevronLeft : faChevronRight}
                />
              </button>
            </div>
          </div>
          <div>
            <div className="flex flex-col font-semibold text-gray-500 justify-start">
              <NavLink to={"/admin-dashboard/dashboard"}>
                {({ isActive }) => (
                  <div className={isActive ? activeClassName : notActive}>
                    <div className="flex py-4 pl-16 mr-8">
                      <GridViewIcon
                        className={isActive ? "text-white" : "text-gray-500"}
                        style={{ fontSize: "32px" }}
                      />
                      <p
                        className={`${toggle ? "visible" : "invisible"
                          } mx-8 my-auto text-lg`}
                      >
                        Dashboard
                      </p>
                    </div>
                  </div>
                )}
              </NavLink>
              <NavLink to={"/admin-dashboard/user"}>
                {({ isActive }) => (
                  <div className={isActive ? activeClassName : notActive}>
                    <div className="flex py-4 pl-16 mr-8">
                      <ManageAccountsOutlinedIcon
                        className={isActive ? "text-white" : "text-gray-500"}
                        style={{ fontSize: "32px" }}
                      />
                      <p
                        className={`${toggle ? "visible" : "invisible"
                          } mx-8 my-auto text-lg`}
                      >
                        User
                      </p>
                    </div>
                  </div>
                )}
              </NavLink>
              <NavLink to={"/admin-dashboard/office"}>
                {({ isActive }) => (
                  <div className={isActive ? activeClassName : notActive}>
                    <div className="flex py-4 pl-16 mr-8 ">
                      <div
                        className={isActive ? "text-white" : "text-gray-500"}
                      >
                        <svg
                          width="32"
                          height="32"
                          viewBox="0 0 32 32"
                          className="fill-current"
                          xmlns="http://www.w3.org/2000/svg"
                        >
                          <path d="M4 2C4 1.46957 4.21071 0.960859 4.58579 0.585786C4.96086 0.210714 5.46957 0 6 0L26 0C26.5304 0 27.0391 0.210714 27.4142 0.585786C27.7893 0.960859 28 1.46957 28 2V15C28 15.2652 27.8946 15.5196 27.7071 15.7071C27.5196 15.8946 27.2652 16 27 16C26.7348 16 26.4804 15.8946 26.2929 15.7071C26.1054 15.5196 26 15.2652 26 15V2H6V30H12V25C12 24.7348 12.1054 24.4804 12.2929 24.2929C12.4804 24.1054 12.7348 24 13 24H16V32H6C5.46957 32 4.96086 31.7893 4.58579 31.4142C4.21071 31.0391 4 30.5304 4 30V2Z" />
                          <path d="M9 4C8.73478 4 8.48043 4.10536 8.29289 4.29289C8.10536 4.48043 8 4.73478 8 5V7C8 7.26522 8.10536 7.51957 8.29289 7.70711C8.48043 7.89464 8.73478 8 9 8H11C11.2652 8 11.5196 7.89464 11.7071 7.70711C11.8946 7.51957 12 7.26522 12 7V5C12 4.73478 11.8946 4.48043 11.7071 4.29289C11.5196 4.10536 11.2652 4 11 4H9ZM15 4C14.7348 4 14.4804 4.10536 14.2929 4.29289C14.1054 4.48043 14 4.73478 14 5V7C14 7.26522 14.1054 7.51957 14.2929 7.70711C14.4804 7.89464 14.7348 8 15 8H17C17.2652 8 17.5196 7.89464 17.7071 7.70711C17.8946 7.51957 18 7.26522 18 7V5C18 4.73478 17.8946 4.48043 17.7071 4.29289C17.5196 4.10536 17.2652 4 17 4H15ZM21 4C20.7348 4 20.4804 4.10536 20.2929 4.29289C20.1054 4.48043 20 4.73478 20 5V7C20 7.26522 20.1054 7.51957 20.2929 7.70711C20.4804 7.89464 20.7348 8 21 8H23C23.2652 8 23.5196 7.89464 23.7071 7.70711C23.8946 7.51957 24 7.26522 24 7V5C24 4.73478 23.8946 4.48043 23.7071 4.29289C23.5196 4.10536 23.2652 4 23 4H21ZM9 10C8.73478 10 8.48043 10.1054 8.29289 10.2929C8.10536 10.4804 8 10.7348 8 11V13C8 13.2652 8.10536 13.5196 8.29289 13.7071C8.48043 13.8946 8.73478 14 9 14H11C11.2652 14 11.5196 13.8946 11.7071 13.7071C11.8946 13.5196 12 13.2652 12 13V11C12 10.7348 11.8946 10.4804 11.7071 10.2929C11.5196 10.1054 11.2652 10 11 10H9ZM15 10C14.7348 10 14.4804 10.1054 14.2929 10.2929C14.1054 10.4804 14 10.7348 14 11V13C14 13.2652 14.1054 13.5196 14.2929 13.7071C14.4804 13.8946 14.7348 14 15 14H17C17.2652 14 17.5196 13.8946 17.7071 13.7071C17.8946 13.5196 18 13.2652 18 13V11C18 10.7348 17.8946 10.4804 17.7071 10.2929C17.5196 10.1054 17.2652 10 17 10H15ZM21 10C20.7348 10 20.4804 10.1054 20.2929 10.2929C20.1054 10.4804 20 10.7348 20 11V13C20 13.2652 20.1054 13.5196 20.2929 13.7071C20.4804 13.8946 20.7348 14 21 14H23C23.2652 14 23.5196 13.8946 23.7071 13.7071C23.8946 13.5196 24 13.2652 24 13V11C24 10.7348 23.8946 10.4804 23.7071 10.2929C23.5196 10.1054 23.2652 10 23 10H21ZM9 16C8.73478 16 8.48043 16.1054 8.29289 16.2929C8.10536 16.4804 8 16.7348 8 17V19C8 19.2652 8.10536 19.5196 8.29289 19.7071C8.48043 19.8946 8.73478 20 9 20H11C11.2652 20 11.5196 19.8946 11.7071 19.7071C11.8946 19.5196 12 19.2652 12 19V17C12 16.7348 11.8946 16.4804 11.7071 16.2929C11.5196 16.1054 11.2652 16 11 16H9ZM15 16C14.7348 16 14.4804 16.1054 14.2929 16.2929C14.1054 16.4804 14 16.7348 14 17V19C14 19.2652 14.1054 19.5196 14.2929 19.7071C14.4804 19.8946 14.7348 20 15 20H17C17.2652 20 17.5196 19.8946 17.7071 19.7071C17.8946 19.5196 18 19.2652 18 19V17C18 16.7348 17.8946 16.4804 17.7071 16.2929C17.5196 16.1054 17.2652 16 17 16H15ZM23.772 18.92C24.132 17.694 25.868 17.694 26.23 18.92L26.316 19.216C26.3697 19.3996 26.4639 19.5688 26.5916 19.7113C26.7194 19.8537 26.8774 19.9656 27.0541 20.0389C27.2308 20.1122 27.4217 20.145 27.6127 20.1348C27.8038 20.1246 27.9901 20.0717 28.158 19.98L28.43 19.832C29.552 19.22 30.78 20.448 30.17 21.57L30.02 21.842C29.9287 22.0098 29.8761 22.196 29.8661 22.3868C29.8561 22.5776 29.8889 22.7682 29.9622 22.9446C30.0355 23.1211 30.1473 23.2789 30.2895 23.4065C30.4317 23.5341 30.6007 23.6282 30.784 23.682L31.082 23.772C32.306 24.132 32.306 25.868 31.082 26.23L30.782 26.316C30.5987 26.3702 30.4299 26.4647 30.288 26.5926C30.146 26.7205 30.0345 26.8786 29.9616 27.0553C29.8887 27.2319 29.8563 27.4227 29.8668 27.6135C29.8772 27.8043 29.9303 27.9904 30.022 28.158L30.17 28.43C30.78 29.552 29.552 30.78 28.43 30.17L28.158 30.02C27.9902 29.9287 27.804 29.8761 27.6132 29.8661C27.4224 29.8561 27.2318 29.8889 27.0554 29.9622C26.8789 30.0355 26.7211 30.1473 26.5935 30.2895C26.4659 30.4317 26.3718 30.6007 26.318 30.784L26.228 31.082C25.868 32.306 24.132 32.306 23.77 31.082L23.684 30.782C23.6298 30.5987 23.5353 30.4299 23.4074 30.288C23.2795 30.146 23.1214 30.0345 22.9447 29.9616C22.7681 29.8887 22.5773 29.8563 22.3865 29.8668C22.1957 29.8772 22.0096 29.9303 21.842 30.022L21.57 30.17C20.448 30.78 19.22 29.552 19.83 28.43L19.98 28.158C20.0713 27.9902 20.1239 27.804 20.1339 27.6132C20.1439 27.4224 20.1111 27.2318 20.0378 27.0554C19.9645 26.8789 19.8527 26.7211 19.7105 26.5935C19.5683 26.4659 19.3993 26.3718 19.216 26.318L18.92 26.228C17.694 25.868 17.694 24.132 18.92 23.77L19.216 23.684C19.3996 23.6303 19.5688 23.5361 19.7113 23.4084C19.8537 23.2806 19.9656 23.1226 20.0389 22.9459C20.1122 22.7692 20.145 22.5783 20.1348 22.3873C20.1246 22.1962 20.0717 22.0099 19.98 21.842L19.832 21.57C19.22 20.448 20.448 19.22 21.57 19.83L21.842 19.98C22.0098 20.0713 22.196 20.1239 22.3868 20.1339C22.5775 20.1439 22.7682 20.1111 22.9446 20.0378C23.1211 19.9645 23.2789 19.8527 23.4065 19.7105C23.5341 19.5683 23.6282 19.3993 23.682 19.216L23.772 18.92ZM28 25C28 24.606 27.9224 24.2159 27.7716 23.8519C27.6209 23.488 27.3999 23.1573 27.1213 22.8787C26.8427 22.6001 26.512 22.3791 26.1481 22.2284C25.7841 22.0776 25.394 22 25 22C24.606 22 24.2159 22.0776 23.8519 22.2284C23.488 22.3791 23.1573 22.6001 22.8787 22.8787C22.6001 23.1573 22.3791 23.488 22.2284 23.8519C22.0776 24.2159 22 24.606 22 25C22 25.7956 22.3161 26.5587 22.8787 27.1213C23.4413 27.6839 24.2044 28 25 28C25.7956 28 26.5587 27.6839 27.1213 27.1213C27.6839 26.5587 28 25.7956 28 25Z" />
                        </svg>
                      </div>
                      <p
                        className={`${toggle ? "visible" : "invisible"
                          } mx-8 my-auto text-lg `}
                      >
                        Office
                      </p>
                    </div>
                  </div>
                )}
              </NavLink>
              <NavLink to={"/admin-dashboard/transaction"}>
                {({ isActive }) => (
                  <div className={isActive ? activeClassName : notActive}>
                    <div className="flex py-4 pl-16 mr-8">
                      <div
                        className={
                          isActive ? "stroke-white" : "stroke-gray-500"
                        }
                      >
                        <svg
                          width="32"
                          height="32"
                          viewBox="0 0 32 32"
                          fill="none"
                          className="stroke-current"
                          xmlns="http://www.w3.org/2000/svg"
                        >
                          <path
                            d="M24.6667 5.33301H7.33333C6.59695 5.33301 6 5.92996 6 6.66634V27.9997C6 28.7361 6.59695 29.333 7.33333 29.333H24.6667C25.403 29.333 26 28.7361 26 27.9997V6.66634C26 5.92996 25.403 5.33301 24.6667 5.33301Z"
                            stroke={
                              isActive ? "stroke-white" : "stroke-gray-500"
                            }
                            strokeWidth="2"
                            strokeLinejoin="round"
                          />
                          <path
                            d="M12 2.6665V6.6665M20 2.6665V6.6665M10.6666 12.6665H21.3333M10.6666 17.9998H18.6666M10.6666 23.3332H16"
                            stroke={
                              isActive ? "stroke-white" : "stroke-gray-500"
                            }
                            strokeWidth="2"
                            strokeLinecap="round"
                            strokeLinejoin="round"
                          />
                        </svg>
                      </div>
                      <p
                        className={`${toggle ? "visible" : "invisible"
                          } mx-8 my-auto text-lg`}
                      >
                        Transaction
                      </p>
                    </div>
                  </div>
                )}
              </NavLink>
              <NavLink to={"/admin-dashboard/review"}>
                {({ isActive }) => (
                  <div className={isActive ? activeClassName : notActive}>
                    <div className="flex py-4 pl-16 mr-8">
                      <div
                        className={isActive ? "text-white" : "text-gray-500"}
                      >
                        <svg
                          width="32"
                          height="32"
                          viewBox="0 0 32 32"
                          className="fill-current"
                          xmlns="http://www.w3.org/2000/svg"
                        >
                          <path d="M16 10.6665C15.6463 10.6665 15.3072 10.807 15.0571 11.057C14.8071 11.3071 14.6666 11.6462 14.6666 11.9998V17.3332C14.6666 17.6868 14.8071 18.0259 15.0571 18.276C15.3072 18.526 15.6463 18.6665 16 18.6665C16.3536 18.6665 16.6927 18.526 16.9428 18.276C17.1928 18.0259 17.3333 17.6868 17.3333 17.3332V11.9998C17.3333 11.6462 17.1928 11.3071 16.9428 11.057C16.6927 10.807 16.3536 10.6665 16 10.6665ZM10.6666 14.6665C10.313 14.6665 9.97387 14.807 9.72382 15.057C9.47377 15.3071 9.33329 15.6462 9.33329 15.9998V17.3332C9.33329 17.6868 9.47377 18.0259 9.72382 18.276C9.97387 18.526 10.313 18.6665 10.6666 18.6665C11.0202 18.6665 11.3594 18.526 11.6094 18.276C11.8595 18.0259 12 17.6868 12 17.3332V15.9998C12 15.6462 11.8595 15.3071 11.6094 15.057C11.3594 14.807 11.0202 14.6665 10.6666 14.6665ZM25.3333 2.6665H6.66663C5.60576 2.6665 4.58834 3.08793 3.8382 3.83808C3.08805 4.58822 2.66663 5.60564 2.66663 6.6665V19.9998C2.66663 21.0607 3.08805 22.0781 3.8382 22.8283C4.58834 23.5784 5.60576 23.9998 6.66663 23.9998H22.12L27.0533 28.9465C27.1779 29.0701 27.3256 29.1678 27.4881 29.2342C27.6505 29.3006 27.8245 29.3342 28 29.3332C28.1749 29.3377 28.3484 29.3011 28.5066 29.2265C28.7501 29.1265 28.9586 28.9566 29.1057 28.7383C29.2528 28.52 29.332 28.2631 29.3333 27.9998V6.6665C29.3333 5.60564 28.9119 4.58822 28.1617 3.83808C27.4116 3.08793 26.3942 2.6665 25.3333 2.6665ZM26.6666 24.7865L23.6133 21.7198C23.4887 21.5963 23.341 21.4985 23.1785 21.4321C23.0161 21.3658 22.8421 21.3322 22.6666 21.3332H6.66663C6.313 21.3332 5.97387 21.1927 5.72382 20.9426C5.47377 20.6926 5.33329 20.3535 5.33329 19.9998V6.6665C5.33329 6.31288 5.47377 5.97374 5.72382 5.7237C5.97387 5.47365 6.313 5.33317 6.66663 5.33317H25.3333C25.6869 5.33317 26.0261 5.47365 26.2761 5.7237C26.5261 5.97374 26.6666 6.31288 26.6666 6.6665V24.7865ZM21.3333 7.99984C20.9797 7.99984 20.6405 8.14031 20.3905 8.39036C20.1404 8.64041 20 8.97955 20 9.33317V17.3332C20 17.6868 20.1404 18.0259 20.3905 18.276C20.6405 18.526 20.9797 18.6665 21.3333 18.6665C21.6869 18.6665 22.0261 18.526 22.2761 18.276C22.5261 18.0259 22.6666 17.6868 22.6666 17.3332V9.33317C22.6666 8.97955 22.5261 8.64041 22.2761 8.39036C22.0261 8.14031 21.6869 7.99984 21.3333 7.99984Z" />
                        </svg>
                      </div>
                      <p
                        className={`${toggle ? "visible" : "invisible"
                          } mx-8 my-auto text-lg`}
                      >
                        Review
                      </p>
                    </div>
                  </div>
                )}
              </NavLink>
              <NavLink to={"/admin-dashboard/promo"}>
                {({ isActive }) => (
                  <div className={isActive ? activeClassName : notActive}>
                    <div className="flex py-4 pl-16 mr-8">
                      <div
                        className={
                          isActive ? "stroke-white" : "stroke-gray-500"
                        }
                      >
                        <svg
                          width="32"
                          height="32"
                          viewBox="0 0 32 32"
                          fill="none"
                          className="stroke-current"
                          xmlns="http://www.w3.org/2000/svg"
                        >
                          <path
                            d="M12 20L20 12"
                            stroke={
                              isActive ? "stroke-white" : "stroke-gray-500"
                            }
                            strokeWidth="2"
                            strokeLinecap="round"
                            strokeLinejoin="round"
                          />
                          <path
                            d="M12.6667 13.3333C13.0349 13.3333 13.3333 13.0349 13.3333 12.6667C13.3333 12.2985 13.0349 12 12.6667 12C12.2985 12 12 12.2985 12 12.6667C12 13.0349 12.2985 13.3333 12.6667 13.3333Z"
                            fill="#666666"
                            stroke={
                              isActive ? "stroke-white" : "stroke-gray-500"
                            }
                            strokeWidth="2"
                            strokeLinecap="round"
                            strokeLinejoin="round"
                          />
                          <path
                            d="M19.3333 20.0003C19.7015 20.0003 20 19.7018 20 19.3337C20 18.9655 19.7015 18.667 19.3333 18.667C18.9651 18.667 18.6666 18.9655 18.6666 19.3337C18.6666 19.7018 18.9651 20.0003 19.3333 20.0003Z"
                            fill="#666666"
                            stroke={
                              isActive ? "stroke-white" : "stroke-gray-500"
                            }
                            strokeWidth="2"
                            strokeLinecap="round"
                            strokeLinejoin="round"
                          />
                          <path
                            d="M6.66667 9.60013C6.66667 8.82216 6.97572 8.07605 7.52582 7.52595C8.07593 6.97584 8.82204 6.66679 9.6 6.66679H10.9333C11.7079 6.66635 12.4508 6.3596 13 5.81346L13.9333 4.88013C14.2059 4.60599 14.53 4.38845 14.887 4.24C15.244 4.09156 15.6267 4.01514 16.0133 4.01514C16.3999 4.01514 16.7827 4.09156 17.1397 4.24C17.4966 4.38845 17.8207 4.60599 18.0933 4.88013L19.0267 5.81346C19.5759 6.3596 20.3188 6.66635 21.0933 6.66679H22.4267C23.2046 6.66679 23.9507 6.97584 24.5009 7.52595C25.051 8.07605 25.36 8.82216 25.36 9.60013V10.9335C25.3604 11.708 25.6672 12.4509 26.2133 13.0001L27.1467 13.9335C27.4208 14.2061 27.6383 14.5302 27.7868 14.8871C27.9352 15.2441 28.0117 15.6269 28.0117 16.0135C28.0117 16.4001 27.9352 16.7828 27.7868 17.1398C27.6383 17.4968 27.4208 17.8209 27.1467 18.0935L26.2133 19.0268C25.6672 19.576 25.3604 20.3189 25.36 21.0935V22.4268C25.36 23.2048 25.051 23.9509 24.5009 24.501C23.9507 25.0511 23.2046 25.3601 22.4267 25.3601H21.0933C20.3188 25.3606 19.5759 25.6673 19.0267 26.2135L18.0933 27.1468C17.8207 27.4209 17.4966 27.6385 17.1397 27.7869C16.7827 27.9354 16.3999 28.0118 16.0133 28.0118C15.6267 28.0118 15.244 27.9354 14.887 27.7869C14.53 27.6385 14.2059 27.4209 13.9333 27.1468L13 26.2135C12.4508 25.6673 11.7079 25.3606 10.9333 25.3601H9.6C8.82204 25.3601 8.07593 25.0511 7.52582 24.501C6.97572 23.9509 6.66667 23.2048 6.66667 22.4268V21.0935C6.66623 20.3189 6.35947 19.576 5.81334 19.0268L4.88 18.0935C4.60587 17.8209 4.38833 17.4968 4.23988 17.1398C4.09143 16.7828 4.01501 16.4001 4.01501 16.0135C4.01501 15.6269 4.09143 15.2441 4.23988 14.8871C4.38833 14.5302 4.60587 14.2061 4.88 13.9335L5.81334 13.0001C6.35947 12.4509 6.66623 11.708 6.66667 10.9335V9.60013"
                            stroke={
                              isActive ? "stroke-white" : "stroke-gray-500"
                            }
                            strokeWidth="2"
                            strokeLinecap="round"
                            strokeLinejoin="round"
                          />
                        </svg>
                      </div>
                      <p
                        className={`${toggle ? "visible" : "invisible"
                          } mx-8 my-auto text-lg`}
                      >
                        Promo
                      </p>
                    </div>
                  </div>
                )}
              </NavLink>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default SidebarAdmin;
