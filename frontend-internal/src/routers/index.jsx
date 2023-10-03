import {
  DashboardPage,
  TransactionPage,
  UserPage,
  OfficePage,
  ReviewPage,
  PromoPage,
  AdminPage,
  EditOffice,
  AddOffice,
} from "components";
import NotFoundPage from "pages/NotFoundPage";
import React from "react";
import { Routes, Route } from "react-router-dom";
import { LandingPage, LoginPage } from "../pages";
import PrivateRoute from "./privateRoutes";
import ProtectedRoute from "./protectedRoutes";

const SetupRouters = () => {
  return (
    <Routes>
      {/*Landingpage Routes*/}
      <Route path="/" element={<LandingPage />} />

      {/*Protected Routes*/}
      <Route path="/admin-dashboard" element={<PrivateRoute />}>
        <Route path="dashboard" index element={<DashboardPage />} />
        <Route path="user" element={<UserPage />} />
        <Route path="office" element={<OfficePage />} />
        <Route path="editOffice" element={<EditOffice />} />
        <Route path="addOffice" element={<AddOffice />} />
        <Route path="transaction" element={<TransactionPage />} />
        <Route path="review" element={<ReviewPage />} />
        <Route path="promo" element={<PromoPage />} />
        <Route path="admin" element={<AdminPage />} />
      </Route>

      {/*Private Routes*/}
      <Route path="login" element={<ProtectedRoute />}>
        <Route index element={<LoginPage />} />
      </Route>

      {/*Notfound Routes*/}
      <Route path="*" element={<NotFoundPage />} />
      <Route />
    </Routes>
  );
};

export default SetupRouters;
