import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:share_space/main.dart';
import 'package:share_space/screens/adding_room_screen.dart';
import 'package:share_space/screens/welcome_screen.dart';

User auth = FirebaseAuth.instance.currentUser!;

class DrawerBox extends StatefulWidget {
  const DrawerBox({super.key});

  @override
  State<DrawerBox> createState() => _DrawerBoxState();
}

class _DrawerBoxState extends State<DrawerBox> {
  String name = auth.displayName!;
  String number = auth.phoneNumber!;
  String email = auth.email!;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: backgroundColor,
      elevation: 5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/otp_icon.png'),
                  radius: 45,
                ),
              ),
              Column(
                children: [
                  Text(
                    name,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    number,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    email,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: [
              drawerButtons(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: const AddRoom(),
                      type: PageTransitionType.scale,
                      alignment: Alignment.center,
                      duration: const Duration(milliseconds: 800),
                    ),
                  );
                },
                iconData: Icons.home,
                text: 'Add new room',
              ),
              drawerButtons(
                  onTap: () {},
                  iconData: Icons.description,
                  text: 'Describe your need'),
              drawerButtons(
                  onTap: () {},
                  iconData: Icons.contacts_outlined,
                  text: 'Update contact details'),
              drawerButtons(
                  onTap: () {}, iconData: Icons.rate_review, text: 'Rate us'),
              drawerButtons(
                  onTap: () {},
                  iconData: Icons.report_problem,
                  text: 'Report issue'),
            ],
          ),
          drawerButtons(
              onTap: () {
                FirebaseAuth.instance.signOut();

                Navigator.pushReplacement(
                  context,
                  PageTransition(
                    child: const WelcomeScreen(),
                    type: PageTransitionType.fade,
                  ),
                );
              },
              color: Colors.red,
              iconData: Icons.logout,
              text: 'Logout'),
        ],
      ),
    );
  }

  InkWell drawerButtons({
    IconData? iconData,
    String? text,
    Color? color,
    required Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
        height: 50,
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: color ?? buttonColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Icon(
                iconData,
                color: const Color(0xFF22044B),
                size: 30,
              ),
            ),
            Text(
              text!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
