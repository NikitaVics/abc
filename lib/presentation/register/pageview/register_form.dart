import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:tennis_court_booking_app/constants/colors.dart';
import 'package:tennis_court_booking_app/constants/font_family.dart';
import 'package:tennis_court_booking_app/presentation/login/provider/sign_in_provider.dart';
import 'package:tennis_court_booking_app/presentation/register/pageview/congrats_screen.dart';
import 'package:tennis_court_booking_app/presentation/register/verifyemail/verify_email.dart';
import 'package:tennis_court_booking_app/widgets/custom_appbar.dart';
import 'package:tennis_court_booking_app/widgets/custom_elevated_button.dart';
import 'package:tennis_court_booking_app/widgets/dateTextField.dart';
import 'package:tennis_court_booking_app/widgets/genderField.dart';
import 'package:tennis_court_booking_app/widgets/prefixphone.dart';
import 'package:tennis_court_booking_app/widgets/textfield_noneditable.dart';
import 'package:tennis_court_booking_app/widgets/textfield_widget.dart';
import 'package:intl/intl.dart';

class RegisterForm extends StatefulWidget {
  final String email;
  final String password;

  const RegisterForm({super.key, required this.email, required this.password});
  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  bool emailError = false,
      phoneError = false,
      phoneprefixError = false,
      loginError = false,
      addressError = false,
      dobError = false,
      nameError = false,
      genderError = false,
      isLoading = false,
      ageError = false;

  String emailErrorText = '',
      loginErrorMessage = '',
      phoneErrorText = '',
      phoneprefixErrorText = '',
      generErrorText = '',
      addressErrorText = '',
      ageErrorText = '';
  bool isEmailValidationSuccessful = false;
  bool isPasswordValidationSuccessful = false;
  TextEditingController _userNameController = TextEditingController();

  TextEditingController _userEmailController = TextEditingController();

  TextEditingController _userDobController = TextEditingController();

  TextEditingController _userPhoneController = TextEditingController();

  TextEditingController _userAddressController = TextEditingController();
  final TextEditingController phonePrefixController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  late FocusNode _dobFocusNode;
  late FocusNode _genderNode;
  late FocusNode _ageNode;
  late FocusNode _phonePrefixNode;
  @override
  void initState() {
    super.initState();
    _userEmailController.text = widget.email;
    _dobFocusNode = FocusNode();
    _genderNode = FocusNode();
    _ageNode = FocusNode();

    _phonePrefixNode = FocusNode();

    _dobFocusNode.addListener(() {
      validateDOB();
    });
  }

  bool showDocumentErrorMessage = false;
  bool showDErrorMessage = false;
  DateTime? dateTime;
  bool isChecked = false;
  File? imageFile;
  File? imageFiles;
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
              isIcon: true,
              isBoarder: false,
              title: "Register as Member",
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
    return AbsorbPointer(
      absorbing: isLoading,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 6.0),
              _buildLoginText(),
              SizedBox(height: 24.0),
              _buildUserName(),
              //_buildUserIdField(),
      
