import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tennis_court_booking_app/constants/colors.dart';
import 'package:tennis_court_booking_app/constants/font_family.dart';
import 'package:tennis_court_booking_app/model/login/login_response_model.dart';
import 'package:tennis_court_booking_app/presentation/login/login_screen.dart';
import 'package:tennis_court_booking_app/presentation/login/provider/sign_in_provider.dart';
import 'package:tennis_court_booking_app/sharedPreference/sharedPref.dart';
import 'package:tennis_court_booking_app/widgets/custom_appbar.dart';
import 'package:tennis_court_booking_app/widgets/custom_elevated_button.dart';
import 'package:tennis_court_booking_app/widgets/textfield_widget.dart';

class PasswordChangeScreen extends StatefulWidget {
  final String email;
  const PasswordChangeScreen({super.key, required this.email});

  @override
  PasswordChangeScreenState createState() => PasswordChangeScreenState();
}

class PasswordChangeScreenState extends State<PasswordChangeScreen> {
  //text controllers:-----------------------------------------------------------
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmpassword = TextEditingController();
  final TextEditingController _oldpassword = TextEditingController();

  //predefine bool value for error:---------------------------------------------
  bool emailError = false,
      passwordError = false,
      confirmPasswordError = false,
      oldPassError = false,
      loginError = false;
  String emailErrorText = '',
      passwordErrorText = '',
      loginErrorMessage = '',
      confirmPasswordErrorText = '',
      oldPassErrorText = '';
  bool isEmailValidationSuccessful = false;
  bool isPasswordValidationSuccessful = false;
  LoginResponse? loginResponse;

  //stores:---------------------------------------------------------------------

  //focus node:-----------------------------------------------------------------
  late FocusNode _passwordFocusNode;
  late FocusNode _confirmpasswordFocusNode;
  late FocusNode _oldPassFocusNode;
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

  String? tokens;
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
    _oldPassFocusNode = FocusNode();
    _oldPassFocusNode.addListener(() {
      validateoldPassword();
    });
     profile();
    provider = Provider.of<SignInProvider>(context, listen: false);
   
  }

  Future<void> profile() async {
    String token = await SharePref.fetchAuthToken();
    tokens = await SharePref.fetchAuthToken();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkThemeback
            : AppColors.lightThemeback,
        primary: true,
        appBar: AppBar(
          toolbarHeight: 70,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Container(
              // height: 100,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkAppBarboarder
                    : AppColors.appbarBoarder,
                width: 1.0,
              ))),
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(bottom: 15, top: 5),
                      child: Row(
                        children: [
                          IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              Navigator.pop(context, null);
                            },
                            icon: Image.asset(
                              "assets/images/leftIcon.png",
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? AppColors.headingTextColor
                                  : AppColors.allHeadColor,
                              //width: 18,
                              height: 26,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "Change Password ",
                            style: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? AppColors.headingTextColor
                                  : AppColors.allHeadColor,
                              fontSize: 20,
                              fontFamily: FontFamily.satoshi,
                              fontWeight: FontWeight.w700,
                              height: 28 / 20,
                            ),
                          ),
                          const Spacer(flex: 2)
                        ],
                      )),
                ],
              ),
            ),
          ),
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkTextInput
              : Colors.white,
          elevation: 0,
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
              ? Column(
                  children: [
                    Expanded(child: Center(child: _buildRightSide())),
                    _buildSignInButton()
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

  Widget _buildRightSide() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            _buildCurrentPasswordField(),
            _buildPasswordField(),
            _buildConfirmPasswordField()
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentPasswordField() {
    return TextFieldWidget(
      read: false,
      hint: "Current Password",
      hintColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkhint
          : AppColors.hintColor,
      isObscure: true,
      padding: const EdgeInsets.only(top: 0.0),
      textController: _oldpassword,
      focusNode: _oldPassFocusNode,
      errorBorderColor: oldPassError
          ? AppColors.errorColor // Border color for validation error
          : AppColors.textInputField,
      focusBorderColor:
          oldPassError ? AppColors.errorColor : AppColors.focusTextBoarder,
      onChanged: (value) {
        setState(() {
          oldPassError = false; // Reset the error flag
        });
      },
      errorText: oldPassError ? oldPassErrorText : " ",
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
          hint: "Password",
          hintColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkhint
              : AppColors.hintColor,
          isObscure: true,
          textController: _password,
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
              text: "Update Password",
              isLoading: isLoading,
              onPressed: () async {
                FocusManager.instance.primaryFocus?.unfocus();
                // SharedPreferences pref = await SharedPreferences.getInstance();

                if (await validate()) {
                  setState(() {
                    isLoading = true;
                  });
                  value
                      .changePasswordApi(
                    _oldpassword.text,
                    _password.text,
                    _confirmpassword.text,
                    tokens!,
                  )
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
                        isLoading = false;
                        print(val['errorMessage']);
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
    _confirmpasswordFocusNode.dispose();
    _oldPassFocusNode.dispose();
    super.dispose();
  }

  Future<bool> validatePassword() async {
    final password = _password.text;
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
    setState(() {
      if (_oldpassword.text.isEmpty) {
        oldPassError = true;
        oldPassErrorText = 'Please enter your current password';
      } else {
        oldPassError = false;
      }
    });

    return !oldPassError;
  }

  Future<bool> validateoldPassword() async {
    setState(() {
      if (_confirmpassword.text.isEmpty) {
        confirmPasswordError = true;
        confirmPasswordErrorText = 'Please enter confirm password';
      } else if (_confirmpassword.text != _password.text) {
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
