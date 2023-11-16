import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:tennis_court_booking_app/constants/colors.dart';
import 'package:tennis_court_booking_app/constants/font_family.dart';
import 'package:tennis_court_booking_app/presentation/login/provider/sign_in_provider.dart';
import 'package:tennis_court_booking_app/presentation/register/pageview/congrats_screen.dart';
import 'package:tennis_court_booking_app/widgets/custom_appbar.dart';
import 'package:tennis_court_booking_app/widgets/custom_elevated_button.dart';
import 'package:tennis_court_booking_app/widgets/dateTextField.dart';
import 'package:tennis_court_booking_app/widgets/textfield_widget.dart';
import 'package:intl/intl.dart';

class RegisterForm extends StatefulWidget {
  final String email;

  const RegisterForm({super.key, required this.email});
  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  bool emailError = false,
      phoneError = false,
      loginError = false,
      addressError = false,
      dobError = false,
      nameError = false,
      isLoading = false;

  String emailErrorText = '',
      loginErrorMessage = '',
      phoneErrorText = '',
      addressErrorText = '';
  bool isEmailValidationSuccessful = false;
  bool isPasswordValidationSuccessful = false;
  TextEditingController _userNameController = TextEditingController();

  TextEditingController _userEmailController = TextEditingController();

  TextEditingController _userDobController = TextEditingController();

  TextEditingController _userPhoneController = TextEditingController();

  TextEditingController _userAddressController = TextEditingController();
  late FocusNode _dobFocusNode;
  @override
  void initState() {
    super.initState();
    _userEmailController.text = widget.email;
    _dobFocusNode = FocusNode();
    _dobFocusNode.addListener(() {
      validateDOB();
    });
  }

  DateTime? dateTime;
  bool isChecked = false;
  File? imageFile;
  DateTime? result;

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
              title: "Registration Form",
              isProgress: true,
              step: 2,
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
            _buildUserDOB(),
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
      read: false,
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

