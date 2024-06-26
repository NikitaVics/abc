import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tennis_court_booking_app/constants/colors.dart';
import 'package:tennis_court_booking_app/constants/font_family.dart';

class CustomElevatedButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Color buttonColor;
  final Color textColor;
  final double height; // Add a double property for height
  final double width;
  final bool isLoading;

  const CustomElevatedButton(
      {super.key,
      required this.text,
      required this.onPressed,
      required this.buttonColor,
      required this.textColor,
      required this.height,
      required this.width,
      required this.isLoading});

  @override
  State<CustomElevatedButton> createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
 
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: ElevatedButton(
       
        style: ElevatedButton.styleFrom(
          
          elevation: 0,
          shape: RoundedRectangleBorder(
           
            borderRadius: BorderRadius.circular(8),
          ),
        
          backgroundColor:
             widget.isLoading? widget.buttonColor:widget.buttonColor, 
             disabledBackgroundColor: widget.buttonColor,
           visualDensity: VisualDensity.standard,
             // Change background color on hover
        ),
        onPressed:widget.isLoading?null: widget.onPressed,
        child:  widget.isLoading
                        ? const SizedBox(
                            height: 24,
                            
                            child: SpinKitThreeBounce(
                              // Use the spinner from Spinkit you prefer
                              
                              color: Colors.white,
                              size: 24.0,
                            ),
                          )
                        : Text(
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
    );
  }
}
