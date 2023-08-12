import 'package:flutter/material.dart';
import 'package:share_space/main.dart';

Container styledInputField({
  required String hintText,
  required TextInputType keyboardType,
  required Function onChanged,
  Function()? suffixIconTap,
  Function()? onTap,
  Function()? onComplete,
  IconData? prefixIcon,
  Widget? child,
  bool? isPassword,
  IconData? suffixIcon,
}) {
  return Container(
    height: 60,
    decoration: BoxDecoration(
      boxShadow: const [
        BoxShadow(
          color: Colors.black,
          blurStyle: BlurStyle.solid,
          blurRadius: 2,
          offset: Offset(2, 2),
          spreadRadius: 1,
        )
      ],
      color: inputFieldColor,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 7),
      child: TextField(
        onEditingComplete: onComplete,
        onTap: onTap,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 17,
        ),
        obscureText: isPassword ?? false,
        onChanged: (value) {
          onChanged(value);
        },
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: InputBorder.none,
          suffixIcon: InkWell(
            onTap: suffixIconTap,
            child: Icon(
              suffixIcon,
              color: backgroundColor,
            ),
          ),
          prefixIcon: child ??
              Icon(
                prefixIcon,
                color: Colors.white70,
              ),
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xCADAF7FF),
            fontSize: 14,
          ),
        ),
      ),
    ),
  );
}
