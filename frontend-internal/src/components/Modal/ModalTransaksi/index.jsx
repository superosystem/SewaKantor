import React, { useState } from "react";
import CreateIcon from "@mui/icons-material/Create";
import { useDispatch } from "react-redux";
import { updateTransaction } from "store/Feature/FeatureTransaction/transactionSlice";
import Swal from "sweetalert2";
import { toast } from "react-hot-toast";
import CloseIcon from "@mui/icons-material/Close";
import { checkbox } from "assets";
import jsConvert from "js-convert-case";

const InputField = ({
  name,
  defaultValue,
  label,
  placeholder,
  onChange,
  className,
  type = "text",
  disabled,
  autoComplete = "off",
  classNameHeader,
}) => (
  <div className={`${classNameHeader} relative`}>
    <input
      type={type}
      id="floating_outlined"
      className={`${className} block px-2.5 pb-2.5 pt-4 w-full text-sm text-gray-900 bg-transparent rounded-lg border-2 border-gray-300 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer`}
      placeholder={placeholder}
      name={name}
      onChange={onChange}
      disabled={disabled}
      autoComplete={autoComplete}
      defaultValue={defaultValue}
    />
    <label
      htmlFor="floating_outlined"
      className="absolute text-sm text-gray-500 duration-300 transform -translate-y-4 scale-75 top-2 z-10 origin-[0] bg-white  px-2 peer-focus:px-2 peer-focus:text-blue-600 peer-focus:dark:text-blue-500 peer-placeholder-shown:scale-100 peer-placeholder-shown:-translate-y-1/2 peer-placeholder-shown:top-1/2 peer-focus:top-2 peer-focus:scale-75 peer-focus:-translate-y-4 left-1"
    >
      {label}
    </label>
  </div>
);

const ModalUpdateTransaksi = ({ dataTransaksi, setReload }) => {
  const dispatch = useDispatch();
  const [modal, setModal] = useState(false);
  const [data, setData] = useState({
    id: dataTransaksi.id,
    status: dataTransaksi.status,
  });

  const handleChangeStatus = (ev) => {
    setData({
      ...data,
      [ev.target.name]: ev.target.value,
    });
  };

  const HANDLEMODAL = () => {
    setModal(!modal);
  };

  const handleUpdateStatus = (e) => {
    e.preventDefault();
    try {
      dispatch(updateTransaction(data));
      setReload();
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
        text: "Edit Transaction Fail",
      });
    }
  };

  return (
    <>
      <button
        onClick={HANDLEMODAL}
        type="button"
        data-modal-toggle="editUserModal"
        className="px-2 py-2 font-medium bg-slate-100 hover:underline rounded-lg hover:bg-blue-600"
      >
        <CreateIcon className="text-slate-500 hover:text-white" />
      </button>

      {/* Edit user modal */}
      {modal && (
        <div
          id="editUserModal"
          tabIndex={-1}
          aria-hidden="true"
          className="flex flex-row bg-black bg-opacity-30 overflow-y-scroll fixed left-0 top-0 z-20 justify-center items-center p-4 pt-32 w-full md:inset-0"
        >
          <div className="relative w-full max-w-lg h-full md:h-auto">
            {/* Modal content */}
            <div className="relative bg-white pb-6 rounded-lg shadow ">
              {/* Modal header */}
              <div className="p-2 rounded-t border-b">
                <button
                  onClick={HANDLEMODAL}
                  type="button"
                  className="text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm p-1.5 ml-auto inline-flex items-center "
                  data-modal-toggle="editUserModal"
                >
                  <svg
                    className="w-5 h-5"
                    fill="currentColor"
                    viewBox="0 0 20 20"
                    xmlns="http://www.w3.org/2000/svg"
                  >
                    <path
                      fillRule="evenodd"
                      d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z"
                      clipRule="evenodd"
                    />
                  </svg>
                </button>
              </div>
              {/* Modal body */}
              <form
                onSubmit={handleUpdateStatus}
                className="py-2 px-6 space-y-6"
              >
                <div className="px-6 lg:px-8 space-y-4">
                  <h3 className="mb-4 text-xl font-medium text-neutral-700 ">
                    Edit Transaction
                  </h3>
                  <div className="space-y-6">
                    <select
                      id="status_booking"
                      name="status"
                      onChange={(ev) => handleChangeStatus(ev)}
                      className="border-2 py-4 border-blue-500 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
                    >
                      <option
                        selected={
                          dataTransaksi.status === "accepted" ? true : false
                        }
                        value="accepted"
                      >
                        Accepted
                      </option>
                      <option
                        selected={
                          dataTransaksi.status === "rejected" ? true : false
                        }
                        value="rejected"
                      >
                        Rejected
                      </option>
                      <option
                        selected={
                          dataTransaksi.status === "pending" ? true : false
                        }
                        value="pending"
                      >
                        Pending
                      </option>
                      <option
                        selected={
                          dataTransaksi.status === "on process" ? true : false
                        }
                        value="on process"
                      >
                        On Process
                      </option>
                    </select>
                  </div>

                  <InputField
                    name="full_name"
                    label="Full Name"
                    placeholder="Full Name"
                    disabled={true}
                    className="text-gray-400"
                    defaultValue={dataTransaksi.user.full_name}
                  />

                  <InputField
                    name="type"
                    label="Type"
                    placeholder="Type"
                    disabled={true}
                    className="text-gray-400"
                    defaultValue={jsConvert.toHeaderCase(
                      dataTransaksi.office.office_type
                    )}
                  />

                  <InputField
                    name="date"
                    label="Date"
                    placeholder="Date"
                    disabled={true}
                    className="text-gray-400"
                    defaultValue={dataTransaksi.check_in.date}
                  />

                  <InputField
                    name="status"
                    label="Status"
                    placeholder="Status"
                    disabled={true}
                    className="text-gray-400"
                    defaultValue={jsConvert.toHeaderCase(dataTransaksi.status)}
                  />

                  {/* Modal footer */}
                  <div className="flex gap-5 ">
                    <button
                      type="button"
                      className="w-1/2 py-2.5 px-5 mr-2 mb-2 text-sm font-medium text-gray-400 focus:outline-none bg-white rounded-lg border border-gray-200 hover:bg-gray-100 hover:text-gray-500 focus:z-10 focus:ring-4 focus:ring-gray-200"
                    >
                      Reset
                    </button>
                    <button
                      type="submit"
                      className="w-1/2 text-white mb-2 bg-success hover:bg-green-400 focus:ring-4 focus:outline-none focus:ring-green-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center"
                    >
                      Save
                    </button>
                  </div>
                </div>
              </form>
            </div>
          </div>
        </div>
      )}
    </>
  );
};

export default ModalUpdateTransaksi;
