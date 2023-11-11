// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tennis_court_booking_app/constants/colors.dart';
import 'package:tennis_court_booking_app/constants/font_family.dart';
import 'package:tennis_court_booking_app/presentation/login/login_screen.dart';
import 'package:tennis_court_booking_app/presentation/login/provider/sign_in_provider.dart';
import 'package:tennis_court_booking_app/presentation/register/pageview/congrats_screen.dart';
import 'package:tennis_court_booking_app/presentation/register/pageview/register_form.dart';
import 'package:tennis_court_booking_app/presentation/register/verifyemail/verify_email.dart';
import 'package:tennis_court_booking_app/widgets/animated_toast.dart';
import 'package:tennis_court_booking_app/widgets/custom_appbar.dart';
import 'package:tennis_court_booking_app/widgets/custom_elevated_button.dart';
import 'package:tennis_court_booking_app/widgets/step_progress_indicator.dart';
import 'package:tennis_court_booking_app/widgets/textfield_widget.dart';

class RegisterAsMember extends StatefulWidget {
  const RegisterAsMember({super.key});

  @override
  State<RegisterAsMember> createState() => _RegisterAsMemberState();
}

class _RegisterAsMemberState extends State<RegisterAsMember> {
  TextEditingController _nameController = TextEditingController();

  TextEditingController _emailController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  TextEditingController _confirmpassController = TextEditingController();
  late FocusNode _passwordFocusNode;
  late FocusNode _userNameFocusNode;
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
  bool isLoading = false;
  SignInProvider? provider;
  bool shouldAllowBack =
      true; // Set it to true initially or based on your initial conditions

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

  bool isUserNameValid(String name) {
    // Define regular expressions for each condition
    final uppercaseRegex = RegExp(r'[a-z]');
    return uppercaseRegex.hasMatch(name);
  }

  bool _isMenuVisible = false;
  bool isMenu = false;
  @override
  void initState() {
    super.initState();
    _passwordFocusNode = FocusNode();
    _passwordFocusNode.addListener(() {
      setState(() {
        _isMenuVisible = _passwordFocusNode.hasFocus;
      });
    });
    _userNameFocusNode = FocusNode();
    _userNameFocusNode.addListener(() {
      setState(() {
        isMenu = _userNameFocusNode.hasFocus;
      });
    });

    _confirmpasswordFocusNode = FocusNode();
    _confirmpasswordFocusNode.addListener(() {
      validateConfirmPassword();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return WillPopScope(
        onWillPop: () async {
          return false; // Prevent going back
        },
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkThemeback
                : AppColors.lightThemeback,
            primary: true,
            appBar: const CustomAppBar(
              isBoarder: false,
              title: "Register as Member",
              isProgress: true,
              step: 1,
            ),
            body: _buildBody(),
          ),
        ),
      );
    });
  }

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
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          //mainAxisAlignment: MainAxisAlignment.center,
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
    final name = _nameController.text;
    final nameConditions = isUserNameValid(name);

    return Column(
      children: [
        TextFieldWidget(
          read: false,
          hint: 'User Name',
          inputType: TextInputType.name,
          hintColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkhint
              : AppColors.hintColor,
          focusNode: _userNameFocusNode,
          // iconColor: _themeStore.darkMode ? Colors.white70 : Colors.black54,
          textController: _nameController,
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
        ),
        if (_userNameFocusNode.hasFocus)
          Visibility(
            visible: !nameConditions,
            child: Card(
              color: AppColors.textInputField,
              child: Column(
                children: [
                  const SizedBox(
                    height: 5,
                  ),
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
                              color: nameConditions
                                  ? AppColors.dotColor
                                  : AppColors.errorColor,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Center(
                              child: Icon(
                                nameConditions ? Icons.check : Icons.clear,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text("Must be in lowerCase"),
                        ],
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  // Add your menu items here
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildUserIdField() {
    return TextFieldWidget(
      read: false,
      hint: 'E-Mail',
      inputType: TextInputType.emailAddress,
      hintColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkhint
          : AppColors.hintColor,
      // iconColor: _themeStore.darkMode ? Colors.white70 : Colors.black54,
      textController: _emailController,
      // inputAction: TextInputAction.next,
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
    final password = _passwordController.text;
    final passwordConditions = isPasswordValid(password);
    final isPasswordValids = passwordConditions.every((condition) => condition);

    return Column(
      children: [
        TextFieldWidget(
          read: false,
          hint: "Password",
          hintColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkhint
              : AppColors.hintColor,
          isObscure: true,
          textController: _passwordController,
          focusNode: _passwordFocusNode,
          errorText: passwordError ? "Please enter valid password" : " ",
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
              color: AppColors.textInputField,
              child: Column(
                children: [
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
        return "At least 8 characters";
      case 1:
        return "Contains lowercase letter";
      case 2:
        return "Contains uppercase letter";
      case 3:
        return "Contains at least 1 number";
      case 4:
        return "Contains special character";
      default:
        return "";
    }
  }

  Widget _buildConfirmPasswordField() {
    return TextFieldWidget(
      read: false,
      hint: "Confirm Password",
      hintColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkhint
          : AppColors.hintColor,
      isObscure: true,
      padding: const EdgeInsets.only(top: 8.0),
      textController: _confirmpassController,
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
              isLoading: isLoading,
              onPressed: () async {
                FocusManager.instance.primaryFocus?.unfocus();
                //SharedPreferences pref = await SharedPreferences.getInstance();
                bool nameValid = await validateName();
                bool emailValid = await validateEmail();
                bool passwordValid = await validatePassword();
                bool confirmPasswordValid = await validateConfirmPassword();

                if (nameValid &&
                    emailValid &&
                    passwordValid &&
                    confirmPasswordValid) {
                  setState(() {
                    isLoading = true;
                  });
                  value.registerApi(_emailController.text,_nameController.text,_passwordController.text,_confirmpassController.text).then((val) {
                    if (val['statusCode'] == 200) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => VerifyEmailScreen(
                                  email: _emailController.text,
                                 
                                )),
                      );
                      setState(() {
                        isLoading = false;
                      });
                    } else {
                      setState(() {
                        isLoading = false;
                         AnimatedToast.showToastMessage(
                        context,
                        val["errorMessage"][0],
                        const Color.fromRGBO(87, 87, 87, 0.93),
                      );
                      });
                      print("false");
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

  // dispose:-------------------------------------------------------------------
  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _confirmpasswordFocusNode.dispose();
    _userNameFocusNode.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpassController.dispose();

    super.dispose();
  }

  Future<bool> validateName() async {
    final name = _nameController.text;
    bool passwordConditions = isUserNameValid(name);

    setState(() {
      if (name.isEmpty) {
        nameError = true;
      } else if (!passwordConditions) {
        nameError = true;
      } else {
        nameError = false;
      }
    });

    return !nameError;
  }

  Future<bool> validateEmail() async {
     final email = _emailController.text;
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+")
        .hasMatch(email);

    setState(() {
      if (email.isEmpty) {
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
    
    final password = _passwordController.text;
    final passwordConditions = isPasswordValid(password);
    bool isPasswordValids = passwordConditions.every((condition) => condition);
    setState(() {
      if (!isPasswordValids) {
        passwordError = true;
      } else {
        passwordError = false;
      }
    });

    return !passwordError;
  }

  Future<bool> validateConfirmPassword() async {
    final confirmpass = _confirmpassController.text;

    setState(() {
      if (confirmpass.isEmpty) {
        confirmPasswordError = true;
        confirmPasswordErrorText = 'Please enter confirm password';
      } else if (confirmpass !=
          _passwordController.text) {
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
