// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:share_space/screens/mobile_login.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:toast/toast.dart';
import '../components/styled_button.dart';
import '../components/styled_inputfield.dart';
import '../constants.dart';
import '../main.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  String name = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  bool isPassword = true;
  FirebaseAuth auth = FirebaseAuth.instance;
  bool progressIndicator = false;

  IconData suffixIcon = Icons.remove_red_eye_outlined;
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
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    bool detectKeyboard = MediaQuery.of(context).viewInsets.bottom == 0;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Create your account'),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 5,
        leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.close)),
      ),
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
              'Creating account...',
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
            Visibility(
              visible: detectKeyboard,
              child: Image.asset(
                'assets/images/space.gif',
                height: deviceHeight / 2.5,
                width: deviceWidth,
                fit: BoxFit.cover,
              ),
            ),
            Visibility(
              visible: detectKeyboard,
              child: textOnImage(
                deviceHeight: deviceHeight,
              ),
            ),
            Padding(
              padding: !detectKeyboard
                  ? const EdgeInsets.only(top: 10)
                  : EdgeInsets.only(top: deviceHeight / 3.5),
              child: Container(
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                height: detectKeyboard ? deviceHeight / 1.4 : deviceHeight - 10,
                width: double.maxFinite,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      styledInputField(
                        hintText: 'Enter your name',
                        prefixIcon: Icons.person,
                        keyboardType: TextInputType.name,
                        onChanged: (value) {
                          setState(() {
                            name = value;
                          });
                        },
                      ),
                      styledInputField(
                        hintText: 'Enter your email address',
                        prefixIcon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });
                        },
                      ),
                      styledInputField(
                        hintText: 'Create strong password',
                        prefixIcon: Icons.lock_outline,
                        keyboardType: TextInputType.visiblePassword,
                        isPassword: isPassword,
                        suffixIcon: suffixIcon,
                        suffixIconTap: () {
                          toggleVisibility();
                        },
                        onChanged: (value) {
                          setState(() {
                            password = value;
                          });
                        },
                      ),
                      styledInputField(
                        hintText: 'Confirm password',
                        prefixIcon: Icons.lock,
                        keyboardType: TextInputType.visiblePassword,
                        onChanged: (value) {
                          setState(() {
                            confirmPassword = value;
                          });
                        },
                      ),
                      styledButton(
                        onTap: () async {
                          if (name.isNotEmpty &&
                              email.isNotEmpty &&
                              password.isNotEmpty &&
                              password == confirmPassword) {
                            try {
                              setState(() {
                                progressIndicator = true;
                              });
                              UserCredential userCredential =
                                  await auth.createUserWithEmailAndPassword(
                                email: email,
                                password: confirmPassword,
                              );
                              if (auth.currentUser != null) {
                                userCredential.user!.updateDisplayName(name);
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    child: const MobileLogin(
                                      tittleText: 'Verify Mobile Number',
                                    ),
                                    type: PageTransitionType.topToBottom,
                                    duration: const Duration(milliseconds: 650),
                                  ),
                                );
                              }
                            } catch (exception) {
                              String errorMessage =
                                  'An unexpected error occurred.';
                              if (exception is FirebaseAuthException) {}
                              Toast.show(
                                ' \n $errorMessage \n ',
                                backgroundRadius: 10,
                                duration: 3,
                                backgroundColor: Colors.red,
                                border: Border.all(
                                  color: Colors.black,
                                ),
                              );
                            }
                          } else {
                            try {
                              Toast.show(
                                ' \n Please fill all input fields correctly \n ',
                                backgroundRadius: 10,
                                duration: 3,
                                backgroundColor: Colors.white,
                                textStyle: const TextStyle(color: Colors.black),
                                border: Border.all(
                                  color: Colors.black,
                                ),
                              );
                            } catch (e) {
                              debugPrint('$e');
                            }
                          }
                          setState(() {
                            progressIndicator = false;
                          });
                        },
                        text: 'Verify and Continue',
                      ),
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
