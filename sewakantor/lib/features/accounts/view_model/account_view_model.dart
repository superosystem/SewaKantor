import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sewakantor/features/accounts/screen/edit_profile_screen.dart';
import 'package:sewakantor/features/accounts/screen/setting_item_screen/about_screen.dart';
import 'package:sewakantor/features/accounts/screen/setting_item_screen/change_password_screen.dart';
import 'package:sewakantor/features/accounts/screen/setting_item_screen/email_screen.dart';
import 'package:sewakantor/features/accounts/screen/setting_item_screen/privacy_pollicy_screen.dart';
import 'package:sewakantor/features/accounts/screen/setting_item_screen/term_condition_screen.dart';
import 'package:sewakantor/features/accounts/screen/setting_screen.dart';
import 'package:sewakantor/features/navigation/view_model/navigasi_view_model.dart';
import 'package:sewakantor/features/transactions/screen/booking_history_screen.dart';
import 'package:sewakantor/widgets/dialog/custom_dialog.dart';

class AccountViewModel with ChangeNotifier {
  /// pick image

  File? _imageProfile;

  get imageProfile => _imageProfile;

  Future<void> pickImageProfile(context, String title) async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? pickImageProfile = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 55,
    );
    _imageProfile = File(pickImageProfile!.path);
    notifyListeners();
    CustomDialog.singleActionDialog(
        onPressed: () => Provider.of<NavigasiViewModel>(context, listen: false)
            .navigasiPop(context),
        context: context,
        title: title,
        imageAsset: 'assets/svg_assets/check_list.svg');
  }

  /// ------------------------------------------------------------------------

  /// button edit profile

  bool _isLoading = false;

  get isLoading => _isLoading;

  void changeProfileMessage(BuildContext context, String title) async {
    _isLoading = !_isLoading;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2));
    _isLoading = false;
    notifyListeners();
    CustomDialog.singleActionDialog(
        onPressed: () => Provider.of<NavigasiViewModel>(context, listen: false)
            .navigasiPop(context),
        context: context,
        title: title,
        imageAsset: 'assets/svg_assets/check_list.svg');
    //
  }

  /// -------------------------------------------------------------------------

  /// list account screen

  final List _accountItem = [
    ['Edit Profile', Icons.edit_outlined, const EditProfileScreen()],
    [
      'Booking',
      Icons.calendar_month_outlined,
      const BookingHistoryScreen(isCenterTitle: false)
    ],
    ['Setting', Icons.settings_outlined, const SettingScreen()],
    ['Log out', Icons.logout, 3]
  ];

  List get accountItem => _accountItem;

  /// -------------------------------------------------------------------------
  /// Setting screen

  List get itemSetting1 => _itemSetting1;

  List get itemSetting2 => _itemSetting2;

  final List _itemSetting1 = [
    [Icons.email_outlined, 'Email', const EmailScreen()],
    [Icons.lock_outline, 'Changes Password', const ChangePasswordScreen()],
    [Icons.delete_forever, 'Delete Account', 3],
  ];

  final List _itemSetting2 = [
    [Icons.info_outline, 'About', AboutScreen()],
    [
      Icons.remove_red_eye_outlined,
      'Terms & Condition',
      const TermConditionScreen()
    ],
    [Icons.privacy_tip_outlined, 'Provacy Police', const PrivacyPolicyScreen()],
  ];

  /// -------------------------------------------------------------------------
  /// about web view loading

  bool _webLoading = true;

  get webLoading => _webLoading;

  void completeLoading() {
    _webLoading = false;
    notifyListeners();
  }
}
