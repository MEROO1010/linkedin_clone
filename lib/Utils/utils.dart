import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
// Add this import
import 'dart:typed_data'; // Add this import

Future<Uint8List?> pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);
  if (file != null) {
    return await file
        .readAsBytes(); // Use readAsBytes to read the file as bytes
  }
  print('No image selected');
  return null; // Return null if no image is selected
}

void showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}
