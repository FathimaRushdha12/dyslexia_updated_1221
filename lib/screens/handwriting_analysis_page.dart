import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class HandwritingAnalysisPage extends StatefulWidget {
  const HandwritingAnalysisPage({super.key});

  @override
  HandwritingAnalysisPageState createState() => HandwritingAnalysisPageState();
}

class HandwritingAnalysisPageState extends State<HandwritingAnalysisPage> {
  File? _handwritingImage;
  final List<String> _words = ["apple", "star", "cloud", "flower", "happy"];
  String _randomWord = "";

  @override
  void initState() {
    super.initState();
    _generateRandomWord();
  }

  void _generateRandomWord() {
    final random = Random();
    setState(() {
      _randomWord = _words[random.nextInt(_words.length)];
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _handwritingImage = File(pickedFile.path);
      });
    }
  }

  void _navigateToSuccessPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SuccessPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Handwriting Analysis"),
        backgroundColor: const Color(0xFFCB6CE6),
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0BBE4), Color(0xFF957DAD), Color(0xFFD291BC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Write this word:",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _randomWord,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFCB6CE6),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _handwritingImage != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _handwritingImage!,
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                      ),
                    )
                        : const Icon(
                      Icons.image,
                      size: 100,
                      color: Color(0xFFCB6CE6),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _pickImage(ImageSource.camera),
                          icon: const Icon(Icons.camera),
                          label: const Text("Camera"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFCB6CE6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                          ),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton.icon(
                          onPressed: () => _pickImage(ImageSource.gallery),
                          icon: const Icon(Icons.photo),
                          label: const Text("Gallery"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFCB6CE6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _navigateToSuccessPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFCB6CE6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                        textStyle: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        shadowColor: Colors.purpleAccent,
                        elevation: 10,
                      ),
                      child: const Text("Submit"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Success!"),
        backgroundColor: const Color(0xFFCB6CE6),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE8E0F0), Color(0x66CB6CE6)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'Well Done!!',
                  textStyle: const TextStyle(
                    fontFamily: 'Caveat',
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFCB6CE6),
                  ),
                  speed: const Duration(milliseconds: 150),
                ),
              ],
              totalRepeatCount: 1,
              pause: const Duration(milliseconds: 500),
            ),
            const SizedBox(height: 30),
            Image.asset(
              'assets/clap.png',
              height: 200,
            ),
            const SizedBox(height: 30),
            const Text(
              "You did an amazing job today!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Color(0xFFCB6CE6),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.star, color: Colors.yellow, size: 40),
                SizedBox(width: 10),
                Icon(Icons.thumb_up, color: Colors.blue, size: 40),
                SizedBox(width: 10),
                Icon(Icons.celebration, color: Colors.pink, size: 40),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCB6CE6),
                padding:
                const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "Keep Going! 🎉",
                style: TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.only(top: 40),
              decoration: BoxDecoration(
                color: const Color(0x66CB6CE6),
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
