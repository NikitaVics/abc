import 'package:flutter/material.dart';
import 'package:tennis_court_booking_app/constants/colors.dart';
import 'package:tennis_court_booking_app/constants/font_family.dart';
import 'package:tennis_court_booking_app/widgets/custom_appbar.dart';
import 'package:tennis_court_booking_app/widgets/custom_elevated_button.dart';
import 'package:tennis_court_booking_app/widgets/textfield_widget.dart';

class RegisterForm extends StatefulWidget {
  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  bool emailError = false,
      phoneError = false,
      loginError = false,
      addressError = false,
      nameError = false;
  String emailErrorText = '',
      loginErrorMessage = '',
      phoneErrorText = '',
      addressErrorText = '';
  bool isEmailValidationSuccessful = false;
  bool isPasswordValidationSuccessful = false;
  TextEditingController _userNameController = TextEditingController();

  TextEditingController _userEmailController = TextEditingController();

  TextEditingController _userPhoneController = TextEditingController();

  TextEditingController _userAddressController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkThemeback
            : AppColors.lightThemeback,
        primary: true,
        appBar: const CustomAppBar(
          isBoarder: false,
          title: "Registration Form",
          isProgress: true,
          step: 2,
        ),
        body: _buildBody(),
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
            _buildUserphone(),
            _buildPasswordField(),
            _buildUploadDocumentField(context),
            _buildNotMemberText(),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginText() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Registration",
            style: TextStyle(
              color: AppColors.allHeadColor,
              fontSize: 32,
              fontFamily: FontFamily.satoshi,
              fontWeight: FontWeight.w700,
              height: 40 / 32,
            ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            "form",
            style: TextStyle(
              color: AppColors.allHeadColor,
              fontSize: 32,
              fontFamily: FontFamily.satoshi,
              fontWeight: FontWeight.w700,
              height: 40 / 32,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserName() {
    return TextFieldWidget(
      hint: 'Name',
      inputType: TextInputType.name,
      hintColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkhint
          : AppColors.hintColor,
      // iconColor: _themeStore.darkMode ? Colors.white70 : Colors.black54,
      textController: _userNameController,
      inputAction: TextInputAction.next,
      errorBorderColor: nameError
          ? AppColors.errorColor // Border color for validation error
          : AppColors.textInputField,
      focusBorderColor:
          nameError ? AppColors.errorColor : AppColors.focusTextBoarder,
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
      textController: _userEmailController,
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

  Widget _buildUserphone() {
    return TextFieldWidget(
      hint: 'Phone No.',
      inputType: TextInputType.phone,
      hintColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkhint
          : AppColors.hintColor,
      // iconColor: _themeStore.darkMode ? Colors.white70 : Colors.black54,
      textController: _userPhoneController,
      inputAction: TextInputAction.next,
      errorBorderColor: phoneError
          ? AppColors.errorColor // Border color for validation error
          : AppColors.textInputField,
      focusBorderColor:
          phoneError ? AppColors.errorColor : AppColors.focusTextBoarder,
      autoFocus: false,
      onChanged: (value) {
        setState(() {
          phoneError = false; // Reset the error flag
        });
        validatePhone(); // Trigger validation on text change
      },
      errorText: phoneError ? phoneErrorText : " ",
    );
  }

  Widget _buildPasswordField() {
    return TextFieldWidget(
      hint: "Address",
      hintColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkhint
          : AppColors.hintColor,
      isObscure: false,
      textController: _userAddressController,
      errorBorderColor: addressError
          ? AppColors.errorColor // Border color for validation error
          : AppColors.textInputField,
      focusBorderColor:
          addressError ? AppColors.errorColor : AppColors.focusTextBoarder,
      onChanged: (value) {
        setState(() {
          addressError = false; // Reset the error flag
        });
        validateAddress(); // Trigger validation on text change
      },
      errorText: addressError ? addressErrorText : " ",
    );
  }

  Widget _buildUploadDocumentField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColors.textInputField,
          ),
          height: 164,
          child: Center(
            child: Text(
              "Upload Document",
              style: TextStyle(
                color: AppColors.hintColor,
                fontSize: 14,
                fontFamily: FontFamily.satoshi,
                fontWeight: FontWeight.w400,
                height: 24 / 14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotMemberText() {
    // Set this to the initial state of the checkbox
    bool isHovered = false;
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                isChecked = !isChecked;
              });
            },
            child: MouseRegion(
              onEnter: (_) {
                setState(() {
                  isHovered = true;
                });
              },
              onExit: (_) {
                setState(() {
                  isHovered = false;
                });
              },
              child: Container(
                width: 18, // Set the width as desired
                height: 18, // Set the height as desired
                decoration: BoxDecoration(
                  color: isChecked
                      ? AppColors.dotColor
                      : Colors
                          .transparent, // Background color when checked or unchecked
                  border: Border.all(
                      color: isChecked
                          ? AppColors.dotColor
                          : AppColors.hoverBoarderColor),
                  borderRadius: BorderRadius.circular(2), // Makes it circular
                ),
                child: isChecked
                    ? Icon(
                        Icons.check,
                        weight: 18,
                        size: 16, // Adjust the size of the checkmark icon
                        color: Colors.white, // Checkmark color when checked
                      )
                    : null,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            "Accept ",
            style: TextStyle(
                color: AppColors.allHeadColor,
                fontSize: 14,
                fontFamily: FontFamily.satoshi,
                fontWeight: FontWeight.w700,
                height: 24 / 14),
          ),
          Text(
            "terms and condition",
            style: TextStyle(
                decoration: TextDecoration.underline,
                decorationThickness: 2.0,
                color: AppColors.dotColor,
                fontSize: 14,
                fontFamily: FontFamily.satoshi,
                fontWeight: FontWeight.w700,
                height: 24 / 14),
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
          child: CustomElevatedButton(
            height: 60,
            width: MediaQuery.of(context).orientation == Orientation.landscape
                ? 70
                : double.infinity,
            text: "Register Now",
            onPressed: () async {
              FocusManager.instance.primaryFocus?.unfocus();
              //SharedPreferences pref = await SharedPreferences.getInstance();
              bool nameValid = await validateName();
              bool emailValid = await validateEmail();
              bool phoneValid = await validatePhone();
              bool addressValid = await validateAddress();
              if (nameValid && emailValid && phoneValid && addressValid) {
                print("yes");
              }
            },
            buttonColor: AppColors.elevatedColor,
            textColor: Colors.white,
          ),
        ),
      ),
    );
  }

  // dispose:-------------------------------------------------------------------
  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    _userNameController.dispose();
    _userEmailController.dispose();
    _userPhoneController.dispose();
    _userAddressController.dispose();

    // _passwordFocusNode.dispose();

    super.dispose();
  }

  Future<bool> validateName() async {
    // var provider = Provider.of<SignInProvider>(context, listen: false);

    setState(() {
      if (_userNameController.text.isEmpty) {
        nameError = true;
      } else {
        nameError = false;
      }
    });

    return !nameError;
  }

  Future<bool> validateEmail() async {
    // var provider = Provider.of<SignInProvider>(context, listen: false);
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+")
        .hasMatch(_userEmailController.text);

    setState(() {
      if (_userEmailController.text.isEmpty) {
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

  Future<bool> validatePhone() async {
    // var provider = Provider.of<SignInProvider>(context, listen: false);

    setState(() {
      if (_userPhoneController.text.isEmpty) {
        phoneError = true;
        phoneErrorText = 'Please enter your phone number';
      } else {
        phoneError = false;
      }
    });

    return !phoneError;
  }

  Future<bool> validateAddress() async {
    // var provider = Provider.of<SignInProvider>(context, listen: false);

    setState(() {
      if (_userAddressController.text.isEmpty) {
        addressError = true;
        addressErrorText = 'Please enter your address';
      } else {
        addressError = false;
      }
    });

    return !addressError;
  }
}
