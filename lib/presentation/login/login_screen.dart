import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tennis_court_booking_app/bottomnavbar/bottom_navbar.dart';

import 'package:tennis_court_booking_app/constants/colors.dart';
import 'package:tennis_court_booking_app/constants/font_family.dart';
import 'package:tennis_court_booking_app/model/login/login_response_model.dart';
import 'package:tennis_court_booking_app/notifications/notification_service.dart';
import 'package:tennis_court_booking_app/presentation/forgotPassword/forgot_pass_using_otp.dart';
import 'package:tennis_court_booking_app/presentation/forgotPassword/otp_send_screen.dart';
import 'package:tennis_court_booking_app/presentation/home/home_screen.dart';
import 'package:tennis_court_booking_app/presentation/login/loginwithotp/login_email_forotp.dart';
import 'package:tennis_court_booking_app/presentation/login/provider/sign_in_provider.dart';
import 'package:tennis_court_booking_app/presentation/register/pageview/register_as_member.dart';
import 'package:tennis_court_booking_app/presentation/register/register.dart';
import 'package:tennis_court_booking_app/widgets/animated_toast.dart';

import 'package:tennis_court_booking_app/widgets/custom_appbar.dart';
import 'package:tennis_court_booking_app/widgets/custom_elevated_button.dart';
import 'package:tennis_court_booking_app/widgets/textfield_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  //text controllers:-----------------------------------------------------------
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  //predefine bool value for error:---------------------------------------------
  bool emailError = false, passwordError = false, loginError = false;
  String emailErrorText = '', loginErrorMessage = '';
  bool isEmailValidationSuccessful = false;
  bool isPasswordValidationSuccessful = false;
  LoginResponse? loginResponse;
  bool isLoading = false;

  //stores:---------------------------------------------------------------------

  //focus node:-----------------------------------------------------------------
  late FocusNode _passwordFocusNode;
  SignInProvider? provider;
  String? error;
  String? devToken;
  NotificationServices notificationServices = NotificationServices();
  @override
  void initState() {
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit();
    //notificationServices.isTokenRefresh();
    notificationServices.getDeviceToken().then((value) async {
      devToken = value;
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('deviceToken', value);
      print('device token');
      print(value);
    });
    _passwordFocusNode = FocusNode();

    provider = Provider.of<SignInProvider>(context, listen: false);
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    email.clear(); // Clear email text
    password.clear(); // Clear password text
    _passwordFocusNode.dispose();
    provider!.dispose(); // Dispose of the SignInProvider
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return WillPopScope(
        onWillPop: () async {
          return false;
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
               isIcon: false,
              isBoarder: true,
              title: "Login",
              isProgress: false,
              step: 0,
            ),
            body: _buildBody(),
          ),
        ),
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
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildLoginText(),
            const SizedBox(height: 24.0),
            _buildUserIdField(),
            _buildPasswordField(),
            // _passwordValidator(),
            _buildForgotPasswordButton(),
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
          "Login",
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
        const SizedBox(height: 8.0),
        Row(
          children: [
            Text(
              "If You Need Any Support",
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkSubHead
                    : AppColors.subheadColor,
                fontSize: 12,
                fontFamily: FontFamily.satoshi,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Text(
              " Click Here",
              style: TextStyle(
                color: AppColors.dotColor,
                fontSize: 12,
                fontFamily: FontFamily.satoshi,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUserIdField() {
    return TextFieldWidget(
      read:isLoading?true: false,
      hint: 'E-Mail',
      inputType: TextInputType.emailAddress,
      hintColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkhint
          : AppColors.hintColor,
      // iconColor: _themeStore.darkMode ? Colors.white70 : Colors.black54,
      textController: email,
      inputAction: TextInputAction.next,
      defaultBoarder: AppColors.textInputField,
      errorBorderColor: emailError
          ? AppColors.errorColor // Border color for validation error
          : AppColors.confirmValid,
      focusBorderColor:
          emailError ? AppColors.errorColor : AppColors.focusTextBoarder,
      autoFocus: false,
      onChanged: (value) {
        setState(() {
          emailError = false; // Reset the error flag
        });
        //validateEmail(); // Trigger validation on text change
      },
      errorText: emailError ? emailErrorText : " ",
    );
  }

  Widget _buildPasswordField() {
    return TextFieldWidget(
      read:     isLoading?true: false,

      hint: "Password",
      hintColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkhint
          : AppColors.hintColor,
      isObscure: true,
      textController: password,
      focusNode: _passwordFocusNode,
      errorText: passwordError ? "Please enter your password" : " ",
      defaultBoarder: AppColors.textInputField,
      errorBorderColor: AppColors.errorColor,
      focusBorderColor:
          passwordError ? AppColors.errorColor : AppColors.focusTextBoarder,
      onChanged: (value) {
        setState(() {
          passwordError = false; // Reset the error flag
        });
      },
    );
  }

  Widget _buildForgotPasswordButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MaterialButton(
          padding: const EdgeInsets.all(0.0),
          child: const Text("Forgot Password?",
              style: TextStyle(
                  color: AppColors.forgotpass,
                  fontSize: 14,
                  fontFamily: FontFamily.satoshi,
                  fontWeight: FontWeight.w500,
                  height: 24 / 14)),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const OtpSendScreen(),
              ),
            );
          },
        ),
        MaterialButton(
          padding: const EdgeInsets.all(0.0),
          child: const Text("Login with OTP",
              style: TextStyle(
                  color: AppColors.forgotpass,
                  fontSize: 14,
                  fontFamily: FontFamily.satoshi,
                  fontWeight: FontWeight.w500,
                  height: 24 / 14)),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const LoginEmailForotpScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildNotMemberText() {
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
         
          TextButton(
            child:   Text(
            "Not a member ?",
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkSubHead
                  : AppColors.subheadColor,
              fontSize: 14,
              fontFamily: FontFamily.satoshi,
              fontWeight: FontWeight.w500,
            ),
          ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const RegisterAsMember(),
                ),
              );
            },
          ),
          TextButton(
            child: const Text("Register now",
                style: TextStyle(
                    color: AppColors.forgotpass,
                    fontSize: 14,
                    fontFamily: FontFamily.satoshi,
                    fontWeight: FontWeight.w500,
                    height: 24 / 14)),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const RegisterAsMember(),
                ),
              );
            },
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
            void loginButtonPressed() async {
              FocusManager.instance.primaryFocus?.unfocus();
              SharedPreferences pref = await SharedPreferences.getInstance();
              setState(() {
                loginError = false;
              });

              if (await validate()) {
                setState(() {
                  isLoading = true;
                });
                value
                    .loginApi(
                  email.text,
                  password.text,
                devToken!
                )
                    .then((val) {
                  if (val != null && val["statusCode"] == 200) {
                    pref.setString('authToken', val['result']['token']);
                    pref.setString('email', val['result']['user']['email']);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BottomNavBar(
                                  initial: 0,
                                )));
                    String? authToken = pref.getString('authToken');
                    if (authToken != null) {
                      print("Auth Token: $authToken");
                    } else {
                      print("Auth Token is not set.");
                    }
                    setState(() {
                      isLoading = false;
                    });
                  } else {
                    setState(() {
                      if (val != null) {
                        loginError = true;
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
            }

            return CustomElevatedButton(
              height: 60,
              width: MediaQuery.of(context).orientation == Orientation.landscape
                  ? 70
                  : double.infinity,
              isLoading: isLoading,
              text: "Login",
              onPressed:
                  passwordError & emailError ? () {} : loginButtonPressed,
              buttonColor: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.darkEditColor
                              : AppColors.elevatedColor,
              textColor: Colors.white,
            );
          }),
        ),
      ),
    );
  }

  // General Methods:-----------------------------------------------------------

  Future<bool> validate() async {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+")
        .hasMatch(email.text);
    final passwords = password.text;

    setState(() {
      if (email.text.isEmpty) {
        emailError = true;
        emailErrorText = 'Please enter your email address or username';
      } else if (email.text != email.text.toLowerCase()) {
        emailError = true;
        emailErrorText = 'Entered email or username is not valid';
      } else {
        emailError = false;
      }
      if (passwords.isEmpty) {
        passwordError = true;
      } else {
        passwordError = false;
      }
    });
    return emailError || passwordError ? false : true;
  }
}
