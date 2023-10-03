import React from "react";
import { logo_black } from "assets";
import "./style.css";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import {
    faHouse,
    faPhone,
    faEnvelope,
    faPenToSquare,
    faSquareEnvelope,
} from "@fortawesome/free-solid-svg-icons";
import { Link } from "react-router-dom";

const Contact = () => {

    return (
        <div
            id="contact"
            className="bg-gray-200 py-20 lg:py-44 flex justify-center"
            data-aos="fade-up"
            data-aos-duration="1200"
        >
            <div className="container flex flex-col lg:flex-row content-center">
                <div className="lg:w-1/2">
                    <div className="text-center lg:text-start">
                        <h1 className="font-bold text-4xl my-4">Get In Touch</h1>
                        <div className="flex justify-center lg:justify-start">
                            <hr className="w-1/2 md:w-1/3 border-b-2 border-t-0 border-black mb-2" />
                        </div>
                        <p className="text-xl lg:w-3/4 py-4">
                            give us suggestions and input to make it better in the future
                        </p>
                    </div>
                    <div className="flex flex-col text-center lg:text-start">
                        <h3 className="font-bold text-xl 2xl:text-2xl my-8">
                            We’d Love to hear from you
                        </h3>
                        <div className="flex flex-col lg:flex-row content-center">
                            <div className="flex flex-col justify-center">
                                <img
                                    src={logo_black}
                                    alt=""
                                    className=" mb-4 px-12 w-full h-24 2xl:w-full lg:h-auto"
                                />
                                <p className="text-bgPrimary text-lg font-bold 2xl:text-xl">
                                    SEWA KANTOR
                                </p>
                            </div>
                            <div className="py-4 lg:py-1 lg:pl-4 2xl:pl-12">
                                <div className="flex py-2 items-center md:justify-center lg:justify-start">
                                    <FontAwesomeIcon icon={faHouse} className="2xl:h-6 mr-4" />
                                    <p className="font-semibold 2xl:text-xl">
                                        Senayan 33, Jakarta
                                    </p>
                                </div>
                                <div className="flex py-2 md:justify-center items-center lg:justify-start">
                                    <FontAwesomeIcon icon={faPhone} className="2xl:h-6 mr-4" />
                                    <p className="font-semibold 2xl:text-xl">0812-3456-7890</p>
                                </div>
                                <div className="flex py-2 items-center md:justify-center lg:justify-start">
                                    <FontAwesomeIcon icon={faEnvelope} className="2xl:h-6 mr-4" />
                                    <p className="font-semibold 2xl:text-xl">
                                        <Link>sewa.kantor@gmail.com</Link>
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <form className="lg:w-1/2 md:ml-12 2xl:ml-2">

                    <div className="bg-bgPrimary rounded-lg flex content-center my-4">
                        <div className="flex justify-end absolute">
                            <FontAwesomeIcon
                                icon={faEnvelope}
                                className="h-6 p-4 top-0 text-white"
                            />
                        </div>
                        <input
                            type="text"
                            placeholder="Input your email"
                            className="bg-bgPrimary text-white rounded-lg w-full py-4 pl-14 border-0 text-lg"
                        />
                    </div>
                    <div className="bg-bgPrimary flex-col rounded-lg flex content-center h-auto">
                        <textarea
                            type="text"
                            id="writesomething"
                            placeholder="Write something"
                            className="bg-bgPrimary text-white rounded-lg border-0 w-full h-40 p-4 text-lg"
                        />
                        <div className="flex justify-end absolute">
                            <FontAwesomeIcon
                                icon={faPenToSquare}
                                className="h-6 p-4 text-white relative top-24 left-[200px] md:left-[530px] lg:top-24 lg:left-[370px] xl:left-[490px] 2xl:left-[640px]"
                            />
                        </div>
                    </div>
                    <div className="my-4 w-full bg-blue-700 p-3 rounded-lg font-bold text-white">
                        <button type="submit">Send</button>
                    </div>
                </form>
            </div>
        </div>
    );
};

export default Contact;
