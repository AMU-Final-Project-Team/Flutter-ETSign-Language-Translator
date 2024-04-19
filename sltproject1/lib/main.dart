// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:sltproject1/imagesourse.dart';

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
  late CameraController controller;
  late Future<void> initializeControllerFuture;
  bool isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeControllerFuture = _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );
    await controller.initialize();
    setState(() => isCameraInitialized = true);
  }

  @override
  void dispose() {
    controller.dispose();
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
              controller = CameraController(
                firstCamera,
                ResolutionPreset.medium,
              );
              await controller.initialize();
              setState(() => isCameraInitialized = true);
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
      body: isCameraInitialized
          ? Stack(
              children: [
                Positioned.fill(child: CameraPreview(controller)),
                Positioned(
                  bottom: 90,
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
      floatingActionButton: isCameraInitialized
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: FloatingActionButton(
                    backgroundColor: Colors.red,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const VideoPlayers()));
                    },
                    heroTag: 'video0',
                    tooltip: 'Pick Video from gallery',
                    child: const Icon(Icons.video_library),
                  ),
                ),
                const SizedBox(
                  width: 100,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FloatingActionButton(
                    backgroundColor: Colors.amber,
                    onPressed: () async {
                      try {
                        // Ensure that the camera is initialized before capturing pictures
                        await initializeControllerFuture;
                        // Perform translation or other action here
                        // This could include processing the camera image
                        // or sending it to a translation service

                        print('Translation started');
                      } catch (e) {
                        // Handle any errors that occur during translation
                        print('Error: $e');
                      }
                    },
                    heroTag: 'translate0',
                    tooltip: 'START TRANSLATION',
                    child: const Icon(Icons.g_translate),
                  ),
                ),
                const SizedBox(width: 10),
              ],
            )
          : null,
    );
  }

 }

enum ImageSource {
  camera,
  gallery,
}
