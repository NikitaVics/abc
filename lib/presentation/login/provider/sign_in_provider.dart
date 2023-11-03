import 'package:flutter/material.dart';
import 'package:tennis_court_booking_app/api/api.dart';
import 'package:tennis_court_booking_app/model/login/login_response_model.dart';

class SignInProvider with ChangeNotifier {
  TextEditingController userEmailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController signUpName = TextEditingController();
  TextEditingController signUpEmail = TextEditingController();
  TextEditingController signUpPassword = TextEditingController();
  TextEditingController signUpConfirmPassword = TextEditingController();
  TextEditingController forgotPass = TextEditingController();
   TextEditingController resetsignUpPassword = TextEditingController();
  TextEditingController resetsignUpConfirmPassword = TextEditingController();

  bool loginLoader = false,
      registerLoader = false,
      forgotPasswordLoader = false;

  updateLoginLoader(bool load) {
    loginLoader = load;
    notifyListeners();
  }

  updateForgotPasswordLoader(bool load) {
    forgotPasswordLoader = load;
    notifyListeners();
  }

  updateRegisterLoader(bool load) {
    registerLoader = load;
    notifyListeners();
  }

  Future forgotPasswordApi(String email) async {
   // updateForgotPasswordLoader(true);
    var body = {
      'email':email,
    };
    try {
      var res = await Api.forgotPassword(body);
      print('Response: $res');
    
      // Parse the 'res' here, if needed.
      //updateForgotPasswordLoader(false);
      return res;
    } catch (e) {
      print('Error while decoding JSON: $e');
      // Handle the error appropriately.
      //updateForgotPasswordLoader(false);
      return null; // Or throw an exception, depending on your requirements.
    }
  }

   Future verifyEmailForgotPasswordApi(String email,String otp) async {
    //updateForgotPasswordLoader(true);
    var body = {
      'email':email,
      'otp':otp,
    };
    try {
      var res = await Api.emaiVerificationForgotPassword(body);
      print('Response: $res');
    
      // Parse the 'res' here, if needed.
      //updateForgotPasswordLoader(false);
      return res;
    } catch (e) {
      print('Error while decoding JSON: $e');
      // Handle the error appropriately.
      //updateForgotPasswordLoader(false);
      return null; // Or throw an exception, depending on your requirements.
    }
  }

  Future resetPasswordApi(String email) async {
    //updateForgotPasswordLoader(true);
    var body = {
      'email':email, 
      'password':resetsignUpPassword.text,
      'confirmedPassword':resetsignUpConfirmPassword.text

    };
    try {
      var res = await Api.resetPassword(body);
      print('Response: $res');
    
      // Parse the 'res' here, if needed.
      //updateForgotPasswordLoader(false);
      return res;
    } catch (e) {
      print('Error while decoding JSON: $e');
      // Handle the error appropriately.
      //updateForgotPasswordLoader(false);
      return null; // Or throw an exception, depending on your requirements.
    }
  }

  Future loginApi() async {
    updateLoginLoader(true);
    var body = {
      'userName': userEmailController.text,
      'password': passwordController.text,
    };

    try {
      var res = await Api.login(body);
      print('Response: $res');
      // Parse the 'res' here, if needed.
      updateLoginLoader(false);
      return res;
    } catch (e) {
      print('Error while decoding JSON: $e');
      // Handle the error appropriately.
      updateLoginLoader(false);
      return null; // Or throw an exception, depending on your requirements.
    }
  }

  Future registerApi() async {
    updateRegisterLoader(true);
    var body = {
      "email": signUpEmail.text,
      "userName": signUpName.text,
      "password": signUpPassword.text,
      "confirmedPassword": signUpConfirmPassword.text
    };
    var res = await Api.register(body);
    updateRegisterLoader(false);
    return res;
  }
}
