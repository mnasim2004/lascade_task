import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class ARView extends StatelessWidget {
  final String? usdzFilePath;

  ARView({this.usdzFilePath});

  @override
  Widget build(BuildContext context) {
    print(usdzFilePath);
    return Scaffold(
      appBar: AppBar(
        title: Text('AR View'),
      ),
      body: Center(
        child: ModelViewer(src: usdzFilePath ?? "", ar: true),
      ),
    );
  }
}
