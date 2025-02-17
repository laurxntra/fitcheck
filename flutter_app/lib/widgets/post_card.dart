import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/comment_section.dart';
import 'package:intl/intl.dart';

class PostCard extends StatefulWidget {
  final String username;
  final String profileImage;
  final String imagePath;
  final String caption;
  final bool isNetworkImage;
  final DateTime timestamp;
  final List<String> comments; // Stores comments
  final Function(String) onCommentAdded; // Callback when a new comment is added

  const PostCard({
    Key? key,
    required this.username,
    required this.profileImage,
    required this.imagePath,
    required this.caption,
    required this.timestamp,
    this.isNetworkImage = true,
    required this.comments,
    required this.onCommentAdded,
  }) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int likes = 0;
  bool isLiked = false;

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
      likes += isLiked ? 1 : -1;
    });
  }

  String getFormattedTime() {
    final now = DateTime.now();
    final difference = now.difference(widget.timestamp);

    if (difference.inMinutes < 1) {
      return "Just now";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} min ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours}h ago";
    } else {
      return "dateformat not implemented"; // DateFormat('MMM d, y').format(widget.timestamp);
    }
  }

  void openComments() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return CommentSection(
          comments: widget.comments,
          onCommentAdded: widget.onCommentAdded,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        //color: Colors.black,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: widget.profileImage.isNotEmpty && widget.profileImage.startsWith('http')
                    ? NetworkImage(widget.profileImage)
                    : const AssetImage('assets/default_avatar.png') as ImageProvider,
                radius: 20,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.username,
                    style: const TextStyle(
                      color: Color(0xffd64117),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    getFormattedTime(),
                    style: const TextStyle(
                      color: Color(0xffb57977),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(
                Icons.more_vert,
                color: Color(0xffd64117),
              )
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: widget.isNetworkImage
                ? Image.network(
                    widget.imagePath,
                    width: double.infinity,
                    height: 400,
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    File(widget.imagePath),
                    width: double.infinity,
                    height: 400,
                    fit: BoxFit.cover,
                  ),
          ),
          const SizedBox(height: 10),
          if (widget.caption.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                widget.caption,
                style: const TextStyle(color: Color(0xff872626), fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border, color: Color(0xffd64117)),
                    onPressed: toggleLike,
                  ),
                  Text(
                    "$likes",
                    style: const TextStyle(color: Color(0xffd64117)),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.comment, color: Color(0xffd64117)),
                    onPressed: openComments,
                  ),
                ],
              ),
              //const Icon(Icons.share, color: Color(0xffd64117)),
            ],
          ),
        ],
      ),
    );
  }
}
