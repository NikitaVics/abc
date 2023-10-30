// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:tennis_court_booking_app/constants/colors.dart';
import 'package:tennis_court_booking_app/constants/font_family.dart';
import 'package:tennis_court_booking_app/presentation/login/login_screen.dart';
import 'package:tennis_court_booking_app/widgets/custom_elevated_button.dart';
import 'package:tennis_court_booking_app/widgets/textfield_widget.dart';

class RegisterAsMember extends StatefulWidget {
 



  @override
  State<RegisterAsMember> createState() => _RegisterAsMemberState();
}

class _RegisterAsMemberState extends State<RegisterAsMember> {
  late FocusNode _passwordFocusNode;
  late FocusNode _confirmpasswordFocusNode;
 TextEditingController _userNameController = TextEditingController();

  TextEditingController _userEmailController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  TextEditingController _confirmPasswordController = TextEditingController();

   
   @override
  void initState() {
    super.initState();
    _passwordFocusNode = FocusNode();
    _confirmpasswordFocusNode = FocusNode();
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
    return  TextFieldWidget(
          hint: 'User Name',
          inputType: TextInputType.name,

          // iconColor: _themeStore.darkMode ? Colors.white70 : Colors.black54,
          textController: _userNameController,
          inputAction: TextInputAction.next,
          autoFocus: false,
          onChanged: (value) {
           // _formStore.setUserId(_userEmailController.text);
          },
          onFieldSubmitted: (value) {
            FocusScope.of(context).requestFocus(_passwordFocusNode);
          },
          errorText: "",
        );
    
  }

  Widget _buildUserIdField() {
    return TextFieldWidget(
          hint: 'E-mail',
          inputType: TextInputType.emailAddress,

          // iconColor: _themeStore.darkMode ? Colors.white70 : Colors.black54,
          textController: _userEmailController,
          inputAction: TextInputAction.next,
          padding: EdgeInsets.only(top: 8.0),
          autoFocus: false,
          onChanged: (value) {
            //_formStore.setUserId(_userEmailController.text);
          },
          onFieldSubmitted: (value) {
            FocusScope.of(context).requestFocus(_passwordFocusNode);
          },
          errorText: " ",
        );
    
  }

  Widget _buildPasswordField() {
    return  TextFieldWidget(
          hint:"Password"
             ,
          isObscure: true,
          padding: EdgeInsets.only(top: 8.0),
          textController: _passwordController,
          focusNode: _passwordFocusNode,
          errorText: "",
          onChanged: (value) {
           // _formStore.setPassword(_passwordController.text);
          },
        );
     
  }

  Widget _buildConfirmPasswordField() {
    return TextFieldWidget(
          hint: "Confirm Password",
          isObscure: true,
          padding: EdgeInsets.only(top: 8.0),
          textController: _confirmPasswordController,
          focusNode: _confirmpasswordFocusNode,
          errorText: " ",
          onChanged: (value) {
            //_formStore.setPassword(_passwordController.text);
          },
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
      builder: (context) =>  LoginScreen(),
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
          child: CustomElevatedButton(
            height: 60,
            width: MediaQuery.of(context).orientation == Orientation.landscape
                ? 70
                : double.infinity,
            text: "Register Now",
            onPressed: () async {
             
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
    _userEmailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
   
    super.dispose();
  }
}
