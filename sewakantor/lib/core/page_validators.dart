import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sewakantor/features/navigation/view_model/navigasi_view_model.dart';
import 'package:sewakantor/utils/enums.dart';
import 'package:sewakantor/widgets/dialog/response_dialog.dart';

nextScreen(bool isUserExist, BuildContext context) {
  if (isUserExist == true) {
    ResponseDialog.dialogLoginSuccess(
        context: context,
        title: 'Success Login',
        description:
            'You have successfully login. Let\'s find a comfortable workplace to work');
    Future.delayed(const Duration(milliseconds: 2500), () {
      Provider.of<NavigasiViewModel>(context, listen: false)
          .navigasiToMenuScreen(context);
    });
  } else {
    ResponseDialog.dialogFailed(
        context: context,
        title: 'Invalid Login',
        description: 'Please double check email and password you entered');
    // const snackbars =
    //     SnackBar(content: Text("login gagal, cek email dan password anda"));
    // ScaffoldMessenger.of(context).showSnackBar(snackbars);
    return;
  }
}

isLogoutSuccess({
  required BuildContext context,
  required String logoutStatusCode,
  required stateOfConnections logoutConnectionState,
}) {
  if (logoutConnectionState != stateOfConnections.isFailed ||
      logoutStatusCode == "200") {
    Provider.of<NavigasiViewModel>(context, listen: false)
        .navigasiLogout(context);
  } else {
    dynamic snackbar;
    if (logoutStatusCode == "400") {
      // return  ResponseDialog.dialogFailed(
      //       context: context,
      //       title: 'Logout Error',
      //       description: 'Your session has expired');
      snackbar =
          SnackBar(content: Text("logout error, sesi anda telah berakhir"));
    } else {
      // return ResponseDialog.dialogFailed(
      //     context: context,
      //     title: 'Logout Error',
      //     description: 'Unknown error');
      snackbar = SnackBar(
          content: Text("logout error, kesalahan yang tidak diketahui"));
    }

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}

isRegisterSuccess({
  required stateOfConnections stateOfRegister,
  required BuildContext context,
  required String registerStatus,
}) {
  if (stateOfRegister != stateOfConnections.isFailed) {
    ResponseDialog.dialogRegisterSuccess(
        context: context,
        title: 'Success Register',
        description:
            'You have successfully registered. Let\'s explore Better space now');
    Future.delayed(const Duration(milliseconds: 2500), () {
      Provider.of<NavigasiViewModel>(context, listen: false)
          .navigasiToLoginScreen(context);
    });
  } else {
    //dynamic snackbar;
    if (registerStatus == "400") {
      ResponseDialog.dialogFailed(
          context: context,
          title: 'Invalid Register',
          description: 'User has been used or your email is not valid');
      // snackbar = SnackBar(
      //     content: Text(
      //         "register gagal, user telah digunakan atau email anda tidak valid"));
    } else {
      ResponseDialog.dialogFailed(
          context: context,
          title: 'Invalid Register',
          description: 'Unknown error');
      // snackbar = SnackBar(
      //     content: Text("register gagal, kesalahan yang tidak diketahui"));
    }
    // ScaffoldMessenger.of(context).showSnackBar(snackbar);
    // return;
  }
}
