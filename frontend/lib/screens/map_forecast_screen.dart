import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather_models.dart';
import '../services/weather_service.dart';
import '../widgets/animated_weather_background.dart';
import '../widgets/glass_card.dart';

class MapForecastScreen extends StatefulWidget {
  const MapForecastScreen({super.key});

  @override
  State<MapForecastScreen> createState() => _MapForecastScreenState();
}

class _MapForecastScreenState extends State<MapForecastScreen>
    with TickerProviderStateMixin {
  late AnimationController _floatingController;
  late Animation<double> _floatingAnimation;
  late List<HourlyForecast> hourlyForecast;
  late List<DailyForecast> dailyForecast;
  int selectedDay = 0;

  @override
  void initState() {
    super.initState();
    _floatingController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _floatingAnimation = Tween<double>(begin: -5.0, end: 5.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );
    
    hourlyForecast = WeatherService.getHourlyForecast();
    dailyForecast = WeatherService.getDailyForecast();
  }

  @override
  void dispose() {
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedWeatherBackground(
        weatherCondition: 'time-based', // Changed to use time-based backgrounds
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Stack(
                  children: [
                    _buildMapBackground(),
                    _buildFloatingWeatherIndicators(),
                  ],
                ),
              ),
              _buildForecastSelector(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GlassCard(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Weather Map',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              selectedDay == 0 
                ? 'Today' 
                : DateFormat('MMM d').format(dailyForecast[selectedDay].date),
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapBackground() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.black.withOpacity(0.1),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Simulated map grid
            CustomPaint(
              size: Size.infinite,
              painter: MapGridPainter(),
            ),
            // Location markers
            _buildLocationMarkers(),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationMarkers() {
    return Stack(
      children: [
        Positioned(
          top: 100,
          left: 80,
          child: _buildLocationMarker('NYC', '24°', '☀️'),
        ),
        Positioned(
          top: 150,
          right: 100,
          child: _buildLocationMarker('LA', '28°', '☁️'),
        ),
        Positioned(
          bottom: 200,
          left: 120,
          child: _buildLocationMarker('Miami', '31°', '🌧️'),
        ),
        Positioned(
          top: 80,
          right: 60,
          child: _buildLocationMarker('Seattle', '18°', '⛈️'),
        ),
      ],
    );
  }

  Widget _buildLocationMarker(String city, String temp, String icon) {
    return AnimatedBuilder(
      animation: _floatingAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatingAnimation.value),
          child: GlassCard(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  icon,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 4),
                Text(
                  temp,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  city,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFloatingWeatherIndicators() {
    return Positioned(
      bottom: 20,
      left: 16,
      right: 16,
      child: GlassCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedDay == 0 ? 'Today\'s Hourly' : '24-Hour Forecast',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 8,
                itemBuilder: (context, index) {
                  final forecast = hourlyForecast[index * 3];
                  return Container(
                    width: 60,
                    margin: const EdgeInsets.only(right: 8),
                    child: Column(
                      children: [
                        Text(
                          DateFormat('HH:mm').format(forecast.time),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          forecast.icon,
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${forecast.temperature.round()}°',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForecastSelector() {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dailyForecast.length,
        itemBuilder: (context, index) {
          final forecast = dailyForecast[index];
          final isSelected = index == selectedDay;
          
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDay = index;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 80,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isSelected 
                  ? Colors.white.withOpacity(0.2)
                  : Colors.white.withOpacity(0.1),
                border: Border.all(
                  color: isSelected 
                    ? Colors.white.withOpacity(0.4)
                    : Colors.white.withOpacity(0.2),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    index == 0 ? 'Today' : DateFormat('EEE').format(forecast.date),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.8),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    forecast.icon,
                    style: TextStyle(
                      fontSize: isSelected ? 24 : 20,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${forecast.maxTemp.round()}°',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1;

    // Draw grid lines
    for (int i = 0; i < 10; i++) {
      final x = (size.width / 10) * i;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (int i = 0; i < 10; i++) {
      final y = (size.height / 10) * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}