// import 'dart:io';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:opencv_4/opencv_4.dart'; // Ensure you have the OpenCV package
// import 'package:image/image.dart' as img; // For image processing

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
//   List<CameraDescription> cameras = [];
//   CameraController? cameraController;
//   File? _processedImageFile;

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     super.didChangeAppLifecycleState(state);
//     if (cameraController == null || !cameraController!.value.isInitialized) {
//       return;
//     }

//     if (state == AppLifecycleState.inactive) {
//       cameraController?.dispose();
//     } else if (state == AppLifecycleState.resumed) {
//       _setupCameraController();
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _setupCameraController();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _buildUI(),
//     );
//   }

//   Widget _buildUI() {
//     if (cameraController == null || !cameraController!.value.isInitialized) {
//       return const Center(
//         child: CircularProgressIndicator(),
//       );
//     }

//     return SafeArea(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           _buildCameraPreview(),
//           _buildCaptureButton(),
//           if (_processedImageFile != null) _buildProcessedImagePreview(),
//         ],
//       ),
//     );
//   }

//   Widget _buildCameraPreview() {
//     return SizedBox(
//       height: MediaQuery.of(context).size.height * 0.60,
//       width: MediaQuery.of(context).size.width * 0.80,
//       child: CameraPreview(cameraController!),
//     );
//   }

//   Widget _buildCaptureButton() {
//     return IconButton(
//       onPressed: () async {
//         XFile picture = await cameraController!.takePicture();
//         await _processImage(picture.path);
//       },
//       iconSize: 100,
//       icon: const Icon(
//         Icons.camera,
//         color: Colors.red,
//       ),
//     );
//   }

//   Widget _buildProcessedImagePreview() {
//     return SizedBox(
//       height: MediaQuery.of(context).size.height * 0.20,
//       width: MediaQuery.of(context).size.width * 0.80,
//       child: Image.file(_processedImageFile!),
//     );
//   }

//   Future<void> _setupCameraController() async {
//     List<CameraDescription> _cameras = await availableCameras();
//     if (_cameras.isNotEmpty) {
//       setState(() {
//         cameras = _cameras;
//         cameraController = CameraController(
//           _cameras.first,
//           ResolutionPreset.high,
//         );
//       });
//       cameraController?.initialize().then((_) {
//         if (!mounted) {
//           return;
//         }
//         setState(() {});
//       }).catchError((Object e) {
//         print(e);
//       });
//     }
//   }

//   Future<void> _processImage(String imagePath) async {
//     try {
//       // Load the image as a byte array
//       img.Image? originalImage =
//           img.decodeImage(File(imagePath).readAsBytesSync());

//       if (originalImage != null) {
//         // Preprocess: Convert the image to grayscale
//         img.Image grayscaleImage = img.grayscale(originalImage);

//         // Save the grayscale image for Canny
//         String grayImagePath = '${imagePath}_gray.png';
//         File(grayImageFile) = File(grayImagePath)
//           ..writeAsBytesSync(img.encodePng(grayscaleImage));

//         // Perform edge detection using OpenCV
//         final result = await Cv2.canny(grayImagePath, 50, 150);

//         // Save the edge-detected image
//         String edgeImagePath = '${imagePath}_edges.png';
//         File(edgeFile) = File(edgeImagePath)..writeAsBytesSync(result);

//         // Store the processed image for display
//         setState(() {
//           _processedImageFile = File(edgeImagePath);
//         });
//       }
//     } catch (e) {
//       print('Error processing image: $e');
//     }
//   }
// }
