import { Navbar, Footer } from "components/index";
import React from "react";
import { Helmet } from "react-helmet";
import Contact from "./Contact";
import Features from "./Features";
import Headers from "./Header";
import "./style.css";
import Testimonials from "./Testimonials";
import Tips from "./Tips";

const LandingPage = () => {
  return (
    <div>
      <Helmet>
        <title>SEWA KANTOR</title>
        <meta name="description" content="Helmet application" />
      </Helmet>
      <Navbar />
      <Headers />
      <Features />
      <Testimonials />
      <Tips />
      <Contact />
      <Footer />
    </div>
  );
};

export default LandingPage;
