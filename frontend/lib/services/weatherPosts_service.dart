

import 'package:cloud_firestore/cloud_firestore.dart';

class AddWeatherPosts {
  final CollectionReference postsCollection = FirebaseFirestore.instance.collection('weatherPosts');

  Future<void> addPost({
    required String title,
    required String description,
    required String detail,
    required String imageUrl,
    required String location,

  }) async{
    await postsCollection.add({
      'title': title,
      'description': description,
      'detail': detail,
      'imageUrl': imageUrl,
      'location': location,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

   Future<DocumentSnapshot> getPostId(String postId)async{
    return await postsCollection.doc(postId).get();
   }

  Stream<QuerySnapshot> getPosts(){
    return postsCollection.orderBy('timestamp', descending: true).snapshots();
  }

  Future<void> updatePost(String postId, Map<String, dynamic> postData,) async{
    await postsCollection.doc(postId).update(postData);
  }

  Future<void> deletePost(String postId) async{
    await postsCollection.doc(postId).delete();
  }
}