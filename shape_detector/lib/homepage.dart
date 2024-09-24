// import 'dart:io';

// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:shape_detector/api.dart';
// // import 'package:model_viewer_plus/model_viewer_plus.dart';
// import 'package:flutter_3d_model/flutter_3d_model.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
//   List<CameraDescription> cameras = [];
//   CameraController? cameraController;
//   String? _modelPath; // Variable to hold the model path
//   int currentCameraIndex = 0; // Track the current camera index

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     super.didChangeAppLifecycleState(state);
//     if (cameraController == null ||
//         cameraController?.value.isInitialized == false) {
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
//     if (cameraController == null ||
//         cameraController?.value.isInitialized == false) {
//       return const Center(
//         child: CircularProgressIndicator(),
//       );
//     }

//     return SafeArea(
//       child: SizedBox.expand(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // Display the camera preview if the model path is not set
//             if (_modelPath == null)
//               Expanded(
//                 child: SizedBox(
//                   width: MediaQuery.of(context).size.width * 0.80,
//                   child: CameraPreview(cameraController!),
//                 ),
//               )
//             // Display the model viewer if _modelPath is set
//             else
//               Expanded(
//                 child: ModelViewer(
//                   src: _modelPath!, // Path to the GLB model
//                   alt: "A 3D model", // Alternative text for accessibility
//                   autoRotate: true, // Automatically rotate the model
//                   cameraControls: true, // Enable camera controls
//                 ),
//               ),
//             // Icon Button
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 16.0),
//               child: IconButton(
//                 onPressed: () async {
//                   // Your existing button logic here...
//                   print('Camera button pressed'); // Debug print
//                   XFile picture = await cameraController!.takePicture();
//                   String imagePath = picture.path;
//                   print('Picture taken at: $imagePath'); // Debug print
//                   String? glbFilePath = await sendImageAndReceiveGLB(imagePath);

//                   print('GLB file path received: $glbFilePath'); // Debug print

