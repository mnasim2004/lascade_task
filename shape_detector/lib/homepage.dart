
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
  String? _filePath; // Variable to hold the file path
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

                  // Call your function to send the image and receive a file path
                  String? filePath = await sendImageAndReceiveGLB(imagePath);
                  print('File path received: $filePath'); // Debug print

                  if (filePath != null && filePath.isNotEmpty) {
                    setState(() {
                      _filePath = filePath; // Store the path for displaying
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to receive file.'),
                      ),
                    );
                  }
                },
                iconSize: 100,
                icon: const Icon(Icons.camera, color: Colors.red),
              ),
            ),
            // Display the image if it's a PNG
            if (_filePath != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _filePath!.endsWith('.png')
                    ? Image.file(File(_filePath!))
                    : Text(
                        'File Path:\n$_filePath',
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
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
