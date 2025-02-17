import 'dart:io';
import 'package:flutter/material.dart';

class PreviewScreen extends StatefulWidget {
  final String imagePath;

  const PreviewScreen({super.key, required this.imagePath});

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  final TextEditingController _captionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Image.file(File(widget.imagePath), fit: BoxFit.contain),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _captionController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Write a caption...",
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[800],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              onPressed: () {
                String caption = _captionController.text.trim();
                Navigator.pop(context, {"imagePath": widget.imagePath, "caption": caption});
              },
              child: const Text(
                "Post",
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
