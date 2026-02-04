# Weather App - Modern Flutter Application

A beautiful, modern Flutter weather application with animated backgrounds, glassmorphism design, and comprehensive weather features.

## 🌟 Features

### 🏠 Bottom Navigation Structure
- **Weather Forecast**: Current weather with detailed information and forecasts
- **Map Forecast**: Interactive weather map with floating indicators
- **Weather News**: Latest weather-related news and updates
- **FAQs**: Common weather questions with expandable answers

### 🌤️ Weather Forecast Screen
- **Current Weather Display**:
  - Large temperature display
  - Weather condition icons (☀️ ☁️ 🌧️ ⛈️)
  - City name and current date
  - Live animated backgrounds that change based on weather conditions

- **Detailed Weather Information**:
  - UV Index with visual indicator
  - Humidity percentage
  - Real Feel temperature
  - Wind Speed with direction (E/W/N/S)
  - Sunrise & Sunset times
  - Atmospheric pressure

- **Forecasts**:
  - 24-hour horizontal scrollable forecast
  - 7-day vertical forecast cards
  - Temperature ranges and weather icons

### 🗺️ Map Forecast Screen
- Interactive weather map interface
- Floating weather indicators with smooth animations
- Location-based weather markers
- Day selector for different forecast periods
- Animated weather indicators that float smoothly
- Grid-based map background

### 📰 Weather News Screen
- Modern card-based news layout
- Weather-related articles and updates
- Climate change information
- Storm warnings and alerts
- Seasonal weather tips
- Pull-to-refresh functionality
- Detailed news view with modal bottom sheet

### ❓ FAQ Screen
- Expandable accordion-style questions
- Common weather terminology explanations
- Educational content about weather phenomena
- Smooth expand/collapse animations

## 🎨 Design Features

### Visual Design
- **Material 3 Design System**: Latest Material Design guidelines
- **Glassmorphism Effects**: Translucent cards with blur effects
- **Gradient Backgrounds**: Beautiful color transitions
- **Smooth Animations**: Fluid transitions and micro-interactions
- **Dark & Light Theme Support**: Automatic system theme detection

### Animated Backgrounds
- **Sunny**: Bright sky with animated sun and glow effects
- **Cloudy**: Moving clouds with soft animations
- **Rainy**: Animated rain drops falling
- **Stormy**: Dark clouds with lightning effects

### UI Components
- **Glass Cards**: Translucent containers with blur effects
- **Floating Elements**: Smooth floating animations
- **Responsive Design**: Adapts to different screen sizes
- **Modern Icons**: Weather-specific iconography

## 🏗️ Technical Architecture

### Project Structure
```
lib/
├── main.dart                 # App entry point
├── models/
│   └── weather_models.dart   # Data models
├── services/
│   └── weather_service.dart  # Mock data service
├── screens/
│   ├── home_screen.dart      # Main navigation
│   ├── weather_forecast_screen.dart
│   ├── map_forecast_screen.dart
│   ├── weather_news_screen.dart
│   └── faq_screen.dart
└── widgets/
    ├── animated_weather_background.dart
    └── glass_card.dart
```

### Dependencies
- **flutter**: Core Flutter framework
- **http**: HTTP requests for API calls
- **intl**: Internationalization and date formatting
- **lottie**: Animation support
- **flutter_staggered_animations**: Staggered list animations
- **glassmorphism**: Glass morphism effects

### Data Models
- **WeatherData**: Current weather information
- **HourlyForecast**: Hourly weather predictions
- **DailyForecast**: Daily weather forecasts
- **NewsItem**: Weather news articles
- **FAQ**: Frequently asked questions

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- IDE (VS Code, Android Studio, or IntelliJ)

### Installation
1. Clone the repository
2. Navigate to the project directory
3. Run `flutter pub get` to install dependencies
4. Run `flutter run` to start the application

### Running the App
```bash
# Install dependencies
flutter pub get

# Run on different platforms
flutter run -d windows    # Windows
flutter run -d android    # Android
flutter run -d ios        # iOS
flutter run -d web        # Web
```

## 🔧 Customization

### Adding Real Weather Data
Replace the mock data in `WeatherService` with actual API calls:
```dart
// Example: OpenWeatherMap API integration
static Future<WeatherData> getCurrentWeather() async {
  final response = await http.get(
    Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=city&appid=API_KEY')
  );
  // Parse and return real data
}
```

### Theming
Customize colors and themes in `main.dart`:
```dart
ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue, // Change primary color
  ),
)
```

### Adding New Weather Conditions
Extend the animated backgrounds in `AnimatedWeatherBackground`:
```dart
case 'foggy':
  return _buildFogAnimation();
```

## 📱 Platform Support
- ✅ Android
- ✅ iOS
- ✅ Windows
- ✅ macOS
- ✅ Linux
- ✅ Web

## 🎯 Future Enhancements
- Real-time weather API integration
- Location-based weather detection
- Weather alerts and notifications
- Offline data caching
- Weather widgets
- Social sharing features
- Multiple location support
- Weather radar integration

## 📄 License
This project is open source and available under the MIT License.

## 🤝 Contributing
Contributions are welcome! Please feel free to submit a Pull Request.

---

**Built with ❤️ using Flutter**
