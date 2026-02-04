import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../models/weather_models.dart';
import '../services/weather_service.dart';
import '../widgets/glass_card.dart';

class WeatherNewsScreen extends StatefulWidget {
  const WeatherNewsScreen({super.key});

  @override
  State<WeatherNewsScreen> createState() => _WeatherNewsScreenState();
}

class _WeatherNewsScreenState extends State<WeatherNewsScreen> {
  late List<NewsItem> newsItems;

  @override
  void initState() {
    super.initState();
    newsItems = WeatherService.getWeatherNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refreshNews,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: newsItems.length,
                    itemBuilder: (context, index) {
                      return _buildNewsCard(newsItems[index]);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(
            Icons.article,
            color: Colors.white,
            size: 28,
          ),
          const SizedBox(width: 12),
          const Text(
            'Weather News',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: _refreshNews,
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCard(NewsItem news) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _buildNewsImage(news.imageUrl),
            ),
            const SizedBox(height: 16),
            Text(
              news.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              news.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.8),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatTimeAgo(news.publishedAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
                TextButton(
                  onPressed: () => _showNewsDetail(news),
                  child: const Text(
                    'Read More',
                    style: TextStyle(
                      color: Colors.lightBlueAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsImage(String imagePath) {
    if (imagePath.startsWith('http')) {
      return Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.withOpacity(0.3),
              Colors.purple.withOpacity(0.3),
            ],
          ),
        ),
        child: const Icon(
          Icons.image,
          size: 60,
          color: Colors.white54,
        ),
      );
    } else {
      final file = File(imagePath);
      if (file.existsSync()) {
        return Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: FileImage(file),
              fit: BoxFit.cover,
            ),
          ),
        );
      } else {
        return Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.broken_image,
                size: 40,
                color: Colors.grey.shade600,
              ),
              const SizedBox(height: 8),
              Text(
                'Image not found',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      }
    }
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  Future<void> _refreshNews() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      // In a real app, this would fetch new data from an API
      newsItems = WeatherService.getWeatherNews();
    });
  }

  void _showNewsDetail(NewsItem news) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Color(0xFF1E3C72),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          news.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          DateFormat('MMM d, yyyy • HH:mm').format(news.publishedAt),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildNewsImage(news.imageUrl),
                        const SizedBox(height: 20),
                        Text(
                          news.description,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'This is a detailed view of the weather news article. In a real application, this would contain the full article content fetched from a news API.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.8),
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}