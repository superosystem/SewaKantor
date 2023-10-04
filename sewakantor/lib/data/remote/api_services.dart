//do api service here
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:sewakantor/data/model/users/user_models_for_regist.dart';
import 'package:sewakantor/data/remote/constant.dart';
import 'package:sewakantor/data/model/reviews/review_models.dart';
import 'package:sewakantor/data/model/transactions/transactions_models.dart';

final NavigationService navService = NavigationService();

class UserService {
  final _dio = Dio();

  UserService() {
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      const secureStorage = FlutterSecureStorage();
      String? accessTokens = await secureStorage.read(key: "access_tokens_bs");
      if (accessTokens != null) {
        options.headers = {"Authorization": "Bearer $accessTokens"};
      }
      return handler.next(options); //continue
    }, onResponse: (response, handler) {
      // Do something with response data
      return handler.next(response); // continue
    }, onError: (DioError e, handler) async {
      const secureStorage = FlutterSecureStorage();
      String? accessTokens = await secureStorage.read(key: "access_tokens_bs");
      if (kDebugMode) {
        print(accessTokens);
      }
      if (accessTokens != null) {
        // _dio.interceptors.requestLock;
        // _dio.interceptors.responseLock;
        if (e.response?.statusCode == 401) {
          if (kDebugMode) {
            print("start refreshing");
          }
          await refreshTokenLoopSafety();
          // _dio.unlock();
          return handler.resolve(await _retry(e.requestOptions));
        } else {
          return handler.next(e);
        }
      } else {
        if (kDebugMode) {
          print("no user detected");
        }
        navService.pushNamedAndRemoveUntil("/firstPage");
      }
    }));
  }

  Future<Response> logoutWithTokensServices(
      {required String accessTokens}) async {
    return _dio.post(
      "${constantValue().serverUrl}logout",
      options: Options(headers: {"Authorization": "Bearer $accessTokens"}),
    );
  }

  Future<Response> fetchProfile({required String accessTokens}) async {
    return await _dio.get("${constantValue().serverUrl}profile",
        options: Options(headers: {"Authorization": "Bearer $accessTokens"}));
  }

  Future<void> refreshExpiredTokens() async {
    const secureStorage = FlutterSecureStorage();
    String? refreshToken = await secureStorage.read(key: "refresh_token_bs");
    if (kDebugMode) {
      print("refreshtoken : $refreshToken");
    }

    if (refreshToken != null) {
      try {
        if (kDebugMode) {
          print("try refreshing");
        }
        Response responses = await _dio.post(
          "${constantValue().serverUrl}refresh",
          options:
              Options(headers: {"Authorization": "Bearer $refreshToken"}),
        );
        if (kDebugMode) {
          print("retry");
        }
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
      "${constantValue().serverUrl}offices/all",
      options: Options(headers: {"Authorization": "Bearer " + accessToken}),
    );
  }

  Future<Response> fetchOfficeById(
      {required String officeId, required String accessToken}) async {
    return _dio.get(
      "${constantValue().serverUrl}offices/$officeId",
      options: Options(headers: {"Authorization": "Bearer " + accessToken}),
    );
  }

  Future<Response> fetchCoworkingSpace({required String accessToken}) async {
    return _dio.get(
      "${constantValue().serverUrl}offices/type/coworking-space",
      options: Options(headers: {"Authorization": "Bearer " + accessToken}),
    );
  }

  Future<Response> fetchMeetingRoom({required String accessToken}) async {
    return _dio.get(
      "${constantValue().serverUrl}offices/type/meeting-room",
      options: Options(headers: {"Authorization": "Bearer " + accessToken}),
    );
  }

  Future<Response> fetchOfficeRoom({required String accessToken}) async {
    return _dio.get(
      "${constantValue().serverUrl}offices/type/office",
      options: Options(headers: {"Authorization": "Bearer " + accessToken}),
    );
  }

  Future<Response> fetchOfficeByRecommendation(
      {required String accessToken}) async {
    return _dio.get(
      "${constantValue().serverUrl}offices/recommendation",
      options: Options(headers: {"Authorization": "Bearer " + accessToken}),
    );
  }

  Future<Response> fetchOfficeByCity(
      {required String accessToken, required String cityName}) async {
    return _dio.get(
      "${constantValue().serverUrl}offices/city/$cityName",
      options: Options(headers: {"Authorization": "Bearer " + accessToken}),
    );
  }

  Future<Response> fetchOfficeByRate(
      {required String accessToken, required String officeRate}) async {
    return _dio.get(
      "${constantValue().serverUrl}offices/rate/$officeRate",
      options: Options(headers: {"Authorization": "Bearer " + accessToken}),
    );
  }

  Future<Response> fetchOfficeByTitle(
      {required String accessToken, required String officeTitle}) async {
    return _dio.get(
      "${constantValue().serverUrl}offices/title?search=$officeTitle",
      options: Options(headers: {"Authorization": "Bearer " + accessToken}),
    );
  }

  Future<Response> fetchNearestOffice(
      {required String accessToken,
      required String formattedLocationRequest}) async {
    return _dio.get(
      "${constantValue().serverUrl}offices/nearest?$formattedLocationRequest",
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
    return _dio.post("${constantValue().serverUrl}transactions/details",
        options: Options(
            contentType: 'multipart/form-data',
            headers: {"Authorization": "Bearer " + accessToken}),
        data: formData);
  }

  Future<Response> getUserTransactionServices(
      {required String accessToken}) async {
    return _dio.get(
      "${constantValue().serverUrl}transactions",
      options: Options(headers: {"Authorization": "Bearer " + accessToken}),
    );
  }

  Future<Response> getUserTransactionDetailByIdServices(
      {required String accessToken, required String requestedID}) async {
    return _dio.get(
      "${constantValue().serverUrl}transaction/details/$requestedID",
      options: Options(headers: {"Authorization": "Bearer " + accessToken}),
    );
  }

  Future<Response> cancelTransaction(
      {required String accessToken,
      required String requestedTransactionId}) async {
    return _dio.put(
        "${constantValue().serverUrl}transactions/details$requestedTransactionId/cancel",
        options: Options(headers: {"Authorization": "Bearer " + accessToken}));
  }

  Future<Response> changeProfileData(
      {required String newName,
      required String newEmail,
      required String newGenders,
      required String accessToken}) async {
    return _dio.put("${constantValue().serverUrl}profile",
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
      "${constantValue().serverUrl}profile/photo",
      data: formData,
      options: Options(
          contentType: 'multipart/form-data',
          headers: {"Authorization": "Bearer " + accessToken}),
    );
  }

  Future<Response> deleteUserAccountServices(
      {required String accessToken}) async {
    return _dio.delete("${constantValue().serverUrl}profile",
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
      "${constantValue().serverUrl}review/details",
      data: formData,
      options: Options(
          contentType: 'multipart/form-data',
          headers: {"Authorization": "Bearer " + accessToken}),
    );
  }

  Future<Response> getAllReviewByUser({required String accessToken}) async {
    return _dio.get("${constantValue().serverUrl}review",
        options: Options(headers: {"Authorization": "Bearer " + accessToken}));
  }

  Future<Response> getAllReviewByOffice(
      {required String accessTokens, required String officeId}) {
    return _dio.get(
        "${constantValue().serverUrl}review/details/office/$officeId",
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
      "${constantValue().serverUrl}review/details/$requestedReviewId",
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
      "${constantValue().serverUrl}login",
      data: {
        "email": userEmail,
        "password": userPassword,
      },
    );
  }

  Future<Response> registerUser({required UserModelForRegist userInfo}) async {
    return dioClient.post(
      "${constantValue().serverUrl}register",
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
        "${constantValue().serverUrl}refresh",
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
