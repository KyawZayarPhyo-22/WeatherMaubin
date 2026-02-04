class CityInfo {
  final String name;
  final double latitude;
  final double longitude;
  final String timezone;

  CityInfo({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.timezone,
  });
}

class WeatherAlert {
  final String id;
  final String type;
  final String messageEn;
  final String messageMy;
  final AlertSeverity severity;
  final DateTime startTime;
  final DateTime endTime;
  final bool pushEnabled;
  final bool isActive;

  WeatherAlert({
    required this.id,
    required this.type,
    required this.messageEn,
    required this.messageMy,
    required this.severity,
    required this.startTime,
    required this.endTime,
    required this.pushEnabled,
    required this.isActive,
  });
}

enum AlertSeverity { low, medium, high }

class WeatherSettings {
  final bool temperatureEnabled;
  final bool rainEnabled;
  final bool windEnabled;
  final bool humidityEnabled;
  final bool uvEnabled;
  final bool airQualityEnabled;

  WeatherSettings({
    required this.temperatureEnabled,
    required this.rainEnabled,
    required this.windEnabled,
    required this.humidityEnabled,
    required this.uvEnabled,
    required this.airQualityEnabled,
  });
}

class AppSettings {
  final String language;
  final bool maintenanceMode;
  final String apiKey;
  final int refreshInterval;

  AppSettings({
    required this.language,
    required this.maintenanceMode,
    required this.apiKey,
    required this.refreshInterval,
  });
}

class DashboardStats {
  final int totalUsers;
  final int activeAlerts;
  final String apiStatus;
  final DateTime lastUpdated;
  final int subscriberCount;

  DashboardStats({
    required this.totalUsers,
    required this.activeAlerts,
    required this.apiStatus,
    required this.lastUpdated,
    required this.subscriberCount,
  });
}

class WeatherTip {
  final String id;
  final String titleEn;
  final String titleMy;
  final String contentEn;
  final String contentMy;
  final DateTime date;
  final bool isActive;

  WeatherTip({
    required this.id,
    required this.titleEn,
    required this.titleMy,
    required this.contentEn,
    required this.contentMy,
    required this.date,
    required this.isActive,
  });
}