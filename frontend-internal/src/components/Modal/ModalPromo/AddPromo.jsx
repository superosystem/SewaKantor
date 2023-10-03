import { CloseOutlined, PlusOutlined } from "@ant-design/icons";
import React, { useState } from "react";
import { useDispatch } from "react-redux";
import { fetchPromo, createPromo } from "store/Feature/FeaturePromo/promoSlice";
import Swal from "sweetalert2";
import CloseIcon from '@mui/icons-material/Close';
import { toast } from "react-hot-toast";
import { checkbox } from "assets";

const AddPromo = ({
    loading,
    setReload
}) => {
    const dispatch = useDispatch();

    const [data, setData] = useState({
        voucher_code: "",
        periode: "",
        nominal: "",
    });

    const [modal, setModal] = useState(false);

    const handleChangePromo = (ev) => {
        setData({
            ...data,
            [ev.target.name]: ev.target.value,
        });
    };

    const HandleModal = () => {
        setModal(!modal);
    }

    const handleSubmit = (ev) => {
        ev.preventDefault();
        const { nominal, periode, voucher_code } = data;
        try {
            dispatch(createPromo({ nominal, periode, voucher_code }));
            setModal(false)
            setReload()
            Swal.fire(
                {
                    icon: "success",
                    title: `Success!`,
                    text: "Add Promo Success.",
                    showConfirmButton: false,
                    timer: 1200
                }
            );
            toast.custom((t) => (
                <div
                    className={`${t.visible ? 'animate-enter ease-in-out duration-200' : 'animate-leave ease-in-out duration-200'
                        } max-w-md w-80 bg-white shadow-lg rounded-lg pointer-events-auto flex ring-1 ring-black ring-opacity-5`}>
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
                                <p className="text-sm font-bold text-success">
                                    Success
                                </p>
                                <p className="mt-1 text-sm text-gray-500">
                                    Success Added Promo
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
            ))
        } catch (error) {
            return Swal.fire({
                icon: "error",
                title: "Oops...",
                text: "Added is Failed ",
            });
        }

    };

    return (
        <>
            <button onClick={HandleModal} className="flex py-2 pl-10 pr-12 bg-blue-600 text-white rounded-xl">
                <PlusOutlined className="mr-4 my-auto text-xl mb-1" />
                <p className="my-auto">Add</p>
            </button>
            {/* Modal Add Promo */}
            {
                modal && (
                    <div className="flex flex-row bg-black bg-opacity-30 overflow-y-auto overflow-x-hidden fixed left-0 top-0 z-20 justify-center items-center p-4 w-full md:inset-0 h-modal md:h-full">
                        <div className="bg-white rounded-2xl px-20 py-12 w-1/2 absolute z-50 transform -translate-y-0 scale-90 transition-opacity transition-transform duration-300 center">
                            <div className="absolute">
                                <button onClick={HandleModal}>
                                    <CloseOutlined className="relative text-xl -top-6 right-12" />
                                </button>
                            </div>
                            <div className="text-start pb-6">
                                <h1 className="text-2xl font-bold text-gray-600">Add Promo / Voucher</h1>
                            </div>
                            <form onSubmit={handleSubmit}>
                                <div className="pb-6">
                                    <div className="relative">
                                        <input
                                            type="text"
                                            id="floating_outlined"
                                            class="block px-2.5 pb-2.5 pt-4 w-full text-sm text-gray-900 bg-transparent rounded-lg border-1 border-gray-300 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                                            placeholder=" "
                                            name="voucher_code"
                                            onChange={(ev) => handleChangePromo(ev)}
                                            autoComplete="off"
                                        />
                                        <label
                                            for="floating_outlined"
                                            className="absolute text-sm text-gray-500 duration-300 transform -translate-y-4 scale-75 top-2 z-10 origin-[0] bg-white  px-2 peer-focus:px-2 peer-focus:text-blue-600 peer-focus:dark:text-blue-500 peer-placeholder-shown:scale-100 peer-placeholder-shown:-translate-y-1/2 peer-placeholder-shown:top-1/2 peer-focus:top-2 peer-focus:scale-75 peer-focus:-translate-y-4 left-1">
                                            Voucher Code
                                        </label>
                                    </div>
                                </div>
                                <div className="pb-6">
                                    <div className="relative">
                                        <input
                                            type="date"
                                            id="floating_outlined"
                                            class="block px-2.5 pb-2.5 pt-4 w-full text-sm text-gray-900 bg-transparent rounded-lg border-1 border-gray-300 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                                            placeholder=" "
                                            name="periode"
                                            onChange={(ev) => handleChangePromo(ev)}
                                        />
                                        <label
                                            for="floating_outlined"
                                            className="absolute text-sm text-gray-500 duration-300 transform -translate-y-4 scale-75 top-2 z-10 origin-[0] bg-white  px-2 peer-focus:px-2 peer-focus:text-blue-600 peer-focus:dark:text-blue-500 peer-placeholder-shown:scale-100 peer-placeholder-shown:-translate-y-1/2 peer-placeholder-shown:top-1/2 peer-focus:top-2 peer-focus:scale-75 peer-focus:-translate-y-4 left-1">
                                            Periode
                                        </label>
                                    </div>
                                </div>
                                <div className="pb-6">
                                    <div className="relative">
                                        <input
                                            type="number"
                                            id="floating_outlined"
                                            class="block px-2.5 pb-2.5 pt-4 w-full text-sm text-gray-900 bg-transparent rounded-lg border-1 border-gray-300 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                                            placeholder=" "
                                            name="nominal"
                                            onChange={(ev) => handleChangePromo(ev)}
                                            autoComplete="off"
                                        />
                                        <label
                                            for="floating_outlined"
                                            className="absolute text-sm text-gray-500 duration-300 transform -translate-y-4 scale-75 top-2 z-10 origin-[0] bg-white  px-2 peer-focus:px-2 peer-focus:text-blue-600 peer-focus:dark:text-blue-500 peer-placeholder-shown:scale-100 peer-placeholder-shown:-translate-y-1/2 peer-placeholder-shown:top-1/2 peer-focus:top-2 peer-focus:scale-75 peer-focus:-translate-y-4 left-1">
                                            Nominal
                                        </label>
                                    </div>
                                </div>
                                <div class="flex items-center justify-center w-full pb-6">
                                    <label for="dropzone-file" class="flex flex-col items-center justify-center w-full h-64 border-2 border-gray-300 border-dashed rounded-lg cursor-pointer bg-gray-50 dark:hover:bg-bray-800 dark:bg-gray-700 hover:bg-gray-100 dark:border-gray-600 dark:hover:border-gray-500 dark:hover:bg-gray-600">
                                        <div class="flex flex-col items-center justify-center pt-5 pb-6">
                                            <svg aria-hidden="true" class="w-10 h-10 mb-3 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12"></path></svg>
                                            <p class="mb-2 text-sm text-gray-500 dark:text-gray-400"><span class="font-semibold">Click to upload</span> or drag and drop</p>
                                            <p class="text-xs text-gray-500 dark:text-gray-400">SVG, PNG, JPG or GIF (MAX. 800x400px)</p>
                                        </div>
                                        <input id="dropzone-file" type="file" class="hidden" />
                                    </label>
                                </div>
                                <div className="w-full flex justify-between">
                                    <button type="reset" className="w-1/2 border-2 border-success rounded-lg text-success m-2 hover:bg-success hover:text-white">
                                        Reset
                                    </button>
                                    <button type="submit" className="w-1/2 bg-success m-2 text-white py-3 rounded-lg hover:bg-opacity-70">
                                        Save
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                )
            }
        </>
    )
}

export default AddPromo;