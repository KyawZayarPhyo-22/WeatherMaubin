import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/admin_models.dart';
import '../services/admin_service.dart';
import '../main.dart';
import 'city_management_screen.dart';
import 'weather_control_screen.dart';
import 'alert_management_screen.dart';
import 'news_management_screen.dart';
import 'settings_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;
  late DashboardStats _stats;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _stats = AdminService.getDashboardStats();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0D47A1) : Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Weather Admin Panel'),
        backgroundColor: isDark ? const Color(0xFF1565C0) : Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.nights_stay,
            ),
            tooltip: Theme.of(context).brightness == Brightness.dark
                ? 'Switch to Light Mode'
                : 'Switch to Dark Blue Mode',
            onPressed: () {
              WeatherApp.of(context)?.toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() => _loadData());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data refreshed')),
              );
            },
          ),
        ],
      ),
      drawer: _buildMaterialDrawer(),
      body: _buildContent(),
    );
  }

  Widget _buildMaterialDrawer() {
    final menuItems = [
      {'icon': Icons.dashboard_outlined, 'selectedIcon': Icons.dashboard, 'label': 'Dashboard'},
      {'icon': Icons.location_city_outlined, 'selectedIcon': Icons.location_city, 'label': 'City Info'},
      {'icon': Icons.cloud_outlined, 'selectedIcon': Icons.cloud, 'label': 'Weather Control'},
      {'icon': Icons.warning_outlined, 'selectedIcon': Icons.warning, 'label': 'Alerts'},
      {'icon': Icons.article_outlined, 'selectedIcon': Icons.article, 'label': 'News Management'},
      {'icon': Icons.settings_outlined, 'selectedIcon': Icons.settings, 'label': 'Settings'},
    ];

    return NavigationDrawer(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (index) {
        setState(() => _selectedIndex = index);
        Navigator.pop(context);
      },
      children: [
        const DrawerHeader(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.admin_panel_settings, size: 48),
              SizedBox(height: 8),
              Text(
                'Admin Panel',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text('Weather Management'),
            ],
          ),
        ),
        ...menuItems.map((item) {
          return NavigationDrawerDestination(
            icon: Icon(item['icon'] as IconData),
            selectedIcon: Icon(item['selectedIcon'] as IconData),
            label: Text(item['label'] as String),
          );
        }),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Logout'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboard();
      case 1:
        return const CityManagementScreen();
      case 2:
        return const WeatherControlScreen();
      case 3:
        return const AlertManagementScreen();
      case 4:
        return const NewsManagementScreen();
      case 5:
        return const SettingsScreen();
      default:
        return _buildDashboard();
    }
  }

  Widget _buildDashboard() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    
    return SingleChildScrollView(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weather Dashboard',
            style: TextStyle(
              fontSize: isSmallScreen ? 20 : 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isSmallScreen ? 2 : 4,
            mainAxisSpacing: isSmallScreen ? 8 : 12,
            crossAxisSpacing: isSmallScreen ? 8 : 12,
            childAspectRatio: isSmallScreen ? 1.2 : 1.5,
            children: [
              _buildStatCard('Temperature', '${_stats.totalUsers}°C', Icons.thermostat, Colors.red, isSmallScreen),
              _buildStatCard('Humidity', '${_stats.activeAlerts}%', Icons.water_drop, Colors.blue, isSmallScreen),
              _buildStatCard('Wind Speed', '${_stats.apiStatus} km/h', Icons.air, Colors.green, isSmallScreen),
              _buildStatCard('Pressure', '${_stats.subscriberCount} hPa', Icons.speed, Colors.purple, isSmallScreen),
            ],
          ),
          
          SizedBox(height: isSmallScreen ? 16 : 24),
          
          if (isSmallScreen) 
            ..._buildMobileCharts() 
          else 
            ..._buildDesktopCharts(),
        ],
      ),
    );
  }

  List<Widget> _buildMobileCharts() {
    return [
      _buildLineChart(true),
      const SizedBox(height: 16),
      _buildRiverLevelChart(true),
    ];
  }

  List<Widget> _buildDesktopCharts() {
    return [
      Row(
        children: [
          Expanded(child: _buildLineChart(false)),
          const SizedBox(width: 16),
          Expanded(child: _buildRiverLevelChart(false)),
        ],
      ),
    ];
  }

  Widget _buildLineChart(bool isSmallScreen) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weather Data Trends',
              style: TextStyle(
                fontSize: isSmallScreen ? 16 : 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: isSmallScreen ? 12 : 16),
            SizedBox(
              height: isSmallScreen ? 200 : 250,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) => Text(
                          '${value.toInt()}°',
                          style: TextStyle(fontSize: isSmallScreen ? 10 : 12),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) => Text(
                          '${value.toInt()}h',
                          style: TextStyle(fontSize: isSmallScreen ? 10 : 12),
                        ),
                      ),
                    ),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        const FlSpot(0, 20),
                        const FlSpot(2, 22),
                        const FlSpot(4, 24),
                        const FlSpot(6, 26),
                        const FlSpot(8, 25),
                        const FlSpot(10, 23),
                        const FlSpot(12, 21),
                      ],
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRiverLevelChart(bool isSmallScreen) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'River Level Monitoring',
              style: TextStyle(
                fontSize: isSmallScreen ? 16 : 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: isSmallScreen ? 12 : 16),
            SizedBox(
              height: isSmallScreen ? 200 : 250,
              child: BarChart(
                BarChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) => Text(
                          '${value.toInt()}m',
                          style: TextStyle(fontSize: isSmallScreen ? 10 : 12),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) => Text(
                          'Day ${value.toInt() + 1}',
                          style: TextStyle(fontSize: isSmallScreen ? 9 : 11),
                        ),
                      ),
                    ),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: true),
                  barGroups: [
                    BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 2.1, color: Colors.teal, width: isSmallScreen ? 16 : 20)]),
                    BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 2.3, color: Colors.teal, width: isSmallScreen ? 16 : 20)]),
                    BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 2.8, color: Colors.teal, width: isSmallScreen ? 16 : 20)]),
                    BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 3.2, color: Colors.teal, width: isSmallScreen ? 16 : 20)]),
                    BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 2.9, color: Colors.teal, width: isSmallScreen ? 16 : 20)]),
                    BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 2.5, color: Colors.teal, width: isSmallScreen ? 16 : 20)]),
                    BarChartGroupData(x: 6, barRods: [BarChartRodData(toY: 2.2, color: Colors.teal, width: isSmallScreen ? 16 : 20)]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, bool isSmallScreen) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: isSmallScreen ? 24 : 32, color: color),
            SizedBox(height: isSmallScreen ? 8 : 12),
            Text(value, style: TextStyle(fontSize: isSmallScreen ? 18 : 24, fontWeight: FontWeight.bold)),
            SizedBox(height: isSmallScreen ? 4 : 8),
            Text(title, style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }


}