import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:share_space/main.dart';
import 'package:share_space/screens/drawer_screen.dart';

late double deviceWidth;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loadingData = true;
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController inputController = TextEditingController();
  void getData({Filter? searchTerm}) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('Rooms')
              .where(
                searchTerm ??
                    Filter.or(
                      Filter('locality', isEqualTo: 'Mumbai'),
                      Filter(
                        'city',
                        isEqualTo: 'Mumbai',
                      ),
                    ),
              )
              .get();
      // .where('gender', isEqualTo: 'Female')
      if (querySnapshot.docs.isNotEmpty) {
        for (var documents in querySnapshot.docs) {
          var data = documents.data();
          List<dynamic> imageList = data['images'];
          String gender = data['gender'];
          String locality = data['locality'];
          String memberType = data['member'];
          String depositAmount = data['deposit'];
          String rentAmount = data['rent'];
          String foodType = data['food'];
          // String description = data['description'];
          // String city = data['city'];
          setState(() {
            roomList.add(
              roomContainer(
                rentAmount: rentAmount,
                depositAmount: depositAmount,
                memberType: memberType,
                locality: locality,
                foodType: foodType,
                gender: gender,
                imageList: imageList,
              ),
            );
          });
        }
      } else {
        setState(() {
          roomList.add(
            const Text(
              'Currently no room is available at this location.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                height: 10,
              ),
            ),
          );
        });
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
    }
  }

  @override
  void initState() {
    getData();
    Future.delayed(
      const Duration(seconds: 5),
      () {
        setState(() {
          loadingData = false;
        });
      },
    );
    super.initState();
  }

  List<Widget> roomList = [];

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: backgroundColor,
      drawer: const DrawerBox(),
      body: ModalProgressHUD(
        inAsyncCall: loadingData,
        color: backgroundColor,
        blur: 2,
        progressIndicator: const CircularProgressIndicator(
          semanticsLabel: 'Fetching rooms',
        ),
        child: CustomScrollView(
          slivers: [
            sliverAppBar(),
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
                child: Column(
                  children: roomList,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverAppBar sliverAppBar() {
    return SliverAppBar(
      expandedHeight: 150,
      elevation: 2,
      floating: true,
      title: Text(
        'SHARE  SPACE',
        style: GoogleFonts.abel(
          letterSpacing: 8,
        ),
      ),
      backgroundColor: primaryColor,
      centerTitle: true,
      forceElevated: true,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(vertical: 30),
        title: Container(
          margin: const EdgeInsets.only(left: 10, right: 10),
          width: double.maxFinite,
          height: 30,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            onChanged: (value) => setState(() {}),
            controller: inputController,
            style: const TextStyle(fontSize: 11, color: Colors.white),
            decoration: InputDecoration(
              suffixIcon: Visibility(
                visible: inputController.text.isNotEmpty,
                child: TextButton(
                  onPressed: () {
                    loadingData = true;
                    setState(() {
                      roomList.clear();
                      getData(
                          searchTerm: Filter.or(
                        Filter('locality', isEqualTo: inputController.text),
                        Filter(
                          'city',
                          isEqualTo: inputController.text,
                        ),
                      ));
                      Timer(const Duration(milliseconds: 500), () {
                        setState(() {
                          loadingData = false;
                        });
                      });
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: buttonColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Find',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ),
              hintText: 'Find rooms by city or locality',
              hintStyle: const TextStyle(
                color: Color(0xD38EA4A9),
              ),
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.white,
                size: 15,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(bottom: 2),
            ),
          ),
        ),
        centerTitle: true,
      ),
    );
  }

  Padding roomContainer({
    required String rentAmount,
    required String depositAmount,
    required String memberType,
    required String locality,
    required String foodType,
    required String gender,
    required List<dynamic> imageList,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: Container(
        height: 450,
        width: deviceWidth - 30,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
          color: primaryColor,
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 8),
              blurRadius: 10,
              spreadRadius: 4,
              color: Color(0xFF182D37),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //* Image container
            imageContainer(imageList),
            //* Details rows
            infoRows(
              rentAmount: rentAmount,
              depositAmount: depositAmount,
              memberType: memberType,
              locality: locality,
              foodType: foodType,
              gender: gender,
            )
          ],
        ),
      ),
    );
  }

  Swiper imageContainer(List<dynamic> imageList) {
    return Swiper(
      pagination: const SwiperPagination(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 220),
      ),
      onTap: (index) {
        showDialog(
          context: context,
          builder: (context) {
            return viewImage(index, imageList);
          },
        );
      },
      itemCount: imageList.length,
      axisDirection: AxisDirection.left,
      layout: SwiperLayout.STACK,
      itemWidth: deviceWidth - 30,
      itemHeight: 250,
      loop: true,
      autoplayDelay: 8000,
      autoplay: true,
      duration: 500,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        return swiperContent(index, imageList);
      },
    );
  }

  ClipRRect swiperContent(int index, List<dynamic> images) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: Image.network(
        images[index],
        height: 250,
        width: double.maxFinite,
        fit: BoxFit.cover,
      ),
    );
  }

  BackdropFilter viewImage(int index, List<dynamic> images) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 20,
        sigmaY: 20,
        tileMode: TileMode.repeated,
      ),
      child: AlertDialog(
        insetPadding: const EdgeInsets.all(0),
        contentPadding: const EdgeInsets.all(0),
        content: Image.network(
          images[index],
          width: double.maxFinite,
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.black,
      ),
    );
  }

  Padding infoRows({
    required String rentAmount,
    required String depositAmount,
    required String memberType,
    required String locality,
    required String foodType,
    required String gender,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //*First Row
            rowContent('Rent', '₹ $rentAmount', 'Deposit', '₹ $depositAmount',
                Colors.greenAccent),
            //*Second Row
            rowContent(
                'Member', memberType, 'Locality', locality, Colors.white),
            //*Third Row
            rowContent('Food', foodType, 'Gender', gender, Colors.white),
            //*Fourth Row
            fourthRowInfo(),
          ],
        ),
      ),
    );
  }

//* contact and more detail buttons
  Row fourthRowInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //* More details button
        InkWell(
          child: Container(
            width: 165,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0x9F979A9C),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/question.png',
                  color: Colors.black45,
                  width: 25,
                ),
                const Text(
                  '  More details',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
        //* Contact Owner button
        InkWell(
          onTap: () {},
          child: Container(
            width: 165,
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
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Row rowContent(
    String firstHint,
    String firstContent,
    String secondHint,
    String secondContent,
    Color? color,
  ) {
    Color hintColor = const Color(0xEBFFFFFF);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            text: '$firstHint: ',
            style: TextStyle(
              color: hintColor,
            ),
            children: [
              TextSpan(
                  text: firstContent,
                  style: TextStyle(
                    color: color ?? Colors.white,
                    fontSize: 17,
                  )),
              // TextSpan(
              //   text: '/M',
              //   style: TextStyle(
              //     color: Colors.white54,
              //   ),
              // )
            ],
          ),
        ),
        // Second Child
        RichText(
          text: TextSpan(
            text: '$secondHint: ',
            style: TextStyle(
              color: hintColor,
            ),
            children: [
              TextSpan(
                text: secondContent,
                style: TextStyle(
                  color: color ?? Colors.white,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
