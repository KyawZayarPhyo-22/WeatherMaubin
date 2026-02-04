import 'package:flutter/material.dart';

class CityManagementScreen extends StatelessWidget {
  const CityManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    
    return SingleChildScrollView(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'City Management',
            style: TextStyle(
              fontSize: isSmallScreen ? 18 : 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          _buildCityCard('Maubin', 'Active', isSmallScreen),
          SizedBox(height: isSmallScreen ? 8 : 12),
          _buildCityCard('Yangon', 'Inactive', isSmallScreen),
        ],
      ),
    );
  }

  Widget _buildCityCard(String city, String status, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  city,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Status: $status',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 12 : 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Icon(
            status == 'Active' ? Icons.check_circle : Icons.cancel,
            color: status == 'Active' ? Colors.green : Colors.red,
            size: isSmallScreen ? 20 : 24,
          ),
        ],
      ),
    );
  }
}