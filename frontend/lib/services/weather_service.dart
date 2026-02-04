import '../models/weather_models.dart';

class WeatherService {
  static List<NewsItem> _newsList = [];

  static WeatherData getCurrentWeather() {
    return WeatherData(
      city: 'Maubin',
      temperature: 24.0,
      condition: 'sunny',
      description: 'Sunny',
      humidity: 65,
      windSpeed: 12.5,
      windDirection: 'NE',
      uvIndex: 6,
      realFeel: 26.0,
      pressure: 1013,
      sunrise: DateTime.now().subtract(const Duration(hours: 2)),
      sunset: DateTime.now().add(const Duration(hours: 6)),
      icon: '☀️',
    );
  }

  static List<HourlyForecast> getHourlyForecast() {
    return List.generate(24, (index) {
      final conditions = ['sunny', 'cloudy', 'rainy', 'stormy'];
      final icons = ['☀️', '☁️', '🌧️', '⛈️'];
      final condition = conditions[index % 4];
      
      return HourlyForecast(
        time: DateTime.now().add(Duration(hours: index)),
        temperature: 20.0 + (index % 10),
        condition: condition,
        icon: icons[conditions.indexOf(condition)],
      );
    });
  }

  static List<DailyForecast> getDailyForecast() {
    return List.generate(7, (index) {
      final conditions = ['sunny', 'cloudy', 'rainy', 'stormy'];
      final icons = ['☀️', '☁️', '🌧️', '⛈️'];
      final condition = conditions[index % 4];
      
      return DailyForecast(
        date: DateTime.now().add(Duration(days: index)),
        maxTemp: 25.0 + (index % 8),
        minTemp: 15.0 + (index % 5),
        condition: condition,
        icon: icons[conditions.indexOf(condition)],
        humidity: 60 + (index % 20),
      );
    });
  }

  static List<NewsItem> getWeatherNews() {
    if (_newsList.isEmpty) {
      _newsList = [
        NewsItem(
          id: '1',
          title: 'Climate Change Impact on Weather Patterns',
          content: 'Scientists report significant changes in global weather patterns due to climate change. Recent studies show increasing frequency of extreme weather events.',
          imageUrl: 'https://via.placeholder.com/300x200',
          publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
          category: 'Climate News',
        ),
        NewsItem(
          id: '2',
          title: 'Storm Warning: Severe Weather Expected',
          content: 'Meteorologists issue storm warnings for several regions this weekend. Residents are advised to take necessary precautions.',
          imageUrl: 'https://via.placeholder.com/300x200',
          publishedAt: DateTime.now().subtract(const Duration(hours: 5)),
          category: 'Weather Alert',
        ),
        NewsItem(
          id: '3',
          title: 'Seasonal Weather Tips for Winter',
          content: 'Essential tips to prepare for the upcoming winter season. Stay warm and safe during cold weather conditions.',
          imageUrl: 'https://via.placeholder.com/300x200',
          publishedAt: DateTime.now().subtract(const Duration(days: 1)),
          category: 'Weather Tips',
        ),
      ];
    }
    return List.from(_newsList.reversed);
  }

  static List<NewsItem> getNewsItems() {
    return getWeatherNews();
  }

  static void addNewsItem(NewsItem newsItem) {
    _newsList.add(newsItem);
  }

  static void deleteNewsItem(String id) {
    _newsList.removeWhere((news) => news.id == id);
  }

  static List<FAQ> getFAQs() {
    return [
      FAQ(
        question: 'What is UV Index?',
        answer: 'The UV Index is a measure of the strength of ultraviolet radiation from the sun. It ranges from 0-11+, with higher values indicating greater risk of harm from unprotected sun exposure.',
      ),
      FAQ(
        question: 'What does "Real Feel" mean?',
        answer: 'Real Feel (or "Feels Like") temperature combines air temperature with other factors like humidity and wind speed to represent how the weather actually feels to your body.',
      ),
      FAQ(
        question: 'How accurate is the forecast?',
        answer: 'Weather forecasts are generally accurate for 3-5 days ahead. Accuracy decreases beyond that timeframe. Current conditions and next-day forecasts are typically 90%+ accurate.',
      ),
      FAQ(
        question: 'What causes different weather conditions?',
        answer: 'Weather is caused by the movement of air masses, temperature differences, humidity levels, and atmospheric pressure changes. These factors interact to create various weather patterns.',
      ),
    ];
  }
}