import 'package:flutter/material.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:provider/provider.dart';
import 'package:sewakantor/features/auth/view_model/login_view_models.dart';
import 'package:sewakantor/features/locations/view_model/get_location_view_model.dart';
import 'package:sewakantor/features/navigation/view_model/navigasi_view_model.dart';
import 'package:sewakantor/features/offices/view_model/office_view_models.dart';
import 'package:sewakantor/utils/colors.dart';

final NavigationService navService = NavigationService();

class SplashScreenTwo extends StatefulWidget {
  const SplashScreenTwo({Key? key}) : super(key: key);

  @override
  State<SplashScreenTwo> createState() => _SplashScreenTwoState();
}

class _SplashScreenTwoState extends State<SplashScreenTwo> {
  @override
  void initState() {
    super.initState();

    final locationProvider =
        Provider.of<GetLocationViewModel>(context, listen: false);
    final providerOffice =
        Provider.of<OfficeViewModels>(context, listen: false);
    final providerClient = Provider.of<LoginViewModels>(context, listen: false);
    providerClient.validateTokenIsExist();
    // final providerOfUser = Provider.of<LoginViewmodels>(context, listen: false);
    // final providerOfOffice =
    // Provider.of<OfficeViewModels>(context, listen: false);
    // final providerOfTransaction =
    // Provider.of<TransactionViewmodels>(context, listen: false);
    if (providerClient.isUserExist == true) {
      Future.delayed(Duration.zero, () {
        providerClient.getProfile();
        providerOffice.fetchAllOffice();
        providerOffice.fetchCoworkingSpace();
        providerOffice.fetchMeetingRoom();
        providerOffice.fetchOfficeRoom();
        providerOffice.fetchOfficeByRecommendation();
        locationProvider.checkAndGetPosition();
        // providerOfTransaction.getTransactionByUser(
        //     userModels: providerOfUser.userModels!,
        //     ListOfAllOffice: providerOfOffice.listOfAllOfficeModels);
      });
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        Provider.of<NavigasiViewModel>(context, listen: false)
            .navigasiToMenuScreen(context);
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        Provider.of<NavigasiViewModel>(context, listen: false)
            .navigasiToLoginScreen(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.whiteColor,
    );
  }
}
