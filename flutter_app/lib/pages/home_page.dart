import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_app/screens/preview_screen.dart';
import 'package:flutter_app/screens/camera_screen.dart';
import 'package:flutter_app/widgets/post_card.dart';
import 'package:flutter_app/widgets/daily_challenge.dart';
import 'package:flutter_app/pages/profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/pages/profile_page.dart';


// Import your S3 Service
import 'package:flutter_app/services/aws_s3_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Toggle to skip real S3 uploads:
  final bool isMockUpload = true;

  // 1) AWS S3 Service instance
  final S3Service _s3Service = S3Service();

  // 2) Lists for posts
  List<Map<String, dynamic>> posts = []; 
  List<String> discoveryPosts = [];
  bool isFriendsPage = true;
  bool initDiscoverPages = false;

  @override
  void initState() {
    super.initState();
  }

  // *******************************************************
  //     Add Post to the Feed
  // *******************************************************
  void addPost(String imagePath, String caption) {
    if (!mounted) return;
    setState(() {
      final newPost = {
        'imagePath': imagePath,
        'caption': caption,
        'timestamp': DateTime.now(),
        'comments': <String>[],
      };
      // Insert at top if we are on "my posts" page
      if (!isFriendsPage) {
        posts.insert(0, newPost);
      }
    });
  }

  // *******************************************************
  //     Camera Flow → (Mock) Upload → Show Preview
  // *******************************************************
  Future<void> _openCamera() async {
    if (!mounted) return;

    // 1) Capture photo
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
      // 2) Show "Uploading..." dialog
      _showUploadingDialog();

      // 3) If isMockUpload is true, skip real upload
      String? uploadedUrl;
      if (isMockUpload) {
        // Let's just pretend the local path is our "URL"
        // or you could do "uploadedUrl = 'https://fake.s3.com/' + fileName"
        uploadedUrl = capturedPath;
        await Future.delayed(const Duration(seconds: 1)); 
        // short delay to mimic a network call
      } else {
        // Real S3 logic
        String fileName = "uploads/${DateTime.now().millisecondsSinceEpoch}.jpg";
        uploadedUrl = await _s3Service.uploadFile(capturedPath, fileName);
      }

      // 4) Close the dialog
      Navigator.pop(context);

      // 5) If success, show PreviewScreen with URL (or local path)
      if (uploadedUrl != null) {
  final postDetails = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PreviewScreen(imagePath: uploadedUrl!),
    ),
  );

        // 6) If user saved the post, add it to feed
        if (postDetails != null) {
          addPost(postDetails['imagePath']!, postDetails['caption']!);
        }
      } else {
        _showErrorDialog("Upload failed. Please try again.");
      }
    }
  }

  // *******************************************************
  //    Gallery Flow → (Mock) Upload → Show Preview
  // *******************************************************
  Future<void> _pickImageFromGallery() async {
    if (!mounted) return;

    // 1) Pick from gallery
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    // 2) Show "Uploading..." dialog
    _showUploadingDialog();

    String? uploadedUrl;
    if (isMockUpload) {
      uploadedUrl = pickedFile.path; 
      await Future.delayed(const Duration(seconds: 1));
    } else {
      // Real S3 logic
      String fileName = "uploads/${DateTime.now().millisecondsSinceEpoch}.jpg";
      uploadedUrl = await _s3Service.uploadFile(pickedFile.path, fileName);
    }

    // 3) Close loading dialog
    Navigator.pop(context);

    // 4) If success, show PreviewScreen with URL (or local path)
    if (uploadedUrl != null) {
  final postDetails = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PreviewScreen(imagePath: uploadedUrl!),
    ),
  );

      // 5) If user saved, add it
      if (postDetails != null) {
        addPost(postDetails['imagePath']!, postDetails['caption']!);
      }
    } else {
      _showErrorDialog("Upload failed. Please try again.");
    }
  }

  // *******************************************************
  //     Show a loading dialog while uploading
  // *******************************************************
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

  // *******************************************************
  //     Show an error dialog
  // *******************************************************
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

  // *******************************************************
  //     Toggle feed between friends & my posts
  // *******************************************************
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
    discoveryPosts.clear();
    discoveryPosts.insert(0, 'assets/outfit1.png');
    discoveryPosts.insert(0, 'assets/outfit2.png');
    discoveryPosts.insert(0, 'assets/outfit3.png');
  }

  // *******************************************************
  //     BUILD
  // *******************************************************
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildTopBar(),
          const SizedBox(height: 10),
          DailyChallengeWidget(),
          Expanded(
            child: (isFriendsPage ? posts : discoveryPosts).isEmpty
                ? _buildEmptyFeed()
                : PageView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: isFriendsPage ? posts.length : discoveryPosts.length,
                    itemBuilder: (context, index) {
                      if (isFriendsPage) {
                        // show feed of friend posts
                        final post = posts[index];
                        return PostCard(
                          username: "User",
                          profileImage: "assets/outfit1.png",
                          imagePath: post['imagePath']!,
                          caption: post['caption']!,
                          timestamp: post['timestamp'],
                          comments: post['comments'],
                          // If we are only using local paths or mock URLs, 
                          // you can set isNetworkImage false to test. 
                          // If you do a "fake" HTTPS URL, set true.
                          isNetworkImage: false,
                          onCommentAdded: (comment) {
                            setState(() {
                              post['comments'].add(comment);
                            });
                          },
                        );
                      } else {
                        // show discovery feed
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
          // "Friends" / "My Post" toggle
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
                      color: isFriendsPage ? const Color(0xff872626) : Colors.transparent,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      "Friends",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isFriendsPage ? Colors.white : const Color(0xff872626),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _toggleFeed(false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: !isFriendsPage ? const Color(0xff872626) : Colors.transparent,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      "My Post",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: !isFriendsPage ? Colors.white : const Color(0xff872626),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // *******************************************************
  //     Top Bar
  // *******************************************************
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
                MaterialPageRoute(builder: (context) => const ProfilePage()),
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

  // *******************************************************
  //     If feed empty, ask user to take a picture
  // *******************************************************
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

  // *******************************************************
  //     Show bottom sheet to pick camera or gallery
  // *******************************************************
  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
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
        ],
      ),
    );
  }

  // *******************************************************
  //     For "My Post" tab, building the discovery feed
  // *******************************************************
  Widget _buildPostWidget(String imagePath) {
    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                "Today's fitPiece:",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff872626),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5),
              Text(
                'pea coat',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffd64117),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),

        SizedBox(
          height: 300,
          width: 250,
          child: Center(
            child: Material(
              child: InkWell(
                onTap: () => _showImageSourceActionSheet(context),
                child: SizedBox(
                  height: 250,
                  width: 250,
                  child: Image.asset(
                    'assets/UploadTriggerClean.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),

        Container(
          padding: const EdgeInsets.all(10),
          child: const Text(
            'find inspiration',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff872626)),
            textAlign: TextAlign.center,
          ),
        ),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, 
            crossAxisSpacing: 0, 
            mainAxisSpacing: 5,
          ),
          itemCount: discoveryPosts.length,
          itemBuilder: (context, index) {
            final postImagePath = discoveryPosts[index];
            return AspectRatio(
              aspectRatio: 1 / 3,
              child: Image.asset(
                postImagePath,
                fit: BoxFit.contain,
              ),
            );
          },
        ),
      ],
    );
  }
}
