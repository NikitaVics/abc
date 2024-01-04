import 'package:flutter/material.dart';
import 'package:tennis_court_booking_app/constants/colors.dart';
import 'package:tennis_court_booking_app/constants/font_family.dart';

typedef GenderCallback = void Function();

class PrefixPhoneTextFieldWidget extends StatefulWidget {
  final String? hint;
  final String? errorText;
  final bool isObscure;
  final bool isIcon;
  final TextInputType? inputType;
  final TextEditingController textController;
  final EdgeInsets padding;
  final Color? hintColor;
  final FocusNode? focusNode;
  final ValueChanged? onFieldSubmitted;
  final ValueChanged? onChanged;
  final bool autoFocus;
  final TextInputAction? inputAction;
  final bool showPassword;
  final Color? errorBorderColor; // New parameter for password visibility
  final Color? focusBorderColor;
  final Color? defaultBoarder;
  final bool read;
  final double width;
  final GenderCallback onSuffixIconPressed;

  const PrefixPhoneTextFieldWidget({
    Key? key,
    required this.errorText,
    required this.textController,
    this.inputType,
    this.hint,
    this.isObscure = false,
    this.isIcon = true,
    this.padding = const EdgeInsets.all(0),
    this.hintColor,
    this.focusNode,
    this.onFieldSubmitted,
    this.onChanged,
    this.autoFocus = false,
    this.inputAction,
    this.showPassword = false,
    this.errorBorderColor, // Initialize showPassword
    this.focusBorderColor,
    this.defaultBoarder,
    required this.read,
    required this.onSuffixIconPressed, required this.width,
  }) : super(key: key);

  @override
  State<PrefixPhoneTextFieldWidget> createState() =>
      _PrefixPhoneTextFieldWidgetState();
}

class _PrefixPhoneTextFieldWidgetState
    extends State<PrefixPhoneTextFieldWidget> {
  bool _isPasswordVisible = false; // Maintain the state of password visibility

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkTextInput
            : AppColors.textInputField, // Customize border color
        width: 1.0,
      ),
    );

    OutlineInputBorder focusedOutlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(
        color: widget.focusBorderColor!,
        width: 1.0, // Customize focused border color
      ),
    );
    OutlineInputBorder errorOutlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(
        color: widget.errorBorderColor!,
        width: 1.0, // Customize error border color
      ),
    );
    OutlineInputBorder focusederrorOutlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(
        color: AppColors.focusTextBoarder,
        width: 1.0, // Customize error border color
      ),
    );
    return Container(
    //  height: 60,
      width:widget.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            readOnly: widget.read,
            controller: widget.textController,
            focusNode: widget.focusNode,
            onFieldSubmitted: widget.onFieldSubmitted,
            onChanged: widget.onChanged,
            autofocus: widget.autoFocus,
            textInputAction: widget.inputAction,
            obscureText:
                widget.isObscure && !_isPasswordVisible, // Toggle visibility
            maxLength: 50,
            keyboardType: widget.inputType,
            cursorColor: AppColors.focusCursorColor,
            style: Theme.of(context).textTheme.bodyLarge,
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: TextStyle(
                color: widget.hintColor,
                fontSize: 14,
                fontFamily: FontFamily.satoshi,
                fontWeight: FontWeight.w400,
                height: 24 / 14,
              ),
              counterText: '',
              filled: true,
              fillColor: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkTextInput
                  : AppColors.textInputField, // Customize the fill color
              enabledBorder: outlineInputBorder,
              border: InputBorder.none,
              focusedBorder: focusedOutlineInputBorder,
              errorBorder: errorOutlineInputBorder,
              focusedErrorBorder: focusederrorOutlineInputBorder,
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 19.0, horizontal: 14.0),
              // Add suffixIcon to toggle password visibility
              suffixIcon: GestureDetector(
                  onTap: () {
                    widget.onSuffixIconPressed();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 12),
                    child: Image.asset(
                      "assets/images/Right2.png",
                      height: 2,
                    ),
                  )),
            ),
          ),
          Visibility(
            visible: widget.errorText != null,
            child: Text(
              widget.errorText ?? '',
              style: TextStyle(
                color: AppColors.errorColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
