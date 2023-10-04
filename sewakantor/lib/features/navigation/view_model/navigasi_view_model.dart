import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:sewakantor/core/testing_screen_for_api.dart';
import 'package:sewakantor/data/model/offices/office_dummy_models.dart';
import 'package:sewakantor/features/accounts/screen/setting_item_screen/term_condition_screen.dart';
import 'package:sewakantor/features/auth/screen/login_screen.dart';
import 'package:sewakantor/features/auth/screen/register_screen.dart';
import 'package:sewakantor/features/home/screen/notification_screen.dart';
import 'package:sewakantor/features/home/screen/search_space_screen.dart';
import 'package:sewakantor/features/menus/screen/menu_screen.dart';
import 'package:sewakantor/features/offices/screen/detail_office/checkout_screen.dart';
import 'package:sewakantor/features/offices/screen/detail_office/office_detail_screen.dart';
import 'package:sewakantor/features/offices/screen/detail_office/payment_detail_screen.dart';
import 'package:sewakantor/features/offices/screen/detail_office/payment_metod_screen.dart';
import 'package:sewakantor/features/offices/screen/detail_office/success_payment_screen.dart';
import 'package:sewakantor/features/offices/screen/office_filter/filter_by_keyword.dart';
import 'package:sewakantor/features/offices/screen/office_filter/filter_by_selection.dart';
import 'package:sewakantor/features/onboard/screen/on_board_view.dart';
import 'package:sewakantor/features/transactions/screen/process_detail_order.dart';
import 'package:sewakantor/features/transactions/widget/booking_status_widget.dart';
import 'package:sewakantor/data/model/transactions/transactions_models.dart';
import 'package:sewakantor/widgets/google_maps.dart';

