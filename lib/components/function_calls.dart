import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FunctionCalls {
  fetchRooms() {
    debugPrint('Fetched Rooms');
  }

  deleteRooms() {
    debugPrint('Deleted Rooms');
  }

  createRooms() {
    debugPrint('Created Rooms');
  }

  Future<dynamic> pickImage() async {
    final ImagePicker imagePicker = ImagePicker();
    List collectedImages = [];
    final List<XFile> pickedImages = await imagePicker.pickMultiImage();
    if (pickedImages.isNotEmpty) {
      for (var img in pickedImages) {
        collectedImages.add(File(img.path));
      }
      return collectedImages;
    }
  }
}
