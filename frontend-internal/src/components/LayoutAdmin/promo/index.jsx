import AddPromo from "components/Modal/ModalPromo/AddPromo";
import EditPromo from "components/Modal/ModalPromo/EditPromo";
import React, { useEffect, useMemo, useState } from "react";
import { Arrow, checkbox } from "assets";
import DeleteAllData from "components/Alert/deleteAllData";
import DeleteForeverIcon from "@mui/icons-material/DeleteForever";
import { useDispatch, useSelector } from "react-redux";
import {
  fetchPromo,
  createPromo,
  deletePromo,
} from "store/Feature/FeaturePromo/promoSlice";
import { ContentTableLoader } from "components";
import { Pagination, Select } from "antd";
import { Helmet } from "react-helmet";
import TableHead from "./tableHead";
import CloseIcon from "@mui/icons-material/Close";
import { toast, Toaster } from "react-hot-toast";
import Swal from "sweetalert2";

const useSortableData = (items, config = null) => {
  const [sortConfig, setSortConfig] = useState(config);

  const sortedItems = useMemo(() => {
    let sortableItems = [...items];
    if (sortConfig !== null) {
      sortableItems.sort((a, b) => {
        if (a[sortConfig.key] < b[sortConfig.key]) {
          return sortConfig.direction === "ascending" ? -1 : 1;
        }
        if (a[sortConfig.key] > b[sortConfig.key]) {
          return sortConfig.direction === "ascending" ? 1 : -1;
        }
        return 0;
      });
    }
    return sortableItems;
  }, [items, sortConfig]);

  const requestSort = (key) => {
    let direction = "ascending";
    if (
      sortConfig &&
      sortConfig.key === key &&
      sortConfig.direction === "ascending"
    ) {
      direction = "descending";
    }
    setSortConfig({ key, direction });
  };

  return { items: sortedItems, requestSort };
};

