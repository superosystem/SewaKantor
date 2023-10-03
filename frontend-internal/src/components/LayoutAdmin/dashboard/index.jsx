import React, { useEffect, useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import { fetchOffice } from "store/Feature/FeatureOffice/officeSlice";
import { fetchTransaction } from "store/Feature/FeatureTransaction/transactionSlice";
import BookingStatus from "./bookingStatus";
import TransactionChart from "./chart";
import ItemsData from "./itemsData";
import TopValueTransaction from "./topValueTransaction";

const DashboardPage = () => {
  const dispatch = useDispatch();

  const listOfOffice = useSelector((state) => state.office.data);
  const [officeList, setOfficeList] = useState(listOfOffice);
  const [coworkingSpace, seCoworkingSpace] = useState(officeList);
  const [meetingSpace, setMeetingSpace] = useState(officeList);
  const [officeSpace, setOfficeSpace] = useState(officeList);
  const [loading, setLoading] = useState(true);

  const setReload = () => {
    setLoading(true);
    setTimeout(() => {
      dispatch(fetchTransaction());
      setLoading(false);
    }, 3000);
  };

  useEffect(() => {
    dispatch(fetchTransaction()).catch((err) => {
      console.log(err);
    });
    dispatch(fetchOffice())
      .then((res) => {
        setOfficeList(res.payload);
      })
      .catch((err) => {
        console.log(err);
      });

    const updatedCoworkList = [];
    const updateMeetingList = [];
    const updatedOfficeList = [];
    officeList.forEach((office) => {
      const loweredOfficeType = office.office_type.toLowerCase();
      if (loweredOfficeType.includes("coworking space")) {
        updatedCoworkList.push(office);
      } else if (loweredOfficeType.includes("meeting room")) {
        updateMeetingList.push(office);
      } else if (loweredOfficeType.includes("office")) {
        updatedOfficeList.push(office);
      }
    });
    seCoworkingSpace(updatedCoworkList);
    setMeetingSpace(updateMeetingList);
    setOfficeSpace(updatedOfficeList);
  }, [dispatch]);

  return (
    <>
      <ItemsData />
      <TransactionChart
        coworkingSpace={coworkingSpace}
        meetingSpace={meetingSpace}
        officeSpace={officeSpace}
      />
      <BookingStatus />
      <TopValueTransaction />
    </>
  );
};

export default DashboardPage;
