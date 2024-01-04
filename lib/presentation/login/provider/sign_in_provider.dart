import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/src/multipart_file.dart';
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
      'email': email,
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

  Future loginWithOtp(String email) async {
    // updateForgotPasswordLoader(true);
    var body = {
      'email': email,
    };
    try {
      var res = await Api.loginWithEmail(body);
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

  Future sendOtpforlogin(String email, String otp) async {
    //updateForgotPasswordLoader(true);
    var body = {
      'email': email,
      'otp': otp,
    };
    try {
      var res = await Api.sendOtp(body);
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

  Future verifyEmailForgotPasswordApi(String email, String otp) async {
    //updateForgotPasswordLoader(true);
    var body = {
      'email': email,
      'otp': otp,
    };
    try {
      var res = await Api.emaiVerification(body);
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

  Future verifyEmail(String email, String otp) async {
    //updateForgotPasswordLoader(true);
    var body = {
      'email': email,
      'otp': otp,
    };
    try {
      var res = await Api.emaiVerification(body);
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

  Future resetPasswordApi(
      String email, String password, String confirmPassword) async {
    //updateForgotPasswordLoader(true);
    var body = {
      'email': email,
      'password': password,
      'confirmedPassword': confirmPassword
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

  Future loginApi(String email, String password) async {
    updateLoginLoader(true);
    var body = {
      'userNameOrEmail': email,
      'password': password,
    };

    var res = await Api.login(body);
    print('Response: $res');
    // Parse the 'res' here, if needed.
    updateLoginLoader(false);
    return res;
  }

  Future registerApi(
      String email, String name, String pass, String confirmPass) async {
    updateRegisterLoader(true);
    var body = {
      "email": email,
      "userName": name,
      "password": pass,
      "confirmedPassword": confirmPass
    };
    var res = await Api.register(body);
    updateRegisterLoader(false);
    return res;
  }

  Future registerFormApi(
      String email,
      String name,
      String phoneNumber,
      String dob,
      String address,
      String document,
      String gender,
      String coutryCode) async {
    //updateRegisterLoader(true);

    var res = await Api.registerForm(
        email, name, phoneNumber, dob, address, document, gender, coutryCode);
    //updateRegisterLoader(false);
    print(email);
    return res;
  }

  Future statusCheckApi(String authToken) async {
    // updateLoginLoader(true);

    try {
      var res = await Api.completeProfile(authToken);
      print('Response: $res');
      // Parse the 'res' here, if needed.
      updateLoginLoader(false);
      return res;
    } catch (e) {
      print('Error while decoding JSON: $e');
      // Handle the error appropriately.
      //updateLoginLoader(false);
      return null; // Or throw an exception, depending on your requirements.
    }
  }

  Future changePasswordApi(String oldPassword, String password,
      String confirmPassword, String bearerToken) async {
    //updateForgotPasswordLoader(true);
    var body = {
      "currentPassword": oldPassword,
      "newPassoword": password,
      "secondNewPassword": confirmPassword
    };
    try {
      var res = await Api.changePassword(body, bearerToken);
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

  Future updateProfile(String bearerToken, String username, String phoneNumber,
      String countryCode, bool deleteImage, String? image) async {
    //updateRegisterLoader(true);

    var res = await Api.updateProfile(
        bearerToken, username, phoneNumber, countryCode, deleteImage, image);
    //updateRegisterLoader(false);
    return res;
  }
}
