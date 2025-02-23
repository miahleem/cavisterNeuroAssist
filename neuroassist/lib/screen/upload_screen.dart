import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '/utils/api_service.dart';

class MRIUploadScreen extends StatefulWidget {
  @override
  _MRIUploadScreenState createState() => _MRIUploadScreenState();
}

class _MRIUploadScreenState extends State<MRIUploadScreen> {
  List<File> _selectedImages = [];
  List<Map<String, dynamic>> _results = [];
  bool _isLoading = false;

  Future<void> _pickImages() async {
    final pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles != null && pickedFiles.length <= 10) {
      setState(() {
        _selectedImages = pickedFiles.map((file) => File(file.path)).toList();
        _results = []; // Reset previous results
      });
    } else if (pickedFiles != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You can only select up to 10 images.")),
      );
    }
  }

  Future<void> _uploadImages() async {
    if (_selectedImages.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ApiService.uploadMRIs(_selectedImages);
      setState(() {
        _results = response;
      });
    } catch (e) {
      setState(() {
        _results = [
          {"error": "Error processing scans"}
        ];
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("MRI Analysis"), backgroundColor: Colors.teal),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_selectedImages.isNotEmpty)
              Container(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedImages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(_selectedImages[index], height: 100),
                      ),
                    );
                  },
                ),
              ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _pickImages,
              icon: Icon(Icons.image),
              label: Text("Select MRI Scans"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _uploadImages,
              icon: Icon(Icons.upload),
              label: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("Upload & Analyze"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            ),
            SizedBox(height: 20),
            if (_results.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        title: Text("Scan ${index + 1}"),
                        subtitle:
                            Text("Diagnosis: ${_results[index]['result']}"),
                        leading: Icon(Icons.local_hospital, color: Colors.teal),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
