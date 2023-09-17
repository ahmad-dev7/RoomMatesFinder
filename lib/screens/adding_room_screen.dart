// ignore_for_file: library_prefixes

import 'package:csc_picker/csc_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rive/rive.dart';
import 'package:share_space/components/styled_button.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:share_space/main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toast/toast.dart' as textToast;

class AddRoom extends StatefulWidget {
  const AddRoom({super.key});

  @override
  State<AddRoom> createState() => _AddRoomState();
}

class _AddRoomState extends State<AddRoom> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController rentController = TextEditingController();
  TextEditingController depositController = TextEditingController();
  TextEditingController localityController = TextEditingController();
  String gender = 'Gender';
  String member = 'Member';
  String food = 'Food';
  String? country;
  String? state;
  String? city;
  final ImagePicker imagePicker = ImagePicker();
  List<File> images = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  bool uploading = false;
  bool loadingCSCPicker = true;
  pickImage() async {
    final List<XFile> pickedImages = await imagePicker.pickMultiImage();
    if (pickedImages.isNotEmpty) {
      for (var img in pickedImages) {
        images.add(File(img.path));
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 600)).then((value) {
      setState(() {
        loadingCSCPicker = false;
      });
    });
    super.initState();
  }

  bool validateForm() {
    bool result = false;
    if (localityController.text.isNotEmpty &&
        depositController.text.isNotEmpty &&
        rentController.text.isNotEmpty &&
        depositController.text.isNotEmpty &&
        food != 'Food' &&
        gender != 'Gender' &&
        member != 'Member' &&
        images.isNotEmpty) {
      setState(() {
        result = true;
      });
    }
    return result;
  }

  Future<void> addRoom() {
    CollectionReference rooms = firestore.collection('Rooms');
    return rooms.add({
      "images": imageLinks,
      "city": city,
      "locality": localityController.text,
      "rent": rentController.text,
      "deposit": depositController.text,
      "food": food,
      "member": member,
      "gender": gender,
      "description": descriptionController.text,
    });
  }

  @override
  void dispose() {
    images.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FToast widgetToast = FToast();
    widgetToast.init(context);
    double deviceWidth = MediaQuery.of(context).size.width;
    textToast.ToastContext().init(context);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar(context),
      body: ModalProgressHUD(
        inAsyncCall: uploading,
        blur: 2,
        dismissible: false,
        color: backgroundColor,
        progressIndicator: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 90,
              width: 70,
              child: RiveAnimation.asset(
                'assets/images/feature_load.riv',
              ),
            ),
            SizedBox(height: 40),
            Text(
              'Adding room to Database...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 40),
            Text(
              'Please be patience, It may take several seconds',
              style: TextStyle(
                color: Color(0x9BFFFFFF),
                backgroundColor: Colors.black,
              ),
            )
          ],
        ),
        child: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: deviceWidth - 45,
              height: 750,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Address container
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueGrey),
                    ),
                    child: Column(
                      children: [
                        loadingCSCPicker
                            ? const CircularProgressIndicator()
                            : countryStateCityPicker(),
                        localAreaInput(),
                      ],
                    ),
                  ),
                  // Description input box
                  descriptionInput(descriptionController),
                  // Rent & Deposit row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      priceInput(
                        deviceWidth: deviceWidth,
                        controller: rentController,
                        label: 'Rent',
                      ),
                      priceInput(
                        deviceWidth: deviceWidth,
                        controller: depositController,
                        label: 'Deposit',
                      ),
                    ],
                  ),
                  // Food, Gender & Member picker row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      dropdownMenu(
                        itemsList: foodList,
                        onChanged: (value) {
                          setState(() {
                            food = value;
                          });
                        },
                        text: food,
                      ),
                      dropdownMenu(
                        itemsList: genderList,
                        onChanged: (selectedGender) {
                          setState(() {
                            gender = selectedGender;
                          });
                        },
                        text: gender,
                      ),
                      dropdownMenu(
                        itemsList: memberList,
                        onChanged: (selectedMember) {
                          setState(() {
                            member = selectedMember;
                          });
                        },
                        text: member,
                      ),
                    ],
                  ),
                  // Picking image and showing them
                  Container(
                    width: double.maxFinite,
                    height: images.isNotEmpty ? 80 : 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1F313A),
                      border: Border.all(
                        color: Colors.blueGrey,
                      ),
                    ),
                    child: images.isEmpty
                        ? TextButton(
                            onPressed: () {
                              pickImage();
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Add Images',
                                  style: TextStyle(
                                    color: Colors.white70,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Icon(
                                  Icons.image_outlined,
                                  color: Color(0xFF80C1B4),
                                ),
                              ],
                            ),
                          )
                        : GridView.count(
                            crossAxisCount: images.length,
                            crossAxisSpacing: 3,
                            children: images
                                .map(
                                  (img) => Image.file(
                                    File(img.path),
                                    fit: BoxFit.cover,
                                  ),
                                )
                                .toList(),
                          ),
                  ),
                  // Submit button
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: SizedBox(
                      height: 50,
                      child: styledButton(
                        color: images.isNotEmpty
                            ? buttonColor
                            : Colors.blueGrey.shade800,
                        onTap: () async {
                          if (validateForm()) {
                            setState(() {
                              uploading = true;
                            });
                            try {
                              for (var img in images) {
                                var time =
                                    DateTime.now().microsecondsSinceEpoch;
                                var user = auth.currentUser!.displayName;
                                final storage = FirebaseStorage.instance;
                                var path = 'images/$time$user.jpg';
                                var file = File(img.path);
                                var ref = storage.ref().child(path);
                                await ref.putFile(file).whenComplete(() async {
                                  var downloadUrl = await ref.getDownloadURL();
                                  imageLinks.add(downloadUrl);
                                });
                              }
                              addRoom();
                              setState(() {
                                AudioPlayer player = AudioPlayer();
                                widgetToast.showToast(
                                  toastDuration: const Duration(seconds: 5),
                                  gravity: ToastGravity.CENTER,
                                  child: const RiveAnimation.asset(
                                    'assets/images/success.riv',
                                  ),
                                );
                                player.play(
                                  AssetSource(
                                    'assets/successAudio.mp3',
                                  ),
                                );
                                uploading = false;
                                Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                    child: const ScreensNavigatorMenu(),
                                    type: PageTransitionType.fade,
                                    duration: const Duration(seconds: 5),
                                  ),
                                );
                              });
                            } catch (e) {
                              debugPrint('$e');
                            }
                          } else {
                            debugPrint('fields are empty');
                            textToast.Toast.show(
                              '\nAll fields are necessary\n',
                              duration: 3,
                              gravity: textToast.Toast.center,
                              backgroundRadius: 10,
                            );
                          }
                        },
                        text: 'Submit',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

