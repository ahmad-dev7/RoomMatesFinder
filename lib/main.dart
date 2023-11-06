import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:share_space/constants.dart';
import 'package:share_space/screens/home_screen.dart';
import 'package:share_space/screens/mobile_login.dart';
import 'package:share_space/screens/profile_screen.dart';
import 'package:share_space/screens/registration_screen.dart';
import 'package:share_space/screens/verification_screen.dart';

Color backgroundColor = const Color(0xFF253A45);
Color primaryColor = const Color(0xFF354E5C);
Color buttonColor = const Color(0xFF54E4C8);
Color inputFieldColor = const Color(0xFF607D8B);

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
        'HomePage': (context) => const HomeScreen(),
        'ProfileScreen': (context) => const UserProfile(),
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
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 2),
      () {
        checkUser(context);
      },
    );
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
