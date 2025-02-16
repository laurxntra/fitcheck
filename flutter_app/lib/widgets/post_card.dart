import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final String username;
  final String profileImage;
  final String mainImage;
  final String timeAgo;

  const PostCard({
    Key? key,
    required this.username,
    required this.profileImage,
    required this.mainImage,
    required this.timeAgo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(profileImage),
                radius: 20,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    timeAgo,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(
                Icons.more_vert,
                color: Colors.white,
              )
            ],
          ),
          const SizedBox(height: 10),
          // Main Image Container
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  mainImage,
                  width: double.infinity,
                  height: 400,
                  fit: BoxFit.cover,
                ),
              ),
              
              Positioned(
                top: 10,
                left: 10,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Image.network(
                      profileImage, 
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.favorite_border, color: Colors.white),
                  SizedBox(width: 10),
                  Icon(Icons.comment, color: Colors.white),
                ],
              ),
              const Icon(Icons.share, color: Colors.white),
            ],
          ),
        ],
      ),
    );
  }
}
