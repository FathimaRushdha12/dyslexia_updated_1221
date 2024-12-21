import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/login_page.dart';
import 'screens/register_page.dart';
import 'screens/navigation_page.dart';
import 'screens/splash_page.dart';
import 'screens/forgot_password_page.dart';
import 'screens/otp_page.dart';
import 'screens/change_password_page.dart';
import 'screens/profile_page.dart';
import 'screens/settings_page.dart';
import 'screens/progress_report_page.dart';
import 'screens/analyzing_data_page.dart';
import 'screens/thank_you_page.dart';
import 'screens/eye_movement_analysis_page.dart';
import 'screens/handwriting_analysis_page.dart';
import 'screens/reading_behaviour_analysis_page.dart';
import 'screens/task_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp()); // Removed `const`
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashPage(), // Removed `const`
      routes: {
        '/login': (context) => LoginPage(), // Removed `const`
        '/register': (context) => RegisterPage(),
        '/navigation': (context) => NavigationPage(), // Removed `const`
        '/forgot-password': (context) => ForgotPasswordPage(), // Removed `const`
        '/otp': (context) => OtpPage(), // Removed `const`
        '/change-password': (context) => ChangePasswordPage(), // Removed `const`
        '/profile': (context) => ProfilePage(), // Removed `const`
        '/settings': (context) => SettingsPage(), // Removed `const`
        '/progress-report': (context) => ProgressReportPage(), // Removed `const`
        '/analyzing-data': (context) => AnalyzingDataPage(), // Removed `const`
        '/thank-you': (context) => ThankYouPage(), // Removed `const`
        '/eye_movement_analysis_page': (context) => EyeMovementAnalysisPage(), // Removed `const`
        '/handwriting_analysis_page': (context) => HandwritingAnalysisPage(), // Removed `const`
        '/reading_behaviour_analysis_page': (context) => ReadingBehaviourAnalysisPage(), // Removed `const`
        '/task_page': (context) => TaskPage(), // Removed `const`
      },
    );
  }
}
