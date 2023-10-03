import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sewakantor/core/parsers.dart';
import 'package:sewakantor/data/model/offices/office_dummy_models.dart';
import 'package:sewakantor/data/model/users/user_models.dart';
import 'package:sewakantor/data/remote/api_services.dart';
import 'package:sewakantor/src/model/transaction_model/transaction_models.dart';
import 'package:sewakantor/utils/enums.dart';

class TransactionViewModels with ChangeNotifier {
  String connectionStatus = "nothing";
  stateOfConnections connectionState = stateOfConnections.isDoingNothing;
  List<UserTransaction> _allTransaction = [];

  List<UserTransaction> get allTransaction => _allTransaction;
  UserTransaction? singleUserTransaction;

  createTransactionRecords(
      {required CreateTransactionModels requestedModels}) async {
    connectionState = stateOfConnections.isStart;
    notifyListeners();
    const secureStorage = FlutterSecureStorage();
    String? accessTokens = await secureStorage.read(key: "access_tokens_bs");
    if (accessTokens != null) {
      connectionState = stateOfConnections.isLoading;
      notifyListeners();
      print("user exist : $accessTokens");
      try {
        Response createResponse = await UserService()
            .createTransactionRecordServices(requestedModels, accessTokens);
        if (createResponse.statusCode == 200 ||
            createResponse.statusCode == 201) {
          print(createResponse.toString());
          connectionState = stateOfConnections.isReady;
          notifyListeners();
        }
      } catch (e) {
        connectionState = stateOfConnections.isFailed;
        notifyListeners();
        print("fail to make record : $e");
      }
    } else {
      connectionState = stateOfConnections.isDoingNothing;
      notifyListeners();
      print("no session exist");
    }
  }

  getTransactionByUser(
      {required UserModel userModels,
      required List<OfficeModels> ListOfAllOffice}) async {
    connectionState = stateOfConnections.isStart;
    notifyListeners();
    const secureStorage = FlutterSecureStorage();
    String? accessTokens = await secureStorage.read(key: "access_tokens_bs");
    if (accessTokens != null) {
      print("user exist : $accessTokens");
      connectionState = stateOfConnections.isLoading;
      notifyListeners();
      try {
        Response response = await UserService()
            .getUserTransactionServices(accessToken: accessTokens);
        _allTransaction = listedUserTransactionParser(
            requestedResponses: response.data["data"],
            requestedUserModel: userModels,
            listOfOfficeModels: ListOfAllOffice);
        notifyListeners();

        print(_allTransaction[1].bookingId.toString() +
            _allTransaction[1].Status);
        connectionState = stateOfConnections.isReady;
        notifyListeners();
      } catch (e) {
        connectionState = stateOfConnections.isFailed;
        notifyListeners();
        print("error get transaction data by user : $e");
      }
    } else {
      connectionState = stateOfConnections.isFailed;
      notifyListeners();
    }
  }

  getTransactionDetail(
      {required UserModel userModels,
      required List<OfficeModels> ListOfAllOffice,
      required String requestedId}) async {
    connectionState = stateOfConnections.isStart;
    notifyListeners();
    const secureStorage = FlutterSecureStorage();
    String? accessTokens = await secureStorage.read(key: "access_tokens_bs");
    if (accessTokens != null) {
      print("user exist : $accessTokens");
      connectionState = stateOfConnections.isLoading;
      notifyListeners();
      try {
        Response response = await UserService()
            .getUserTransactionDetailByIdServices(
                accessToken: accessTokens, requestedID: requestedId);
        print(response);
        singleUserTransaction = userTransactionParsers(
            jsonResponse: response.data["data"],
            requestedUserModel: userModels,
            listOfficeModels: ListOfAllOffice);
        notifyListeners();

        print(singleUserTransaction?.bookingId);
        connectionState = stateOfConnections.isReady;
        notifyListeners();
      } catch (e) {
        connectionState = stateOfConnections.isFailed;
        notifyListeners();
        print("error get transaction data by user : $e");
      }
    } else {
      connectionState = stateOfConnections.isFailed;
      notifyListeners();
    }
  }

  cancelUserTransactions({required String TransactionID}) async {
    connectionState = stateOfConnections.isStart;
    notifyListeners();
    const secureStorage = FlutterSecureStorage();
    String? accessTokens = await secureStorage.read(key: "access_tokens_bs");
    if (accessTokens != null) {
      print("user exist : $accessTokens");
      connectionState = stateOfConnections.isLoading;
      notifyListeners();
      try {
        Response response = await UserService().cancelTransaction(
            accessToken: accessTokens, requestedTransactionId: TransactionID);
        print("canceled" + response.toString());
        notifyListeners();
        connectionState = stateOfConnections.isReady;
        notifyListeners();
      } on DioError catch (e) {
        connectionState = stateOfConnections.isFailed;
        notifyListeners();
        print("error cancel transaction data by user : $e");
      }
    } else {
      connectionState = stateOfConnections.isFailed;
      notifyListeners();
    }
  }
}
