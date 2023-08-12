import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:page_transition/page_transition.dart';

import 'package:share_space/components/styled_button.dart';
import 'package:share_space/components/styled_inputfield.dart';
import 'package:share_space/main.dart';
import 'package:share_space/screens/verification_screen.dart';

class MobileLogin extends StatefulWidget {
  const MobileLogin({super.key});
  @override
  State<MobileLogin> createState() => _MobileLoginState();
}

class _MobileLoginState extends State<MobileLogin> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String mobileNumber = '';
  String countryCode = '91';
  bool newUser = FirebaseAuth.instance.currentUser != null;
  bool progressIndicator = false;
  @override
  Widget build(BuildContext context) {
    String phoneNumber = '+$countryCode$mobileNumber';
    return Scaffold(
      appBar: appBar(context),
      backgroundColor: backgroundColor,
      body: ModalProgressHUD(
        inAsyncCall: progressIndicator,
        dismissible: false,
        blur: 10,
        color: Colors.blueGrey,
        progressIndicator: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            const CircularProgressIndicator(),
            Text(
              'Sending OTP on $phoneNumber',
              style: const TextStyle(
                height: 2,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Hero(
                  tag: 'icon',
                  child: Image.asset(
                    'assets/images/otp_icon.png',
                    height: 150,
                  ),
                ),
              ),
              const Flexible(child: SizedBox(height: 40)),
              styledInputField(
                hintText: 'Enter your mobile number',
                child: countryPicker(context),
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  setState(() {
                    mobileNumber = value;
                  });
                },
              ),
              const Flexible(child: SizedBox(height: 60)),
              styledButton(
                onTap: () async {
                  try {
                    setState(() {
                      if (mobileNumber.length >= 10) {
                        progressIndicator = true;
                      }
                    });
                    await auth.verifyPhoneNumber(
                      phoneNumber: phoneNumber,
                      verificationCompleted:
                          (PhoneAuthCredential credential) async {},
                      verificationFailed: (FirebaseAuthException e) {
                        debugPrint(e.message);
                      },
                      codeSent:
                          (String verificationID, int? resendToken) async {
                        if (auth.currentUser != null) {
                          setState(() {
                            progressIndicator = false;
                            print(
                                'Value of $progressIndicator, should be false');
                          });
                          Navigator.push(
                            context,
                            PageTransition(
                              child: Verification(
                                verificationId: verificationID,
                                phoneNumber: phoneNumber,
                                resendToken: resendToken,
                              ),
                              type: PageTransitionType.rightToLeft,
                            ),
                          );
                        } else {
                          setState(() {
                            progressIndicator = false;
                            print(
                                'Value of $progressIndicator, should be false');
                          });
                          Navigator.push(
                            context,
                            PageTransition(
                              child: Verification(
                                verificationId: verificationID,
                                phoneNumber: phoneNumber,
                                resendToken: resendToken,
                              ),
                              type: PageTransitionType.rightToLeft,
                            ),
                          );
                        }
                      },
                      codeAutoRetrievalTimeout: (String verificationId) {},
                      timeout: const Duration(seconds: 40),
                    );
                  } catch (e) {
                    debugPrint(e.toString());
                  }
                },
                text: 'Get OTP',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding countryPicker(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: Colors.white, width: 0.2),
          borderRadius: BorderRadius.circular(5),
        ),
        child: InkWell(
          onTap: () {
            showCountryPicker(
              context: context,
              showPhoneCode: true,
              countryListTheme: countryListStyle(context),
              onSelect: (Country country) {
                setState(() {
                  countryCode = country.phoneCode;
                });
              },
            );
          },
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '+$countryCode',
                  style: const TextStyle(color: Colors.white),
                ),
                const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white70,
                  size: 25,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: backgroundColor,
      leading: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: const Icon(
          Icons.close,
        ),
      ),
      title: const Text(
        'Continue with number',
      ),
      centerTitle: true,
    );
  }

  CountryListThemeData countryListStyle(context) {
    return CountryListThemeData(
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).size.height / 2.8,
      ),
      borderRadius: BorderRadius.circular(20),
      backgroundColor: backgroundColor,
      textStyle: const TextStyle(
        color: Colors.white,
      ),
      searchTextStyle: const TextStyle(
        color: Colors.white,
      ),
      inputDecoration: const InputDecoration(
        hintText: 'Search country',
        hintStyle: TextStyle(
          color: Colors.white54,
        ),
      ),
    );
  }
}
