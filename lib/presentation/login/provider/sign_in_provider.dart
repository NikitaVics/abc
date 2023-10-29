import 'package:flutter/material.dart';
import 'package:tennis_court_booking_app/api/api.dart';

class SignInProvider with ChangeNotifier {
  TextEditingController userEmailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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

  Future loginApi() async {
    updateLoginLoader(true);
    var body = {
      'userName': userEmailController.text,
      'password': passwordController.text,
    };
    var res = await Api.login(body);
    print(body);
    updateLoginLoader(false);
    return res;
  }
}
