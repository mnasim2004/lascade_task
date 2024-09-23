  import 'package:camera/camera.dart';
  import 'package:flutter/material.dart';
  import 'package:gal/gal.dart';

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
                  XFile picture = await cameraController!.takePicture();

                  // Gal.putImage(
                  //   picture.path,
                  // );
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
