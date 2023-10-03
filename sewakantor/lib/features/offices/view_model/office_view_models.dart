import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sewakantor/core/parsers.dart';
import 'package:sewakantor/data/model/offices/office_dummy_models.dart';
import 'package:sewakantor/data/remote/api_services.dart';
import 'package:sewakantor/utils/enums.dart';

class OfficeViewModels with ChangeNotifier {
  //when isUserExist true OfficeViewModels can contain data, when false all office model data will be destroyed
  bool isUserExist = true;

  //stateOfConnection used for letting loading UI know when it should display loading animation, when to stops
  stateOfConnections connectionState = stateOfConnections.isDoingNothing;

  //office models result from fetchOfficeById
  OfficeModels? _officeModelById;

  OfficeModels? get officeModelById => _officeModelById;

  //List of All ofice models
  List<OfficeModels> _listOfAllOfficeModels = [];

  List<OfficeModels> get listOfAllOfficeModels => _listOfAllOfficeModels;

  //fetch by type//
  //fetch all meeting room type
  List<OfficeModels> _listOfMeetingRoom = [];

  List<OfficeModels> get listOfMeetingRoom => _listOfMeetingRoom;

  //fetch all coworking space type
  List<OfficeModels> _listOfCoworkingSpace = [];

  List<OfficeModels> get listOfCoworkingSpace => _listOfCoworkingSpace;

  //fetch all coworking space type
  List<OfficeModels> _listOfOfficeRoom = [];

  List<OfficeModels> get listOfOfficeRoom => _listOfOfficeRoom;

  //fetch by parameters
  //fetch by recommendation
  List<OfficeModels> _listOfOfficeByRecommendation = [];

  List<OfficeModels> get listOfOfficeByRecommendation =>
      _listOfOfficeByRecommendation;

  //fetch by city
  List<OfficeModels> _listOfOfficeByCity = [];

  List<OfficeModels> get listOfOfficeByCity => _listOfOfficeByCity;

  //fetch by rate
  List<OfficeModels> _listOfOfficeByRate = [];

  List<OfficeModels> get listOfOfficeByRate => _listOfOfficeByRate;

  //fetch by Title
  List<OfficeModels> _listOfOfficeByTitle = [];

  List<OfficeModels> get listOfOfficeByTitle => _listOfOfficeByTitle;

  //fetch by position(nearest)
  List<OfficeModels> _listOfOfficeByNearestPosition = [];

  List<OfficeModels> get listOfOfficeByNearestPosition =>
      _listOfOfficeByNearestPosition;

  fetchAllOffice() async {
    connectionState = stateOfConnections.isStart;
    notifyListeners();
    const secureStorage = FlutterSecureStorage();
    String? accessTokens = await secureStorage.read(key: "access_tokens_bs");
    if (accessTokens != null) {
      connectionState = stateOfConnections.isLoading;
      notifyListeners();
      try {
        Response getResponse =
            await UserService().fetchAllOffice(accessToken: accessTokens);

        if (getResponse.statusCode == 200) {
          print(getResponse.statusCode);
          _listOfAllOfficeModels = officeModelParsers(getResponse.data["data"]);
          notifyListeners();
          isUserExist = true;
          notifyListeners();
          connectionState = stateOfConnections.isReady;
          notifyListeners();
        }
      } catch (e) {
        connectionState = stateOfConnections.isFailed;
        print("error : $e");
        notifyListeners();
      }
    } else {
      connectionState = stateOfConnections.isFailed;
      isUserExist = false;
      notifyListeners();
    }
  }

  fetchOfficeById({required String officeId}) async {
    connectionState = stateOfConnections.isStart;
    notifyListeners();
    const secureStorage = FlutterSecureStorage();
    String? accessTokens = await secureStorage.read(key: "access_tokens_bs");

    //start fetching
    if (accessTokens != null) {
      connectionState = stateOfConnections.isLoading;
      notifyListeners();
      try {
        Response getResponse = await UserService()
            .fetchOfficeById(officeId: officeId, accessToken: accessTokens);

        if (getResponse.statusCode == 200) {
          print(getResponse.statusCode);
          print(getResponse.data["data"]);
          _officeModelById = singleOfficeModelParser(getResponse.data["data"]);
          notifyListeners();
          isUserExist = true;
          notifyListeners();
          connectionState = stateOfConnections.isReady;
          notifyListeners();
        }
      } catch (e) {
        connectionState = stateOfConnections.isFailed;
        print("error : $e");
        notifyListeners();
      }
    } else {
      connectionState = stateOfConnections.isFailed;
      isUserExist = false;
      notifyListeners();
    }
  }

