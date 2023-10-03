import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sewakantor/core/parsers.dart';
import 'package:sewakantor/data/remote/api_services.dart';
import 'package:sewakantor/src/model/review_model/review_models.dart';
import 'package:sewakantor/utils/enums.dart';

class ReviewViewModels with ChangeNotifier {
  stateOfConnections connectionState = stateOfConnections.isDoingNothing;

  List<ReviewModels> _listOfReviewByUser = [];

  List<ReviewModels> get listOfReviewUser => _listOfReviewByUser;

  List<ReviewModels> _listOfReviewByOffice = [];

  List<ReviewModels> get listOfReviewOffice => _listOfReviewByOffice;

  createOfficeReviews(
      {required String reviewComment,
      required double rating,
      required int officeId}) async {
    connectionState = stateOfConnections.isStart;
    notifyListeners();
    const secureStorage = FlutterSecureStorage();
    String? accessTokens = await secureStorage.read(key: "access_tokens_bs");
    if (accessTokens != null) {
      print("user exist : $accessTokens");
      connectionState = stateOfConnections.isLoading;
      notifyListeners();
      try {
        Response response = await UserService().createOfficeReview(
            requestedReviewModel: ReviewModels(
                reviewComment: reviewComment,
                reviewRating: rating,
                reviewedOfficeId: officeId),
            accessToken: accessTokens);
        print(response);
        connectionState = stateOfConnections.isReady;
        notifyListeners();
      } catch (e) {
        connectionState = stateOfConnections.isFailed;
        notifyListeners();
        print(e.toString());
      }
    } else {
      connectionState = stateOfConnections.isFailed;
      notifyListeners();
    }
  }

  getReviewByUser() async {
    connectionState = stateOfConnections.isStart;
    notifyListeners();
    const secureStorage = FlutterSecureStorage();
    String? accessTokens = await secureStorage.read(key: "access_tokens_bs");
    if (accessTokens != null) {
      print("user exist : $accessTokens");
      connectionState = stateOfConnections.isLoading;
      notifyListeners();
      try {
        Response response =
            await UserService().getAllReviewByUser(accessToken: accessTokens);
        _listOfReviewByUser =
            listOfReviewModelParser(listOfResponse: response.data["data"]);
        notifyListeners();
        connectionState = stateOfConnections.isReady;
        notifyListeners();
        print(_listOfReviewByUser);
      } catch (e) {
        print(e.toString());
      }
    } else {
      connectionState = stateOfConnections.isFailed;
      notifyListeners();
    }
  }

  getReviewByOffice({required String officeId}) async {
    connectionState = stateOfConnections.isStart;
    notifyListeners();
    const secureStorage = FlutterSecureStorage();
    String? accessTokens = await secureStorage.read(key: "access_tokens_bs");
    if (accessTokens != null) {
      print("user exist : $accessTokens");
      connectionState = stateOfConnections.isLoading;
      notifyListeners();
      try {
        Response response = await UserService().getAllReviewByOffice(
            accessTokens: accessTokens, officeId: officeId);

        _listOfReviewByOffice =
            listOfReviewModelParser(listOfResponse: response.data["data"]);
        notifyListeners();
        connectionState = stateOfConnections.isReady;
        notifyListeners();
        print(_listOfReviewByOffice);
      } catch (e) {
        print(e.toString());
      }
    } else {
      connectionState = stateOfConnections.isFailed;
      notifyListeners();
    }
  }

  editOfficeReviews(
      {required int reviewId,
      required ReviewModels currentReviewModel,
      String? newComment,
      double? newRating,
      int? newOfficeId}) async {
    connectionState = stateOfConnections.isStart;
    notifyListeners();
    const secureStorage = FlutterSecureStorage();
    String? accessTokens = await secureStorage.read(key: "access_tokens_bs");
    if (accessTokens != null) {
      print("user exist : $accessTokens");
      connectionState = stateOfConnections.isLoading;
      notifyListeners();
      try {
        Response response = await UserService().editOfficeReview(
            requestedReviewModel: ReviewModels(
                reviewComment: newComment ?? currentReviewModel.reviewComment,
                reviewRating: newRating ?? currentReviewModel.reviewRating,
                reviewedOfficeId:
                    newOfficeId ?? currentReviewModel.reviewedOfficeId),
            accessToken: accessTokens,
            requestedReviewId: reviewId);
        print(response);
        connectionState = stateOfConnections.isReady;
        notifyListeners();
      } catch (e) {
        connectionState = stateOfConnections.isFailed;
        notifyListeners();
        print(e.toString());
      }
    } else {
      connectionState = stateOfConnections.isFailed;
      notifyListeners();
    }
  }
}
