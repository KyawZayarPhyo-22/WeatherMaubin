import '../models/admin_models.dart';

class AdminService {
  static CityInfo getCityInfo() {
    return CityInfo(
      name: 'Maubin',
      latitude: 17.3333,
      longitude: 95.6500,
      timezone: 'Asia/Yangon',
    );
  }

  static AppSettings getAppSettings() {
    return AppSettings(
      language: 'English',
      maintenanceMode: false,
      apiKey: 'your_api_key_here',
      refreshInterval: 30,
    );
  }

  static WeatherSettings getWeatherSettings() {
    return WeatherSettings(
      temperatureEnabled: true,
      rainEnabled: true,
      windEnabled: true,
      humidityEnabled: true,
      uvEnabled: true,
      airQualityEnabled: false,
    );
  }

  static List<WeatherAlert> getActiveAlerts() {
    return [
      WeatherAlert(
        id: '1',
        type: 'Heavy Rain',
        messageEn: 'Heavy rainfall expected in the next 6 hours',
        messageMy: 'လာမည့် ၆ နာရီအတွင်း မိုးသည်းထန်စွာ ရွာနိုင်သည်',
        severity: AlertSeverity.high,
        startTime: DateTime.now(),
        endTime: DateTime.now().add(const Duration(hours: 6)),
        pushEnabled: true,
        isActive: true,
      ),
      WeatherAlert(
        id: '2',
        type: 'Strong Wind',
        messageEn: 'Strong winds up to 40 km/h expected',
        messageMy: 'လေပြင်းမှုန်တိုင်း ၄၀ ကီလိုမီတာ/နာရီ အထိ ဖြစ်နိုင်သည်',
        severity: AlertSeverity.medium,
        startTime: DateTime.now(),
        endTime: DateTime.now().add(const Duration(hours: 12)),
        pushEnabled: true,
        isActive: true,
      ),
    ];
  }

  static DashboardStats getDashboardStats() {
    return DashboardStats(
      totalUsers: 1250,
      activeAlerts: 2,
      apiStatus: 'Online',
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 15)),
      subscriberCount: 980,
    );
  }

  static List<WeatherTip> getWeatherTips() {
    return [
      WeatherTip(
        id: '1',
        titleEn: 'Rainy Season Safety',
        titleMy: 'မိုးရာသီ ဘေးကင်းရေး',
        contentEn: 'Carry an umbrella and avoid flooded areas during heavy rain.',
        contentMy: 'မိုးသည်းထန်စွာရွာချိန်တွင် ထီးကိုင်ဆောင်ပြီး ရေလွှမ်းမိုးသောနေရာများကို ရှောင်ကြဉ်ပါ။',
        date: DateTime.now(),
        isActive: true,
      ),
      WeatherTip(
        id: '2',
        titleEn: 'UV Protection',
        titleMy: 'ခရမ်းလွန်ရောင်ခြည် ကာကွယ်ရေး',
        contentEn: 'Use sunscreen and wear protective clothing during high UV hours.',
        contentMy: 'ခရမ်းလွန်ရောင်ခြည်များသောအချိန်တွင် နေကာကရင်မ်နှင့် အကာအကွယ်အဝတ်အစားများ ဝတ်ဆင်ပါ။',
        date: DateTime.now(),
        isActive: true,
      ),
    ];
  }

  static Future<void> updateCityInfo(CityInfo cityInfo) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
  }

  static Future<void> updateAppSettings(AppSettings settings) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
  }

  static Future<void> updateWeatherSettings(WeatherSettings settings) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
  }

  static Future<void> createAlert(WeatherAlert alert) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
  }

  static Future<void> refreshWeatherData() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
  }
}