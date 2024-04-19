// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SIGN LANGUAGE TRANSLATOR',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = _initializeCamera();
  }
Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );
    await _controller.initialize();
    setState(() => _isCameraInitialized = true);
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildStartPage() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/images/anieth.png'),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Spacer(), // Push button towards the bottom
          ElevatedButton.icon(
            onPressed: () async {
              final cameras = await availableCameras();
              final firstCamera = cameras.first;
              _controller = CameraController(
                firstCamera,
                ResolutionPreset.medium,
              );
              await _controller.initialize();
              setState(() => _isCameraInitialized = true);
            },
            icon: const Icon(Icons.camera_alt),
            label: const Text('START CAMERA'),
          ),
          const SizedBox(height: 60), // Add some vertical spacing
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SIGN LANGUAGE TRANSLATOR'),
      ),
      body: _isCameraInitialized
          ? Stack(
              children: [
                Positioned.fill(child: CameraPreview(_controller)),
                Positioned(
                  bottom: 70,
                  left: 5,
                  right: 5,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    color: Colors.white54,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Detecting...',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : _buildStartPage(),
      floatingActionButton: _isCameraInitialized
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FloatingActionButton.extended(
                  onPressed: () {
                    _controller.dispose(); // Stop the camera
                    setState(() => _isCameraInitialized = false); // Update flag
                  },
                  label: const Text('Upload'),
                  icon: const Icon(Icons.video_camera_back_rounded),
                ),
                const SizedBox(width: 16),
                FloatingActionButton.extended(
                  onPressed: () async {
                    try {
                      // Ensure that the camera is initialized before capturing pictures
                      await _initializeControllerFuture;
                      // Perform translation or other action here
                      // This could include processing the camera image
                      // or sending it to a translation service
                      print('Translation started');
                    } catch (e) {
                      // Handle any errors that occur during translation
                      print('Error: $e');
                    }
                  },
                  label: const Text('START TRANSLATION'),
                  icon: const Icon(Icons.g_translate),
                ),
              ],
            )
          : null,
    );
  }
}
