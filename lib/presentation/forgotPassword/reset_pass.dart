import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tennis_court_booking_app/constants/colors.dart';
import 'package:tennis_court_booking_app/constants/font_family.dart';
import 'package:tennis_court_booking_app/model/login/login_response_model.dart';
import 'package:tennis_court_booking_app/presentation/forgotPassword/forgot_pass_using_otp.dart';
import 'package:tennis_court_booking_app/presentation/login/login_screen.dart';
import 'package:tennis_court_booking_app/presentation/login/provider/sign_in_provider.dart';
import 'package:tennis_court_booking_app/presentation/register/register.dart';

import 'package:tennis_court_booking_app/widgets/custom_appbar.dart';
import 'package:tennis_court_booking_app/widgets/custom_elevated_button.dart';
import 'package:tennis_court_booking_app/widgets/textfield_widget.dart';

class ResetPassScreen extends StatefulWidget {
  final String email;
  const ResetPassScreen({super.key,required this.email});

  @override
  ResetPassScreenState createState() => ResetPassScreenState();
}

class ResetPassScreenState extends State<ResetPassScreen> {
  //text controllers:-----------------------------------------------------------

  //predefine bool value for error:---------------------------------------------
  bool emailError = false,
      passwordError = false,
      confirmPasswordError = false,
      loginError = false;
  String emailErrorText = '',
      passwordErrorText = '',
      loginErrorMessage = '',
      confirmPasswordErrorText = '';
  bool isEmailValidationSuccessful = false;
  bool isPasswordValidationSuccessful = false;
  LoginResponse? loginResponse;

  //stores:---------------------------------------------------------------------

  //focus node:-----------------------------------------------------------------
  late FocusNode _passwordFocusNode;
  late FocusNode _confirmpasswordFocusNode;
  SignInProvider? provider;

  @override
  void initState() {
    super.initState();
    _passwordFocusNode = FocusNode();
    _confirmpasswordFocusNode = FocusNode();
    provider = Provider.of<SignInProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkThemeback
            : AppColors.lightThemeback,
        primary: true,
        appBar: const CustomAppBar(
          isBoarder: true,
          title: "Forgot Password",
            isProgress: false,
               step: 0,
        ),
        body: _buildBody(),
      );
    });
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Material(
      color: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkThemeback
          : AppColors.lightThemeback,
      child: Stack(
        children: <Widget>[
          MediaQuery.of(context).orientation == Orientation.landscape
              ? Row(
                  children: <Widget>[
                    Expanded(child: _buildLeftSide()),
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: _buildRightSide(),
                          ),
                          _buildSignInButton()
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Expanded(child: Center(child: _buildRightSide())),
                    _buildSignInButton()
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildLeftSide() {
    return SizedBox(
      width: 300,
      child: SizedBox.expand(
        child: Image.asset(
          "assets/images/onboard_back_one.png",
          //Assets.carBackground,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildRightSide() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildLoginText(),
            const SizedBox(height: 20.0),
            _buildPasswordField(),
            _buildConfirmPasswordField()
          ],
        ),
      ),
    );
  }

  Widget _buildLoginText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Enter New ",
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.headingTextColor
                : AppColors.allHeadColor,
            fontSize: 32,
            fontFamily: FontFamily.satoshi,
            fontWeight: FontWeight.w700,
            height: 40 / 32,
          ),
        ),
        Text(
          "Password",
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.headingTextColor
                : AppColors.allHeadColor,
            fontSize: 32,
            fontFamily: FontFamily.satoshi,
            fontWeight: FontWeight.w700,
            height: 40 / 32,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return TextFieldWidget(
      hint: "Password",
      hintColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkhint
          : AppColors.hintColor,
      isObscure: true,
      textController: provider!.resetsignUpPassword,
      focusNode: _passwordFocusNode,
      errorBorderColor: passwordError
          ? AppColors.errorColor // Border color for validation error
          : AppColors.textInputField,
      focusBorderColor:
          passwordError ? AppColors.errorColor : AppColors.focusTextBoarder,
      onChanged: (value) {
        setState(() {
          passwordError = false; // Reset the error flag
        });
        validatePassword(); // Trigger validation on text change
      },
      errorText: passwordError ? passwordErrorText : " ",
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFieldWidget(
      hint: "Confirm Password",
      hintColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkhint
          : AppColors.hintColor,
      isObscure: true,
      padding: const EdgeInsets.only(top: 0.0),
      textController: provider!.resetsignUpConfirmPassword,
      focusNode: _confirmpasswordFocusNode,
      errorBorderColor: confirmPasswordError
          ? AppColors.errorColor // Border color for validation error
          : AppColors.textInputField,
      focusBorderColor: confirmPasswordError
          ? AppColors.errorColor
          : AppColors.focusTextBoarder,
      onChanged: (value) {
        setState(() {
          confirmPasswordError = false; // Reset the error flag
        });
        validatePassword(); // Trigger validation on text change
      },
      errorText: confirmPasswordError ? confirmPasswordErrorText : " ",
    );
  }

  Widget _buildSignInButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 19),
        child: FocusScope(
          // Manage keyboard focus
          child: Consumer<SignInProvider>(builder: (context, value, child) {
            return CustomElevatedButton(
              height: 60,
              width: MediaQuery.of(context).orientation == Orientation.landscape
                  ? 70
                  : double.infinity,
              text: "Update Password",
              onPressed: () async {
                FocusManager.instance.primaryFocus?.unfocus();
              // SharedPreferences pref = await SharedPreferences.getInstance();
                value
                    .resetPasswordApi(
                 widget.email,
                )
                    .then((val) {
                  if (val["statusCode"] == 200) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                    print(val);
                  } else {
                    setState(() {
                      print(val['errorMessage']);
                    });
                  }
                });
                /* if (_formStore.canLogin) {
                DeviceUtils.hideKeyboard(context);
                _userStore.login(
                    _userEmailController.text, _passwordController.text);
              } else {
                _showErrorMessage('Please fill in all fields');
              }*/
              },
              buttonColor: AppColors.elevatedColor,
              textColor: Colors.white,
            );
          }),
        ),
      ),
    );
  }

  // General Methods:-----------------------------------------------------------

  // dispose:-------------------------------------------------------------------
  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree

    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<bool> validatePassword() async {
    var provider = Provider.of<SignInProvider>(context, listen: false);

    setState(() {
      if (provider.resetsignUpPassword.text.isEmpty) {
        passwordError = true;
        passwordErrorText = 'Please enter your password';
      } else if (provider.resetsignUpPassword.text.length < 8) {
        passwordError = true;
        passwordErrorText = 'Password must be at least 8 characters';
      } else {
        passwordError = false;
      }
    });

    return !passwordError;
  }

  Future<bool> validateConfirmPassword() async {
    var provider = Provider.of<SignInProvider>(context, listen: false);

    setState(() {
      if (provider.resetsignUpConfirmPassword.text.isEmpty) {
        confirmPasswordError = true;
        confirmPasswordErrorText = 'Please enter confirm password';
      } else if (provider.resetsignUpConfirmPassword.text !=
          provider.resetsignUpConfirmPassword.text) {
        confirmPasswordError = true;
        confirmPasswordErrorText = 'Passwords do not match';
      } else {
        confirmPasswordError = false;
      }
    });

    return !confirmPasswordError;
  }

  Future<bool> validate() async {
    bool passwordValid = await validatePassword();
    bool confirmPasswordValid = await validateConfirmPassword();

    return passwordValid && confirmPasswordValid;
  }
}
