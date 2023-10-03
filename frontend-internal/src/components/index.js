import Navbar from "./Navbar/index";
import Footer from "./Footer/index";
import LayoutAdmin from "./LayoutAdmin";

import AdminPage from "./LayoutAdmin/admin";
import UserPage from "./LayoutAdmin/user";
import OfficePage from "./LayoutAdmin/office";
import TransactionPage from "./LayoutAdmin/transaction";
import ReviewPage from "./LayoutAdmin/review";
import PromoPage from "./LayoutAdmin/promo";
import DashboardPage from "./LayoutAdmin/dashboard";
import EditOffice from "./Modal/ModalOffice/EditOffice";
import AddOffice from "./Modal/ModalOffice/AddOffice";
import ContentTableLoader from "./Loader/ContentTableLoader";

export { AdminPage, UserPage, OfficePage, TransactionPage, ReviewPage, PromoPage, DashboardPage, EditOffice, AddOffice };
export { Navbar, Footer, LayoutAdmin };

// Loader
export { ContentTableLoader };