//* Body ends here

//* Methods

  List<String> imageLinks = [];

  Container localAreaInput() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(left: 10),
      height: 42,
      color: city == null ? Colors.blueGrey.shade700 : Colors.blueGrey,
      child: TextField(
        textCapitalization: TextCapitalization.words,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        controller: localityController,
        decoration: InputDecoration(
          hintText: 'Enter local area eg. Belapur',
          hintStyle: const TextStyle(color: Colors.white70),
          border: InputBorder.none,
          enabled: city == null ? false : true,
        ),
      ),
    );
  }

  CSCPicker countryStateCityPicker() {
    return CSCPicker(
      dropdownDecoration: BoxDecoration(color: inputFieldColor),
      disabledDropdownDecoration: BoxDecoration(
        color: Colors.blueGrey.shade700,
      ),
      selectedItemStyle: const TextStyle(color: Colors.white, fontSize: 16),
      onCountryChanged: (pickedCountry) {
        country = pickedCountry;
      },
      onStateChanged: (pickedState) {
        state = pickedState;
      },
      onCityChanged: (pickedCity) {
        city = pickedCity;
        setState(() {});
        print('$country,\n $state,\n $city');
      },
    );
  }

  Container dropdownMenu({
    required List<DropdownMenuItem<dynamic>>? itemsList,
    required void Function(dynamic)? onChanged,
    required String text,
  }) {
    return Container(
      height: 40,
      padding: const EdgeInsets.only(left: 5),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blueGrey,
        ),
      ),
      child: DropdownButton(
        icon: const Icon(
          Icons.arrow_drop_down_sharp,
          color: Color(0xFF80C1B4),
        ),
        underline: const SizedBox(),
        items: itemsList,
        onChanged: onChanged,
        elevation: 5,
        dropdownColor: inputFieldColor,
        hint: Text(
          text,
          style: TextStyle(
            color: text == 'Food' || text == 'Gender' || text == 'Member'
                ? Colors.white60
                : Colors.white,
          ),
        ),
        iconEnabledColor: Colors.white70,
        iconSize: 30,
      ),
    );
  }

  List<DropdownMenuItem> foodList = [
    const DropdownMenuItem(
      value: 'Veg',
      child: Text(
        'Veg',
        style: TextStyle(color: Colors.white),
      ),
    ),
    const DropdownMenuItem(
      value: 'Non-Veg',
      child: Text(
        'Non-Veg',
        style: TextStyle(color: Colors.white),
      ),
    )
  ];

  List<DropdownMenuItem> memberList = [
    const DropdownMenuItem(
      value: 'Student',
      child: Text(
        'Student',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    ),
    const DropdownMenuItem(
      value: 'Employee',
      child: Text(
        'Employee',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    ),
    const DropdownMenuItem(
      value: 'Any',
      child: Text(
        'Any',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    ),
  ];

  List<DropdownMenuItem> genderList = [
    const DropdownMenuItem(
      value: 'Male',
      child: Text(
        'Male',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    ),
    const DropdownMenuItem(
      value: 'Female',
      child: Text(
        'Female',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    ),
  ];

  AppBar appBar(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      title: const Text('Add new room'),
      centerTitle: true,
      automaticallyImplyLeading: false,
    );
  }

  SizedBox priceInput({
    required double deviceWidth,
    required TextEditingController controller,
    required String label,
  }) {
    return SizedBox(
      height: 55,
      width: deviceWidth / 2.5,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [LengthLimitingTextInputFormatter(5)],
        style: const TextStyle(color: Colors.white, fontSize: 18),
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.currency_rupee,
            color: Color(0xFF80C1B4),
            size: 18,
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blueGrey,
            ),
          ),
          labelStyle: const TextStyle(color: Colors.white70),
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  TextFormField descriptionInput(TextEditingController controller) {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.done,
      controller: descriptionController,
      minLines: 1,
      maxLines: 6,
      maxLength: 200,
      style: const TextStyle(
        height: 1.2,
        color: Colors.white,
        fontSize: 16,
      ),
      decoration: const InputDecoration(
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.blueGrey)),
        border: OutlineInputBorder(),
        counterStyle: TextStyle(
          color: Colors.white,
          backgroundColor: Color(0x43000000),
        ),
        hintText: 'Add description about your room...',
        hintStyle: TextStyle(
          color: Colors.white60,
          fontSize: 13,
        ),
      ),
    );
  }
}
