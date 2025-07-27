import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/connection_status_widget.dart';
import './widgets/device_list_widget.dart';
import './widgets/device_pairing_dialog.dart';

class IoTHub extends StatefulWidget {
  const IoTHub({Key? key}) : super(key: key);

  @override
  State<IoTHub> createState() => _IoTHubState();
}

class _IoTHubState extends State<IoTHub> with TickerProviderStateMixin {
  int _currentIndex = 1; // IoT Hub is at index 1
  bool _isConnected = true;
  bool _isMultiSelectMode = false;
  List<String> _selectedDevices = [];

  // Mock IoT device data
  final List<Map<String, dynamic>> _devices = [
    {
      "id": "ph_001",
      "name": "Field A pH Sensor",
      "type": "Soil pH Sensor",
      "batteryLevel": 85,
      "signalStrength": 92,
      "primaryValue": 6.8,
      "primaryUnit": "pH",
      "isOnline": true,
      "lastUpdate": "2 mins ago",
      "location": "North Field Section A",
      "historicalData": [6.5, 6.7, 6.8, 6.9, 6.8, 6.7, 6.8],
    },
    {
      "id": "moisture_001",
      "name": "Irrigation Zone 1",
      "type": "Moisture Sensor",
      "batteryLevel": 67,
      "signalStrength": 78,
      "primaryValue": 45.2,
      "primaryUnit": "%",
      "isOnline": true,
      "lastUpdate": "1 min ago",
      "location": "South Field Zone 1",
      "historicalData": [42.1, 43.5, 44.8, 45.2, 46.1, 45.8, 45.2],
    },
    {
      "id": "weather_001",
      "name": "Main Weather Station",
      "type": "Weather Station",
      "batteryLevel": 92,
      "signalStrength": 95,
      "primaryValue": 24.5,
      "primaryUnit": "°C",
      "isOnline": true,
      "lastUpdate": "30 secs ago",
      "location": "Central Farm Area",
      "historicalData": [23.2, 23.8, 24.1, 24.5, 24.8, 24.6, 24.5],
    },
    {
      "id": "camera_001",
      "name": "Cam for rodents",
      "type": "Camera",
      "batteryLevel": 34,
      "signalStrength": 65,
      "primaryValue": 0.0,
      "primaryUnit": "p",
      "isOnline": false,
      "lastUpdate": "15 mins ago",
      "location": "East Field Monitoring",
      "historicalData": [1080, 1080, 720, 1080, 1080, 1080, 1080],
    },
    {
      "id": "actuator_001",
      "name": "Sprinkler Controller",
      "type": "Actuator",
      "batteryLevel": 78,
      "signalStrength": 88,
      "primaryValue": 0.0,
      "primaryUnit": "L/min",
      "isOnline": true,
      "lastUpdate": "5 mins ago",
      "location": "West Irrigation System",
      "historicalData": [0, 15.5, 12.3, 0, 18.2, 0, 0],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // Sticky header with connection status
          ConnectionStatusWidget(
            isConnected: _isConnected,
            connectedDevices:
                _devices.where((device) => device['isOnline'] as bool).length,
            onAddDevice: _showDevicePairingDialog,
          ),
          // Main content
          Expanded(
            child: DeviceListWidget(
              devices: _devices,
              onRefresh: _refreshDevices,
              onDeviceCalibrate: _calibrateDevice,
              onDeviceRename: _renameDevice,
              onDeviceSetAlerts: _setDeviceAlerts,
              onDeviceDisconnect: _disconnectDevice,
            ),
          ),
        ],
      ),
      // Floating action button for device pairing
      floatingActionButton: _isConnected
          ? FloatingActionButton(
              onPressed: _showDevicePairingDialog,
              child: CustomIconWidget(
                iconName: 'add',
                color: AppTheme
                        .lightTheme.floatingActionButtonTheme.foregroundColor ??
                    Colors.black,
                size: 6.w,
              ),
              tooltip: 'Add Device',
            )
          : null,
      // Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor:
            AppTheme.lightTheme.bottomNavigationBarTheme.backgroundColor,
        selectedItemColor:
            AppTheme.lightTheme.bottomNavigationBarTheme.selectedItemColor,
        unselectedItemColor:
            AppTheme.lightTheme.bottomNavigationBarTheme.unselectedItemColor,
        elevation:
            AppTheme.lightTheme.bottomNavigationBarTheme.elevation ?? 8.0,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'dashboard',
              color: _currentIndex == 0
                  ? AppTheme.lightTheme.bottomNavigationBarTheme
                          .selectedItemColor ??
                      AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.bottomNavigationBarTheme
                          .unselectedItemColor ??
                      AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.6),
              size: 5.w,
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'device_hub',
              color: _currentIndex == 1
                  ? AppTheme.lightTheme.bottomNavigationBarTheme
                          .selectedItemColor ??
                      AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.bottomNavigationBarTheme
                          .unselectedItemColor ??
                      AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.6),
              size: 5.w,
            ),
            label: 'IoT Hub',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'task_alt',
              color: _currentIndex == 2
                  ? AppTheme.lightTheme.bottomNavigationBarTheme
                          .selectedItemColor ??
                      AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.bottomNavigationBarTheme
                          .unselectedItemColor ??
                      AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.6),
              size: 5.w,
            ),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'cloud',
              color: _currentIndex == 3
                  ? AppTheme.lightTheme.bottomNavigationBarTheme
                          .selectedItemColor ??
                      AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.bottomNavigationBarTheme
                          .unselectedItemColor ??
                      AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.6),
              size: 5.w,
            ),
            label: 'Weather',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'settings',
              color: _currentIndex == 4
                  ? AppTheme.lightTheme.bottomNavigationBarTheme
                          .selectedItemColor ??
                      AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.bottomNavigationBarTheme
                          .unselectedItemColor ??
                      AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.6),
              size: 5.w,
            ),
            label: 'Control',
          ),
        ],
      ),
    );
  }

  void _onBottomNavTap(int index) {
    if (index == _currentIndex) return;

    setState(() {
      _currentIndex = index;
    });

    // Navigate to different screens based on index
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/farm-dashboard');
        break;
      case 1:
        // Already on IoT Hub
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/task-management');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/weather-details');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/device-control-panel');
        break;
    }
  }

  void _refreshDevices() {
    setState(() {
      // Simulate refresh by updating connection status
      _isConnected = true;
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Devices refreshed successfully'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showDevicePairingDialog() {
    showDialog(
      context: context,
      builder: (context) => DevicePairingDialog(
        onQRScan: _startQRScanning,
        onManualEntry: _addDeviceManually,
      ),
    );
  }

  void _startQRScanning() {
    // Simulate QR scanning process
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('QR Scanner opened - Point camera at device QR code'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _addDeviceManually() {
    // Simulate manual device addition
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Device added successfully'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _calibrateDevice(Map<String, dynamic> device) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Calibrate Device'),
        content: Text(
            'Starting calibration for ${device['name']}. This may take a few minutes.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Calibration started for ${device['name']}'),
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                ),
              );
            },
            child: Text('Start'),
          ),
        ],
      ),
    );
  }

  void _renameDevice(Map<String, dynamic> device) {
    final TextEditingController controller =
        TextEditingController(text: device['name']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Rename Device'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'Device Name',
            hintText: 'Enter new name',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  device['name'] = controller.text;
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Device renamed successfully'),
                    backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                  ),
                );
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _setDeviceAlerts(Map<String, dynamic> device) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Set Alerts'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Configure alerts for ${device['name']}'),
            SizedBox(height: 2.h),
            SwitchListTile(
              title: Text('Low Battery Alert'),
              subtitle: Text('Alert when battery < 20%'),
              value: true,
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: Text('Connection Lost Alert'),
              subtitle: Text('Alert when device goes offline'),
              value: true,
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: Text('Value Out of Range'),
              subtitle: Text('Alert for abnormal readings'),
              value: false,
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Alert settings saved'),
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                ),
              );
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _disconnectDevice(Map<String, dynamic> device) {
    setState(() {
      _devices.removeWhere((d) => d['id'] == device['id']);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${device['name']} disconnected'),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              _devices.add(device);
            });
          },
        ),
      ),
    );
  }
}
