// // import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
// // import 'package:flutter/material.dart';
// // import 'package:vector_math/vector_math_64.dart' as vector;

// // class ARView extends StatefulWidget {
// //   final String modelPath; // Path of the converted 3D model file

// //   ARView({required this.modelPath, required String glbFilePath});

// //   @override
// //   _ARViewState createState() => _ARViewState();
// // }

// // class _ARViewState extends State<ARView> {
// //   ArCoreController? arCoreController;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('AR View'),
// //       ),
// //       body: ArCoreView(
// //         onArCoreViewCreated: _onArCoreViewCreated,
// //       ),
// //     );
// //   }

// //   void _onArCoreViewCreated(ArCoreController controller) {
// //     arCoreController = controller;
// //     _add3DModel(widget.modelPath);
// //   }

// //   void _add3DModel(String modelPath) async {
// //     final node = ArCoreReferenceNode(
// //       name: "3DModel",
// //       object3DFileName: modelPath, // Should be an .obj or .fbx file
// //       scale: vector.Vector3(0.5, 0.5, 0.5),
// //       position: vector.Vector3(0.0, 0.0, -1.0),
// //     );

// //     arCoreController?.addArCoreNode(node);
// //   }

// //   @override
// //   void dispose() {
// //     arCoreController?.dispose();
// //     super.dispose();
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'dart:html' as html;
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'ar_web.dart';

// class ARView extends StatefulWidget {
//   final String modelPath;

//   ARView({required this.modelPath});

//   @override
//   _ARViewState createState() => _ARViewState();
// }

// class _ARViewState extends State<ARView> {
//   @override
//   void initState() {
//     super.initState();
//     if (kIsWeb) {
//       initWebXR(widget.modelPath); // Call the web-specific function
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('AR View'),
//       ),
//       body: Center(
//         child: Text('AR content will be displayed here.'),
//       ),
//     );
//   }
// }
