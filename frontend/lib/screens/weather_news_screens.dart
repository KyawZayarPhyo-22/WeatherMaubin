import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frontend/services/weatherPosts_service.dart';
import 'package:intl/intl.dart';
import '../widgets/glass_card.dart';

class WeatherNewsScreens extends StatefulWidget {
  const WeatherNewsScreens({super.key});

  @override
  State<WeatherNewsScreens> createState() => _WeatherNewsScreensState();
}

class _WeatherNewsScreensState extends State<WeatherNewsScreens> {
  // late List<NewsItem> newsItems;

  AddWeatherPosts weatherPostsService = AddWeatherPosts();

  @override
  void initState() {
    super.initState();
    // newsItems = WeatherService.getWeatherNews();
  }

  @override
  Widget build(BuildContext context) {
     final isDark = Theme.of(context).brightness == Brightness.dark;

    return StreamBuilder(
      stream: weatherPostsService.getPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No data available'));
        }

        final postsdoc = snapshot.data!.docs;

        return Scaffold(
            backgroundColor: isDark
          ? const Color(0xFF0D47A1)
          : Theme.of(context).colorScheme.surface,
          body: Container(
            // decoration: const BoxDecoration(
            //   gradient: LinearGradient(
            //     begin: Alignment.topCenter,
            //     end: Alignment.bottomCenter,
            //     colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
            //   ),
            // ),
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        // In a real app, this would fetch new data from an API
                        setState(() {});
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: postsdoc.length,
                        itemBuilder: (context, index) {
                          final post =
                              postsdoc[index].data() as Map<String, dynamic>;
                          return _buildNewsCard(post, postsdoc[index].id, context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
         
          const Text(
            'Weather News List',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
         
        ],
      ),
    );
  }

  Widget _buildNewsCard(Map<String, dynamic> news, String docId , BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _buildNewsImage(news['imageUrl'] ?? ''),
            ),
            const SizedBox(height: 16),
            Text(
              news['title'] ?? 'No Title',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,

              ),
            ),
            const SizedBox(height: 8),
            Text(
              news['description'] ?? 'No Description',
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
                  // _formatTimeAgo(news.publishedAt),
                  DateFormat(
                    'MMM d, yyyy',
                  ).format((news['timestamp'] as Timestamp).toDate()),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
                TextButton(
                  onPressed: () => _showNewsDetail(docId),
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
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: Image.network(
        imagePath,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 200,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: double.infinity,
            height: 200,
            color: Colors.grey.shade200,
            child: const Icon(Icons.broken_image, size: 40),
          );
        },
      ),
    );
  }



  void _showNewsDetail(String newss) async {
    DocumentSnapshot doc = await AddWeatherPosts().getPostId(newss);
    Map<String, dynamic>? post;
    if (doc.exists) {
      setState(() {
        post = doc.data() as Map<String, dynamic>;
      });
    }
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
                          // news['title'] ?? 'No Title',
                          post!['title'] ?? 'No Title',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,


                          children: [
                            Text(
                              DateFormat(
                                'MMM d, yyyy',
                              ).format((post!['timestamp'] as Timestamp).toDate()),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.6),
                              ),
                            ), 
                        //   Row(
                       
                          
                        //   children: [
                        //     IconButton(onPressed: (){
                        //       Navigator.push(context, MaterialPageRoute(builder: (context)=> updatePost(
                        //         postId: doc.id,
                        //         postData: post!,
                        //       )));
                        //     }, icon: Icon(Icons.edit,size: 20,color: Colors.white))  ,
                        //     IconButton(onPressed: (){
                        //      weatherPostsService.deletePost(doc.id);
                        //       Navigator.pop(context);
                        //       ScaffoldMessenger.of(context).showSnackBar(
                        //         const SnackBar(content: Text('Post deleted successfully')),
                        //       );
                              
                        //     }, icon: Icon(Icons.delete_outline,size: 20,color: Colors.white))                            
                        //   ],
                        // ),
                          ],
                        ),
                       
                        const SizedBox(height: 20),
                        _buildNewsImage(post!['imageUrl'] ?? ''),
                        const SizedBox(height: 20),
                        Text(
                          post!['description'] ?? 'No Description',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          post!['detail'] ?? 'No Details Available',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.8),
                            height: 1.6,
                          ),
                        ),
                        SizedBox(height: 30),
                        Text(
                          textAlign: TextAlign.center,
                          post!['location'] ?? 'No location Available',
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
