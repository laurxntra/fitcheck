import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';
import 'pages/home_page.dart';
import 'pages/phone_login.dart';
import 'pages/otp_verification.dart'; 

// ignore: unused_element
late List<CameraDescription> _cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  
  _cameras = await availableCameras();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    await Permission.camera.request();
    await Permission.microphone.request();
    await Permission.storage.request();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FitCheck',
      theme: ThemeData.dark(),
      initialRoute: '/', 
      routes: {
        '/': (context) => const PhoneLoginScreen(), 
        '/otp': (context) => const OtpVerificationScreen(), 
        '/home': (context) => HomePage(), 
      },
    );
  }
}
