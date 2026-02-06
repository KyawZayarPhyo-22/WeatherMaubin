import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import '../widgets/animated_weather_background.dart';
import '../widgets/glass_card.dart';

class WaterLevelForecastScreen extends StatefulWidget {
  const WaterLevelForecastScreen({super.key});

  @override
  State<WaterLevelForecastScreen> createState() => _WaterLevelForecastScreenState();
}

class _WaterLevelForecastScreenState extends State<WaterLevelForecastScreen>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late Animation<double> _waveAnimation;
  
  // Sample water level data
  final List<WaterLevelData> waterLevels = [
    WaterLevelData(DateTime.now().subtract(const Duration(hours: 6)), 2.5, WaterStatus.normal),
    WaterLevelData(DateTime.now().subtract(const Duration(hours: 5)), 2.8, WaterStatus.normal),
    WaterLevelData(DateTime.now().subtract(const Duration(hours: 4)), 3.2, WaterStatus.warning),
    WaterLevelData(DateTime.now().subtract(const Duration(hours: 3)), 3.8, WaterStatus.warning),
    WaterLevelData(DateTime.now().subtract(const Duration(hours: 2)), 4.2, WaterStatus.danger),
    WaterLevelData(DateTime.now().subtract(const Duration(hours: 1)), 4.5, WaterStatus.danger),
    WaterLevelData(DateTime.now(), 4.1, WaterStatus.warning),
  ];

  // Sample 7-day forecast data
  final List<DailyForecast> dailyForecast = [
    DailyForecast(DateTime.now(), 4.1, 3.8, WaterStatus.warning),
    DailyForecast(DateTime.now().add(const Duration(days: 1)), 3.9, 3.5, WaterStatus.warning),
    DailyForecast(DateTime.now().add(const Duration(days: 2)), 3.2, 2.8, WaterStatus.normal),
    DailyForecast(DateTime.now().add(const Duration(days: 3)), 2.9, 2.5, WaterStatus.normal),
    DailyForecast(DateTime.now().add(const Duration(days: 4)), 3.4, 3.0, WaterStatus.warning),
    DailyForecast(DateTime.now().add(const Duration(days: 5)), 4.3, 3.9, WaterStatus.danger),
    DailyForecast(DateTime.now().add(const Duration(days: 6)), 4.0, 3.6, WaterStatus.warning),
  ];

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    _waveAnimation = Tween<double>(begin: 0, end: 1).animate(_waveController);
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedWeatherBackground(
        weatherCondition: 'time-based',
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildStatusCards(),
                      const SizedBox(height: 16),
                      _buildCurrentWaterLevel(),
                      const SizedBox(height: 16),
                      _buildWaterLevelChart(),
                      const SizedBox(height: 16),
                      _build7DayForecast(),
                    ],
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
      child: GlassCard(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'WATER LEVEL',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              DateFormat('MMM d, HH:mm').format(DateTime.now()),
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

  Widget _buildCurrentWaterLevel() {
    final currentLevel = waterLevels.last;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Level',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${currentLevel.level.toStringAsFixed(1)}m',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _getStatusColor(currentLevel.status),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: _getStatusColor(currentLevel.status).withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  _getStatusText(currentLevel.status),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blue.shade100.withOpacity(0.1),
                  Colors.blue.shade900.withOpacity(0.3),
                ],
              ),
              border: Border.all(
                color: Colors.blue.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Stack(
              children: [
                // Height markers on the left
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width: 50,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.1),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                    ),
                    child: Stack(
                      children: [
                        for (int i = 0; i <= 7; i++)
                          Positioned(
                            bottom: (i / 7.0 * 160) + 20,
                            left: 8,
                            child: Text(
                              '${i}m',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                // Water animation area
                Positioned(
                  left: 50,
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    child: Stack(
                      children: [
                        // Grid lines
                        Positioned.fill(
                          child: CustomPaint(
                            painter: HeightMarkerPainter(),
                          ),
                        ),
                        // Water animation
                        AnimatedBuilder(
                          animation: _waveAnimation,
                          builder: (context, child) {
                            return CustomPaint(
                              painter: WavePainter(_waveAnimation.value, currentLevel.level / 7.0),
                              size: const Size(double.infinity, 200),
                            );
                          },
                        ),
                        // River name overlay
                        Positioned(
                          bottom: 16,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Maubin River',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaterLevelChart() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '24-Hour Trend',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              // Y-axis labels
              Container(
                width: 30,
                height: 200,
                child: Stack(
                  children: [
                    for (int i = 0; i <= 5; i++)
                      Positioned(
                        bottom: (i / 5.0 * 180) + 5,
                        left: 0,
                        child: Text(
                          '${i}m',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Chart area
              Expanded(
                child: GestureDetector(
                  onPanUpdate: (details) {
                    _showChartTooltip(details.localPosition);
                  },
                  onTapDown: (details) {
                    _showChartTooltip(details.localPosition);
                  },
                  child: SizedBox(
                    height: 200,
                    child: CustomPaint(
                      painter: WaterLevelChartPainter(waterLevels),
                      size: const Size(double.infinity, 200),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '6h ago',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
              Text(
                'Now',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showChartTooltip(Offset position) {
    final stepX = (MediaQuery.of(context).size.width - 100) / (waterLevels.length - 1);
    final index = (position.dx / stepX).round().clamp(0, waterLevels.length - 1);
    final data = waterLevels[index];
    
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.water_drop, color: _getStatusColor(data.status), size: 16),
            const SizedBox(width: 8),
            Text(
              '${DateFormat('HH:mm').format(data.time)} • ${data.level.toStringAsFixed(1)}m • ${_getStatusText(data.status)}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
        backgroundColor: _getStatusColor(data.status),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildStatusCards() {
    final currentLevel = waterLevels.last;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Status Overview',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(currentLevel.status),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: _getStatusColor(currentLevel.status).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  _getStatusText(currentLevel.status),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildModernStatusCard('Normal', '< 3.0m', Colors.green, currentLevel.status == WaterStatus.normal),
              const SizedBox(width: 12),
              _buildModernStatusCard('Warning', '3.0-4.0m', Colors.orange, currentLevel.status == WaterStatus.warning),
              const SizedBox(width: 12),
              _buildModernStatusCard('Danger', '> 4.0m', Colors.red, currentLevel.status == WaterStatus.danger),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModernStatusCard(String title, String range, Color color, bool isActive) {
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: isActive
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [color.withOpacity(0.3), color.withOpacity(0.1)],
                )
              : LinearGradient(
                  colors: [Colors.white.withOpacity(0.08), Colors.white.withOpacity(0.03)],
                ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive ? color.withOpacity(0.6) : Colors.white.withOpacity(0.1),
            width: isActive ? 2 : 1,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : Colors.white.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              range,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: isActive ? Colors.white.withOpacity(0.9) : Colors.white.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _build7DayForecast() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '7-Day Forecast',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: dailyForecast.map((forecast) {
              final isToday = DateFormat('yyyy-MM-dd').format(forecast.date) == 
                             DateFormat('yyyy-MM-dd').format(DateTime.now());
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isToday 
                      ? Colors.white.withOpacity(0.15)
                      : Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isToday 
                        ? Colors.white.withOpacity(0.3)
                        : Colors.white.withOpacity(0.1),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        isToday ? 'Today' : DateFormat('EEE, MMM d').format(forecast.date),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isToday ? FontWeight.w600 : FontWeight.w500,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _getStatusColor(forecast.status),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${forecast.minLevel.toStringAsFixed(1)}m',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            _getStatusColor(forecast.status).withOpacity(0.3),
                            _getStatusColor(forecast.status),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${forecast.maxLevel.toStringAsFixed(1)}m',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(WaterStatus status) {
    switch (status) {
      case WaterStatus.normal:
        return Colors.green;
      case WaterStatus.warning:
        return Colors.orange;
      case WaterStatus.danger:
        return Colors.red;
    }
  }

  String _getStatusText(WaterStatus status) {
    switch (status) {
      case WaterStatus.normal:
        return 'NORMAL';
      case WaterStatus.warning:
        return 'WARNING';
      case WaterStatus.danger:
        return 'DANGER';
    }
  }
}

class WaterLevelData {
  final DateTime time;
  final double level;
  final WaterStatus status;

  WaterLevelData(this.time, this.level, this.status);
}

class DailyForecast {
  final DateTime date;
  final double maxLevel;
  final double minLevel;
  final WaterStatus status;

  DailyForecast(this.date, this.maxLevel, this.minLevel, this.status);
}

enum WaterStatus { normal, warning, danger }

class WavePainter extends CustomPainter {
  final double animationValue;
  final double waterLevel;

  WavePainter(this.animationValue, this.waterLevel);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.blue.shade300.withOpacity(0.8),
          Colors.blue.shade600.withOpacity(0.9),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path();
    final waveHeight = 8.0;
    final waveLength = size.width / 3;
    final waterY = size.height * (1 - waterLevel);

    path.moveTo(0, size.height);
    path.lineTo(0, waterY);
    
    for (double x = 0; x <= size.width; x += 2) {
      final wave1 = waveHeight * math.sin((x / waveLength * 2 * math.pi) + (animationValue * 4 * math.pi));
      final wave2 = waveHeight * 0.5 * math.sin((x / (waveLength * 0.7) * 2 * math.pi) + (animationValue * 3 * math.pi));
      final y = waterY + wave1 + wave2;
      path.lineTo(x, y);
    }
    
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);

    // Add surface shimmer effect
    final shimmerPaint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final shimmerPath = Path();
    for (double x = 0; x <= size.width; x += 3) {
      final wave = waveHeight * 0.3 * math.sin((x / waveLength * 2 * math.pi) + (animationValue * 5 * math.pi));
      final y = waterY + wave;
      if (x == 0) {
        shimmerPath.moveTo(x, y);
      } else {
        shimmerPath.lineTo(x, y);
      }
    }
    canvas.drawPath(shimmerPath, shimmerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class HeightMarkerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 1;

    // Draw height markers every meter (0m to 7m)
    for (int i = 0; i <= 7; i++) {
      final y = size.height - (i / 7.0 * size.height);
      
      // Draw horizontal line only
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class WaterLevelChartPainter extends CustomPainter {
  final List<WaterLevelData> data;

  WaterLevelChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    final maxLevel = 5.0;
    final stepX = size.width / (data.length - 1);

    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      final y = size.height - (data[i].level / maxLevel * size.height);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }

      // Draw data points
      final pointPaint = Paint()
        ..color = _getStatusColor(data[i].status)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(Offset(x, y), 4, pointPaint);
    }

    canvas.drawPath(path, paint);

    // Draw grid lines
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..strokeWidth = 1;

    for (int i = 0; i <= 5; i++) {
      final y = (size.height / 5) * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  Color _getStatusColor(WaterStatus status) {
    switch (status) {
      case WaterStatus.normal:
        return Colors.green;
      case WaterStatus.warning:
        return Colors.orange;
      case WaterStatus.danger:
        return Colors.red;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}