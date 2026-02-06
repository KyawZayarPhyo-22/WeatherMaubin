import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screens/admin_dashboard_screen.dart';
import 'package:frontend/screens/weather_news_screen.dart';
import 'package:frontend/services/weatherPosts_service.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class updatePost extends StatefulWidget {
  final String postId;
  final Map<String, dynamic> postData;
  const updatePost({super.key, required this.postId, required this.postData});

  @override
  State<updatePost> createState() => _updatePostState();
}

class _updatePostState extends State<updatePost> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _detailController = TextEditingController();
  final _locationController = TextEditingController();

  bool isloading = false;


  final AddWeatherPosts _weatherPosts = AddWeatherPosts();

  void initState() {
    _titleController.text = widget.postData['title'];
    _descriptionController.text = widget.postData['description'];
    _detailController.text = widget.postData['detail'];
    _locationController.text = widget.postData['location'];

  }
  // image file

  File? selectedImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  // Upload new image to Cloudinary
  Future<String> uploadToCloudinary(File image) async {
    const cloudName = 'dnhuo0zde';
    const uploadPreset = 'food_upload';
    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
    );

    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', image.path));

    final response = await request.send();
    final responseData = await response.stream.bytesToString();
    final jsonData = jsonDecode(responseData);

    return jsonData['secure_url'];
  }


  // Update food in Firestore
  Future<void> updatePost() async {
    setState(() => isloading = true);

    try {
      String imageUrl = widget.postData['imageUrl'];

      // If user picked new image, upload it
      if (selectedImage != null) {
        imageUrl = await uploadToCloudinary(selectedImage!);
      }

      await _weatherPosts.updatePost(widget.postId ,{
        'title': _titleController.text,
        'description': _descriptionController.text,
        'detail': _detailController.text,
        'imageUrl': imageUrl,
        'location': _locationController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // await FirebaseFirestore.instance.collection('weatherPosts').doc(widget.postId).update({
      //   'title': _titleController.text,
      //   'description': _descriptionController.text,
      //   'detail': _detailController.text,
      //   'imageUrl': imageUrl,
      //   'location': _locationController.text,
      //   'timestamp': FieldValue.serverTimestamp(),
      // });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Post updated!')));
      // Navigator.push(context, MaterialPageRoute(builder: (context) => AdminDashboardScreen())); // Navigate to desired screen after update
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }

    setState(() => isloading = false);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
         backgroundColor: isDark
          ? const Color(0xFF0D47A1)
          : Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("Update Weather New"),
        centerTitle: true,
          backgroundColor: isDark
          ? const Color(0xFF0D47A1)
          : Theme.of(context).colorScheme.surface,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Image Picker UI
            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey),
                ),
                child: selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          selectedImage!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          widget.postData['imageUrl'],
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 16),

            /// Title
            TextField(
              controller: _titleController ,
              decoration: const InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            /// Description
            TextField(
              controller: _descriptionController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: "Short Description",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            /// Detail
            TextField(
              controller: _detailController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: "Detail",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            /// Location
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: "Location",
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            /// Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isloading ? null : updatePost,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 247, 246, 244),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: isloading
                    ? const CircularProgressIndicator(color: Colors.white60)
                    : const Text(
                        "Update Weather News",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 50, 50, 50),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
