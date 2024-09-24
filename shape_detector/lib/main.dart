import 'package:flutter/material.dart';
import 'package:shape_detector/homepage.dart'; // Import the file where HomePage is defined.

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '3D Model Viewer', // Set your app title here
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(), // Provide the title here
    );
  }
}
