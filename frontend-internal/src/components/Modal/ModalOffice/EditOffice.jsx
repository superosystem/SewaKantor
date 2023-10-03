import React, { useEffect, useState } from "react";
import { dataJakarta } from "store/dataJakarta";
import CreateIcon from "@mui/icons-material/Create";
import { useDispatch, useSelector } from "react-redux";
import { updateOffice } from "store/Feature/FeatureOffice/officeSlice";
import CloseIcon from "@mui/icons-material/Close";
import { toast } from "react-hot-toast";
import { checkbox } from "assets";
import { fetchFacility } from "store/Feature/FeaturesFacility/facilitySlice";
import jsConvert from "js-convert-case";
import CurrencyInput from "react-currency-input-field";
import Swal from "sweetalert2";

const InputField = ({
  name,
  label,
  placeholder,
  defaultValue,
  onClick,
  onChange,
  className = "border-gray-400",
  type = "text",
  disabled,
  onKeyPress,
}) => (
  <div className="relative">
    <input
      type={type}
      id="floating_outlined"
      className={`${className} block px-2.5 pb-2.5 pt-4 w-full text-sm text-gray-900 bg-transparent rounded-lg border-2 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer`}
      placeholder={placeholder}
      name={name}
      onClick={onClick}
      defaultValue={defaultValue}
      onKeyPress={onKeyPress}
      onChange={onChange}
      disabled={disabled}
    />
    <label
      htmlFor="floating_outlined"
      className="absolute text-sm text-gray-500 duration-300 transform -translate-y-4 scale-75 top-2 z-10 origin-[0] bg-white  px-2 peer-focus:px-2 peer-focus:text-blue-600 peer-focus:dark:text-blue-500 peer-placeholder-shown:scale-100 peer-placeholder-shown:-translate-y-1/2 peer-placeholder-shown:top-1/2 peer-focus:top-2 peer-focus:scale-75 peer-focus:-translate-y-4 left-1"
    >
      {label}
    </label>
  </div>
);

const CurrencyField = ({
  name,
  label,
  placeholder,
  defaultValue,
  onClick,
  onValueChange,
  className = "border-gray-400",
  type = "text",
  disabled,
}) => (
  <div className="relative">
    <CurrencyInput
      type={type}
      id="floating_outlined"
      className={`${className} block px-2.5 pb-2.5 pt-4 w-full text-sm text-gray-900 bg-transparent rounded-lg border-2 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer`}
      placeholder={placeholder}
      name={name}
      prefix={"Rp."}
      onClick={onClick}
      defaultValue={defaultValue}
      onValueChange={onValueChange}
      autoComplete="off"
      disabled={disabled}
    />
    <label
      htmlFor="floating_outlined"
      className="absolute text-sm text-gray-500 duration-300 transform -translate-y-4 scale-75 top-2 z-10 origin-[0] bg-white  px-2 peer-focus:px-2 peer-focus:text-blue-600 peer-focus:dark:text-blue-500 peer-placeholder-shown:scale-100 peer-placeholder-shown:-translate-y-1/2 peer-placeholder-shown:top-1/2 peer-focus:top-2 peer-focus:scale-75 peer-focus:-translate-y-4 left-1"
    >
      {label}
    </label>
  </div>
);

