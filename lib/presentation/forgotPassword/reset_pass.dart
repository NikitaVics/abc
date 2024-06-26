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
import 'package:tennis_court_booking_app/widgets/animated_toast.dart';

import 'package:tennis_court_booking_app/widgets/custom_appbar.dart';
import 'package:tennis_court_booking_app/widgets/custom_appbar_login.dart';
import 'package:tennis_court_booking_app/widgets/custom_elevated_button.dart';
import 'package:tennis_court_booking_app/widgets/textfield_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ResetPassScreen extends StatefulWidget {
  final String email;
  const ResetPassScreen({super.key, required this.email});

  @override
  ResetPassScreenState createState() => ResetPassScreenState();
}

class ResetPassScreenState extends State<ResetPassScreen> {
  //text controllers:-----------------------------------------------------------
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmpassword = TextEditingController();

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
  bool isLoading = false;
  List<bool> isPasswordValid(String password) {
    // Define regular expressions for each condition
    final lowercaseRegex = RegExp(r'[a-z]');
    final uppercaseRegex = RegExp(r'[A-Z]');
    final digitRegex = RegExp(r'[0-9]');
    final specialCharRegex = RegExp(r'[!@#\$%^&*()_+{}\[\]:;<>,.?~\\-]');

    final isLengthValid = password.length >= 8;
    final hasLowercase = lowercaseRegex.hasMatch(password);
    final hasUppercase = uppercaseRegex.hasMatch(password);
    final hasDigit = digitRegex.hasMatch(password);
    final hasSpecialChar = specialCharRegex.hasMatch(password);

    return [
      isLengthValid,
      hasLowercase,
      hasUppercase,
      hasDigit,
      hasSpecialChar
    ];
  }

  bool _isMenuVisible = false;
  @override
  void initState() {
    super.initState();
    _passwordFocusNode = FocusNode();
    _passwordFocusNode.addListener(() {
      setState(() {
        _isMenuVisible = _passwordFocusNode.hasFocus;
      });
    });
    _confirmpasswordFocusNode = FocusNode();
    _confirmpasswordFocusNode.addListener(() {
      validateConfirmPassword();
    });
    provider = Provider.of<SignInProvider>(context, listen: false);
  }

  Future _onWilPop() async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isLoading,
      child: WillPopScope(
        onWillPop: () async {
          return await _onWilPop(); // Prevent going back
        },
        child: Builder(builder: (context) {
          return GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Scaffold(
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkThemeback
                  : AppColors.lightThemeback,
              primary: true,
              appBar:  CustomAppBarsLogin(
                isIcon: true,
                isBoarder: true,
                title: (AppLocalizations.of(context)!.forgotPassword),
                isProgress: false,
                step: 0,
              ),
              body: _buildBody(),
            ),
          );
        }),
      ),
    );
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
         (AppLocalizations.of(context)!.newPass),
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
          (AppLocalizations.of(context)!.password),
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
    final password = _password.text;
    final passwordConditions = isPasswordValid(password);
    final isPasswordValids = passwordConditions.every((condition) => condition);

    return Column(
      children: [
        TextFieldWidget(
          read: false,
          hint: (AppLocalizations.of(context)!.password),
          hintColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkhint
              : AppColors.hintColor,
          isObscure: true,
          textController: _password,
          focusNode: _passwordFocusNode,
          errorText: passwordError ? passwordErrorText : " ",
          defaultBoarder: AppColors.textInputField,
          errorBorderColor: AppColors.errorColor,
          focusBorderColor:
              passwordError ? AppColors.errorColor : AppColors.focusTextBoarder,
          onChanged: (value) {
            setState(() {
              passwordError = false; // Reset the error flag
            });
          },
        ),
        if (_passwordFocusNode.hasFocus)
          Visibility(
            visible: !isPasswordValids,
            child: Card(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkTextInput
                  : AppColors.textInputField,
              child: Column(
                children: [
                  const SizedBox(
                    height: 2,
                  ),
                  for (int i = 0; i < 5; i++)
                    Column(
                      children: [
                        Row(
                          children: [
                            const SizedBox(width: 5),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: passwordConditions[i]
                                    ? AppColors.dotColor
                                    : AppColors.errorColor,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Center(
                                child: Icon(
                                  passwordConditions[i]
                                      ? Icons.check
                                      : Icons.clear,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(_getConditionText(i)),
                          ],
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),

                  // Add your menu items here
                ],
              ),
            ),
          ),
      ],
    );
  }

   String _getConditionText(int index) {
    switch (index) {
      case 0:
        return (AppLocalizations.of(context)!.atLeast8char);
      case 1:
        return (AppLocalizations.of(context)!.lowerCase);
      case 2:
        return (AppLocalizations.of(context)!.upperCase);
      case 3:
        return (AppLocalizations.of(context)!.atleast1num);
      case 4:
        return (AppLocalizations.of(context)!.specialChar);
      default:
        return "";
    }
  }

  Widget _buildConfirmPasswordField() {
    return TextFieldWidget(
      read: false,
      hint:(AppLocalizations.of(context)!.confirmPass),
      hintColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkhint
          : AppColors.hintColor,
      isObscure: true,
      padding: const EdgeInsets.only(top: 0.0),
      textController: _confirmpassword,
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
              text: (AppLocalizations.of(context)!.updatePass),
              isLoading: isLoading,
              onPressed: () async {
                FocusManager.instance.primaryFocus?.unfocus();
                // SharedPreferences pref = await SharedPreferences.getInstance();

                if (await validate()) {
                  setState(() {
                    isLoading = true;
                  });
                  value
                      .resetPasswordApi(
                          widget.email, _password.text, _confirmpassword.text)
                      .then((val) {
                    if (val["statusCode"] == 200) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                      setState(() {
                        isLoading = false;
                      });
                      print(val);
                    } else {
                      setState(() {
          if (val != null) {
            AnimatedToast.showToastMessage(
              context,
              val["errorMessage"][0],
              const Color.fromRGBO(87, 87, 87, 0.93),
            );
          }
          isLoading = false;
        });
                    }
                  });
                }
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
    final password = _password.text;
    final passwordConditions = isPasswordValid(password);
    bool isPasswordValids = passwordConditions.every((condition) => condition);
    setState(() {
      if(password.isEmpty)
      {
          passwordError = true;
        passwordErrorText = (AppLocalizations.of(context)!.newPassText);
      }
      else if (!isPasswordValids) {
        passwordError = true;
        passwordErrorText =(AppLocalizations.of(context)!.newPassText2);
      } else {
        passwordError = false;
      }
    });

    return !passwordError;
  }

  Future<bool> validateConfirmPassword() async {
    setState(() {
      if (_confirmpassword.text.isEmpty) {
        confirmPasswordError = true;
        confirmPasswordErrorText = (AppLocalizations.of(context)!.validPass1);
      } else if (_confirmpassword.text != _password.text) {
        confirmPasswordError = true;
        confirmPasswordErrorText =(AppLocalizations.of(context)!.validPass2);
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
