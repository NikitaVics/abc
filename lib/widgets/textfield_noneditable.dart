// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:tennis_court_booking_app/constants/colors.dart';
import 'package:tennis_court_booking_app/constants/font_family.dart';

class TextFieldNonEditable extends StatefulWidget {
  TextEditingController? controller;
  final Color focusBorderColor;
  final FocusNode? focusNode;
  Color fillColor;
  Color? color;
  Color boarderColor;
  String hint;
  Color hintColor;
  bool obscure;
  double width;
  TextInputType textInputType;
  bool? editable;
  IconData? iconData;
  String? initialValue;
  TextInputAction? textInputAction;
 
  

  // Callback to notify when the focus changes
 

  TextFieldNonEditable({
    Key? key,
    this.controller,
    required this.hint,
    required this.obscure,
    required this.textInputType,
    required this.hintColor,
    required this.boarderColor,
    required this.width,
    required this.fillColor,
    this.initialValue,
    required this.focusBorderColor,
    this.color,
    this.editable,
    this.iconData,
    this.focusNode,
    
    this.textInputAction,
   
  }) : super(key: key);

  @override
  _TextFieldNonEditableState createState() => _TextFieldNonEditableState();
}

class _TextFieldNonEditableState extends State<TextFieldNonEditable> {
 
 



  @override
  Widget build(BuildContext context) {
     OutlineInputBorder focusedOutlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(
        color: widget.focusBorderColor,
        width: 1.0, // Customize focused border color
      ),
    );
 
   

    return SizedBox(
      width: widget.width,
      child: Container(
        height: 56,
       // padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: widget.color,
          border: Border.all(
            color: widget.boarderColor,
            width: 1,
          ),
        ),
        child: TextFormField(
          focusNode: widget.focusNode,
          autofocus: true,
          initialValue: widget.initialValue,
          controller: widget.controller,
          obscureText: widget.obscure,
          enabled: widget.editable,
          style: const TextStyle(
            color: AppColors.subheadColor,
            fontSize: 16,
            fontFamily: FontFamily.satoshi,
            fontWeight: FontWeight.w400,
            height: 24 / 16,
          ),
          keyboardType: widget.textInputType,
          textInputAction: widget.textInputAction,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12,vertical: 20),
             focusedBorder: focusedOutlineInputBorder,
            border: InputBorder.none,
            hintText: widget.hint,
            fillColor: widget.fillColor,
            hintStyle: TextStyle(
              color: widget.hintColor,
              fontSize: 16,
              fontFamily: FontFamily.satoshi,
              fontWeight: FontWeight.w400,
              height: 24 / 16,
            ),
          ),
        ),
      ),
    );
  }
}
