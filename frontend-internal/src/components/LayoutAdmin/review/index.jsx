import React, { useEffect, useState } from "react";
import DeleteForeverIcon from "@mui/icons-material/DeleteForever";
import { toast, Toaster } from "react-hot-toast";
import CloseIcon from "@mui/icons-material/Close";
import Swal from "sweetalert2";
import { checkbox } from "assets";
import { Pagination, Select } from "antd";
import { twitter } from "assets";
import { Rating } from "@mui/material";
import { Helmet } from "react-helmet";
import { useDispatch, useSelector } from "react-redux";
import {
  deleteReview,
  fetchReview,
} from "store/Feature/FeatureReview/reviewSlice";
import { ContentTableLoader } from "components";

const Card = ({
  imgUrl,
  name,
  rating,
  date,
  office,
  comment,
  onChange,
  key,
}) => {
  return (
    <>
      <div className="flex justify-between">
        <div className="flex">
          <img src={imgUrl} className="rounded-full" alt="gambar" />
          <div className="pl-4 flex flex-col text-start">
            <p className="font-bold text-xl my-auto">{name}</p>
            <Rating
              name="half-rating-read"
              defaultValue={rating}
              precision={0.5}
              readOnly
            />
          </div>
        </div>
        <p className="text-gray-500">{date}</p>
      </div>
      <div className="my-12 text-start">
        <h3 className="font-bold text-gray-500">{office}</h3>
        <p className="text-gray-500">“{comment}”</p>
      </div>
      <div className="flex justify-end">
        <button
          onClick={onChange}
          className="rounded-xl text-white bg-fifth hover:bg-opacity-70 px-8 py-3 flex content-center"
        >
          <DeleteForeverIcon className="text-white" />
          <p className="ml-4 my-auto">Hide Comment</p>
        </button>
      </div>
    </>
  );
};

const ReviewPage = () => {
  const dispatch = useDispatch();
  const listOfReview = useSelector((state) => state.reviews.data);
  const pageSize = 4;
  const [dataReview, setDataReview] = useState({
    minValue: 0,
    maxValue: 2,
  });
  const [filter, setFilter] = useState("newest");
  const [testimonial, setTestimonial] = useState(listOfReview);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    dispatch(fetchReview()).then((res) => {
      setTestimonial(res.payload);
      setLoading(false);
    });
    setTimeout(() => {
      setLoading(false);
    }, 500);
    setDataReview({
      minValue: 0,
      maxValue: 4,
    });
  }, [dispatch]);

  const handleChange = (value) => {
    setDataReview({
      minValue: (value - 1) * pageSize,
      maxValue: value * pageSize,
    });
  };

  const setReload = () => {
    setLoading(true);
    setTimeout(() => {
      dispatch(fetchReview()).then((res) => {
        setTestimonial(res.payload);
      });
      setLoading(false);
    }, 500);
  };

  const handleFilter = (value) => {
    setFilter(value);
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
        title: `Are you sure?`,
        text: "The selected record will be permanently deleted. Are you want to continue",
        showCancelButton: true,
        confirmButtonText: "Yes, Delete",
        cancelButtonText: "No, cancel",
        reverseButtons: true,
      })
      .then((result) => {
        if (result.isConfirmed) {
          try {
            dispatch(deleteReview(id));
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
        <title>Dashboard | Reviews</title>
        <meta name="description" content="Helmet application" />
      </Helmet>
      <div className="flex flex-col w-full">
        <div className="flex justify-between px-8 py-4 w-full bg-white rounded-2xl shadow">
          <h1 className="text-3xl font-bold my-auto">Review</h1>
          <div className="flex content-center px-12 rounded-xl text-lg py-2">
            <p className="mr-4">Sort By : </p>
            <Select
              defaultValue="newest"
              style={{ width: 140 }}
              className="ring-0 border-0"
              onChange={handleFilter}
              options={[
                {
                  value: "newest",
                  label: "Newest",
                },
                {
                  value: "oldest",
                  label: "Oldest",
                },
              ]}
            />
          </div>
        </div>
        <div className=" my-8 py-8 justify-center flex min-w-full flex-wrap bg-white rounded-2xl shadow">
          {loading ? (
            <ContentTableLoader />
          ) : (
            <>
              {testimonial
                .slice(dataReview.minValue, dataReview.maxValue)
                .map((review) => (
                  <div
                    key={review.id}
                    className="bg-white p-8 m-8 drop-shadow-4xl rounded-2xl w-[520px]"
                  >
                    <Card
                      imgUrl={twitter}
                      name={review.user.full_name}
                      rating={review.score}
                      date={review.created_at.substr(0, 11)}
                      office={review.office.office_name}
                      comment={review.comment}
                      onChange={() => handleDelete(review.id)}
                    />
                  </div>
                ))}
            </>
          )}
        </div>
        <div>
          <Pagination
            defaultCurrent={1}
            defaultPageSize={pageSize}
            total={testimonial.length}
            onChange={handleChange}
          />
        </div>
      </div>
      <Toaster position="bottom-left" reverseOrder={false} />
    </>
  );
};

export default ReviewPage;
