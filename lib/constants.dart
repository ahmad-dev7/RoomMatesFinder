import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:share_space/components/bottom_navigation_menue.dart';
import 'package:share_space/screens/instruction_screens.dart';
import 'package:share_space/screens/mobile_login.dart';

List<Shadow> normalShadow = const [
  BoxShadow(
    color: Colors.black,
    blurRadius: 5,
    spreadRadius: 50,
    offset: Offset(2, 2),
  ),
];

Widget textOnImage({required double deviceHeight}) {
  return SizedBox(
    height: deviceHeight / 3.4,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
            text: TextSpan(
              text: 'S',
              style: GoogleFonts.aBeeZee(
                color: const Color(0xFF3E987F),
                fontSize: 60,
                fontWeight: FontWeight.w900,
                shadows: const [
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(0, 1.5),
                    blurRadius: 2,
                    spreadRadius: 5,
                  )
                ],
              ),
              children: const [
                TextSpan(
                  text: 'hare',
                  style: TextStyle(
                    color: Color(0xFFDBDBDB),
                  ),
                ),
                TextSpan(
                  text: 'S',
                  style: TextStyle(
                    color: Color(0xFF3E987F),
                  ),
                ),
                TextSpan(
                  text: 'pace',
                  style: TextStyle(
                    color: Color(0xFFDBDBDB),
                  ),
                ),
              ],
            ),
          ),
          Text(
            'Your space, Your choice',
            style: GoogleFonts.lateef(
              color: const Color(0xFFC9C7C7),
              fontSize: 40,
              shadows: const [
                BoxShadow(
                  color: Colors.white,
                  offset: Offset(0, 1.5),
                  blurRadius: 2,
                  spreadRadius: 5,
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}

Widget dividerLine = const Expanded(
  child: Padding(
    padding: EdgeInsets.symmetric(horizontal: 10),
    child: Divider(
      thickness: 1.2,
      color: Colors.white38,
    ),
  ),
);

void controlForm(value, context) {
  if (value.length == 1) {
    FocusScope.of(context).nextFocus();
  }
  if (value.length == 0) {
    FocusScope.of(context).previousFocus();
  }
}

void checkUser(BuildContext context) {
  FirebaseAuth auth = FirebaseAuth.instance;

  if (auth.currentUser != null) {
    if (auth.currentUser!.phoneNumber != null) {
      Navigator.pushReplacement(
        context,
        PageTransition(
          child: const ScreensNavigatorMenu(),
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 200),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        PageTransition(
          child: const MobileLogin(),
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 200),
        ),
      );
    }
  } else {
    Navigator.pushReplacement(
      context,
      PageTransition(
        child: const IntroductionPages(),
        type: PageTransitionType.fade,
        duration: const Duration(milliseconds: 200),
      ),
    );
  }
}

Widget styledText({
  required String text,
  FontWeight? weight,
  double? size,
  double? height,
  Color? color,
  double? width,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(
      horizontal: width ?? 26.5,
      vertical: height ?? 12.5,
    ),
    child: Text(
      text,
      overflow: TextOverflow.visible,
      textAlign: TextAlign.start,
      softWrap: true,
      style: TextStyle(
        color: color ?? Colors.white,
        fontWeight: weight ?? FontWeight.normal,
        fontSize: size ?? 18,
      ),
    ),
  );
}

BackdropFilter viewImage(int index, List<dynamic> images) {
  return BackdropFilter(
    filter: ImageFilter.blur(
      sigmaX: 20,
      sigmaY: 20,
      tileMode: TileMode.repeated,
    ),
    child: AlertDialog(
      insetPadding: const EdgeInsets.all(0),
      contentPadding: const EdgeInsets.all(0),
      content: Image.network(
        images[index],
        width: double.maxFinite,
      ),
      backgroundColor: Colors.transparent,
      shadowColor: Colors.black,
    ),
  );
}
