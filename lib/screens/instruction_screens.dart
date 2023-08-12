import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:share_space/constants.dart';
import 'package:page_transition/page_transition.dart';
import 'package:share_space/screens/welcome_screen.dart';

late double deviceHeight;
late double deviceWidth;
PageViewModel pages({
  required String img,
  required String title,
  required String description,
}) {
  return PageViewModel(
    useScrollView: false,
    titleWidget: Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 2),
              blurRadius: 30,
              spreadRadius: .5,
              color: Color(0x92000000),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            img,
            width: double.maxFinite,
            height: deviceHeight / 1.8,
            fit: BoxFit.cover,
          ),
        ),
      ),
    ),
    bodyWidget: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          title,
          style: GoogleFonts.aBeeZee(
            color: const Color(0xFF54E4C8),
            fontSize: 25,
            fontWeight: FontWeight.bold,
            shadows: normalShadow,
          ),
        ),
        const SizedBox(height: 50),
        Text(
          description,
          textAlign: TextAlign.center,
          style: GoogleFonts.albertSans(
            color: Colors.white,
            fontSize: 17,
            height: 1.7,
            shadows: normalShadow,
          ),
        )
      ],
    ),
  );
}

class IntroductionPages extends StatelessWidget {
  const IntroductionPages({super.key});

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: IntroductionScreen(
        globalBackgroundColor: Colors.blueGrey.shade900,
        showNextButton: false,
        done: Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'Continue',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onDone: () {
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: const WelcomeScreen(),
              type: PageTransitionType.leftToRight,
              duration: const Duration(milliseconds: 600),
            ),
          );
        },
        pages: [
          //* First Slide
          pages(
            img: 'assets/images/first.jpg',
            title: 'Find Sharing Rooms',
            description:
                'You can find sharing rooms on your preferred location, under your suitable budget.',
          ),
          //* Second Slide
          pages(
            img: 'assets/images/second_pic.png',
            title: 'Find Perfect Room-Mate',
            description:
                'You can find a perfect room-mate who shares same interests and passions as yours.',
          ),
          //* Third Slide
          pages(
            img: 'assets/images/third.jpg',
            title: 'Sit Relaxed & Get Room',
            description:
                'You can fill a form, describing your needs, and will notify you as soon as we find it.',
          ),
        ],
        showSkipButton: true,
        skip: Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'Skip',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        onSkip: () {
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: const WelcomeScreen(),
              type: PageTransitionType.leftToRight,
              duration: const Duration(milliseconds: 600),
            ),
          );
        },
      ),
    );
  }
}
