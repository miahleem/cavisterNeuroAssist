import 'package:flutter/material.dart';
import 'screen/upload_screen.dart';

void main() {
  runApp(NeuroAssist());
}

class NeuroAssist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MRI Scan Analyzer',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: MRIUploadScreen(),
    );
  }
}
