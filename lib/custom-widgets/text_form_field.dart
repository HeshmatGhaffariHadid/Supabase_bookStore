import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {

  final FocusNode node;
  final TextEditingController controller;
  final String label;
  final TextInputAction textInputAction;
  final bool? hideText;
  final IconButton? suffixIcon;
  final TextInputType? inputType;
  final String? Function(String?)? validator;
  final Function(String?)? onSubmitted;

   CustomTextFormField({
    super.key,
    required this.node,
    required this.controller,
     required this.label,
     this.textInputAction = TextInputAction.next,
     this.hideText,
     this.suffixIcon,
     this.inputType,
     this.validator,
     this.onSubmitted
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: node,
      controller: controller,
      obscureText: hideText ?? false,
      style: TextStyle(color: Colors.black),
      textAlign: TextAlign.start,
      keyboardType: inputType,
      textInputAction: textInputAction,
      canRequestFocus: true,
      enabled: true,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        suffixIcon: suffixIcon,
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.indigo, width: 1.5),
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.indigo),
          borderRadius: BorderRadius.circular(10),
        )
      ),
      onFieldSubmitted: onSubmitted,
      validator: validator,
    );
  }
}
