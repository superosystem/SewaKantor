import Swal from "sweetalert2";

const DeleteAlert = () => {
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
          swalWithBootstrapButtons.fire(
            "Deleted!",
            "Your file has been deleted.",
            "success"
          );
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

export default DeleteAlert;
