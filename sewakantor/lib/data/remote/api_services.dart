//do api service here
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:sewakantor/data/model/users/user_models_for_regist.dart';
import 'package:sewakantor/data/remote/constant.dart';
import 'package:sewakantor/src/model/review_model/review_models.dart';
import 'package:sewakantor/src/model/transaction_model/transaction_models.dart';

final NavigationService navService = NavigationService();

class UserService {
  final _dio = Dio();

  UserService() {
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      const secureStorage = FlutterSecureStorage();
      String? accessTokens = await secureStorage.read(key: "access_tokens_bs");
      if (accessTokens != null) {
        options.headers = {"Authorization": "Bearer " + accessTokens};
      }
      return handler.next(options); //continue
    }, onResponse: (response, handler) {
      // Do something with response data
      return handler.next(response); // continue
    }, onError: (DioError e, handler) async {
      const secureStorage = FlutterSecureStorage();
      String? accessTokens = await secureStorage.read(key: "access_tokens_bs");
      print(accessTokens);
      if (accessTokens != null) {
        // _dio.interceptors.requestLock;
        // _dio.interceptors.responseLock;
        if (e.response?.statusCode == 401) {
          print("start refreshing");
          await refreshTokenLoopSafety();
          // _dio.unlock();
          return handler.resolve(await _retry(e.requestOptions));
        } else {
          return handler.next(e);
        }
      } else {
        print("no user detected");
        navService.pushNamedAndRemoveUntil("/firstPage");
      }
    }));
  }

  Future<Response> logoutWithTokensServices(
      {required String accessTokens}) async {
    return _dio.post(
      constantValue().userLogoutWithToken,
      options: Options(headers: {"Authorization": "Bearer $accessTokens"}),
    );
  }

  Future<Response> fetchProfile({required String accessTokens}) async {
    return await _dio.get(constantValue().userGetProfileEndpoint,
        options: Options(headers: {"Authorization": "Bearer " + accessTokens}));
  }

  Future<void> refreshExpiredTokens() async {
    const secureStorage = FlutterSecureStorage();
    String? refreshToken = await secureStorage.read(key: "refresh_token_bs");
    print("refreshtoken : " + refreshToken.toString());

    if (refreshToken != null) {
      try {
        print("try refreshing");
        Response responses = await _dio.post(
          constantValue().userRefreshToken,
          options:
              Options(headers: {"Authorization": "Bearer " + refreshToken}),
        );
        print("retry");
        if (responses.statusCode == 200 || responses.statusCode == 201) {
          print("refreshed");
          await secureStorage.write(
              key: "access_tokens_bs", value: responses.data["access_token"]);
          await secureStorage.write(
              key: "refresh_token_bs", value: responses.data["refresh_token"]);
        }
      } catch (e) {
        print("fail to refresh");
        print(e.toString());
        destroyUserSession();
      }
    } else {
      print("gagal refresh, session destroyed");
      destroyUserSession();
    }
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = new Options(
        method: requestOptions.method, headers: requestOptions.headers);
    return this._dio.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }

  Future<Response> fetchAllOffice({required String accessToken}) async {
    return _dio.get(
      constantValue().getAllOffice,
      options: Options(headers: {"Authorization": "Bearer " + accessToken}),
    );
  }

  Future<Response> fetchOfficeById(
      {required String officeId, required String accessToken}) async {
    return _dio.get(
      constantValue().getOfficeBaseUrl + officeId,
      options: Options(headers: {"Authorization": "Bearer " + accessToken}),
    );
  }

  Future<Response> fetchCoworkingSpace({required String accessToken}) async {
    return _dio.get(
      constantValue().getCoworkingSpaceOffice,
      options: Options(headers: {"Authorization": "Bearer " + accessToken}),
    );
  }

  Future<Response> fetchMeetingRoom({required String accessToken}) async {
    return _dio.get(
      constantValue().getMeetingRoomOffice,
      options: Options(headers: {"Authorization": "Bearer " + accessToken}),
    );
  }

  Future<Response> fetchOfficeRoom({required String accessToken}) async {
    return _dio.get(
      constantValue().getOfficeRoom,
      options: Options(headers: {"Authorization": "Bearer " + accessToken}),
    );
  }

  Future<Response> fetchOfficeByRecommendation(
      {required String accessToken}) async {
    return _dio.get(
      constantValue().getOfficeDataByRecommendation,
      options: Options(headers: {"Authorization": "Bearer " + accessToken}),
    );
  }

  Future<Response> fetchOfficeByCity(
      {required String accessToken, required String cityName}) async {
    return _dio.get(
      constantValue().getOfficeDataByCityBaseUrl + cityName,
      options: Options(headers: {"Authorization": "Bearer " + accessToken}),
    );
  }

  Future<Response> fetchOfficeByRate(
      {required String accessToken, required String officeRate}) async {
    return _dio.get(
      constantValue().getOfficeByRatingBaseUrl + officeRate,
      options: Options(headers: {"Authorization": "Bearer " + accessToken}),
    );
  }

  Future<Response> fetchOfficeByTitle(
      {required String accessToken, required String officeTitle}) async {
    return _dio.get(
      constantValue().getOfficeByTitleBaseUrl + officeTitle,
      options: Options(headers: {"Authorization": "Bearer " + accessToken}),
    );
  }

  Future<Response> fetchNearestOffice(
      {required String accessToken,
      required String formattedLocationRequest}) async {
    return _dio.get(
      constantValue().getNearestOfficeBaseUrl + formattedLocationRequest,
      options: Options(headers: {"Authorization": "Bearer " + accessToken}),
    );
  }

  Future<Response> createTransactionRecordServices(
      CreateTransactionModels formattedTransactionModels,
      String accessToken) async {
    FormData formData = FormData.fromMap({
      "price": formattedTransactionModels.transactionTotalPrice,
      "check_in_hour":
          formattedTransactionModels.transactionBookingTime.checkInHour,
      "check_in_date":
          formattedTransactionModels.transactionBookingTime.checkInDate,
      "duration": formattedTransactionModels.duration,
      "payment_method": formattedTransactionModels.paymentMethodName,
      "drink": formattedTransactionModels.selectedDrink,
      "office_id": formattedTransactionModels.selectedOfficeId,
    });
    print(formData.fields);
    return _dio.post(constantValue().createTransactionRecord,
        options: Options(
            contentType: 'multipart/form-data',
            headers: {"Authorization": "Bearer " + accessToken}),
        data: formData);
  }

  Future<Response> getUserTransactionServices(
      {required String accessToken}) async {
    return _dio.get(
      constantValue().getAllTransactionByUser,
      options: Options(headers: {"Authorization": "Bearer " + accessToken}),
    );
  }

  Future<Response> getUserTransactionDetailByIdServices(
      {required String accessToken, required String requestedID}) async {
    return _dio.get(
      constantValue().getTransactionDetails + requestedID,
      options: Options(headers: {"Authorization": "Bearer " + accessToken}),
    );
  }

  Future<Response> cancelTransaction(
      {required String accessToken,
      required String requestedTransactionId}) async {
    return _dio.put(
        constantValue().cancelTransactionByIdBaseUrl +
            requestedTransactionId +
            "/cancel",
        options: Options(headers: {"Authorization": "Bearer " + accessToken}));
  }

  Future<Response> changeProfileData(
      {required String newName,
      required String newEmail,
      required String newGenders,
      required String accessToken}) async {
    return _dio.put(constantValue().userChangeProfileData,
        data: {
          "full_name": newName,
          "email": newEmail,
          "gender": newGenders,
        },
        options: Options(headers: {"Authorization": "Bearer " + accessToken}));
  }

  Future<Response> setProfilePicture(
      {required String filePath,
      required String fileName,
      required String accessToken}) async {
    var formData = FormData.fromMap(
        {"photo": await MultipartFile.fromFile(fileName, filename: fileName)});
    return _dio.put(
      constantValue().userSetProfilePhoto,
      data: formData,
      options: Options(
          contentType: 'multipart/form-data',
          headers: {"Authorization": "Bearer " + accessToken}),
    );
  }

  Future<Response> deleteUserAccountServices(
      {required String accessToken}) async {
    return _dio.delete(constantValue().userDeleteAccount,
        options: Options(headers: {"Authorization": "Bearer " + accessToken}));
  }

  Future<Response> createOfficeReview(
      {required ReviewModels requestedReviewModel,
      required String accessToken}) async {
    var formData = FormData.fromMap({
      "comment": requestedReviewModel.reviewComment,
      "score": requestedReviewModel.reviewRating,
      "office_id": requestedReviewModel.reviewedOfficeId,
    });
    return _dio.post(
      constantValue().createReview,
      data: formData,
      options: Options(
          contentType: 'multipart/form-data',
          headers: {"Authorization": "Bearer " + accessToken}),
    );
  }

  Future<Response> getAllReviewByUser({required String accessToken}) async {
    return _dio.get(constantValue().getAllReviewsByUser,
        options: Options(headers: {"Authorization": "Bearer " + accessToken}));
  }

  Future<Response> getAllReviewByOffice(
      {required String accessTokens, required String officeId}) {
    return _dio.get(constantValue().getReviewsByOfficeIdBaseUrl + officeId,
        options: Options(headers: {"Authorization": "Bearer " + accessTokens}));
  }

  Future<Response> editOfficeReview(
      {required ReviewModels requestedReviewModel,
      required String accessToken,
      required int requestedReviewId}) async {
    var formData = FormData.fromMap({
      "comment": requestedReviewModel.reviewComment,
      "score": requestedReviewModel.reviewRating,
      "office_id": requestedReviewModel.reviewedOfficeId,
    });
    return _dio.put(
      constantValue().editReviewsBaseUrl + "$requestedReviewId",
      data: formData,
      options: Options(
          contentType: 'multipart/form-data',
          headers: {"Authorization": "Bearer " + accessToken}),
    );
  }
}

