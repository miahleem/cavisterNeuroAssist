import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:animate_do/animate_do.dart';

class FileUploadWidget extends StatefulWidget {
  final Function(String?) onFileSelected;
  FileUploadWidget({required this.onFileSelected});

  @override
  _FileUploadWidgetState createState() => _FileUploadWidgetState();
}

class _FileUploadWidgetState extends State<FileUploadWidget> {
  File? _file;

  Future<void> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'dcm'],
      );
      if (result != null) {
        setState(() {
          _file = File(result.files.single.path!);
        });
        widget.onFileSelected(_file!.path);
      } else {
        print("No file selected");
      }
    } catch (e) {
      print("Error picking file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FadeIn(
          child: Text(
            _file == null
                ? "No file selected."
                : "File: ${_file!.path.split('/').last}",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
        SizedBox(height: 20),
        BounceInDown(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 32),
              backgroundColor: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),

            //SizedBox(height: 20),

            onPressed: pickFile,
            child:
                Text("Upload MRI File", style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}
