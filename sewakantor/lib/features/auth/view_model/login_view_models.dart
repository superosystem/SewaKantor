import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:sewakantor/core/parsers.dart';
import 'package:sewakantor/data/model/users/user_models.dart';
import 'package:sewakantor/data/remote/api_services.dart';
import 'package:sewakantor/utils/enums.dart';
import 'package:sewakantor/widgets/dialog/custom_dialog.dart';

final NavigationService navService = NavigationService();

class LoginViewModels with ChangeNotifier {
  UserModel? userModels;
  UserToken? userTokens;
  bool isUserExist = false;
  String statusConnection = "-";
  String logoutStatusCode = "-";
  stateOfConnections apiLoginState = stateOfConnections.isDoingNothing;
  stateOfConnections apiProfileState = stateOfConnections.isDoingNothing;
  stateOfConnections apiLogoutState = stateOfConnections.isDoingNothing;
  stateOfConnections profileSetterConnectionState =
      stateOfConnections.isDoingNothing;
  var _dio = Dio();

  File? _imageProfile;

  File? get imageProfile => _imageProfile;

  late String pathImage;

  Future<void> pickImageProfile(
      context, String title, Function()? onPressed) async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? pickImageProfile = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 55,
    );
    _imageProfile = File(pickImageProfile!.path);

    // pathImage = Uuid().v1();
    pathImage = _imageProfile!.path;

    notifyListeners();
    CustomDialog.singleActionDialog(
        onPressed: onPressed,
        // Provider.of<NavigasiViewModel>(context, listen: false)
        // .navigasiPop(context),
        context: context,
        title: title,
        imageAsset: 'assets/svg_assets/check_list.svg');
  }

  logoutWithTokens() async {
    final _secureStorage = FlutterSecureStorage();
    String? accessTokens = await _secureStorage.read(key: "access_tokens_bs");
    apiLogoutState = stateOfConnections.isStart;
    notifyListeners();
    if (accessTokens != null) {
      try {
        apiLogoutState = stateOfConnections.isLoading;
        notifyListeners();
        Response logoutResponse = await UserService()
            .logoutWithTokensServices(accessTokens: accessTokens);
        apiLogoutState = stateOfConnections.isReady;
        notifyListeners();
        if (logoutResponse.statusCode == 200) {
          logoutStatusCode = logoutResponse.statusCode.toString();
          notifyListeners();
          destroyActiveUser(_secureStorage);
          print(logoutResponse.statusCode.toString() + "success status");
        }
      } catch (e) {
        print("error : $e");
        logoutStatusCode = e.toString();

        apiLogoutState = stateOfConnections.isFailed;
        notifyListeners();
      }
    }
    notifyListeners();
  }

  loginGetToken({required userEmail, required userPassword}) async {
    const secureStorage = FlutterSecureStorage();
    apiLoginState = stateOfConnections.isStart;
    notifyListeners();
    try {
      apiLoginState = stateOfConnections.isLoading;
      notifyListeners();
      Response responses = await SignService()
          .loginUser(userEmail: userEmail, userPassword: userPassword);
      print("success login" + "$responses");

      if (responses.statusCode == 200) {
        if (responses.data["access_token"] != null) {
          userTokens = UserToken.fromJson(responses.data);
          await secureStorage.write(
              key: "access_tokens_bs", value: responses.data["access_token"]);
          await secureStorage.write(
              key: "refresh_token_bs", value: responses.data["refresh_token"]);
        }
      }
      await validateTokenIsExist();
    } catch (e) {
      statusConnection = e.toString();
      print("error on" + '$e');
    }
    notifyListeners();
  }

  validateTokenIsExist() async {
    const secureStorage = FlutterSecureStorage();
    String? accessTokens = await secureStorage.read(key: "access_tokens_bs");
    String? refreshTokens = await secureStorage.read(key: "refresh_token_bs");
    print("check user session");

    if (accessTokens != null && refreshTokens != null) {
      userTokens =
          UserToken(accessToken: accessTokens, refreshToken: refreshTokens);
      isUserExist = true;
      print("the user token is : $accessTokens");
      apiLoginState = stateOfConnections.isReady;
      notifyListeners();
      print("hehe");
    } else {
      isUserExist == false;

      print("no user session exist");
    }
    notifyListeners();
  }

  getProfile() async {
    apiProfileState = stateOfConnections.isStart;
    notifyListeners();
    const secureStorage = FlutterSecureStorage();
    String? accessTokens = await secureStorage.read(key: "access_tokens_bs");
    String? refreshTokens = await secureStorage.read(key: "refresh_token_bs");
    if (accessTokens != null) {
      apiProfileState = stateOfConnections.isLoading;
      notifyListeners();
      try {
        Response profResponse =
            await UserService().fetchProfile(accessTokens: accessTokens);
        print("fetch pertama : ${profResponse.statusCode}");

        if (profResponse.statusCode == 200) {
          apiProfileState = stateOfConnections.isReady;
          notifyListeners();
          userModels = userModelParser(
              profResponse.data,
              UserToken(
                  accessToken: accessTokens, refreshToken: refreshTokens));
          print(profResponse.data["data"]['email'] + "fetch success");
        }
      } catch (e) {
        apiProfileState = stateOfConnections.isFailed;
        notifyListeners();
        print("error: $e");
      }
    } else {
      apiProfileState = stateOfConnections.isFailed;
      notifyListeners();
      print("no active user");
    }
    notifyListeners();
  }

  setUserProfilePicture(
      {required String filePath, required String fileName}) async {
    profileSetterConnectionState = stateOfConnections.isStart;
    notifyListeners();
    const secureStorage = FlutterSecureStorage();
    String? accessTokens = await secureStorage.read(key: "access_tokens_bs");
    if (accessTokens != null) {
      print("user exist : $accessTokens");
      profileSetterConnectionState = stateOfConnections.isLoading;
      notifyListeners();

      Response response = await UserService().setProfilePicture(
          filePath: filePath, fileName: fileName, accessToken: accessTokens);
    }
  }

  deleteUserAccount() async {
    apiProfileState = stateOfConnections.isStart;
    notifyListeners();
    const secureStorage = FlutterSecureStorage();
    String? accessTokens = await secureStorage.read(key: "access_tokens_bs");
    if (accessTokens != null) {
      print("user exist : $accessTokens");
      apiProfileState = stateOfConnections.isLoading;
      notifyListeners();
      try {
        Response response = await UserService()
            .deleteUserAccountServices(accessToken: accessTokens);
        print(response);
        if (response.statusCode == 200 || response.statusCode == 201) {
          destroyActiveUser(secureStorage);
          apiProfileState = stateOfConnections.isReady;
        }
      } on DioError catch (e) {
        print("error : " + e.toString());
      }
    } else {
      apiProfileState = stateOfConnections.isFailed;
      notifyListeners();
      print("no active user");
    }
  }

  updateProfileData(
      {String? newName,
      String? newEmail,
      String? newGenders,
      required UserModel currentUserModels}) async {
    profileSetterConnectionState = stateOfConnections.isStart;
    notifyListeners();
    const secureStorage = FlutterSecureStorage();
    String? accessTokens = await secureStorage.read(key: "access_tokens_bs");
    if (accessTokens != null) {
      print("user exist : $accessTokens");
      profileSetterConnectionState = stateOfConnections.isLoading;
      notifyListeners();
      try {
        Response response = await UserService().changeProfileData(
            newName: newName ?? currentUserModels.userProfileDetails.userName,
            newEmail: newEmail ?? currentUserModels.userEmail,
            newGenders:
                newGenders ?? currentUserModels.userProfileDetails.userGender,
            accessToken: accessTokens);
        print(response);
        profileSetterConnectionState = stateOfConnections.isReady;
        notifyListeners();
      } catch (e) {
        profileSetterConnectionState = stateOfConnections.isFailed;
        notifyListeners();
        print("eror update data use : $e");
      }
    } else {
      profileSetterConnectionState = stateOfConnections.isFailed;
      notifyListeners();
      print("no active user");
    }
  }

  destroyActiveUser(FlutterSecureStorage flutterStorage) async {
    await flutterStorage.deleteAll();
    userTokens = null;
    isUserExist = false;
    userModels = null;
    notifyListeners();
    navService.pushNamedAndRemoveUntil("/firstPage");
  }

  resetLoginConnectionState() {
    apiLoginState = stateOfConnections.isDoingNothing;
    notifyListeners();
  }

  resetProfileFetchConnectionState() {
    apiProfileState = stateOfConnections.isDoingNothing;
    notifyListeners();
  }
}