              // _buildUserDOB(),
              _buildUserphone(),
              _buildUserGender(),
              // _buildPasswordField(),
              //_buildUploadDocumentField(context),
              // _buildNotMemberText(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginText() {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        "Tell Us About You",
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
    );
  }

  Widget _buildUserName() {
    return TextFieldWidget(
      read: false,
      hint: 'Full Name',
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

  Widget _buildUserGender() {
    return Row(
      children: [
        Expanded(
          child: GenderTextFieldWidget(
            read: false,
            hint: 'Age',
            inputType: TextInputType.none,
            focusNode: _ageNode,
            hintColor: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkhint
                : AppColors.hintColor,
            // iconColor: _themeStore.darkMode ? Colors.white70 : Colors.black54,
            textController: ageController,
            inputAction: TextInputAction.next,
            errorBorderColor: ageError
                ? AppColors.errorColor // Border color for validation error
                : AppColors.textInputField,
            focusBorderColor:
                ageError ? AppColors.errorColor : AppColors.focusTextBoarder,
            autoFocus: false,
            onSuffixIconPressed: () async {
              FocusScope.of(context).requestFocus(_ageNode);
              String? selectedAge = await showAgeMenu(context);

              if (selectedAge != null) {
                setState(() {
                  ageController.text = selectedAge;
                  ageError = false;
                   validateAge(); // Reset the error flag
                });
              }
            },
            onChanged: (value) {
              
            },

            errorText: ageError ? "Please enter age" : " ",
            isIcon: true,
          ),
        ),
        SizedBox(
          width: 19,
        ),
        Expanded(
          child: GenderTextFieldWidget(
            read: false,
            hint: 'Gender',
            inputType: TextInputType.none,
            focusNode: _genderNode,
            hintColor: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkhint
                : AppColors.hintColor,
            // iconColor: _themeStore.darkMode ? Colors.white70 : Colors.black54,
            textController: genderController,
            inputAction: TextInputAction.next,
            errorBorderColor: genderError
                ? AppColors.errorColor // Border color for validation error
                : AppColors.textInputField,
            focusBorderColor:
                genderError ? AppColors.errorColor : AppColors.focusTextBoarder,
            autoFocus: false,
            onSuffixIconPressed: () async {
              FocusScope.of(context).requestFocus(_genderNode);
              String? selectedGender = await showGenderMenu(context);

              if (selectedGender != null) {
                setState(() {
                  genderController.text = selectedGender;
                  genderError = false;
                   validateGender(); // Reset the error flag
                });
                
              }
            },
          
            errorText: genderError ? "Please enter gender" : " ",
            isIcon: true,
          ),
        ),
      ],
    );
  }

  Future<String?> showGenderMenu(BuildContext context) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RenderBox iconBox =
        _genderNode.context?.findRenderObject() as RenderBox;
    final Offset iconPosition = iconBox.localToGlobal(Offset.zero);

    // Increase these values for more bottom distance
    final double translateY = 25.0; // Adjust as needed
    final double translateX = 170.0;

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        iconPosition.translate(translateX, iconBox.size.height),
        iconPosition.translate(translateX, iconBox.size.height + translateY),
      ),
      Offset.zero & overlay.size,
    );

    final String? selectedGender = await showMenu<String>(
      surfaceTintColor:  Theme.of(context).brightness == Brightness.dark
                              ? AppColors.darkTextInput
                              : AppColors.textInputField,
      context: context,
      position: position,
      items: ['Male', 'Female', 'Not Disclosed'].map((String gender) {
        return PopupMenuItem<String>(
          value: gender,
          child: Text(gender),
        );
      }).toList(),
    );

    if (selectedGender != null) {
      genderController.text = selectedGender;
      genderError = false;
      validateGender();
      // Handle the selected gender as needed
      print('Selected Gender: $selectedGender');
    }
  }

  Future<String?> showAgeMenu(BuildContext context) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RenderBox iconBox = _ageNode.context?.findRenderObject() as RenderBox;
    final Offset iconPosition = iconBox.localToGlobal(Offset.zero);

    // Increase these values for more bottom distance
    final double translateY = 180.0; // Adjust as needed
    final double translateX = -8.0;

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        iconPosition.translate(translateX, iconBox.size.height),
        iconPosition.translate(translateX, iconBox.size.height + translateY),
      ),
      Offset.zero & overlay.size,
    );

    final String? selectedAge = await showMenu<String>(
      context: context,
      position: position,
      items:  List.generate(61, (index) => (index + 10).toString())
          .map((String age) {
        return PopupMenuItem<String>(
          value: age,
          child: Text(age),
        );
      }).toList(),
    );

    if (selectedAge != null) {
      ageController.text = selectedAge;
        ageError = false;
                   validateAge();
      // Handle the selected gender as needed
      print('Selected age: $selectedAge');
    }
  }

  Widget _buildUserDOB() {
    return DateTextFieldWidget(
      read: false,
      hint: 'Date Of Birth',
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
          lastDate: DateTime.now(),
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
      errorText: dobError ? "Please enter Date of Birth" : " ",
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
    return Row(
      children: [
        /* InkWell(
          onTap: () {
            showCountryPicker(
              context: context,
              showPhoneCode: true,
              onSelect: (Country country) {
                phonePrefixController.text = "+ ${country.phoneCode}";
              },
            );
          },
          child: Container(
            // height: 60,
            width: MediaQuery.of(context).size.width / 5.5,
            decoration: BoxDecoration(color: Colors.transparent),
            child: TextFieldWidget(
              //width: MediaQuery.of(context).size.width / 5.5,

              read: true,
              hint: '+91 ',
              inputType: TextInputType.phone,
              hintColor: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkhint
                  : AppColors.hintColor,
              // iconColor: _themeStore.darkMode ? Colors.white70 : Colors.black54,
              textController: phonePrefixController,
              inputAction: TextInputAction.next,
              errorBorderColor: phoneprefixError
                  ? AppColors.errorColor // Border color for validation error
                  : AppColors.textInputField,
              focusBorderColor: phoneprefixError
                  ? AppColors.errorColor
                  : AppColors.focusTextBoarder,
              autoFocus: false,
              onChanged: (value) {
                setState(() {
                  phoneprefixError = false; // Reset the error flag
                });
                validatePhonePrefix(); // Trigger validation on text change
              },
              errorText: phoneprefixError ? phoneprefixErrorText : " ",
            ),
          ),
        ),*/
        Expanded(
          flex: 1,
          child: GenderTextFieldWidget(
            read: false,
            hint: '+ ',
            inputType: TextInputType.none,
            focusNode: _phonePrefixNode,
            hintColor: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkhint
                : AppColors.hintColor,
            // iconColor: _themeStore.darkMode ? Colors.white70 : Colors.black54,
            textController: phonePrefixController,
            inputAction: TextInputAction.next,
            errorBorderColor: phoneprefixError
                ? AppColors.errorColor // Border color for validation error
                : AppColors.textInputField,
            focusBorderColor: phoneprefixError
                ? AppColors.errorColor
                : AppColors.focusTextBoarder,
            autoFocus: false,
            onSuffixIconPressed: () async {
              FocusScope.of(context).requestFocus(_phonePrefixNode);
              showCountryPicker(
                context: context,
                showPhoneCode: true,
                onSelect: (Country country) {
                  phonePrefixController.text = "+ ${country.phoneCode}";
                   setState(() {
                phoneprefixError = false; // Reset the error flag
              });
              validatePhonePrefix(); 
                },
              );
            },
            onChanged: (value) {
             // Trigger validation on text change
            },
            errorText: phoneprefixError ? phoneprefixErrorText : " ",
            isIcon: true,
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Expanded(
            flex: 2,
            child: TextFieldWidget(
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
              focusBorderColor: phoneError
                  ? AppColors.errorColor
                  : AppColors.focusTextBoarder,
              autoFocus: false,
              onChanged: (value) {
                setState(() {
                  phoneError = false; // Reset the error flag
                });
                validatePhone(); // Trigger validation on text change
              },
              errorText: phoneError ? phoneErrorText : " ",
            )),
      ],
    );

    /*TextFieldWidget(
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
    );*/
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
                  scrollDirection: Axis.vertical,
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
              child: Column(
                children: [
                  Container(
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
                  if (showDErrorMessage == false)
                    Text("Please Enter your picture",
                        style: TextStyle(color: Colors.red)),
                ],
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
    return AbsorbPointer(
      absorbing: isLoading,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 19),
          child: FocusScope(
            
            // Manage keyboard focus
            child: Consumer<SignInProvider>(builder: (context, value, child) {
               // FocusManager.instance.primaryFocus?.unfocus();
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
                  onPressed: isLoading  ? (){
                      //FocusManager.instance.primaryFocus?.unfocus();
                  }:() async {
                    
                    FocusManager.instance.primaryFocus?.unfocus();
                    bool nameValid = await validateName();
      
                    bool phoneValid = await validatePhone();
                    bool ageValid = await validateAge();
                    bool prefValid = await validatePhonePrefix();
                    bool isGender = await validateGender();
      
                    if (nameValid && phoneValid && ageValid && isGender &&prefValid) {
                      setState(() {
                        isLoading = true;
                      });
      
                      value
                          .registerApi(
                              widget.email,
                              widget.password,
                              _userNameController.text,
                              int.parse(ageController.text),
                              genderController.text,
                              phonePrefixController.text,
                              _userPhoneController.text)
                          .then((val) {
                        if (val['statusCode'] == 200) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => VerifyEmailScreen(
                                      email: widget.email,
                                      password: widget.password,
                                    )),
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
                  },
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
                          "Next",
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

  Future<bool> validateGender() async {
    // var provider = Provider.of<SignInProvider>(context, listen: false);

    setState(() {
      if (genderController.text.isEmpty) {
        genderError = true;
      } else {
        genderError = false;
      }
    });

    return !ageError;
  }

  Future<bool> validateAge() async {
    // var provider = Provider.of<SignInProvider>(context, listen: false);

    setState(() {
      if (ageController.text.isEmpty) {
        ageError = true;
      } else {
        ageError = false;
      }
    });

    return !ageError;
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
        phoneErrorText = 'Please enter your contact number';
      } else {
        phoneError = false;
      }
    });

    return !phoneError;
  }

  Future<bool> validatePhonePrefix() async {
    // var provider = Provider.of<SignInProvider>(context, listen: false);

    setState(() {
      if (phonePrefixController.text.isEmpty) {
        phoneprefixError = true;
        phoneprefixErrorText = 'Please enter your phone prefix';
      } else {
        phoneprefixError = false;
      }
    });

    return !phoneprefixError;
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
