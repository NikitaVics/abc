// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:tennis_court_booking_app/constants/colors.dart';
import 'package:tennis_court_booking_app/constants/font_family.dart';

class TextFieldNonEditable extends StatefulWidget {
  TextEditingController? controller;
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
  TextFieldNonEditable(
      {Key? key,
      this.controller,
      required this.hint,
      required this.obscure,
      required this.textInputType,
      required this.hintColor,
      required this.boarderColor,
      required this.width,
      this.initialValue,
      this.color,
      this.editable,
      this.iconData,
      this.textInputAction})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TextFieldNonEditableState createState() => _TextFieldNonEditableState();
}

class _TextFieldNonEditableState extends State<TextFieldNonEditable> {
  dynamic height, width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = widget.width;

    return SizedBox(
      width: width,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: widget.color,
            border: Border.all(color: widget.boarderColor, width: 1)),
        child: TextFormField(
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
              border: InputBorder.none,
              hintText: widget.hint,
              hintStyle: TextStyle(
                color: widget.hintColor,
                fontSize: 16,
                fontFamily: FontFamily.satoshi,
                fontWeight: FontWeight.w400,
                height: 24 / 16,
              )),
        ),
      ),
    );
  }
}
