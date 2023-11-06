import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:share_space/components/contact_button.dart';
import 'package:share_space/constants.dart';
import 'package:share_space/main.dart';

class OpenBuilderWidget extends StatelessWidget {
  final List<dynamic> imageList;
  final String ownerName;
  final String description;
  final String city;
  final String rentAmount;
  final String depositAmount;
  final String gender;
  final String foodType;
  final String memberType;
  final String locality;
  final String number;
  final String nearBy;
  final String religion;
  final String memberCount;

  const OpenBuilderWidget({
    super.key,
    required this.imageList,
    required this.city,
    required this.rentAmount,
    required this.depositAmount,
    required this.gender,
    required this.foodType,
    required this.memberType,
    required this.locality,
    required this.description,
    required this.number,
    required this.ownerName,
    required this.nearBy,
    required this.religion,
    required this.memberCount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('More Info'),
        centerTitle: true,
        automaticallyImplyLeading: true,
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 25),
              height: 280,
              child: Swiper(
                onTap: (index) {
                  viewImage(index, imageList);
                },
                itemCount: imageList.length,
                autoplay: true,
                autoplayDisableOnInteraction: true,
                viewportFraction: 0.85,
                scale: 0.85,
                curve: Curves.linearToEaseOut,
                duration: 500,
                itemBuilder: (context, index) {
                  String imagePath = imageList[index];
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      imagePath,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 25),
            styledText(
              text: 'About',
              weight: FontWeight.w600,
              size: 25,
              color: const Color(0xFFC3EBFF),
              height: 5,
            ),
            styledText(text: description, height: 0),
            const SizedBox(height: 20),
            infoText(title: 'Posted by', info: ownerName),
            infoText(title: 'Near by', info: nearBy),
            infoText(title: 'Members count', info: memberCount),
            infoText(title: 'Religion', info: religion),
            infoText(title: 'Local area', info: locality),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 26.5),
              child: SizedBox(
                width: 170,
                child: ContactButton(number: number),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget infoText({required String title, required String info}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26.5),
      child: Row(
        children: [
          styledText(
              text: '$title: ', color: const Color(0xFFC3EBFF), width: 0),
          const SizedBox(width: 5),
          styledText(text: info, width: 0, weight: FontWeight.w400)
        ],
      ),
    );
  }
}