class NavigasiViewModel with ChangeNotifier {
  /// navigasi splash 2 ke onboarding view
  void navigasiToOnboardingView(BuildContext context) {
    Timer(
      const Duration(milliseconds: 300),
      () {
        Navigator.of(context).pushAndRemoveUntil(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondAnimation) =>
                  const OnBoardView(),
              transitionsBuilder:
                  (context, animation, secondAnimation, child) =>
                      FadeTransition(
                opacity: animation,
                child: child,
              ),
            ),
            (route) => false);
      },
    );
    notifyListeners();
  }

  /// navigasi kembali
  void navigasiPop(BuildContext context) {
    Navigator.pop(context);
  }

  /// navigasi register ke login screen
  void navigasiToRegisterScreen(BuildContext context) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => const RegisterScreen(),
      ),
    );
  }

  /// navigasi onboarding ke register screen
  void navigasiToLoginScreen(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
        CupertinoPageRoute(
          builder: (context) => const LoginScreen(),
        ),
        (route) => false);
  }

  ///navigasi ke terms and condition page
  void navigasiToTermsAndConditionScreen(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondAnimation) =>
            const TermConditionScreen(),
        transitionDuration: const Duration(milliseconds: 1200),
        transitionsBuilder: (context, animation, secondAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.linearToEaseOut;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  /// navigasi login ke menu screen
  void navigasiToMenuScreen(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondAnimation) =>
              const MenuScreen(),
          transitionDuration: const Duration(milliseconds: 1200),
          transitionsBuilder: (context, animation, secondAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.linearToEaseOut;

            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
        (route) => false);
  }

  /// navigasi home ke search screen
  void navigasiToSearchSpaces(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const SearchSpaceScreen(),
      ),
    );
  }

  /// navigasi ke halaman notifikasi
  void navigasiToNotification(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const NotificationScreen(),
      ),
    );
  }

  /// navigasi account setting by index
  void navigasiSettingItem(context, dynamic settingItem) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => settingItem,
      ),
    );
  }

  /// navigasi log out
  void navigasiLogout(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondAnimation) =>
              const LoginScreen(),
          transitionsBuilder: (context, animation, secondAnimation, child) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        ),
        (route) => false);
    notifyListeners();
  }

  /// navigasi onboarding ke register screen
  void navigasiForTesting(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
        CupertinoPageRoute(
          //change the target widget here

          builder: (context) => const TestingScreenAPI(),
        ),
        (route) => false);
  }

  /// navigasi open google maps
  void navigasiOpenGoogleMaps({
    context,
    required OfficeModels officeId,
  }) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => GoogleMapsWidget(
          officeData: officeId,
        ),
      ),
    );
  }

  /// navigasi open google maps
  void navigasiToPaymentDetail(
      {required BuildContext context,
      required String officeId,
      required CreateTransactionModels bookingForm,
      required int paymentMethodIndex,
      required String durationTimeUnit}) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => PaymentDetailScreen(
          officeId: officeId,
          bookingForms: bookingForm,
          paymentMethodPointerIndex: paymentMethodIndex,
          durationTimeUnits: durationTimeUnit,
        ),
      ),
    );
  }

  /// belum final
  /// navigasi dari detail payment ke success payment
  void navigasiSuccessPayment(
      {required BuildContext context,
      required CreateTransactionModels requestedTransactionModel}) {
    Navigator.pushAndRemoveUntil(
        context,
        CupertinoModalPopupRoute(
            builder: (context) => SuccessPaymentScreen(
                  requestedTransactionModels: requestedTransactionModel,
                )),
        (route) => false);

    notifyListeners();
  }

  /// navigasi back check permission
  Future navigasiBackCheckPermission(BuildContext context) async {
    Navigator.pop(context);
  }

  /// navigasi to search filtering
  void navigasiToFilterSearch(BuildContext context) {
    Timer(
      const Duration(milliseconds: 300),
      () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondAnimation) =>
                const KeywordFilterScreen(),
            transitionsBuilder: (context, animation, secondAnimation, child) =>
                FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
        );
      },
    );
    notifyListeners();
  }

  /// navigasi to detail office
  void navigasiToDetailSpace({
    context,
    required String officeId,
  }) {
    Navigator.push(
      context,
      CupertinoModalPopupRoute(
        builder: (context) => OfficeDetailScreen(
          officeID: officeId,
        ),
      ),
    );
  }

  /// navigasi back dari succes payment screen
  Future<bool> navigasiBackToMenu(BuildContext context) async {
    Navigator.pushReplacement(
      context,
      CupertinoDialogRoute(
          builder: (context) => const MenuScreen(), context: context),
    );
    notifyListeners();
    return Future(() => true);
  }

  /// navigasi success screen to detail order
  void navigasiToDetailOrder(
      {required BuildContext context,
      UserTransaction? requestedModel,
      required bool isNewTransaction,
      CreateTransactionModels? requestedCreateTransactionModel}) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => ProcessDetailOrderScreens(
          isNewTransaction: isNewTransaction,
          statusTransaction: BookingStatusWidget.statusOnProcess(context),
          requestedModels: requestedModel,
          requestedCreateTransactionModel: requestedCreateTransactionModel,
        ),
      ),
    );
    notifyListeners();
  }

  /// navigasi to checkout screen
  void navigasiToCheckOut(BuildContext context, String officeId) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => CheckoutScreen(
          officeId: officeId,
        ),
      ),
    );
  }

  /// navigasi dari sukses screen
  void navigasiBackToBookingHistory(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondAnimation) =>
              const MenuScreen(
            currentIndex: 1,
          ),
          transitionsBuilder: (context, animation, secondAnimation, child) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        ),
        (route) => false);

    notifyListeners();
  }

  /// navigasi to payment method
  void navigasiToPaymentMetod(
      {required BuildContext context,
      required String officeId,
      required TransactionFormModels checkoutForm,
      required String durationTimeUnit}) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => PaymentMetodScreen(
          checkoutForms: checkoutForm,
          officeId: officeId,
          durationTimeUnit: durationTimeUnit,
        ),
      ),
    );
  }

  /// navigasi all office (home screen)
  void navigasiAllOffice(BuildContext context, Widget routeOffice) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => routeOffice),
    );
  }

  /// navigasi search by item selected
  void navigasiToSearchBySelected(BuildContext context, String officeLocation,
      String officeType, String dateSelected) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => SelectedFilterScreen(
          officeLocation: officeLocation,
          officeType: officeType,
          dateSelected: dateSelected,
        ),
      ),
    );
  }
}
