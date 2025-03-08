import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';

// Import your project files
import 'package:flutter_app/pages/profile_page.dart';
import 'package:flutter_app/screens/preview_screen.dart';
import 'package:flutter_app/widgets/post_card.dart';
import 'screens/camera_screen.dart';
import 'services/aws_s3_service.dart'; // Import AWS S3 upload service

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: "useraccess.env"); // This is the line I changed to fix the bug
    print("Environment variables loaded successfully.");
  } catch (e) {
    print("Error loading environment variables: $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitCheck',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final S3Service _s3Service = S3Service(); // AWS S3 Service Instance
  List<Map<String, dynamic>> posts = []; // Stores S3 image URLs, captions, etc.
  bool isFriendsPage = true;

  void addPost(String imageUrl, String caption) {
    if (mounted) {
      setState(() {
        posts.insert(0, {
          'imagePath': imageUrl,
          'caption': caption,
          'timestamp': DateTime.now(),
          'comments': <String>[],
        });
      });
    }
  }

  /// Capture image from Camera and Upload to AWS S3
  Future<void> _openCamera() async {
    if (!mounted) return;

    final capturedPath = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CameraScreen(
          onImageCaptured: (imagePath) {
            Navigator.pop(context, imagePath);
          },
        ),
      ),
    );

    if (capturedPath != null) {
      _showUploadingDialog();
      String fileName = "uploads/${DateTime.now().millisecondsSinceEpoch}.jpg";
      String? uploadedUrl = await _s3Service.uploadFile(capturedPath, fileName);
      Navigator.pop(context);

      if (uploadedUrl != null) {
        final postDetails = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PreviewScreen(imagePath: uploadedUrl),
          ),
        );

        if (postDetails != null) {
          addPost(postDetails['imagePath']!, postDetails['caption']!);
        }
      } else {
        _showErrorDialog("Upload failed. Please try again.");
      }
    }
  }

  /// Pick image from Gallery and Upload to AWS S3
  Future<void> _pickImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null && mounted) {
      _showUploadingDialog();
      String fileName = "uploads/${DateTime.now().millisecondsSinceEpoch}.jpg";
      String? uploadedUrl = await _s3Service.uploadFile(pickedFile.path, fileName);
      Navigator.pop(context);

      if (uploadedUrl != null) {
        final postDetails = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PreviewScreen(imagePath: uploadedUrl),
          ),
        );

        if (postDetails != null) {
          addPost(postDetails['imagePath']!, postDetails['caption']!);
        }
      } else {
        _showErrorDialog("Upload failed. Please try again.");
      }
    }
  }

  /// Show loading dialog while uploading
  void _showUploadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text("Uploading image..."),
          ],
        ),
      ),
    );
  }

  /// Show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildTopBar(),
          Expanded(
            child: posts.isEmpty
                ? _buildEmptyFeed()
                : ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return PostCard(
                        username: "User",
                        profileImage: "assets/outfit1.png",
                        imagePath: post['imagePath']!,
                        caption: post['caption']!,
                        timestamp: post['timestamp'],
                        comments: post['comments'],
                        isNetworkImage: true,
                        onCommentAdded: (comment) {
                          setState(() {
                            post['comments'].add(comment);
                          });
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showImageSourceActionSheet(context),
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 70, left: 16, right: 16, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.group, color: Color(0xffd0addc), size: 28),
            onPressed: () {},
          ),
          Image.asset(
            'assets/FitCheck.png',
            height: 75,
            fit: BoxFit.contain,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
            child: const CircleAvatar(
              radius: 24,
              backgroundColor: Color(0xffd0addc),
              child: Icon(Icons.person, color: Colors.white, size: 26),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyFeed() {
    return Center(
      child: GestureDetector(
        onTap: _openCamera,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.camera_alt, size: 50, color: Color(0xffb57977)),
            SizedBox(height: 10),
            Text(
              "No posts yet.\nTake a picture!",
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xffb57977), fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(children: [
        ListTile(
          leading: const Icon(Icons.camera_alt),
          title: const Text('Camera'),
          onTap: () {
            Navigator.pop(context);
            _openCamera();
          },
        ),
        ListTile(
          leading: const Icon(Icons.photo_album),
          title: const Text('Gallery'),
          onTap: () {
            Navigator.pop(context);
            _pickImageFromGallery();
          },
        ),
      ]),
    );
  }
}
