import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'preview_screen.dart';

class CameraScreen extends StatefulWidget {
  final Function(String) onImageCaptured;

  const CameraScreen({Key? key, required this.onImageCaptured}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      print("No cameras found.");
      Navigator.pop(context);
      return;
    }

    _controller = CameraController(cameras.first, ResolutionPreset.high);
    await _controller!.initialize();
    setState(() {
      _isCameraInitialized = true;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _capturePhoto() async {
    if (!_controller!.value.isInitialized) return;

    final XFile photo = await _controller!.takePicture();
    final imagePath = photo.path;

    final postedImage = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PreviewScreen(imagePath: imagePath),
      ),
    );

    if (postedImage != null) {
      widget.onImageCaptured(postedImage);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isCameraInitialized
          ? Stack(
              children: [
                CameraPreview(_controller!),
                Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: FloatingActionButton(
                      onPressed: _capturePhoto,
                      backgroundColor: Colors.white,
                      child: const Icon(Icons.camera_alt_rounded, color: Colors.black),
                    ),
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
