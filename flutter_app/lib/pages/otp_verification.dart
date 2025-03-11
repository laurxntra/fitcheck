import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController otpController = TextEditingController();
  late String verificationId;
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    verificationId = args["verificationId"];
  }

  Future<void> verifyOTP() async {
  setState(() {
    isLoading = true;
  });

  try {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otpController.text.trim(),
    );

    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    User? user = userCredential.user; // User is nullable

    if (user != null) {
      print("✅ Login Successful! User ID: ${user.uid}");

      // 🔹 Save user data in Firestore only if user is not null
      await _saveUserToFirestore(user);

      // 🔹 Navigate to Home Page
      Navigator.pushReplacementNamed(context, "/home");
    } else {
      print("❌ Login failed. User is null.");
    }
  } on FirebaseAuthException catch (e) {
    String errorMessage = "Invalid OTP. Try again.";

    if (e.code == "invalid-verification-code") {
      errorMessage = "The verification code is incorrect.";
    } else if (e.code == "session-expired") {
      errorMessage = "The verification code has expired.";
    } else if (e.code == "quota-exceeded") {
      errorMessage = "SMS quota exceeded. Try again later.";
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage)),
    );
  } catch (e) {
    print("❌ OTP Verification Error: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("An unexpected error occurred. Try again.")),
    );
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}


Future<void> _saveUserToFirestore(User user) async {
  try {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);

    // 🔹 Check if the user already exists in Firestore
    DocumentSnapshot doc = await userDoc.get();
    if (!doc.exists) {
      await userDoc.set({
        "uid": user.uid,
        "phone": user.phoneNumber ?? "",
        "name": "New User",
        "username": "user${user.uid.substring(0, 5)}", // Example username
        "bio": "Hey there! I'm using FitCheck.",
        "posts": 0,
        "followers": [],
        "following": [],
        "awards": 0,
        "createdAt": FieldValue.serverTimestamp(),
      });
      print("✅ New user saved to Firestore!");
    } else {
      print("ℹ️ User already exists in Firestore.");
    }
  } catch (e) {
    print("❌ Error saving user to Firestore: $e");
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Enter OTP")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Enter the OTP sent to your phone",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: otpController,
              decoration: InputDecoration(
                labelText: "Enter OTP",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              maxLength: 6,
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: verifyOTP,
                      child: const Text("Verify OTP"),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