  fetchMeetingRoom() async {
    connectionState = stateOfConnections.isStart;
    notifyListeners();
    const secureStorage = FlutterSecureStorage();
    String? accessTokens = await secureStorage.read(key: "access_tokens_bs");
    if (accessTokens != null) {
      connectionState = stateOfConnections.isLoading;
      notifyListeners();
      try {
        Response getResponse =
            await UserService().fetchMeetingRoom(accessToken: accessTokens);

        if (getResponse.statusCode == 200) {
          print(getResponse);
          _listOfMeetingRoom = officeModelParsers(getResponse.data["data"]);
          notifyListeners();
          isUserExist = true;
          notifyListeners();
          connectionState = stateOfConnections.isReady;
          notifyListeners();
        }
      } catch (e) {
        connectionState = stateOfConnections.isFailed;
        print("error : $e");
        notifyListeners();
      }
    } else {
      connectionState = stateOfConnections.isFailed;
      isUserExist = false;
      notifyListeners();
    }
  }

  fetchCoworkingSpace() async {
    connectionState = stateOfConnections.isStart;
    notifyListeners();
    const secureStorage = FlutterSecureStorage();
    String? accessTokens = await secureStorage.read(key: "access_tokens_bs");
    if (accessTokens != null) {
      connectionState = stateOfConnections.isLoading;
      notifyListeners();
      try {
        Response getResponse =
            await UserService().fetchCoworkingSpace(accessToken: accessTokens);

        if (getResponse.statusCode == 200) {
          print(getResponse);
          _listOfCoworkingSpace = officeModelParsers(getResponse.data["data"]);
          notifyListeners();
          isUserExist = true;
          notifyListeners();
          connectionState = stateOfConnections.isReady;
          notifyListeners();
        }
      } catch (e) {
        connectionState = stateOfConnections.isFailed;
        print("error : $e");
        notifyListeners();
      }
    } else {
      connectionState = stateOfConnections.isFailed;
      isUserExist = false;
      notifyListeners();
    }
  }

  fetchOfficeRoom() async {
    connectionState = stateOfConnections.isStart;
    notifyListeners();
    const secureStorage = FlutterSecureStorage();
    String? accessTokens = await secureStorage.read(key: "access_tokens_bs");
    if (accessTokens != null) {
      connectionState = stateOfConnections.isLoading;
      notifyListeners();
      try {
        Response getResponse =
            await UserService().fetchOfficeRoom(accessToken: accessTokens);

        if (getResponse.statusCode == 200) {
          print(getResponse);
          _listOfOfficeRoom = officeModelParsers(getResponse.data["data"]);
          notifyListeners();
          isUserExist = true;
          notifyListeners();
          connectionState = stateOfConnections.isReady;
          notifyListeners();
        }
      } catch (e) {
        connectionState = stateOfConnections.isFailed;
        print("error : $e");
        notifyListeners();
      }
    } else {
      connectionState = stateOfConnections.isFailed;
      isUserExist = false;
      notifyListeners();
    }
  }

  fetchOfficeByRecommendation() async {
    connectionState = stateOfConnections.isStart;
    notifyListeners();
    const secureStorage = FlutterSecureStorage();
    String? accessTokens = await secureStorage.read(key: "access_tokens_bs");
    if (accessTokens != null) {
      connectionState = stateOfConnections.isLoading;
      notifyListeners();
      try {
        Response getResponse = await UserService()
            .fetchOfficeByRecommendation(accessToken: accessTokens);

        if (getResponse.statusCode == 200) {
          print(getResponse.statusCode);
          _listOfOfficeByRecommendation =
              officeModelParsers(getResponse.data["data"]);
          notifyListeners();
          isUserExist = true;
          notifyListeners();
          connectionState = stateOfConnections.isReady;
          notifyListeners();
        }
      } catch (e) {
        connectionState = stateOfConnections.isFailed;
        print("error : $e");
        notifyListeners();
      }
    } else {
      connectionState = stateOfConnections.isFailed;
      isUserExist = false;
      notifyListeners();
    }
  }

  fetchOfficeByCity({required String city}) async {
    connectionState = stateOfConnections.isStart;
    notifyListeners();
    const secureStorage = FlutterSecureStorage();
    String? accessTokens = await secureStorage.read(key: "access_tokens_bs");
    if (accessTokens != null) {
      connectionState = stateOfConnections.isLoading;
      notifyListeners();
      try {
        Response getResponse = await UserService()
            .fetchOfficeByCity(accessToken: accessTokens, cityName: city);

        if (getResponse.statusCode == 200) {
          print(getResponse);
          _listOfOfficeByCity = officeModelParsers(getResponse.data["data"]);
          notifyListeners();
          isUserExist = true;
          notifyListeners();
          connectionState = stateOfConnections.isReady;
          notifyListeners();
        }
      } catch (e) {
        connectionState = stateOfConnections.isFailed;
        print("error : $e");
        notifyListeners();
      }
    } else {
      connectionState = stateOfConnections.isFailed;
      isUserExist = false;
      notifyListeners();
    }
  }

