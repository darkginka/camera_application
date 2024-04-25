import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:camera_application/camera/image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CameraDemo extends StatefulWidget {
  const CameraDemo({super.key});

  @override
  _CameraDemoState createState() => _CameraDemoState();
}

class _CameraDemoState extends State<CameraDemo> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  List<CameraDescription> cameras = [];

  @override
  void initState() {
    cameraInit();
    super.initState();
  }

  cameraInit() async {
    cameras = await availableCameras();
    _initializeControllerFuture = _initCameraController(cameras[0]);
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (canPop) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ImageViewScreen()));
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Camera')),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.large(
          backgroundColor: Colors.grey,
          shape: const CircleBorder(),
          child: const Icon(
            Icons.camera_alt,
            color: Colors.black,
            size: 50,
          ),
          onPressed: _takePicture,
        ),
        body: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Stack(
                children: [
                  CameraPreview(_controller!),
                  // Positioned(
                  //   bottom: 16.0,
                  //   right: 16.0,
                  //   child: FloatingActionButton(
                  //     child: Icon(Icons.camera_alt),
                  //     onPressed: _takePicture,
                  //   ),
                  // ),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Future<void> _initCameraController(CameraDescription camera) async {
    final controller = CameraController(camera, ResolutionPreset.high);
    await controller.initialize();
    setState(() {
      _controller = controller;
    });
  }

  Future<void> _takePicture() async {
    if (_controller != null) {
      await _controller!.takePicture().then((image) {
        _saveImage(image);
        Fluttertoast.showToast(
            msg: "image capture",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
      });
    }
  }

  Future<void> _saveImage(XFile image) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = DateTime.now().toString() + '.jpg';
    final path = File(directory.path + name).path;
    await image.saveTo(path);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> abc = prefs.getStringList('path') ?? [];
    abc.add(path);
    prefs.setStringList('path', abc);

    List<String> pqr = prefs.getStringList('name') ?? [];
    pqr.add(name);
    prefs.setStringList('name', pqr);
  }
}
