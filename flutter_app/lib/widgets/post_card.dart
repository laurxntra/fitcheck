import 'dart:io';
import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final String username;
  final String profileImage;
  final String imagePath;
  final String timeAgo;
  final String caption;
  final bool isNetworkImage;

  const PostCard({
    Key? key,
    required this.username,
    required this.profileImage,
    required this.imagePath,
    required this.timeAgo,
    required this.caption,
    this.isNetworkImage = true,
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
                backgroundImage: profileImage.isNotEmpty && profileImage.startsWith('http')
                    ? NetworkImage(profileImage)
                    : const AssetImage('assets/default_avatar.png') as ImageProvider,
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
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: isNetworkImage
                ? Image.network(
                    imagePath,
                    width: double.infinity,
                    height: 400,
                    fit: BoxFit.contain,
                  )
                : Image.file(
                    File(imagePath),
                    width: double.infinity,
                    height: 400,
                    fit: BoxFit.contain,
                  ),
          ),
          const SizedBox(height: 10),
          // Caption Display
          if (caption.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                caption,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
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
