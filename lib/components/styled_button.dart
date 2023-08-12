import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_space/main.dart';

import '../constants.dart';

InkWell styledButton({
  required Function() onTap,
  required String text,
  IconData? icon,
  Color? color,
  MainAxisAlignment? alignment,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: 60,
      width: double.maxFinite,
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            blurRadius: 5,
            offset: Offset(2, 2),
            spreadRadius: 1,
          )
        ],
        color: color ?? buttonColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: alignment ?? MainAxisAlignment.center,
        children: [
          Visibility(
            visible: (icon != null),
            child: Row(
              children: [
                const SizedBox(width: 15),
                Icon(
                  icon,
                  color: Colors.white,
                  shadows: normalShadow,
                ),
                const SizedBox(width: 15),
              ],
            ),
          ),
          Text(
            text,
            style: GoogleFonts.aBeeZee(
              fontSize: 25,
              color: backgroundColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    ),
  );
}
