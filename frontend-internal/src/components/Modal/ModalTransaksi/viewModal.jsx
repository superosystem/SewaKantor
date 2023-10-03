import React, { useState } from "react";
import RemoveRedEyeIcon from "@mui/icons-material/RemoveRedEye";
import { CloseOutlined } from "@ant-design/icons";
import jsConvert from "js-convert-case";
import CurrencyFormat from "react-currency-format";

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
      className={`${className} block px-2.5 pb-2.5 pt-4 w-full text-sm text-gray-900 bg-transparent rounded-lg border-2 border-gray-400 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer`}
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

const ModalViewTransaction = ({ dataTransaksi }) => {
  const [modal, setModal] = useState(false);
  const [ppn, setPPN] = useState("");
  const [service, setService] = useState("");
  const [price, setPrice] = useState("");
  const HANDLEMODAL = () => {
    setModal(!modal);
  };

  return (
    <>
      <button
        onClick={HANDLEMODAL}
        type="button"
        data-modal-toggle="editUserModal"
        className=" p-2 font-medium bg-slate-100 hover:underline rounded-lg hover:bg-blue-600"
      >
        <RemoveRedEyeIcon className="text-slate-500 hover:text-white" />
      </button>
      {/* Edit user modal */}
      {modal && (
        <div
          className={`transition-transform duration-1000 delay-700 ease-in-out flex flex-row bg-black bg-opacity-30 overflow-y-auto overflow-x-hidden fixed left-0 top-0 z-20 justify-center items-center p-4 w-full md:inset-0 h-modal md:h-full`}
        >
          <div
            id="extralarge-modal"
            tabIndex={-1}
            className=" overflow-y-auto overflow-x-hidden fixed top-0 right-0 z-50  mr-0 md:h-full transition duration-300"
          >
            <div className="relative w-full max-w-lg h-full md:h-auto">
              {/* Modal content */}
              <form
                onSubmit={() => {}}
                className="relative bg-white rounded-tl-3xl rounded-bl-3xl shadow "
              >
                {/* Modal header */}
                <div className="p-3 absolute rounded-t">
                  <button
                    onClick={HANDLEMODAL}
                    type="button"
                    className="text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm p-1.5 ml-auto inline-flex items-center ease-in-out delay-100"
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
                <div className="py-8 px-6 space-y-2">
                  <div className="px-6 lg:px-8 space-y-4">
                    <h3 className="mb-6 text-xl font-medium text-gray-900 ">
                      Detail Transaction
                    </h3>
                    <div className="grid grid-cols-2 gap-4">
                      <InputField
                        name="transaction_id"
                        label="Transaction ID"
                        placeholder="Transaction ID"
                        disabled={true}
                        defaultValue={dataTransaksi.id}
                      />
                      <InputField
                        name="status"
                        label="Status Booking"
                        placeholder="Status Booking"
                        disabled={true}
                        defaultValue={jsConvert.toHeaderCase(
                          dataTransaksi.status
                        )}
                      />
                      <InputField
                        classNameHeader="col-span-2"
                        name="full_name"
                        label="Full Name"
                        placeholder="Full Name"
                        disabled={true}
                        defaultValue={jsConvert.toHeaderCase(
                          dataTransaksi.user.full_name
                        )}
                      />
                      <InputField
                        classNameHeader="col-span-2"
                        name="email"
                        label="Email Address"
                        placeholder="Email Address"
                        disabled={true}
                        defaultValue={dataTransaksi.user.email}
                      />
                      <InputField
                        classNameHeader="col-span-2"
                        name="email"
                        label="Office"
                        placeholder="Office"
                        disabled={true}
                        defaultValue={dataTransaksi.office.office_name}
                      />
                      <InputField
                        name="date"
                        label="Date"
                        // type="date"
                        placeholder="Date"
                        disabled={true}
                        defaultValue={dataTransaksi.check_in.date}
                      />
                      <InputField
                        name="text"
                        label="Check In"
                        placeholder="Check In"
                        disabled={true}
                        defaultValue={dataTransaksi.check_in.date}
                      />
                      <InputField
                        name="text"
                        label="Time"
                        placeholder="Time"
                        disabled={true}
                        defaultValue={dataTransaksi.check_in.time}
                      />
                      <InputField
                        name="text"
                        label="Duration"
                        placeholder="Duration"
                        disabled={true}
                        defaultValue={dataTransaksi.duration}
                      />
                      <InputField
                        name="text"
                        classNameHeader="col-span-2"
                        label="Welcome Drink"
                        placeholder="Welcome Drink"
                        disabled={true}
                        defaultValue={jsConvert.toHeaderCase(
                          dataTransaksi.drink
                        )}
                      />
                      <InputField
                        name="text"
                        label="Price"
                        placeholder="Price"
                        disabled={true}
                        defaultValue={price}
                      />
                      <InputField
                        name="text"
                        label="Payment Method"
                        placeholder="Payment Method"
                        disabled={true}
                        defaultValue={dataTransaksi.payment_method}
                      />
                      <InputField
                        name="text"
                        classNameHeader="col-span-2"
                        label="Price/Month"
                        placeholder="Price Month"
                        disabled={true}
                        defaultValue={`${price} /month`}
                      />
                      <InputField
                        name="text"
                        label="Service"
                        placeholder="Service"
                        disabled={true}
                        defaultValue={service}
                      />
                      <InputField
                        name="text"
                        label="PPN(11%)"
                        placeholder="PPN(11%)"
                        disabled={true}
                        defaultValue={ppn}
                      />
                    </div>

                    {/* Modal footer */}
                    <div className="flex h-full pt-4">
                      <div className="flex justify-end gap-5 w-full">
                        <button
                          type="button"
                          onClick={HANDLEMODAL}
                          className="w-full flex justify-center py-2 px-5 mb-2 text-sm font-medium text-gray-400 focus:outline-none bg-white rounded-lg border border-gray-200 hover:bg-success hover:text-white focus:z-10 focus:ring-4 focus:ring-gray-200"
                        >
                          <CloseOutlined className="text-lg mb-1 mr-2" />
                          <p className="my-auto">Close</p>
                        </button>
                      </div>
                    </div>
                  </div>
                </div>
                <div className="hidden">
                  <CurrencyFormat
                    className="hidden"
                    value={0.11 * dataTransaksi.price}
                    displayType={"text"}
                    thousandSeparator={true}
                    prefix={"Rp."}
                    renderText={(value) => {
                      setPPN(value);
                    }}
                  />
                  <CurrencyFormat
                    className="hidden"
                    value={dataTransaksi.price}
                    displayType={"text"}
                    thousandSeparator={true}
                    prefix={"Rp."}
                    renderText={(value) => {
                      setPrice(value);
                    }}
                  />
                  <CurrencyFormat
                    className="hidden"
                    value={10000}
                    displayType={"text"}
                    thousandSeparator={true}
                    prefix={"Rp."}
                    renderText={(value) => {
                      setService(value);
                    }}
                  />
                </div>
              </form>
            </div>
          </div>
        </div>
      )}
    </>
  );
};

export default ModalViewTransaction;
