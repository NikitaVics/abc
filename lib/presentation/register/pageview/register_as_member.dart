// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tennis_court_booking_app/constants/colors.dart';
import 'package:tennis_court_booking_app/constants/font_family.dart';
import 'package:tennis_court_booking_app/presentation/login/login_screen.dart';
import 'package:tennis_court_booking_app/presentation/login/provider/sign_in_provider.dart';
import 'package:tennis_court_booking_app/presentation/register/verifyemail/verify_email.dart';
import 'package:tennis_court_booking_app/widgets/custom_elevated_button.dart';
import 'package:tennis_court_booking_app/widgets/textfield_widget.dart';

class RegisterAsMember extends StatefulWidget {
  @override
  State<RegisterAsMember> createState() => _RegisterAsMemberState();
}

class _RegisterAsMemberState extends State<RegisterAsMember> {
  late FocusNode _passwordFocusNode;
  late FocusNode _confirmpasswordFocusNode;
  bool emailError = false,
      passwordError = false,
      loginError = false,
      confirmPasswordError = false,
      nameError = false;
  String emailErrorText = '',
      loginErrorMessage = '',
      passwordErrorText = '',
      confirmPasswordErrorText = '';
  bool isEmailValidationSuccessful = false;
  bool isPasswordValidationSuccessful = false;
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
    return Column(
      children: [
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _buildLoginText(),
                      SizedBox(height: 24.0),
                      _buildUserName(),
                      _buildUserIdField(),
                      _buildPasswordField(),
                      _buildConfirmPasswordField(),
                      _buildNotMemberText(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        _buildSignInButton()
      ],
    );
  }

  Widget _buildLoginText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Register as Member",
          style: TextStyle(
            color: AppColors.allHeadColor,
            fontSize: 32,
            fontFamily: FontFamily.satoshi,
            fontWeight: FontWeight.w700,
            height: 40 / 32,
          ),
        ),
        SizedBox(height: 8.0),
        Row(
          children: [
            Text(
              "If you need any support",
              style: TextStyle(
                color: AppColors.subheadColor,
                fontSize: 12,
                fontFamily: FontFamily.satoshi,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              " Click Here",
              style: TextStyle(
                color: AppColors.dotColor,
                fontSize: 12,
                fontFamily: FontFamily.satoshi,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildUserName() {
    return TextFieldWidget(
      hint: 'User Name',
      inputType: TextInputType.name,
      hintColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkhint
          : AppColors.hintColor,
      // iconColor: _themeStore.darkMode ? Colors.white70 : Colors.black54,
      textController: provider!.signUpName,
      inputAction: TextInputAction.next,
     defaultBoarder: AppColors.textInputField,
      errorBorderColor: emailError
          ? AppColors.errorColor // Border color for validation error
          : AppColors.textInputField,
      focusBorderColor:
          emailError ? AppColors.errorColor : AppColors.focusTextBoarder,
     
    
      autoFocus: false,
      onChanged: (value) {
        setState(() {
          nameError = false; // Reset the error flag
        });
        validateName(); // Trigger validation on text change
      },
      errorText: nameError ? "Please enter name" : " ",
    );
  }

  Widget _buildUserIdField() {
    return TextFieldWidget(
      hint: 'E-Mail',
      inputType: TextInputType.emailAddress,
      hintColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkhint
          : AppColors.hintColor,
      // iconColor: _themeStore.darkMode ? Colors.white70 : Colors.black54,
      textController: provider!.signUpEmail,
      inputAction: TextInputAction.next,
      errorBorderColor: emailError
          ? AppColors.errorColor // Border color for validation error
          : AppColors.textInputField,
      focusBorderColor:
          emailError ? AppColors.errorColor : AppColors.focusTextBoarder,
      autoFocus: false,
      onChanged: (value) {
        setState(() {
          emailError = false; // Reset the error flag
        });
        validateEmail(); // Trigger validation on text change
      },
      errorText: emailError ? emailErrorText : " ",
    );
  }

  Widget _buildPasswordField() {
    return TextFieldWidget(
      hint: "Password",
      hintColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkhint
          : AppColors.hintColor,
      isObscure: true,
      padding: const EdgeInsets.only(top: 8.0),
      textController: provider!.signUpPassword,
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
      padding: const EdgeInsets.only(top: 8.0),
      textController: provider!.signUpConfirmPassword,
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

  Widget _buildNotMemberText() {
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Already a member ?",
            style: TextStyle(
              color: AppColors.allHeadColor,
              fontSize: 14,
              fontFamily: FontFamily.satoshi,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
              );
            },
            child: Text(
              " Login now",
              style: TextStyle(
                color: AppColors.dotColor,
                fontSize: 14,
                fontFamily: FontFamily.satoshi,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
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
              text: "Register Now",
              onPressed: () async {
                FocusManager.instance.primaryFocus?.unfocus();
                //SharedPreferences pref = await SharedPreferences.getInstance();
                setState(() {
                  loginError = false;
                });
                validate().then((v) {
                  if (v == true) {
                    value.registerApi().then((val) {
                      if (val['statusCode'] == 200) {
                       Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => VerifyEmailScreen(email: provider!.signUpEmail.text)
                      ),
                    );
                      } else {
                        setState(() {
                          loginError = true;
                          loginErrorMessage = val['message'];
                        });
                      }
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

  // dispose:-------------------------------------------------------------------
  @override
  void dispose() {
    _passwordFocusNode.dispose();

    super.dispose();
  }

  Future<bool> validateName() async {
    var provider = Provider.of<SignInProvider>(context, listen: false);

    setState(() {
      if (provider.signUpName.text.isEmpty) {
        nameError = true;
      } else {
        nameError = false;
      }
    });

    return !nameError;
  }

  Future<bool> validateEmail() async {
    var provider = Provider.of<SignInProvider>(context, listen: false);
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+")
        .hasMatch(provider.signUpEmail.text);

    setState(() {
      if (provider.signUpEmail.text.isEmpty) {
        emailError = true;
        emailErrorText = 'Please enter your email address';
      } else if (!emailValid) {
        emailError = true;
        emailErrorText = 'Entered email is not valid';
      } else {
        emailError = false;
      }
    });

    return !emailError;
  }

  Future<bool> validatePassword() async {
    var provider = Provider.of<SignInProvider>(context, listen: false);

    setState(() {
      if (provider.signUpPassword.text.isEmpty) {
        passwordError = true;
        passwordErrorText = 'Please enter your password';
      } else if (provider.signUpPassword.text.length < 8) {
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
      if (provider.signUpConfirmPassword.text.isEmpty) {
        confirmPasswordError = true;
        confirmPasswordErrorText = 'Please enter confirm password';
      } else if (provider.signUpPassword.text !=
          provider.signUpConfirmPassword.text) {
        confirmPasswordError = true;
        confirmPasswordErrorText = 'Passwords do not match';
      } else {
        confirmPasswordError = false;
      }
    });

    return !confirmPasswordError;
  }

  Future<bool> validate() async {
    bool nameValid = await validateName();
    bool emailValid = await validateEmail();
    bool passwordValid = await validatePassword();
    bool confirmPasswordValid = await validateConfirmPassword();

    return nameValid && emailValid && passwordValid && confirmPasswordValid;
  }
}
