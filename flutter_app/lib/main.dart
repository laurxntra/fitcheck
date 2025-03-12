import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/home_page.dart';
import 'package:flutter_app/pages/phone_login.dart';
import 'package:flutter_app/pages/otp_verification.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_app/pages/profile_page.dart';
import 'package:flutter_app/pages/edit_profile_screen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // 1) Initialize Firebase
    if (Platform.isIOS) {
      await Firebase.initializeApp();
    } else {
      await Firebase.initializeApp();
    }
    print("✅ Firebase initialized successfully!");

    // 2) Optionally force logout on startup (remove if you want to persist the user)
    await FirebaseAuth.instance.signOut();

    // 3) Load environment variables for AWS S3
    await dotenv.load(fileName: "useraccess.env");
    print("✅ Environment variables loaded successfully.");
  } catch (e) {
    print("❌ Initialization Failed: $e");
  }

  // 4) Run your app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitCheck',
      theme: ThemeData(primarySwatch: Colors.blue),
      // Decide which screen to start with:
      // If the user is signed in, show home; otherwise phone login
      initialRoute: '/',
      routes: {
        '/': (context) => FirebaseAuth.instance.currentUser == null
            ? const PhoneLoginScreen() // Not signed in → Phone login
            : const HomePage(),         // Already signed in → Home
        '/otp': (context) => const OTPScreen(),
        '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage(),
        '/edit_profile': (context) => const EditProfileScreen(),
      },
    );
  }
}