  Widget _buildUserDOB() {
    return DateTextFieldWidget(
      read: false,
      hint: 'DOB',
      inputType: TextInputType.none,
      focusNode: _dobFocusNode,
      hintColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkhint
          : AppColors.hintColor,
      // iconColor: _themeStore.darkMode ? Colors.white70 : Colors.black54,
      textController: _userDobController,
      inputAction: TextInputAction.next,
      errorBorderColor: dobError
          ? AppColors.errorColor // Border color for validation error
          : AppColors.textInputField,
      focusBorderColor:
          dobError ? AppColors.errorColor : AppColors.focusTextBoarder,
      autoFocus: false,
      onSuffixIconPressed: () async {
        FocusScope.of(context).requestFocus(_dobFocusNode);
        result = await showDatePicker(
          context: context,
          initialDate: dateTime ?? DateTime.now(),
          firstDate: DateTime(1950),
          lastDate: DateTime(2101),
          helpText: "Select Date",
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: ThemeData.light().copyWith(
                primaryColor: AppColors.darkSubHead,
                hintColor: Colors.teal,
                colorScheme:
                    const ColorScheme.light(primary: AppColors.dotColor)
                        .copyWith(background: Colors.blueGrey),
              ),
              child: child!,
            );
          },
        );
        if (result != null) {
          setState(() {
            dateTime = result;
            _userDobController.text = DateFormat('dd/MM/yyyy').format(result!);

            print(result!.toLocal().toString());
          });
        }
      },
      onChanged: (value) {
        setState(() {
          dobError = false; // Reset the error flag
        });
        validateDOB(); // Trigger validation on text change
      },
      errorText: dobError ? "Please enter DOB" : " ",
      isIcon: true,
    );
  }

  Widget _buildUserIdField() {
    return TextFieldWidget(
      read: true,
      hint: 'E-Mail',
      inputType: TextInputType.emailAddress,
      hintColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkhint
          : AppColors.hintColor,
      // iconColor: _themeStore.darkMode ? Colors.white70 : Colors.black54,
      textController: _userEmailController,
      inputAction: TextInputAction.next,
      defaultBoarder: AppColors.textInputField,
      errorBorderColor: AppColors.textInputField,
      focusBorderColor: AppColors.textInputField,
      autoFocus: false,

      errorText: " ",
    );
  }

  Widget _buildUserphone() {
    return TextFieldWidget(
      read: false,
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
      read: false,
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
      child: imageFile != null
          ? Stack(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    height: 164,
                    child: SingleChildScrollView(
                      child: Image.file(
                        imageFile!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10, // Adjust the top position as needed
                  right: 10, // Adjust the right position as needed
                  child: IconButton(
                    icon: Icon(Icons.close), // You can choose a different icon
                    onPressed: () {
                      // Handle the delete action here
                      // For example, you can set imageFile to null to remove the image
                      setState(() {
                        imageFile = null;
                      });
                    },
                  ),
                ),
              ],
            )
          : GestureDetector(
              onTap: () async {
                Map<Permission, PermissionStatus> statuses = await [
                  Permission.storage,
                  Permission.camera,
                ].request();
                if (statuses[Permission.storage]!.isGranted &&
                    statuses[Permission.camera]!.isGranted) {
                  showImagePicker(context);
                } else {}
              },
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
                    ? const Icon(
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
          child: Consumer<SignInProvider>(builder: (context, value, child) {
            return SizedBox(
              height: 60,
              width: MediaQuery.of(context).orientation == Orientation.landscape
                  ? 70
                  : double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1.0,
                      color: AppColors.elevatedColor,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  disabledBackgroundColor: AppColors.disableButtonColor,
                  disabledForegroundColor: AppColors.disableButtonTextColor,
                  backgroundColor: AppColors
                      .elevatedColor, // Change background color on hover
                ),
                onPressed: isChecked
                    ? () async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        bool nameValid = await validateName();

                        bool phoneValid = await validatePhone();
                        bool addressValid = await validateAddress();
                        bool dobValid = await validateDOB();
                        setState(() {
                          isLoading = true;
                        });
                        if (nameValid &&
                            phoneValid &&
                            addressValid &&
                            dobValid &&
                            isChecked ) {
                          
                          print("result ${result!}");
                          value
                              .registerFormApi(
                                  _userEmailController.text,
                                  _userNameController.text,
                                  _userPhoneController.text,
                                  result!.toUtc().toIso8601String(),
                                  _userAddressController.text,
                                  imageFile!.path)
                              .then((val) {
                            if (val['statusCode'] == 200) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const CongratsScreen()),
                              );
                              setState(() {
                                isLoading = false;
                              });
                              print("yup");
                            } else {
                              setState(() {
                                isLoading = false;
                              });
                              print("false");
                            }
                          });
                        }
                      }
                    : null,
                child: isLoading
                    ? const SizedBox(
                        height: 24,
                        child: SpinKitThreeBounce(
                          // Use the spinner from Spinkit you prefer

                          color: Colors.white,
                          size: 24.0,
                        ),
                      )
                    : const Text(
                        "Register Now",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: FontFamily.satoshi,
                          fontWeight: FontWeight.w700,
                          height: 24 / 14,
                        ),
                      ),
              ),
            );
          }),

          /*CustomElevatedButton(
            isLoading: false,
            height: 60,
            width: MediaQuery.of(context).orientation == Orientation.landscape
                ? 70
                : double.infinity,
            text: "Register Now",
            onPressed: () async {
              FocusManager.instance.primaryFocus?.unfocus();
              bool nameValid = await validateName();
              bool emailValid = await validateEmail();
              bool phoneValid = await validatePhone();
              bool addressValid = await validateAddress();
              bool dobValid = await validateDOB();
              if (nameValid &&
                  emailValid &&
                  phoneValid &&
                  addressValid &&
                  dobValid && isChecked) {
                print("yes");
              }
            },
            buttonColor: AppColors.elevatedColor,
            textColor: Colors.white,
          ),*/
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
    _dobFocusNode.dispose();

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

  Future<bool> validateDOB() async {
    setState(() {
      // Check for an empty DOB only if the field loses focus
      dobError =
          _dobFocusNode.hasFocus ? false : _userDobController.text.isEmpty;
    });

    return !dobError;
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

  final picker = ImagePicker();

  void showImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Card(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 5.2,
            margin: const EdgeInsets.only(top: 8.0),
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: InkWell(
                    child: Container(
                        height: 135,
                        color: const Color(0xffF3F3F3),
                        padding: const EdgeInsets.all(16.0),
                        child:
                            Center(child: Icon(Icons.browse_gallery_outlined))),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.pop(context);
                    },
                  ),
                ),
                Container(
                  height: 135, // Adjust the height as needed
                  width: 1, // Adjust the width as needed
                  color: Colors.black,
                ),
                Expanded(
                  child: InkWell(
                    child: Container(
                        height: 135,
                        color: const Color(0xffF3F3F3),
                        padding: const EdgeInsets.all(16.0),
                        child: Center(child: Icon(Icons.camera))),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _imgFromGallery() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  _imgFromCamera() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }
}
