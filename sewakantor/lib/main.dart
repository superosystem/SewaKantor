import 'package:sewakantor/data/model/offices/office_dummy_data.dart';
import 'package:sewakantor/features/splashscreen/splash_screen1.dart';
import 'package:sewakantor/features/home/screen/voucer_promo_screen.dart';
import 'package:sewakantor/utils/colors.dart';
import 'package:sewakantor/utils/network_status.dart';
import 'package:sewakantor/utils/text_theme.dart';
import 'package:sewakantor/features/accounts/view_model/account_view_model.dart';
import 'package:sewakantor/features/reviews/view_model/add_review_view_model.dart';
import 'package:sewakantor/features/locations/view_model/get_location_view_model.dart';
import 'package:sewakantor/features/auth/view_model/login_view_model.dart';
import 'package:sewakantor/features/auth/view_model/login_view_models.dart';
import 'package:sewakantor/features/menus/view_model/menu_view_model.dart';
import 'package:sewakantor/features/navigation/view_model/navigasi_view_model.dart';
import 'package:sewakantor/features/offices/view_model/office_view_models.dart';
import 'package:sewakantor/features/onboard/view_model/onboard_view_models.dart';
import 'package:sewakantor/features/promo/view_model/promo_view_model.dart';
import 'package:sewakantor/features/auth/view_model/register_view_models.dart';
import 'package:sewakantor/features/reviews/view_model/review_view_model.dart';
import 'package:sewakantor/features/spaces/view_model/search_spaces_view_model.dart';
import 'package:sewakantor/features/transactions/view_model/transaction_view_model.dart';
import 'package:sewakantor/features/transactions/view_model/transaction_view_models.dart';
import 'package:sewakantor/features/wishlists/view_model/whislist_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const sewakantorApp());
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class sewakantorApp extends StatelessWidget {
  const sewakantorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OnboardViewModels()),
        ChangeNotifierProvider(create: (_) => RegisterViewModels()),
        ChangeNotifierProvider(create: (_) => LoginViewModels()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => NavigasiViewModel()),
        ChangeNotifierProvider(create: (_) => MenuViewModel()),

        ChangeNotifierProvider(create: (_) => AccountViewModel()),
        ChangeNotifierProvider(create: (_) => OfficeViewModels()),
        ChangeNotifierProvider(create: (_) => OfficeDummyDataViewModels()),

        ChangeNotifierProvider(create: (_) => ReviewViewModels()),
        ChangeNotifierProvider(create: (_) => AddReviewViewModel()),
        
        ChangeNotifierProvider(create: (_) => TransactionViewModels()),
        ChangeNotifierProvider(create: (_) => SearchSpacesViewModel()),
        ChangeNotifierProvider(create: (_) => PromoViewModel()),
        ChangeNotifierProvider(create: (_) => GetLocationViewModel()),
        ChangeNotifierProvider(create: (_) => TransactionViewModel()),
        ChangeNotifierProvider(create: (_) => WhislistViewModel()),
        StreamProvider<NetworkStatus>(
          create: (context) =>
              NetworkStatusService().networkStatusController.stream,
          initialData: NetworkStatus.online,
        ),
      ],
      child: MaterialApp(
        navigatorKey: NavigationService.navigationKey,
        home: const SplashScreenOne(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: MyColor.neutral900,
          textTheme: myTextTheme,
          colorScheme: Theme.of(context)
              .colorScheme
              .copyWith(secondary: MyColor.whiteColor),
        ),
        routes: {
          VoucerPromoScreen.routeName: (_) => const VoucerPromoScreen(),
          "/firstPage": ((context) => const SplashScreenOne())
        },
      ),
    );
  }
}
