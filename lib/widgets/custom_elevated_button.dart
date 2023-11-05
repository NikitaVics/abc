import 'package:flutter/material.dart';
import 'package:tennis_court_booking_app/constants/colors.dart';
import 'package:tennis_court_booking_app/constants/font_family.dart';

class CustomElevatedButton extends StatefulWidget {
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
  State<CustomElevatedButton> createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  @override
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          isHovered = true;
        });
      },
      onExit: (event) {
        setState(() {
          isHovered = false;
        });
      },
      child: SizedBox(
        height: widget.height,
        width: widget.width,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1.0,
                color:  isHovered ? Color(0xff47B967) :AppColors.elevatedColor,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: isHovered ? Color(0xff47B967) : widget.buttonColor, // Change background color on hover
          ),
          onPressed: widget.onPressed,
          child: Text(
            widget.text,
            style: TextStyle(
              color: widget.textColor,
              fontSize: 14,
              fontFamily: FontFamily.satoshi,
              fontWeight: FontWeight.w700,
              height: 24 / 14,
            ),
          ),
        ),
      ),
    );
  }
}