  fetchOfficeByRating({required String requestedRating}) async {
    connectionState = stateOfConnections.isStart;
    notifyListeners();
    const secureStorage = FlutterSecureStorage();
    String? accessTokens = await secureStorage.read(key: "access_tokens_bs");
    if (accessTokens != null) {
      connectionState = stateOfConnections.isLoading;
      notifyListeners();
      try {
        Response getResponse = await UserService().fetchOfficeByRate(
            accessToken: accessTokens, officeRate: requestedRating);

        if (getResponse.statusCode == 200) {
          print(getResponse.statusCode);
          _listOfOfficeByRate = officeModelParsers(getResponse.data["data"]);
          notifyListeners();
          isUserExist = true;
          notifyListeners();
          connectionState = stateOfConnections.isReady;
          notifyListeners();
        }
      } catch (e) {
        connectionState = stateOfConnections.isFailed;
        print("error : $e");
        notifyListeners();
      }
    } else {
      connectionState = stateOfConnections.isFailed;
      isUserExist = false;
      notifyListeners();
    }
  }

  fetchOfficeByOfficeTitle({required requestedOfficeTitle}) async {
    connectionState = stateOfConnections.isStart;
    notifyListeners();
    const secureStorage = FlutterSecureStorage();
    String? accessTokens = await secureStorage.read(key: "access_tokens_bs");
    if (accessTokens != null) {
      connectionState = stateOfConnections.isLoading;
      notifyListeners();
      try {
        Response getResponse = await UserService().fetchOfficeByTitle(
            accessToken: accessTokens, officeTitle: requestedOfficeTitle);

        if (getResponse.statusCode == 200) {
          print(getResponse.statusCode);
          _listOfOfficeByTitle = officeModelParsers(getResponse.data["data"]);
          notifyListeners();
          isUserExist = true;
          notifyListeners();
          connectionState = stateOfConnections.isReady;
          notifyListeners();
        }
      } catch (e) {
        connectionState = stateOfConnections.isFailed;
        print("error : $e");
        notifyListeners();
      }
    } else {
      connectionState = stateOfConnections.isFailed;
      isUserExist = false;
      notifyListeners();
    }
  }

  fetchNearestOffice(
      {required String latitudes, required String longitudes}) async {
    connectionState = stateOfConnections.isStart;
    notifyListeners();
    const secureStorage = FlutterSecureStorage();
    String? accessTokens = await secureStorage.read(key: "access_tokens_bs");
    if (accessTokens != null) {
      connectionState = stateOfConnections.isLoading;
      notifyListeners();
      try {
        Response getResponse = await UserService().fetchNearestOffice(
            accessToken: accessTokens,
            formattedLocationRequest: positionRequestFormatter(
                latitude: latitudes, longitude: longitudes));

        if (getResponse.statusCode == 200) {
          print(getResponse.statusCode);
          _listOfOfficeByNearestPosition =
              officeModelParsers(getResponse.data["data"]);
          notifyListeners();
          isUserExist = true;
          notifyListeners();
          connectionState = stateOfConnections.isReady;
          notifyListeners();
        }
      } catch (e) {
        connectionState = stateOfConnections.isFailed;
        print("error : $e");
        notifyListeners();
      }
    } else {
      connectionState = stateOfConnections.isFailed;
      isUserExist = false;
      notifyListeners();
    }
  }

  destroyDataWhenlogout() async {
    final _secureStorage = FlutterSecureStorage();
    String? _accessTokens = await _secureStorage.read(key: "access_tokens_bs");
    if (_accessTokens != null) {
      print("not destroyed");
      print(_accessTokens);
      return;
    } else {
      print("destroyed");
      isUserExist = false;
      notifyListeners();
      _listOfAllOfficeModels = [];
      _officeModelById = null;
      _listOfCoworkingSpace = [];
      _listOfMeetingRoom = [];
      _listOfOfficeByCity = [];
      _listOfOfficeByNearestPosition = [];
      _listOfOfficeByRate = [];
      _listOfOfficeByRecommendation = [];
      _listOfOfficeByTitle = [];
      _listOfOfficeRoom = [];
      notifyListeners();
    }
  }
}
