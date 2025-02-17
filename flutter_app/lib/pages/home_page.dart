import 'package:flutter/material.dart';
import 'package:flutter_app/screens/preview_screen.dart';
import 'package:flutter_app/widgets/post_card.dart';
import '../screens/camera_screen.dart';
import 'profile_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> posts = []; // Stores timestamp & comments
  List<String> discoveryPosts = [];
  bool isFriendsPage = true;
  bool initDiscoverPages = false;

  void addPost(String imagePath, String caption) {
    if (mounted) {
      setState(() {
        final newPost = {
          'imagePath': imagePath,
          'caption': caption,
          'timestamp': DateTime.now(),
          'comments': <String>[], // Store comments
        };
        if (isFriendsPage) {
          posts.insert(0, newPost);
         } 
         //else {
        //   discoveryPosts.insert(0, imagePath);
        // }
      });
    }
  }

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
      final postDetails = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PreviewScreen(imagePath: capturedPath),
        ),
      );

      if (postDetails != null) {
        addPost(postDetails['imagePath']!, postDetails['caption']!);
      }
    }
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null && mounted) {
      final imagePath = pickedFile.path;
      final postDetails = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PreviewScreen(imagePath: imagePath),
        ),
      );
      if (postDetails != null) {
        addPost(postDetails['imagePath']!, postDetails['caption']!);
      }
    }
  }

void _toggleFeed(bool isFriendsSelected) {
   setState(() {
     isFriendsPage = isFriendsSelected;
   });
    if (!initDiscoverPages) {
      initDiscoveryPhotos();
      initDiscoverPages = true;
    }
 }

 
 void initDiscoveryPhotos() {
   discoveryPosts.insert(0, 'assets/outfit1.png');
   discoveryPosts.insert(0, 'assets/outfit2.png');
   discoveryPosts.insert(0, 'assets/outfit3.png');
 }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Color(0xFFEADCf0),
      body: Column(
        children: [
          _buildTopBar(),
          Expanded(
            child: (isFriendsPage ? posts : discoveryPosts).isEmpty
                ? _buildEmptyFeed()
                : PageView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: isFriendsPage ? posts.length : discoveryPosts.length,
                    itemBuilder: (context, index) {
                      
                      if (isFriendsPage) {
                      final post = posts[index]; // Access the map from the list
                        return PostCard(
                        username: "User",
                        profileImage: "https://via.placeholder.com/150",
                        imagePath: post['imagePath']!,
                        caption: post['caption']!,
                        timestamp: post['timestamp'], // Pass timestamp
                        comments: post['comments'], // Pass comments
                        isNetworkImage: false,
                        onCommentAdded: (comment) {
                          setState(() {
                            post['comments'].add(comment);
                          });
                         },
                       );
                     }
                     else { // show my posts
                       return _buildPostWidget(discoveryPosts[index]);
                     }
                   },
                 ),
         ),
       ],
     ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => _toggleFeed(true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: isFriendsPage ? Colors.black : Colors.transparent,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      "Friends",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isFriendsPage ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _toggleFeed(false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: !isFriendsPage ? Colors.black : Colors.transparent,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      "My Post",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: !isFriendsPage ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () => _showImageSourceActionSheet(context),
            child: const Icon(Icons.camera_alt, color: Colors.black),
          ),
        ],
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
            icon: const Icon(Icons.group, color: Colors.white, size: 28),
            onPressed: () {},
          ),
          Image.asset(
            'assets/FitCheck.png', // Replace with your actual image path
            height: 75, // Adjust the size as needed
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
              backgroundColor: Colors.grey,
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
            Icon(Icons.camera_alt, size: 50, color: Colors.grey),
            SizedBox(height: 10),
            Text(
              "No posts yet.\nTake a picture!",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 18),
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

  Widget _buildPostWidget(String imagePath) {
 // If the imagePath starts with 'assets/', treat it as an asset image.
    return Column(
      children: [
        // Condition to check if extra content should be shown above the GridView
        if (!isFriendsPage)
          Container(
            padding: EdgeInsets.all(10),
            
            child: Text(
              'fitPiece: pea coat',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            
            child: Text(
              'find inspiration',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
        
        // GridView displaying images
        GridView.builder(
          shrinkWrap: true,  // Use shrinkWrap to prevent the GridView from taking up all available space
          physics: NeverScrollableScrollPhysics(),  // Prevent scrolling if wrapped in Column
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 3 images per row
            crossAxisSpacing: 0, // Space between columns
            mainAxisSpacing: 5, // Space between rows
          ),
          itemCount: discoveryPosts.length, // Length of the list of images
          itemBuilder: (context, index) {
            // Access the map for the post at this index
            final post = discoveryPosts[index];
            // Get the image path from the map
            String imagePath = discoveryPosts[index];


            return AspectRatio(
              aspectRatio: 1 / 3, // Maintain aspect ratio
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain, // Adjust this as needed
              ),
            );
          },
        ),
      ],
    );
  
  
 }

}
