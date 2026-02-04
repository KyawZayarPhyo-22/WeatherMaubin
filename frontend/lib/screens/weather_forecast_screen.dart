import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
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
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _loadWeatherData();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black.withOpacity(0.4),
            Colors.grey.shade900.withOpacity(0.3),
            Colors.black.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentWeather.city.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('EEEE, MMM d').format(_myanmarTime),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 40),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${currentWeather.temperature.round()}',
                style: const TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                  height: 0.9,
                ),
              ),
              Text(
                '°C',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w300,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    currentWeather.description,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                          child: Icon(
                            _isNightTime() ? Icons.nights_stay : Icons.wb_sunny,
                            color: _isNightTime() ? Colors.indigo.shade300 : Colors.orange.shade300,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          Icons.access_time,
                          color: Colors.white.withOpacity(0.8),
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('HH:mm:ss').format(_myanmarTime),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildMinimalStat(
                    Icons.water_drop_outlined,
                    '${currentWeather.humidity}%',
                    'Humidity',
                  ),
                ),
                Container(
                  width: 1,
                  height: 32,
                  color: Colors.white.withOpacity(0.1),
                ),
                Expanded(
                  child: _buildMinimalStat(
                    Icons.air,
                    '${currentWeather.windSpeed} km/h',
                    'Wind',
                  ),
                ),
                Container(
                  width: 1,
                  height: 32,
                  color: Colors.white.withOpacity(0.1),
                ),
                Expanded(
                  child: _buildMinimalStat(
                    _isNightTime() ? Icons.nights_stay_outlined : Icons.wb_sunny_outlined,
                    '${currentWeather.uvIndex}',
                    'UV Index',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DateTime get _myanmarTime {
    return DateTime.now().toUtc().add(const Duration(hours: 6, minutes: 30));
  }

  bool _isNightTime() {
    final hour = _myanmarTime.hour;
    return hour < 6 || hour >= 18;
  }

  Widget _buildMinimalStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: Colors.white.withOpacity(0.5),
          ),
        ),
        const SizedBox(height: 6),
        Icon(
          icon,
          color: _getMinimalStatIconColor(icon),
          size: 18,
        ),
      ],
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
        _buildDetailCard(
          'UV Index',
          '${currentWeather.uvIndex}',
          _isNightTime() ? Icons.nights_stay : Icons.wb_sunny,
        ),
        _buildDetailCard(
          'Humidity',
          '${currentWeather.humidity}%',
          Icons.water_drop,
        ),
        _buildDetailCard(
          'Real Feel',
          '${currentWeather.realFeel.round()}°',
          Icons.thermostat,
        ),
        _buildDetailCard(
          'Wind',
          '${currentWeather.windSpeed} km/h ${currentWeather.windDirection}',
          Icons.air,
        ),
        _buildDetailCard(
          'Sunrise',
          DateFormat('HH:mm').format(currentWeather.sunrise),
          Icons.wb_twilight,
        ),
        _buildDetailCard(
          'Pressure',
          '${currentWeather.pressure} hPa',
          Icons.speed,
        ),
      ],
    );
  }

  Widget _buildDetailCard(String title, String value, IconData icon) {
    return GlassCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: _getIconColor(icon), size: 24),
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
                      Text(forecast.icon, style: const TextStyle(fontSize: 24)),
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
                        index == 0
                            ? 'Today'
                            : DateFormat('EEE').format(forecast.date),
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

  Color _getMinimalStatIconColor(IconData icon) {
    switch (icon) {
      case Icons.water_drop_outlined:
        return Colors.blue.shade300;
      case Icons.air:
        return Colors.green.shade300;
      case Icons.wb_sunny_outlined:
        return Colors.orange.shade300;
      case Icons.nights_stay_outlined:
        return Colors.indigo.shade300;
      default:
        return Colors.white.withOpacity(0.7);
    }
  }

  Color _getIconColor(IconData icon) {
    switch (icon) {
      case Icons.wb_sunny:
        return Colors.orange;
      case Icons.nights_stay:
        return Colors.indigo;
      case Icons.water_drop:
        return Colors.blue;
      case Icons.thermostat:
        return Colors.red;
      case Icons.air:
        return Colors.green;
      case Icons.wb_twilight:
        return Colors.amber;
      case Icons.speed:
        return Colors.purple;
      default:
        return Colors.white.withOpacity(0.8);
    }
  }
}