const PromoPage = () => {
  const dispatch = useDispatch();
  const listOfPromo = useSelector((state) => state.promo.data);
  const pageSize = 6;
  const [promoList, setPromoList] = useState(listOfPromo);
  const { items, requestSort, sortConfig } = useSortableData(promoList);
  const [isCheckAll, setIsCheckAll] = useState(false);
  const [isCheck, setIsCheck] = useState([]);
  const [dataPromo, setDataPromo] = useState({
    minValue: 0,
    maxValue: 20,
  });
  const [searchWords, setSearchWords] = useState("");
  const [loading, setLoading] = useState(true);

  const getClassNamesFor = (name) => {
    if (!sortConfig) {
      return;
    }
    return sortConfig.key === name ? sortConfig.direction : undefined;
  };

  const handleChange = (value) => {
    setDataPromo({
      minValue: (value - 1) * pageSize,
      maxValue: value * pageSize,
    });
  };

  const setReload = () => {
    setLoading(true);
    setTimeout(() => {
      dispatch(fetchPromo()).then((res) => {
        setPromoList(res.payload);
      });
      setLoading(false);
    }, 3000);
  };

  const handleSelectAll = () => {
    setIsCheckAll(!isCheckAll);
    setIsCheck(promoList.map((promo) => promo.id));
    if (isCheckAll) {
      setIsCheck([]);
    }
  };

  const handleClickCheck = (ev) => {
    const { id, checked } = ev.target;
    setIsCheck([...isCheck, id]);
    if (!checked) {
      setIsCheck(isCheck.filter((item) => item !== id));
    }
  };

  const handleSearch = (ev) => {
    setSearchWords(ev.target.value);
  };

  useEffect(() => {
    dispatch(fetchPromo())
      .then((res) => {
        if (searchWords === "") {
          setPromoList(res.payload);
        }
        setLoading(false);
      })
      .catch((err) => {
        console.log(err);
      });

    setTimeout(() => {
      setLoading(false);
    }, 500);
    setDataPromo({
      minValue: 0,
      maxValue: 6,
    });

    const loweredSearchedWords = searchWords.toLowerCase();
    const updatedPromoList = [];
    if (searchWords !== "") {
      listOfPromo.forEach((promo) => {
        const loweredPromoVCode = promo.voucher_code.toLowerCase();
        if (loweredPromoVCode.includes(loweredSearchedWords)) {
          updatedPromoList.push(promo);
        }
      });
      setPromoList(updatedPromoList);
      setLoading(false);
    } else {
      setPromoList(listOfPromo);
    }
  }, [dispatch, searchWords]);

  const handleDeleteAll = () => {
    DeleteAllData();
  };

  const handleDelete = (id) => {
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
        title: "Are you sure?",
        text: "The selected record will be permanently deleted. Are you want to continue",
        showCancelButton: true,
        confirmButtonText: "Yes, Delete",
        cancelButtonText: "No, cancel",
        reverseButtons: true,
      })
      .then((result) => {
        if (result.isConfirmed) {
          try {
            dispatch(deletePromo(id));
            setReload();
            Swal.fire({
              icon: "success",
              title: `Deleted!`,
              text: "Your data has been deleted.",
              showConfirmButton: false,
              timer: 1200,
            });
            toast.custom((t) => (
              <div
                className={`${t.visible
                  ? "animate-enter ease-in-out duration-200"
                  : "animate-leave ease-in-out duration-200"
                  } max-w-md w-80 bg-white shadow-lg rounded-lg pointer-events-auto flex ring-1 ring-black ring-opacity-5`}
              >
                <div className="flex-1 w-0 p-4">
                  <div className="flex items-start">
                    <div className="flex-shrink-0 pt-0.5">
                      <img
                        className="h-10 w-10 rounded-full"
                        src={checkbox}
                        alt=""
                      />
                    </div>
                    <div className="ml-3 flex-col text-start">
                      <p className="text-sm font-bold text-success">Success</p>
                      <p className="mt-1 text-sm text-gray-500">
                        Successfully Deleted
                      </p>
                    </div>
                  </div>
                </div>
                <div className="flex border-gray-200">
                  <button
                    onClick={() => toast.dismiss(t.id)}
                    className="w-full border border-transparent rounded-none rounded-r-lg p-4 flex items-center justify-center text-sm font-medium text-slate-400 hover:text-slate-600 focus:outline-none"
                  >
                    <CloseIcon />
                  </button>
                </div>
              </div>
            ));
            return result;
          } catch (error) {
            return Swal.fire({
              icon: "error",
              title: "Oops...",
              text: "Delete is Failed ",
            });
          }
        }
      });
  };

  return (
    <>
      <Helmet>
        <title>Dashboard | Promo</title>
        <meta name="description" content="Helmet application" />
      </Helmet>
      <div className="flex flex-col w-full">
        <div className="flex justify-between px-8 py-2 w-full bg-white rounded-2xl shadow">
          <h1 className="text-2xl font-bold my-auto">Voucher Promo</h1>
          <div className="flex content-center pl-12 rounded-xl text-lg py-2">
            <AddPromo loading={loading} setReload={setReload} />
          </div>
        </div>
        <div className="mt-4 z-10">
          <div className="overflow-x-auto relative shadow-md sm:rounded-2xl">
            <div className="flex justify-between items-center py-4 bg-white px-4">
              <div className="flex">
                <h1 className="inline pr-4 text-base my-auto text-neutral-500">
                  ({promoList?.length}) Record Found
                </h1>
                <button
                  type="button"
                  onClick={() => { }}
                  className="text-white bg-fifth hover:bg-red-400 font-medium rounded-full text-sm px-5 py-2.5 flex text-center mr-2 mb-2"
                >
                  <DeleteForeverIcon className="text-white" />
                  <p className="my-auto">Delete Selected</p>
                </button>
              </div>
              <label htmlFor="table-search" className="sr-only">
                Search
              </label>
              <div className="relative">
                <div className="flex absolute inset-y-0 left-0 items-center pl-3 pointer-events-none">
                  <svg
                    className="w-5 h-5 text-gray-500 "
                    aria-hidden="true"
                    fill="currentColor"
                    viewBox="0 0 20 20"
                    xmlns="http://www.w3.org/2000/svg"
                  >
                    <path
                      fillRule="evenodd"
                      d="M8 4a4 4 0 100 8 4 4 0 000-8zM2 8a6 6 0 1110.89 3.476l4.817 4.817a1 1 0 01-1.414 1.414l-4.816-4.816A6 6 0 012 8z"
                      clipRule="evenodd"
                    />
                  </svg>
                </div>
                <input
                  type="text"
                  id="table-search-promo"
                  onChange={(ev) => handleSearch(ev)}
                  className="block p-4 pl-10 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-blue-500 focus:border-blue-500"
                  placeholder="Search for promo"
                />
              </div>
            </div>
            {loading ? (
              <ContentTableLoader />
            ) : (
              <table className="w-full text-sm text-left text-gray-500 ">
                <TableHead
                  handleSelectAll={handleSelectAll}
                  isChecked={isCheckAll}
                  requestSort={requestSort}
                  getClassNamesFor={getClassNamesFor}
                />
                <tbody>
                  {items
                    ?.slice(dataPromo.minValue, dataPromo.maxValue)
                    .map((promo) => (
                      <tr
                        className="bg-white border-b hover:bg-gray-50"
                        key={promo.id}
                      >
                        <td className="p-4 w-4">
                          <div className="flex items-center">
                            <input
                              id="checkbox-table-search-1"
                              type="checkbox"
                              dataid={promo.id}
                              checked={isCheckAll ? true : promo.checked}
                              onChange={handleClickCheck}
                              className="w-4 h-4 text-blue-600 bg-gray-100 rounded border-gray-300 focus:ring-blue-500"
                            />
                            <label
                              htmlFor="checkbox-table-search-1"
                              className="sr-only"
                            >
                              checkbox
                            </label>
                          </div>
                        </td>
                        <td className="py-4 px-6 text-center">{promo.id}</td>
                        <td className="py-4 px-6 text-center">
                          {promo.voucher_code}
                        </td>
                        <td className="py-4 px-6 text-center">
                          {promo.periode}
                        </td>
                        <td className="py-4 px-6 text-center">
                          {promo.nominal} %
                        </td>
                        <td className="py-4 px-6 flex gap-2 items-center justify-center">
                          <button
                            href="#"
                            onClick={() => handleDelete(promo.id)}
                            type="button"
                            data-modal-toggle="editUserModal"
                            className=" px-2 py-2 font-medium bg-slate-100 hover:underline rounded-lg hover:bg-red-700 text-white"
                          >
                            <DeleteForeverIcon className="text-slate-500 hover:text-white" />
                          </button>
                          <EditPromo
                            dataPromo={promo}
                            loading={loading}
                            setReload={setReload}
                          />
                        </td>
                      </tr>
                    ))}
                </tbody>
              </table>
            )}
          </div>
          <div className="text-start mt-8">
            <Pagination
              defaultCurrent={1}
              defaultPageSize={pageSize}
              total={promoList?.length}
              onChange={handleChange}
            />
          </div>
        </div>
      </div>
      <Toaster position="bottom-left" reverseOrder={false} />
    </>
  );
};

export default PromoPage;
