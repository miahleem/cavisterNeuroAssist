import 'package:flutter/material.dart';
import 'dart:io';

class ImagePickerWidget extends StatelessWidget {
  final File? image;
  final VoidCallback onPickImage;

  ImagePickerWidget({required this.image, required this.onPickImage});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        image == null
            ? Icon(Icons.image, size: 100, color: Colors.indigo[900])
            : ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(image!, height: 200),
              ),
        SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: onPickImage,
          icon: Icon(Icons.upload_file, color: Colors.white),
          label: Text('Select MRI Scan'),
        ),
      ],
    );
  }
}
