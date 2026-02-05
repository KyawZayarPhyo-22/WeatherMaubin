import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/screens/admin_dashboard_screen.dart';

import 'package:frontend/screens/weather_news_screen.dart';
import 'package:frontend/services/weatherPosts_service.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';


class WeatherPosts extends StatefulWidget {
  const WeatherPosts({super.key});

  @override
  State<WeatherPosts> createState() => _WeatherPostsState();
}

class _WeatherPostsState extends State<WeatherPosts> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _detailController = TextEditingController();
  final _locationController = TextEditingController();

  bool isloading = false;

  final AddWeatherPosts weatherPostsService = AddWeatherPosts();


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

  Future<String> uploadImage(File image) async {
    const cloudName = 'dnhuo0zde';
    const uploadPreset = 'food_upload';

    final url = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
    );

    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', image.path));

    final response = await request.send();
    final resBody = await response.stream.bytesToString();
    final json = jsonDecode(resBody);

    return json['secure_url'];
  }

  Future<void> _addPosts() async {
    setState(() => isloading = true);
    if (selectedImage == null) {
     setState(() => isloading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select an image")));
      return;
    }
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _detailController.text.isEmpty ||
        _locationController.text.isEmpty) {
     setState(() => isloading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all the fields")),
      );

      return;
    }

    final imageURL = await uploadImage(selectedImage!);
    try {
      await weatherPostsService.addPost(
        title: _titleController.text,
        description: _descriptionController.text,
        detail: _detailController.text,
        imageUrl: imageURL,
        location: _locationController.text,
      );
      setState(() => isloading = false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Post added successfully')));

      // Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
        );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error : $e')));
      setState(() => isloading = false);
    } finally {
      setState(() => isloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      // backgroundColor: const Color.fromARGB(255, 2, 64, 171),
      backgroundColor: isDark
          ? const Color(0xFF0D47A1)
          : Theme.of(context).colorScheme.surface,

      body: SingleChildScrollView(
        padding: EdgeInsets.all(isSmallScreen ? 12 : 16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Add Weather Post",
              style: TextStyle(
                fontSize: isSmallScreen ? 20 : 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),

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
                child: selectedImage == null
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo, size: 40),
                            SizedBox(height: 8),
                            Text("Tap to pick image"),
                          ],
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          selectedImage!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 16),

            /// Title
            TextField(
              controller: _titleController,
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
                onPressed: isloading ? null : _addPosts,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 247, 246, 244),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: isloading
                    ? const CircularProgressIndicator(color: Colors.white60)
                    : const Text(
                        "Post Weather News",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 50, 50, 50),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            SizedBox(height: isSmallScreen ? 16 : 20),
            // Text(
            //   'Published News',
            //   style: TextStyle(
            //     fontSize: isSmallScreen ? 16 : 18,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // SizedBox(height: isSmallScreen ? 8 : 12),
            // _buildNewsCard(),
          ],
        ),
      ),
    );
  }

}
