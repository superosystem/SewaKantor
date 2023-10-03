class constantValue {
  //helper constant
  //---

  //api endpoint constant
  String baseUrl = "https://cd0d-103-191-218-211.ngrok-free.app/api/v1/";

  //user endpoint
  String userRegisterEndpoint =
      "https://cd0d-103-191-218-211.ngrok-free.app/api/v1/register";
  String userLoginEndpoint =
      "https://cd0d-103-191-218-211.ngrok-free.app/api/v1/login";
  String userGetProfileEndpoint =
      "https://cd0d-103-191-218-211.ngrok-free.app/api/v1/profile";
  String userRefreshToken =
      "https://cd0d-103-191-218-211.ngrok-free.app/api/v1/refresh";
  String userLogoutWithToken =
      "https://cd0d-103-191-218-211.ngrok-free.app/api/v1/logout";
  String userSetProfilePhoto =
      "https://cd0d-103-191-218-211.ngrok-free.app/api/v1/profile/photo";
  String userChangeProfileData =
      "https://cd0d-103-191-218-211.ngrok-free.app/api/v1/profile";
  String userDeleteAccount =
      "https://cd0d-103-191-218-211.ngrok-free.app/api/v1/profile";

  //office endpoint
  String getAllOffice =
      "https://cd0d-103-191-218-211.ngrok-free.app/api/v1/offices/all";
  String getCoworkingSpaceOffice =
      "https://cd0d-103-191-218-211.ngrok-free.app/api/v1/offices/type/coworking-space";
  String getMeetingRoomOffice =
      "https://cd0d-103-191-218-211.ngrok-free.app/api/v1/offices/type/meeting-room";
  String getOfficeRoom =
      "https://cd0d-103-191-218-211.ngrok-free.app/api/v1/offices/type/office";
  String getOfficeDataByRecommendation =
      "https://cd0d-103-191-218-211.ngrok-free.app/api/v1/offices/recommendation";

  //get  office by request variable
  String getOfficeBaseUrl =
      "https://cd0d-103-191-218-211.ngrok-free.app/api/v1/offices/";
  String getOfficeDataByCityBaseUrl =
      "https://cd0d-103-191-218-211.ngrok-free.app/api/v1/offices/city/";
  String getOfficeByRatingBaseUrl =
      "https://cd0d-103-191-218-211.ngrok-free.app/api/v1/offices/rate/";
  String getOfficeByTitleBaseUrl =
      "https://cd0d-103-191-218-211.ngrok-free.app/api/v1/offices/title?search=";
  String getNearestOfficeBaseUrl =
      "https://cd0d-103-191-218-211.ngrok-free.app/api/v1/offices/nearest?";

  //Transaction Endpoint
  String createTransactionRecord =
      "https://cd0d-103-191-218-211.ngrok-free.app/api/v1/transactions/details";
  String getAllTransactionByUser =
      "https://cd0d-103-191-218-211.ngrok-free.app/api/v1/transactions";
  String getTransactionDetails =
      "https://cd0d-103-191-218-211.ngrok-free.app/api/v1/transactions/details/";

  //cancel endpoint need o be tampered with transactionId/cancel
  String cancelTransactionByIdBaseUrl =
      "https://cd0d-103-191-218-211.ngrok-free.app/api/v1/transactions/details/";

  //Google maps API key
  String gmapApiKey = 'AIzaSyA1MgLuZuyqR_OGY3ob3M52N46TDBRI_9k';

  //Reviews Endpoint
  String createReview =
      "https://cd0d-103-191-218-211.ngrok-free.app/api/v1/review/details";
  String getAllReviewsByUser =
      "https://cd0d-103-191-218-211.ngrok-free.app/api/v1/review";
  String editReviewsBaseUrl =
      "https://cd0d-103-191-218-211.ngrok-free.app/api/v1/review/details/";
  String getReviewDetailBaseUrl =
      "https://cd0d-103-191-218-211.ngrok-free.app/api/v1/review/details/";
  String getReviewsByOfficeIdBaseUrl =
      "https://cd0d-103-191-218-211.ngrok-free.app/api/v1/review/details/office/";
}
