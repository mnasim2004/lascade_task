import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:edge_detection/edge_detection.dart';
import 'dart:io';
import 'package:opencv_dart/opencv_dart.dart' as cv;
import 'package:image/image.dart' as img;

class Detection2 extends StatefulWidget {
  const Detection2({super.key});

  @override
  State<Detection2> createState() => _Detection2State();
}

class _Detection2State extends State<Detection2> with WidgetsBindingObserver {
  List<CameraDescription> cameras = [];
  CameraController? cameraController;
  File? _processedImageFile; // Store the processed image file here

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (cameraController == null ||
        cameraController?.value.isInitialized == false) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _setupCameraController();
    }
  }

  @override
  void initState() {
    super.initState();
    _setupCameraController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    if (cameraController == null ||
        cameraController?.value.isInitialized == false) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return SafeArea(
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_processedImageFile != null)
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.80,
                width: MediaQuery.sizeOf(context).width * 0.80,
                child: Image.file(
                  _processedImageFile!,
                  fit: BoxFit.contain,
                ),
              )
            else
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.80,
                width: MediaQuery.sizeOf(context).width * 0.80,
                child: CameraPreview(
                  cameraController!,
                ),
              ),
            IconButton(
              onPressed: () async {
                XFile picture = await cameraController!.takePicture();
                _processImage(picture.path);
              },
              iconSize: 100,
              icon: const Icon(
                Icons.camera,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _setupCameraController() async {
    List<CameraDescription> _cameras = await availableCameras();
    if (_cameras.isNotEmpty) {
      setState(() {
        cameras = _cameras;
        cameraController = CameraController(
          _cameras.first,
          ResolutionPreset.high,
        );
      });
      cameraController?.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      }).catchError(
        (Object e) {
          print(e);
        },
      );
    }
  }

//   Future<void> _processImage(String imagePath) async {
//     String? detectedEdgesPath;
//     try {
//       // Detect edges using edge_detection package
//       detectedEdgesPath =
//           (await EdgeDetection.detectEdge(imagePath)) as String?;

//       if (detectedEdgesPath != null) {
//         setState(() {
//           _processedImageFile = File(detectedEdgesPath!);
//         });
//       }
//     } catch (e) {
//       print('Edge detection error: $e');
//     }
//   }
// }

// Future<void> _processImage(String imagePath) async {
//   String? detectedPolygonPath;
//   try {
//     // Detect polygon using native code
//     detectedPolygonPath = await PolygonDetector.detectPolygon(imagePath);

//     if (detectedPolygonPath != null) {
//       setState(() {
//         _processedImageFile = File(detectedPolygonPath);
//       });
//     }
//   } catch (e) {
//     print('Polygon detection error: $e');
//   }
// }

  Future<void> _processImage(String imagePath) async {
    try {
      // Read the image using opencv_dart
      final img = cv.imread(imagePath, flags: cv.IMREAD_COLOR);

      // Convert image to grayscale
      final gray = cv.cvtColor(img, cv.COLOR_BGR2GRAY);

      // Apply Gaussian Blur to smooth the image
      final blurred = cv.gaussianBlur(gray, [5, 5] as (int, int), 0);

      // Perform edge detection using Canny
      final edges = cv.canny(blurred, 100, 200);

      // Find contours in the image
      final contours = cv.findContours(
        edges,
        cv.RETR_TREE,
        cv.CHAIN_APPROX_SIMPLE,
      );

      // Draw the contours on the original image
      final output = img.clone();
      cv.drawContours(
          output, contours as cv.Contours, -1, [0, 255, 0] as cv.Scalar);

      // Save and display the processed image
      cv.imwrite('output_image.png', output);

      setState(() {
        _processedImageFile = File('output_image.png');
      });
    } catch (e) {
      print('Error processing image: $e');
    }
  }
}
