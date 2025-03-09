import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  _PhoneLoginScreenState createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool isValid = false;
  String fullPhoneNumber = "";
  String? storedVerificationId;  // ✅ Fix: Defined verificationId properly
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _validatePhoneNumber(PhoneNumber phone) {
    setState(() {
      isValid = phone.number.length >= 10;
      fullPhoneNumber = phone.completeNumber;
    });
  }

  void _dismissKeyboard() {
    _focusNode.unfocus();
  }

  void sendOtp() async {
  if (!isValid || storedVerificationId != null) return;  // ✅ Prevent multiple requests

  try {
    print("📞 Sending OTP to: $fullPhoneNumber");

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: fullPhoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        print("✅ Auto-verification complete! Signing in...");
        await FirebaseAuth.instance.signInWithCredential(credential);
        Navigator.pushReplacementNamed(context, "/home");
      },
      verificationFailed: (FirebaseAuthException e) {
        print("❌ Verification Failed: ${e.code} - ${e.message}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.message}")),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          storedVerificationId = verificationId;  // ✅ Store verification ID
        });
        print("✅ Code Sent Successfully! Verification ID: $verificationId");

        Navigator.pushNamed(
          context,
          "/otp",
          arguments: {"verificationId": verificationId},  // ✅ Navigate to OTP entry screen
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print("🕒 Auto retrieval timeout: $verificationId");
      },
    );
  } catch (e) {
    print("❌ Firebase Phone Auth Error: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("An error occurred. Try again.")),
    );
  }
}

  @override
  Widget build(BuildContext context) {  // ✅ Fix: `build()` must be inside the class
    return GestureDetector(
      onTap: _dismissKeyboard,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Center(
                  child: Image.asset(
                    'assets/FitCheck.png',
                    height: 150,
                    width: 150,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  "What's your phone number?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff872626),
                  ),
                ),
                const SizedBox(height: 20),
                IntlPhoneField(
                  controller: phoneController,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                  onChanged: _validatePhoneNumber,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xffd0addc),
                    hintText: 'Enter your phone number',
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  initialCountryCode: 'US',
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isValid ? sendOtp : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isValid ? Color(0xffd64117) : Colors.grey[700],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Send Verification Code',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
