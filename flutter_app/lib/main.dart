import 'package:flutter/material.dart';
import 'pages/phone_login.dart';  // ✅ Make sure this file exists
import 'pages/otp_verification.dart'; // ✅ Make sure this file exists
import 'pages/home_page.dart'; // ✅ Make sure this file exists

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        '/home': (context) => const HomePage(),
      },
    );
  }
}