const EditOffice = ({ dataDetailOffice, setReload }) => {
  const imageTypeRegex = /image\/(jpg|jpeg)/gm;
  const [jakartaLits, setJakartaList] = useState(dataJakarta);
  const dispatch = useDispatch();
  const [citys, setCitys] = useState([]);
  const [city, setCity] = useState("");
  const [visibleCity, setVisibleCity] = useState(false);
  const [district, setDistrict] = useState([]);
  const [lat, setLat] = useState(null);
  const [lng, setLng] = useState(null);
  const [status, setStatus] = useState(null);
  const [imageFiles, setImageFiles] = useState(dataDetailOffice.images);
  const [images, setImages] = useState([]);

  const listOfFacility = useSelector((state) => state.facility.data);
  const [facilityList, setFacilityList] = useState(listOfFacility);

  const checked = dataDetailOffice.facility_model.map(
    (val) => val.facilities_id
  );

  let facilities = "";
  checked.forEach((val, i) => {
    if (i === checked.length - 1) {
      facilities += val;
    } else {
      facilities += `${val},`;
    }
  });

  const [isCheck, setIsCheck] = useState(facilities.split(","));

  const [data, setData] = useState({
    id: dataDetailOffice.id,
    title: dataDetailOffice.title,
    description: dataDetailOffice.description,
    office_type: dataDetailOffice.office_type.toLowerCase(),
    office_length: dataDetailOffice.office_length,
    price: dataDetailOffice.price,
    open_hour: dataDetailOffice.open_hour,
    close_hour: dataDetailOffice.close_hour,
    lat: dataDetailOffice.lat,
    lng: dataDetailOffice.lng,
    accommodate: dataDetailOffice.accommodate,
    working_desk: dataDetailOffice.working_desk,
    meeting_room: dataDetailOffice.meeting_room,
    private_room: dataDetailOffice.private_room,
    city: dataDetailOffice.city.toLowerCase(),
    district: dataDetailOffice.district,
    address: dataDetailOffice.address,
    images: imageFiles,
    facilities_id: isCheck.toString(),
  });

  const checkedFacilityDesc = dataDetailOffice.facility_model.map(
    (val) => val.facilities_desc
  );

  const handleChangeFacilities = (ev) => {
    const { value, checked } = ev.target;
    setIsCheck([...isCheck, value]);
    if (!checked) {
      setIsCheck(isCheck.filter((item) => item !== value));
    }
    setData({ ...data, facilities_id: isCheck.toString() });
  };

  const [modal, setModal] = useState(false);
  const HandleModal = (ev) => {
    ev.preventDefault();
    setModal(!modal);
    setIsCheck(facilities.split(","));
    setData({ ...data, facilities_id: facilities });
    setVisibleCity(false);
  };

  const handleUploadImages = (e) => {
    e.preventDefault();
    const { files } = e.target;
    const validImageFiles = [];
    for (let i = 0; i < files.length; i++) {
      const file = files[i];
      if (file.type.match(imageTypeRegex)) {
        validImageFiles.push(file);
      }
    }
    if (validImageFiles.length) {
      setImageFiles(validImageFiles);
      return;
    }
    alert("Selected images are not of valid type!");
  };

  // console.log(imageFiles)

  useEffect(() => {
    dispatch(fetchFacility()).then((res) => {
      setFacilityList(res.payload);
    });

    const fileReaders = [];
    let isCancel = false;
    if (imageFiles.length) {
      const promises = imageFiles.map((file) => {
        return new Promise((resolve, reject) => {
          const fileReader = new FileReader();
          fileReaders.push(fileReader);
          fileReader.onload = (e) => {
            const { result } = e.target;
            if (result) {
              resolve(result);
            }
          };
          fileReader.onabort = () => {
            reject(new Error("File reading aborted"));
          };
          fileReader.onerror = () => {
            reject(new Error("Failed to read file"));
          };
          fileReader.readAsDataURL(file);
        });
      });
      Promise.all(promises)
        .then((images) => {
          if (!isCancel) {
            setImages(images);
            setData({ ...data, images: images });
          }
        })
        .catch((err) => {
          console.log(err);
        });
    }
    return () => {
      isCancel = true;
      fileReaders.forEach((fileReader) => {
        if (fileReader.readyState === 1) {
          fileReader.abort();
        }
      });
    };
  }, [imageFiles]);

  const preventMinus = (e) => {
    if (e.code === "Minus") {
      e.preventDefault();
    }
  };

  const setHandleChangeData = (ev) => {
    setData({
      ...data,
      [ev.target.name]: ev.target.value,
    });
  };

  const setHandleValuePrice = (value) => {
    setData({
      ...data,
      price: value,
    });
  };

  useEffect(() => {
    setJakartaList(dataJakarta);
    const list = [];
    jakartaLits.map((city) => {
      return list.push(city.city);
    });
    setCitys(list);
    setDistrict(jakartaLits[0].district);
  }, [dataJakarta]);

  const handleSelectedCity = (evt) => {
    const checked = evt.target.value;
    setCity(checked);
    if (checked) {
      setVisibleCity(true);
    }
    const index = citys.indexOf(checked);
    setDistrict(jakartaLits[index].district);
    setData({ ...data, city: checked });
  };

  const handleSelectedDistrict = (evt) => {
    const checked = evt.target.value;
    setData({ ...data, district: checked });
  };

  const getLocation = () => {
    if (!navigator.geolocation) {
      setStatus("Geolocation is not supported by your browser");
    } else {
      setStatus("Locating...");
      navigator.geolocation.getCurrentPosition(
        (position) => {
          setStatus(null);
          setLat(position.coords.latitude);
          setLng(position.coords.longitude);
        },
        () => {
          setStatus("Unable to retrieve your location");
        }
      );
    }
  };

  const handleUpdate = (e) => {
    e.preventDefault();
    const formData = new FormData();
    formData.append("id", data.id);
    formData.append("title", data.title);
    formData.append("description", data.description);
    formData.append("office_type", data.office_type);
    formData.append("office_length", data.office_length);
    formData.append("price", data.price);
    formData.append("open_hour", data.open_hour);
    formData.append("close_hour", data.close_hour);
    formData.append("lat", data.lat);
    formData.append("lng", data.lng);
    formData.append("accommodate", data.accommodate);
    formData.append("working_desk", data.working_desk);
    formData.append("meeting_room", data.meeting_room);
    formData.append("private_room", data.private_room);
    formData.append("city", data.city);
    formData.append("district", data.district);
    formData.append("address", data.address);
    formData.append("facilities_id", isCheck.toString());
    imageFiles.forEach((image) => {
      formData.append("images", image);
    });
    try {
      dispatch(updateOffice(formData));
      console.log(formData);
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
                <p className="mt-1 text-sm text-gray-500">Successfully Updated</p>
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
        text: "Edit Office Failed",
        showConfirmButton: false,
        timer: 1000,
      });
    }
  };

  return (
    <>
      <button
        type="button"
        onClick={HandleModal}
        data-modal-toggle="editUserModal"
        className="px-2 py-2 font-medium bg-slate-100 hover:underline rounded-lg hover:bg-blue-600"
      >
        <CreateIcon className="text-slate-500 hover:text-white" />
      </button>

      {modal && (
        <div className="flex flex-row bg-black bg-opacity-30 overflow-y-scroll fixed left-0 top-0 z-50 justify-center items-center p-4 pt-32 w-full md:inset-0">
          <div className="bg-white rounded-2xl px-20 py-12 mt-96 mb-12 w-3/4 z-50 drop-shadow-4xl transform -translate-y-0 scale-25 transition-opacity transition-transform duration-300 center">
            <div className="flex flex-col w-full">
              <div className="flex justify-between px-8 py-4 w-full bg-white rounded-2xl drop-shadow-4xl">
                <h1 className="text-2xl text-gray-800 font-bold my-auto">
                  Edit Office
                </h1>
                <button
                  type="button"
                  onClick={HandleModal}
                  className="text-white bg-fifth hover:bg-red-400 font-medium rounded-full text-sm px-5 my-auto py-2.5 flex text-center"
                >
                  <p className="my-auto">Close</p>
                </button>
              </div>
              <form
                onSubmit={handleUpdate}
                className="bg-white rounded-2xl drop-shadow-4xl w-full py-4 px-4 justify-between flex mt-8"
                key={dataDetailOffice.id}
              >
                <div className="mx-2 mt-4 mb-4 w-1/2">
                  <div className="pb-6">
                    <InputField
                      name="id"
                      label="Office ID"
                      placeholder="Office ID"
                      disabled={true}
                      defaultValue={dataDetailOffice.id}
                      onChange={(ev) => setHandleChangeData(ev)}
                    />
                  </div>
                  <div className="pb-6">
                    <InputField
                      name="title"
                      label="Full Name"
                      placeholder="Full Name"
                      defaultValue={dataDetailOffice.title}
                      onChange={(ev) => setHandleChangeData(ev)}
                    />
                  </div>
                  <div className="pb-6 flex-col text-start">
                    <p className="pb-4">Select Type</p>
                    <div className="flex">
                      <div className="flex items-center mr-4">
                        <input
                          id="inline-radio"
                          type="radio"
                          value="office"
                          name="office_type"
                          onChange={(ev) => setHandleChangeData(ev)}
                          defaultChecked={
                            dataDetailOffice.office_type.toLowerCase() ===
                              "office"
                              ? true
                              : undefined
                          }
                          className="w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-gray-800 focus:ring-2 dark:bg-gray-700 dark:border-gray-600"
                        />
                        <label
                          htmlFor="inline-radio"
                          className="ml-2 text-sm font-medium text-gray-900 dark:text-gray-300"
                        >
                          Office
                        </label>
                      </div>
                      <div className="flex items-center mr-4">
                        <input
                          id="inline-2-radio"
                          type="radio"
                          value="coworking space"
                          name="office_type"
                          onChange={(ev) => setHandleChangeData(ev)}
                          defaultChecked={
                            dataDetailOffice.office_type.toLowerCase() ===
                              "coworking space"
                              ? true
                              : undefined
                          }
                          className="w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-gray-800 focus:ring-2 dark:bg-gray-700 dark:border-gray-600"
                        />
                        <label
                          htmlFor="inline-2-radio"
                          className="ml-2 text-sm font-medium text-gray-900 dark:text-gray-300"
                        >
                          Coworking
                        </label>
                      </div>
                      <div className="flex items-center mr-4">
                        <input
                          id="inline-checked-radio"
                          type="radio"
                          value="meeting room"
                          name="office_type"
                          onChange={(ev) => setHandleChangeData(ev)}
                          defaultChecked={
                            dataDetailOffice.office_type.toLowerCase() ===
                              "meeting room"
                              ? true
                              : undefined
                          }
                          className="w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-gray-800 focus:ring-2 dark:bg-gray-700 dark:border-gray-600"
                        />
                        <label
                          htmlFor="inline-checked-radio"
                          className="ml-2 text-sm font-medium text-gray-900 dark:text-gray-300"
                        >
                          Meeting Room
                        </label>
                      </div>
                    </div>
                  </div>
                  <div className="pb-6 flex w-full">
                    <div className="w-full">
                      <CurrencyField
                        name="price"
                        label="Price(Rp)"
                        placeholder="Price(Rp)"
                        defaultValue={dataDetailOffice.price}
                        onKeyPress={preventMinus}
                        onValueChange={(value, name) =>
                          setHandleValuePrice(value)
                        }
                      />
                    </div>
                    <div className="flex mx-auto w-full ml-8">
                      <div className="flex items-center mx-8">
                        <input
                          id="inline-radio"
                          type="radio"
                          defaultChecked={true}
                          onChange={() => { }}
                          className="w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-gray-800 focus:ring-2 dark:bg-gray-700 dark:border-gray-600"
                        />
                        <label
                          htmlFor="inline-radio"
                          className="ml-2 text-sm font-medium text-gray-900 dark:text-gray-300"
                        >
                          / hour
                        </label>
                      </div>
                      <div className="flex items-center">
                        <input
                          id="inline-2-radio"
                          type="radio"
                          onChange={() => { }}
                          className="w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-gray-800 focus:ring-2 dark:bg-gray-700 dark:border-gray-600"
                        />
                        <label
                          htmlFor="inline-2-radio"
                          className="ml-2 text-sm font-medium text-gray-900 dark:text-gray-300"
                        >
                          / month
                        </label>
                      </div>
                    </div>
                  </div>
                  <div className="w-full flex">
                    <div className="pb-6 w-full">
                      <InputField
                        name="open_hour"
                        label="Open"
                        placeholder="Open"
                        defaultValue={dataDetailOffice.open_hour}
                        type="time"
                        onChange={(ev) => setHandleChangeData(ev)}
                      />
                    </div>
                    <div className="pb-6 w-full ml-8">
                      <InputField
                        name="close_hour"
                        label="Close"
                        placeholder="Close"
                        defaultValue={dataDetailOffice.close_hour}
                        type="time"
                        onChange={(ev) => setHandleChangeData(ev)}
                      />
                    </div>
                  </div>
                  <div className="pb-6 w-full">
                    <InputField
                      name="office_length"
                      label="Length Office / M2"
                      placeholder="Length Office / M2"
                      defaultValue={dataDetailOffice.office_length}
                      onChange={(ev) => setHandleChangeData(ev)}
                    />
                  </div>
                  <div className="pb-6 w-full">
                    <InputField
                      name="description"
                      label="Description"
                      placeholder="Description"
                      defaultValue={dataDetailOffice.description}
                      onChange={(ev) => setHandleChangeData(ev)}
                    />
                  </div>
                  <div className="pb-6 w-full flex justify-between">
                    <div className="w-full">
                      <select
                        id="city"
                        name="city"
                        onClick={(ev) => handleSelectedCity(ev)}
                        onChange={(ev) => setHandleChangeData(ev)}
                        defaultChecked={
                          citys.includes(dataDetailOffice.city)
                            ? true
                            : undefined
                        }
                        className="border-2 py-3.5 border-gray-400 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
                      >
                        <option
                          value={dataDetailOffice.city}
                          hidden={visibleCity ? true : undefined}
                          defaultChecked={dataDetailOffice.city}
                        >
                          {dataDetailOffice.city}
                        </option>
                        {jakartaLits.map((city, index) => {
                          return (
                            <option
                              value={city.city}
                              key={index}
                              id="regionIndex"
                              index={index}
                            >
                              {jsConvert.toHeaderCase(city.city)}
                            </option>
                          );
                        })}
                      </select>
                    </div>
                    <div className="w-full ml-8">
                      <select
                        id="district"
                        name="district"
                        onClick={(ev) => handleSelectedDistrict(ev)}
                        onChange={(ev) => setHandleChangeData(ev)}
                        defaultChecked={dataDetailOffice.district}
                        className="border-2 py-3.5 border-gray-400 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
                      >
                        <option
                          value={dataDetailOffice.district}
                          hidden={visibleCity ? true : undefined}
                          defaultChecked={dataDetailOffice.district}
                        >
                          {dataDetailOffice.district}
                        </option>
                        {district.map((val, index) => {
                          return (
                            <option
                              value={val}
                              id="regionIndex"
                              key={index}
                              index={index}
                            >
                              {val}
                            </option>
                          );
                        })}
                      </select>
                    </div>
                  </div>
                  <div className="pb-6 w-full">
                    <InputField
                      name="address"
                      label="Address"
                      placeholder="Address"
                      defaultValue={dataDetailOffice.address}
                      onChange={(ev) => setHandleChangeData(ev)}
                    />
                  </div>
                  <div className="pb-6 w-full flex justify-between">
                    <div className="w-full">
                      <InputField
                        name="lat"
                        label="Latitude"
                        placeholder="Latitude"
                        onClick={getLocation}
                        defaultValue={dataDetailOffice.lat}
                        onChange={(ev) => setHandleChangeData(ev)}
                      />
                    </div>
                    <div className="w-full ml-8">
                      <InputField
                        name="lng"
                        label="Longitude"
                        placeholder="Longitude"
                        onClick={getLocation}
                        defaultValue={dataDetailOffice.lng}
                        onChange={(ev) => setHandleChangeData(ev)}
                      />
                    </div>
                  </div>
                  <div className="flex items-center pb-6 justify-center w-full">
                    <label
                      htmlFor="dropzone-file"
                      className="flex flex-col items-center justify-center w-full h-40 border-2 border-gray-300 border-dashed rounded-lg cursor-pointer bg-gray-50 dark:hover:bg-bray-800 dark:bg-gray-700 hover:bg-gray-100 dark:border-gray-600 dark:hover:border-gray-500 dark:hover:bg-gray-600"
                    >
                      <input
                        id="dropzone-file"
                        type="file"
                        name="images"
                        accept="image/jpg, image/jpeg"
                        multiple
                        className="hidden"
                        onChange={(e) => handleUploadImages(e)}
                      />
                      <div className="gap-6">
                        <div className="flex justify-between py-2">
                          {images.length > 0 ? (
                            <>
                              {images.map((img, i) => (
                                <img
                                  key={i}
                                  src={img}
                                  alt="image1"
                                  className="max-w-[90px] max-h-[90px] mx-2 rounded-md"
                                />
                              ))}
                            </>
                          ) : (
                            <>
                              {dataDetailOffice.images.map((img, i) => (
                                <img
                                  key={i}
                                  src={img}
                                  alt="image1"
                                  className="max-w-[90px] max-h-[90px] mx-2 rounded-md"
                                />
                              ))}
                            </>
                          )}
                        </div>
                      </div>
                    </label>
                  </div>
                  <div className="w-full flex justify-between">
                    <button
                      type="reset"
                      className="w-1/2 border-2 border-success rounded-lg text-success mr-8 hover:bg-success hover:text-white"
                    >
                      Reset
                    </button>
                    <button
                      type="submit"
                      className="w-1/2 bg-success text-white py-3 rounded-lg hover:bg-opacity-70"
                    >
                      Save
                    </button>
                  </div>
                </div>
                <div className="mx-12 w-1/2">
                  <p className="text-start mb-2 mt-4">Capacity</p>
                  <div className="pb-6 w-full flex justify-between">
                    <div className="w-3/4">
                      <InputField
                        name="accommodate"
                        label="Accommodate"
                        placeholder="Accommodate"
                        defaultValue={dataDetailOffice.accommodate}
                        onChange={(ev) => setHandleChangeData(ev)}
                      />
                    </div>
                    <div className="w-1/4 ml-4">
                      <InputField
                        label="Person"
                        placeholder="Person"
                        className="border-gray-200"
                        disabled={true}
                      />
                    </div>
                  </div>
                  <div className="pb-6 w-full flex justify-between">
                    <div className="w-3/4">
                      <InputField
                        name="working_desk"
                        label="Working Desk"
                        placeholder="Working Desk"
                        defaultValue={dataDetailOffice.working_desk}
                        onChange={(ev) => setHandleChangeData(ev)}
                      />
                    </div>
                    <div className="w-1/4 ml-4">
                      <InputField
                        label="Desk"
                        placeholder="Desk"
                        className="border-gray-200"
                        disabled={true}
                      />
                    </div>
                  </div>
                  <div className="pb-6 w-full flex justify-between">
                    <div className="w-3/4">
                      <InputField
                        name="meeting_room"
                        label="Meeting Room"
                        placeholder="Meeting Room"
                        defaultValue={dataDetailOffice.meeting_room}
                        onChange={(ev) => setHandleChangeData(ev)}
                      />
                    </div>
                    <div className="w-1/4 ml-4">
                      <InputField
                        label="Room"
                        placeholder="Room"
                        className="border-gray-200"
                        disabled={true}
                      />
                    </div>
                  </div>
                  <div className="pb-6 w-full flex justify-between">
                    <div className="w-3/4">
                      <InputField
                        name="private_room"
                        label="Private Room"
                        placeholder="Private Room"
                        onChange={(ev) => setHandleChangeData(ev)}
                        defaultValue={dataDetailOffice.private_room}
                      />
                    </div>
                    <div className="w-1/4 ml-4">
                      <InputField
                        label="Room"
                        placeholder="Room"
                        className="border-gray-200"
                        disabled={true}
                      />
                    </div>
                  </div>
                  <p className="text-start mb-2">Facilities</p>
                  {facilityList?.slice(0, 10).map((fasilitas, index) => (
                    <div className="flex items-center mb-2" key={fasilitas.id}>
                      <input
                        onChange={(ev) => handleChangeFacilities(ev)}
                        defaultChecked={
                          checkedFacilityDesc.includes(
                            `${fasilitas.description}`
                          )
                            ? true
                            : undefined
                        }
                        id="default-checkbox"
                        type="checkbox"
                        value={fasilitas.id}
                        name="facilities_id"
                        className="w-4 h-4 text-blue-600 bg-gray-100 rounded border-gray-400 focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-gray-800 focus:ring-2 dark:bg-gray-700 dark:border-gray-600"
                      />
                      <label
                        htmlFor="default-checkbox"
                        className="ml-8 border-2 pl-3 py-3 w-full text-start border-gray-400 rounded-lg text-sm font-normal text-gray-900 dark:text-gray-300"
                      >
                        {fasilitas.description}
                      </label>
                    </div>
                  ))}
                </div>
              </form>
            </div>
          </div>
        </div>
      )}
    </>
  );
};

export default EditOffice;
