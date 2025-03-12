import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'phone_login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_profile_screen.dart';
import 'folder_detail_page.dart'; 
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';



class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? 'testUser';
  Map<String, dynamic>? userData;
  List<Map<String, dynamic>> folders = [];
  File? _image;

  @override
  void initState() {
    super.initState();
    _listenForUserDataChanges();  // Listen for real-time data changes
    _fetchFolders();
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      // Upload the image to Firebase Storage and update the profile picture in Firestore
      await _uploadImage(_image!);
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    try {
      String fileName = 'profile_pictures/${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference storageRef = FirebaseStorage.instance.ref().child(fileName);

      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;

      String downloadUrl = await snapshot.ref.getDownloadURL();
      await _updateProfilePicture(downloadUrl);
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

    Future<void> _updateProfilePicture(String imageUrl) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'profilePicture': imageUrl, // Save the image URL in the user's document
      });

      // After updating Firestore, reload the user data
      _listenForUserDataChanges();
    } catch (e) {
      print("Error updating profile picture: $e");
    }
  }

  void _fetchFolders() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('folders')
        .get()
        .then((querySnapshot) {
      setState(() {
        folders = querySnapshot.docs.map((doc) => doc.data()).toList();
      });
    }).catchError((error) {
      print("Error fetching folders: $error");
    });
  }

  // Use Firestore snapshots to listen for real-time updates
  void _listenForUserDataChanges() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots()
        .listen((DocumentSnapshot<Map<String, dynamic>> doc) {
      if (doc.exists) {
        setState(() {
          userData = doc.data();
        });
      } else {
        print("User document does not exist.");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildTopBar(context),
          Expanded(
            child: userData == null
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    children: [
                      Column(
                        children: [
                          _buildHeader(),
                          _buildProfileInfo(),
                          _buildFoldersGrid(),
                          _buildButtons(context),
                          _buildTabBar(),
                        ],
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 70, left: 16, right: 16, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.group, color: Color(0xffd0addc), size: 28),
            onPressed: () {},
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
            child: Image.asset(
              'assets/FitCheck.png',
              height: 75,
              fit: BoxFit.contain,
            ),
          ),
          GestureDetector(
            onTap: () {},
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

  Widget _buildFoldersGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Two columns for the grid
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: folders.length,
      itemBuilder: (context, index) {
        final folder = folders[index];
        return GestureDetector(
          onTap: () {
            // Navigate to folder detail page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FolderDetailPage(folderId: folder['folderId']),
              ),
            );
          },
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.network(folder['thumbnail'], fit: BoxFit.cover, height: 150),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    folder['name'],
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _image == null
          ? CircleAvatar(
              radius: 40,
              backgroundColor: Color(0xffd0addc),
              backgroundImage: NetworkImage(userData?['profilePicture'] ?? ''),
              child: Icon(Icons.person, size: 40, color: Colors.white),
          )
          : CircleAvatar(
              radius:40,
              backgroundImage: FileImage(_image!),
          ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                userData?['name'] ?? 'Loading...',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              Text(
                '@${userData?['username'] ?? 'Loading...'}',
                style: TextStyle(fontSize: 15),
              ),
              Text(userData?['bio'] ?? 'Insert bio here'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildProfileInfoItem('Posts', userData?['posts']?.toString() ?? '0'),
          _buildProfileInfoItem('Followers', userData?['followers']?.length.toString() ?? '0'),
          _buildProfileInfoItem('Following', userData?['following']?.length.toString() ?? '0'),
          _buildProfileInfoItem('Awards', userData?['awards']?.toString() ?? '0'),
        ],
      ),
    );
  }

  Widget _buildProfileInfoItem(String label, String count) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Text(label),
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditProfileScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff872626),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text(
              'Edit Profile',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _signOut(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text(
              'Sign Out',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const PhoneLoginScreen()),
    );
  }

  Widget _buildTabBar() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            indicatorColor: Color(0xff872626),
            labelColor: const Color(0xff872626),
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(icon: Icon(Icons.grid_on)),  // Assuming grid icon for folders
            ],
          ),
          SizedBox(
            height: 400,
            child: TabBarView(
              children: [
                _buildFoldersGrid(),  // Corrected to show folders grid
              ],
            ),
          ),
        ],
      ),
    );
  }
}
