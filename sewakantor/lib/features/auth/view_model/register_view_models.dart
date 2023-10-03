import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:sewakantor/data/model/users/user_models_for_regist.dart';
import 'package:sewakantor/data/remote/api_services.dart';
import 'package:sewakantor/utils/enums.dart';

class RegisterViewModels with ChangeNotifier {
  int statusCodeRegister = 0;
  Response? retrievedResponses;
  stateOfConnections connectionsState = stateOfConnections.isDoingNothing;

  createUser({required UserModelForRegist userInfo}) async {
    connectionsState = stateOfConnections.isStart;
    notifyListeners();
    try {
      connectionsState = stateOfConnections.isLoading;
      notifyListeners();
      Response responses = await SignService().registerUser(userInfo: userInfo);
      if (responses.statusCode == 200 || responses.statusCode == 201) {
        statusCodeRegister = responses.statusCode!;
        ;
        print('User created: ${responses.data}');
        retrievedResponses = responses;
        connectionsState = stateOfConnections.isReady;
        notifyListeners();
      } else if (responses.statusCode == 400) {
        connectionsState = stateOfConnections.isFailed;
        statusCodeRegister = 400;
        retrievedResponses = responses;
        notifyListeners();
      } else {
        connectionsState = stateOfConnections.isFailed;
        statusCodeRegister = responses.statusCode!;
        retrievedResponses = responses;
        notifyListeners();
      }
      connectionsState = stateOfConnections.isReady;
      notifyListeners();
    } catch (e) {
      connectionsState = stateOfConnections.isFailed;
      statusCodeRegister = 400;
      print('Error creating user: $e');
      notifyListeners();
    }
  }
}