class SignService {
  Dio dioClient = Dio();

  Future<Response> loginUser(
      {required String userEmail, required String userPassword, tempo}) async {
    return dioClient.post(
      constantValue().userLoginEndpoint,
      data: {
        "email": userEmail,
        "password": userPassword,
      },
    );
  }

  Future<Response> registerUser({required UserModelForRegist userInfo}) async {
    return dioClient.post(
      constantValue().userRegisterEndpoint,
      data: {
        "full_name": userInfo.full_name,
        "gender": userInfo.gender,
        "email": userInfo.email,
        "password": userInfo.password,
        "confirmation_password": userInfo.confirmation_password
      },
    );
  }
}

Future<void> refreshTokenLoopSafety() async {
  const secureStorage = FlutterSecureStorage();
  String? refreshToken = await secureStorage.read(key: "refresh_token_bs");
  if (refreshToken != null) {
    try {
      Response responses = await Dio().post(
        constantValue().userRefreshToken,
        options: Options(headers: {"Authorization": "Bearer " + refreshToken}),
      );
      print(responses);
      if (responses.statusCode == 200 || responses.statusCode == 201) {
        print("refreshed");
        await secureStorage.write(
            key: "access_tokens_bs", value: responses.data["access_token"]);
        await secureStorage.write(
            key: "refresh_token_bs", value: responses.data["refresh_token"]);
      }
    } catch (e) {
      print("gagal refresh");
      destroyUserSession();
    }
  } else {
    print("ga ada user aktif");
    destroyUserSession();
  }
}

Future<void> destroyUserSession() async {
  const secureStorage = FlutterSecureStorage();
  print("destroying this sessions");
  await secureStorage.deleteAll();
}
