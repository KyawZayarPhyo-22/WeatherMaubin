import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather_models.dart';
import '../services/weather_service.dart';
import '../widgets/animated_weather_background.dart';
import '../widgets/glass_card.dart';

class WeatherForecastScreen extends StatefulWidget {
  const WeatherForecastScreen({super.key});

  @override
  State<WeatherForecastScreen> createState() => _WeatherForecastScreenState();
}

class _WeatherForecastScreenState extends State<WeatherForecastScreen> {
  late WeatherData currentWeather;
  late List<HourlyForecast> hourlyForecast;
  late List<DailyForecast> dailyForecast;

  @override
  void initState() {
    super.initState();
    _loadWeatherData();
  }

  void _loadWeatherData() {
    currentWeather = WeatherService.getCurrentWeather();
    hourlyForecast = WeatherService.getHourlyForecast();
    dailyForecast = WeatherService.getDailyForecast();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedWeatherBackground(
        weatherCondition: 'time-based', 
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildCurrentWeather(),
                const SizedBox(height: 20),
                _buildWeatherDetails(),
                const SizedBox(height: 20),
                _buildHourlyForecast(),
                const SizedBox(height: 20),
                _buildDailyForecast(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentWeather() {
    return GlassCard(
      child: Column(
        children: [
          Text(
            currentWeather.city,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            DateFormat('EEEE, MMM d').format(DateTime.now()),
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                currentWeather.icon,
                style: const TextStyle(fontSize: 60),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${currentWeather.temperature.round()}°',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    currentWeather.description,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetails() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildDetailCard('UV Index', '${currentWeather.uvIndex}', Icons.wb_sunny),
        _buildDetailCard('Humidity', '${currentWeather.humidity}%', Icons.water_drop),
        _buildDetailCard('Real Feel', '${currentWeather.realFeel.round()}°', Icons.thermostat),
        _buildDetailCard('Wind', '${currentWeather.windSpeed} km/h ${currentWeather.windDirection}', Icons.air),
        _buildDetailCard('Sunrise', DateFormat('HH:mm').format(currentWeather.sunrise), Icons.wb_twilight),
        _buildDetailCard('Pressure', '${currentWeather.pressure} hPa', Icons.speed),
      ],
    );
  }

  Widget _buildDetailCard(String title, String value, IconData icon) {
    return GlassCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white.withOpacity(0.8), size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHourlyForecast() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8, bottom: 12),
          child: Text(
            '24-Hour Forecast',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: hourlyForecast.length,
            itemBuilder: (context, index) {
              final forecast = hourlyForecast[index];
              return Container(
                width: 80,
                margin: const EdgeInsets.only(right: 12),
                child: GlassCard(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('HH:mm').format(forecast.time),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        forecast.icon,
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${forecast.temperature.round()}°',
                        style: const TextStyle(
                          fontSize: 14,
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
        ),
      ],
    );
  }

  Widget _buildDailyForecast() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8, bottom: 12),
          child: Text(
            '7-Day Forecast',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: dailyForecast.length,
          itemBuilder: (context, index) {
            final forecast = dailyForecast[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: GlassCard(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        index == 0 ? 'Today' : DateFormat('EEE').format(forecast.date),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        forecast.icon,
                        style: const TextStyle(fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${forecast.humidity}%',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${forecast.maxTemp.round()}°/${forecast.minTemp.round()}°',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}