import 'dart:async';
import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_space/components/contact_button.dart';
import 'package:share_space/constants.dart';
import 'package:share_space/main.dart';
import 'package:rive/rive.dart';
import 'package:share_space/screens/more_info_screen.dart';
import 'package:toast/toast.dart';

late double deviceWidth;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loadingData = true;
  bool show = true;
  FirebaseAuth auth = FirebaseAuth.instance;
  bool loadingImage = false;
  TextEditingController inputController = TextEditingController();
  List<Widget> roomList = [];
  getData({Filter? searchTerm}) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('Rooms')
              .where(searchTerm ?? Filter('rent', isGreaterThan: '0'))
              .get();
      // .where('gender', isEqualTo: 'Female')
      if (querySnapshot.docs.isNotEmpty) {
        debugPrint('snapshot has data');
        for (var documents in querySnapshot.docs) {
          var data = documents.data();
          List<dynamic> imageList = data['images'];
          String gender = data['gender'];
          String locality = data['locality'];
          String memberType = data['member'];
          String depositAmount = data['deposit'];
          String rentAmount = data['rent'];
          String foodType = data['food'];
          String description = data['description'];
          String city = data['city'];
          String number = data['number'];
          String postedBy = data['postedBy'];
          String nearBy = data['nearBy'];
          String religion = data['religion'];
          String memberCount = data['memberCount'];
          setState(() {
            roomList.add(
              roomContainer(
                rentAmount: rentAmount,
                depositAmount: depositAmount,
                memberType: memberType,
                locality: locality,
                foodType: foodType,
                gender: gender,
                description: description,
                city: city,
                imageList: imageList,
                number: number,
                postedBy: postedBy,
                nearBy: nearBy,
                religion: religion,
                memberCount: memberCount,
              ),
            );
            debugPrint("${roomList.length} room lists");
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
    if (roomList.isNotEmpty) {
      setState(() {
        debugPrint('making loading data false');
        loadingData = false;
      });
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    ToastContext().init(context);
    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          sliverAppBar(),
          SliverToBoxAdapter(
            child: loadingData
                ? const Center(
                    child: SizedBox(
                      height: 90,
                      width: 70,
                      child: RiveAnimation.asset(
                        'assets/images/loading2.riv',
                        placeHolder: Text('Loading Data...'),
                      ),
                    ),
                  )
                : Column(
                    children: roomList,
                  ),
          ),
        ],
      ),
    );
  }

// Scaffold Body ends here

  SliverAppBar sliverAppBar() {
    return SliverAppBar(
      automaticallyImplyLeading: false,
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
            keyboardAppearance: Brightness.dark,
            onEditingComplete: () {
              roomList.clear();
              setState(() {
                loadingData = true;
                getData(
                    searchTerm: Filter.or(
                  Filter('locality', isEqualTo: inputController.text),
                  Filter(
                    'city',
                    isEqualTo: inputController.text,
                  ),
                ));
              });
            },
            textCapitalization: TextCapitalization.words,
            onChanged: (value) => setState(() {
              inputController.text.isEmpty
                  ? setState(() {
                      loadingData = true;
                      roomList.clear();
                      getData();
                    })
                  : debugPrint(value);
            }),
            controller: inputController,
            style: const TextStyle(fontSize: 11, color: Colors.white),
            decoration: InputDecoration(
              suffixIcon: Visibility(
                visible: inputController.text.isNotEmpty,
                child: InkWell(
                  onTap: () {
                    inputController.clear();
                    roomList.clear();
                    getData();
                  },
                  child: const Icon(Icons.close, size: 20, color: Colors.grey),
                ),
              ),
              hintText: 'Find rooms by city or locality',
              hintStyle: const TextStyle(
                color: Color(0xD38EA4A9),
                fontSize: 10,
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
    required String description,
    required String city,
    required String number,
    required String postedBy,
    required String nearBy,
    required String religion,
    required String memberCount,
    required List<dynamic> imageList,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: OpenContainer(
          closedColor: primaryColor,
          middleColor: primaryColor,
          openColor: primaryColor,
          transitionDuration: const Duration(seconds: 1),
          tappable: false,
          openBuilder: (context, action) {
            return OpenBuilderWidget(
              imageList: imageList,
              city: city,
              rentAmount: rentAmount,
              depositAmount: depositAmount,
              gender: gender,
              foodType: foodType,
              memberType: memberType,
              locality: locality,
              description: description,
              nearBy: nearBy,
              number: number,
              ownerName: postedBy,
              religion: religion,
              memberCount: memberCount,
            );
          },
          closedBuilder: (context, action) {
            return Container(
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
                  imageContainer(imageList, 0, SwiperLayout.STACK, 0),
                  //* Details rows
                  infoRows(
                    action: action,
                    rentAmount: rentAmount,
                    depositAmount: depositAmount,
                    memberType: memberType,
                    locality: locality,
                    foodType: foodType,
                    gender: gender,
                    number: number,
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> loadImage(String imageUrl) {
    final completer = Completer<void>();
    Image.network(imageUrl)
        .image
        .resolve(const ImageConfiguration())
        .addListener(
          ImageStreamListener(
            (ImageInfo info, bool synchronousCall) {
              completer.complete();
            },
            onError: (dynamic exception, StackTrace? stackTrace) {
              completer.completeError(exception);
            },
          ),
        );
    return completer.future;
  }

  Swiper imageContainer(
    List<dynamic> imageList,
    double? viewPort,
    SwiperLayout? layout,
    double? bottomRadius,
  ) {
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
      // will be taken
      viewportFraction: viewPort ?? 0,
      layout: layout ?? SwiperLayout.STACK,
      itemWidth: deviceWidth - 30,
      itemHeight: 250,
      loop: true,
      autoplayDelay: 60000,
      autoplay: true,
      duration: 500,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        String imagePath = imageList[index];
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: Image.network(
            imagePath,
            height: 250,
            width: double.maxFinite,
            fit: BoxFit.cover,
          ),
        );
        // return index == 0
        //     ? FutureBuilder(
        //         future: loadImage(imagePath),
        //         builder: (context, snapshot) {
        //           if (snapshot.connectionState == ConnectionState.waiting) {
        //             return const Padding(
        //               padding: EdgeInsets.symmetric(
        //                 horizontal: 10,
        //                 vertical: 80,
        //               ),
        //               child: RiveAnimation.asset(
        //                 'assets/images/loading2.riv',
        //               ),
        //             );
        //           } else {
        //             return swiperContent(index, imageList);
        //           }
        //         },
        //       )
        //     : swiperContent(index, imageList);
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

  Padding infoRows(
      {required void Function() action,
      required String rentAmount,
      required String depositAmount,
      required String memberType,
      required String locality,
      required String foodType,
      required String number,
      required String gender}) {
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
            fourthRowInfo(
              action,
              rentAmount,
              number,
            ),
          ],
        ),
      ),
    );
  }

//* contact and more detail buttons
  Row fourthRowInfo(void Function() action, String rentAmount, String number) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //* More details button

        InkWell(
          onTap: action,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
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
                  color: Colors.black54,
                  width: 25,
                ),
                const Text(
                  '  More details',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),

        //* Contact Owner button
        ContactButton(number: number),
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
