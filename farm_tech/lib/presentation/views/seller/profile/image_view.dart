import 'dart:io';

import 'package:flutter/material.dart';

// widget to view an image when clicked in a seperate window
class ImageView extends StatelessWidget {
  // constructor
  ImageView({required this.assetName, this.file});

  final String assetName; // image path
  File? file; // file object of file image (picked image)

  @override
  Widget build(BuildContext context) {
    // if assetName is empty means image is a file object
    return assetName.isNotEmpty
        ? InteractiveViewer(child: Image.network(assetName))
        : InteractiveViewer(child: Image.file(file!));
  }
}
