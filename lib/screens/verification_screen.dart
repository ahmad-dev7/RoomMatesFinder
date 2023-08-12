// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:page_transition/page_transition.dart';
import 'package:share_space/components/styled_button.dart';
import 'package:share_space/constants.dart';
import 'package:share_space/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_space/screens/home_screen.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:toast/toast.dart';

class Verification extends StatefulWidget {
  final String? phoneNumber;
  final String? verificationId;
  final int? resendToken;

  const Verification({
    super.key,
    this.phoneNumber,
    this.verificationId,
    this.resendToken,
  });

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  String pin1 = '';
  String pin2 = '';
  String pin3 = '';
  String pin4 = '';
  String pin5 = '';
  String pin6 = '';
  FirebaseAuth auth = FirebaseAuth.instance;
  bool progressIndicator = false;
  int remainingTime = 45;
  bool showButton = false;
  Timer? _timer;

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (remainingTime != 0) {
          setState(() {
            remainingTime--;
          });
        } else {
          setState(() {
            showButton = true;
            _timer?.cancel();
          });
        }
      },
    );
  }

  void _verifyOTP({required String smsCode}) async {
    if (smsCode.isNotEmpty) {
      setState(() {
        progressIndicator = true;
      });
      try {
        if (kIsWeb) {
          RecaptchaVerifier(
            auth: FirebaseAuthPlatform.instance,
            container: null,
            size: RecaptchaVerifierSize.compact,
            onError: (FirebaseAuthException error) {
              debugPrint('Recaptcha Error: ${error.message}');
            },
            onExpired: () {},
          );
        }

        AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: widget.verificationId!,
          smsCode: smsCode,
        );

        if (auth.currentUser == null) {
          UserCredential userCredential =
              await FirebaseAuth.instance.signInWithCredential(credential);
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: const HomeScreen(),
              type: PageTransitionType.bottomToTop,
            ),
          );
          debugPrint('User signedin: ${userCredential.user?.uid}');
        } else {
          await auth.currentUser!.linkWithCredential(credential);
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: const HomeScreen(),
              type: PageTransitionType.bottomToTop,
            ),
          );
        }
      } catch (e) {
        print('Error during OTP verification: ${e.toString()}');
      }
      setState(() {
        progressIndicator = false;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Verify number'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: backgroundColor,
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
              'Verifying OTP...',
              style: TextStyle(
                height: 2,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                child: Hero(
                  tag: 'icon',
                  child: Image.asset(
                    'assets/images/otp_icon.png',
                    width: 175,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Form(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    otpContainer(onChange: (value) {
                      pin1 = value;
                      controlForm(value, context);
                    }),
                    otpContainer(onChange: (value) {
                      pin2 = value;
                      controlForm(value, context);
                    }),
                    otpContainer(onChange: (value) {
                      pin3 = value;
                      controlForm(value, context);
                    }),
                    otpContainer(onChange: (value) {
                      pin4 = value;
                      controlForm(value, context);
                    }),
                    otpContainer(onChange: (value) {
                      pin5 = value;
                      controlForm(value, context);
                    }),
                    otpContainer(onChange: (value) {
                      pin6 = value;
                      controlForm(value, context);
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              showButton
                  ? TextButton(
                      onPressed: () async {
                        await auth.verifyPhoneNumber(
                          phoneNumber: widget.phoneNumber,
                          verificationCompleted:
                              (PhoneAuthCredential credential) async {},
                          verificationFailed:
                              (FirebaseAuthException exception) {
                            print(exception);
                          },
                          codeSent: (String verificationID, int? resendToken) {
                            print(widget.phoneNumber);
                          },
                          codeAutoRetrievalTimeout: (String timeOut) {
                            print(timeOut);
                          },
                          forceResendingToken: widget.resendToken,
                        );
                        Toast.show(
                          "\nNew OTP is sent to ${widget.phoneNumber}\n",
                          duration: 3,
                          gravity: Toast.center,
                          backgroundColor: Colors.black,
                          textStyle: const TextStyle(
                            color: Colors.white,
                          ),
                        );
                        setState(() {
                          remainingTime = 45;
                          startTimer();
                          showButton = false;
                        });
                      },
                      child: const Text(
                        'Resend OTP',
                        style: TextStyle(
                          color: Colors.greenAccent,
                        ),
                      ),
                    )
                  : RichText(
                      text: TextSpan(
                        text: 'You can request new OTP after   ',
                        children: [
                          TextSpan(
                            text: remainingTime.toString(),
                            style: const TextStyle(
                              fontSize: 19,
                              color: Colors.greenAccent,
                            ),
                          ),
                          const TextSpan(
                            text: 's',
                            style: TextStyle(
                              color: Colors.white54,
                            ),
                          )
                        ],
                      ),
                    ),
              const SizedBox(height: 35),
              styledButton(
                onTap: () async {
                  final String otp = '$pin1$pin2$pin3$pin4$pin5$pin6';
                  _verifyOTP(smsCode: otp);
                },
                text: 'Verify & Continue',
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget otpContainer({required Function onChange}) {
    return Container(
      height: 58,
      width: 44,
      decoration: BoxDecoration(
        color: const Color(0xFF8BBBD3),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            offset: Offset(2, 2),
            blurRadius: 2,
            spreadRadius: 1,
          ),
        ],
      ),
      child: TextFormField(
        keyboardType: TextInputType.number,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.white,
          shadows: normalShadow,
          fontSize: 30,
          decoration: TextDecoration.none,
        ),
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          hintText: '0',
          hintStyle: TextStyle(
            color: Color(0x99607D8B),
            shadows: [],
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(
              color: Color(0xFF5FA6E0),
              width: 3,
              style: BorderStyle.solid,
            ),
          ),
          border: InputBorder.none,
        ),
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: (value) {
          onChange(value);
        },
      ),
    );
  }
}
