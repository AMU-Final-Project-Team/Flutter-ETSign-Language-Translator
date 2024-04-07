import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SIGN LANGUAGE TRANSLATOR',
      home: const HomePage(),
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
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/images/anieth.png'),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Spacer(), // Push button towards the bottom
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
            icon: Icon(Icons.camera_alt),
            label: Text('START CAMERA'),
          ),
          SizedBox(height: 60), // Add some vertical spacing
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SIGN LANGUAGE TRANSLATOR'),
      ),
      body:
          _isCameraInitialized ? CameraPreview(_controller) : _buildStartPage(),
      floatingActionButton: _isCameraInitialized
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton.extended(
                  onPressed: () {
                    _controller.dispose(); // Stop the camera
                    setState(() => _isCameraInitialized = false); // Update flag
                  },
                  label: Text('STOP'),
                  icon: Icon(Icons.stop),
                ),
                SizedBox(width: 16),
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
                  label: Text('START TRANSLATION'),
                  icon: Icon(Icons.g_translate),
                ),
              ],
            )
          : null,
    );
  }
}
