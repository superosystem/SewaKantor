import { notfound } from "assets";
import React from "react";
import { Helmet } from "react-helmet";
import { Link } from "react-router-dom";

const NotFoundPage = () => {
    return (
        <>
            <Helmet>
                <title>404 Not Found</title>
                <meta name="description" content="Helmet application" />
            </Helmet>

            <div className="flex flex-col md:flex-row justify-center h-screen content-center">
                <div className="md:flex w-full px-12 lg:px-2 lg:w-4/5">
                    <div className="w-full lg:w-1/2 md:pl-16 md:pr-12 lg:pr-0 mx-auto my-auto">
                        <img src={notfound} alt="" />
                    </div>
                    <div className="w-full lg:w-1/2 lg:pr-16 pt-12 md:pt-0 mx-auto md:my-auto">
                        <div className="text-start">
                            <p className="text-3xl lg:text-5xl font-semibold mb-4 lg:mb-8">404 Page not <span className="text-secondary">found</span></p>
                            <p className="text-xl lg:text-2xl lg:w-3/4">We could not find the page you are looking for. The page you are looking for does not exist or has been moved</p>
                            <Link to="/">
                                <button className="py-2 px-4 mt-4 lg:mt-8 bg-secondary text-white rounded-lg w-1/2 lg:w-1/3">Back to Home</button>
                            </Link>
                        </div>
                    </div>
                </div>
            </div>
        </>
    )
}

export default NotFoundPage;