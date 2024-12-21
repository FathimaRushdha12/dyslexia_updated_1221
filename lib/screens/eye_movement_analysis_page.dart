import 'package:flutter/material.dart';

import 'package:camera/camera.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';


class EyeMovementAnalysisPage extends StatefulWidget {
  const EyeMovementAnalysisPage({super.key});

  @override
  EyeMovementAnalysisPageState createState() =>
      EyeMovementAnalysisPageState();
}

class EyeMovementAnalysisPageState extends State<EyeMovementAnalysisPage> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  int _selectedCameraIndex = 0; // Index to keep track of the current camera
  bool _isRecording = false;
  bool _isAudioRecording = false;
  String? _videoPath;
  String? _audioPath;
  final FlutterSoundRecorder _audioRecorder = FlutterSoundRecorder();

  @override
  void initState() {
    super.initState();
    _initializeCameras();
    _initializeAudioRecorder();
  }

  // Initialize cameras
  Future<void> _initializeCameras() async {
    _cameras = await availableCameras();
    if (_cameras!.isNotEmpty) {
      _initializeCamera(_selectedCameraIndex);
    }
  }

  // Initialize selected camera
  Future<void> _initializeCamera(int cameraIndex) async {
    if (_cameraController != null) {
      await _cameraController?.dispose();
    }
    _cameraController = CameraController(
      _cameras![cameraIndex],
      ResolutionPreset.high,
    );
    await _cameraController?.initialize();
    setState(() {});
  }

  // Toggle between front and back cameras
  void _toggleCamera() {
    if (_cameras != null && _cameras!.length > 1) {
      _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras!.length;
      _initializeCamera(_selectedCameraIndex);
    }
  }

  // Initialize audio recorder
  Future<void> _initializeAudioRecorder() async {
    await _audioRecorder.openRecorder();
    setState(() {});
  }

  // Start/Stop video recording
  void _toggleVideoRecording() async {
    if (_isRecording) {
      final video = await _cameraController?.stopVideoRecording();
      setState(() {
        _isRecording = false;
        _videoPath = video?.path;
      });
    } else {
      final directory = await getApplicationDocumentsDirectory();
      final videoPath = '${directory.path}/eye_movement_video.mp4';
      await _cameraController?.startVideoRecording();
      setState(() {
        _isRecording = true;
        _videoPath = videoPath;
      });
    }
  }

  // Start/Stop audio recording
  void _toggleAudioRecording() async {
    if (_isAudioRecording) {
      await _audioRecorder.stopRecorder();
      setState(() {
        _isAudioRecording = false;
      });
    } else {
      final directory = await getApplicationDocumentsDirectory();
      final audioPath = '${directory.path}/audio_recording.wav';
      await _audioRecorder.startRecorder(toFile: audioPath);
      setState(() {
        _isAudioRecording = true;
        _audioPath = audioPath;
      });
    }
  }

  // Submit files (combine video and audio)
  Future<void> _submitFiles() async {
    if (_videoPath != null && _audioPath != null) {
      final directory = Directory(
          '${(await getApplicationDocumentsDirectory())
              .path}/submission_folder');
      if (!directory.existsSync()) {
        directory.createSync();
      }

      final videoFile = File(_videoPath!);
      final audioFile = File(_audioPath!);

      await videoFile.copy('${directory.path}/eye_movement_video.mp4');
      await audioFile.copy('${directory.path}/audio_recording.wav');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Files submitted successfully: ${directory.path}")),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                "Please record both video and audio before submitting."),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eye Movement Analysis'),
        backgroundColor: const Color(0xFFCB6CE6),
        actions: [
          IconButton(
            icon: const Icon(Icons.switch_camera),
            onPressed: _toggleCamera,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_cameraController != null && _cameraController!.value.isInitialized)
              SizedBox(
                width: 300,
                height: 350,
                child: CameraPreview(_cameraController!),
              ),
            const SizedBox(height: 20),
            const Text(
              'Please follow the paragraph below for eye movement tracking:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              'This is a simple paragraph to follow for tracking eye movements.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _toggleVideoRecording,
              child: Text(_isRecording ? 'Stop Video Recording' : 'Start Video Recording'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _toggleAudioRecording,
              child: Text(_isAudioRecording ? 'Stop Audio Recording' : 'Start Audio Recording'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitFiles,
              child: const Text('Submit Files'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _audioRecorder.closeRecorder();
    super.dispose();
  }
}
