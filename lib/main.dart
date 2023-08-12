import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:share_space/screens/home_screen.dart';
import 'package:share_space/screens/instruction_screens.dart';
import 'package:share_space/screens/mobile_login.dart';
import 'package:share_space/screens/registration_screen.dart';
import 'package:share_space/screens/verification_screen.dart';

Color backgroundColor = const Color(0xFF253A45);
Color primaryColor = const Color(0xFF354E5C);
Color buttonColor = const Color(0xFF54E4C8);
Color inputFieldColor = Colors.blueGrey;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAOj8ttwofs-iPWMsqyyo5N45BUJPj1Qi8",
        appId: "1:841542336430:web:2c93fa71b5397c34ecd23f",
        messagingSenderId: "841542336430",
        projectId: "share-space-3a0e5",
      ),
    );
  }
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoadingScreen(),
        'mobileLogin': (context) => const MobileLogin(),
        'verification': (context) => const Verification(),
        'Registration': (context) => const Registration(),
        'Home': (context) => const HomeScreen(),
      },
    ),
  );
}

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(milliseconds: 2000),
      () {
        checkUser();
      },
    );
  }

  void checkUser() {
    if (auth.currentUser != null) {
      if (auth.currentUser!.phoneNumber != null) {
        Navigator.pushReplacement(
          context,
          PageTransition(
            child: const HomeScreen(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('assets/images/app_icon.gif'),
            ),
          ],
        ),
      ),
    );
  }
}
