import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  _PhoneLoginScreenState createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final TextEditingController phoneController = TextEditingController();

  void sendOtp() {
    String phoneNumber = phoneController.text.trim();

    if (phoneNumber.isNotEmpty && phoneNumber.length >= 10) {
      Navigator.pushReplacementNamed(
        context,
        "/otp",
        arguments: {"phoneNumber": phoneNumber},
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid phone number!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // BeReal-style dark theme
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              // **Centered Logo**
              Center(
                child: Image.asset(
                  'assets/FitCheck.png', // Ensure it's in assets
                  height: 200, // Increase size
                  width: 200,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 40),

              // **Prompt**
              const Text(
                "What's your phone number?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 20),

              // **Phone Number Input with Country Picker**
              IntlPhoneField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[900], // Dark grey input field
                  hintText: 'Enter your phone number',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                initialCountryCode: 'US', // Default to United States
              ),

              const SizedBox(height: 10),

              // **Terms & Privacy Policy**
              const Text.rich(
                TextSpan(
                  text: "By continuing, you agree to our ",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                  children: [
                    TextSpan(
                      text: "Privacy Policy",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: " and "),
                    TextSpan(
                      text: "Terms of Service",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // **Send Verification Button**
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: sendOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800], // Dark grey button
                    foregroundColor: Colors.white, // White text
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Send Verification Text',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
