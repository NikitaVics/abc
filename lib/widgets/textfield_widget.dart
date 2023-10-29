
import 'package:flutter/material.dart';
import 'package:tennis_court_booking_app/constants/colors.dart';
import 'package:tennis_court_booking_app/constants/font_family.dart';

class TextFieldWidget extends StatefulWidget {
  final String? hint;
  final String? errorText;
  final bool isObscure;
  final bool isIcon;
  final TextInputType? inputType;
  final TextEditingController textController;
  final EdgeInsets padding;
  final Color hintColor;
  final Color iconColor;
  final FocusNode? focusNode;
  final ValueChanged? onFieldSubmitted;
  final ValueChanged? onChanged;
  final bool autoFocus;
  final TextInputAction? inputAction;
  final bool showPassword; // New parameter for password visibility

  const TextFieldWidget({
    Key? key,
    required this.errorText,
    required this.textController,
    this.inputType,
    this.hint,
    this.isObscure = false,
    this.isIcon = true,
    this.padding = const EdgeInsets.all(0),
    this.hintColor = AppColors.hintColor,
    this.iconColor = Colors.grey,
    this.focusNode,
    this.onFieldSubmitted,
    this.onChanged,
    this.autoFocus = false,
    this.inputAction,
    this.showPassword = false, // Initialize showPassword
  }) : super(key: key);

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  bool _isPasswordVisible = false; // Maintain the state of password visibility

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(
        color: AppColors.textInputField, // Customize border color
        width: 1.0,
      ),
    );

    OutlineInputBorder focusedOutlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(
        color: AppColors.dotColor, // Customize focused border color
      ),
    );

    return Padding(
      padding: widget.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: widget.textController,
            focusNode: widget.focusNode,
            onFieldSubmitted: widget.onFieldSubmitted,
            onChanged: widget.onChanged,
            autofocus: widget.autoFocus,
            textInputAction: widget.inputAction,
            obscureText: widget.isObscure && !_isPasswordVisible, // Toggle visibility
            maxLength: 25,
            keyboardType: widget.inputType,
            style: Theme.of(context).textTheme.bodyLarge,
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: TextStyle(  color: widget.hintColor,
            fontSize: 14,
            fontFamily: FontFamily.satoshi,
            fontWeight: FontWeight.w400,
            height: 24 / 14,),
              counterText: '',
              filled: true,
              fillColor: AppColors.textInputField, // Customize the fill color
              enabledBorder: outlineInputBorder,
              border: InputBorder.none,
              focusedBorder: focusedOutlineInputBorder,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 19.0, horizontal: 14.0),
              // Add suffixIcon to toggle password visibility
              suffixIcon: widget.isObscure
                  ? IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: widget.iconColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    )
                  : null,
            ),
          ),
          if (widget.errorText != null)
            Text(
              widget.errorText!,
              style: const TextStyle(color: Colors.red), // Customize error text style
            ),
        ],
      ),
    );
  }
}