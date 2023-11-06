import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:share_space/main.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactButton extends StatelessWidget {
  final String number;
  const ContactButton({super.key, required this.number});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Alert(
          context: context,
          style: AlertStyle(
            animationType: AnimationType.grow,
            animationDuration: const Duration(milliseconds: 500),
            backgroundColor: backgroundColor,
            titleStyle: const TextStyle(color: Colors.white),
          ),
          content: const SizedBox(
            height: 50,
            child: Icon(
              Icons.add_call,
              size: 30,
              color: Colors.greenAccent,
            ),
          ),
          title: "Do you want to contact owner!",
          buttons: [
            DialogButton(
              color: Colors.grey,
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            DialogButton(
              color: buttonColor,
              child: const Text('Call'),
              onPressed: () {
                // ignore: deprecated_member_use
                launch("tel:$number");
              },
            ),
          ],
        ).show();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0x5E0CCABE),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.phone,
              color: Colors.greenAccent,
            ),
            Text(
              '  Contact Owner',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
