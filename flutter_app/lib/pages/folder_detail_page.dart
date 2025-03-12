import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FolderDetailPage extends StatelessWidget {
  final String folderId;

  const FolderDetailPage({required this.folderId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Folder Details'),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection('folders')
            .doc(folderId)
            .collection('items')
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No items in this folder.'));
          }

          var items = snapshot.data!.docs;
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              var item = items[index];
              return ListTile(
                title: Text(item['description']),
                leading: Image.network(item['image']),
              );
            },
          );
        },
      ),
    );
  }
}
