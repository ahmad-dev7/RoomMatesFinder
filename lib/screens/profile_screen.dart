import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:share_space/main.dart';
import 'package:share_space/screens/welcome_screen.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  User auth = FirebaseAuth.instance.currentUser!;
  List<Widget> postedRooms = [];
  bool loadingData = true;
  CollectionReference collection =
      FirebaseFirestore.instance.collection('Rooms');
  getData() async {
    postedRooms.clear();
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('Rooms')
              .where(Filter('number', isEqualTo: auth.phoneNumber))
              .get();
      if (querySnapshot.docs.isNotEmpty) {
        debugPrint('snapshot has data');
        for (var documents in querySnapshot.docs) {
          var data = documents.data();
          String locality = data['locality'];
          String depositAmount = data['deposit'];
          String rentAmount = data['rent'];
          String id = documents.id;
          setState(() {
            postedRooms.add(
              yourRoomsContainer(
                id: id,
                rent: rentAmount,
                deposit: depositAmount,
                locality: locality,
              ),
            );
            debugPrint("${postedRooms.length} room lists");
          });
        }
      } else {
        setState(() {
          postedRooms.add(
            const Text(
              'You have not added any room',
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
    if (postedRooms.isNotEmpty) {
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
    String name = auth.displayName!;
    String number = auth.phoneNumber!;
    String email = auth.email!;
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13.5),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 35,
                        child: Icon(Icons.person, size: 35),
                      ),
                    ),
                    const SizedBox(width: 25),
                    SizedBox(
                      height: 90,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          customText(
                              text: name, size: 25, weight: FontWeight.w400),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Container(
                  height: 370,
                  width: double.maxFinite,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF102833),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customText(
                          text: 'Your Rooms',
                          size: 25,
                          weight: FontWeight.bold,
                        ),
                        const SizedBox(height: 10),
                        Visibility(
                          visible: !loadingData,
                          replacement: const CircularProgressIndicator(),
                          child: Column(
                            children: postedRooms,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                customText(text: email),
                const SizedBox(height: 5),
                customText(text: number),
                const SizedBox(height: 25),
                logoutButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container yourRoomsContainer({
    required String id,
    required String locality,
    required String rent,
    required String deposit,
  }) {
    return Container(
      height: 125,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              customInfoText(title: 'Locality', info: locality),
              customInfoText(title: 'Rent', info: rent),
              customInfoText(title: 'Deposit', info: deposit),
            ],
          ),
          Wrap(
            children: [
              const SizedBox(
                height: 125,
                child: VerticalDivider(
                  color: Color(0xFF10232D),
                ),
              ),
              SizedBox(
                height: 125,
                width: 70,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {
                        Alert(
                          context: context,
                          type: AlertType.warning,
                          title: "Are you sure?",
                          style: AlertStyle(
                              backgroundColor: backgroundColor,
                              titleStyle:
                                  const TextStyle(color: Colors.redAccent)),
                          content: const Text(
                            'You want to delete this room!',
                            style: TextStyle(color: Colors.white),
                          ),
                          buttons: [
                            DialogButton(
                              color: Colors.grey,
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            DialogButton(
                              color: Colors.red,
                              child: const Text('Delete'),
                              onPressed: () {
                                collection.doc(id).delete();
                                Navigator.pop(context);
                                getData();
                              },
                            ),
                          ],
                        ).show();
                      },
                      icon: const Icon(
                        Icons.delete,
                        size: 30,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  ElevatedButton logoutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Alert(
          context: context,
          type: AlertType.warning,
          title: "Do you want to Logout?",
          buttons: [
            DialogButton(
              color: Colors.grey,
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            DialogButton(
              color: Colors.red,
              child: const Text('Logout'),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  PageTransition(
                    child: const WelcomeScreen(),
                    type: PageTransitionType.fade,
                  ),
                );
              },
            ),
          ],
        ).show();
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent, minimumSize: const Size(170, 45)),
      child: const Text('Logout'),
    );
  }

  Text customText({
    required String text,
    double? size,
    FontWeight? weight,
    Color? color,
  }) {
    return Text(
      text,
      style: TextStyle(
        color: color ?? Colors.white,
        fontSize: size ?? 16,
        fontWeight: weight ?? FontWeight.normal,
      ),
    );
  }

  Row customInfoText(
      {required String title,
      required String info,
      Color? color,
      double? size}) {
    return Row(
      children: [
        customText(
          text: '$title: ',
          color: color,
          size: size,
        ),
        const SizedBox(width: 5),
        customText(text: info, color: const Color(0xFFCECCCC), size: size)
      ],
    );
  }
}
