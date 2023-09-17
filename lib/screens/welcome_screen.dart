// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:page_transition/page_transition.dart';
import 'package:share_space/components/styled_button.dart';
import 'package:share_space/components/styled_inputfield.dart';
import 'package:share_space/constants.dart';
import 'package:share_space/main.dart';
import 'package:share_space/screens/mobile_login.dart';
import 'package:share_space/screens/registration_screen.dart';
import 'package:toast/toast.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool isPassword = true;
  IconData suffixIcon = Icons.remove_red_eye_outlined;
  String? _emailId;
  String? _password;
  bool progressIndicator = false;

  void toggleVisibility() {
    setState(() {
      if (isPassword == true) {
        isPassword = false;
        suffixIcon = Icons.visibility_off_outlined;
      } else {
        isPassword = true;
        suffixIcon = Icons.remove_red_eye_outlined;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    bool detectKeyboard = MediaQuery.of(context).viewInsets.bottom == 0;
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: progressIndicator,
        dismissible: false,
        blur: 10,
        color: Colors.blueGrey,
        progressIndicator: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            CircularProgressIndicator(),
            Text(
              'Fetching account details..',
              style: TextStyle(
                height: 2,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        child: Stack(
          children: [
            Image.asset(
              'assets/images/space.gif',
              height: deviceHeight / 2.5,
              width: deviceWidth,
              fit: BoxFit.cover,
            ),
            textOnImage(deviceHeight: deviceHeight),
            Padding(
              padding: !detectKeyboard
                  ? EdgeInsets.only(top: deviceHeight / 3)
                  : EdgeInsets.only(top: deviceHeight / 2.7),
              child: Container(
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                height: deviceHeight / 1.4,
                width: double.maxFinite,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Visibility(
                        visible: detectKeyboard,
                        child: styledButton(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                child: const MobileLogin(),
                                type: PageTransitionType.rightToLeft,
                              ),
                            );
                          },
                          text: 'Continue with number',
                          alignment: MainAxisAlignment.start,
                          icon: FontAwesomeIcons.mobileRetro,
                        ),
                      ),
                      Visibility(
                        visible: detectKeyboard,
                        child: Row(
                          children: [
                            dividerLine,
                            const Text(
                              'Or login with',
                              style: TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                            dividerLine,
                          ],
                        ),
                      ),
                      styledInputField(
                        hintText: 'Enter your email ID',
                        prefixIcon: Icons.email_rounded,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          setState(() {
                            _emailId = value;
                          });
                        },
                      ),
                      styledInputField(
                        hintText: 'Enter your password',
                        prefixIcon: Icons.lock,
                        keyboardType: TextInputType.visiblePassword,
                        suffixIcon: suffixIcon,
                        isPassword: isPassword,
                        suffixIconTap: () {
                          toggleVisibility();
                        },
                        onChanged: (value) {
                          setState(() {
                            _password = value;
                          });
                        },
                      ),
                      if (_password != null && _emailId != null)
                        TextButton(
                          onPressed: () async {
                            try {
                              setState(() {
                                progressIndicator = true;
                              });
                              UserCredential userCredential = await FirebaseAuth
                                  .instance
                                  .signInWithEmailAndPassword(
                                email: _emailId!,
                                password: _password!,
                              );
                              if (userCredential.user != null) {
                                setState(() {
                                  progressIndicator = false;
                                });
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    child: const ScreensNavigatorMenu(),
                                    type: PageTransitionType.leftToRight,
                                  ),
                                );
                              }
                            } catch (exception) {
                              String error = 'Please try again';
                              if (exception is FirebaseAuthException) {
                                setState(() {
                                  error = exception.message!;
                                });
                                Toast.show(
                                  error,
                                  duration: 4,
                                  backgroundColor: Colors.black,
                                );
                              }
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Continue',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.blue,
                                shadows: [
                                  BoxShadow(
                                    blurRadius: 10,
                                    spreadRadius: 10,
                                    color: Colors.black,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      Visibility(
                        visible: detectKeyboard,
                        child: RichText(
                          text: TextSpan(
                            text: 'Don\'t have an account? ',
                            style: const TextStyle(
                              color: Colors.white70,
                            ),
                            children: [
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => Navigator.push(
                                        context,
                                        PageTransition(
                                          child: const Registration(),
                                          type: PageTransitionType
                                              .bottomToTopJoined,
                                          childCurrent: widget,
                                          duration:
                                              const Duration(milliseconds: 700),
                                          reverseDuration:
                                              const Duration(milliseconds: 700),
                                        ),
                                      ),
                                text: ' Register',
                                style: const TextStyle(
                                  color: Colors.greenAccent,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
