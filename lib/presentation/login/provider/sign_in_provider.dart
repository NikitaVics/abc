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

  Future resetPasswordApi(String email,String password,String confirmPassword) async {
    //updateForgotPasswordLoader(true);
    var body = {
      'email':email, 
      'password':password,
      'confirmedPassword':confirmPassword

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

  Future loginApi(String email,String password) async {
    updateLoginLoader(true);
    var body = {
      'userName': email,
      'password': password,
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

  Future registerFormApi(String email,String name,String phoneNumber,String dob,String address,String imageUrl) async {
    //updateRegisterLoader(true);
    var body = {
  "email":email,
  "name": name,
  "phoneNumber": phoneNumber,
  "dob": dob,
  "address":address,
  "imageUrl":imageUrl
    };
    var res = await Api.registerForm(body);
    //updateRegisterLoader(false);
    return res;
  }
}
