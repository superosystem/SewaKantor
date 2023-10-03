import React, { useState } from "react";
import { CloseOutlined } from "@ant-design/icons";
import RemoveRedEyeIcon from "@mui/icons-material/RemoveRedEye";
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
}) => (
  <div className="relative">
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

const ViewOffice = ({ dataDetailOffice }) => {
  const [price, setPrice] = useState("");
  const [modal, setModal] = useState(false);
  const HandleModal = () => {
    setModal(!modal);
  };

  return (
    <>
      <button
        onClick={HandleModal}
        href="#"
        type="button"
        data-modal-toggle="editUserModal"
        className=" transition-transform duration-1000 delay-700 ease-in-out p-2 font-medium bg-slate-100 hover:underline rounded-lg hover:bg-blue-600"
      >
        <RemoveRedEyeIcon className="text-slate-500 hover:text-white" />
      </button>

      {/* Modal View */}
      {modal && (
        <div
          className={` transition-transform duration-1000 delay-700 ease-in-out flex flex-row bg-black bg-opacity-30 overflow-y-auto overflow-x-hidden fixed left-0 top-0 z-20 justify-center items-center p-4 w-full md:inset-0 h-modal md:h-full`}
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
                <div className="p-3 mt-1 absolute rounded-t">
                  <button
                    onClick={HandleModal}
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
                    <h3 className="mb-4 text-xl text-start font-medium text-gray-900 ">
                      Detail Office
                    </h3>
                    <div className="grid grid-cols-2 gap-4">
                      <InputField
                        name="office_id"
                        label="Office ID"
                        placeholder="Office ID"
                        disabled={true}
                        defaultValue={dataDetailOffice.id}
                      />
                      <InputField
                        name="type"
                        label="Type"
                        placeholder="Type"
                        disabled={true}
                        defaultValue={dataDetailOffice.office_type}
                      />

                      <div className="col-span-2 relative">
                        <InputField
                          name="full_name"
                          label="Full Name"
                          placeholder="Full Name"
                          disabled={true}
                          defaultValue={dataDetailOffice.title}
                        />
                      </div>

                      <div className="col-span-2 relative">
                        <InputField
                          name="price"
                          label={`Price / ${"hour"}`}
                          placeholder="Type"
                          disabled={true}
                          defaultValue={price}
                        />
                      </div>
                      <InputField
                        name="address"
                        label="Address"
                        placeholder="Address"
                        disabled={true}
                        defaultValue={dataDetailOffice.address}
                      />
                      <InputField
                        name="district"
                        label="District"
                        placeholder="District"
                        disabled={true}
                        defaultValue={dataDetailOffice.district}
                      />
                      <InputField
                        name="open"
                        label="Open"
                        type="time"
                        placeholder="Open"
                        disabled={true}
                        defaultValue={dataDetailOffice.open_hour}
                      />
                      <InputField
                        name="close"
                        label="Close"
                        type="time"
                        placeholder="Close"
                        disabled={true}
                        defaultValue={dataDetailOffice.close_hour}
                      />
                      <div className="col-span-2 relative">
                        <InputField
                          name="description"
                          label="Description"
                          className="h-24"
                          placeholder="Description"
                          disabled={true}
                          defaultValue={dataDetailOffice.description}
                        />
                      </div>
                      <InputField
                        name="capacity"
                        label="Capacity"
                        placeholder="Capacity"
                        disabled={true}
                        defaultValue={`${dataDetailOffice.accommodate} Person`}
                      />
                      <InputField
                        name="meeting_room"
                        label="Meeting Room"
                        placeholder="Meeting Room"
                        disabled={true}
                        defaultValue={`${dataDetailOffice.meeting_room} Room`}
                      />
                      <InputField
                        name="private_room"
                        label="Private Room"
                        placeholder="Private Room"
                        disabled={true}
                        defaultValue={`${dataDetailOffice.private_room} Room`}
                      />
                      <InputField
                        name="working_desk"
                        label="Working Desk"
                        placeholder="Working Desk"
                        disabled={true}
                        defaultValue={`${dataDetailOffice.working_desk} Desk`}
                      />
                      <div className="col-span-2 relative">
                        <InputField
                          name="facilities"
                          label="Facilities"
                          placeholder="Facilities"
                          disabled={true}
                          defaultValue={`${dataDetailOffice.facility_model.length} Facilities`}
                        />
                        <div className="pt-2 text-start">
                          {dataDetailOffice.facility_model.map((fasility) => (
                            <p
                              key={fasility.facilities_id}
                              className="py-3 px-3 border border-gray-400 rounded-lg mb-2"
                            >
                              {fasility.facilities_desc}
                            </p>
                          ))}
                        </div>
                      </div>
                      <div className="col-span-2 relative">
                        <InputField
                          name="address"
                          label="Address"
                          placeholder="Address"
                          disabled={true}
                          defaultValue={`${dataDetailOffice.address}, ${dataDetailOffice.district}, ${dataDetailOffice.city}`}
                        />
                      </div>
                      <InputField
                        name="latitude"
                        label="Latitude"
                        placeholder="Latitude"
                        disabled={true}
                        defaultValue={dataDetailOffice.lat}
                      />
                      <InputField
                        name="longitude"
                        label="Longitude"
                        placeholder="Longitude"
                        disabled={true}
                        defaultValue={dataDetailOffice.lng}
                      />
                      <div className="col-span-2 relative">
                        <InputField
                          name="length_room"
                          label="Length Room"
                          placeholder="Length Room"
                          disabled={true}
                          defaultValue={`${dataDetailOffice.office_length}m2`}
                        />
                      </div>
                      <div className="col-span-2 relative">
                        <InputField
                          name="total_booked"
                          label="Total Booked"
                          placeholder="Total Booked"
                          disabled={true}
                          defaultValue={dataDetailOffice.total_booked}
                        />
                      </div>
                    </div>
                    <div>
                      <div className="flex items-center justify-center w-full">
                        <label
                          htmlFor="dropzone-file"
                          className="flex flex-wrap items-center justify-center w-full h-auto border-2 border-gray-300 border-dashed rounded-lg cursor-pointer bg-gray-50 dark:hover:bg-bray-800 dark:bg-gray-700 hover:bg-gray-100 dark:border-gray-600 dark:hover:border-gray-500 dark:hover:bg-gray-600"
                        >
                          <div className="gap-6">
                            <div className="flex justify-between py-2">
                              <img
                                src={dataDetailOffice.images[0]}
                                alt="image1"
                                className="max-w-[90px] max-h-[90px] mx-2 rounded-md"
                              />
                              <img
                                src={dataDetailOffice.images[1]}
                                alt="image2"
                                className="max-w-[90px] max-h-[90px] mx-2 rounded-md"
                              />
                              <img
                                src={dataDetailOffice.images[2]}
                                alt="image3"
                                className="max-w-[90px] max-h-[90px] mx-2 rounded-md"
                              />
                              <img
                                src={dataDetailOffice.images[3]}
                                alt="image3"
                                className="max-w-[90px] max-h-[90px] mx-2 rounded-md"
                              />
                            </div>
                          </div>
                        </label>
                      </div>
                    </div>

                    {/* Modal footer */}
                    <div className="flex">
                      <button
                        type="button"
                        onClick={HandleModal}
                        className="w-full flex justify-center py-2 px-5 mb-2 text-sm font-medium text-gray-400 focus:outline-none bg-white rounded-lg border border-gray-200 hover:bg-success hover:text-white focus:z-10 focus:ring-4 focus:ring-gray-200"
                      >
                        <CloseOutlined className="text-lg mb-1 mr-2" />
                        <p className="my-auto">Close</p>
                      </button>
                    </div>
                  </div>
                </div>
              </form>
            </div>
          </div>
          <CurrencyFormat
            className="hidden"
            value={0.11 * dataDetailOffice.price}
            displayType={"text"}
            thousandSeparator={true}
            prefix={"Rp."}
            renderText={(value) => {
              setPrice(value);
            }}
          />
        </div>
      )}
    </>
  );
};

export default ViewOffice;
