import 'dart:io';
import 'package:flutter/material.dart';

class PreviewScreen extends StatelessWidget {
  final String imagePath;

  const PreviewScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Image.file(File(imagePath), fit: BoxFit.contain),
          ),

          Positioned(
            top: 50,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () {
                print("User canceled post");
                Navigator.pop(context, null); 
              },
            ),
          ),

          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                onPressed: () {
                  print("User posted image: $imagePath");
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context, imagePath); 
                  }
                },
                child: const Text(
                  "Post",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
