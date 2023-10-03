import { CloseOutlined } from "@ant-design/icons";
import React, { useEffect, useState } from "react";
import CreateIcon from "@mui/icons-material/Create";
import { useDispatch } from "react-redux";
import Swal from "sweetalert2";
import toast from "react-hot-toast";
import CloseIcon from "@mui/icons-material/Close";
import { checkbox } from "assets";
import { updatePromo } from "store/Feature/FeaturePromo/promoSlice";

const EditPromo = ({ dataPromo, setReload }) => {
  const [modal, setModal] = useState(false);
  const [reset, setReset] = useState(true);
  const [data, setData] = useState({
    id: dataPromo.id,
    voucher_code: dataPromo.voucher_code,
    periode: dataPromo.periode,
    nominal: dataPromo.nominal,
  });

  const { id, voucher_code, periode, nominal } = data;
  const dispatch = useDispatch();

  useEffect(() => {
    setReset(true);
  }, []);

  const HandleModal = () => {
    setModal(!modal);
    setReset(true);
  };

  const handleReset = () => {
    setReset(!reset);
  };

  const handleChangeEditPromo = (ev) => {
    setData({
      ...data,
      [ev.target.name]: ev.target.value,
    });
  };

  const handleSubmit = (ev) => {
    ev.preventDefault();
    try {
      dispatch(updatePromo({ id, voucher_code, periode, nominal }));
      setReload();
      Swal.fire({
        icon: "success",
        title: "Success",
        text: "Edit Promo Success",
        showConfirmButton: false,
        timer: 1000,
      });
      toast.custom((t) => (
        <div
          className={`${
            t.visible
              ? "animate-enter ease-in-out duration-200"
              : "animate-leave ease-in-out duration-200"
          } max-w-md w-80 bg-white shadow-lg rounded-lg pointer-events-auto flex ring-1 ring-black ring-opacity-5`}
        >
          <div className="flex-1 w-0 p-4">
            <div className="flex items-start">
              <div className="flex-shrink-0 pt-0.5">
                <img className="h-10 w-10 rounded-full" src={checkbox} alt="" />
              </div>
              <div className="ml-3 flex-col text-start">
                <p className="text-sm font-bold text-success">Success</p>
                <p className="mt-1 text-sm text-gray-500">
                  Successfully Updated
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
    } catch (error) {
      Swal.fire({
        icon: "error",
        title: "Failed",
        text: "Edit Users Fail",
      });
    }
  };

  return (
    <>
      <button
        onClick={HandleModal}
        type="button"
        data-modal-toggle="editUserModal"
        className="px-2 py-2 font-medium bg-slate-100 hover:underline rounded-lg hover:bg-blue-600"
      >
        <CreateIcon className="text-slate-500 hover:text-white" />
      </button>
      {/* Edit Promo Modal */}
      {modal && (
        <div className="flex flex-row bg-black bg-opacity-30 overflow-y-auto overflow-x-hidden fixed left-0 top-0 z-50 justify-center items-center p-4 w-full md:inset-0 h-modal md:h-full">
          <div className="bg-white rounded-2xl px-20 py-12 w-1/4 absolute z-50 transform -translate-y-0 scale-125 transition-transform duration-300 center">
            <div className="absolute">
              <button onClick={HandleModal}>
                <CloseOutlined className="relative text-xl -top-6 right-12" />
              </button>
            </div>
            <div className="text-start pb-6">
              <h1 className="text-2xl font-bold text-gray-600">Edit Promo</h1>
            </div>
            <form onSubmit={handleSubmit}>
              <div className="pb-6">
                <div className="relative">
                  <input
                    type="text"
                    id="floating_outlined"
                    className="block px-2.5 pb-2.5 pt-4 w-full text-sm text-gray-900 bg-transparent rounded-lg border-1 border-gray-300 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                    placeholder=" "
                    name="voucher_code"
                    onChange={(ev) => handleChangeEditPromo(ev)}
                    defaultValue={reset ? dataPromo.voucher_code : ""}
                  />
                  <label
                    htmlFor="floating_outlined"
                    className="absolute text-sm text-gray-500 duration-300 transform -translate-y-4 scale-75 top-2 z-10 origin-[0] bg-white  px-2 peer-focus:px-2 peer-focus:text-blue-600 peer-focus:dark:text-blue-500 peer-placeholder-shown:scale-100 peer-placeholder-shown:-translate-y-1/2 peer-placeholder-shown:top-1/2 peer-focus:top-2 peer-focus:scale-75 peer-focus:-translate-y-4 left-1"
                  >
                    Voucher Code
                  </label>
                </div>
              </div>
              <div className="pb-6">
                <div className="relative">
                  <input
                    type="date"
                    id="floating_outlined"
                    className="block px-2.5 pb-2.5 pt-4 w-full text-sm text-gray-900 bg-transparent rounded-lg border-1 border-gray-300 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                    placeholder=" "
                    name="periode"
                    onChange={(ev) => handleChangeEditPromo(ev)}
                    defaultValue={reset ? dataPromo.periode : ""}
                  />
                  <label
                    htmlFor="floating_outlined"
                    className="absolute text-sm text-gray-500 duration-300 transform -translate-y-4 scale-75 top-2 z-10 origin-[0] bg-white  px-2 peer-focus:px-2 peer-focus:text-blue-600 peer-focus:dark:text-blue-500 peer-placeholder-shown:scale-100 peer-placeholder-shown:-translate-y-1/2 peer-placeholder-shown:top-1/2 peer-focus:top-2 peer-focus:scale-75 peer-focus:-translate-y-4 left-1"
                  >
                    Periode
                  </label>
                </div>
              </div>
              <div className="pb-6">
                <div className="relative">
                  <input
                    type="text"
                    id="floating_outlined"
                    className="block px-2.5 pb-2.5 pt-4 w-full text-sm text-gray-900 bg-transparent rounded-lg border-1 border-gray-300 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                    placeholder=" "
                    name="nominal"
                    onChange={(ev) => handleChangeEditPromo(ev)}
                    defaultValue={reset ? dataPromo.nominal : ""}
                  />
                  <div className="absolute">
                    <p className="relative -top-8 -right-[230px]">%</p>
                  </div>
                  <label
                    htmlFor="floating_outlined"
                    className="absolute text-sm text-gray-500 duration-300 transform -translate-y-4 scale-75 top-2 z-10 origin-[0] bg-white  px-2 peer-focus:px-2 peer-focus:text-blue-600 peer-focus:dark:text-blue-500 peer-placeholder-shown:scale-100 peer-placeholder-shown:-translate-y-1/2 peer-placeholder-shown:top-1/2 peer-focus:top-2 peer-focus:scale-75 peer-focus:-translate-y-4 left-1"
                  >
                    Nominal
                  </label>
                </div>
              </div>
              <div className="w-full flex justify-between">
                <button
                  type="reset"
                  onClick={handleReset}
                  className="w-1/2 border-2 border-success rounded-lg text-success mr-2 hover:bg-success hover:text-white"
                >
                  {reset ? "Reset" : "Cancel"}
                </button>
                <button
                  type="submit"
                  className="w-1/2 bg-success ml-2 text-white py-3 rounded-lg hover:bg-opacity-70"
                >
                  Save
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </>
  );
};

export default EditPromo;
