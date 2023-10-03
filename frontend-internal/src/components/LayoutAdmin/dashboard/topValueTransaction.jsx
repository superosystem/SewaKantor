import { items } from "assets";
import { ContentTableLoader } from "components";
import jsConvert from "js-convert-case";
import React, { useEffect, useState } from "react";
import CurrencyFormat from "react-currency-format";
import { Helmet } from "react-helmet";
import { useDispatch, useSelector } from "react-redux";
import { fetchTransaction } from "store/Feature/FeatureTransaction/transactionSlice";

const TopValueTransaction = () => {
  const dispatch = useDispatch();
  const listOfTransaction = useSelector((state) => state.transactions.data);
  const [topValueList, setValueList] = useState(listOfTransaction);
  const [loading, setLoading] = useState(true);
  const [average, setAverage] = useState(1);

  useEffect(() => {
    dispatch(fetchTransaction())
    let totalPrice = 0;
    listOfTransaction.forEach((transaksi) => {
      totalPrice += transaksi.price;
    });
    const priceAverage = totalPrice / listOfTransaction.length;
    setAverage(priceAverage);

    const updateTopValueTransaksi = [];
    listOfTransaction.forEach((transaksi) => {
      if (transaksi.price > average) {
        updateTopValueTransaksi.push(transaksi);
      }
    });
    setValueList(updateTopValueTransaksi);
    setLoading(false);
  }, [average]);

  return (
    <>
      <Helmet>
        <title>Dashboard</title>
        <meta name="description" content="Helmet application" />
      </Helmet>
      <section className="mt-10 w-full flex flex-col bg-white rounded-3xl drop-shadow-4xl">
        <div className="p-6 space-y-6">
          <div>
            <h1 className="font-bold text-2xl text-left">
              Top Value Transaction
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
                        Photo
                      </th>
                      <th scope="col" className="py-3 px-6">
                        Name
                      </th>
                      <th scope="col" className="py-3 px-6">
                        Price
                      </th>
                      <th scope="col" className="py-3 px-6">
                        Office Name
                      </th>
                      <th scope="col" className="py-3 px-6">
                        Type
                      </th>
                      <th scope="col" className="py-3 px-6 rounded-r-2xl">
                        Date
                      </th>
                    </tr>
                  </thead>
                  <tbody>
                    {topValueList?.slice(0, 5).map((transaksi) => (
                      <tr
                        className="bg-white font-medium text-neutral-500"
                        key={transaksi.id}
                      >
                        <td className="py-4 px-6 font-medium  whitespace-nowrap ">
                          <img
                            src={items}
                            className="rounded-full max-w-[40px]"
                            alt="img"
                          />
                        </td>
                        <td className="py-4 px-6">
                          {jsConvert.toHeaderCase(transaksi.user.full_name)}
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
                          {jsConvert.toHeaderCase(transaksi.office.office_name)}
                        </td>
                        <td className="py-4 px-6">
                          {jsConvert.toHeaderCase(transaksi.office.office_type)}
                        </td>
                        <td className="py-4 px-6">{transaksi.check_in.date}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              )}
            </div>
          </div>
        </div>
      </section>
    </>
  );
};

export default TopValueTransaction;
