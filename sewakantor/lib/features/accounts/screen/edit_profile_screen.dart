import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sewakantor/core/network/network_aware.dart';
import 'package:sewakantor/core/network/no_connection_screen.dart';
import 'package:sewakantor/features/auth/view_model/login_view_models.dart';
import 'package:sewakantor/features/navigation/view_model/navigasi_view_model.dart';
import 'package:sewakantor/utils/adapt_size.dart';
import 'package:sewakantor/utils/colors.dart';
import 'package:sewakantor/utils/enums.dart';
import 'package:sewakantor/utils/form_validator.dart';
import 'package:sewakantor/widgets/button_widget.dart';
import 'package:sewakantor/widgets/default_appbar_widget.dart';
import 'package:sewakantor/widgets/dialog/custom_dialog.dart';
import 'package:sewakantor/widgets/loading_widget.dart';
import 'package:sewakantor/widgets/string_radio_button.dart';
import 'package:sewakantor/widgets/text_filed_widget.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _editNameController = TextEditingController();

  final GlobalKey<FormState> _key = GlobalKey();

  ValueNotifier<String> stringGenderVal = ValueNotifier<String>('male');

  @override
  void dispose() {
    super.dispose();
    _editNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: defaultAppbarWidget(
          contexts: context,
          leadIconFunction: () {
            context.read<NavigasiViewModel>().navigasiPop(context);
          },
          isCenterTitle: false,
          titles: 'Edit Profile',
        ),
        body: NetworkAware(
          offlineChild: const NoConnectionScreen(),
          onlineChild: Padding(
            padding: EdgeInsets.only(
              left: AdaptSize.screenWidth * .016,
              right: AdaptSize.screenWidth * .016,
              top: AdaptSize.pixel10,
            ),
            child: Form(
              key: _key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: AdaptSize.pixel16,
                  ),

                  /// form field
                  Consumer<LoginViewModels>(builder: (context, value, child) {
                    return textFormFields(
                      label: 'Full Name',
                      controller: _editNameController,
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontSize: AdaptSize.pixel16),
                      validators: (value) => FormValidator.validateProfilName(
                        title: 'Name',
                        value1: _editNameController.text,
                      ),
                      hintTexts:
                          value.userModels?.userProfileDetails.userName ??
                              'New Name',
                      obscureText: false,
                      textInputAction: TextInputAction.done,
                    );
                  }),

                  SizedBox(
                    height: AdaptSize.pixel16,
                  ),

                  /// gender text
                  Text(
                    "Gender",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),

                  /// radio button
                  Row(
                    children: [
                      /// male value
                      stringRadioButton(
                        context: context,
                        customRadioController: stringGenderVal,
                        controlledIdValue: 'male',
                      ),

                      SizedBox(
                        width: AdaptSize.screenHeight * .01,
                      ),

                      Text(
                        "Male",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),

                      /// feemale value
                      stringRadioButton(
                        context: context,
                        customRadioController: stringGenderVal,
                        controlledIdValue: 'female',
                      ),

                      SizedBox(
                        width: AdaptSize.screenHeight * .01,
                      ),

                      Text(
                        "Female",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const Spacer(),

                  Consumer<LoginViewModels>(builder: (context, value, child) {
                    return buttonWidget(
                      sizeheight: AdaptSize.screenHeight / 14,
                      sizeWidth: double.infinity,
                      borderRadius: BorderRadius.circular(10),
                      backgroundColor: MyColor.darkBlueColor,
                      onPressed: () async {
                        if (_key.currentState!.validate()) {
                          await value.updateProfileData(
                            currentUserModels: value.userModels!,
                            newName: _editNameController.text,
                            newGenders: stringGenderVal.value,
                          );
                          if (value.profileSetterConnectionState ==
                              stateOfConnections.isReady) {
                            _editNameController.clear();
                            return Future.delayed(Duration.zero, () {
                              return CustomDialog.singleActionDialog(
                                  onPressed: () => Navigator.pop(context, true),
                                  context: context,
                                  title:
                                      'Your profile has been updated successfully!',
                                  imageAsset:
                                      'assets/svg_assets/check_list.svg');
                            });
                          }
                        }
                      },
                      child: value.profileSetterConnectionState ==
                              stateOfConnections.isLoading
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

                  SizedBox(
                    height: AdaptSize.screenHeight * .02,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
