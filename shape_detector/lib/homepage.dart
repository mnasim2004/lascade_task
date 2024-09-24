// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:gal/gal.dart';
// import 'package:shape_detector/api.dart';
// import 'package:shape_detector/ar.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
//   List<CameraDescription> cameras = [];
//   CameraController? cameraController;

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
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             SizedBox(
//               height: MediaQuery.sizeOf(context).height * 0.80,
//               width: MediaQuery.sizeOf(context).width * 0.80,
//               child: CameraPreview(
//                 cameraController!,
//               ),
//             ),
//             IconButton(
//               onPressed: () async {
//                 XFile picture = await cameraController!.takePicture();
//                 String imagePath = picture.path;
//                 String? stlFilePath = await sendImageAndReceiveSTL(imagePath);
//                 // Gal.putImage(
//                 //   picture.path,
//                 // );

//                 if (stlFilePath != null) {
//                   // Now you can use this path to display the STL file in your AR view
//                   print(stlFilePath);
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ARView(
//                           usdzFilePath: stlFilePath), // Use the STL path here
//                     ),
//                   );
//                 } else {
//                   print('Failed to receive STL file.');
//                 }
//               },
//               iconSize: 100,
//               icon: const Icon(
//                 Icons.camera,
//                 color: Colors.red,
//               ),
//             )
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
//           _cameras.first,
//           ResolutionPreset.high,
//         );
//       });
//       cameraController?.initialize().then((_) {
//         if (!mounted) {
//           return;
//         }
//         setState(() {});
//       }).catchError(
//         (Object e) {
//           print(e);
//         },
//       );
//     }
//   }
// }

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shape_detector/api.dart';
import 'package:shape_detector/ar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  List<CameraDescription> cameras = [];
  CameraController? cameraController;

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
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.80,
              width: MediaQuery.sizeOf(context).width * 0.80,
              child: CameraPreview(
                cameraController!,
              ),
            ),
            IconButton(
              onPressed: () async {
                print('Camera button pressed'); // Debug print
                XFile picture = await cameraController!.takePicture();
                String imagePath = picture.path;
                print('Picture taken at: $imagePath'); // Debug print
                String? glbFilePath = await sendImageAndReceiveSTL(imagePath);
                print('GLB file path received: $glbFilePath'); // Debug print

                if (glbFilePath != null && glbFilePath.isNotEmpty) {
                  print(
                      'Navigating to ARView with path: $glbFilePath'); // Debug print
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ARView(
                        glbFilePath: glbFilePath,
                        modelPath:
                            '', // If modelPath is needed, pass an empty string or actual value
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to receive GLB file.')),
                  );
                }
              },
              iconSize: 100,
              icon: const Icon(
                Icons.camera,
                color: Colors.red,
              ),
            )
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
}
