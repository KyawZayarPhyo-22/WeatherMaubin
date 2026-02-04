import 'package:flutter/material.dart';
import 'dart:math';

class AnimatedWeatherBackground extends StatefulWidget {
  final String weatherCondition;
  final Widget child;

  const AnimatedWeatherBackground({
    super.key,
    required this.weatherCondition,
    required this.child,
  });

  @override
  State<AnimatedWeatherBackground> createState() =>
      _AnimatedWeatherBackgroundState();
}

class _AnimatedWeatherBackgroundState extends State<AnimatedWeatherBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getTimeOfDay() {
    final hour = DateTime.now().hour;
    if (hour >= 6 && hour < 12) return 'morning';
    if (hour >= 12 && hour < 17) return 'afternoon';
    if (hour >= 17 && hour < 21) return 'evening';
    return 'night';
  }

  @override
  Widget build(BuildContext context) {
    final timeOfDay = _getTimeOfDay();

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(gradient: _getGradientForTime(timeOfDay)),
          child: Stack(
            children: [_buildTimeBasedElements(timeOfDay), widget.child],
          ),
        );
      },
    );
  }

  LinearGradient _getGradientForTime(String timeOfDay) {
    switch (timeOfDay) {
      case 'morning':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF87CEEB), Color(0xFFB0E0E6)], // Sky blue
        );
      case 'afternoon':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0080FF), Color(0xFFFFD700)], // Blue and yellow
        );
      case 'evening':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1E3C72),
            Color(0xFFFF6B35),
          ], // Blue and sunset orange
        );
      case 'night':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 73, 72, 72),
            Color.fromARGB(255, 63, 59, 59),
          ], // White and dark
        );
      default:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0080FF), Color(0xFFFFD700)],
        );
    }
  }

  Widget _buildTimeBasedElements(String timeOfDay) {
    switch (timeOfDay) {
      case 'morning':
        return _buildMorningElements();
      case 'afternoon':
        return _buildAfternoonElements();
      case 'evening':
        return _buildEveningElements();
      case 'night':
        return _buildNightElements();
      default:
        return _buildAfternoonElements();
    }
  }

  Widget _buildMorningElements() {
    return Stack(
      children: [
        // Morning clouds - light and fluffy
        Positioned(
          top: 80 + (_animation.value * 15),
          left: 30 + (_animation.value * 20),
          child: Image.asset(
            'assets/images/morning,afternoon.png',
            width: 80,
            height: 40,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        Positioned(
          top: 120 + (_animation.value * 10),
          right: 60 + (_animation.value * 25),
          child: Image.asset(
            'assets/images/morning,afternoon.png',
            width: 60,
            height: 30,
            color: Colors.white.withOpacity(0.5),
          ),
        ),
        // Gentle floating particles
        ...List.generate(6, (index) {
          return Positioned(
            top: 100 + (index * 60.0) + (_animation.value * 10),
            left: 50 + (index * 50.0) % 300,
            child: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildAfternoonElements() {
    return Stack(
      children: [
        // Moving sun to the right
        Positioned(
          top: 60,
          right: 50 + (_animation.value * 100), // Moves from right to left
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.yellow,
                  Colors.orange.withOpacity(0.8),
                  Colors.orange.withOpacity(0.3),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.yellow.withOpacity(0.4),
                  blurRadius: 25,
                  spreadRadius: 8,
                ),
              ],
            ),
          ),
        ),
        // Sun rays
        Positioned(
          top: 60,
          right: 50 + (_animation.value * 100),
          child: Transform.rotate(
            angle: _animation.value * 0.5,
            child: Container(
              width: 100,
              height: 100,
              child: CustomPaint(painter: SunRaysPainter()),
            ),
          ),
        ),
        // Afternoon clouds - bright white
        Positioned(
          top: 100 + (_animation.value * 12),
          left: 40 + (_animation.value * 30),
          child: Image.asset(
            'assets/images/morning,afternoon.png',
            width: 90,
            height: 45,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
        Positioned(
          top: 140 + (_animation.value * 8),
          right: 80 + (_animation.value * 20),
          child: Image.asset(
            'assets/images/morning,afternoon.png',
            width: 70,
            height: 35,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
        // Floating dots
        ...List.generate(4, (index) {
          return Positioned(
            top: 120 + (index * 80.0),
            left: 40 + (index * 70.0) % 250 + (_animation.value * 15),
            child: Container(
              width: 3,
              height: 3,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildEveningElements() {
    return Stack(
      children: [
        // Warm glow effect
        Positioned(
          bottom: 0,
          right: 40,
          child: Container(
            width: 120 + (_animation.value * 20),
            height: 120 + (_animation.value * 20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.orange.withOpacity(0.2),
            ),
          ),
        ),
        // Evening clouds - orange tinted
        Positioned(
          top: 90 + (_animation.value * 10),
          left: 50 + (_animation.value * 15),
          child: Image.asset(
            'assets/images/evening.jpg',
            width: 85,
            height: 42,
            color: Colors.orange.withOpacity(0.4),
          ),
        ),
        Positioned(
          top: 130 + (_animation.value * 12),
          right: 70 + (_animation.value * 18),
          child: Image.asset(
            'assets/images/evening.jpg',
            width: 65,
            height: 32,
            color: Colors.pink.withOpacity(0.3),
          ),
        ),
        // Gentle particles
        ...List.generate(5, (index) {
          return Positioned(
            top: 150 + (index * 50.0) + (_animation.value * 8),
            right: 60 + (index * 40.0) % 200,
            child: Container(
              width: 2,
              height: 2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.orange.withOpacity(0.7),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildNightElements() {
    return Stack(
      children: [
        // Soft moon glow
        Positioned(
          top: 60,
          right: 50,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.4),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.2),
                  blurRadius: 15,
                  spreadRadius: 3,
                ),
              ],
            ),
          ),
        ),
        // Night clouds - dark silhouettes
        Positioned(
          top: 110 + (_animation.value * 8),
          left: 40 + (_animation.value * 12),
          child: Image.asset(
            'assets/images/Choud2.png',
            width: 150,
            height: 38,
            color: Colors.white.withOpacity(0.4),
          ),
        ),
        Positioned(
          top: 90 + (_animation.value * 6),
          right: 75 + (_animation.value * 15),
          child: Image.asset(
            'assets/images/Choud2.png',
            fit: BoxFit.cover,
            width: 80,
            height: 28,
            color: Colors.white.withOpacity(0.4),
          ),
        ),
        Positioned(
          top: 150 + (_animation.value * 6),
          right: 120 + (_animation.value * 15),
          child: Image.asset(
            'assets/images/Choud2.png',
            fit: BoxFit.cover,
            width: 80,
            height: 28,
            color: Colors.grey.withOpacity(0.4),
          ),
        ),
        // Twinkling stars
        ...List.generate(8, (index) {
          return Positioned(
            top: 80 + (index * 40.0),
            left: 30 + (index * 45.0) % 280,
            child: AnimatedOpacity(
              opacity: 0.3 + (_animation.value * 0.4),
              duration: const Duration(milliseconds: 500),
              child: Container(
                width: 2,
                height: 2,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

class SunRaysPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.yellow.withOpacity(0.6)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 3;

    for (int i = 0; i < 8; i++) {
      final angle = (i * 45) * (3.14159 / 180);
      final start = Offset(
        center.dx + radius * 0.8 * cos(angle),
        center.dy + radius * 0.8 * sin(angle),
      );
      final end = Offset(
        center.dx + radius * 1.2 * cos(angle),
        center.dy + radius * 1.2 * sin(angle),
      );
      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
