import 'package:flutter/material.dart';
import '../models/admin_models.dart';
import '../services/admin_service.dart';

class AlertManagementScreen extends StatefulWidget {
  const AlertManagementScreen({super.key});

  @override
  State<AlertManagementScreen> createState() => _AlertManagementScreenState();
}

class _AlertManagementScreenState extends State<AlertManagementScreen> {
  List<WeatherAlert> _alerts = [];

  @override
  void initState() {
    super.initState();
    _loadAlerts();
  }

  void _loadAlerts() {
    setState(() {
      _alerts = AdminService.getActiveAlerts();
    });
  }

  void _showCreateAlertDialog() {
    final titleController = TextEditingController();
    final messageController = TextEditingController();
    String selectedSeverity = 'Medium';
    String selectedType = 'Weather Warning';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Create New Alert'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Alert Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Alert Type',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Weather Warning', 'Flood Alert', 'Storm Warning', 'Heat Advisory']
                      .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                      .toList(),
                  onChanged: (value) => setDialogState(() => selectedType = value!),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedSeverity,
                  decoration: const InputDecoration(
                    labelText: 'Severity',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Low', 'Medium', 'High', 'Critical']
                      .map((severity) => DropdownMenuItem(value: severity, child: Text(severity)))
                      .toList(),
                  onChanged: (value) => setDialogState(() => selectedSeverity = value!),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: messageController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Alert Message',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty && messageController.text.isNotEmpty) {
                  _createAlert(selectedType, selectedSeverity, titleController.text, messageController.text);
                  Navigator.pop(context);
                }
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  void _createAlert(String type, String severity, String title, String message) {
    final AlertSeverity alertSeverity;
    switch (severity.toLowerCase()) {
      case 'low': alertSeverity = AlertSeverity.low; break;
      case 'high': alertSeverity = AlertSeverity.high; break;
      default: alertSeverity = AlertSeverity.medium;
    }
    
    final now = DateTime.now();
    final newAlert = WeatherAlert(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: type,
      messageEn: message,
      messageMy: message,
      severity: alertSeverity,
      startTime: now,
      endTime: now.add(const Duration(hours: 24)),
      pushEnabled: true,
      isActive: true,
    );
    
    setState(() {
      _alerts.insert(0, newAlert);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Alert "$title" created successfully')),
    );
  }

  void _deleteAlert(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Alert'),
        content: const Text('Are you sure you want to delete this alert?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _alerts.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Alert deleted successfully')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _toggleAlert(int index) {
    setState(() {
      _alerts[index] = WeatherAlert(
        id: _alerts[index].id,
        type: _alerts[index].type,
        messageEn: _alerts[index].messageEn,
        messageMy: _alerts[index].messageMy,
        severity: _alerts[index].severity,
        startTime: _alerts[index].startTime,
        endTime: _alerts[index].endTime,
        pushEnabled: _alerts[index].pushEnabled,
        isActive: !_alerts[index].isActive,
      );
    });
  }

  Color _getSeverityColor(AlertSeverity severity) {
    switch (severity) {
      case AlertSeverity.high: return Colors.red;
      case AlertSeverity.medium: return Colors.orange;
      case AlertSeverity.low: return Colors.yellow.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    
    return SingleChildScrollView(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Alert Management',
                style: TextStyle(
                  fontSize: isSmallScreen ? 18 : 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                onPressed: _showCreateAlertDialog,
                icon: const Icon(Icons.add),
                label: Text(isSmallScreen ? 'Add' : 'Create Alert'),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          
          if (_alerts.isEmpty)
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Icon(Icons.warning_amber_outlined, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'No alerts created yet',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create your first alert to get started',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                ],
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _alerts.length,
              separatorBuilder: (context, index) => SizedBox(height: isSmallScreen ? 8 : 12),
              itemBuilder: (context, index) => _buildAlertCard(_alerts[index], index, isSmallScreen),
            ),
        ],
      ),
    );
  }

  Widget _buildAlertCard(WeatherAlert alert, int index, bool isSmallScreen) {
    final severityColor = _getSeverityColor(alert.severity);
    
    return Card(
      elevation: 2,
      child: Container(
        padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border(left: BorderSide(color: severityColor, width: 4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            alert.type,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 14 : 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isSmallScreen ? 6 : 8,
                              vertical: isSmallScreen ? 2 : 4,
                            ),
                            decoration: BoxDecoration(
                              color: severityColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              alert.severity.name.toUpperCase(),
                              style: TextStyle(
                                fontSize: isSmallScreen ? 10 : 12,
                                color: severityColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isSmallScreen ? 6 : 8,
                              vertical: isSmallScreen ? 2 : 4,
                            ),
                            decoration: BoxDecoration(
                              color: alert.isActive ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              alert.isActive ? 'Active' : 'Inactive',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 10 : 12,
                                color: alert.isActive ? Colors.green : Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isSmallScreen ? 4 : 8),
                      Text(
                        alert.messageEn,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 12 : 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton(
                  icon: Icon(
                    Icons.more_vert,
                    size: isSmallScreen ? 20 : 24,
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      onTap: () => _toggleAlert(index),
                      child: Row(
                        children: [
                          Icon(alert.isActive ? Icons.pause : Icons.play_arrow, size: 16),
                          const SizedBox(width: 8),
                          Text(alert.isActive ? 'Deactivate' : 'Activate'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () => _deleteAlert(index),
                      child: const Row(
                        children: [
                          Icon(Icons.delete, size: 16, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}