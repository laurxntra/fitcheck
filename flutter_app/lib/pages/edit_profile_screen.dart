import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  final User? user = FirebaseAuth.instance.currentUser;
  File? _pickedImage;
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();

    // Pre-populate the fields with the current data
    if (user != null) {
      FirebaseFirestore.instance.collection('users').doc(user!.uid).get().then((doc) {
        if (doc.exists) {
          _nameController.text = doc['name'] ?? '';
          _usernameController.text = doc['username'] ?? '';
          _bioController.text = doc['bio'] ?? '';
          _profileImageUrl = doc['profilePicture'] ?? '';  // Using the profilePicture field
        }
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadProfilePicture() async {
    if (_pickedImage == null) return;

    try {
      final storageRef = FirebaseStorage.instance.ref().child('profile_pictures').child('${user!.uid}.jpg');
      UploadTask uploadTask = storageRef.putFile(_pickedImage!);

      // Listening to upload states
      uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
        switch (taskSnapshot.state) {
          case TaskState.running:
            print("Upload is ${taskSnapshot.bytesTransferred / taskSnapshot.totalBytes * 100}% complete.");
            break;
          case TaskState.paused:
            print("Upload is paused.");
            break;
          case TaskState.canceled:
            print("Upload was canceled.");
            break;
          case TaskState.error:
            print("Upload failed.");
            break;
          case TaskState.success:
            print("Upload successful.");
            break;
        }
      });

      await uploadTask;
      _profileImageUrl = await storageRef.getDownloadURL();
    } catch (e) {
      print("Error uploading profile picture: $e");
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _uploadProfilePicture(); // Upload the profile picture

        await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
          'name': _nameController.text,
          'username': _usernameController.text,
          'bio': _bioController.text,
          'profilePicture': _profileImageUrl, // Save the profile image URL
        });

        // Navigate back to profile page after saving
        Navigator.pop(context);
      } catch (e) {
        print("Error updating profile: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to update profile. Please try again.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _pickedImage != null 
                    ? FileImage(_pickedImage!)
                    : _profileImageUrl != null && _profileImageUrl!.isNotEmpty
                      ? NetworkImage(_profileImageUrl!) as ImageProvider
                      : const AssetImage('assets/default_profile.png'),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bioController,
                decoration: const InputDecoration(labelText: 'Biography'),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProfile,
                child: const Text("Save Changes"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
