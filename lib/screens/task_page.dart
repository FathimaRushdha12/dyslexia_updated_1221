import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<TaskPage> {
  String? profileImagePath;

  @override
  void initState() {
    super.initState();
    _loadProfileImagePath();
  }

  Future<void> _loadProfileImagePath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      profileImagePath = prefs.getString('profileImagePath');
    });
  }

  Future<void> _saveProfileImagePath(String path) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('profileImagePath', path);
    setState(() {
      profileImagePath = path;
    });
  }

  Future<void> _uploadProfileImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _saveProfileImagePath(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
        backgroundColor: const Color(0xFFCB6CE6),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            profileImagePath != null
                ? CircleAvatar(
              radius: 60,
              backgroundImage: FileImage(File(profileImagePath!)),
            )
                : const Icon(Icons.account_circle, size: 120, color: Color(0xFFCB6CE6)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadProfileImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCB6CE6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text(
                'Upload New Profile Picture',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 30),
            _buildNavigationButton(
              context,
              label: 'Handwriting Analysis',
              routeName: '/handwritingAnalysis',
            ),
            _buildNavigationButton(
              context,
              label: 'Voice Analysis',
              routeName: '/readingBehaviourAnalysis',
            ),
            _buildNavigationButton(
              context,
              label: 'Eye Movement Analysis',
              routeName: '/eyeMovementAnalysis',
            ),
          ],
        ),
      ),
    );
  }

  // Custom method to create styled navigation buttons
  Widget _buildNavigationButton(BuildContext context, {required String label, required String routeName}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: ElevatedButton(
        onPressed: () => Navigator.pushNamed(context, routeName),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFCB6CE6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
