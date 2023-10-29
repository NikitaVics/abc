import 'package:flutter/material.dart';
import 'package:tennis_court_booking_app/constants/colors.dart';
import 'package:tennis_court_booking_app/constants/font_family.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color buttonColor;
  final Color textColor;
  final double height; // Add a double property for height
  final double width;  

  const CustomElevatedButton(
      {super.key, required this.text,
      required this.onPressed,
      required this.buttonColor,
      required this.textColor,
      required this.height,
      required this.width
      });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                width: 1.0,
                color: AppColors.elevatedColor,
              ),
              borderRadius: BorderRadius.circular(8),
              // Set to height for a circular shape
            ),
            backgroundColor: buttonColor),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 14,
            fontFamily: FontFamily.satoshi,
            fontWeight: FontWeight.w700,
            height: 24 / 14,
          ),
        ),
      ),
    );
  }
}
