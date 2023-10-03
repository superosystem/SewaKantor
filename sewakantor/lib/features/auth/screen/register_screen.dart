import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sewakantor/core/page_validators.dart';
import 'package:sewakantor/data/model/users/user_models_for_regist.dart';
import 'package:sewakantor/features/auth/view_model/login_view_model.dart';
import 'package:sewakantor/features/auth/view_model/register_view_models.dart';
import 'package:sewakantor/features/navigation/view_model/navigasi_view_model.dart';
import 'package:sewakantor/utils/adapt_size.dart';
import 'package:sewakantor/utils/colors.dart';
import 'package:sewakantor/utils/enums.dart';
import 'package:sewakantor/utils/form_validator.dart';
import 'package:sewakantor/widgets/button_widget.dart';
import 'package:sewakantor/widgets/loading_widget.dart';
import 'package:sewakantor/widgets/rich_text_widget.dart';
import 'package:sewakantor/widgets/string_radio_button.dart';
import 'package:sewakantor/widgets/text_filed_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  ValueNotifier<GenderEnum> radGenderVal =
      ValueNotifier<GenderEnum>(GenderEnum.male);
  ValueNotifier<String> _stringGenderVal = ValueNotifier<String>('male');

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _fullnameController.dispose();
    _confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final registerProvider = Provider.of<RegisterViewModels>(context);
    AdaptSize.size(context: context);
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(
              top: AdaptSize.paddingTop + AdaptSize.screenHeight / 19,
              left: AdaptSize.screenWidth / 22.5,
              right: AdaptSize.screenWidth / 22.5),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(bottom: AdaptSize.screenHeight / 400),
                  child: Text(
                    "Hi,",
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(bottom: AdaptSize.screenHeight / 33.3),
                  child: Text(
                    "let's register to use the app",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(bottom: AdaptSize.screenHeight / 72.7),
                  child: textFormFields(
                    textInputAction: TextInputAction.done,
                    obscureText: false,
                    hintTexts: 'fullname',
                    textStyle: Theme.of(context).textTheme.bodyText1,
                    label: 'Full Name',
                    controller: _fullnameController,
                    validators: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),

                SizedBox(
                  height: AdaptSize.screenHeight * .011,
                ),

                /// gender text
                Text(
                  "Gender",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),

                /// gender radio button
                Row(
                  children: [
                    /// male value
                    stringRadioButton(
                      context: context,
                      customRadioController: _stringGenderVal,
                      controlledIdValue: 'male',
                    ),

                    SizedBox(
                      width: AdaptSize.screenWidth * .011,
                    ),

                    Text(
                      "Male",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),

                    SizedBox(
                      width: AdaptSize.screenWidth * .014,
                    ),

                    /// feemale value
                    stringRadioButton(
                      context: context,
                      customRadioController: _stringGenderVal,
                      controlledIdValue: 'female',
                    ),

                    SizedBox(
                      width: AdaptSize.screenWidth * .01,
                    ),

                    Text(
                      "Female",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),

                SizedBox(
                  height: AdaptSize.screenHeight * .024,
                ),

                /// email field
                textFormFields(
                  textInputAction: TextInputAction.done,
                  obscureText: false,
                  maxLines: 1,
                  keyboardType: TextInputType.emailAddress,
                  hintTexts: 'example@gmail.com',
                  textStyle: Theme.of(context).textTheme.bodyText1,
                  label: 'Email',
                  controller: _emailController,
                  validators: (email) =>
                      email == null || !EmailValidator.validate(email)
                          ? "enter valid email"
                          : null,
                ),

                SizedBox(
                  height: AdaptSize.screenHeight * .024,
                ),

                /// password field
                Consumer<LoginViewModel>(builder: (context, value, child) {
                  return textFormFields(
                    textInputAction: TextInputAction.done,
                    maxLines: 1,
                    obscureText: value.visiblePassword1 ? false : true,
                    textStyle: Theme.of(context).textTheme.bodyText1,
                    label: "Password",
                    controller: _passwordController,
                    suffixIcon: IconButton(
                      onPressed: () {
                        value.visiblePass1();
                      },
                      icon: value.visiblePassword1
                          ? Icon(
                              Icons.visibility_off,
                              color: MyColor.darkBlueColor,
                            )
                          : Icon(Icons.remove_red_eye,
                              color: MyColor.darkBlueColor),
                    ),
                    hintTexts: "Password",
                    validators: (value) => FormValidator.validate(
                      title: 'password',
                      value1: _passwordController.text,
                      value2: _confirmPasswordController.text,
                    ),
                  );
                }),

                SizedBox(
                  height: AdaptSize.screenHeight * .024,
                ),

                /// confrim password field
                Consumer<LoginViewModel>(builder: (context, value, child) {
                  return textFormFields(
                    textInputAction: TextInputAction.done,
                    maxLines: 1,
                    obscureText: value.visiblePassword2 ? false : true,
                    textStyle: Theme.of(context).textTheme.bodyText1,
                    label: "Confirm Password",
                    controller: _confirmPasswordController,
                    hintTexts: "Confirm Password",
                    suffixIcon: IconButton(
                      onPressed: () {
                        value.visiblePass2();
                      },
                      icon: value.visiblePassword2
                          ? Icon(
                              Icons.visibility_off,
                              color: MyColor.darkBlueColor,
                            )
                          : Icon(Icons.remove_red_eye,
                              color: MyColor.darkBlueColor),
                    ),
                    validators: (value) => FormValidator.validate(
                      title: 'confirm password',
                      value1: _passwordController.text,
                      value2: _confirmPasswordController.text,
                    ),
                  );
                }),

                SizedBox(
                  height: AdaptSize.screenHeight * .024,
                ),

                /// terms and conditions
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding:
                        EdgeInsets.only(bottom: AdaptSize.screenHeight / 100),
                    child: richTextWidget(
                      text1: 'I agree to the ',
                      textStyle1: Theme.of(context).textTheme.bodySmall,
                      text2: 'Terms & Conditions ',
                      textStyle2: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: MyColor.darkBlueColor),
                      text3: 'that apply',
                      textStyle3: Theme.of(context).textTheme.bodySmall,
                      recognizer: TapGestureRecognizer()
                        ..onTap = (() {
                          NavigasiViewModel()
                              .navigasiToTermsAndConditionScreen(context);
                        }),
                    ),
                  ),
                ),

                /// button register
                ValueListenableBuilder(
                  valueListenable: radGenderVal,
                  builder: ((context, values, child) {
                    return Consumer<RegisterViewModels>(
                        builder: (context, regValue, child) {
                      return buttonWidget(
                        sizeheight: AdaptSize.screenHeight / 14,
                        sizeWidth: double.infinity,
                        borderRadius: BorderRadius.circular(10),
                        backgroundColor: MyColor.darkBlueColor,
                        onPressed: () async {
                          final isValid = _formKey.currentState!.validate();
                          if (isValid == false) {
                            return;
                          } else {
                            debugPrint(radGenderVal.value.toString());
                            await registerProvider.createUser(
                              userInfo: UserModelForRegist(
                                full_name: _fullnameController.text,
                                gender: _stringGenderVal.value,
                                email: _emailController.text,
                                password: _passwordController.text,
                                confirmation_password:
                                    _confirmPasswordController.text,
                              ),
                            );
                            debugPrint(
                                "status : ${regValue.statusCodeRegister}");
                            debugPrint("state : ${regValue.connectionsState}");
                            isRegisterSuccess(
                                stateOfRegister: regValue.connectionsState,
                                context: context,
                                registerStatus:
                                    regValue.statusCodeRegister.toString());
                          }
                        },
                        child: regValue.connectionsState ==
                                stateOfConnections.isLoading
                            ? LoadingWidget.whiteButtonLoading
                            : Text(
                                "Register",
                                style: Theme.of(context)
                                    .textTheme
                                    .button!
                                    .copyWith(color: MyColor.whiteColor),
                              ),
                      );
                    });
                  }),
                ),

                /// button to login screen
                Padding(
                  padding: EdgeInsets.only(
                    bottom: AdaptSize.screenHeight * .05,
                    top: AdaptSize.screenHeight * 0.1,
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: richTextWidget(
                        text1: 'already have an account? ',
                        textStyle1: Theme.of(context).textTheme.bodyMedium,
                        text2: 'Login',
                        textStyle2: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: MyColor.darkBlueColor),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            NavigasiViewModel().navigasiPop(context);
                          }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
