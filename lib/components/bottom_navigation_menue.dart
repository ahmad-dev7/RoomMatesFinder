import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:share_space/main.dart';
import 'package:share_space/screens/adding_room_screen.dart';
import 'package:share_space/screens/home_screen.dart';
import 'package:share_space/screens/profile_screen.dart';

class ScreensNavigatorMenu extends StatefulWidget {
  const ScreensNavigatorMenu({super.key});

  @override
  State<ScreensNavigatorMenu> createState() => _ScreensNavigatorMenuState();
}

class _ScreensNavigatorMenuState extends State<ScreensNavigatorMenu> {
  List<Widget> items = const [
    Icon(Icons.home, color: Colors.white),
    Icon(Icons.add, color: Colors.white),
    Icon(Icons.person, color: Colors.white),
  ];
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      bottomNavigationBar: CurvedNavigationBar(
        items: items,
        backgroundColor: backgroundColor,
        color: Colors.blueGrey,
        buttonBackgroundColor: const Color(0xFF3D6E87),
        animationDuration: const Duration(milliseconds: 300),
        height: 60,
        onTap: (selectedIndex) {
          setState(() {
            index = selectedIndex;
          });
        },
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
        color: Colors.transparent,
        child: child(index: index),
      ),
    );
  }
}

Widget child({required int index}) {
  List<Widget> children = const [HomeScreen(), AddRoom(), UserProfile()];
  return children[index];
}
