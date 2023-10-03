import { combineReducers } from "@reduxjs/toolkit";

import users from "./FeatureUser/userSlice";
import transactions from "./FeatureTransaction/transactionSlice";
import promo from "./FeaturePromo/promoSlice";
import office from "./FeatureOffice/officeSlice";
import loader from "./FeatureLoader/loaderSlice";
import reviews from "./FeatureReview/reviewSlice";
import facility from "./FeaturesFacility/facilitySlice";

const rootReducers = combineReducers({
    users,
    transactions,
    promo,
    office,
    loader,
    reviews,
    facility,
});

export default rootReducers;