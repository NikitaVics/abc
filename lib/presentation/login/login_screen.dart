import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tennis_court_booking_app/api/api.dart';
import 'package:tennis_court_booking_app/constants/colors.dart';
import 'package:tennis_court_booking_app/constants/font_family.dart';
import 'package:tennis_court_booking_app/presentation/login/provider/sign_in_provider.dart';
import 'package:tennis_court_booking_app/presentation/register/register.dart';
import 'package:tennis_court_booking_app/theme/theme_manager.dart';
import 'package:tennis_court_booking_app/widgets/custom_appbar.dart';
import 'package:tennis_court_booking_app/widgets/custom_elevated_button.dart';
import 'package:tennis_court_booking_app/widgets/textfield_widget.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //text controllers:-----------------------------------------------------------

  //predefine bool value for error:---------------------------------------------
  bool emailError = false, passwordError = false, loginError = false;
  String emailErrorText = '', loginErrorMessage = '';

  //stores:---------------------------------------------------------------------

  //focus node:-----------------------------------------------------------------
  late FocusNode _passwordFocusNode;
  SignInProvider? provider;

  @override
  void initState() {
    super.initState();
    _passwordFocusNode = FocusNode();
    provider = Provider.of<SignInProvider>(context, listen: false);
  }
 
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Scaffold(
          backgroundColor:Theme.of(context).brightness == Brightness.dark? AppColors.darkThemeback:AppColors.lightThemeback,
          primary: true,
          appBar: const CustomAppBar(
            isBoarder: true,
            title: "Login",
          ),
          body: _buildBody(),
        );
      }
    );
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Material(
      color: Theme.of(context).brightness == Brightness.dark? AppColors.darkThemeback:AppColors.lightThemeback,
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
            const SizedBox(height: 24.0),
            _buildUserIdField(),
            _buildPasswordField(),
            _buildForgotPasswordButton(),
            _buildNotMemberText(),
            
          ],
        ),
      ),
    );
  }

  Widget _buildLoginText() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Log In",
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
        ),
        
      ],
    );
  }

  Widget _buildUserIdField() {
    return TextFieldWidget(
      hint: 'E-mail',
      inputType: TextInputType.emailAddress,

      // iconColor: _themeStore.darkMode ? Colors.white70 : Colors.black54,
      textController: provider!.userEmailController,
      inputAction: TextInputAction.next,
      autoFocus: false,
      onChanged: (value) {
        // _formStore.setUserId(_userEmailController.text);
      },
      onFieldSubmitted: (value) {
        FocusScope.of(context).requestFocus(_passwordFocusNode);
      },
      errorText: emailError ? emailErrorText : " ",
    );
  }

  Widget _buildPasswordField() {
    return TextFieldWidget(
      hint: "",
      //AppLocalizations.of(context).translate('login_et_user_password'),
      isObscure: true,
      padding: const EdgeInsets.only(top: 8.0),
      textController: provider!.passwordController,
      focusNode: _passwordFocusNode,
      errorText: passwordError ? "please enter your password" : " ",

      onChanged: (value) {
        // _formStore.setPassword(_passwordController.text);
      },
    );
  }

  Widget _buildForgotPasswordButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MaterialButton(
          padding: const EdgeInsets.all(0.0),
          child: const Text("Forgot Passward?",
              style: TextStyle(
                  color: AppColors.forgotpass,
                  fontSize: 14,
                  fontFamily: FontFamily.satoshi,
                  fontWeight: FontWeight.w500,
                  height: 24 / 14)),
          onPressed: () {},
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
          onPressed: () {},
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
          const Text(
            "Not a member ?",
            style: TextStyle(
              color: AppColors.allHeadColor,
              fontSize: 14,
              fontFamily: FontFamily.satoshi,
              fontWeight: FontWeight.w500,
            ),
          ),
          MaterialButton(
            padding: const EdgeInsets.all(0.0),
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
      builder: (context) =>  RegisterScreen(),
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
            return CustomElevatedButton(
              height: 60,
              width: MediaQuery.of(context).orientation == Orientation.landscape
                  ? 70
                  : double.infinity,
              text: "Login Now",
              onPressed: () async {
                FocusManager.instance.primaryFocus?.unfocus();
                SharedPreferences pref = await SharedPreferences.getInstance();
                setState(() {
                  loginError = false;
                });
                validate().then((v) {
                  if (v == true) {
                    value.loginApi().then((val) {
                      if (val['statusCode'] == 200) {
                        setState(() {
                          loginError = false;
                        });
                        pref.setString('authToken', val['result']['token']);
                        String? authToken = pref.getString('authToken');
if (authToken != null) {
  print("Auth Token: $authToken");
} else {
  print("Auth Token is not set.");
}

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

  // General Methods:-----------------------------------------------------------

  // dispose:-------------------------------------------------------------------
  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree

    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<bool> validate() async {
    var provider = Provider.of<SignInProvider>(context, listen: false);
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+")
        .hasMatch(provider.userEmailController.text);
    setState(() {
      if (provider.userEmailController.text.isEmpty) {
        emailError = true;
        emailErrorText = 'Please enter your email address';
      } else {
        emailError = false;
      }
      if (provider.passwordController.text.isEmpty) {
        passwordError = true;
      } else {
        passwordError = false;
      }
    });
    return emailError || passwordError ? false : true;
  }
}
