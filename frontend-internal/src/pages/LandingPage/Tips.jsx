import React from "react";
import { mockup_phone } from "assets";

const Tips = () => {
    return (
        <div className="flex justify-center py-12 lg:py-32" id="tips">
            <div className="container flex flex-col lg:flex-row lg:content-center md:justify-around">
                <div data-aos="zoom-in-right" className="md:w-3/4 lg:w-1/2 m-auto">
                    <img
                        src={mockup_phone}
                        alt="Mockup Phone"
                        className="w-full py-12 md:w-full lg:w-auto md:p-12"
                    />
                </div>
                <div
                    data-aos="zoom-in-left"
                    className="py-12 lg:w-1/2 text-center md:text-start"
                >
                    <h1 className=" text-3xl 2xl:text-4xl font-bold md:w-1/2 pb-4">
                        Very Easy step to booking!
                    </h1>
                    <div className="flex justify-center md:justify-start">
                        <hr className="w-1/2 md:w-1/3 border-b-2 border-t-0 border-black mb-2" />
                    </div>
                    <p className="text-lg">
                        only with 2 steps of using this application. you can book what
                        working space do you want!
                    </p>
                    <div className="pb-4 2xl:pb-8 pt-4">
                        <h3 className="font-bold 2xl:text-2xl lg:text-lg">Install App</h3>
                        <p className="font-normal text-lg">
                            Search for 'SEWA KANTOR' on playstore or appstore.{" "}
                        </p>
                    </div>
                    <div className="pb-4 2xl:pb-8">
                        <h3 className="font-bold 2xl:text-2xl lg:text-lg">
                            Search or choose your workspace
                        </h3>
                        <p className="font-normal text-lg">
                            available popular workspaces and recommendations.
                        </p>
                    </div>
                    <div className="pb-4 2xl:pb-8">
                        <h3 className="font-bold 2xl:text-2xl lg:text-lg">Fast booking!</h3>
                        <p className="font-normal text-lg">
                            Just booking and pay with scan barcode. Then, it’s done.
                        </p>
                    </div>
                </div>
            </div>
        </div>
    );
};

export default Tips;
