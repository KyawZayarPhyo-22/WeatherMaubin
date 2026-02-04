import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import '../models/weather_models.dart';
import '../services/weather_service.dart';

class NewsManagementScreen extends StatefulWidget {
  const NewsManagementScreen({super.key});

  @override
  State<NewsManagementScreen> createState() => _NewsManagementScreenState();
}

class _NewsManagementScreenState extends State<NewsManagementScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  File? _selectedImage;
  List<NewsItem> _newsList = [];

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  void _loadNews() {
    _newsList = WeatherService.getNewsItems();
    setState(() {});
  }

  Future<void> _pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _selectedImage = File(result.files.single.path!);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to select image')),
      );
    }
  }

  void _addNews() {
    if (_titleController.text.isEmpty ||
        _contentController.text.isEmpty ||
        _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and select an image')),
      );
      return;
    }

    final newNews = NewsItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      content: _contentController.text,
      imageUrl: _selectedImage!.path,
      publishedAt: DateTime.now(),
      category: 'Weather Update',
    );

    WeatherService.addNewsItem(newNews);
    _loadNews();
    _clearForm();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('News posted successfully!')),
    );
  }

  void _clearForm() {
    _titleController.clear();
    _contentController.clear();
    _selectedImage = null;
    setState(() {});
  }

  void _deleteNews(String id) {
    WeatherService.deleteNewsItem(id);
    _loadNews();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('News deleted successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'News Management',
            style: TextStyle(
              fontSize: isSmallScreen ? 18 : 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          _buildAddNewsForm(isSmallScreen),
          SizedBox(height: isSmallScreen ? 16 : 20),
          Text(
            'Published News (${_newsList.length})',
            style: TextStyle(
              fontSize: isSmallScreen ? 16 : 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: isSmallScreen ? 8 : 12),
          ..._newsList.map((news) => _buildNewsCard(news, isSmallScreen)),
        ],
      ),
    );
  }

  Widget _buildAddNewsForm(bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Post New Weather News',
            style: TextStyle(
              fontSize: isSmallScreen ? 16 : 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),

          /// Title
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'News Title',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),

          SizedBox(height: isSmallScreen ? 8 : 12),

          /// Content
          TextField(
            controller: _contentController,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: 'News Content',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),

          SizedBox(height: isSmallScreen ? 12 : 16),

          /// Image Picker
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                if (_selectedImage != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      _selectedImage!,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  Container(
                    height: 150,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'No image selected',
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  ),

                SizedBox(height: isSmallScreen ? 8 : 12),

                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image),
                  label: Text(
                    _selectedImage == null ? 'Choose Image' : 'Change Image',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade700,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: isSmallScreen ? 12 : 16),

          /// Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _addNews,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      vertical: isSmallScreen ? 12 : 16,
                    ),
                  ),
                  child: const Text('Post News'),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: _clearForm,
                child: const Text('Clear'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCard(NewsItem news, bool isSmallScreen) {
    return Container(
      margin: EdgeInsets.only(bottom: isSmallScreen ? 8 : 12),
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  news.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isSmallScreen ? 14 : 16,
                  ),
                ),
              ),
              PopupMenuButton(
                itemBuilder: (_) => [
                  PopupMenuItem(
                    onTap: () => _deleteNews(news.id),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            news.content,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                news.category,
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                DateFormat('MMM dd, HH:mm').format(news.publishedAt),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}
