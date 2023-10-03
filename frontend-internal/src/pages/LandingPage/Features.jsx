import React from "react";
import { fitur1, fitur2, fitur3, fitur4 } from "assets";
import "./style.css";
import { Helmet } from "react-helmet";

const Feature = ({ imgUrl, title, desc, efect }) => (
  <div
    className="p-4 mt-2 md:w-1/2 lg:w-1/4 lg:px-8"
    data-aos={efect}
    data-aos-offset="500"
    data-aos-duration="1000"
  >
    <div className="flex justify-center content-center">
      <img src={imgUrl} alt="" />
    </div>
    <h3 className="font-bold py-3">{title}</h3>
    <p className="w-50 font-normal">{desc}</p>
  </div>
);

const Features = () => {
  return (
    <>
      <div id="features" className="bg-bgPrimary flex justify-center">
        <div className="container flex flex-col text-white py-24 md:py-12 lg:py-28 2xl:py-32">
          <div data-aos="fade-up">
            <h1 className="pb-4 text-2xl font-bold lg:text-3xl">
              Amazing Apps Feature!
            </h1>
            <div className="flex justify-center py-2">
              <hr className="w-44" />
            </div>
            <p className="p-2">
              4 of the best mainstay features that will make your awesome booking.
              don't miss it!
            </p>
          </div>
          <div
            data-aos="zoom-in"
            className="flex flex-col md:flex-row md:flex-wrap justify-center pt-12"
          >
            <Feature
              imgUrl={fitur1}
              // efect="fade-up"
              title="Popular Workspace"
              desc="A features that give you the top and most popular workspaces by visitor rating. will definitely give you the best experience for working."
            />
            <Feature
              imgUrl={fitur2}
              title="Workspace Recommendation"
              desc="A feature that provides recommendations for the closest workspace. Of course you can choose the workspace according to what you want."
            />
            <Feature
              imgUrl={fitur3}
              title="Custom your Wishlist"
              desc="Wishlist saving feature. You can add a wishlist according to your wish, just by clicking the save icon, your wishlist is already saved."
            />
            <Feature
              imgUrl={fitur4}
              title="Easy Booking"
              desc="Experience an easy and attractive booking experience. Easy booking with just a barcode scan, interesting!"
            />
          </div>
        </div>
      </div>
    </>
  );
};

export default Features;
