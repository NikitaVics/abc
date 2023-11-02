import 'package:flutter/material.dart';
import 'package:tennis_court_booking_app/constants/colors.dart';
import 'package:tennis_court_booking_app/constants/font_family.dart';

class OtpInput extends StatelessWidget {
  final TextEditingController controller;
  final bool autoFocus;
  const OtpInput(this.controller, this.autoFocus, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(
        color: AppColors.appbarBoarder, 
          width: 1.0,// Customize focused border color
      ),
    );
     OutlineInputBorder focusedOutlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(
        color: AppColors.confirmValid, 
          width: 1.0,// Customize focused border color
      ),
    );
    return SizedBox(
      height:56,
      width:67,
     
      child: TextField(
        autofocus: autoFocus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        controller: controller,
        maxLength: 1,
        cursorColor: Theme.of(context).primaryColor,
        decoration:  InputDecoration(
          contentPadding:const EdgeInsets.symmetric(vertical: 16.0, horizontal: 14.0),
           enabledBorder: outlineInputBorder,
           focusedBorder:focusedOutlineInputBorder ,
            counterText: '',
            hintStyle:const TextStyle(
                color:AppColors.hintColor,
                fontSize: 14,
                fontFamily: FontFamily.satoshi,
                fontWeight: FontWeight.w400,
                height: 24 / 14,
              ),),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}