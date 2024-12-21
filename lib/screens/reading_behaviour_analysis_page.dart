import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kids Voice Recorder',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const ReadingBehaviourAnalysisPage(),
    );
  }
}

class ReadingBehaviourAnalysisPage extends StatefulWidget {
  const ReadingBehaviourAnalysisPage({super.key});


  @override
  ReadingBehaviourAnalysisPageState createState() => ReadingBehaviourAnalysisPageState();
}

class ReadingBehaviourAnalysisPageState extends State<ReadingBehaviourAnalysisPage> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  bool _isRecording = false;
  bool _isRecorderInitialized = false;
  bool _isPlaying = false;
  Timer? _timer;
  int _recordingDuration = 0;
  final List<String> _recordings = [];
  String? _currentPlayingFile;

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
    _initializePlayer();
  }

  Future<void> _initializeRecorder() async {
    final status = await Permission.microphone.request();
    if (status.isGranted) {
      await _recorder.openRecorder();
      setState(() {
        _isRecorderInitialized = true;
      });
    }
  }

  Future<void> _initializePlayer() async {
    await _player.openPlayer();
  }

  Future<void> _startRecording() async {
    if (!_isRecording && _isRecorderInitialized) {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.aac';

      try {
        await _recorder.startRecorder(toFile: path);
        setState(() {
          _isRecording = true;
          _recordingDuration = 0;
        });

        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            _recordingDuration++;
          });
        });
      } catch (e) {
        debugPrint("Error starting recording: $e");
      }
    }
  }

  Future<void> _stopRecording() async {
    if (_isRecording) {
      try {
        final path = await _recorder.stopRecorder();
        _timer?.cancel();
        setState(() {
          _isRecording = false;
          _recordings.add(path!);
        });
      } catch (e) {
        debugPrint("Error stopping recording: $e");
      }
    }
  }

  Future<void> _playRecording(String path) async {
    if (!_isPlaying || _currentPlayingFile != path) {
      await _player.startPlayer(fromURI: path, whenFinished: () {
        setState(() {
          _isPlaying = false;
          _currentPlayingFile = null;
        });
      });
      setState(() {
        _isPlaying = true;
        _currentPlayingFile = path;
      });
    } else {
      await _player.pausePlayer();
      setState(() {
        _isPlaying = false;
      });
    }
  }

  Future<void> _deleteRecording(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
      setState(() {
        _recordings.remove(path);
      });
    }
  }

  Future<void> _submitRecording(String path) async {
    debugPrint("Submitting recording: $path");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Recording $path submitted successfully!")),
    );
  }

  Future<void> _renameRecording(String oldPath) async {
    final currentContext = context; // Capture the context
    final TextEditingController renameController = TextEditingController();
    showDialog(
      context: currentContext, // Use the captured context
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Rename Recording"),
          content: TextField(
            controller: renameController,
            decoration: const InputDecoration(hintText: "Enter new name"),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(currentContext).pop();
              },
            ),
            TextButton(
              child: const Text("Rename"),
              onPressed: () async {
                final newName = renameController.text;
                if (newName.isNotEmpty) {
                  final directory = await getApplicationDocumentsDirectory();
                  final newPath = '${directory.path}/$newName.aac';
                  final file = File(oldPath);
                  await file.rename(newPath);

                  setState(() {
                    final index = _recordings.indexOf(oldPath);
                    _recordings[index] = newPath;
                  });
                }
                if (context.mounted) {
                  Navigator.of(currentContext).pop(); // Use the captured context
                }
              },
            ),
          ],
        );
      },
    );
  }


  @override
  void dispose() {
    _recorder.closeRecorder();
    _player.closePlayer();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCB6CE6),
      appBar: AppBar(
        title: const Text('Kids Voice Recorder'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFCB6CE6), Color(0xFFFEC7D7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Welcome to the Kids Voice Recorder! Tap the microphone to start recording, and let’s begin!",
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              _isRecording
                  ? Image.asset(
                'assets/microphone.png',
                width: 100,
                height: 100,
              )
                  : Image.asset(
                'assets/microphone.png',
                width: 180,
                height: 180,
              ),
              const SizedBox(height: 10),
              Text(
                _isRecording ? "Recording..." : "Tap the button to start recording",
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Text(
                _isRecording ? "Duration: ${_formatDuration(_recordingDuration)}" : "",
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isRecorderInitialized ? (_isRecording ? _stopRecording : _startRecording) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isRecording ? Icons.stop : Icons.mic,
                      color: Colors.white,
                      size: 30,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _isRecording ? "Stop Recording" : "Start Recording",
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _recordings.length,
                  itemBuilder: (context, index) {
                    final path = _recordings[index];
                    final fileName = path.split('/').last;
                    return Card(
                      color: Colors.deepPurpleAccent.withOpacity(0.8),
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ListTile(
                        title: Text(
                          fileName,
                          style: const TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        leading: IconButton(
                          icon: Icon(
                            _isPlaying && _currentPlayingFile == path ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: () => _playRecording(path),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.send, color: Colors.white),
                              onPressed: () => _submitRecording(path),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.white),
                              onPressed: () => _renameRecording(path),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.white),
                              onPressed: () => _deleteRecording(path),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Success!"),
        backgroundColor: const Color(0xFFCB6CE6), // Use the main color here
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFE8E0F0), // Light background
              Color(0x66CB6CE6), // Lighter variant with transparency
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated text for excitement
            AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'Well Done!!',
                  textStyle: const TextStyle(
                    fontFamily: 'Caveat', // Fun and engaging font
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFCB6CE6), // Use the main color here
                  ),
                  speed: const Duration(milliseconds: 150),
                ),
              ],
              totalRepeatCount: 1,
              pause: const Duration(milliseconds: 500),
            ),
            const SizedBox(height: 30),
            // Fun illustration or image
            Image.asset(
                'assets/images/clap.png', // Use a fun celebratory image
                height: 200,
              ),
            const SizedBox(height: 30),
            // Encouraging message
            const Text(
              "You did an amazing job today!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Color(0xFFCB6CE6), // Use the main color here
              ),
            ),
            const SizedBox(height: 20),
            // Fun graphic elements for engagement
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, color: Colors.yellow, size: 40),
                const SizedBox(width: 10),
                Icon(Icons.thumb_up, color: Colors.blue, size: 40),
                const SizedBox(width: 10),
                Icon(Icons.celebration, color: Colors.pink, size: 40),
              ],
            ),
            const SizedBox(height: 30),
            // Action button to encourage further engagement
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Navigate back or to the next step
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCB6CE6),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Rounded button
                ),
              ),
              child: const Text(
                "Keep Going! 🎉",
                style: TextStyle(fontSize: 24),
              ),
            ),

            const SizedBox(height: 20),
            // Footer with motivational statement
            Container(
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.only(top: 40),
              decoration: BoxDecoration(
                color: const Color(0x66CB6CE6),
                // Lighter variant with transparency
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Text(
                "Keep practicing, and you'll shine even brighter!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}