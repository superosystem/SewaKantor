import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sewakantor/core/network/network_aware.dart';
import 'package:sewakantor/core/network/no_connection_screen.dart';
import 'package:sewakantor/features/accounts/view_model/account_view_model.dart';
import 'package:sewakantor/features/navigation/view_model/navigasi_view_model.dart';
import 'package:sewakantor/utils/adapt_size.dart';
import 'package:sewakantor/utils/colors.dart';
import 'package:sewakantor/utils/form_validator.dart';
import 'package:sewakantor/widgets/button_widget.dart';
import 'package:sewakantor/widgets/default_appbar_widget.dart';
import 'package:sewakantor/widgets/loading_widget.dart';
import 'package:sewakantor/widgets/text_filed_widget.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _updatePasswordController =
      TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey();

  @override
  void dispose() {
    super.dispose();
    _updatePasswordController.dispose();
    _confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppbarWidget(
        contexts: context,
        leadIconFunction: () {
          context.read<NavigasiViewModel>().navigasiPop(context);
        },
        isCenterTitle: false,
        titles: 'Change Password',
      ),
      body: NetworkAware(
        offlineChild: const NoConnectionScreen(),
        onlineChild: Padding(
          padding: EdgeInsets.only(
            left: AdaptSize.screenWidth * .016,
            right: AdaptSize.screenWidth * .016,
            top: AdaptSize.pixel16,
          ),
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// update password
                textFormFields(
                  label: 'Update Password',
                  controller: _updatePasswordController,
                  textStyle: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: AdaptSize.pixel16),
                  validators: (value) => FormValidator.validate(
                    title: 'password',
                    value1: _updatePasswordController.text,
                    value2: _confirmPasswordController.text,
                  ),
                  hintTexts: '********',
                  obscureText: false,
                  textInputAction: TextInputAction.done,
                ),

                SizedBox(
                  height: AdaptSize.pixel10,
                ),

                /// confirm update password
                textFormFields(
                  label: 'Confirm Update Password',
                  controller: _confirmPasswordController,
                  textStyle: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: AdaptSize.pixel16),
                  validators: (value) => FormValidator.validate(
                    title: 'password',
                    value1: _updatePasswordController.text,
                    value2: _confirmPasswordController.text,
                  ),
                  hintTexts: '********',
                  obscureText: false,
                  textInputAction: TextInputAction.done,
                ),

                SizedBox(
                  height: AdaptSize.screenHeight * .018,
                ),

                /// button submit
                Consumer<AccountViewModel>(builder: (context, value, child) {
                  return buttonWidget(
                    sizeheight: AdaptSize.screenHeight / 14,
                    sizeWidth: double.infinity,
                    borderRadius: BorderRadius.circular(10),
                    backgroundColor: MyColor.darkBlueColor,
                    onPressed: () async {
                      if (_key.currentState!.validate()) {
                        value.changeProfileMessage(context,
                            'Your password has been updated successfully!');
                        _updatePasswordController.clear();
                        _confirmPasswordController.clear();
                      }
                    },
                    child: value.isLoading
                        ? LoadingWidget.whiteButtonLoading
                        : Text(
                            "Save Changes",
                            style: Theme.of(context)
                                .textTheme
                                .button!
                                .copyWith(color: MyColor.whiteColor),
                          ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