//                   if (glbFilePath != null && glbFilePath.isNotEmpty) {
//                     print(
//                         'Displaying GLB file with path: $glbFilePath'); // Debug print
//                     setState(() {
//                       _modelPath = glbFilePath; // Store the path for displaying
//                     });
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                           content: Text('Failed to receive GLB file.')),
//                     );
//                   }
//                 },
//                 iconSize: 100,
//                 icon: const Icon(
//                   Icons.camera,
//                   color: Colors.red,
//                 ),
//               ),
//             ),
//             // Optional: Display the model path
//             if (_modelPath != null)
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Text(
//                   'GLB File Path:\n$_modelPath',
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(fontSize: 16, color: Colors.black),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _setupCameraController() async {
//     List<CameraDescription> _cameras = await availableCameras();
//     if (_cameras.isNotEmpty) {
//       setState(() {
//         cameras = _cameras;
//         cameraController = CameraController(
//           _cameras[currentCameraIndex],
//           ResolutionPreset.high,
//         );
//       });
//       cameraController?.initialize().then((_) {
//         if (!mounted) return;
//         setState(() {});
//       }).catchError((Object e) {
//         print(e);
//       });
//     }
//   }

//   void _switchCamera() {
//     if (cameras.isNotEmpty) {
//       // Switch between the first and last camera
//       currentCameraIndex = (currentCameraIndex == 0) ? cameras.length - 1 : 0;
//       _setupCameraController();
//     }
//   }
// }

//   // Widget _buildUI() {
//   //   if (cameraController == null ||
//   //       cameraController?.value.isInitialized == false) {
//   //     return const Center(
//   //       child: CircularProgressIndicator(),
//   //     );
//   //   }

//   //   return SafeArea(
//   //     child: SizedBox.expand(
//   //       child: Column(
//   //         mainAxisAlignment: MainAxisAlignment.start,
//   //         crossAxisAlignment: CrossAxisAlignment.center,
//   //         children: [
//   //           // Camera Preview wrapped in Expanded to take up available space
//   //           Expanded(
//   //             child: SizedBox(
//   //               width: MediaQuery.of(context).size.width *
//   //                   0.80, // Corrected MediaQuery usage
//   //               child: CameraPreview(cameraController!),
//   //             ),
//   //           ),
//   //           // Icon Button
//   //           Padding(
//   //             padding: const EdgeInsets.symmetric(vertical: 16.0),
//   //             child: IconButton(
//   //               onPressed: () async {
//   //                 print('Camera button pressed'); // Debug print
//   //                 XFile picture = await cameraController!.takePicture();
//   //                 String imagePath = picture.path;
//   //                 print('Picture taken at: $imagePath'); // Debug print
//   //                 String? glbFilePath = await sendImageAndReceiveGLB(imagePath);

//   //                 print('GLB file path received: $glbFilePath'); // Debug print

//   //                 if (glbFilePath != null && glbFilePath.isNotEmpty) {
//   //                   print(
//   //                       'Displaying GLB file with path: $glbFilePath'); // Debug print
//   //                   setState(() {
//   //                     _modelPath = glbFilePath; // Store the path for displaying
//   //                   });
//   //                 } else {
//   //                   ScaffoldMessenger.of(context).showSnackBar(
//   //                     const SnackBar(
//   //                         content: Text('Failed to receive GLB file.')),
//   //                   );
//   //                 }
//   //               },
//   //               iconSize: 100,
//   //               icon: const Icon(
//   //                 Icons.camera,
//   //                 color: Colors.red,
//   //               ),
//   //             ),
//   //           ),
//   //           // Display the model path if it's set
//   //           if (_modelPath != null)
//   //             Padding(
//   //               padding: const EdgeInsets.all(16.0),
//   //               child: Text(
//   //                 'GLB File Path:\n$_modelPath',
//   //                 textAlign: TextAlign.center,
//   //                 style: const TextStyle(fontSize: 16, color: Colors.black),
//   //               ),
//   //             ),
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   // }
//   // Import the package

// // ... existing code ...
//   // Widget _buildUI() {
//   //   if (cameraController == null ||
//   //       cameraController?.value.isInitialized == false) {
//   //     return const Center(
//   //       child: CircularProgressIndicator(),
//   //     );
//   //   }

//   //   return SafeArea(
//   //     child: SizedBox.expand(
//   //       child: Column(
//   //         mainAxisAlignment: MainAxisAlignment.start,
//   //         crossAxisAlignment: CrossAxisAlignment.center,
//   //         children: [
//   //           // Camera Preview wrapped in Expanded to take up available space
//   //           Expanded(
//   //             flex:
//   //                 3, // Use flex to adjust the space taken by the camera preview
//   //             child: SizedBox(
//   //               width: MediaQuery.of(context).size.width * 0.80,
//   //               child: CameraPreview(cameraController!),
//   //             ),
//   //           ),
//   //           // Icon Button
//   //           Padding(
//   //             padding: const EdgeInsets.symmetric(vertical: 16.0),
//   //             child: IconButton(
//   //               onPressed: () async {
//   //                 // Capture image and handle the GLB model logic
//   //                 print('Camera button pressed'); // Debug print
//   //                 XFile picture = await cameraController!.takePicture();
//   //                 String imagePath = picture.path;
//   //                 print('Picture taken at: $imagePath'); // Debug print
//   //                 String? glbFilePath = await sendImageAndReceiveGLB(imagePath);

//   //                 print('GLB file path received: $glbFilePath'); // Debug print

//   //                 if (glbFilePath != null && glbFilePath.isNotEmpty) {
//   //                   print(
//   //                       'Displaying GLB file with path: $glbFilePath'); // Debug print
//   //                   setState(() {
//   //                     _modelPath = glbFilePath; // Store the path for displaying
//   //                   });
//   //                 } else {
//   //                   ScaffoldMessenger.of(context).showSnackBar(
//   //                     const SnackBar(
//   //                         content: Text('Failed to receive GLB file.')),
//   //                   );
//   //                 }
//   //               },
//   //               iconSize: 100,
//   //               icon: const Icon(
//   //                 Icons.camera,
//   //                 color: Colors.red,
//   //               ),
//   //             ),
//   //           ),
//   //           // Display the GLB model if _modelPath is set
//   //           if (_modelPath != null)
//   //             Expanded(
//   //               flex: 5, // Use more space for the model viewer
//   //               child: ModelViewer(
//   //                 src: _modelPath!, // Path to the GLB model
//   //                 alt: "A 3D model", // Alternative text for accessibility
//   //                 autoRotate: true, // Automatically rotate the model
//   //                 cameraControls: true, // Enable camera controls
//   //                 ar: true, // Enable AR mode if applicable
//   //               ),
//   //             ),
//   //           // Optional: Display the model path
//   //           if (_modelPath != null)
//   //             Padding(
//   //               padding: const EdgeInsets.all(16.0),
//   //               child: Text(
//   //                 'GLB File Path:\n$_modelPath',
//   //                 textAlign: TextAlign.center,
//   //                 style: const TextStyle(fontSize: 16, color: Colors.black),
//   //               ),
//   //             ),
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   // }
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shape_detector/api.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  List<CameraDescription> cameras = [];
  CameraController? cameraController;
  String? _modelPath; // Variable to hold the model path
  int currentCameraIndex = 0; // Track the current camera index

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
      return const Center(child: CircularProgressIndicator());
    }

    return SafeArea(
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Display the camera preview
            Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.80,
                child: CameraPreview(cameraController!),
              ),
            ),
            // Icon Button to take a picture
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: IconButton(
                onPressed: () async {
                  print('Camera button pressed'); // Debug print
                  XFile picture = await cameraController!.takePicture();
                  String imagePath = picture.path;
                  print('Picture taken at: $imagePath'); // Debug print

                  // Call your function to send the image and receive a GLB path
                  String? glbFilePath = await sendImageAndReceiveGLB(imagePath);
                  print('GLB file path received: $glbFilePath'); // Debug print

                  if (glbFilePath != null && glbFilePath.isNotEmpty) {
                    setState(() {
                      _modelPath = glbFilePath; // Store the path for displaying
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Failed to receive GLB file.')),
                    );
                  }
                },
                iconSize: 100,
                icon: const Icon(Icons.camera, color: Colors.red),
              ),
            ),
            // Display the model path if it's set
            if (_modelPath != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'GLB File Path:\n$_modelPath',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
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
          _cameras[currentCameraIndex],
          ResolutionPreset.high,
        );
      });
      cameraController?.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      }).catchError((Object e) {
        print(e);
      });
    }
  }

  void _switchCamera() {
    if (cameras.isNotEmpty) {
      // Switch between the first and last camera
      currentCameraIndex = (currentCameraIndex == 0) ? cameras.length - 1 : 0;
      _setupCameraController();
    }
  }
}
