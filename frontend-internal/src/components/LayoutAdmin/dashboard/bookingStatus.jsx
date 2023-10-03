import { Pagination } from "antd";
import { ContentTableLoader } from "components";
import jsConvert from "js-convert-case";
import React, { useEffect, useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import {
  fetchTransaction,
  updateTransaction,
} from "store/Feature/FeatureTransaction/transactionSlice";
import CurrencyFormat from "react-currency-format";
import Swal from "sweetalert2";

const BookingStatus = () => {
  const dispatch = useDispatch();
  const listOfTransaction = useSelector((state) => state.transactions.data);
  const [transaksiList, setTransaksiList] = useState(listOfTransaction);
  const [loading, setLoading] = useState(true);
  const pageSize = 6;

  const [dataTransaksi, setDataTransaksi] = useState({
    minValue: 0,
    maxValue: 20,
  });

  const handleChange = (value) => {
    setDataTransaksi({
      minValue: (value - 1) * pageSize,
      maxValue: value * pageSize,
    });
  };

  const setReload = () => {
    setLoading(true);
    dispatch(fetchTransaction())
      .then((res) => {
        const updateListOnProcess = [];
        res.payload.forEach((transaksi) => {
          const loweredStatus = transaksi.status.toLowerCase();
          if (loweredStatus.includes("on process")) {
            updateListOnProcess.push(transaksi);
          }
        });
        setTransaksiList(updateListOnProcess);
      });
    setTimeout(() => {
      setLoading(false);
    }, 500);
  };

  useEffect(() => {
    dispatch(fetchTransaction())
      .then((res) => {
        const updateListOnProcess = [];
        res.payload.forEach((transaksi) => {
          const loweredStatus = transaksi.status.toLowerCase();
          if (loweredStatus.includes("on process")) {
            updateListOnProcess.push(transaksi);
          }
        });
        setTransaksiList(updateListOnProcess);
      });
    setTimeout(() => {
      setLoading(false);
    }, 500);
    setDataTransaksi({
      minValue: 0,
      maxValue: 6,
    });
  }, [dispatch]);

  const handleChangeReject = (ev, id) => {
    ev.preventDefault();
    const swalWithBootstrapButtons = Swal.mixin({
      customClass: {
        confirmButton:
          "focus:outline-none text-white bg-fifth hover:bg-red-600 font-medium rounded-lg text-sm px-5 py-2.5 mr-2 mb-2",
        cancelButton:
          "py-2.5 px-5 mr-2 mb-2 text-sm font-medium text-gray-900 focus:outline-none bg-white rounded-lg border border-gray-200 hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-4 focus:ring-gray-200",
      },
      buttonsStyling: false,
    });

    swalWithBootstrapButtons
      .fire({
        title: `Are you sure?`,
        text: "The selected record will be rejected. Are you want to continue",
        showCancelButton: true,
        confirmButtonText: "Yes, Rejected",
        cancelButtonText: "No, cancel",
        reverseButtons: true,
      })
      .then((result) => {
        if (result.isConfirmed) {
          try {
            dispatch(updateTransaction({ id, status: "rejected" }));
            setReload();
            Swal.fire({
              icon: "error",
              title: "Booking Rejected !",
              text: "This user's order status has been updated, you can see in the transaction details list.",
              showConfirmButton: false,
              timer: 1800,
            });
          } catch (error) {
            Swal.fire({
              icon: "error",
              title: "Failed",
              text: "Edit Transaction Fail",
            });
          }
        }
      });
  };

  const handleChangeAccept = (ev, id) => {
    ev.preventDefault();
    const swalWithBootstrapButtons = Swal.mixin({
      customClass: {
        confirmButton:
          "focus:outline-none text-white bg-success bg-opacity-90 hover:bg-success font-medium rounded-lg text-sm px-5 py-2.5 mr-2 mb-2",
        cancelButton:
          "py-2.5 px-5 mr-2 mb-2 text-sm font-medium text-gray-900 focus:outline-none bg-white rounded-lg border border-gray-200 hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-4 focus:ring-gray-200",
      },
      buttonsStyling: false,
    });

    swalWithBootstrapButtons
      .fire({
        title: `Are you sure?`,
        text: "The selected record will be accepted. Are you want to continue",
        showCancelButton: true,
        confirmButtonText: "Yes, Accepted",
        cancelButtonText: "No, cancel",
        reverseButtons: true,
      })
      .then((result) => {
        if (result.isConfirmed) {
          try {
            dispatch(updateTransaction({ id, status: "accepted" }));
            setReload();
            Swal.fire({
              icon: "success",
              title: "Booking Accepted !",
              text: "This user's order status has been updated, you can see in the transaction details list.",
              showConfirmButton: false,
              timer: 1800,
            });
          } catch (error) {
            Swal.fire({
              icon: "error",
              title: "Failed",
              text: "Edit Transaction Fail",
            });
          }
        }
      });
  };

  return (
    <>
      <section className="mt-10 flex flex-col bg-white rounded-3xl drop-shadow-4xl">
        <div className="p-6 space-y-6">
          <div>
            <h1 className="font-bold text-2xl text-left">
              Recent Status Booking
            </h1>
          </div>
          <div>
            <div className="overflow-x-auto relative">
              {loading ? (
                <ContentTableLoader />
              ) : (
                <table className="w-full text-sm text-left text-gray-500 space-y-6 ">
                  <thead className="text-xs text-gray-700 uppercase bg-gray-100 ">
                    <tr>
                      <th scope="col" className="py-3 px-6 rounded-l-2xl">
                        Date
                      </th>
                      <th scope="col" className="py-3 px-6">
                        Name
                      </th>
                      <th scope="col" className="py-3 px-6">
                        Type
                      </th>
                      <th scope="col" className="py-3 px-6">
                        Office Name
                      </th>
                      <th scope="col" className="py-3 px-6">
                        Price(Rp)
                      </th>
                      <th scope="col" className="py-3 px-6 rounded-r-2xl">
                        Action
                      </th>
                    </tr>
                  </thead>
                  <tbody>
                    {transaksiList
                      ?.slice(dataTransaksi.minValue, dataTransaksi.maxValue)
                      .map((transaksi) => (
                        <tr
                          className="bg-white font-medium text-neutral-500"
                          key={transaksi.id}
                        >
                          <td className="py-4 px-6 font-medium  whitespace-nowrap  ">
                            {transaksi.check_in.date}
                          </td>
                          <td className="py-4 px-6">
                            {transaksi.user.full_name}
                          </td>
                          <td className="py-4 px-6">
                            {jsConvert.toHeaderCase(
                              transaksi.office.office_type
                            )}
                          </td>
                          <td className="py-4 px-6">
                            {jsConvert.toHeaderCase(
                              transaksi.office.office_name
                            )}
                          </td>
                          <td className="py-4 px-6">
                            <CurrencyFormat
                              value={transaksi.price}
                              displayType={"text"}
                              thousandSeparator={true}
                              prefix={"Rp."}
                              renderText={(value) => <div>{value}</div>}
                            />
                          </td>
                          <td className="py-4 px-6">
                            <div className="flex items-center gap-2">
                              <button
                                onClick={(ev) =>
                                  handleChangeReject(ev, transaksi.id)
                                }
                                className="py-2 px-4 text-sixth bg-[#FBE0DB] rounded-lg"
                                value="rejected"
                              >
                                Reject
                              </button>
                              <button
                                onClick={(ev) =>
                                  handleChangeAccept(ev, transaksi.id)
                                }
                                className="py-2 px-4 text-[#45AF49] bg-[#DAEFDB] rounded-lg"
                                value="accepted"
                              >
                                Accept
                              </button>
                            </div>
                          </td>
                        </tr>
                      ))}
                  </tbody>
                </table>
              )}
            </div>
            <div className="mt-8 text-start">
              <Pagination
                defaultCurrent={1}
                defaultPageSize={pageSize}
                total={transaksiList?.length}
                onChange={handleChange}
              />
            </div>
          </div>
        </div>
      </section>
    </>
  );
};

export default BookingStatus;
