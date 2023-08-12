import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
