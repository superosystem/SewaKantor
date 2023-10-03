import React from "react";
import { logo, facebook, twitter, instagram } from "assets/index";
import { HashLink } from 'react-router-hash-link';
import { Link } from "react-router-dom";
import { animateScroll as scroll } from 'react-scroll';


const Footer = () => {
    const scrollToTop = () => {
        scroll.scrollToTop();
    }

    return (
        <div className="bg-bgPrimary py-12 flex justify-center">
            <div className="container text-white">
                <div className="flex flex-col md:flex-row lg:flex-row justify-between">
                    <div className="flex flex-col content-center">
                        <div className="flex content-center">
                            <img src={logo} alt="logo-better" />
                            <p className="items-center px-4 py-6 text-2xl font-bold">SEWA KANTOR</p>
                        </div>
                        <div className="py-8">
                            <p className="text-lg md:w-60 lg:w-96 text-start">Mobile-based applications that will make your life easier for booking a workspace</p>
                        </div>
                        <div className="pt-2 pb-4 flex lg:pt-4">
                            <img src={instagram} alt="instagram" className="pr-4" />
                            <img src={twitter} alt="twitter" className="pr-4" />
                            <img src={facebook} alt="instagram" className="pr-4" />
                        </div>
                    </div>
                    <div className="flex flex-col md:flex-row lg:flex-row lg:px-12">
                        <div className="text-start flex flex-col md:pr-12 lg:px-8 2xl:px-32">
                            <h3 className="font-bold text-lg py-4">MAIN MENU</h3>
                            <HashLink
                                smooth
                                to="/#hero"
                                className="block py-2 my-1 pr-4 text-white md:hover:bg-transparent md:border-0 hover:text-blue-700 md:p-0">
                                Home
                            </HashLink>
                            <HashLink
                                smooth
                                to="/#features"
                                className="block py-2 my-1 pr-4 text-white md:hover:bg-transparent md:border-0 hover:text-blue-700 md:p-0">
                                Feature
                            </HashLink>
                            <HashLink
                                smooth
                                to="/#testimonials"
                                className="block py-2 my-1 pr-4 text-white md:hover:bg-transparent md:border-0 hover:text-blue-700 md:p-0">
                                Testimonial
                            </HashLink>
                            <HashLink
                                smooth
                                to="/#tips"
                                className="block py-2 my-1 pr-4 text-white md:hover:bg-transparent md:border-0 hover:text-blue-700 md:p-0">
                                Step
                            </HashLink>
                            <HashLink
                                smooth
                                to="/#contact"
                                className="block py-2 my-1 pr-4 text-white md:hover:bg-transparent md:border-0 hover:text-blue-700 md:p-0">
                                About us
                            </HashLink>
 
                        </div>
                        <div className="text-start flex flex-col">
                            <h3 className="font-bold text-lg pt-8 md:py-4 lg:py-4">CONTACT</h3>
                            <HashLink className="my-1" to="/#">Senayan 33, Jakarta</HashLink>
                            <HashLink className="my-1" to="/#">sewa.kantor@gmail.com</HashLink>
                            <HashLink className="my-1" to="/#">0812-3456-7890</HashLink>
                        </div>
                    </div>
                </div>
                <div className="text-center pt-12">
                    <Link href="">Sewa Kantor | 2022</Link>
                </div>
            </div>
        </div>
    );
};

export default Footer;