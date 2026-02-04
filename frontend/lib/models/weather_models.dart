class WeatherData {
  final String city;
  final double temperature;
  final String condition;
  final String description;
  final int humidity;
  final double windSpeed;
  final String windDirection;
  final int uvIndex;
  final double realFeel;
  final int pressure;
  final DateTime sunrise;
  final DateTime sunset;
  final String icon;

  WeatherData({
    required this.city,
    required this.temperature,
    required this.condition,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.windDirection,
    required this.uvIndex,
    required this.realFeel,
    required this.pressure,
    required this.sunrise,
    required this.sunset,
    required this.icon,
  });
}

class HourlyForecast {
  final DateTime time;
  final double temperature;
  final String condition;
  final String icon;

  HourlyForecast({
    required this.time,
    required this.temperature,
    required this.condition,
    required this.icon,
  });
}

class DailyForecast {
  final DateTime date;
  final double maxTemp;
  final double minTemp;
  final String condition;
  final String icon;
  final int humidity;

  DailyForecast({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.condition,
    required this.icon,
    required this.humidity,
  });
}

class NewsItem {
  final String id;
  final String title;
  final String content;
  final String imageUrl;
  final DateTime publishedAt;
  final String category;

  NewsItem({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.publishedAt,
    required this.category,
  });

  // For backward compatibility
  String get description => content;
}

class FAQ {
  final String question;
  final String answer;

  FAQ({
    required this.question,
    required this.answer,
  });
}